Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab1ITNPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:15:31 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43201 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab1ITNP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:15:27 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 2/3] trusted-keys: check hex2bin result
Date: Tue, 20 Sep 2011 09:15:04 -0400
Message-Id: <1316524505-27272-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1316524505-27272-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316524505-27272-1-git-send-email-zohar@linux.vnet.ibm.com>
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

