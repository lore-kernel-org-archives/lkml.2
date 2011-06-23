Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814Ab1FWR6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:58:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:35085 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab1FWRhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 169/247] MIPS: MTX-1: Make au1000_eth probe all PHY addresses
Date: Thu, 23 Jun 2011 13:33:57 -0400
Message-Id: <1308850515-15242-110-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <florian@openwrt.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bf3a1eb85967dcbaae42f4fcb53c2392cec32677 upstream.

When au1000_eth probes the MII bus for PHY address, if we do not set
au1000_eth platform data's phy_search_highest_address, the MII probing
logic will exit early and will assume a valid PHY is found at address 0.
For MTX-1, the PHY is at address 31, and without this patch, the link
detection/speed/duplex would not work correctly.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
To: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/2111/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/mips/alchemy/mtx-1/platform.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/mips/alchemy/mtx-1/platform.c b/arch/mips/alchemy/mtx-1/platform.c
index e30e42a..956f946 100644
--- a/arch/mips/alchemy/mtx-1/platform.c
+++ b/arch/mips/alchemy/mtx-1/platform.c
@@ -28,6 +28,8 @@
 #include <linux/mtd/physmap.h>
 #include <mtd/mtd-abi.h>
 
+#include <asm/mach-au1x00/au1xxx_eth.h>
+
 static struct gpio_keys_button mtx1_gpio_button[] = {
 	{
 		.gpio = 207,
@@ -140,10 +142,17 @@ static struct __initdata platform_device * mtx1_devs[] = {
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
-- 
1.7.4.4

