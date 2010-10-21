Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab0JUVCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:02:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52363 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758000Ab0JUVB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:01:58 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Cc: Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v3 05/12] davinci: add spi devices on tnetv107x evm
Date: Thu, 21 Oct 2010 17:01:06 -0400
Message-Id: <1287694873-12904-6-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287694873-12904-1-git-send-email-cyril@ti.com>
References: <1287694873-12904-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds definitions for spi devices on the tnetv107x evm platform.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/board-tnetv107x-evm.c |   45 +++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index 401ad26..c37c5c6 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -25,6 +25,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/input.h>
 #include <linux/input/matrix_keypad.h>
+#include <linux/spi/spi.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -38,6 +39,7 @@
 
 #define EVM_MMC_WP_GPIO		21
 #define EVM_MMC_CD_GPIO		24
+#define EVM_SPI_CS_GPIO		54
 
 static int initialize_gpio(int gpio, char *desc)
 {
@@ -203,9 +205,47 @@ static struct matrix_keypad_platform_data keypad_config = {
 	.no_autorepeat	= 0,
 };
 
+static void spi_select_device(int cs)
+{
+	static int gpio;
+
+	if (!gpio) {
+		int ret;
+		ret = gpio_request(EVM_SPI_CS_GPIO, "spi chipsel");
+		if (ret < 0) {
+			pr_err("cannot open spi chipsel gpio\n");
+			gpio = -ENOSYS;
+			return;
+		} else {
+			gpio = EVM_SPI_CS_GPIO;
+			gpio_direction_output(gpio, 0);
+		}
+	}
+
+	if (gpio < 0)
+		return;
+
+	return gpio_set_value(gpio, cs ? 1 : 0);
+}
+
+static const struct ti_ssp_spi_data spi_master_data = {
+	.num_cs		= 2,
+	.select		= spi_select_device,
+};
+
 static struct ti_ssp_data ssp_config = {
 	.out_clock	= 250 * 1000,
 	.dev_data	= {
+		[1] = {
+			.dev_name = "ti-ssp-spi",
+			.iosel = SSP_PIN_SEL(0, SSP_CLOCK)	|
+				 SSP_PIN_SEL(1, SSP_DATA)	|
+				 SSP_PIN_SEL(2, SSP_CHIPSEL)	|
+				 SSP_PIN_SEL(3, SSP_IN)		|
+				 SSP_INPUT_SEL(3),
+			.pdata = &spi_master_data,
+			.pdata_sz = sizeof(spi_master_data),
+		},
 	},
 };
 
@@ -217,6 +257,9 @@ static struct tnetv107x_device_info evm_device_info __initconst = {
 	.ssp_config		= &ssp_config,
 };
 
+static struct spi_board_info spi_info[] __initconst = {
+};
+
 static __init void tnetv107x_evm_board_init(void)
 {
 	davinci_cfg_reg_list(sdio1_pins);
@@ -224,6 +267,8 @@ static __init void tnetv107x_evm_board_init(void)
 	davinci_cfg_reg_list(ssp_pins);
 
 	tnetv107x_devices_init(&evm_device_info);
+
+	spi_register_board_info(spi_info, ARRAY_SIZE(spi_info));
 }
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
-- 
1.7.0.4

