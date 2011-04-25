Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab1DYU5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:57:44 -0400
Received: from 1wt.eu ([62.212.114.60]:33858 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab1DYUX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:56 -0400
Message-Id: <20110425200234.815401582@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, maximilian attems <max@stro.at>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 042/173] isdn: hisax: Replace the bogus access to irq stats
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 40f08a724fcc21285cf3a75aec957aef908605c6 upstream.

Abusing irq stats in a driver for counting interrupts is a horrible
idea and not safe with shared interrupts. Replace it by a local
interrupt counter.

Noticed by the attempt to remove the irq stats export.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/hisax/config.c |   18 ++++++++++++++----
 drivers/isdn/hisax/hisax.h  |    1 +
 2 files changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -800,6 +800,16 @@ static void closecard(int cardnr)
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
@@ -808,10 +818,10 @@ static int init_card(struct IsdnCardStat
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
@@ -821,8 +831,8 @@ static int init_card(struct IsdnCardStat
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
--- a/drivers/isdn/hisax/hisax.h
+++ b/drivers/isdn/hisax/hisax.h
@@ -959,6 +959,7 @@ struct IsdnCardState {
 	u_long		event;
 	struct work_struct tqueue;
 	struct timer_list dbusytimer;
+	unsigned int	irq_cnt;
 #ifdef ERROR_STATISTIC
 	int		err_crc;
 	int		err_tx;


