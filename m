Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664Ab1DNR5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:57:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:41364 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab1DNR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:57:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 119/209] crypto: padlock - Fix AES-CBC handling on odd-block-sized input
Date: Thu, 14 Apr 2011 13:54:37 -0400
Message-Id: <1302803767-9715-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit c054a076a1bd4731820a9c4d638b13d5c9bf5935 upstream.

On certain VIA chipsets AES-CBC requires the input/output to be
a multiple of 64 bytes.  We had a workaround for this but it was
buggy as it sent the whole input for processing when it is meant
to only send the initial number of blocks which makes the rest
a multiple of 64 bytes.

As expected this causes memory corruption whenever the workaround
kicks in.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/crypto/padlock-aes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 2e992bc..8a515ba 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -286,7 +286,7 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
 	if (initial)
 		asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"	/* rep xcryptcbc */
 			      : "+S" (input), "+D" (output), "+a" (iv)
-			      : "d" (control_word), "b" (key), "c" (count));
+			      : "d" (control_word), "b" (key), "c" (initial));
 
 	asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"	/* rep xcryptcbc */
 		      : "+S" (input), "+D" (output), "+a" (iv)
-- 
1.7.4.4

