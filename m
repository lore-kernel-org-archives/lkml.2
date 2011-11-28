Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab1K1IoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 03:44:05 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:5817 "EHLO
	VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753007Ab1K1In2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 03:43:28 -0500
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
Subject: [PATCH v2 6/7] ASoC: SigmaDSP: Move private structs and functions to C file
Date: Mon, 28 Nov 2011 09:44:19 +0100
Message-ID: <1322469860-8210-6-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322469860-8210-1-git-send-email-lars@metafoo.de>
References: <1322469860-8210-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the structs and functions only used by SigmaDSP firmware loader itself
from the header to the C file.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Mike Frysinger <vapier@gentoo.org>
---
 sound/soc/codecs/sigmadsp.c |   36 ++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/sigmadsp.h |   39 ---------------------------------------
 2 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/sound/soc/codecs/sigmadsp.c b/sound/soc/codecs/sigmadsp.c
index c0ad885..aa223c5 100644
--- a/sound/soc/codecs/sigmadsp.c
+++ b/sound/soc/codecs/sigmadsp.c
@@ -15,6 +15,42 @@
 
 #include "sigmadsp.h"
 
+#define SIGMA_MAGIC "ADISIGM"
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
+struct sigma_firmware {
+	const struct firmware *fw;
+	size_t pos;
+};
+
+static inline u32 sigma_action_len(struct sigma_action *sa)
+{
+	return (sa->len_hi << 16) | le16_to_cpu(sa->len);
+}
+
 static size_t sigma_action_size(struct sigma_action *sa)
 {
 	size_t payload = 0;
diff --git a/sound/soc/codecs/sigmadsp.h b/sound/soc/codecs/sigmadsp.h
index d0de882..99a6091 100644
--- a/sound/soc/codecs/sigmadsp.h
+++ b/sound/soc/codecs/sigmadsp.h
@@ -9,47 +9,8 @@
 #ifndef __SIGMA_FIRMWARE_H__
 #define __SIGMA_FIRMWARE_H__
 
-#include <linux/firmware.h>
-#include <linux/types.h>
-
 struct i2c_client;
 
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
-};
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
-};
-
-static inline u32 sigma_action_len(struct sigma_action *sa)
-{
-	return (sa->len_hi << 16) | le16_to_cpu(sa->len);
-}
-
 extern int process_sigma_firmware(struct i2c_client *client, const char *name);
 
 #endif
-- 
1.7.7.3


