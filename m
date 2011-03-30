Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515Ab1C3VHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:58322 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964830Ab1C3VHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411277854"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tglx@linutronix.de, ak@linux.intel.com, mingo@elte.hu, max@stro.at,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [123/275] isdn: hisax: Replace the bogus access to irq stats
Message-Id: <20110330210603.350713E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 40f08a724fcc21285cf3a75aec957aef908605c6 upstream.

Abusing irq stats in a driver for counting interrupts is a horrible
idea and not safe with shared interrupts. Replace it by a local
interrupt counter.

Noticed by the attempt to remove the irq stats export.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/hisax/config.c |   18 ++++++++++++++----
 drivers/isdn/hisax/hisax.h  |    1 +
 2 files changed, 15 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/isdn/hisax/config.c
===================================================================
--- linux-2.6.35.y.orig/drivers/isdn/hisax/config.c	2011-03-29 22:51:18.981237487 -0700
+++ linux-2.6.35.y/drivers/isdn/hisax/config.c	2011-03-29 23:03:00.769280486 -0700
@@ -801,6 +801,16 @@
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
@@ -809,10 +819,10 @@
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
@@ -822,8 +832,8 @@
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
Index: linux-2.6.35.y/drivers/isdn/hisax/hisax.h
===================================================================
--- linux-2.6.35.y.orig/drivers/isdn/hisax/hisax.h	2011-03-29 22:51:18.981237487 -0700
+++ linux-2.6.35.y/drivers/isdn/hisax/hisax.h	2011-03-29 23:03:00.770280460 -0700
@@ -959,6 +959,7 @@
 	u_long		event;
 	struct work_struct tqueue;
 	struct timer_list dbusytimer;
+	unsigned int	irq_cnt;
 #ifdef ERROR_STATISTIC
 	int		err_crc;
 	int		err_tx;
