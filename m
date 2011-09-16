Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1IPMvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:51:16 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48897 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab1IPMvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:51:11 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Safford <safford@watson.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 5/5] target: check hex2bin result
Date: Fri, 16 Sep 2011 08:50:30 -0400
Message-Id: <1316177430-13167-5-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that hex2bin does error checking, on error add debugging error msg.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 drivers/target/target_core_cdb.c        |    5 ++++-
 drivers/target/target_core_fabric_lib.c |   11 +++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 8ae09a1..004f6b1 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -167,6 +167,7 @@ target_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	u32 prod_len;
 	u32 unit_serial_len, off = 0;
 	u16 len = 0, id_len;
+	bool ret;
 
 	off = 4;
 
@@ -215,7 +216,9 @@ target_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	 * VENDOR_SPECIFIC_IDENTIFIER_EXTENTION
 	 */
 	buf[off++] |= hex_to_bin(dev->se_sub_dev->t10_wwn.unit_serial[0]);
-	hex2bin(&buf[off], &dev->se_sub_dev->t10_wwn.unit_serial[1], 12);
+	ret = hex2bin(&buf[off], &dev->se_sub_dev->t10_wwn.unit_serial[1], 12);
+	if (!ret)
+		pr_debug("unit_serial: invalid hex string\n");
 
 	len = 20;
 	off = (len + 4);
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index c4ea3a9..aa31452 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -63,6 +63,7 @@ u32 sas_get_pr_transport_id(
 	unsigned char *buf)
 {
 	unsigned char *ptr;
+	bool ret;
 
 	/*
 	 * Set PROTOCOL IDENTIFIER to 6h for SAS
@@ -74,7 +75,9 @@ u32 sas_get_pr_transport_id(
 	 */
 	ptr = &se_nacl->initiatorname[4]; /* Skip over 'naa. prefix */
 
-	hex2bin(&buf[4], ptr, 8);
+	ret = hex2bin(&buf[4], ptr, 8);
+	if (!ret)
+		pr_debug("sas transport_id: invalid hex string\n");
 
 	/*
 	 * The SAS Transport ID is a hardcoded 24-byte length
@@ -158,6 +161,8 @@ u32 fc_get_pr_transport_id(
 	unsigned char *ptr;
 	int i;
 	u32 off = 8;
+	bool ret;
+
 	/*
 	 * PROTOCOL IDENTIFIER is 0h for FCP-2
 	 *
@@ -174,7 +179,9 @@ u32 fc_get_pr_transport_id(
 			i++;
 			continue;
 		}
-		hex2bin(&buf[off++], &ptr[i], 1);
+		ret = unpack_hex_byte(&buf[off++], &ptr[i]);
+		if (!ret)
+			pr_debug("fc transport_id: invalid hex string\n");
 		i += 2;
 	}
 	/*
-- 
1.7.3.4

