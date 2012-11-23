Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2KWRFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 12:05:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab2KWRFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 12:05:40 -0500
Date: Fri, 23 Nov 2012 18:05:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: arch_check_bp_in_kernelspace: fix the range check
Message-ID: <20121123170553.GA1664@redhat.com>
References: <20121122161238.GA27078@redhat.com> <20121123091453.016B0592076@miso.sublimeip.com> <20121123163320.GA32716@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123163320.GA32716@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to mention...

On 11/23, Oleg Nesterov wrote:
>
> On 11/23, Amnon Shiloh wrote:
> >
> > Or, there is an alternative: if only I (the ptracer or the traced process)
> > was allowed to munmap the vsyscall page,
>
> It is not possible to unmap it. The kernel (swapper_pg_dir) has this
> mapping, not the process. Unlike vdso. IOW, you can only "unmap" it
> globally and obviously you can't do this from the userspace.

And even if this were possible, this can't help. Please look at
__bad_area_nosemaphore()->emulate_vsyscall(), the process won't get
SIGSEGV. IOW, in fact EMULATE already "unmaps" this page (sets _NX)
to trigger the fault.

Sure, we can do something like below, but it doesn't look very nice
too.

Oleg.

--- x/arch/x86/mm/fault.c
+++ x/arch/x86/mm/fault.c
@@ -744,7 +744,8 @@ __bad_area_nosemaphore(struct pt_regs *r
 		 */
 		if (unlikely((error_code & PF_INSTR) &&
 			     ((address & ~0xfff) == VSYSCALL_START))) {
-			if (emulate_vsyscall(regs, address))
+			if (!(tsk->ptrace & PTRACE_O_DONTEMULATE) &&
+			    emulate_vsyscall(regs, address))
 				return;
 		}
 #endif

