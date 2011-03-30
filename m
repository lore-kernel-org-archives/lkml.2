Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081Ab1C3V2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:28:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:12876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933639Ab1C3VJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735928"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: florian@openwrt.org, ak@linux.intel.com, ralf@linux-mips.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [187/275] MIPS: MTX-1: Make au1000_eth probe all PHY addresses
Message-Id: <20110330210710.9656B3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Florian Fainelli <florian@openwrt.org>

commit bf3a1eb85967dcbaae42f4fcb53c2392cec32677 upstream.

When au1000_eth probes the MII bus for PHY address, if we do not set
au1000_eth platform data's phy_search_highest_address, the MII probing
logic will exit early and will assume a valid PHY is found at address 0.
For MTX-1, the PHY is at address 31, and without this patch, the link
detection/speed/duplex would not work correctly.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
To: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/2111/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mips/alchemy/mtx-1/platform.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.35.y/arch/mips/alchemy/mtx-1/platform.c
===================================================================
--- linux-2.6.35.y.orig/arch/mips/alchemy/mtx-1/platform.c	2011-03-29 22:50:47.044054680 -0700
+++ linux-2.6.35.y/arch/mips/alchemy/mtx-1/platform.c	2011-03-29 23:03:02.147245227 -0700
@@ -28,6 +28,8 @@
 #include <linux/mtd/physmap.h>
 #include <mtd/mtd-abi.h>
 
+#include <asm/mach-au1x00/au1xxx_eth.h>
+
 static struct gpio_keys_button mtx1_gpio_button[] = {
 	{
 		.gpio = 207,
@@ -140,10 +142,17 @@
 	&mtx1_mtd,
 };
 
+static struct au1000_eth_platform_data mtx1_au1000_eth0_pdata = {
+	.phy_search_highest_addr	= 1,
+	.phy1_search_mac0 		= 1,
+};
+
 static int __init mtx1_register_devices(void)
 {
 	int rc;
 
+	au1xxx_override_eth_cfg(0, &mtx1_au1000_eth0_pdata);
+
 	rc = gpio_request(mtx1_gpio_button[0].gpio,
 					mtx1_gpio_button[0].desc);
 	if (rc < 0) {
