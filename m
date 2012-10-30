Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab2J3ShW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:37:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45244 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2J3ShT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:37:19 -0400
From: Behan Webster <behanw@converseincode.com>
To: herbert@gondor.hengli.com.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        pageexec@freemail.hu, Behan Webster <behanw@converseincode.com>
Subject: [PATCH 2/2] Remove VLAIS usage from crypto/testmgr.c
Date: Tue, 30 Oct 2012 14:37:29 -0400
Message-Id: <1351622249-18084-3-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351622249-18084-1-git-send-email-behanw@converseincode.com>
References: <1351622249-18084-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
precludes the use of compilers which don't implement VLAIS (for instance the
Clang compiler). This patch instead allocates the appropriate amount of memory
using an char array.

Patch from series at
http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
by PaX Team.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Cc: pageexec@freemail.hu
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 crypto/testmgr.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 941d75c..5b7b3a6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1578,16 +1578,19 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 	}
 
 	do {
-		struct {
-			struct shash_desc shash;
-			char ctx[crypto_shash_descsize(tfm)];
-		} sdesc;
-
-		sdesc.shash.tfm = tfm;
-		sdesc.shash.flags = 0;
-
-		*(u32 *)sdesc.ctx = le32_to_cpu(420553207);
-		err = crypto_shash_final(&sdesc.shash, (u8 *)&val);
+		char sdesc[sizeof(struct shash_desc)
+			+ crypto_shash_descsize(tfm)
+			+ CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
+		struct shash_desc *shash = (struct shash_desc *)sdesc;
+		u32 *ctx = (u32 *)((unsigned long)(sdesc
+			+ sizeof(struct shash_desc) + CRYPTO_MINALIGN - 1)
+			& ~(CRYPTO_MINALIGN - 1));
+
+		shash->tfm = tfm;
+		shash->flags = 0;
+
+		*ctx = le32_to_cpu(420553207);
+		err = crypto_shash_final(shash, (u8 *)&val);
 		if (err) {
 			printk(KERN_ERR "alg: crc32c: Operation failed for "
 			       "%s: %d\n", driver, err);
-- 
1.7.9.5

