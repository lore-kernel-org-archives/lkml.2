Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab1ITTxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:53:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38437 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1ITTxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:53:50 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Arnaud Lacombe <lacombar@gmail.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>
Subject: [PATCH v1 2/4] trusted-keys: check hex2bin result
Date: Tue, 20 Sep 2011 15:52:51 -0400
Message-Id: <1316548373-8782-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1316548373-8782-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316548373-8782-1-git-send-email-zohar@linux.vnet.ibm.com>
x-cbid: 11092019-2398-0000-0000-0000005CBD1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For each hex2bin call in trusted keys, check that the ascii hex string is
valid.  On failure, return -EINVAL.

Changelog v1:
- hex2bin now returns an int

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/keys/trusted.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 0c33e2e..0964fc2 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -779,7 +779,10 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 			opt->pcrinfo_len = strlen(args[0].from) / 2;
 			if (opt->pcrinfo_len > MAX_PCRINFO_SIZE)
 				return -EINVAL;
-			hex2bin(opt->pcrinfo, args[0].from, opt->pcrinfo_len);
+			res = hex2bin(opt->pcrinfo, args[0].from,
+				      opt->pcrinfo_len);
+			if (res < 0)
+				return -EINVAL;
 			break;
 		case Opt_keyhandle:
 			res = strict_strtoul(args[0].from, 16, &handle);
@@ -791,12 +794,18 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 		case Opt_keyauth:
 			if (strlen(args[0].from) != 2 * SHA1_DIGEST_SIZE)
 				return -EINVAL;
-			hex2bin(opt->keyauth, args[0].from, SHA1_DIGEST_SIZE);
+			res = hex2bin(opt->keyauth, args[0].from,
+				      SHA1_DIGEST_SIZE);
+			if (res < 0)
+				return -EINVAL;
 			break;
 		case Opt_blobauth:
 			if (strlen(args[0].from) != 2 * SHA1_DIGEST_SIZE)
 				return -EINVAL;
-			hex2bin(opt->blobauth, args[0].from, SHA1_DIGEST_SIZE);
+			res = hex2bin(opt->blobauth, args[0].from,
+				      SHA1_DIGEST_SIZE);
+			if (res < 0)
+				return -EINVAL;
 			break;
 		case Opt_migratable:
 			if (*args[0].from == '0')
@@ -860,7 +869,9 @@ static int datablob_parse(char *datablob, struct trusted_key_payload *p,
 		p->blob_len = strlen(c) / 2;
 		if (p->blob_len > MAX_BLOB_SIZE)
 			return -EINVAL;
-		hex2bin(p->blob, c, p->blob_len);
+		ret = hex2bin(p->blob, c, p->blob_len);
+		if (ret < 0)
+			return -EINVAL;
 		ret = getoptions(datablob, p, o);
 		if (ret < 0)
 			return ret;
-- 
1.7.3.4

