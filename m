Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1BCCy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:54:58 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57204 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab1BCCy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:54:57 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alexander Shishkin <virtuoso@slind.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ARM: etm: Don't require clock control
Date: Wed,  2 Feb 2011 18:54:19 -0800
Message-Id: <1296701663-12168-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If clk_get fail, assume the etb does not need a separate clock.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 arch/arm/kernel/etm.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 11db628..308b733 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -362,12 +362,10 @@ static int __init etb_probe(struct amba_device *dev, struct amba_id *id)
 		goto out_unmap;
 
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
@@ -402,8 +400,10 @@ static int etb_remove(struct amba_device *dev)
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

