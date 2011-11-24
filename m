Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1KXMr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:47:56 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:10672
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093Ab1KXMru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:47:50 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <drivers@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 5/8] ASoC: Move SigmaDSP firmware loader to ASoC
Date: Thu, 24 Nov 2011 13:48:24 +0100
Message-ID: <1322138908-32127-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1322138908-32127-1-git-send-email-lars@metafoo.de>
References: <1322138908-32127-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been pointed out previously, that the firmware subsystem is not the right
place for the SigmaDSP firmware loader. Furthermore the SigmaDSP is currently
only used in audio products and we are aiming for better integration into the
ASoC framework in the future, with support for ALSA controls for firmware
parameters and support dynamic power management as well. So the natural choice
for the SigmaDSP firmware loader is the ASoC subsystem.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 MAINTAINERS                 |    1 +
 drivers/firmware/Kconfig    |   12 ----
 drivers/firmware/Makefile   |    1 -
 drivers/firmware/sigma.c    |  147 ------------------------------------------
 include/linux/sigma.h       |   55 ----------------
 sound/soc/codecs/Kconfig    |    6 ++-
 sound/soc/codecs/Makefile   |    2 +
 sound/soc/codecs/adau1701.c |    2 +-
 sound/soc/codecs/sigmadsp.c |  148 +++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/sigmadsp.h |   55 ++++++++++++++++
 10 files changed, 212 insertions(+), 217 deletions(-)
 delete mode 100644 drivers/firmware/sigma.c
 delete mode 100644 include/linux/sigma.h
 create mode 100644 sound/soc/codecs/sigmadsp.c
 create mode 100644 sound/soc/codecs/sigmadsp.h

diff --git a/MAINTAINERS b/MAINTAINERS
index fd7e441..d14e47a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -542,6 +542,7 @@ F:	sound/soc/codecs/adau*
 F:	sound/soc/codecs/adav*
 F:	sound/soc/codecs/ad1*
 F:	sound/soc/codecs/ssm*
+F:	sound/soc/codecs/sigma.*
 
 ANALOG DEVICES INC ASOC DRIVERS
 L:	uclinux-dist-devel@blackfin.uclinux.org
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index efba163..9b00072 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -145,18 +145,6 @@ config ISCSI_IBFT
 	  detect iSCSI boot parameters dynamically during system boot, say Y.
 	  Otherwise, say N.
 
-config SIGMA
-	tristate "SigmaStudio firmware loader"
-	depends on I2C
-	select CRC32
-	default n
-	help
-	  Enable helper functions for working with Analog Devices SigmaDSP
-	  parts and binary firmwares produced by Analog Devices SigmaStudio.
-
-	  If unsure, say N here.  Drivers that need these helpers will select
-	  this option automatically.
-
 source "drivers/firmware/google/Kconfig"
 
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 47338c9..5a7e273 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -12,6 +12,5 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
-obj-$(CONFIG_SIGMA)		+= sigma.o
 
 obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
