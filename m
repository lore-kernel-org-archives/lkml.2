Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1K1Inu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 03:43:50 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:23737 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab1K1In3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 03:43:29 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <drivers@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>, <stable@kernel.org>
Subject: [PATCH v2 3/7] firmware: Sigma: Fix endianess issues
Date: Mon, 28 Nov 2011 09:44:16 +0100
Message-ID: <1322469860-8210-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322469860-8210-1-git-send-email-lars@metafoo.de>
References: <1322469860-8210-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the SigmaDSP firmware loader only works correctly on little-endian
systems. Fix this by using the proper endianess conversion functions.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: stable@kernel.org
---
 drivers/firmware/sigma.c |    2 +-
 include/linux/sigma.h    |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/sigma.c b/drivers/firmware/sigma.c
index 36265de..1eedb6f 100644
--- a/drivers/firmware/sigma.c
+++ b/drivers/firmware/sigma.c
@@ -133,7 +133,7 @@ int process_sigma_firmware(struct i2c_client *client, const char *name)
 	crc = crc32(0, fw->data + sizeof(*ssfw_head),
 			fw->size - sizeof(*ssfw_head));
 	pr_debug("%s: crc=%x\n", __func__, crc);
-	if (crc != ssfw_head->crc)
+	if (crc != le32_to_cpu(ssfw_head->crc))
 		goto done;
 
 	ssfw.pos = sizeof(*ssfw_head);
diff --git a/include/linux/sigma.h b/include/linux/sigma.h
index 9a138c2..d0de882 100644
--- a/include/linux/sigma.h
+++ b/include/linux/sigma.h
@@ -24,7 +24,7 @@ struct sigma_firmware {
 struct sigma_firmware_header {
 	unsigned char magic[7];
 	u8 version;
-	u32 crc;
+	__le32 crc;
 };
 
 enum {
@@ -40,14 +40,14 @@ enum {
 struct sigma_action {
 	u8 instr;
 	u8 len_hi;
-	u16 len;
-	u16 addr;
+	__le16 len;
+	__be16 addr;
 	unsigned char payload[];
 };
 
 static inline u32 sigma_action_len(struct sigma_action *sa)
 {
-	return (sa->len_hi << 16) | sa->len;
+	return (sa->len_hi << 16) | le16_to_cpu(sa->len);
 }
 
 extern int process_sigma_firmware(struct i2c_client *client, const char *name);
-- 
1.7.7.3


