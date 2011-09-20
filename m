Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157Ab1ITTyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:54:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60985 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab1ITTyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:54:07 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Arnaud Lacombe <lacombar@gmail.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>
Subject: [PATCH v1 4/4] target: check hex2bin result
Date: Tue, 20 Sep 2011 15:52:53 -0400
Message-Id: <1316548373-8782-5-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1316548373-8782-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316548373-8782-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that hex2bin does error checking, on error add debugging error msg.

Changelog v1:
- hex2bin now returns an int

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 drivers/target/target_core_fabric_lib.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index c4ea3a9..17658ca 100644
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
+	if (ret < 0)
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
+		ret = hex2bin(&buf[off++], &ptr[i], 1);
+		if (ret < 0)
+			pr_debug("fc transport_id: invalid hex string\n");
 		i += 2;
 	}
 	/*
-- 
1.7.3.4

