Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030804Ab2I1TNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:13:42 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54594 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030650Ab2I1TF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:05:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Timur Tabi <timur@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: [ 237/262] powerpc/85xx: p1022ds: disable the NAND flash node if video is enabled
Date: Fri, 28 Sep 2012 11:52:46 -0700
Message-Id: <20120928183026.354225821@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <timur@freescale.com>

commit 6269f2584a359766f53005c676daff8aee60cbed upstream.

The Freescale P1022 has a unique pin muxing "feature" where the DIU video
controller's video signals are muxed with 24 of the local bus address signals.
When the DIU is enabled, the bulk of the local bus is disabled, preventing
access to memory-mapped devices like NAND flash and the pixis FPGA.

Therefore, if the DIU is going to be enabled, then memory-mapped devices on
the localbus, like NAND flash, need to be disabled.

This patch is similar to "powerpc/85xx: p1022ds: disable the NOR flash node
if video is enabled", except that it disables the NAND flash node instead.
This PIXIS node needs to remain enabled because it is used by platform code
to switch into indirect mode.

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/powerpc/platforms/85xx/p1022_ds.c |   38 +++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 9 deletions(-)

--- a/arch/powerpc/platforms/85xx/p1022_ds.c
+++ b/arch/powerpc/platforms/85xx/p1022_ds.c
@@ -435,6 +435,8 @@ static void __init disable_one_node(stru
 		prom_update_property(np, new, old);
 	else
 		prom_add_property(np, new);
+
+	pr_info("p1022ds: disabling %s node\n", np->full_name);
 }
 
 /* TRUE if there is a "video=fslfb" command-line parameter. */
@@ -499,28 +501,46 @@ static void __init p1022_ds_setup_arch(v
 	diu_ops.valid_monitor_port	= p1022ds_valid_monitor_port;
 
 	/*
-	 * Disable the NOR flash node if there is video=fslfb... command-line
-	 * parameter.  When the DIU is active, NOR flash is unavailable, so we
-	 * have to disable the node before the MTD driver loads.
+	 * Disable the NOR and NAND flash nodes if there is video=fslfb...
+	 * command-line parameter.  When the DIU is active, the localbus is
+	 * unavailable, so we have to disable these nodes before the MTD
+	 * driver loads.
 	 */
 	if (fslfb) {
 		struct device_node *np =
 			of_find_compatible_node(NULL, NULL, "fsl,p1022-elbc");
 
 		if (np) {
-			np = of_find_compatible_node(np, NULL, "cfi-flash");
-			if (np) {
+			struct device_node *np2;
+
+			of_node_get(np);
+			np2 = of_find_compatible_node(np, NULL, "cfi-flash");
+			if (np2) {
 				static struct property nor_status = {
 					.name = "status",
 					.value = "disabled",
 					.length = sizeof("disabled"),
 				};
 
-				pr_info("p1022ds: disabling %s node",
-					np->full_name);
-				disable_one_node(np, &nor_status);
-				of_node_put(np);
+				disable_one_node(np2, &nor_status);
+				of_node_put(np2);
+			}
+
+			of_node_get(np);
+			np2 = of_find_compatible_node(np, NULL,
+						      "fsl,elbc-fcm-nand");
+			if (np2) {
+				static struct property nand_status = {
+					.name = "status",
+					.value = "disabled",
+					.length = sizeof("disabled"),
+				};
+
+				disable_one_node(np2, &nand_status);
+				of_node_put(np2);
 			}
+
+			of_node_put(np);
 		}
 
 	}


