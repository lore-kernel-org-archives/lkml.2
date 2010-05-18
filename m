Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0ERP0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:26:01 -0400
Received: from www.tglx.de ([62.245.132.106]:54667 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab0ERP0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:26:00 -0400
Date: Tue, 18 May 2010 17:25:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT Pull] timer fixes for 2.6.35
Message-ID: <alpine.LFD.2.00.1005181724280.3368@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
Jens Rottmann (1):
      cs5535-clockevt: Free timer in IRQ setup error path


 drivers/clocksource/cs5535-clockevt.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/cs5535-clockevt.c b/drivers/clocksource/cs5535-clockevt.c
index b314a99..d7be69f 100644
--- a/drivers/clocksource/cs5535-clockevt.c
+++ b/drivers/clocksource/cs5535-clockevt.c
@@ -154,14 +154,14 @@ static int __init cs5535_mfgpt_init(void)
 	if (cs5535_mfgpt_setup_irq(timer, MFGPT_CMP2, &timer_irq)) {
 		printk(KERN_ERR DRV_NAME ": Could not set up IRQ %d\n",
 				timer_irq);
-		return -EIO;
+		goto err_timer;
 	}
 
 	/* And register it with the kernel */
 	ret = setup_irq(timer_irq, &mfgptirq);
 	if (ret) {
 		printk(KERN_ERR DRV_NAME ": Unable to set up the interrupt.\n");
-		goto err;
+		goto err_irq;
 	}
 
 	/* Set the clock scale and enable the event mode for CMP2 */
@@ -184,8 +184,10 @@ static int __init cs5535_mfgpt_init(void)
 
 	return 0;
 
-err:
+err_irq:
 	cs5535_mfgpt_release_irq(cs5535_event_clock, MFGPT_CMP2, &timer_irq);
+err_timer:
+	cs5535_mfgpt_free_timer(cs5535_event_clock);
 	printk(KERN_ERR DRV_NAME ": Unable to set up the MFGPT clock source\n");
 	return -EIO;
 }
