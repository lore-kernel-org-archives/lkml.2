Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2JGRLn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 13:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab2JGRLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 13:11:35 -0400
Date: Sun, 7 Oct 2012 19:13:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [regression] boot failure on alpha, bisected
Message-ID: <20121007171300.GA10942@redhat.com>
References: <20121006204736.GA1830@ds20.borg.net> <20121007165534.GA8024@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121007165534.GA8024@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07, Oleg Nesterov wrote:
>
> Hmm. I know nothing about arch/alpha and I can't understand its entry.S.
> But _it seems_ to me that do_notify_resume() is called with irqs disabled.
> If this is true, then imho arch/alpha should be fixed.
>
> Before this commit task_work_run() enabled irqs, but this was the "side
> effect" of spin_lock_irq/spin_unlock_irq, we should not rely on this.

Could you please test the debugging patch below?

Oleg.


--- x/arch/alpha/kernel/signal.c
+++ x/arch/alpha/kernel/signal.c
@@ -567,11 +567,19 @@ do_signal(struct pt_regs * regs, struct 
 		ptrace_set_bpt(current);	/* re-set breakpoint */
 }
 
+#include <linux/ratelimit.h>
+
 void
 do_notify_resume(struct pt_regs *regs, struct switch_stack *sw,
 		 unsigned long thread_info_flags,
 		 unsigned long r0, unsigned long r19)
 {
+	if (irqs_disabled()) {
+		printk_ratelimited(KERN_WARNING
+			"NOTIFY with irqs_disabled:%lx\n", thread_info_flags);
+		local_irq_enable();
+	}
+
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs, sw, r0, r19);
 

