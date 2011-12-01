Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab1LAVXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:23:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:45112 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab1LAVXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:23:24 -0500
Date: Thu, 1 Dec 2011 22:23:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ido Yariv <ido@wizery.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: Fix race condition when stopping the irq thread
In-Reply-To: <1322740508-22640-1-git-send-email-ido@wizery.com>
Message-ID: <alpine.LFD.2.02.1112012221380.2735@ionos>
References: <1322740508-22640-1-git-send-email-ido@wizery.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011, Ido Yariv wrote:

> In irq_wait_for_interrupt(), the should_stop member is verified before
> setting the task's state to TASK_INTERRUPTIBLE and calling schedule().
> In case kthread_stop sets should_stop and wakes up the process after
> should_stop is checked by the irq thread but before the task's state is
> changed, the irq thread might never exit:
> 
> kthread_stop                            irq_wait_for_interrupt
> ------------                            ----------------------
> 
>                                         ...
> ...                                     while (!kthread_should_stop()) {
> kthread->should_stop = 1;
> wake_up_process(k);
> wait_for_completion(&kthread->exited);
> ...
>                                             set_current_state(TASK_INTERRUPTIBLE);
> 
>                                             ...
> 
>                                             schedule();
>                                         }
>                                         ...
> 
> Fix this by checking if the thread should stop after modifying the
> task's state.

Good catch! I restructure it to:

--- tip.orig/kernel/irq/manage.c
+++ tip/kernel/irq/manage.c
@@ -623,8 +623,9 @@ static irqreturn_t irq_nested_primary_ha
 
 static int irq_wait_for_interrupt(struct irqaction *action)
 {
+	set_current_state(TASK_INTERRUPTIBLE);
+
 	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (test_and_clear_bit(IRQTF_RUNTHREAD,
 				       &action->thread_flags)) {
@@ -632,7 +633,9 @@ static int irq_wait_for_interrupt(struct
 			return 0;
 		}
 		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
 	}
+	__set_current_state(TASK_RUNNING);
 	return -1;
 }
 
That saves us the extra conditional in the loop.

Thanks,

	tglx
