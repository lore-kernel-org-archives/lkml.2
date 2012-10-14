Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2JNO7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:59:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46504 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932183Ab2JNOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:24 -0400
Message-Id: <20121014143544.624496464@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 080/147] mtd: omap2: fix module loading
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Bießmann <andreas@biessmann.de>

commit 4d3d688da8e7016f15483e9319b41311e1db9515 upstream.

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
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/nand/omap2.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index e604a45..9142005 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1364,6 +1364,7 @@ static int omap_nand_remove(struct platform_device *pdev)
 	/* Release NAND device, its internal structures and partitions */
 	nand_release(&info->mtd);
 	iounmap(info->nand.IO_ADDR_R);
+	release_mem_region(info->phys_base, NAND_IO_SIZE);
 	kfree(info);
 	return 0;
 }


