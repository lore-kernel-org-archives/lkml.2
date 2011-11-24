Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1KXMr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:47:58 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:55184
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516Ab1KXMr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:47:56 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <drivers@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 8/8] ASoC: SigmaDSP: Add regmap support
Date: Thu, 24 Nov 2011 13:48:27 +0100
Message-ID: <1322138908-32127-8-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1322138908-32127-1-git-send-email-lars@metafoo.de>
References: <1322138908-32127-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for loading the SigmaDSP firmware using regmap. This allows us
to transparently use SPI or I2C as the transport protocol on devices which
support them.

For now we keep the old I2C support since we have one user of this which is not
straight forward to convert to regmap, due to variable length registers.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/sigmadsp.c |   68 ++++++++++++++++++++++++++++++++++--------
 sound/soc/codecs/sigmadsp.h |    5 +++
 2 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/sigmadsp.c b/sound/soc/codecs/sigmadsp.c
index c6964f4..6fed878d 100644
--- a/sound/soc/codecs/sigmadsp.c
+++ b/sound/soc/codecs/sigmadsp.c
@@ -11,6 +11,7 @@
 #include <linux/firmware.h>
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/regmap.h>
 #include <linux/module.h>
 
 #include "sigmadsp.h"
@@ -44,12 +45,17 @@ struct sigma_action {
 struct sigma_firmware {
 	const struct firmware *fw;
 	size_t pos;
+
+	void *control_data;
+	int (*write)(void *control_data, const struct sigma_action *sa,
+			size_t len);
 };
 
 static inline u32 sigma_action_len(struct sigma_action *sa)
 {
 	return (sa->len_hi << 16) | le16_to_cpu(sa->len);
 }
+
 static size_t sigma_action_size(struct sigma_action *sa)
 {
 	size_t payload = 0;
@@ -69,8 +75,22 @@ static size_t sigma_action_size(struct sigma_action *sa)
 	return payload + sizeof(struct sigma_action);
 }
 
+static int sigma_action_write_regmap(void *control_data,
+	const struct sigma_action *sa, size_t len)
+{
+	return regmap_raw_write(control_data, le16_to_cpu(sa->addr),
+		sa->payload, len - 2);
+}
+
+static int sigma_action_write_i2c(void *control_data,
+	const struct sigma_action *sa, size_t len)
+{
+	return i2c_master_send(control_data, (const unsigned char *)&sa->addr,
+		len);
+}
+
 static int
-process_sigma_action(struct i2c_client *client, struct sigma_action *sa)
+process_sigma_action(struct sigma_firmware *ssfw, struct sigma_action *sa)
 {
 	size_t len = sigma_action_len(sa);
 	int ret;
@@ -82,7 +102,7 @@ process_sigma_action(struct i2c_client *client, struct sigma_action *sa)
 	case SIGMA_ACTION_WRITEXBYTES:
 	case SIGMA_ACTION_WRITESINGLE:
 	case SIGMA_ACTION_WRITESAFELOAD:
-		ret = i2c_master_send(client, (void *)&sa->addr, len);
+		ret = ssfw->write(ssfw->control_data, sa, len);
 		if (ret < 0)
 			return -EINVAL;
 		break;
@@ -100,7 +120,7 @@ process_sigma_action(struct i2c_client *client, struct sigma_action *sa)
 }
 
 static int
-process_sigma_actions(struct i2c_client *client, struct sigma_firmware *ssfw)
+process_sigma_actions(struct sigma_firmware *ssfw)
 {
 	struct sigma_action *sa;
 	size_t size;
@@ -114,7 +134,7 @@ process_sigma_actions(struct i2c_client *client, struct sigma_firmware *ssfw)
 		if (ssfw->pos > ssfw->fw->size || size == 0)
 			break;
 
-		ret = process_sigma_action(client, sa);
+		ret = process_sigma_action(ssfw, sa);
 
 		pr_debug("%s: action returned %i\n", __func__, ret);
 
@@ -128,23 +148,23 @@ process_sigma_actions(struct i2c_client *client, struct sigma_firmware *ssfw)
 	return 0;
 }
 
-int process_sigma_firmware(struct i2c_client *client, const char *name)
+static int _process_sigma_firmware(struct device *dev,
+	struct sigma_firmware *ssfw, const char *name)
 {
 	int ret;
 	struct sigma_firmware_header *ssfw_head;
-	struct sigma_firmware ssfw;
 	const struct firmware *fw;
 	u32 crc;
 
 	pr_debug("%s: loading firmware %s\n", __func__, name);
 
 	/* first load the blob */
-	ret = request_firmware(&fw, name, &client->dev);
+	ret = request_firmware(&fw, name, dev);
 	if (ret) {
 		pr_debug("%s: request_firmware() failed with %i\n", __func__, ret);
 		return ret;
 	}
-	ssfw.fw = fw;
+	ssfw->fw = fw;
 
 	/* then verify the header */
 	ret = -EINVAL;
@@ -154,13 +174,13 @@ int process_sigma_firmware(struct i2c_client *client, const char *name)
 	 * purposes and having the limit makes it easier to avoid integer
 	 * overflows later in the loading process. */
 	if (fw->size < sizeof(*ssfw_head) || fw->size >= 0x4000000) {
-		dev_err(&client->dev, "Failed to load firmware: Invalid size\n");
+		dev_err(dev, "Failed to load firmware: Invalid size\n");
 		goto done;
 	}
 
 	ssfw_head = (void *)fw->data;
 	if (memcmp(ssfw_head->magic, SIGMA_MAGIC, ARRAY_SIZE(ssfw_head->magic))) {
-		dev_err(&client->dev, "Failed to load firmware: Invalid magic\n");
+		dev_err(dev, "Failed to load firmware: Invalid magic\n");
 		goto done;
 	}
 
@@ -168,16 +188,16 @@ int process_sigma_firmware(struct i2c_client *client, const char *name)
 			fw->size - sizeof(*ssfw_head));
 	pr_debug("%s: crc=%x\n", __func__, crc);
 	if (crc != le32_to_cpu(ssfw_head->crc)) {
-		dev_err(&client->dev, "Failed to load firmware: Wrong crc checksum:" \
+		dev_err(dev, "Failed to load firmware: Wrong crc checksum:" \
 			" expected %x got %x.\n",
 			le32_to_cpu(ssfw_head->crc), crc);
 		goto done;
 	}
 
-	ssfw.pos = sizeof(*ssfw_head);
+	ssfw->pos = sizeof(*ssfw_head);
 
 	/* finally process all of the actions */
-	ret = process_sigma_actions(client, &ssfw);
+	ret = process_sigma_actions(ssfw);
 
  done:
 	release_firmware(fw);
@@ -186,6 +206,28 @@ int process_sigma_firmware(struct i2c_client *client, const char *name)
 
 	return ret;
 }
+
+int process_sigma_firmware(struct i2c_client *client, const char *name)
+{
+	struct sigma_firmware ssfw;
+
+	ssfw.control_data = client;
+	ssfw.write = sigma_action_write_i2c;
+
+	return _process_sigma_firmware(&client->dev, &ssfw, name);
+}
 EXPORT_SYMBOL(process_sigma_firmware);
 
+int process_sigma_firmware_regmap(struct device *dev, struct regmap *regmap,
+	const char *name)
+{
+	struct sigma_firmware ssfw;
+
+	ssfw.control_data = regmap;
+	ssfw.write = sigma_action_write_regmap;
+
+	return _process_sigma_firmware(dev, &ssfw, name);
+}
+EXPORT_SYMBOL(process_sigma_firmware_regmap);
+
 MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/sigmadsp.h b/sound/soc/codecs/sigmadsp.h
index 99a6091..e439cbd 100644
--- a/sound/soc/codecs/sigmadsp.h
+++ b/sound/soc/codecs/sigmadsp.h
@@ -9,8 +9,13 @@
 #ifndef __SIGMA_FIRMWARE_H__
 #define __SIGMA_FIRMWARE_H__
 
+#include <linux/device.h>
+#include <linux/regmap.h>
+
 struct i2c_client;
 
 extern int process_sigma_firmware(struct i2c_client *client, const char *name);
+extern int process_sigma_firmware_regmap(struct device *dev,
+		struct regmap *regmap, const char *name);
 
 #endif
-- 
1.7.7.1


