Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab2CVLGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:06:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab2CVLGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:06:16 -0400
Date: Thu, 22 Mar 2012 12:06:07 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] genirq: Get rid of unneeded force parameter in
 irq_finalize_oneshot()
Message-ID: <20120322110606.GD17233@dhcp-26-207.brq.redhat.com>
References: <20120319145848.GG2147@dhcp-26-207.brq.redhat.com>
 <alpine.LFD.2.02.1203221128260.2542@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203221128260.2542@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 11:32:26AM +0100, Thomas Gleixner wrote:
> Wrong.
> 
> CPU 0				CPU 1
> 
>     do_exit()
> 				check(PF_EXITING)
> 				set_bit(IRQTF_RUNTHREAD)
> 				...
>     set(PF_EXITING)
>     exit_irq_thread()

Thomas,

Did not you pick this code with 7140ea1 commit?

@@ -845,6 +842,13 @@ void exit_irq_thread(void)
 
 	desc = irq_to_desc(action->irq);
 
+	/*
+	 * If IRQTF_RUNTHREAD is set, we need to decrement
+	 * desc->threads_active and wake possible waiters.
+	 */
+	if (test_and_clear_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+		wake_threads_waitq(desc);
+
 	/* Prevent a stale desc->threads_oneshot */
 	irq_finalize_oneshot(desc, action, true);
 }

> 
>     if (test_bit(IRQTF_RUNTHREAD))
> 	goto out;
> 
> 	-> FAIL
> 
> Thanks,
> 
> 	tglx

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
