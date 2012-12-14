Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2LNFt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:49:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53211 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2LNFt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:49:26 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, johnstul@us.ibm.com, horms@verge.net.au,
        shinya.kuribayashi.px@renesas.com, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Fri, 14 Dec 2012 14:54:00 +0900
Message-Id: <20121214055400.10081.66986.sendpatchset@w520>
In-Reply-To: <20121214055323.10081.12056.sendpatchset@w520>
References: <20121214055323.10081.12056.sendpatchset@w520>
Subject: [PATCH 04/08] clocksource: sh_cmt: Introduce per-register functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Introduce sh_cmt_read_cmstr/cmcsr/cmcnt() and
sh_cmt_write_cmstr/cmcsr/cmcnt/cmcor() to in the
future allow us to split counter registers from
control registers and reduce code complexity by
removing sh_cmt_read() and sh_cmt_write(). 

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/clocksource/sh_cmt.c |   71 ++++++++++++++++++++++++++++++++----------
 1 file changed, 55 insertions(+), 16 deletions(-)

--- 0001/drivers/clocksource/sh_cmt.c
+++ work/drivers/clocksource/sh_cmt.c	2012-12-14 10:50:15.000000000 +0900
@@ -86,6 +86,21 @@ static inline unsigned long sh_cmt_read(
 	return ioread16(base + offs);
 }
 
+static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_priv *p)
+{
+	return sh_cmt_read(p, CMSTR);
+}
+
+static inline unsigned long sh_cmt_read_cmcsr(struct sh_cmt_priv *p)
+{
+	return sh_cmt_read(p, CMCSR);
+}
+
+static inline unsigned long sh_cmt_read_cmcnt(struct sh_cmt_priv *p)
+{
+	return sh_cmt_read(p, CMCNT);
+}
+
 static inline void sh_cmt_write(struct sh_cmt_priv *p, int reg_nr,
 				unsigned long value)
 {
@@ -112,21 +127,45 @@ static inline void sh_cmt_write(struct s
 	iowrite16(value, base + offs);
 }
 
+static inline void sh_cmt_write_cmstr(struct sh_cmt_priv *p,
+				      unsigned long value)
+{
+	sh_cmt_write(p, CMSTR, value);
+}
+
+static inline void sh_cmt_write_cmcsr(struct sh_cmt_priv *p,
+				      unsigned long value)
+{
+	sh_cmt_write(p, CMCSR, value);
+}
+
+static inline void sh_cmt_write_cmcnt(struct sh_cmt_priv *p,
+				      unsigned long value)
+{
+	sh_cmt_write(p, CMCNT, value);
+}
+
+static inline void sh_cmt_write_cmcor(struct sh_cmt_priv *p,
+				      unsigned long value)
+{
+	sh_cmt_write(p, CMCOR, value);
+}
+
 static unsigned long sh_cmt_get_counter(struct sh_cmt_priv *p,
 					int *has_wrapped)
 {
 	unsigned long v1, v2, v3;
 	int o1, o2;
 
-	o1 = sh_cmt_read(p, CMCSR) & p->overflow_bit;
+	o1 = sh_cmt_read_cmcsr(p) & p->overflow_bit;
 
 	/* Make sure the timer value is stable. Stolen from acpi_pm.c */
 	do {
 		o2 = o1;
-		v1 = sh_cmt_read(p, CMCNT);
-		v2 = sh_cmt_read(p, CMCNT);
-		v3 = sh_cmt_read(p, CMCNT);
-		o1 = sh_cmt_read(p, CMCSR) & p->overflow_bit;
+		v1 = sh_cmt_read_cmcnt(p);
+		v2 = sh_cmt_read_cmcnt(p);
+		v3 = sh_cmt_read_cmcnt(p);
+		o1 = sh_cmt_read_cmcsr(p) & p->overflow_bit;
 	} while (unlikely((o1 != o2) || (v1 > v2 && v1 < v3)
 			  || (v2 > v3 && v2 < v1) || (v3 > v1 && v3 < v2)));
 
@@ -142,14 +181,14 @@ static void sh_cmt_start_stop_ch(struct
 
 	/* start stop register shared by multiple timer channels */
 	raw_spin_lock_irqsave(&sh_cmt_lock, flags);
-	value = sh_cmt_read(p, CMSTR);
+	value = sh_cmt_read_cmstr(p);
 
 	if (start)
 		value |= 1 << cfg->timer_bit;
 	else
 		value &= ~(1 << cfg->timer_bit);
 
-	sh_cmt_write(p, CMSTR, value);
+	sh_cmt_write_cmstr(p, value);
 	raw_spin_unlock_irqrestore(&sh_cmt_lock, flags);
 }
 
@@ -173,14 +212,14 @@ static int sh_cmt_enable(struct sh_cmt_p
 	/* configure channel, periodic mode and maximum timeout */
 	if (p->width == 16) {
 		*rate = clk_get_rate(p->clk) / 512;
-		sh_cmt_write(p, CMCSR, 0x43);
+		sh_cmt_write_cmcsr(p, 0x43);
 	} else {
 		*rate = clk_get_rate(p->clk) / 8;
-		sh_cmt_write(p, CMCSR, 0x01a4);
+		sh_cmt_write_cmcsr(p, 0x01a4);
 	}
 
-	sh_cmt_write(p, CMCOR, 0xffffffff);
-	sh_cmt_write(p, CMCNT, 0);
+	sh_cmt_write_cmcor(p, 0xffffffff);
+	sh_cmt_write_cmcnt(p, 0);
 
 	/*
 	 * According to the sh73a0 user's manual, as CMCNT can be operated
@@ -194,12 +233,12 @@ static int sh_cmt_enable(struct sh_cmt_p
 	 * take RCLKx2 at maximum.
 	 */
 	for (k = 0; k < 100; k++) {
-		if (!sh_cmt_read(p, CMCNT))
+		if (!sh_cmt_read_cmcnt(p))
 			break;
 		udelay(1);
 	}
 
-	if (sh_cmt_read(p, CMCNT)) {
+	if (sh_cmt_read_cmcnt(p)) {
 		dev_err(&p->pdev->dev, "cannot clear CMCNT\n");
 		ret = -ETIMEDOUT;
 		goto err1;
@@ -222,7 +261,7 @@ static void sh_cmt_disable(struct sh_cmt
 	sh_cmt_start_stop_ch(p, 0);
 
 	/* disable interrupts in CMT block */
-	sh_cmt_write(p, CMCSR, 0);
+	sh_cmt_write_cmcsr(p, 0);
 
 	/* stop clock */
 	clk_disable(p->clk);
@@ -270,7 +309,7 @@ static void sh_cmt_clock_event_program_v
 		if (new_match > p->max_match_value)
 			new_match = p->max_match_value;
 
-		sh_cmt_write(p, CMCOR, new_match);
+		sh_cmt_write_cmcor(p, new_match);
 
 		now = sh_cmt_get_counter(p, &has_wrapped);
 		if (has_wrapped && (new_match > p->match_value)) {
@@ -346,7 +385,7 @@ static irqreturn_t sh_cmt_interrupt(int
 	struct sh_cmt_priv *p = dev_id;
 
 	/* clear flags */
-	sh_cmt_write(p, CMCSR, sh_cmt_read(p, CMCSR) & p->clear_bits);
+	sh_cmt_write_cmcsr(p, sh_cmt_read_cmcsr(p) & p->clear_bits);
 
 	/* update clock source counter to begin with if enabled
 	 * the wrap flag should be cleared by the timer specific
