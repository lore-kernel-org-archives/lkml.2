Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab1KXMt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:49:29 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:48044
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134Ab1KXMrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:47:45 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <drivers@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>, <stable@kernel.org>
Subject: [PATCH 1/8] firmware: Sigma: Prevent out of bounds memory access
Date: Thu, 24 Nov 2011 13:48:20 +0100
Message-ID: <1322138908-32127-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SigmaDSP firmware loader currently does not perform enough boundary size
checks when processing the firmware. As a result it is possible that a
malformed firmware can cause an out of bounds memory access.

This patch adds checks which ensure that both the action header and the payload
are completely inside the firmware data boundaries before processing them.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: stable@kernel.org
---
 drivers/firmware/sigma.c |   70 ++++++++++++++++++++++++++++++++--------------
 include/linux/sigma.h    |    5 ---
 2 files changed, 49 insertions(+), 26 deletions(-)

diff --git a/drivers/firmware/sigma.c b/drivers/firmware/sigma.c
index f10fc52..5b17966 100644
--- a/drivers/firmware/sigma.c
+++ b/drivers/firmware/sigma.c
@@ -14,13 +14,30 @@
 #include <linux/module.h>
 #include <linux/sigma.h>
 
-/* Return: 0==OK, <0==error, =1 ==no more actions */
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
 static int
-process_sigma_action(struct i2c_client *client, struct sigma_firmware *ssfw)
+process_sigma_action(struct i2c_client *client, struct sigma_action *sa)
 {
-	struct sigma_action *sa = (void *)(ssfw->fw->data + ssfw->pos);
 	size_t len = sigma_action_len(sa);
-	int ret = 0;
+	int ret;
 
 	pr_debug("%s: instr:%i addr:%#x len:%zu\n", __func__,
 		sa->instr, sa->addr, len);
@@ -29,44 +46,50 @@ process_sigma_action(struct i2c_client *client, struct sigma_firmware *ssfw)
 	case SIGMA_ACTION_WRITEXBYTES:
 	case SIGMA_ACTION_WRITESINGLE:
 	case SIGMA_ACTION_WRITESAFELOAD:
-		if (ssfw->fw->size < ssfw->pos + len)
-			return -EINVAL;
 		ret = i2c_master_send(client, (void *)&sa->addr, len);
 		if (ret < 0)
 			return -EINVAL;
 		break;
-
 	case SIGMA_ACTION_DELAY:
-		ret = 0;
 		udelay(len);
 		len = 0;
 		break;
-
 	case SIGMA_ACTION_END:
-		return 1;
-
+		return 0;
 	default:
 		return -EINVAL;
 	}
 
-	/* when arrive here ret=0 or sent data */
-	ssfw->pos += sigma_action_size(sa, len);
-	return ssfw->pos == ssfw->fw->size;
+	return 1;
 }
 
 static int
 process_sigma_actions(struct i2c_client *client, struct sigma_firmware *ssfw)
 {
-	pr_debug("%s: processing %p\n", __func__, ssfw);
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
 
-	while (1) {
-		int ret = process_sigma_action(client, ssfw);
 		pr_debug("%s: action returned %i\n", __func__, ret);
-		if (ret == 1)
-			return 0;
-		else if (ret)
+
+		if (ret <= 0)
 			return ret;
 	}
+
+	if (ssfw->pos != ssfw->fw->size)
+		return -EINVAL;
+
+	return 0;
 }
 
 int process_sigma_firmware(struct i2c_client *client, const char *name)
@@ -89,7 +112,12 @@ int process_sigma_firmware(struct i2c_client *client, const char *name)
 
 	/* then verify the header */
 	ret = -EINVAL;
-	if (fw->size < sizeof(*ssfw_head))
+
+	/* Reject too small or unreasonable large files. The upper limit is
+	 * chosen a bit arbitrarily but it should be enough for all practical
+	 * purposes and having the limit makes it easier to avoid integer
+	 * overflows later in the loading process. */
+	if (fw->size < sizeof(*ssfw_head) || fw->size >= 0x4000000)
 		goto done;
 
 	ssfw_head = (void *)fw->data;
diff --git a/include/linux/sigma.h b/include/linux/sigma.h
index e2accb3..9a138c2 100644
--- a/include/linux/sigma.h
+++ b/include/linux/sigma.h
@@ -50,11 +50,6 @@ static inline u32 sigma_action_len(struct sigma_action *sa)
 	return (sa->len_hi << 16) | sa->len;
 }
 
-static inline size_t sigma_action_size(struct sigma_action *sa, u32 payload_len)
-{
-	return sizeof(*sa) + payload_len + (payload_len % 2);
-}
-
 extern int process_sigma_firmware(struct i2c_client *client, const char *name);
 
 #endif
-- 
1.7.7.1


