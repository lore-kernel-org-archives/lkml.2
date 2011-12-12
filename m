Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1LLD2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:28:52 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19009 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1LLD2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:28:37 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202hzz8275bhz2ei87h2a8h668h839hb79i61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <sonic.adi@gmail.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, Bob Liu <lliubbo@gmail.com>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 02/11] blackfin: bf533-stamp: add missed patches for new asoc driver
Date: Mon, 12 Dec 2011 11:28:24 +0800
Message-ID: <1323660513-9620-2-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
References: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASoC drivers changed between 2.6.37 and 3.0, but we didn't apply these changes
in bf533 board file.

So apply missed patches for asoc since 2.6.37 together.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 arch/blackfin/mach-bf533/boards/stamp.c |  168 +++++++++++++++++++++++++++++--
 1 files changed, 160 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index d12d4de..2ba4d0b 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -541,27 +541,150 @@ static struct platform_device bfin_dpmc = {
 	},
 };
 
+#if defined(CONFIG_SND_BF5XX_I2S) || defined(CONFIG_SND_BF5XX_I2S_MODULE) || \
+	defined(CONFIG_SND_BF5XX_TDM) || defined(CONFIG_SND_BF5XX_TDM_MODULE) \
+	|| defined(CONFIG_SND_BF5XX_AC97) || \
+	defined(CONFIG_SND_BF5XX_AC97_MODULE)
+
+#include <asm/bfin_sport.h>
+
+#define SPORT_REQ(x) \
+	[x] = {P_SPORT##x##_TFS, P_SPORT##x##_DTPRI, P_SPORT##x##_TSCLK, \
+		P_SPORT##x##_RFS, P_SPORT##x##_DRPRI, P_SPORT##x##_RSCLK, 0}
+
+static const u16 bfin_snd_pin[][7] = {
+	SPORT_REQ(0),
+	SPORT_REQ(1),
+};
+
+static struct bfin_snd_platform_data bfin_snd_data[] = {
+	{
+		.pin_req = &bfin_snd_pin[0][0],
+	},
+	{
+		.pin_req = &bfin_snd_pin[1][0],
+	},
+};
+
+#define BFIN_SND_RES(x) \
+	[x] = { \
+		{ \
+			.start = SPORT##x##_TCR1, \
+			.end = SPORT##x##_TCR1, \
+			.flags = IORESOURCE_MEM \
+		}, \
+		{ \
+			.start = CH_SPORT##x##_RX, \
+			.end = CH_SPORT##x##_RX, \
+			.flags = IORESOURCE_DMA, \
+		}, \
+		{ \
+			.start = CH_SPORT##x##_TX, \
+			.end = CH_SPORT##x##_TX, \
+			.flags = IORESOURCE_DMA, \
+		}, \
+		{ \
+			.start = IRQ_SPORT##x##_ERROR, \
+			.end = IRQ_SPORT##x##_ERROR, \
+			.flags = IORESOURCE_IRQ, \
+		} \
+	}
+
+static struct resource bfin_snd_resources[][4] = {
+	BFIN_SND_RES(0),
+	BFIN_SND_RES(1),
+};
+#endif
+
 #if defined(CONFIG_SND_BF5XX_I2S) || defined(CONFIG_SND_BF5XX_I2S_MODULE)
+static struct platform_device bfin_i2s_pcm = {
+	.name = "bfin-i2s-pcm-audio",
+	.id = -1,
+};
+#endif
+
+#if defined(CONFIG_SND_BF5XX_TDM) || defined(CONFIG_SND_BF5XX_TDM_MODULE)
+static struct platform_device bfin_tdm_pcm = {
+	.name = "bfin-tdm-pcm-audio",
+	.id = -1,
+};
+#endif
+
+#if defined(CONFIG_SND_BF5XX_AC97) || defined(CONFIG_SND_BF5XX_AC97_MODULE)
+static struct platform_device bfin_ac97_pcm = {
+	.name = "bfin-ac97-pcm-audio",
+	.id = -1,
+};
+#endif
+
+#if defined(CONFIG_SND_BF5XX_SOC_AD73311) || \
+	defined(CONFIG_SND_BF5XX_SOC_AD73311_MODULE)
+static const unsigned ad73311_gpio[] = {
+	GPIO_PF4,
+};
+
+static struct platform_device bfin_ad73311_machine = {
+	.name = "bfin-snd-ad73311",
+	.id = 1,
+	.dev = {
+		.platform_data = (void *)ad73311_gpio,
+	},
+};
+#endif
+
+#if defined(CONFIG_SND_SOC_AD73311) || defined(CONFIG_SND_SOC_AD73311_MODULE)
+static struct platform_device bfin_ad73311_codec_device = {
+	.name = "ad73311",
+	.id = -1,
+};
+#endif
+
+#if defined(CONFIG_SND_SOC_AD74111) || defined(CONFIG_SND_SOC_AD74111_MODULE)
+static struct platform_device bfin_ad74111_codec_device = {
+	.name = "ad74111",
+	.id = -1,
+};
+#endif
+
+#if defined(CONFIG_SND_BF5XX_SOC_I2S) || \
+	defined(CONFIG_SND_BF5XX_SOC_I2S_MODULE)
 static struct platform_device bfin_i2s = {
 	.name = "bfin-i2s",
 	.id = CONFIG_SND_BF5XX_SPORT_NUM,
-	/* TODO: add platform data here */
+	.num_resources =
+		ARRAY_SIZE(bfin_snd_resources[CONFIG_SND_BF5XX_SPORT_NUM]),
+	.resource = bfin_snd_resources[CONFIG_SND_BF5XX_SPORT_NUM],
+	.dev = {
+		.platform_data = &bfin_snd_data[CONFIG_SND_BF5XX_SPORT_NUM],
+	},
 };
 #endif
 
-#if defined(CONFIG_SND_BF5XX_TDM) || defined(CONFIG_SND_BF5XX_TDM_MODULE)
+#if defined(CONFIG_SND_BF5XX_SOC_TDM) || \
+	defined(CONFIG_SND_BF5XX_SOC_TDM_MODULE)
 static struct platform_device bfin_tdm = {
 	.name = "bfin-tdm",
 	.id = CONFIG_SND_BF5XX_SPORT_NUM,
-	/* TODO: add platform data here */
+	.num_resources =
+		ARRAY_SIZE(bfin_snd_resources[CONFIG_SND_BF5XX_SPORT_NUM]),
+	.resource = bfin_snd_resources[CONFIG_SND_BF5XX_SPORT_NUM],
+	.dev = {
+		.platform_data = &bfin_snd_data[CONFIG_SND_BF5XX_SPORT_NUM],
+	},
 };
 #endif
 
-#if defined(CONFIG_SND_BF5XX_AC97) || defined(CONFIG_SND_BF5XX_AC97_MODULE)
+#if defined(CONFIG_SND_BF5XX_SOC_AC97) || \
+	defined(CONFIG_SND_BF5XX_SOC_AC97_MODULE)
 static struct platform_device bfin_ac97 = {
 	.name = "bfin-ac97",
 	.id = CONFIG_SND_BF5XX_SPORT_NUM,
-	/* TODO: add platform data here */
+	.num_resources =
+		ARRAY_SIZE(bfin_snd_resources[CONFIG_SND_BF5XX_SPORT_NUM]),
+	.resource = bfin_snd_resources[CONFIG_SND_BF5XX_SPORT_NUM],
+	.dev = {
+		.platform_data = &bfin_snd_data[CONFIG_SND_BF5XX_SPORT_NUM],
+	},
 };
 #endif
 
@@ -597,7 +720,8 @@ static struct platform_device *stamp_devices[] __initdata = {
 #endif
 #endif
 
-#if defined(CONFIG_SERIAL_BFIN_SPORT) || defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
+#if defined(CONFIG_SERIAL_BFIN_SPORT) || \
+	defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
 #ifdef CONFIG_SERIAL_BFIN_SPORT0_UART
 	&bfin_sport0_uart_device,
 #endif
@@ -619,14 +743,42 @@ static struct platform_device *stamp_devices[] __initdata = {
 #endif
 
 #if defined(CONFIG_SND_BF5XX_I2S) || defined(CONFIG_SND_BF5XX_I2S_MODULE)
-	&bfin_i2s,
+	&bfin_i2s_pcm,
 #endif
 
 #if defined(CONFIG_SND_BF5XX_TDM) || defined(CONFIG_SND_BF5XX_TDM_MODULE)
-	&bfin_tdm,
+	&bfin_tdm_pcm,
 #endif
 
 #if defined(CONFIG_SND_BF5XX_AC97) || defined(CONFIG_SND_BF5XX_AC97_MODULE)
+	&bfin_ac97_pcm,
+#endif
+
+#if defined(CONFIG_SND_BF5XX_SOC_AD73311) || \
+	defined(CONFIG_SND_BF5XX_SOC_AD73311_MODULE)
+	&bfin_ad73311_machine,
+#endif
+
+#if defined(CONFIG_SND_SOC_AD73311) || defined(CONFIG_SND_SOC_AD73311_MODULE)
+	&bfin_ad73311_codec_device,
+#endif
+
+#if defined(CONFIG_SND_SOC_AD74111) || defined(CONFIG_SND_SOC_AD74111_MODULE)
+	&bfin_ad74111_codec_device,
+#endif
+
+#if defined(CONFIG_SND_BF5XX_SOC_I2S) || \
+	defined(CONFIG_SND_BF5XX_SOC_I2S_MODULE)
+	&bfin_i2s,
+#endif
+
+#if defined(CONFIG_SND_BF5XX_SOC_TDM) || \
+	defined(CONFIG_SND_BF5XX_SOC_TDM_MODULE)
+	&bfin_tdm,
+#endif
+
+#if defined(CONFIG_SND_BF5XX_SOC_AC97) || \
+	defined(CONFIG_SND_BF5XX_SOC_AC97_MODULE)
 	&bfin_ac97,
 #endif
 };
-- 
1.7.0.4


