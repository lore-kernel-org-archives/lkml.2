Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1K1In3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 03:43:29 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:16891
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988Ab1K1In1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 03:43:27 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <drivers@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 5/7] ASoC: SigmaDSP: Provide diagnostic error messages
Date: Mon, 28 Nov 2011 09:44:18 +0100
Message-ID: <1322469860-8210-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322469860-8210-1-git-send-email-lars@metafoo.de>
References: <1322469860-8210-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide some error messages when loading the firmware fails, so it is possible
to diagnose the reason for the failure.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Changes since v1:
	* Don't split error message string across multiple lines.
---
 sound/soc/codecs/sigmadsp.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/sigmadsp.c b/sound/soc/codecs/sigmadsp.c
index acb97a9..c0ad885 100644
--- a/sound/soc/codecs/sigmadsp.c
+++ b/sound/soc/codecs/sigmadsp.c
@@ -124,18 +124,25 @@ int process_sigma_firmware(struct i2c_client *client, const char *name)
 	 * purposes and having the limit makes it easier to avoid integer
 	 * overflows later in the loading process.
 	 */
-	if (fw->size < sizeof(*ssfw_head) || fw->size >= 0x4000000)
+	if (fw->size < sizeof(*ssfw_head) || fw->size >= 0x4000000) {
+		dev_err(&client->dev, "Failed to load firmware: Invalid size\n");
 		goto done;
+	}
 
 	ssfw_head = (void *)fw->data;
-	if (memcmp(ssfw_head->magic, SIGMA_MAGIC, ARRAY_SIZE(ssfw_head->magic)))
+	if (memcmp(ssfw_head->magic, SIGMA_MAGIC, ARRAY_SIZE(ssfw_head->magic))) {
+		dev_err(&client->dev, "Failed to load firmware: Invalid magic\n");
 		goto done;
+	}
 
 	crc = crc32(0, fw->data + sizeof(*ssfw_head),
 			fw->size - sizeof(*ssfw_head));
 	pr_debug("%s: crc=%x\n", __func__, crc);
-	if (crc != le32_to_cpu(ssfw_head->crc))
+	if (crc != le32_to_cpu(ssfw_head->crc)) {
+		dev_err(&client->dev, "Failed to load firmware: Wrong crc checksum: expected %x got %x\n",
+			le32_to_cpu(ssfw_head->crc), crc);
 		goto done;
+	}
 
 	ssfw.pos = sizeof(*ssfw_head);
 
-- 
1.7.7.3


