Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228Ab2JKC01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:26:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54027 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933397Ab2JKC0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:26:21 -0400
X-Sasl-enc: xgyTP/GoB81T5EET/jUFEPMPUIbYHUKWPTHpb/NXf8G8 1349922380
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: =?UTF-8?q?=5B=2084/84=5D=20mtd=3A=20omap2=3A=20fix=20module=20loading?=
Date: Thu, 11 Oct 2012 11:04:08 +0900
Message-Id: <20121011015432.198516875@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/omap2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1139,6 +1139,7 @@ static int omap_nand_remove(struct platf
 	/* Release NAND device, its internal structures and partitions */
 	nand_release(&info->mtd);
 	iounmap(info->nand.IO_ADDR_R);
+	release_mem_region(info->phys_base, NAND_IO_SIZE);
 	kfree(info);
 	return 0;
 }


