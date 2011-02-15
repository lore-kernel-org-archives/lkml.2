Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1BOGLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:11:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45219 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1BOGLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:11:46 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-omap@vger.kernel.org,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Shishkin <virtuoso@slind.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] ARM: etm: Don't require clock control
Date: Mon, 14 Feb 2011 22:11:09 -0800
Message-Id: <1297750276-12475-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1296701663-12168-1-git-send-email-arve@android.com>
References: <1296701663-12168-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If clk_get fail, assume the etb does not need a separate clock.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 arch/arm/kernel/etm.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 11db628..d4ec368 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -361,13 +361,12 @@ static int __init etb_probe(struct amba_device *dev, struct amba_id *id)
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
@@ -402,8 +401,10 @@ static int etb_remove(struct amba_device *dev)
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
1.7.3.1

