Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab2FDB4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 21:56:42 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:22582
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462Ab2FDB4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 21:56:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Richard Zhao <richard.zhao@freescale.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <sameo@linux.intel.com>, <paul.liu@linaro.org>, <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>
Subject: [PATCH RESEND] mfd: anatop: permit adata be NULL when access register
Date: Mon, 4 Jun 2012 09:56:29 +0800
Message-ID: <1338774989-4416-1-git-send-email-richard.zhao@freescale.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Zhao <richard.zhao@linaro.org>

It makes anatop register access easier. Anatop has many misc registers,
which may not be a specific driver.

There's only one anatop device for a running system, so we use a global
variable to store struct anatop.

Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
Cc: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
---
 drivers/mfd/anatop-mfd.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/anatop-mfd.c b/drivers/mfd/anatop-mfd.c
index 6da0634..60d59cb 100644
--- a/drivers/mfd/anatop-mfd.c
+++ b/drivers/mfd/anatop-mfd.c
@@ -41,8 +41,15 @@
 #include <linux/of_address.h>
 #include <linux/mfd/anatop.h>
 
+/* For any running system, there's only one anatop device. */
+static struct anatop *anatop_data;
+
 u32 anatop_read_reg(struct anatop *adata, u32 addr)
 {
+	BUG_ON(!anatop_data);
+	if (!adata)
+		adata = anatop_data;
+
 	return readl(adata->ioreg + addr);
 }
 EXPORT_SYMBOL_GPL(anatop_read_reg);
@@ -51,6 +58,10 @@ void anatop_write_reg(struct anatop *adata, u32 addr, u32 data, u32 mask)
 {
 	u32 val;
 
+	BUG_ON(!anatop_data);
+	if (!adata)
+		adata = anatop_data;
+
 	data &= mask;
 
 	spin_lock(&adata->reglock);
@@ -83,6 +94,7 @@ static int __devinit of_anatop_probe(struct platform_device *pdev)
 	drvdata->ioreg = ioreg;
 	spin_lock_init(&drvdata->reglock);
 	platform_set_drvdata(pdev, drvdata);
+	anatop_data = drvdata;
 	of_platform_populate(np, of_anatop_match, NULL, dev);
 
 	return 0;
-- 
1.7.5.4


