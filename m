Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0C2Eng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 00:43:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab0C2Enf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 00:43:35 -0400
Date: Mon, 29 Mar 2010 15:43:25 +1100
From: Neil Brown <neilb@suse.de>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sysfs: simplify handling for s_active refcount
Message-ID: <20100329154325.2bb42a9c@notabene.brown>
In-Reply-To: <m1bpebfrhv.fsf@fess.ebiederm.org>
References: <20100324031829.2136.66489.stgit@notabene.brown>
	<20100324032008.2136.52640.stgit@notabene.brown>
	<m139znogl0.fsf@fess.ebiederm.org>
	<20100326163236.1ffb2c2b@notabene.brown>
	<m1bpebfrhv.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010 00:53:48 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Neil Brown <neilb@suse.de> writes:
> 
> > On Thu, 25 Mar 2010 21:24:43 -0700
> > ebiederm@xmission.com (Eric W. Biederman) wrote:
> >
> >> NeilBrown <neilb@suse.de> writes:
> >> 
> >> > s_active counts the number of active references to a 'sysfs_direct'.
> >> > When we wish to deactivate a sysfs_direct, we subtract a large
> >> > number for the refcount so it will always appear negative.  When
> >> > it is negative, new references will not be taken.
> >> > After that subtraction, we wait for all the active references to
> >> > drain away.
> >> >
> >> > The subtraction of the large number contains exactly the same
> >> > information as the setting of the flag SYSFS_FLAG_REMOVED.
> >> > (We know this as we already assert that SYSFS_FLAG_REMOVED is set
> >> > before adding the large-negative-bias).
> >> > So doing both is pointless.
> >> >
> >> > By starting s_active with a value of 1, not 0 (as is typical of
> >> > reference counts) and using atomic_inc_not_zero, we can significantly
> >> > simplify the code while keeping exactly the same functionality.
> >> 
> >> Overall your logic appears correct but in detail this patch scares me.
> >> 
> >> sd->s_flags is protected by the sysfs_mutex, and you aren't
> >> taking it when you read it.  So in general I don't see the new check
> >> if (sd->s_flags & SYSFS_FLAG_REMOVED) == 0 providing any guarantee of
> >> progress whatsoever with user space applications repeated reading from
> >> a sysfs file when that sysfs file is being removed.  They could easily
> >> have the sd->s_flags value cached and never see the new value, given a
> >> crazy enough cache architecture.
> >
> > As you say, this is only a liveness issue.  The atomic_inc_not_zero
> > guarantees that we don't take a new reference after the last one is gone.
> > The test on SYSFS_FLAG_REMOVED is only there to ensure that the count does
> > eventually get to zero.
> > There could only be a problem here if the change to s_flags was not
> > propagated to all CPUs in some reasonably small time.
> 
> Having this handled correctly is a key part of the abstraction
> implemented with sysfs_get_active sysfs_put_active and
> sysfs_deactivate.  It is a requirement that userspace can not cuause
> denial of service attacks on the rest of the kernel.
> 
> > I'm not expert on these things but it was my understanding that interesting
> > cache architectures could arbitrarily re-order accesses, but does not delay
> > them indefinitely.
> > Inserting barriers could possibly make this more predictable, but that would
> > just delay certain loads/stores until a known state was reached - it would
> > not make the data visible at another CPU any faster (or would it?).
> 
> > So unless there is no cache-coherency protocol at all, I think that
> > SYSFS_FLAG_REMOVED will be seen promptly and that s_active will drop to zero
> > and quickly as it does today.
> 
> This is my problem with your patch.  You have replaced something that
> used an existing abstraction properly, with something that does not
> use any abstraction at all and we are reduced to talking about cpu
> memory ordering requirements.

We are not talking about memory ordering requirements.  There are no memory
ordering requirements introduced in the patch.  It really doesn't matter if
the setting of SYSFS_FLAG_REMOVED is seen before or after anything else.
All that matters is that it does get seen, and it will be seen long before
you could possibly describe the situation as 'denial of service'.

However if we do consider memory ordering guarantees we can describe a clear
limit to the possibly delay between SYSFS_FLAG_REMOVED being set, and being
seen.  The atomic_inc_not_zero serves as a memory barrier in exactly the same
way that the current code requires atomic_dec_return.  So while

	if (likely(sd)
	    && (sd->s_flags & SYSFS_FLAG_REMOVED) == 0
	    && atomic_inc_not_zero(&sd->s_active)) {

could possibly gain a reference even 'after' SYS_FLAG_REMOVED as been set,
a second call to this on the same processor will see SYSFS_FLAG_REMOVED.
So at the absolute most, we could see NCPUS active references gained and
dropped after SYSFS_FLAG_REMOVED was set - a clear limit which is all we need.
I'm still not sure we even need to argue in terms of memory barriers to be
sure the code is correct, but it seems they are sufficient to give a simple
proof.
The sysfs code already has a dependency on implicit memory barriers to ensure
that ->s_sibling points to a completion.  My change does not significantly
add to that.


> 
> Furthermore this code you are changing is not used raw but it is the
> building blocks for a well defined abstraction.  The users of
> sysfs_get_active sysfs_put_active and sysfs_deactivate don't have to
> know the details of how they are implemented to think about and
> reason about it accurately.

True.  However it is raw in the sense that if some other developer wanted
similar functionality in their own code they might copy the low level stuff
as they wouldn't be able to use the sys_* routines directly.  Copying
complex code is not a good path to maintainability.

> 
> I am very much in favor of a general primitive that we can use for
> blocking ref counts.  We have them in sysfs, proc, sysctl, and a few
> other places with similar requirements.  Each location has a different
> implementation, but essentially the same semantics.
> 
> What is really needed is something with the semantics of:
> read_trylock
> read_unlock
> write_lock() perhaps synchronize?

Yes - I think the synergy between locks an refcounts is really interesting...

As you say, simply using a general abstraction which provides these functions
would incur a space cost that you don't want.  You avoid this cost by
re-using s_sibling to store a reference to a completion.
Finding a primitive that allows such optimisations is an interesting
challenge.
I really think that atomic_inc_not_zero is sufficient to provide what you
need.

NeilBrown


> 
> With multiple reads in side the read side critical section, and 
> biased so that the read side is very cheap, and the data structure
> size is very cheap.  We have an ugly but otherwise near optimal
> implementation in sysfs.  srcu is close the data structure
> costs too much to use on every sysfs dirent.
> 
> Improving and getting it right is very attractive.  The code that
> exists today is correct and signals that something fishy is going
> on so there is no point in doing something less than right.
> 
> Eric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

