Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab2HaLza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:55:30 -0400
Received: from hulk.biessmann.org ([62.75.166.25]:36315 "EHLO
	hulk.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2HaLz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:55:29 -0400
X-Greylist: delayed 1162 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2012 07:55:29 EDT
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
To: linux-kernel@vger.kernel.org
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-omap@vger.kernel.org,
        =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 2/2] mtd/nand/omap2: fix module loading
Date: Fri, 31 Aug 2012 13:35:42 +0200
Message-Id: <1346412942-4015-3-git-send-email-andreas@biessmann.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346412942-4015-1-git-send-email-andreas@biessmann.de>
References: <1346412942-4015-1-git-send-email-andreas@biessmann.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SPAM_bar: --
X-SPAM_score: -28
X-ChkData-Signature: 29a333cca3031776a1f03073235f7d25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unloading the omap2 nand driver missed to release the memory region which will
result in not being able to request it again if one want to load the driver
later on.

This patch fixes following error when loading omap2 module after unloading:
---8<---
~ $ rmmod omap2
~ $ modprobe omap2
[   37.420928] omap2-nand: probe of omap2-nand.0 failed with error -16
~ $
--->8---

This error was introduced in 67ce04bf2746f8a1f8c2a104b313d20c63f68378 which
was the first commit of this driver.

Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/nand/omap2.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 4cd7ac0..48f1d4e 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1387,6 +1387,7 @@ static int omap_nand_remove(struct platform_device *pdev)
 	/* Release NAND device, its internal structures and partitions */
 	nand_release(&info->mtd);
 	iounmap(info->nand.IO_ADDR_R);
+	release_mem_region(info->phys_base, NAND_IO_SIZE);
 	kfree(info);
 	return 0;
 }
-- 
1.7.10.4

