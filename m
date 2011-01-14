Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab1ANOH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:07:56 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:49993 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1ANOHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:07:48 -0500
To: safford@watson.ibm.com
Cc: dhowells@redhat.com, safford@us.ibm.com, jmorris@namei.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Trusted and Encrypted Keys: fix up TSS_rawhmac() so wealways kfree() and remember to call va_end()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net>
	<1295011682.7804.2.camel@localhost.localdomain>
	<201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp>
In-Reply-To: <201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp>
Message-Id: <201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 14 Jan 2011 23:07:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Please wait. That patch is incorrect. I'm making patch now.
I'm doing "git pull" now. Using 2.6.37-git11 instead.

James Morris wrote:
> It's queued in my for-linus branch, waiting to see what happens with 
> http://marc.info/?l=linux-security-module&m=129494927918805&w=3

I think above patch is incorrect because va_end() might be called without
va_start(). C says va_start() without va_end() causes undefined behavior.
I think va_end() without va_start() causes undefined behavior as well.



[PATCH 1/3] Trusted and Encrypted Keys: fix memory leak.

Use "break" rather than "return"/"goto" in order to make sure that
va_end() is always called.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/keys/trusted_defined.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.37-git11.orig/security/keys/trusted_defined.c
+++ linux-2.6.37-git11/security/keys/trusted_defined.c
@@ -101,11 +101,13 @@ static int TSS_rawhmac(unsigned char *di
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



By the way, TSS_authhmac() has similar code. 

	data = va_arg(argp, unsigned char *);
	ret = crypto_shash_update(&sdesc->shash, data, dlen);

I don't know why we check for NULL in TSS_rawhmac(), but
I think we should check for NULL in TSS_authhmac() as well.



[PATCH 2/3] Trusted and Encrypted Keys: check for NULL.

Check for NULL in TSS_authhmac() as well as TSS_rawhmac().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/keys/trusted_defined.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.37-git11.orig/security/keys/trusted_defined.c
+++ linux-2.6.37-git11/security/keys/trusted_defined.c
@@ -148,6 +148,11 @@ static int TSS_authhmac(unsigned char *d
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



Also, on the assumption that crypto_shash_init()/crypto_shash_update() return 0
on success and negative value otherwise, below cleanup is possible.



[PATCH 3/3] Trusted and Encrypted Keys: avoid goto within va_start()/va_end()

Avoid use of "goto" inside

  va_start();
  for (;;) {

  }
  va_end();

in order to avoid scattering va_end() inside the loop.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/keys/trusted_defined.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- linux-2.6.37-git11.orig/security/keys/trusted_defined.c
+++ linux-2.6.37-git11/security/keys/trusted_defined.c
@@ -150,17 +150,15 @@ static int TSS_authhmac(unsigned char *d
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
@@ -229,13 +227,12 @@ static int TSS_checkhmac1(unsigned char 
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
 
@@ -323,13 +320,12 @@ static int TSS_checkhmac2(unsigned char 
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
 



Not tested at all. Please review and test.
