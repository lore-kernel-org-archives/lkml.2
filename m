Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab2CTV34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 17:29:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:36214 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab2CTV3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 17:29:54 -0400
Message-ID: <1332278973.2982.24.camel@pasglop>
Subject: Re: [PATCH 04/20 v3] powerpc/mm/fault.c: Port OOM changes to
 do_page_fault
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>, Jimi Xenidis <jimix@pobox.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>
Date: Wed, 21 Mar 2012 08:29:33 +1100
In-Reply-To: <1332278936.2982.23.camel@pasglop>
References: <1332259260-1943-1-git-send-email-consul.kautuk@gmail.com>
	 <1332278936.2982.23.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 08:28 +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2012-03-20 at 12:01 -0400, Kautuk Consul wrote:
> > Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
> > (mm: retry page fault when blocking on disk transfer) and
> > commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
> > (x86,mm: make pagefault killable)
> > 
> > The above commits introduced changes into the x86 pagefault handler
> > for making the page fault handler retryable as well as killable.
> > 
> > These changes reduce the mmap_sem hold time, which is crucial
> > during OOM killer invocation.
> > 
> > Port these changes to powerpc.
> 
> I have done that port already :-) It's in powerpc-next which I will send
> to Linus to pull today or tomorrow....

BTW. Feel free to review what I've done, it's quite possible that I have
screwed something up ...

Cheers,
Ben.

> Cheers,
> Ben.
> 
> > Signed-off-by: Mohd. Faris <mohdfarisq2010@gmail.com>
> > Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> > ---
> >  arch/powerpc/mm/fault.c |   51 +++++++++++++++++++++++++++++++++-------------
> >  1 files changed, 36 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> > index 2f0d1b0..a3b1176 100644
> > --- a/arch/powerpc/mm/fault.c
> > +++ b/arch/powerpc/mm/fault.c
> > @@ -129,6 +129,7 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
> >  	int is_write = 0, ret;
> >  	int trap = TRAP(regs);
> >   	int is_exec = trap == 0x400;
> > +	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
> >  
> >  #if !(defined(CONFIG_4xx) || defined(CONFIG_BOOKE))
> >  	/*
> > @@ -212,6 +213,7 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
> >  		if (!user_mode(regs) && !search_exception_tables(regs->nip))
> >  			goto bad_area_nosemaphore;
> >  
> > +retry:
> >  		down_read(&mm->mmap_sem);
> >  	}
> >  
> > @@ -313,6 +315,7 @@ good_area:
> >  	} else if (is_write) {
> >  		if (!(vma->vm_flags & VM_WRITE))
> >  			goto bad_area;
> > +		flags |= FAULT_FLAG_WRITE;
> >  	/* a read */
> >  	} else {
> >  		/* protection fault */
> > @@ -327,7 +330,11 @@ good_area:
> >  	 * make sure we exit gracefully rather than endlessly redo
> >  	 * the fault.
> >  	 */
> > -	ret = handle_mm_fault(mm, vma, address, is_write ? FAULT_FLAG_WRITE : 0);
> > +	ret = handle_mm_fault(mm, vma, address, flags);
> > +
> > +	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
> > +		return 0;
> > +
> >  	if (unlikely(ret & VM_FAULT_ERROR)) {
> >  		if (ret & VM_FAULT_OOM)
> >  			goto out_of_memory;
> > @@ -335,22 +342,36 @@ good_area:
> >  			goto do_sigbus;
> >  		BUG();
> >  	}
> > -	if (ret & VM_FAULT_MAJOR) {
> > -		current->maj_flt++;
> > -		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
> > -				     regs, address);
> > -#ifdef CONFIG_PPC_SMLPAR
> > -		if (firmware_has_feature(FW_FEATURE_CMO)) {
> > -			preempt_disable();
> > -			get_lppaca()->page_ins += (1 << PAGE_FACTOR);
> > -			preempt_enable();
> > +	if (flags & FAULT_FLAG_ALLOW_RETRY) {
> > +		if (ret & VM_FAULT_MAJOR) {
> > +			current->maj_flt++;
> > +			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
> > +					     regs, address);
> > +#ifdef CONFIG_PPC_SMLPAR
> > +			if (firmware_has_feature(FW_FEATURE_CMO)) {
> > +				preempt_disable();
> > +				get_lppaca()->page_ins += (1 << PAGE_FACTOR);
> > +				preempt_enable();
> > +			}
> > +#endif
> > +		} else {
> > +			current->min_flt++;
> > +			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
> > +					     regs, address);
> > +		}
> > +		if (fault & VM_FAULT_RETRY) {
> > +			flags &= ~FAULT_FLAG_ALLOW_RETRY;
> > +
> > +			/*
> > +			 * No need to up_read(&mm->mmap_sem) as we would
> > +			 * have already released it in __lock_page_or_retry
> > +			 * in mm/filemap.c.
> > +			 */
> > +
> > +			goto retry;
> >  		}
> > -#endif
> > -	} else {
> > -		current->min_flt++;
> > -		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
> > -				     regs, address);
> >  	}
> > +
> >  	up_read(&mm->mmap_sem);
> >  	return 0;
> >  
> 


