Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1LGQ7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:59:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211Ab1LGQRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:17:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:26 2011
Message-Id: <20111207160826.235689614@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:04 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [44/80] firmware: Sigma: Fix endianess issues
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit bda63586bc5929e97288cdb371bb6456504867ed upstream.

Currently the SigmaDSP firmware loader only works correctly on little-endian
systems. Fix this by using the proper endianess conversion functions.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firmware/sigma.c |    2 +-
 include/linux/sigma.h    |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/firmware/sigma.c
+++ b/drivers/firmware/sigma.c
@@ -133,7 +133,7 @@ int process_sigma_firmware(struct i2c_cl
 	crc = crc32(0, fw->data + sizeof(*ssfw_head),
 			fw->size - sizeof(*ssfw_head));
 	pr_debug("%s: crc=%x\n", __func__, crc);
-	if (crc != ssfw_head->crc)
+	if (crc != le32_to_cpu(ssfw_head->crc))
 		goto done;
 
 	ssfw.pos = sizeof(*ssfw_head);
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


