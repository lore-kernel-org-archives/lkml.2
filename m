Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422758Ab2JaLWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:22:50 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48864 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935456Ab2JaLWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:22:46 -0400
From: Behan Webster <behanw@converseincode.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>, pageexec@freemail.hu,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH V2] Remove VLAIS usage from libcrc32c.c
Date: Wed, 31 Oct 2012 07:23:05 -0400
Message-Id: <1351682585-6772-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.7.9.5
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
[Use shash_desc_ctx() to calculate address of ctx]
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 lib/libcrc32c.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 244f548..c155b3f 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -41,20 +41,20 @@ static struct crypto_shash *tfm;
 
 u32 crc32c(u32 crc, const void *address, unsigned int length)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
-	} desc;
+	char desc[sizeof(struct shash_desc) + crypto_shash_descsize(tfm)
+		+ CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
+	u32 *ctx = (u32 *)shash_desc_ctx(shash);
 	int err;
 
-	desc.shash.tfm = tfm;
-	desc.shash.flags = 0;
-	*(u32 *)desc.ctx = crc;
+	shash->tfm = tfm;
+	shash->flags = 0;
+	*ctx = crc;
 
-	err = crypto_shash_update(&desc.shash, address, length);
+	err = crypto_shash_update(shash, address, length);
 	BUG_ON(err);
 
-	return *(u32 *)desc.ctx;
+	return *ctx;
 }
 
 EXPORT_SYMBOL(crc32c);
-- 
1.7.9.5

