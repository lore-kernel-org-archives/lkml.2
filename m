Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2IGPbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:31:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab2IGPb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:31:27 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@lst.de,
        roland@kernel.org
Subject: [PATCH 09/11] target: support zero allocation length in SBC commands
Date: Fri,  7 Sep 2012 17:30:40 +0200
Message-Id: <1347031842-2531-10-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

READ CAPACITY must be subject to the same treatment as INQUIRY,
REQUEST SENSE, and MODE SENSE, but there are no pre-existing bugs
to fix here.  Just use an on-stack buffer, and copy to it after
checking the return value of transport_kmap_data_sg.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/target/target_core_sbc.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index a9dd946..868f8aa 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -40,8 +40,9 @@
 static int sbc_emulate_readcapacity(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *buf;
 	unsigned long long blocks_long = dev->transport->get_blocks(dev);
+	unsigned char *rbuf;
+	unsigned char buf[8];
 	u32 blocks;
 
 	if (blocks_long >= 0x00000000ffffffff)
@@ -49,8 +50,6 @@ static int sbc_emulate_readcapacity(struct se_cmd *cmd)
 	else
 		blocks = (u32)blocks_long;
 
-	buf = transport_kmap_data_sg(cmd);
-
 	buf[0] = (blocks >> 24) & 0xff;
 	buf[1] = (blocks >> 16) & 0xff;
 	buf[2] = (blocks >> 8) & 0xff;
@@ -60,7 +59,11 @@ static int sbc_emulate_readcapacity(struct se_cmd *cmd)
 	buf[6] = (dev->se_sub_dev->se_dev_attrib.block_size >> 8) & 0xff;
 	buf[7] = dev->se_sub_dev->se_dev_attrib.block_size & 0xff;
 
-	transport_kunmap_data_sg(cmd);
+	rbuf = transport_kmap_data_sg(cmd);
+	if (rbuf) {
+		memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
+		transport_kunmap_data_sg(cmd);
+	}
 
 	target_complete_cmd(cmd, GOOD);
 	return 0;
@@ -69,11 +72,11 @@ static int sbc_emulate_readcapacity(struct se_cmd *cmd)
 static int sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *buf;
+	unsigned char *rbuf;
+	unsigned char buf[32];
 	unsigned long long blocks = dev->transport->get_blocks(dev);
 
-	buf = transport_kmap_data_sg(cmd);
-
+	memset(buf, 0, sizeof(buf));
 	buf[0] = (blocks >> 56) & 0xff;
 	buf[1] = (blocks >> 48) & 0xff;
 	buf[2] = (blocks >> 40) & 0xff;
@@ -93,7 +96,11 @@ static int sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 	if (dev->se_sub_dev->se_dev_attrib.emulate_tpu || dev->se_sub_dev->se_dev_attrib.emulate_tpws)
 		buf[14] = 0x80;
 
-	transport_kunmap_data_sg(cmd);
+	rbuf = transport_kmap_data_sg(cmd);
+	if (rbuf) {
+		memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
+		transport_kunmap_data_sg(cmd);
+	}
 
 	target_complete_cmd(cmd, GOOD);
 	return 0;
-- 
1.7.1


