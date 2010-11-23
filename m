Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0KWJ0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:26:21 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55435 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0KWJ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:26:19 -0500
Date: Tue, 23 Nov 2010 19:56:09 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@vger.kernel.org>
Subject: Re: [RFC][PATCH] Cross Memory Attach v2 (resend)
Message-ID: <20101123195609.1e32dd0c@lilo>
In-Reply-To: <xmemattach@mdm.bga.com>
References: <20101122122847.3585b447@lilo>
 <xmemattach@mdm.bga.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 02:45:44 -0600
Milton Miller <miltonm@bga.com> wrote:
> On 2010-11-22 about 1:59:02, Chris Yeoh wrote:
> > Resending just in case the previous mail was missed rather than
> > ignored :-) I'd appreciate any comments....
> 
> sometimes starting a review leads to lots of comments :-)

Thanks :-)

> > @@ -624,3 +624,4 @@ asmlinkage long compat_sys_fanotify_mark(int
> > fanotify_fd, unsigned int flags, u64 mask = ((u64)mask_hi << 32) |
> > mask_lo; return sys_fanotify_mark(fanotify_fd, flags, mask, dfd,
> > pathname); }
> > +
> 
> 
> looks like a leftover fragment

yup, will fix

> > +				      unsigned long liovcnt,
> > +				      const struct iovec __user
> > *rvec,
> > +				      unsigned long riovcnt,
> > +				      unsigned long flags);
> 
> 
> These will obviously need compat code, as both struct iovec and long
> are different on 32 and 64 bit.
> 
> It looks like fs/compat.c has a helper for copying a compat iovec.


Yea I left off the compat code for now - when I looked at readv/writev
as examples there seemed to be a lot of cut & paste required so I
thought I'd leave doing that bit till I knew the original was ok.

> > +	/* Get the pages we're interested in */
> > +	pages_pinned = get_user_pages(task, task->mm, pa,
> > +				      nr_pages_to_copy,
> > +				      vm_write, 0, process_pages,
> > NULL); +
> > +	if (pages_pinned != nr_pages_to_copy)
> > +		goto end;
> 
> 
> Throughout this code, you are giving priority to errors encountered
> over partial progress, like read and write do.
> 
> While this is a new syscall and not read or write, is this
> intentional?

I did look at readv and writev quite a bit which is probably where it
comes from, but I don't think this behaviour is inappropriate. Where we
are using it (MPI) something has gone very wrong if the full read/write
cannot occur. I'm struggling a bit to think of use cases of this
interface where you would reasonably expect partial read/writes.

> 
> Please use the kernel multi-line comment style (see
> Documentation/CodingStyle) (which is used thoughout memory.c)
> 

ok

> 
> don't cast arguments to min, use min_t instead.

ok

> > +		target_kaddr = kmap(process_pages[i]) +
> > start_offset; +
> > +		if (vm_write)
> > +			ret = copy_from_user(target_kaddr,
> > +
> > lvec[*lvec_current].iov_base
> > +					     + *lvec_offset,
> > +					     bytes_to_copy);
> > +		else
> > +			ret =
> > copy_to_user(lvec[*lvec_current].iov_base
> > +					   + *lvec_offset,
> > +					   target_kaddr,
> > bytes_to_copy);
> 
> 
> access_process_vm uses copy_to|from_user_page, which on many
> architectures will invalidate the icache when writing the page.  Some
> archtectures (including sparc) also have cache flushes, some before
> the copy.  The most non-trivial seems to be arm.

Hrm. Thats going to complicate things a bit. Can't call
copy_to_user_page to do the copy, but will need an arch specific call
for the appropriate cache flushing.

> Hmm, I just realized this could create a ABBA deadlock between the
> two processes mm semaphore, as this is holding the remote processes
> mmap semaphore while doing copy to or from the current process space.

Oh :-(

> do we need to keep mmap_sem after we get the pages?  maybe that is the
> way out of the deadlock part ...

I don't think we need to keep mmap_sem after we get the pages (lots
of examples where the lock is dropped just after). So yes, that would
remove the deadlock problem. 


> 
> > +		kunmap(process_pages[i]);
> > +		if (ret) {
> > +			i++;
> > +			goto end;
> > +		}
> > +		bytes_copied += bytes_to_copy;
> > +		*lvec_offset += bytes_to_copy;
> > +		if (*lvec_offset == lvec[*lvec_current].iov_len) {
> > +			/* Need to copy remaining part of page into
> > +			   the next iovec if there are any bytes
> > left in page */
> 
> comment style
> nit: perhaps more on the first line?

ok

> > +				i--;
> > +		} else {
> > +			if (start_offset)
> > +				start_offset = 0;
> 
> This should be unconditional -- a store to an argument (local stack)
> variable is likely faster than the compare and branch.

ok

> 
> There are several functions with similar names, and _v doesn't mean
> much.

I'll have another look at the naming. I originally had an non iovec
syscall and probably need to fix things up now.

> > +	mm = task->mm;
> > +
> > +	if (!mm) {
> > +		rc = -EINVAL;
> 
> need task_unlock(task) in this path

oops, yes.

> 
> get_task_mm has additional tests and should probably be used.
> that breaks your optimization of getting doing task_lock(task) once.

ok, yea I was trying to avoid getting the task lock only once, but
better to leave the optimization out for now rather than copy more code?

> 
> These checks could be moved before finding the process, allowing a
> simple return of the error code.  Unless we need to care if we get
> -EINVAL over -ESRCH or -EPERM.
> 

No, moving it should be fine.

> 
> PAGE_SIZE * 2 is somewhat magic and used across multiple functions,
> plase define a derived constant, or better yet pass the size of the
> buffer allocated.
> 

ok
> 
> > +				GFP_KERNEL);
> > +
> > +	if (!process_pages) {
> > +		rc = -ENOMEM;
> > +		goto free_iovecs;
> > +	}
> 
> 
> actually i would consider moveing the process and mm lookup to here,
> after we validate the copy makes sense.

I'll look at that.

> If we require the source and destination vectors to be equal length
> then we could replace this check with a simple i < riovcnt.

We unfortunately don't want to make that assumption. Other bits get
much simpler too, especially if the source and destination iovecs are
basically the same size, but thats not always going to be the case for
how mpi implementations want to use it.

> 
> while this may help bound the latency, and it documents that the
> mm semaphore is locked over the call, it also leads to more lock
> activity ... but the final solution needs to deal with the ABBA
> issue mentioned above.

Yea I think we'll need to hold the mm semaphore only during
get_user_pages to avoid that deadlock

> You have a flags argument but don't check it anywhere.
> 
> Please check flags for any unsupported options.

ok

> Can we get by with one syscall by making one of the flags the
> direction?

I think there's room for that, even considering how we want to use flags
in the future.

Chris

-- 
cyeoh@au1.ibm.com

