Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0KWJZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:25:38 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56194 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab0KWJZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:25:35 -0500
Date: Tue, 23 Nov 2010 19:55:23 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        Ingo Molnar <mingo@elte.hu>, Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [RFC][PATCH] Cross Memory Attach v2 (resend)
Message-ID: <20101123195523.46e6addb@lilo>
In-Reply-To: <20101122130527.c13c99d3.akpm@linux-foundation.org>
References: <20101122122847.3585b447@lilo>
 <20101122130527.c13c99d3.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 13:05:27 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:
> We have a bit of a track record of adding cool-looking syscalls and
> then regretting it a few years later.  Few people use them, and maybe
> they weren't so cool after all, and we have to maintain them for
> ever. Bugs (sometimes security-relevant ones) remain undiscovered for
> long periods because few people use (or care about) the code.
> 
> So I think the bar is a high one - higher than it used to be.
> Convince us that this feature is so important that it's worth all
> that overhead and risk?

Well there are the benchmark results to show that there is
real improvement for MPI implementations (well at least for those
benchmarks ;-) There's also been a few papers written on something
quite similar (KNEM) which goes into more detail on the potential gains.

http://runtime.bordeaux.inria.fr/knem/

I've also heard privately that something very similar has been used in
at least one device driver to support intranode operations for quite a
while, but maintaining this out of tree as the mm has changed has been
quite painful. 

And I can get it down to just one syscall by using the flags parameter
if that helps at all.

> > HPCC results:
> > =============
> > 
> > MB/s			Num Processes	
> > Naturally Ordered	4	8	16	32
> > Base			1235	935	622	419
> > CMA			4741	3769	1977	703
> > 
> > 			
> > MB/s			Num Processes	
> > Randomly Ordered	4	8	16	32
> > Base			1227	947	638	412
> > CMA			4666	3682	1978	710
> > 				
> > MB/s			Num Processes	
> > Max Ping Pong		4	8	16	32
> > Base			2028	1938	1928	1882
> > CMA			7424	7510	7598	7708
> 
> So with the "Naturally ordered" testcase, it got 4741/1235 times
> faster with four processes?

Yes, thats correct.

> > +asmlinkage long sys_process_vm_writev(pid_t pid,
> > +				      const struct iovec __user
> > *lvec,
> > +				      unsigned long liovcnt,
> > +				      const struct iovec __user
> > *rvec,
> > +				      unsigned long riovcnt,
> > +				      unsigned long flags);
> 
> I have a vague feeling that some architectures have issues with six or
> more syscall args.  Or maybe it was seven.

There seem to be quite a few syscalls around with 6 args and none with
7 so I suspect (or at least hope) its 7. 

> > +		bytes_to_copy = min(PAGE_SIZE - start_offset,
> > +				    len - bytes_copied);
> > +		bytes_to_copy = min((size_t)bytes_to_copy,
> > +				    lvec[*lvec_current].iov_len -
> > *lvec_offset);
> 
> Use of min_t() is conventional.

ok

> It might be a little more efficient to do
> 
> 
> 	if (vm_write) {
> 		for (j = 0; j < pages_pinned; j++) {
> 			if (j < i)
> 				set_page_dirty_lock(process_pages[j]);
> 			put_page(process_pages[j]);
> 	} else {
> 		for (j = 0; j < pages_pinned; j++)
> 			put_page(process_pages[j]);
> 	}
> 
> and it is hopefully more efficient still to use release_pages() for
> the second loop.
> 
> This code would have been clearer if a better identifier than `i' had
> been chosen.

ok.
 
> > +			 struct page **process_pages,
> > +			 struct mm_struct *mm,
> > +			 struct task_struct *task,
> > +			 unsigned long flags, int vm_write)
> > +{
> > +	unsigned long pa = addr & PAGE_MASK;
> > +	unsigned long start_offset = addr - pa;
> > +	int nr_pages;
> > +	unsigned long bytes_copied = 0;
> > +	int rc;
> > +	unsigned int nr_pages_copied = 0;
> > +	unsigned int nr_pages_to_copy;
> 
> What prevents me from copying more than 2^32 pages?

Yea it should support that... will fix.

> > +		if (rc == -EFAULT)
> 
> It would be more future-safe to use
> 
> 		if (rc < 0)
> 
> > +			goto free_mem;

ok.

> > +	int i;
> > +	int rc;
> > +	int bytes_copied;
> 
> This was unsigned long in process_vm_rw().  Please review all these
> types for appropriate size and signedness.
> 

ok, will do.

Thanks for looking over the patch!

Chris
-- 
cyeoh@au1.ibm.com


