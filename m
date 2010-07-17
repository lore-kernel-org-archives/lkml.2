Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab0GQPTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 11:19:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59997 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759999Ab0GQPTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 11:19:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ry052Wx/pp3MzxsxcX0ZJ8zBHUv83prX4FaaCV3hSkuoegZYc3Q64qWppp6dmQdx2F
         4o3xcC+YFahCxG0CC1j9/IDvYVcp1ixp1phccpDqyIVGB9/cDRUFHvTjgENL5e60YbxS
         GLDEC7oENR352BuZ5wSB/9Glwc24DC16s/Az4=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Kevin Hilman <davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sandeep Paulraj <s-paulraj@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] arm: mach-davinci: check irq2ctlr() result
Date: Sat, 17 Jul 2010 19:19:07 +0400
Message-Id: <1279379947-15152-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If irq2ctlr() fails return IRQ_NONE.
Also as it can fail make 'ctlr' signed.


The semantic patch that finds this problem (many false-positive results):
(http://coccinelle.lip6.fr/)

// <smpl>
@ r1 @
identifier f;
@@
int f(...) { ... }

@@
identifier r1.f;
type T;
unsigned T x;
@@

*x = f(...)
 ...
*x > 0


Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/arm/mach-davinci/dma.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/dma.c b/arch/arm/mach-davinci/dma.c
index d33827a..d1127e1 100644
--- a/arch/arm/mach-davinci/dma.c
+++ b/arch/arm/mach-davinci/dma.c
@@ -344,10 +344,12 @@ static int irq2ctlr(int irq)
 static irqreturn_t dma_irq_handler(int irq, void *data)
 {
 	int i;
-	unsigned ctlr;
+	int ctlr;
 	unsigned int cnt = 0;
 
 	ctlr = irq2ctlr(irq);
+	if (ctlr < 0)
+		return IRQ_NONE;
 
 	dev_dbg(data, "dma_irq_handler\n");
 
@@ -398,10 +400,12 @@ static irqreturn_t dma_irq_handler(int irq, void *data)
 static irqreturn_t dma_ccerr_handler(int irq, void *data)
 {
 	int i;
-	unsigned ctlr;
+	int ctlr;
 	unsigned int cnt = 0;
 
 	ctlr = irq2ctlr(irq);
+	if (ctlr < 0)
+		return IRQ_NONE;
 
 	dev_dbg(data, "dma_ccerr_handler\n");
 
-- 
1.7.0.4

