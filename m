Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407Ab2BJWlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:41:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50022 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760556Ab2BJWlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:12 -0500
MIME-Version: 1.0
Message-Id: <20120210222947.191721128@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Huang Shijie <b32955@freescale.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [patch 24/86] mtd: gpmi-nand bugfix: reset the BCH module when it is not MX23
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Shijie <b32955@freescale.com>

commit 9398d1ce09b9009996f7d2468e1d3c785fa6feda upstream.

In MX28, if we do not reset the BCH module. The BCH module may
becomes unstable when the board reboots for several thousands times.
This bug has been catched in customer's production.

The patch adds some comments (some from Wolfram Sang), and fixes it now.

Also change gpmi_reset_block() to static.

Signed-off-by: Huang Shijie <b32955@freescale.com>
Acked-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -69,17 +69,19 @@ static int clear_poll_bit(void __iomem *
  *  [1] enable the module.
  *  [2] reset the module.
  *
- * In most of the cases, it's ok. But there is a hardware bug in the BCH block.
+ * In most of the cases, it's ok.
+ * But in MX23, there is a hardware bug in the BCH block (see erratum #2847).
  * If you try to soft reset the BCH block, it becomes unusable until
  * the next hard reset. This case occurs in the NAND boot mode. When the board
  * boots by NAND, the ROM of the chip will initialize the BCH blocks itself.
  * So If the driver tries to reset the BCH again, the BCH will not work anymore.
- * You will see a DMA timeout in this case.
+ * You will see a DMA timeout in this case. The bug has been fixed
+ * in the following chips, such as MX28.
  *
  * To avoid this bug, just add a new parameter `just_enable` for
  * the mxs_reset_block(), and rewrite it here.
  */
-int gpmi_reset_block(void __iomem *reset_addr, bool just_enable)
+static int gpmi_reset_block(void __iomem *reset_addr, bool just_enable)
 {
 	int ret;
 	int timeout = 0x400;
@@ -206,7 +208,15 @@ int bch_set_geometry(struct gpmi_nand_da
 	if (ret)
 		goto err_out;
 
-	ret = gpmi_reset_block(r->bch_regs, true);
+	/*
+	* Due to erratum #2847 of the MX23, the BCH cannot be soft reset on this
+	* chip, otherwise it will lock up. So we skip resetting BCH on the MX23.
+	* On the other hand, the MX28 needs the reset, because one case has been
+	* seen where the BCH produced ECC errors constantly after 10000
+	* consecutive reboots. The latter case has not been seen on the MX23 yet,
+	* still we don't know if it could happen there as well.
+	*/
+	ret = gpmi_reset_block(r->bch_regs, GPMI_IS_MX23(this));
 	if (ret)
 		goto err_out;
 


