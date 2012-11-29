Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab2K2DdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 22:33:09 -0500
Received: from [216.32.181.184] ([216.32.181.184]:59801 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751972Ab2K2DdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 22:33:06 -0500
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzzz2fh2a8h668h839hd25hf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1155h)
Message-ID: <50B6D71E.30003@am.sony.com>
Date: Wed, 28 Nov 2012 19:31:42 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
        <grant.likely@secretlab.ca>
Subject: 3.6.7-rt18 ARM BUG_ON() at kernel/sched/core.c:3817
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.7-rt18:  kernel BUG at .../kernel/sched/core.c:3817!

Grant reported this same problem for 3.6.5-rt15.

I am seeing it on a different arm board.

Here is the BUG_ON():

   asmlinkage void __sched preempt_schedule_irq(void)
   {
        struct thread_info *ti = current_thread_info();

        /* Catch callers which need to be fixed */
        BUG_ON(ti->preempt_count || !irqs_disabled());

Putting in some extra printk(), the BUG_ON() is triggering because
ti->preempt_count is non-zero.


It appears that the cause is in arch/arm/kernel/entry-armv.S.

The call to preempt_schedule_irq() is from svc_preempt:

   #ifdef CONFIG_PREEMPT
   svc_preempt:
           mov     r8, lr
   1:      bl      preempt_schedule_irq            @ irq en/disable is done inside


svc_preempt is branched to from one of two possible places.  The first was
present before the lazy preempt code was added.  The first appears ok to me.
(Note that the first branch does not occur if preempt count is non-zero.)

The second branch can occur even if the preempt count is non-zero (which is
what the BUG_ON() is finding):

   __irq_svc:
           svc_entry
           irq_handler

   #ifdef CONFIG_PREEMPT
           get_thread_info tsk
           ldr     r8, [tsk, #TI_PREEMPT]          @ get preempt count
           ldr     r0, [tsk, #TI_FLAGS]            @ get flags
           teq     r8, #0                          @ if preempt count != 0
           movne   r0, #0                          @ force flags to 0
           tst     r0, #_TIF_NEED_RESCHED
           blne    svc_preempt
           ldr     r8, [tsk, #TI_PREEMPT_LAZY]     @ get preempt lazy count
           ldr     r0, [tsk, #TI_FLAGS]            @ get flags
           teq     r8, #0                          @ if preempt lazy count != 0
           movne   r0, #0                          @ force flags to 0
           tst     r0, #_TIF_NEED_RESCHED_LAZY
           blne    svc_preempt
   #endif





