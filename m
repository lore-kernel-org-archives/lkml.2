Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab2FTWtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:49:51 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33734 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab2FTWts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:49:48 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 01/15] ARM: etm: Don't require clock control
Date: Wed, 20 Jun 2012 18:47:33 -0400
Message-Id: <1340232467-6023-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062022-2398-0000-0000-000007B78DE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

If clk_get fail, assume the etb does not need a separate clock.

CC: Russell King <linux@arm.linux.org.uk>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/arm/kernel/etm.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 36d20bd..bd295e8 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -362,13 +362,12 @@ static int __devinit etb_probe(struct amba_device *dev, const struct amba_id *id
 	if (ret)
 		goto out_unmap;
 
+	/* Get optional clock. Currently used to select clock source on omap3 */
 	t->emu_clk = clk_get(&dev->dev, "emu_src_ck");
-	if (IS_ERR(t->emu_clk)) {
+	if (IS_ERR(t->emu_clk))
 		dev_dbg(&dev->dev, "Failed to obtain emu_src_ck.\n");
-		return -EFAULT;
-	}
-
-	clk_enable(t->emu_clk);
+	else
+		clk_enable(t->emu_clk);
 
 	etb_unlock(t);
 	t->etb_bufsz = etb_readl(t, ETBR_DEPTH);
@@ -403,8 +402,10 @@ static int etb_remove(struct amba_device *dev)
 	iounmap(t->etb_regs);
 	t->etb_regs = NULL;
 
-	clk_disable(t->emu_clk);
-	clk_put(t->emu_clk);
+	if (!IS_ERR(t->emu_clk)) {
+		clk_disable(t->emu_clk);
+		clk_put(t->emu_clk);
+	}
 
 	amba_release_regions(dev);
 
-- 
1.7.9.5

