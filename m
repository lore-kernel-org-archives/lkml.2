Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1IPMvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:51:07 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44147 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab1IPMus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:50:48 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Safford <safford@watson.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 3/5] trusted-keys: check hex2bin result
Date: Fri, 16 Sep 2011 08:50:28 -0400
Message-Id: <1316177430-13167-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

For each hex2bin call in trusted keys, check that the ascii hex string is
valid.  On failure, return -EINVAL.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/keys/trusted.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 0c33e2e..9b847e1 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -779,7 +779,9 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 			opt->pcrinfo_len = strlen(args[0].from) / 2;
 			if (opt->pcrinfo_len > MAX_PCRINFO_SIZE)
 				return -EINVAL;
-			hex2bin(opt->pcrinfo, args[0].from, opt->pcrinfo_len);
+			if (!hex2bin(opt->pcrinfo, args[0].from,
+				     opt->pcrinfo_len))
+				return -EINVAL;
 			break;
 		case Opt_keyhandle:
 			res = strict_strtoul(args[0].from, 16, &handle);
@@ -791,12 +793,16 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 		case Opt_keyauth:
 			if (strlen(args[0].from) != 2 * SHA1_DIGEST_SIZE)
 				return -EINVAL;
-			hex2bin(opt->keyauth, args[0].from, SHA1_DIGEST_SIZE);
+			if (!hex2bin(opt->keyauth, args[0].from,
+				     SHA1_DIGEST_SIZE))
+				return -EINVAL;
 			break;
 		case Opt_blobauth:
 			if (strlen(args[0].from) != 2 * SHA1_DIGEST_SIZE)
 				return -EINVAL;
-			hex2bin(opt->blobauth, args[0].from, SHA1_DIGEST_SIZE);
+			if (!hex2bin(opt->blobauth, args[0].from,
+				     SHA1_DIGEST_SIZE))
+				return -EINVAL;
 			break;
 		case Opt_migratable:
 			if (*args[0].from == '0')
@@ -860,7 +866,8 @@ static int datablob_parse(char *datablob, struct trusted_key_payload *p,
 		p->blob_len = strlen(c) / 2;
 		if (p->blob_len > MAX_BLOB_SIZE)
 			return -EINVAL;
-		hex2bin(p->blob, c, p->blob_len);
+		if (!hex2bin(p->blob, c, p->blob_len))
+			return -EINVAL;
 		ret = getoptions(datablob, p, o);
 		if (ret < 0)
 			return ret;
-- 
1.7.3.4

