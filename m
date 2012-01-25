Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab2AYKkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 05:40:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40256 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab2AYKkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 05:40:04 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Sekhar Nori <nsekhar@ti.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH v2 3/3] arm: da830: move NAND and NOR devices as aemif MFD slaves
Date: Wed, 25 Jan 2012 15:55:56 +0530
Message-ID: <1327487156-10238-3-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1327487156-10238-1-git-send-email-prakash.pm@ti.com>
References: <1327487156-10238-1-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAND and NOR device are made as aemif devices slave, hence device
registration achieved via aemif MFD driver.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
Since v1:
Patch is generated using -M option.

 arch/arm/mach-davinci/board-da830-evm.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index 0b43554..0ad3662 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -396,14 +396,29 @@ static struct resource da830_evm_nand_resources[] = {
 	},
 };
 
-static struct platform_device da830_evm_nand_device = {
-	.name		= "davinci_nand",
-	.id		= 1,
-	.dev		= {
-		.platform_data	= &da830_evm_nand_pdata,
+static struct platform_device da830_evm_devices[] __initdata = {
+	{
+		.name		= "davinci_nand",
+		.id		= 1,
+		.dev		= {
+			.platform_data	= &da830_evm_nand_pdata,
+		},
+		.num_resources	= ARRAY_SIZE(da830_evm_nand_resources),
+		.resource	= da830_evm_nand_resources,
+	},
+};
+
+static struct davinci_aemif_devices da830_emif_devices = {
+	.devices	= da830_evm_devices,
+	.num_devices	= ARRAY_SIZE(da830_evm_devices),
+};
+
+static struct platform_device davinci_emif_device = {
+	.name	= "davinci_aemif",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &da830_emif_devices,
 	},
-	.num_resources	= ARRAY_SIZE(da830_evm_nand_resources),
-	.resource	= da830_evm_nand_resources,
 };
 
 static inline void da830_evm_init_nand(int mux_mode)
@@ -422,7 +437,7 @@ static inline void da830_evm_init_nand(int mux_mode)
 		pr_warning("da830_evm_init: emif25 mux setup failed: %d\n",
 				ret);
 
-	ret = platform_device_register(&da830_evm_nand_device);
+	ret = platform_device_register(&davinci_emif_device);
 	if (ret)
 		pr_warning("da830_evm_init: NAND device not registered.\n");
 
-- 
1.7.1

