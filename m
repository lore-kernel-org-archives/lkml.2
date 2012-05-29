Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2E2QOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:14:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32714 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab2E2QOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:14:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6725"; a="195607165"
Date: Tue, 29 May 2012 11:14:15 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: hexagon: signal bugs
Message-ID: <20120529161415.GA2486@codeaurora.org>
References: <20120519210911.GB11775@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120519210911.GB11775@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 10:09:11PM +0100, Al Viro wrote:
> 	1) spot the braino:
> void do_trap0(struct pt_regs *regs)
> ...
>         unsigned long syscallret = 0;
> 	...
>                 if ((unsigned long) regs->syscall_nr >= __NR_syscalls) {
>                         regs->r00 = -1;
>                 } else {
>                         syscall = (syscall_fn)
>                                   (sys_call_table[regs->syscall_nr]);
>                         syscallret = syscall(regs->r00, regs->r01,
>                                    regs->r02, regs->r03,
>                                    regs->r04, regs->r05);
>                 }
> 
>                 if (regs->syscall_nr != __NR_rt_sigreturn)
>                         regs->r00 = syscallret;
> IOW, the last if () should've been inside the "syscall_nr is not too high"
> branch of the if () just above...
> 
> 	2) you do _not_ want syscall restarts to happen on sigreturn().
> Whatever adjustment needed to be done had already been done back before
> we'd saved the registers into sigcontext.  So doing
>         regs->syscall_nr = __NR_rt_sigreturn;
> in sys_rt_sigreturn() is exactly the wrong thing - for syscall restart
> purposes you want it to look like a non-syscall (i.e. it should be
> regs->syscall_nr = -1 to make your check in handle_signal() work).
> Incidentally, I would suggest just having that thing return regs->r00;
> then you can avoid all special-casing for "do we want to put the
> return value of sys_...() into regs->r00?" in do_trap0().
> 
> 	3) if you have multiple pending signals, you need to handle all
> of them before returning to userland.  And you need to make sure that
> syscall restart logics does not trigger on anything past the first time
> around.
> 
> 	4) checking for !user_mode(regs) needs to be done in the loop (created
> while fixing #3) in vm_entry.S where you are calling do_notify_resume();
> you need to leave the loop if it's true (if you can get there on return
> to kernel in the first place).

Just wanted to say thanks so much for reviewing the code; I didn't get
around to making the changes until late last week, but I've got the fixes
in my tree and will submit a patch for review after I've given it some
testing.


Thanks again,
Richard Kuo



-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
