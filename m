Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2JJG1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 02:27:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64466 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab2JJG1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 02:27:06 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marex@denx.de>
Subject: [PATCH for 3.7] mtd: nand: fix Samsung SLC NAND identification regression
Date: Tue,  9 Oct 2012 23:26:06 -0700
Message-Id: <1349850366-4731-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A combination of the following two commits caused a regression in 3.7-rc1
when identifying some Samsung NAND, so that some previously working NAND
were no longer detected properly:

    commit e3b88bd604283ef83ae6e8f53622d5b1ffe9d43a
    mtd: nand: add generic READ ID length calculation functions

    commit e2d3a35ee427aaba99b6c68a56609ce276c51270
    mtd: nand: detect Samsung K9GBG08U0A, K9GAG08U0F ID

Particularly, a regression was seen on Samsung K9F2G08U0B, with the
following full 8-byte READ ID string:

    ec da 10 95 44 00 ec da

The basic problem is that Samsung manufactures both SLC and MLC NAND
that use a non-standard decoding table for deriving information from
their IDs. I have heuristically determined that all the chips that use
the new table have ID strings which wrap around after the 6th byte.
Unfortunately, I overlooked the fact that some older Samsung SLC (which
use a different decoding table) have "5 byte ID strings" which also wrap
around after the 6th byte.

This patch re-introduces a distinction between these old and new Samsung
NAND by checking that the 6th byte is non-zero, allowing both old and
new Samsung NAND to be detected properly.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Tested-by: Brian Norris <computersforpeace@gmail.com>
Reported-by: Marek Vasut <marex@denx.de>
Tested-by: Marek Vasut <marex@denx.de>
---
David,

Marek and I just discovered this issue during the merge window. Please merge
this fix in the 3.7-rc cycle. Thanks.

 drivers/mtd/nand/nand_base.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index ec6841d..d5ece6e 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2983,13 +2983,14 @@ static void nand_decode_ext_id(struct mtd_info *mtd, struct nand_chip *chip,
 	/*
 	 * Field definitions are in the following datasheets:
 	 * Old style (4,5 byte ID): Samsung K9GAG08U0M (p.32)
-	 * New style   (6 byte ID): Samsung K9GAG08U0F (p.44)
+	 * New Samsung (6 byte ID): Samsung K9GAG08U0F (p.44)
 	 * Hynix MLC   (6 byte ID): Hynix H27UBG8T2B (p.22)
 	 *
-	 * Check for ID length, cell type, and Hynix/Samsung ID to decide what
-	 * to do.
+	 * Check for ID length, non-zero 6th byte, cell type, and Hynix/Samsung
+	 * ID to decide what to do.
 	 */
-	if (id_len == 6 && id_data[0] == NAND_MFR_SAMSUNG) {
+	if (id_len == 6 && id_data[0] == NAND_MFR_SAMSUNG &&
+			id_data[5] != 0x00) {
 		/* Calc pagesize */
 		mtd->writesize = 2048 << (extid & 0x03);
 		extid >>= 2;
-- 
1.7.11.3

