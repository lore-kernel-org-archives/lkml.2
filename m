Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab1FWRg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:36:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:34457 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261Ab1FWRgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 101/247] isdn: hisax: Replace the bogus access to irq stats
Date: Thu, 23 Jun 2011 13:32:49 -0400
Message-Id: <1308850515-15242-42-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 40f08a724fcc21285cf3a75aec957aef908605c6 upstream.

Abusing irq stats in a driver for counting interrupts is a horrible
idea and not safe with shared interrupts. Replace it by a local
interrupt counter.

Noticed by the attempt to remove the irq stats export.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/isdn/hisax/config.c |   18 ++++++++++++++----
 drivers/isdn/hisax/hisax.h  |    1 +
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 544cf4b..0a347a8 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
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
@@ -809,10 +819,10 @@ static int init_card(struct IsdnCardState *cs)
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
@@ -822,8 +832,8 @@ static int init_card(struct IsdnCardState *cs)
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
diff --git a/drivers/isdn/hisax/hisax.h b/drivers/isdn/hisax/hisax.h
index 832a878..32ab392 100644
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
-- 
1.7.4.4

