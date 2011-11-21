Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1KUEH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 23:07:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65201 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab1KUEHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 23:07:12 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/3] sound/soc/lapis: add machine driver
Date: Mon, 21 Nov 2011 13:08:51 +0900
Message-Id: <1321848532-8784-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add machine driver for LAPIS Semiconductor ML7213 IOH.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 sound/soc/Kconfig                   |    1 +
 sound/soc/Makefile                  |    1 +
 sound/soc/lapis/Kconfig             |    6 ++
 sound/soc/lapis/Makefile            |    4 ++
 sound/soc/lapis/ml7213ioh-machine.c |   87 +++++++++++++++++++++++++++++++++++
 5 files changed, 99 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/lapis/Kconfig
 create mode 100644 sound/soc/lapis/Makefile
 create mode 100644 sound/soc/lapis/ml7213ioh-machine.c

diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 1381db8..674142b 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -60,6 +60,7 @@ source "sound/soc/s6000/Kconfig"
 source "sound/soc/sh/Kconfig"
 source "sound/soc/tegra/Kconfig"
 source "sound/soc/txx9/Kconfig"
+source "sound/soc/lapis/Kconfig"
 
 # Supported codecs
 source "sound/soc/codecs/Kconfig"
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index 9ea8ac8..6586d99 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_SND_SOC)	+= s6000/
 obj-$(CONFIG_SND_SOC)	+= sh/
 obj-$(CONFIG_SND_SOC)	+= tegra/
 obj-$(CONFIG_SND_SOC)	+= txx9/
+obj-$(CONFIG_SND_SOC)	+= lapis/
diff --git a/sound/soc/lapis/Kconfig b/sound/soc/lapis/Kconfig
new file mode 100644
index 0000000..1bd5200
--- /dev/null
+++ b/sound/soc/lapis/Kconfig
@@ -0,0 +1,6 @@
+config SND_SOC_ML7213_MACHINE
+	tristate "ML7213 IOH ASoC machine driver"
+	depends on SND_SOC_TXX9ACLC
+	select SND_SOC_ML7213_PLATFORM
+	help
+	  This is ASoC machine driver for ML7213 IOH
diff --git a/sound/soc/lapis/Makefile b/sound/soc/lapis/Makefile
new file mode 100644
index 0000000..468d922
--- /dev/null
+++ b/sound/soc/lapis/Makefile
@@ -0,0 +1,4 @@
+# Platform
+snd-soc-ml7213-machine-objs := ml7213ioh-machine.o
+
+obj-$(CONFIG_SND_SOC_ML7213_MACHINE) += snd-soc-ml7213-plat.o
diff --git a/sound/soc/lapis/ml7213ioh-machine.c b/sound/soc/lapis/ml7213ioh-machine.c
new file mode 100644
index 0000000..7f5629c
--- /dev/null
+++ b/sound/soc/lapis/ml7213ioh-machine.c
@@ -0,0 +1,87 @@
+/*
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/soc.h>
+
+static struct snd_soc_dai_link ioh_i2s_dai = {
+	.name = "I2S",
+	.stream_name = "I2S HiFi",
+	.cpu_dai_name = "ml7213ioh-i2s",
+	.codec_dai_name = "ml7213ioh-hifi",
+	.platform_name	= "ml7213ioh-pcm-audio",
+	.codec_name	= "ml26124-codec",
+};
+
+static struct snd_soc_card ioh_i2s_card = {
+	.name		= "ml7213ioh i2s",
+	.dai_link	= &ioh_i2s_dai,
+	.num_links	= 1,
+};
+
+static struct platform_device *soc_pdev;
+
+static int __init ioh_i2s_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	soc_pdev = platform_device_alloc("soc-audio", -1);
+	if (!soc_pdev)
+		return -ENOMEM;
+	platform_set_drvdata(soc_pdev, &ioh_i2s_card);
+	ret = platform_device_add(soc_pdev);
+	if (ret) {
+		platform_device_put(soc_pdev);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __exit ioh_i2s_remove(struct platform_device *pdev)
+{
+	platform_device_unregister(soc_pdev);
+	return 0;
+}
+
+static struct platform_driver ioh_i2s_driver = {
+	.remove = ioh_i2s_remove,
+	.driver = {
+		.name = "ml7213ioh-machine",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init ioh_i2s_init(void)
+{
+	return platform_driver_probe(&ioh_i2s_driver,
+				     ioh_i2s_probe);
+}
+
+static void __exit ioh_i2s_exit(void)
+{
+	platform_driver_unregister(&ioh_i2s_driver);
+}
+
+module_init(ioh_i2s_init);
+module_exit(ioh_i2s_exit);
+
+MODULE_AUTHOR("Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>");
+MODULE_DESCRIPTION("LAPIS Semiconductor ML7213 IOH ALSA SoC machine driver");
+MODULE_LICENSE("GPL");
-- 
1.7.4.4

