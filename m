Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1LMGd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:33:59 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:40386 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab1LMGdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:33:24 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Amit Kucheria <amit.kucheria@canonical.com> (maintainer:ARM/FREESCALE
	IMX51),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 18/19] mbimx51sd: add audio codec support
Date: Tue, 13 Dec 2011 07:31:50 +0100
Message-Id: <1323757911-25217-18-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323757911-25217-1-git-send-email-eric@eukrea.com>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/mach-mx5/Kconfig                    |    1 +
 arch/arm/mach-mx5/eukrea_mbimxsd-baseboard.c |   28 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx5/Kconfig b/arch/arm/mach-mx5/Kconfig
index f318b67..ab700bb 100644
--- a/arch/arm/mach-mx5/Kconfig
+++ b/arch/arm/mach-mx5/Kconfig
@@ -115,6 +115,7 @@ choice
 config MACH_EUKREA_MBIMXSD51_BASEBOARD
 	prompt "Eukrea MBIMXSD development board"
 	bool
+	select IMX_HAVE_PLATFORM_IMX_SSI
 	select IMX_HAVE_PLATFORM_SDHCI_ESDHC_IMX
 	select LEDS_GPIO_REGISTER
 	help
diff --git a/arch/arm/mach-mx5/eukrea_mbimxsd-baseboard.c b/arch/arm/mach-mx5/eukrea_mbimxsd-baseboard.c
index d817fc8..19acca1 100644
--- a/arch/arm/mach-mx5/eukrea_mbimxsd-baseboard.c
+++ b/arch/arm/mach-mx5/eukrea_mbimxsd-baseboard.c
@@ -67,6 +67,11 @@ static iomux_v3_cfg_t eukrea_mbimxsd_pads[] = {
 	NEW_PAD_CTRL(MX51_PAD_GPIO1_0__SD1_CD, PAD_CTL_PUS_22K_UP |
 			PAD_CTL_PKE | PAD_CTL_SRE_FAST |
 			PAD_CTL_DSE_HIGH | PAD_CTL_PUE | PAD_CTL_HYS),
+	/* SSI */
+	MX51_PAD_AUD3_BB_TXD__AUD3_TXD,
+	MX51_PAD_AUD3_BB_RXD__AUD3_RXD,
+	MX51_PAD_AUD3_BB_CK__AUD3_TXC,
+	MX51_PAD_AUD3_BB_FS__AUD3_TXFS,
 };
 
 #define GPIO_LED1	IMX_GPIO_NR(3, 30)
@@ -113,6 +118,11 @@ static struct i2c_board_info eukrea_mbimxsd_i2c_devices[] = {
 	},
 };
 
+static const
+struct imx_ssi_platform_data eukrea_mbimxsd_ssi_pdata __initconst = {
+	.flags = IMX_SSI_SYN | IMX_SSI_NET | IMX_SSI_USE_I2S_SLAVE,
+};
+
 /*
  * system init for baseboard usage. Will be called by cpuimx51sd init.
  *
@@ -125,11 +135,29 @@ void __init eukrea_mbimxsd51_baseboard_init(void)
 			ARRAY_SIZE(eukrea_mbimxsd_pads)))
 		printk(KERN_ERR "error setting mbimxsd pads !\n");
 
+#if defined(CONFIG_SND_SOC_EUKREA_TLV320)
+	/* SSI unit master I2S codec connected to SSI_AUD3 */
+	mxc_audmux_v2_configure_port(0,
+			MXC_AUDMUX_V2_PTCR_SYN |
+			MXC_AUDMUX_V2_PTCR_TFSDIR |
+			MXC_AUDMUX_V2_PTCR_TFSEL(2) |
+			MXC_AUDMUX_V2_PTCR_TCLKDIR |
+			MXC_AUDMUX_V2_PTCR_TCSEL(2),
+			MXC_AUDMUX_V2_PDCR_RXDSEL(2)
+	);
+	mxc_audmux_v2_configure_port(2,
+			MXC_AUDMUX_V2_PTCR_SYN |
+			MXC_AUDMUX_V2_PTCR_TCSEL(0),
+			MXC_AUDMUX_V2_PDCR_RXDSEL(0)
+	);
+#endif
 	imx51_add_imx_uart(1, NULL);
 	imx51_add_imx_uart(2, &uart_pdata);
 
 	imx51_add_sdhci_esdhc_imx(0, NULL);
 
+	imx51_add_imx_ssi(0, &eukrea_mbimxsd_ssi_pdata);
+
 	gpio_request(GPIO_LED1, "LED1");
 	gpio_direction_output(GPIO_LED1, 1);
 	gpio_free(GPIO_LED1);
-- 
1.7.6.4

