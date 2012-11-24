Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab2KXOPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 09:15:01 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:36768 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2KXOPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 09:15:00 -0500
Subject: Re: arch_check_bp_in_kernelspace: fix the range check
To: oleg@redhat.com (Oleg Nesterov)
Date: Sun, 25 Nov 2012 01:14:58 +1100 (EST)
Cc: gorcunov@openvz.org (Cyrill Gorcunov),
        xemul@parallels.com (Pavel Emelyanov),
        rostedt@goodmis.org (Steven Rostedt),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20121123170553.GA1664@redhat.com>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121124141458.CB215592076@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

This patch may look ugly, but it is one way to solve my problem.

This way, "strace" too, which is broken since the introduction of
the vsyscall page, will again be able to report when the program
calls "time()" or "gettimeofday()" - currently it cannot!

I think that allowing to set the x86 debug-registers to the
vsyscall page is more elegant - but do whatever you prefer.

Best Regards,
Amnon.



> forgot to mention...
> 
> On 11/23, Oleg Nesterov wrote:
> >
> > On 11/23, Amnon Shiloh wrote:
> > >
> > > Or, there is an alternative: if only I (the ptracer or the traced process)
> > > was allowed to munmap the vsyscall page,
> >
> > It is not possible to unmap it. The kernel (swapper_pg_dir) has this
> > mapping, not the process. Unlike vdso. IOW, you can only "unmap" it
> > globally and obviously you can't do this from the userspace.
> 
> And even if this were possible, this can't help. Please look at
> __bad_area_nosemaphore()->emulate_vsyscall(), the process won't get
> SIGSEGV. IOW, in fact EMULATE already "unmaps" this page (sets _NX)
> to trigger the fault.
> 
> Sure, we can do something like below, but it doesn't look very nice
> too.
> 
> Oleg.
> 
> --- x/arch/x86/mm/fault.c
> +++ x/arch/x86/mm/fault.c
> @@ -744,7 +744,8 @@ __bad_area_nosemaphore(struct pt_regs *r
>  		 */
>  		if (unlikely((error_code & PF_INSTR) &&
>  			     ((address & ~0xfff) == VSYSCALL_START))) {
> -			if (emulate_vsyscall(regs, address))
> +			if (!(tsk->ptrace & PTRACE_O_DONTEMULATE) &&
> +			    emulate_vsyscall(regs, address))
>  				return;
>  		}
>  #endif
> 
> 

