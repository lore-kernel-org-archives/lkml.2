Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0I3XXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:23:51 -0400
Received: from www.tglx.de ([62.245.132.106]:52413 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab0I3XPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:15:42 -0400
Message-Id: <20100930221739.365426515@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:15:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 09/47] isdn: hisax: Replace the bogus access to irq stats
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=drivers-isdn-hisax-fix-madness.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abusing irq stats in a driver for counting interrupts is a horrible
idea and not safe with shared interrupts. Replace it by a local
interrupt counter.

Noticed by the attempt to remove the irq stats export.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/isdn/hisax/config.c |   18 ++++++++++++++----
 drivers/isdn/hisax/hisax.h  |    1 +
 2 files changed, 15 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/drivers/isdn/hisax/config.c
===================================================================
--- linux-2.6-tip.orig/drivers/isdn/hisax/config.c
+++ linux-2.6-tip/drivers/isdn/hisax/config.c
@@ -801,6 +801,16 @@ static void closecard(int cardnr)
 	ll_unload(csta);
 }
 
+static irqreturn_t card_irq(int intno, void *dev_id)
+{
+	struct IsdnCardState *cs = dev_id;
+	irqreturn_t ret = cs->irq_func(intno, cs);
+
+	if (ret == IRQ_HANDLED)
+		cs->irq_cnt++;
+	return ret;
+}
+
 static int init_card(struct IsdnCardState *cs)
 {
 	int 	irq_cnt, cnt = 3, ret;
@@ -809,10 +819,10 @@ static int init_card(struct IsdnCardStat
 		ret = cs->cardmsg(cs, CARD_INIT, NULL);
 		return(ret);
 	}
-	irq_cnt = kstat_irqs(cs->irq);
+	irq_cnt = cs->irq_cnt = 0;
 	printk(KERN_INFO "%s: IRQ %d count %d\n", CardType[cs->typ],
 	       cs->irq, irq_cnt);
-	if (request_irq(cs->irq, cs->irq_func, cs->irq_flags, "HiSax", cs)) {
+	if (request_irq(cs->irq, card_irq, cs->irq_flags, "HiSax", cs)) {
 		printk(KERN_WARNING "HiSax: couldn't get interrupt %d\n",
 		       cs->irq);
 		return 1;
@@ -822,8 +832,8 @@ static int init_card(struct IsdnCardStat
 		/* Timeout 10ms */
 		msleep(10);
 		printk(KERN_INFO "%s: IRQ %d count %d\n",
-		       CardType[cs->typ], cs->irq, kstat_irqs(cs->irq));
-		if (kstat_irqs(cs->irq) == irq_cnt) {
+		       CardType[cs->typ], cs->irq, cs->irq_cnt);
+		if (cs->irq_cnt == irq_cnt) {
 			printk(KERN_WARNING
 			       "%s: IRQ(%d) getting no interrupts during init %d\n",
 			       CardType[cs->typ], cs->irq, 4 - cnt);
Index: linux-2.6-tip/drivers/isdn/hisax/hisax.h
===================================================================
--- linux-2.6-tip.orig/drivers/isdn/hisax/hisax.h
+++ linux-2.6-tip/drivers/isdn/hisax/hisax.h
@@ -959,6 +959,7 @@ struct IsdnCardState {
 	u_long		event;
 	struct work_struct tqueue;
 	struct timer_list dbusytimer;
+	unsigned int	irq_cnt;
 #ifdef ERROR_STATISTIC
 	int		err_crc;
 	int		err_tx;


