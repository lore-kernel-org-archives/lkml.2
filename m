Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2BUKqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:46:18 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:57131 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294Ab2BUKqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:46:15 -0500
MIME-Version: 1.0
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        alsa-devel@alsa-project.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MFD/Input/ASoC: twl6040 kconfig fixes
Date: Tue, 21 Feb 2012 12:46:11 +0200
Message-Id: <1329821171-3769-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid breaking x86_64 allmodconfig build the Kconfig files need to be
changed.
Change the dependency graph of the twl6040 stack.

Stephen Rothwell wrote:
> Hi Samuel,
>
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> drivers/built-in.o: In function `twl6040_driver_init':
> twl6040-core.c:(.init.text+0xb147): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `twl6040_probe':
> twl6040-core.c:(.devinit.text+0x7f22): undefined reference to `regmap_init_i2c'
> drivers/built-in.o: In function `twl6040_driver_exit':
> twl6040-core.c:(.exit.text+0x67a): undefined reference to `i2c_del_driver'
>
>
> Caused by commit ded0df851077 ("mfd: Convert twl6040 to an i2c driver,
> and separate it from twl core").

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---

Hi Stephen, Samuel,

This patch will fix the build failure with x86_64 allmodconfig, and it will
still work on the target platform.

As a note: this series might not be going via the mfd tree at the end since
some of the dependencies are going via sound tree. We are discussing the way
forward.

Regards,
Peter

 drivers/input/misc/Kconfig |    2 +-
 drivers/mfd/Kconfig        |   11 +++++++++--
 sound/soc/codecs/Kconfig   |    3 +--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 6a9ee24..9450d4c 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -368,7 +368,7 @@ config INPUT_TWL4030_VIBRA
 
 config INPUT_TWL6040_VIBRA
 	tristate "Support for TWL6040 Vibrator"
-	select TWL6040_CORE
+	depends on TWL6040_CORE
 	select INPUT_FF_MEMLESS
 	help
 	  This option enables support for TWL6040 Vibrator Driver.
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 0e48997..ea7c36f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -266,10 +266,17 @@ config TWL6030_PWM
 	  This is used to control charging LED brightness.
 
 config TWL6040_CORE
-	bool
-	depends on I2C && GENERIC_HARDIRQS
+	bool "Support for TWL6040 audio codec"
+	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
+	select REGMAP_I2C
 	default n
+	help
+	  Say yes here if you want support for Texas Instruments TWL6040 audio
+	  codec.
+	  This driver provides common support for accessing the device,
+	  additional drivers must be enabled in order to use the
+	  functionality of the device (audio, vibra).
 
 config MFD_STMPE
 	bool "Support STMicroelectronics STMPE"
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index f1a1197..6b4d86a 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -56,7 +56,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_TPA6130A2 if I2C
 	select SND_SOC_TLV320DAC33 if I2C
 	select SND_SOC_TWL4030 if TWL4030_CORE
-	select SND_SOC_TWL6040 if I2C
+	select SND_SOC_TWL6040 if TWL6040_CORE
 	select SND_SOC_UDA134X
 	select SND_SOC_UDA1380 if I2C
 	select SND_SOC_WL1273 if MFD_WL1273_CORE
@@ -274,7 +274,6 @@ config SND_SOC_TWL4030
 	tristate
 
 config SND_SOC_TWL6040
-	select TWL6040_CORE
 	tristate
 
 config SND_SOC_UDA134X
-- 
1.7.8.4

