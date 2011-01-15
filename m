Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1AOA6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 19:58:32 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55367 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab1AOA6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 19:58:31 -0500
To: safford@watson.ibm.com, dhowells@redhat.com, jj@chaosbits.net
Cc: jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Trusted and Encrypted Keys: fix up TSS_rawhmac() so wealways kfree() and remember to call va_end()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net>
	<1295011682.7804.2.camel@localhost.localdomain>
	<201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp>
	<201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp>
In-Reply-To: <201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp>
Message-Id: <201101150958.HJG17666.tFOOFSFVLQHJOM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 15 Jan 2011 09:58:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Tetsuo Handa wrote:
> > Please wait. That patch is incorrect. I'm making patch now.
> I'm doing "git pull" now. Using 2.6.37-git11 instead.
"git pull" completed.
Refreshed using security-testing-2.6#for-linus and compile tested.
Please review and test.

 From 161ec4ee18cc86b41277b9a92a8fb2e732b3662f Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 15 Jan 2011 05:23:53 +0900
Subject: [PATCH 1/3] trusted-keys: another free memory bugfix

TSS_rawhmac() forgot to call va_end()/kfree() when data == NULL and
forgot to call va_end() when crypto_shash_update() < 0.
Fix these bugs by escaping from the loop using "break"
(rather than "return"/"goto") in order to make sure that
va_end()/kfree() are always called.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/keys/trusted_defined.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
index 932f868..7b21795 100644
--- a/security/keys/trusted_defined.c
+++ b/security/keys/trusted_defined.c
@@ -101,11 +101,13 @@ static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
 		if (dlen == 0)
 			break;
 		data = va_arg(argp, unsigned char *);
-		if (data == NULL)
-			return -EINVAL;
+		if (data == NULL) {
+			ret = -EINVAL;
+			break;
+		}
 		ret = crypto_shash_update(&sdesc->shash, data, dlen);
 		if (ret < 0)
-			goto out;
+			break;
 	}
 	va_end(argp);
 	if (!ret)
-- 
1.6.1

 From 06bbcce524ceedb404519cade2c592d66c251595 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 15 Jan 2011 05:40:51 +0900
Subject: [PATCH 2/3] trusted-keys: check for NULL before using it

TSS_rawhmac() checks for data != NULL before using it.
We should do the same thing for TSS_authhmac().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/keys/trusted_defined.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
index 7b21795..f7d0677 100644
--- a/security/keys/trusted_defined.c
+++ b/security/keys/trusted_defined.c
@@ -148,6 +148,11 @@ static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
 		if (dlen == 0)
 			break;
 		data = va_arg(argp, unsigned char *);
+		if (!data) {
+			ret = -EINVAL;
+			va_end(argp);
+			goto out;
+		}
 		ret = crypto_shash_update(&sdesc->shash, data, dlen);
 		if (ret < 0) {
 			va_end(argp);
-- 
1.6.1

 From b4d611a1489da65366ad3e72a00093be76d39fc5 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 15 Jan 2011 05:47:22 +0900
Subject: [PATCH 3/3] trusted-keys: avoid scattring va_end()

We can avoid scattering va_end() within the

  va_start();
  for (;;) {

  }
  va_end();

loop, assuming that crypto_shash_init()/crypto_shash_update() return 0 on
success and negative value otherwise.

Make TSS_authhmac()/TSS_checkhmac1()/TSS_checkhmac2() similar to TSS_rawhmac()
by removing "va_end()/goto" from the loop.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/keys/trusted_defined.c |   30 +++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
index f7d0677..2836c6d 100644
--- a/security/keys/trusted_defined.c
+++ b/security/keys/trusted_defined.c
@@ -150,17 +150,15 @@ static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
 		data = va_arg(argp, unsigned char *);
 		if (!data) {
 			ret = -EINVAL;
-			va_end(argp);
-			goto out;
+			break;
 		}
 		ret = crypto_shash_update(&sdesc->shash, data, dlen);
-		if (ret < 0) {
-			va_end(argp);
-			goto out;
-		}
+		if (ret < 0)
+			break;
 	}
 	va_end(argp);
-	ret = crypto_shash_final(&sdesc->shash, paramdigest);
+	if (!ret)
+		ret = crypto_shash_final(&sdesc->shash, paramdigest);
 	if (!ret)
 		ret = TSS_rawhmac(digest, key, keylen, SHA1_DIGEST_SIZE,
 				  paramdigest, TPM_NONCE_SIZE, h1,
@@ -229,13 +227,12 @@ static int TSS_checkhmac1(unsigned char *buffer,
 			break;
 		dpos = va_arg(argp, unsigned int);
 		ret = crypto_shash_update(&sdesc->shash, buffer + dpos, dlen);
-		if (ret < 0) {
-			va_end(argp);
-			goto out;
-		}
+		if (ret < 0)
+			break;
 	}
 	va_end(argp);
-	ret = crypto_shash_final(&sdesc->shash, paramdigest);
+	if (!ret)
+		ret = crypto_shash_final(&sdesc->shash, paramdigest);
 	if (ret < 0)
 		goto out;
 
@@ -323,13 +320,12 @@ static int TSS_checkhmac2(unsigned char *buffer,
 			break;
 		dpos = va_arg(argp, unsigned int);
 		ret = crypto_shash_update(&sdesc->shash, buffer + dpos, dlen);
-		if (ret < 0) {
-			va_end(argp);
-			goto out;
-		}
+		if (ret < 0)
+			break;
 	}
 	va_end(argp);
-	ret = crypto_shash_final(&sdesc->shash, paramdigest);
+	if (!ret)
+		ret = crypto_shash_final(&sdesc->shash, paramdigest);
 	if (ret < 0)
 		goto out;
 
-- 
1.6.1
