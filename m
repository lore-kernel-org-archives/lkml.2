Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab1ARBkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 20:40:24 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59643 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab1ARBkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 20:40:22 -0500
X-Nat-Received: from [202.181.97.72]:52577 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1295314783.8420
Message-Id: <201101180139.p0I1dh9T066040@www262.sakura.ne.jp>
Subject: [PATCH 3/3] trusted-keys: small cleanup
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: zohar@linux.vnet.ibm.com
Cc: safford@watson.ibm.com, safford@us.ibm.com, jj@chaosbits.net,
        dhowells@redhat.com, jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Jan 2011 10:39:43 +0900
References: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net> <1295011682.7804.2.camel@localhost.localdomain> <201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp> <201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp> <alpine.LNX.2.00.1101161504050.8049@swampdragon.chaosbits.net> <201101170039.p0H0d1f5085735@www262.sakura.ne.jp> <201101170041.p0H0ffFE086481@www262.sakura.ne.jp> <201101170044.p0H0iLQW087457@www262.sakura.ne.jp> <1295298400.2642.9.camel@localhost.localdomain>
In-Reply-To: <1295298400.2642.9.camel@localhost.localdomain>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 17012011 #4672815, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar wrote:
> Change the existing '(!ret)' to '(ret < 0)', like the rest of the code?
> It's not wrong, but ....

Something like this?
----------------------------------------
>From 9793efa6fbef62d9e85a06c329761c081ff804c5 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 18 Jan 2011 10:14:32 +0900
Subject: [PATCH 3/3] trusted-keys: small cleanup

We can avoid scattering va_end() by changing from

  initialize();
  va_start();
  for (;;) {
    if (error condition) {
      va_end();
      goto out;
    }
  }
  va_end();
  if (error condition)
    goto out;
  finalize();
 out:

to

  initialize();
  va_start();
  for (;;) {
    if (error condition)
      break;
  }
  va_end();
  if (error condition)
    goto out;
  finalize();
 out:

.

Also, use

  if (ret < 0)
    goto out;

rather than

  if (!ret)
    ret = do_something();

to clarify error condition.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/keys/trusted_defined.c |   43 ++++++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
index f7d0677..bc04de1 100644
--- a/security/keys/trusted_defined.c
+++ b/security/keys/trusted_defined.c
@@ -101,7 +101,7 @@ static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
 		if (dlen == 0)
 			break;
 		data = va_arg(argp, unsigned char *);
-		if (data == NULL) {
+		if (!data) {
 			ret = -EINVAL;
 			break;
 		}
@@ -110,8 +110,9 @@ static int TSS_rawhmac(unsigned char *digest, const unsigned char *key,
 			break;
 	}
 	va_end(argp);
-	if (!ret)
-		ret = crypto_shash_final(&sdesc->shash, digest);
+	if (ret < 0)
+		goto out;
+	ret = crypto_shash_final(&sdesc->shash, digest);
 out:
 	kfree(sdesc);
 	return ret;
@@ -150,21 +151,21 @@ static int TSS_authhmac(unsigned char *digest, const unsigned char *key,
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
+	if (ret < 0)
+		goto out;
 	ret = crypto_shash_final(&sdesc->shash, paramdigest);
-	if (!ret)
-		ret = TSS_rawhmac(digest, key, keylen, SHA1_DIGEST_SIZE,
-				  paramdigest, TPM_NONCE_SIZE, h1,
-				  TPM_NONCE_SIZE, h2, 1, &c, 0, 0);
+	if (ret < 0)
+		goto out;
+	ret = TSS_rawhmac(digest, key, keylen, SHA1_DIGEST_SIZE,
+			  paramdigest, TPM_NONCE_SIZE, h1,
+			  TPM_NONCE_SIZE, h2, 1, &c, 0, 0);
 out:
 	kfree(sdesc);
 	return ret;
@@ -229,12 +230,12 @@ static int TSS_checkhmac1(unsigned char *buffer,
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
+	if (ret < 0)
+		goto out;
 	ret = crypto_shash_final(&sdesc->shash, paramdigest);
 	if (ret < 0)
 		goto out;
@@ -323,12 +324,12 @@ static int TSS_checkhmac2(unsigned char *buffer,
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
+	if (ret < 0)
+		goto out;
 	ret = crypto_shash_final(&sdesc->shash, paramdigest);
 	if (ret < 0)
 		goto out;
-- 
1.7.1

