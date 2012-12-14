Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab2LNFti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:49:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53688 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2LNFtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:49:35 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, johnstul@us.ibm.com, horms@verge.net.au,
        shinya.kuribayashi.px@renesas.com, tglx@linutronix.de,
        Magnus Damm <magnus.damm@gmail.com>
Date: Fri, 14 Dec 2012 14:54:10 +0900
Message-Id: <20121214055410.10081.32594.sendpatchset@w520>
In-Reply-To: <20121214055323.10081.12056.sendpatchset@w520>
References: <20121214055323.10081.12056.sendpatchset@w520>
Subject: [PATCH 05/08] clocksource: sh_cmt: CMSTR and CMCSR register access update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update hardware register access code for CMSTR and CMCSR
from using sh_cmt_read() and sh_cmt_write() to make use
of 16-bit register access functions such as sh_cmt_read16()
and sh_cmt_write16(). Also update sh_cmt_read() and
sh_cmt_write() now when the special cases are gone.

This patch moves us one step closer to the goal of separating
counter register access functions from control control register
functions.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/clocksource/sh_cmt.c |   66 +++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

--- 0005/drivers/clocksource/sh_cmt.c
+++ work/drivers/clocksource/sh_cmt.c	2012-12-14 12:58:01.000000000 +0900
@@ -56,44 +56,46 @@ struct sh_cmt_priv {
 	bool cs_enabled;
 };
 
-static DEFINE_RAW_SPINLOCK(sh_cmt_lock);
+static inline unsigned long sh_cmt_read16(void __iomem *base,
+					  unsigned long offs)
+{
+	return ioread16(base + (offs << 1));
+}
+
+static inline void sh_cmt_write16(void __iomem *base, unsigned long offs,
+				  unsigned long value)
+{
+	iowrite16(value, base + (offs << 1));
+}
 
-#define CMSTR -1 /* shared register */
 #define CMCSR 0 /* channel register */
 #define CMCNT 1 /* channel register */
 #define CMCOR 2 /* channel register */
 
 static inline unsigned long sh_cmt_read(struct sh_cmt_priv *p, int reg_nr)
 {
-	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
 	void __iomem *base = p->mapbase;
-	unsigned long offs;
+	unsigned long offs = reg_nr;
 
-	if (reg_nr == CMSTR) {
-		offs = 0;
-		base -= cfg->channel_offset;
-	} else
-		offs = reg_nr;
-
-	if (p->width == 16)
+	if (p->width == 16) {
 		offs <<= 1;
-	else {
+		return ioread16(base + offs);
+	} else {
 		offs <<= 2;
-		if ((reg_nr == CMCNT) || (reg_nr == CMCOR))
-			return ioread32(base + offs);
+		return ioread32(base + offs);
 	}
-
-	return ioread16(base + offs);
 }
 
 static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_priv *p)
 {
-	return sh_cmt_read(p, CMSTR);
+	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
+
+	return sh_cmt_read16(p->mapbase - cfg->channel_offset, 0);
 }
 
 static inline unsigned long sh_cmt_read_cmcsr(struct sh_cmt_priv *p)
 {
-	return sh_cmt_read(p, CMCSR);
+	return sh_cmt_read16(p->mapbase, CMCSR);
 }
 
 static inline unsigned long sh_cmt_read_cmcnt(struct sh_cmt_priv *p)
@@ -104,39 +106,30 @@ static inline unsigned long sh_cmt_read_
 static inline void sh_cmt_write(struct sh_cmt_priv *p, int reg_nr,
 				unsigned long value)
 {
-	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
 	void __iomem *base = p->mapbase;
-	unsigned long offs;
-
-	if (reg_nr == CMSTR) {
-		offs = 0;
-		base -= cfg->channel_offset;
-	} else
-		offs = reg_nr;
+	unsigned long offs = reg_nr;
 
-	if (p->width == 16)
+	if (p->width == 16) {
 		offs <<= 1;
-	else {
+		iowrite16(value, base + offs);
+	} else {
 		offs <<= 2;
-		if ((reg_nr == CMCNT) || (reg_nr == CMCOR)) {
-			iowrite32(value, base + offs);
-			return;
-		}
+		iowrite32(value, base + offs);
 	}
-
-	iowrite16(value, base + offs);
 }
 
 static inline void sh_cmt_write_cmstr(struct sh_cmt_priv *p,
 				      unsigned long value)
 {
-	sh_cmt_write(p, CMSTR, value);
+	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
+
+	sh_cmt_write16(p->mapbase - cfg->channel_offset, 0, value);
 }
 
 static inline void sh_cmt_write_cmcsr(struct sh_cmt_priv *p,
 				      unsigned long value)
 {
-	sh_cmt_write(p, CMCSR, value);
+	sh_cmt_write16(p->mapbase, CMCSR, value);
 }
 
 static inline void sh_cmt_write_cmcnt(struct sh_cmt_priv *p,
@@ -173,6 +166,7 @@ static unsigned long sh_cmt_get_counter(
 	return v2;
 }
 
+static DEFINE_RAW_SPINLOCK(sh_cmt_lock);
 
 static void sh_cmt_start_stop_ch(struct sh_cmt_priv *p, int start)
 {
