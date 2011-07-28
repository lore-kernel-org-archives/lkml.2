Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab1G1FRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:17:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:51308 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab1G1FQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:16:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 05/11] crypto.h: remove unused crypto_tfm_alg_modname() inline
Date: Thu, 28 Jul 2011 01:16:12 -0400
Message-Id: <1311830178-30314-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The <linux/crypto.h> (which is in turn in common headers
like tcp.h) wants to use module_name() in an inline fcn.
But having all of <linux/module.h> along for the ride is
overkill and slows down compiles by a measureable amount,
since it in turn includes lots of headers.

Since the inline is never used anywhere in the kernel[1],
we can just remove it, and then also remove the module.h
include as well.

In all the many crypto modules, there were some relying on
crypto.h including module.h -- for them we now explicitly
call out module.h for inclusion.

[1] git grep shows some staging drivers also define the same
static inline, but they also never ever use it.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/crypto.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e5e468e..1e51f9a 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -18,7 +18,6 @@
 #define _LINUX_CRYPTO_H
 
 #include <linux/atomic.h>
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/slab.h>
@@ -505,11 +504,6 @@ static inline int crypto_tfm_alg_priority(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_priority;
 }
 
-static inline const char *crypto_tfm_alg_modname(struct crypto_tfm *tfm)
-{
-	return module_name(tfm->__crt_alg->cra_module);
-}
-
 static inline u32 crypto_tfm_alg_type(struct crypto_tfm *tfm)
 {
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
-- 
1.7.6

