Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2LNFtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:49:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2LNFtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:49:45 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, johnstul@us.ibm.com, horms@verge.net.au,
        shinya.kuribayashi.px@renesas.com, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Fri, 14 Dec 2012 14:54:19 +0900
Message-Id: <20121214055419.10081.15178.sendpatchset@w520>
In-Reply-To: <20121214055323.10081.12056.sendpatchset@w520>
References: <20121214055323.10081.12056.sendpatchset@w520>
Subject: [PATCH 06/08] clocksource: sh_cmt: CMCNT and CMCOR register access update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Break out the CMCNT and CMCOR register access code
into separate 16-bit and 32-bit functions that are
hooked into callbacks at init time. This reduces
the amount of software calculations happening at
runtime.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/clocksource/sh_cmt.c |   62 +++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 36 deletions(-)

--- 0006/drivers/clocksource/sh_cmt.c
+++ work/drivers/clocksource/sh_cmt.c	2012-12-14 13:00:20.000000000 +0900
@@ -54,38 +54,39 @@ struct sh_cmt_priv {
 	struct clocksource cs;
 	unsigned long total_cycles;
 	bool cs_enabled;
+
+	/* callbacks for CMCNT and CMCOR access */
+	unsigned long (*read_count)(void __iomem *base, unsigned long offs);
+	void (*write_count)(void __iomem *base, unsigned long offs,
+			    unsigned long value);
 };
 
-static inline unsigned long sh_cmt_read16(void __iomem *base,
-					  unsigned long offs)
+static unsigned long sh_cmt_read16(void __iomem *base, unsigned long offs)
 {
 	return ioread16(base + (offs << 1));
 }
 
-static inline void sh_cmt_write16(void __iomem *base, unsigned long offs,
-				  unsigned long value)
+static unsigned long sh_cmt_read32(void __iomem *base, unsigned long offs)
+{
+	return ioread32(base + (offs << 2));
+}
+
+static void sh_cmt_write16(void __iomem *base, unsigned long offs,
+			   unsigned long value)
 {
 	iowrite16(value, base + (offs << 1));
 }
 
+static void sh_cmt_write32(void __iomem *base, unsigned long offs,
+			   unsigned long value)
+{
+	iowrite32(value, base + (offs << 2));
+}
+
 #define CMCSR 0 /* channel register */
 #define CMCNT 1 /* channel register */
 #define CMCOR 2 /* channel register */
 
-static inline unsigned long sh_cmt_read(struct sh_cmt_priv *p, int reg_nr)
-{
-	void __iomem *base = p->mapbase;
-	unsigned long offs = reg_nr;
-
-	if (p->width == 16) {
-		offs <<= 1;
-		return ioread16(base + offs);
-	} else {
-		offs <<= 2;
-		return ioread32(base + offs);
-	}
-}
-
 static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_priv *p)
 {
 	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
@@ -100,22 +101,7 @@ static inline unsigned long sh_cmt_read_
 
 static inline unsigned long sh_cmt_read_cmcnt(struct sh_cmt_priv *p)
 {
-	return sh_cmt_read(p, CMCNT);
-}
-
-static inline void sh_cmt_write(struct sh_cmt_priv *p, int reg_nr,
-				unsigned long value)
-{
-	void __iomem *base = p->mapbase;
-	unsigned long offs = reg_nr;
-
-	if (p->width == 16) {
-		offs <<= 1;
-		iowrite16(value, base + offs);
-	} else {
-		offs <<= 2;
-		iowrite32(value, base + offs);
-	}
+	return p->read_count(p->mapbase, CMCNT);
 }
 
 static inline void sh_cmt_write_cmstr(struct sh_cmt_priv *p,
@@ -135,13 +121,13 @@ static inline void sh_cmt_write_cmcsr(st
 static inline void sh_cmt_write_cmcnt(struct sh_cmt_priv *p,
 				      unsigned long value)
 {
-	sh_cmt_write(p, CMCNT, value);
+	p->write_count(p->mapbase, CMCNT, value);
 }
 
 static inline void sh_cmt_write_cmcor(struct sh_cmt_priv *p,
 				      unsigned long value)
 {
-	sh_cmt_write(p, CMCOR, value);
+	p->write_count(p->mapbase, CMCOR, value);
 }
 
 static unsigned long sh_cmt_get_counter(struct sh_cmt_priv *p,
@@ -718,10 +704,14 @@ static int sh_cmt_setup(struct sh_cmt_pr
 
 	if (resource_size(res) == 6) {
 		p->width = 16;
+		p->read_count = sh_cmt_read16;
+		p->write_count = sh_cmt_write16;
 		p->overflow_bit = 0x80;
 		p->clear_bits = ~0x80;
 	} else {
 		p->width = 32;
+		p->read_count = sh_cmt_read32;
+		p->write_count = sh_cmt_write32;
 		p->overflow_bit = 0x8000;
 		p->clear_bits = ~0xc000;
 	}
