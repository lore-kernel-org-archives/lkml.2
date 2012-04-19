Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab2DSVmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:42:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36240 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448Ab2DSVNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:13:25 -0400
Message-Id: <20120419210614.184773380@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [ 36/59] pch_phub: Care FUNCSEL register in PM
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

commit dd7d7fea29c18b818e94f252a76f495490d399c3 upstream.

Only ML7213/ML7223(Bus-n) has this register.
Currently,this driver doesn't care register "FUNCSEL" in suspend/resume.
This patch saves/restores FUNCSEL register only when the device is ML7213 or
ML7223(Bus-n).

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/pch_phub.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -93,6 +93,7 @@
 #define PCH_PHUB_INTPIN_REG_WPERMIT_REG3	0x002C
 #define PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE	0x0040
 #define CLKCFG_REG_OFFSET			0x500
+#define FUNCSEL_REG_OFFSET			0x508
 
 #define PCH_PHUB_OROM_SIZE 15360
 
@@ -111,6 +112,7 @@
  * @intpin_reg_wpermit_reg3:		INTPIN_REG_WPERMIT register 3 val
  * @int_reduce_control_reg:		INT_REDUCE_CONTROL registers val
  * @clkcfg_reg:				CLK CFG register val
+ * @funcsel_reg:			Function select register value
  * @pch_phub_base_address:		Register base address
  * @pch_phub_extrom_base_address:	external rom base address
  * @pch_mac_start_address:		MAC address area start address
@@ -131,6 +133,7 @@ struct pch_phub_reg {
 	u32 intpin_reg_wpermit_reg3;
 	u32 int_reduce_control_reg[MAX_NUM_INT_REDUCE_CONTROL_REG];
 	u32 clkcfg_reg;
+	u32 funcsel_reg;
 	void __iomem *pch_phub_base_address;
 	void __iomem *pch_phub_extrom_base_address;
 	u32 pch_mac_start_address;
@@ -214,6 +217,8 @@ static void pch_phub_save_reg_conf(struc
 			__func__, i, chip->int_reduce_control_reg[i]);
 	}
 	chip->clkcfg_reg = ioread32(p + CLKCFG_REG_OFFSET);
+	if ((chip->ioh_type == 2) || (chip->ioh_type == 4))
+		chip->funcsel_reg = ioread32(p + FUNCSEL_REG_OFFSET);
 }
 
 /* pch_phub_restore_reg_conf - restore register configuration */
@@ -274,6 +279,8 @@ static void pch_phub_restore_reg_conf(st
 	}
 
 	iowrite32(chip->clkcfg_reg, p + CLKCFG_REG_OFFSET);
+	if ((chip->ioh_type == 2) || (chip->ioh_type == 4))
+		iowrite32(chip->funcsel_reg, p + FUNCSEL_REG_OFFSET);
 }
 
 /**