diff --git a/drivers/firmware/sigma.c b/drivers/firmware/sigma.c
deleted file mode 100644
index 749932c..0000000
--- a/drivers/firmware/sigma.c
+++ /dev/null
@@ -1,147 +0,0 @@
-/*
- * Load Analog Devices SigmaStudio firmware files
- *
- * Copyright 2009-2011 Analog Devices Inc.
- *
- * Licensed under the GPL-2 or later.
- */
-
-#include <linux/crc32.h>
-#include <linux/delay.h>
-#include <linux/firmware.h>
-#include <linux/kernel.h>
-#include <linux/i2c.h>
-#include <linux/module.h>
-#include <linux/sigma.h>
-
-static size_t sigma_action_size(struct sigma_action *sa)
-{
-	size_t payload = 0;
-
-	switch (sa->instr) {
-	case SIGMA_ACTION_WRITEXBYTES:
-	case SIGMA_ACTION_WRITESINGLE:
-	case SIGMA_ACTION_WRITESAFELOAD:
-		payload = sigma_action_len(sa);
-		break;
-	default:
-		break;
-	}
-
-	payload = ALIGN(payload, 2);
-
-	return payload + sizeof(struct sigma_action);
-}
-
-static int
-process_sigma_action(struct i2c_client *client, struct sigma_action *sa)
-{
-	size_t len = sigma_action_len(sa);
-	int ret;
-
-	pr_debug("%s: instr:%i addr:%#x len:%zu\n", __func__,
-		sa->instr, sa->addr, len);
-
-	switch (sa->instr) {
-	case SIGMA_ACTION_WRITEXBYTES:
-	case SIGMA_ACTION_WRITESINGLE:
-	case SIGMA_ACTION_WRITESAFELOAD:
-		ret = i2c_master_send(client, (void *)&sa->addr, len);
-		if (ret < 0)
-			return -EINVAL;
-		break;
-	case SIGMA_ACTION_DELAY:
-		udelay(len);
-		len = 0;
-		break;
-	case SIGMA_ACTION_END:
-		return 0;
-	default:
-		return -EINVAL;
-	}
-
-	return 1;
-}
-
-static int
-process_sigma_actions(struct i2c_client *client, struct sigma_firmware *ssfw)
-{
-	struct sigma_action *sa;
-	size_t size;
-	int ret;
-
-	while (ssfw->pos + sizeof(*sa) <= ssfw->fw->size) {
-		sa = (struct sigma_action *)(ssfw->fw->data + ssfw->pos);
-
-		size = sigma_action_size(sa);
-		ssfw->pos += size;
-		if (ssfw->pos > ssfw->fw->size || size == 0)
-			break;
-
-		ret = process_sigma_action(client, sa);
-
-		pr_debug("%s: action returned %i\n", __func__, ret);
-
-		if (ret <= 0)
-			return ret;
-	}
-
-	if (ssfw->pos != ssfw->fw->size)
-		return -EINVAL;
-
-	return 0;
-}
-
-int process_sigma_firmware(struct i2c_client *client, const char *name)
-{
-	int ret;
-	struct sigma_firmware_header *ssfw_head;
-	struct sigma_firmware ssfw;
-	const struct firmware *fw;
-	u32 crc;
-
-	pr_debug("%s: loading firmware %s\n", __func__, name);
-
-	/* first load the blob */
-	ret = request_firmware(&fw, name, &client->dev);
-	if (ret) {
-		pr_debug("%s: request_firmware() failed with %i\n", __func__, ret);
-		return ret;
-	}
-	ssfw.fw = fw;
-
-	/* then verify the header */
-	ret = -EINVAL;
-
-	/* Reject too small or unreasonable large files. The upper limit is
-	 * chosen a bit arbitrarily but it should be enough for all practical
-	 * purposes and having the limit makes it easier to avoid integer
-	 * overflows later in the loading process. */
-	if (fw->size < sizeof(*ssfw_head) || fw->size >= 0x4000000)
-		goto done;
-
-	ssfw_head = (void *)fw->data;
-	if (memcmp(ssfw_head->magic, SIGMA_MAGIC, ARRAY_SIZE(ssfw_head->magic)))
-		goto done;
-
-	crc = crc32(0, fw->data + sizeof(*ssfw_head),
-			fw->size - sizeof(*ssfw_head));
-	pr_debug("%s: crc=%x\n", __func__, crc);
-	if (crc != le32_to_cpu(ssfw_head->crc))
-		goto done;
-
-	ssfw.pos = sizeof(*ssfw_head);
-
-	/* finally process all of the actions */
-	ret = process_sigma_actions(client, &ssfw);
-
- done:
-	release_firmware(fw);
-
-	pr_debug("%s: loaded %s\n", __func__, name);
-
-	return ret;
-}
-EXPORT_SYMBOL(process_sigma_firmware);
-
-MODULE_LICENSE("GPL");
diff --git a/include/linux/sigma.h b/include/linux/sigma.h
deleted file mode 100644
index 745f1bd..0000000
--- a/include/linux/sigma.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/*
- * Load firmware files from Analog Devices SigmaStudio
- *
- * Copyright 2009-2011 Analog Devices Inc.
- *
- * Licensed under the GPL-2 or later.
- */
-
-#ifndef __SIGMA_FIRMWARE_H__
-#define __SIGMA_FIRMWARE_H__
-
-#include <linux/firmware.h>
-#include <linux/types.h>
-
-struct i2c_client;
-
-#define SIGMA_MAGIC "ADISIGM"
-
-struct sigma_firmware {
-	const struct firmware *fw;
-	size_t pos;
-};
-
-struct sigma_firmware_header {
-	unsigned char magic[7];
-	u8 version;
-	__le32 crc;
-} __packed;
-
-enum {
-	SIGMA_ACTION_WRITEXBYTES = 0,
-	SIGMA_ACTION_WRITESINGLE,
-	SIGMA_ACTION_WRITESAFELOAD,
-	SIGMA_ACTION_DELAY,
-	SIGMA_ACTION_PLLWAIT,
-	SIGMA_ACTION_NOOP,
-	SIGMA_ACTION_END,
-};
-
-struct sigma_action {
-	u8 instr;
-	u8 len_hi;
-	__le16 len;
-	__be16 addr;
-	unsigned char payload[];
-} __packed;
-
-static inline u32 sigma_action_len(struct sigma_action *sa)
-{
-	return (sa->len_hi << 16) | le16_to_cpu(sa->len);
-}
-
-extern int process_sigma_firmware(struct i2c_client *client, const char *name);
-
-#endif
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 686f45a..593174c 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -141,7 +141,7 @@ config SND_SOC_AD73311
 	tristate
 
 config SND_SOC_ADAU1701
