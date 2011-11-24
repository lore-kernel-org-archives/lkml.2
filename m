Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab1KXMse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:48:34 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:12282
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755425Ab1KXMry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:47:54 -0500
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
Subject: [PATCH 7/8] ASoC: SigmaDSP: Move private structs and functions to c file
Date: Thu, 24 Nov 2011 13:48:26 +0100
Message-ID: <1322138908-32127-7-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1322138908-32127-1-git-send-email-lars@metafoo.de>
References: <1322138908-32127-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the structs and functions only used by SigmaDSP firmware loader itself
from the header to the c file.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/sigmadsp.c |   35 +++++++++++++++++++++++++++++++++++
 sound/soc/codecs/sigmadsp.h |   39 ---------------------------------------
 2 files changed, 35 insertions(+), 39 deletions(-)

diff --git a/sound/soc/codecs/sigmadsp.c b/sound/soc/codecs/sigmadsp.c
index e13501a..c6964f4 100644
--- a/sound/soc/codecs/sigmadsp.c
+++ b/sound/soc/codecs/sigmadsp.c
@@ -15,6 +15,41 @@
 
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
 static size_t sigma_action_size(struct sigma_action *sa)
 {
 	size_t payload = 0;
diff --git a/sound/soc/codecs/sigmadsp.h b/sound/soc/codecs/sigmadsp.h
index 745f1bd..99a6091 100644
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
 extern int process_sigma_firmware(struct i2c_client *client, const char *name);
 
 #endif
-- 
1.7.7.1


