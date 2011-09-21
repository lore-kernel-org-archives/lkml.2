Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1IUMfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:35:39 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41126 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab1IUMfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:35:37 -0400
Subject: Re: [PATCH v1 4/4] target: check hex2bin result (updated)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Arnaud Lacombe <lacombar@gmail.com>, James.Mor@us.ibm.com
In-Reply-To: <1316548373-8782-5-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316548373-8782-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1316548373-8782-5-git-send-email-zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 08:35:31 -0400
Message-ID: <1316608531.3155.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that hex2bin does error checking, on error add debugging error msg.

Changelog v1 (update):
- fixed definition of 'ret'
- hex2bin now returns an int

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/target/target_core_fabric_lib.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index c4ea3a9..39f021b 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -63,6 +63,7 @@ u32 sas_get_pr_transport_id(
 	unsigned char *buf)
 {
 	unsigned char *ptr;
+	int ret;
 
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
@@ -156,8 +159,9 @@ u32 fc_get_pr_transport_id(
 	unsigned char *buf)
 {
 	unsigned char *ptr;
-	int i;
+	int i, ret;
 	u32 off = 8;
+
 	/*
 	 * PROTOCOL IDENTIFIER is 0h for FCP-2
 	 *
@@ -174,7 +178,9 @@ u32 fc_get_pr_transport_id(
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