-	select SIGMA
+	select SND_SOC_SIGMADSP
 	tristate
 
 config SND_SOC_ADAU1373
@@ -234,6 +234,10 @@ config SND_SOC_RT5631
 config SND_SOC_SGTL5000
 	tristate
 
+config SND_SOC_SIGMADSP
+	tristate
+	select CRC32
+
 config SND_SOC_SN95031
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 62b01e4..4aea5b1 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -33,6 +33,7 @@ snd-soc-rt5631-objs := rt5631.o
 snd-soc-sgtl5000-objs := sgtl5000.o
 snd-soc-alc5623-objs := alc5623.o
 snd-soc-alc5632-objs := alc5632.o
+snd-soc-sigma-objs := sigma.o
 snd-soc-sn95031-objs := sn95031.o
 snd-soc-spdif-objs := spdif_transciever.o
 snd-soc-ssm2602-objs := ssm2602.o
@@ -134,6 +135,7 @@ obj-$(CONFIG_SND_SOC_MAX9850)	+= snd-soc-max9850.o
 obj-$(CONFIG_SND_SOC_PCM3008)	+= snd-soc-pcm3008.o
 obj-$(CONFIG_SND_SOC_RT5631)	+= snd-soc-rt5631.o
 obj-$(CONFIG_SND_SOC_SGTL5000)  += snd-soc-sgtl5000.o
+obj-$(CONFIG_SND_SOC_SIGMA)	+= snd-soc-sigma.o
 obj-$(CONFIG_SND_SOC_SN95031)	+=snd-soc-sn95031.o
 obj-$(CONFIG_SND_SOC_SPDIF)	+= snd-soc-spdif.o
 obj-$(CONFIG_SND_SOC_SSM2602)	+= snd-soc-ssm2602.o
diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
index 8b7e1c5..6a6af56 100644
--- a/sound/soc/codecs/adau1701.c
+++ b/sound/soc/codecs/adau1701.c
@@ -12,13 +12,13 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
-#include <linux/sigma.h>
 #include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 
+#include "sigmadsp.h"
 #include "adau1701.h"
 
 #define ADAU1701_DSPCTRL	0x1c
