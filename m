Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520Ab2J3SoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:44:16 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:50463 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2J3SoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:44:14 -0400
From: Behan Webster <behanw@converseincode.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>, pageexec@freemail.hu,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] Remove VLAIS usage from libcrc32c.c
Date: Tue, 30 Oct 2012 14:44:25 -0400
Message-Id: <1351622665-18547-1-git-send-email-behanw@converseincode.com>
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
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 lib/libcrc32c.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 244f548..5d0bac8 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -41,20 +41,21 @@ static struct crypto_shash *tfm;
 
 u32 crc32c(u32 crc, const void *address, unsigned int length)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
-	} desc;
+	char desc[sizeof(struct shash_desc) + crypto_shash_descsize(tfm)
+		+ CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
+	u32 *ctx = (u32 *)((unsigned long)(desc + sizeof(struct shash_desc)
+		+ CRYPTO_MINALIGN - 1) & ~(CRYPTO_MINALIGN - 1));
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

