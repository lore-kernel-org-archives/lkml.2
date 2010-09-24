Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0IXLaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 07:30:52 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45365 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab0IXLav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 07:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FtgGhABTUCMTKnYDPWwoiMIlC+WaFFfdhjuwU0XSNckO54x7FJQtPaMy0gHtVhKlgv
         bHnDRDKMDMzGqJTQe5rsa7CJscnH9mynM+y+2aTkf0yFHjMNCsHWySg5CEstPd8ey7re
         y95P+e0rNVYgWUtZkPceEA9tbsxk5Er2xZJrU=
From: Huang Shijie <shijie8@gmail.com>
To: David.Woodhouse@intel.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH] mtd : add init_size hook for NAND driver
Date: Fri, 24 Sep 2010 19:34:23 +0800
Message-Id: <1285328063-7982-1-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all the NAND devices have all the information in additional
id bytes.

So add a hook in the nand_chip{} is a good method to calculate the
right value of oobsize, erasesize and so on.

Without the hook,you will get the wrong value, and you have to hack
in the ->scan_bbt() to change the wrong value which make the code
mess.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/mtd/nand/nand_base.c |    6 ++++--
 include/linux/mtd/nand.h     |    5 +++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index d551ddd..0288f1f 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2848,8 +2848,10 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 
 	chip->chipsize = (uint64_t)type->chipsize << 20;
 
-	/* Newer devices have all the information in additional id bytes */
-	if (!type->pagesize) {
+	if (!type->pagesize && chip->init_size) {
+		/* set the pagesize, oobsize, erasesize by the driver*/
+		busw = chip->init_size(mtd, chip);
+	} else if (!type->pagesize) {
 		int extid;
 		/* The 3rd id byte holds MLC / multichip data */
 		chip->cellinfo = id_data[2];
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 102e12c..2296a7a 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -332,6 +332,9 @@ struct nand_buffers {
  * @block_markbad:	[REPLACEABLE] mark the block bad
  * @cmd_ctrl:		[BOARDSPECIFIC] hardwarespecific funtion for controlling
  *			ALE/CLE/nCE. Also used to write command and address
+ * @init_size:		[BOARDSPECIFIC] hardwarespecific funtion for setting
+ *			mtd->oobsize, mtd->writesize and so on.
+ *			Return with the bus width.
  * @dev_ready:		[BOARDSPECIFIC] hardwarespecific function for accesing device ready/busy line
  *			If set to NULL no access to ready/busy is available and the ready/busy information
  *			is read from the chip status register
@@ -386,6 +389,8 @@ struct nand_chip {
 	int		(*block_markbad)(struct mtd_info *mtd, loff_t ofs);
 	void		(*cmd_ctrl)(struct mtd_info *mtd, int dat,
 				    unsigned int ctrl);
+	int		(*init_size)(struct mtd_info *mtd,
+					struct nand_chip *this);
 	int		(*dev_ready)(struct mtd_info *mtd);
 	void		(*cmdfunc)(struct mtd_info *mtd, unsigned command, int column, int page_addr);
 	int		(*waitfunc)(struct mtd_info *mtd, struct nand_chip *this);
-- 
1.7.2.2

