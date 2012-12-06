Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847Ab2LFHmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:42:44 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:59917 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784Ab2LFHmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:42:42 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-mtd@lists.infradead.org
Cc: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 1/2] mtd: mxc_nand: fix unbalanced clk_disable() in error path
Date: Thu,  6 Dec 2012 08:42:27 +0100
Message-Id: <1354779748-28869-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If nand_scan_ident() or nand_scan_tail() fails, the NAND chip may have
been deselected and the clock already disabled. Thus, check 'clk_act'
in the error path to decide whether the clock still needs to be
disabled.

This fixes a:
|WARNING: at drivers/clk/clk.c:472 __clk_disable+0x3c/0x78()

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/mtd/nand/mxc_nand.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index d316324..d965809 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -1556,7 +1556,8 @@ static int mxcnd_probe(struct platform_device *pdev)
 	return 0;
 
 escan:
-	clk_disable_unprepare(host->clk);
+	if (host->clk_act)
+		clk_disable_unprepare(host->clk);
 
 	return err;
 }
-- 
1.7.2.5