diff --git a/sound/soc/codecs/sigmadsp.c b/sound/soc/codecs/sigmadsp.c
new file mode 100644
index 0000000..01b69f4
--- /dev/null
+++ b/sound/soc/codecs/sigmadsp.c
@@ -0,0 +1,148 @@
+/*
+ * Load Analog Devices SigmaStudio firmware files
+ *
+ * Copyright 2009-2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/crc32.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+
+#include "sigmadsp.h"
+
+static size_t sigma_action_size(struct sigma_action *sa)
+{
+	size_t payload = 0;
+
+	switch (sa->instr) {
+	case SIGMA_ACTION_WRITEXBYTES:
+	case SIGMA_ACTION_WRITESINGLE:
+	case SIGMA_ACTION_WRITESAFELOAD:
+		payload = sigma_action_len(sa);
+		break;
+	default:
+		break;
+	}
+
+	payload = ALIGN(payload, 2);
+
+	return payload + sizeof(struct sigma_action);
+}
+
+static int
+process_sigma_action(struct i2c_client *client, struct sigma_action *sa)
+{
+	size_t len = sigma_action_len(sa);
+	int ret;
+
+	pr_debug("%s: instr:%i addr:%#x len:%zu\n", __func__,
+		sa->instr, sa->addr, len);
+
+	switch (sa->instr) {
+	case SIGMA_ACTION_WRITEXBYTES:
+	case SIGMA_ACTION_WRITESINGLE:
+	case SIGMA_ACTION_WRITESAFELOAD:
+		ret = i2c_master_send(client, (void *)&sa->addr, len);
+		if (ret < 0)
+			return -EINVAL;
+		break;
+	case SIGMA_ACTION_DELAY:
+		udelay(len);
+		len = 0;
+		break;
+	case SIGMA_ACTION_END:
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	return 1;
+}
+
+static int
+process_sigma_actions(struct i2c_client *client, struct sigma_firmware *ssfw)
+{
+	struct sigma_action *sa;
+	size_t size;
+	int ret;
+
+	while (ssfw->pos + sizeof(*sa) <= ssfw->fw->size) {
+		sa = (struct sigma_action *)(ssfw->fw->data + ssfw->pos);
+
+		size = sigma_action_size(sa);
+		ssfw->pos += size;
+		if (ssfw->pos > ssfw->fw->size || size == 0)
+			break;
+
+		ret = process_sigma_action(client, sa);
+
+		pr_debug("%s: action returned %i\n", __func__, ret);
+
+		if (ret <= 0)
+			return ret;
+	}
+
+	if (ssfw->pos != ssfw->fw->size)
+		return -EINVAL;
+
+	return 0;
+}
+
+int process_sigma_firmware(struct i2c_client *client, const char *name)
+{
+	int ret;
+	struct sigma_firmware_header *ssfw_head;
+	struct sigma_firmware ssfw;
+	const struct firmware *fw;
+	u32 crc;
+
+	pr_debug("%s: loading firmware %s\n", __func__, name);
+
+	/* first load the blob */
+	ret = request_firmware(&fw, name, &client->dev);
+	if (ret) {
+		pr_debug("%s: request_firmware() failed with %i\n", __func__, ret);
+		return ret;
+	}
+	ssfw.fw = fw;
+
+	/* then verify the header */
+	ret = -EINVAL;
+
+	/* Reject too small or unreasonable large files. The upper limit is
+	 * chosen a bit arbitrarily but it should be enough for all practical
+	 * purposes and having the limit makes it easier to avoid integer
+	 * overflows later in the loading process. */
+	if (fw->size < sizeof(*ssfw_head) || fw->size >= 0x4000000)
+		goto done;
+
+	ssfw_head = (void *)fw->data;
+	if (memcmp(ssfw_head->magic, SIGMA_MAGIC, ARRAY_SIZE(ssfw_head->magic)))
+		goto done;
+
+	crc = crc32(0, fw->data + sizeof(*ssfw_head),
+			fw->size - sizeof(*ssfw_head));
+	pr_debug("%s: crc=%x\n", __func__, crc);
+	if (crc != le32_to_cpu(ssfw_head->crc))
+		goto done;
+
+	ssfw.pos = sizeof(*ssfw_head);
+
+	/* finally process all of the actions */
+	ret = process_sigma_actions(client, &ssfw);
+
+ done:
+	release_firmware(fw);
+
+	pr_debug("%s: loaded %s\n", __func__, name);
+
+	return ret;
+}
+EXPORT_SYMBOL(process_sigma_firmware);
+
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/sigmadsp.h b/sound/soc/codecs/sigmadsp.h
new file mode 100644
index 0000000..745f1bd
--- /dev/null
+++ b/sound/soc/codecs/sigmadsp.h
@@ -0,0 +1,55 @@
+/*
+ * Load firmware files from Analog Devices SigmaStudio
+ *
+ * Copyright 2009-2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef __SIGMA_FIRMWARE_H__
+#define __SIGMA_FIRMWARE_H__
+
+#include <linux/firmware.h>
+#include <linux/types.h>
+
+struct i2c_client;
+
+#define SIGMA_MAGIC "ADISIGM"
+
+struct sigma_firmware {
+	const struct firmware *fw;
+	size_t pos;
+};
+
+struct sigma_firmware_header {
+	unsigned char magic[7];
+	u8 version;
+	__le32 crc;
+} __packed;
+
+enum {
+	SIGMA_ACTION_WRITEXBYTES = 0,
+	SIGMA_ACTION_WRITESINGLE,
+	SIGMA_ACTION_WRITESAFELOAD,
+	SIGMA_ACTION_DELAY,
+	SIGMA_ACTION_PLLWAIT,
+	SIGMA_ACTION_NOOP,
+	SIGMA_ACTION_END,
+};
+
+struct sigma_action {
+	u8 instr;
+	u8 len_hi;
+	__le16 len;
+	__be16 addr;
+	unsigned char payload[];
+} __packed;
+
+static inline u32 sigma_action_len(struct sigma_action *sa)
+{
+	return (sa->len_hi << 16) | le16_to_cpu(sa->len);
+}
+
+extern int process_sigma_firmware(struct i2c_client *client, const char *name);
+
+#endif
-- 
1.7.7.1


