Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab1AQAjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 19:39:36 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:53179 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1AQAjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 19:39:35 -0500
X-Nat-Received: from [202.181.97.72]:64884 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1295224741.17950
Message-Id: <201101170039.p0H0d1f5085735@www262.sakura.ne.jp>
Subject: [PATCH 1/3] trusted-keys: another free memory bugfix
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: safford@watson.ibm.com, safford@us.ibm.com
Cc: jj@chaosbits.net, dhowells@redhat.com, jmorris@namei.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Jan 2011 09:39:01 +0900
References: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net> <1295011682.7804.2.camel@localhost.localdomain> <201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp> <201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp> <alpine.LNX.2.00.1101161504050.8049@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1101161504050.8049@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 16012011 #4657071, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending in separated mails in case somebody missed that
there was 3 patches in one mail.
----------------------------------------
>From 94e965700f1e401408836d4aa782105483196842 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 17 Jan 2011 09:22:47 +0900
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
1.7.1

