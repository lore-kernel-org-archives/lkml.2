Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3ACMUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:20:22 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:33414 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3ACMUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:20:13 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org
Subject: [PATCH -v2 17/26] mtd: rename random32() to prandom_u32()
Date: Thu,  3 Jan 2013 21:19:13 +0900
Message-Id: <1357215562-6288-18-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org
---

No change from v1

 drivers/mtd/nand/nandsim.c          |  6 +++---
 drivers/mtd/tests/mtd_nandecctest.c | 10 +++++-----
 drivers/mtd/tests/mtd_stresstest.c  |  8 ++++----
 drivers/mtd/ubi/debug.h             |  6 +++---
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index 818b65c..4c31798 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -1476,12 +1476,12 @@ int do_read_error(struct nandsim *ns, int num)
 
 void do_bit_flips(struct nandsim *ns, int num)
 {
-	if (bitflips && random32() < (1 << 22)) {
+	if (bitflips && prandom_u32() < (1 << 22)) {
 		int flips = 1;
 		if (bitflips > 1)
-			flips = (random32() % (int) bitflips) + 1;
+			flips = (prandom_u32() % (int) bitflips) + 1;
 		while (flips--) {
-			int pos = random32() % (num * 8);
+			int pos = prandom_u32() % (num * 8);
 			ns->buf.byte[pos / 8] ^= (1 << (pos % 8));
 			NS_WARN("read_page: flipping bit %d in page %d "
 				"reading from %d ecc: corrected=%u failed=%u\n",
diff --git a/drivers/mtd/tests/mtd_nandecctest.c b/drivers/mtd/tests/mtd_nandecctest.c
index ceb261f..2e6b41e 100644
--- a/drivers/mtd/tests/mtd_nandecctest.c
+++ b/drivers/mtd/tests/mtd_nandecctest.c
@@ -43,7 +43,7 @@ struct nand_ecc_test {
 static void single_bit_error_data(void *error_data, void *correct_data,
 				size_t size)
 {
-	unsigned int offset = random32() % (size * BITS_PER_BYTE);
+	unsigned int offset = prandom_u32() % (size * BITS_PER_BYTE);
 
 	memcpy(error_data, correct_data, size);
 	__change_bit_le(offset, error_data);
@@ -54,9 +54,9 @@ static void double_bit_error_data(void *error_data, void *correct_data,
 {
 	unsigned int offset[2];
 
-	offset[0] = random32() % (size * BITS_PER_BYTE);
+	offset[0] = prandom_u32() % (size * BITS_PER_BYTE);
 	do {
-		offset[1] = random32() % (size * BITS_PER_BYTE);
+		offset[1] = prandom_u32() % (size * BITS_PER_BYTE);
 	} while (offset[0] == offset[1]);
 
 	memcpy(error_data, correct_data, size);
@@ -67,7 +67,7 @@ static void double_bit_error_data(void *error_data, void *correct_data,
 
 static unsigned int random_ecc_bit(size_t size)
 {
-	unsigned int offset = random32() % (3 * BITS_PER_BYTE);
+	unsigned int offset = prandom_u32() % (3 * BITS_PER_BYTE);
 
 	if (size == 256) {
 		/*
@@ -75,7 +75,7 @@ static unsigned int random_ecc_bit(size_t size)
 		 * and 17th bit) in ECC code for 256 byte data block
 		 */
 		while (offset == 16 || offset == 17)
-			offset = random32() % (3 * BITS_PER_BYTE);
+			offset = prandom_u32() % (3 * BITS_PER_BYTE);
 	}
 
 	return offset;
diff --git a/drivers/mtd/tests/mtd_stresstest.c b/drivers/mtd/tests/mtd_stresstest.c
index dc89e32..4e9fc1f 100644
--- a/drivers/mtd/tests/mtd_stresstest.c
+++ b/drivers/mtd/tests/mtd_stresstest.c
@@ -57,7 +57,7 @@ static int rand_eb(void)
 	unsigned int eb;
 
 again:
-	eb = random32();
+	eb = prandom_u32();
 	/* Read or write up 2 eraseblocks at a time - hence 'ebcnt - 1' */
 	eb %= (ebcnt - 1);
 	if (bbt[eb])
@@ -69,7 +69,7 @@ static int rand_offs(void)
 {
 	unsigned int offs;
 
-	offs = random32();
+	offs = prandom_u32();
 	offs %= bufsize;
 	return offs;
 }
@@ -78,7 +78,7 @@ static int rand_len(int offs)
 {
 	unsigned int len;
 
-	len = random32();
+	len = prandom_u32();
 	len %= (bufsize - offs);
 	return len;
 }
@@ -148,7 +148,7 @@ static int do_write(void)
 
 static int do_operation(void)
 {
-	if (random32() & 1)
+	if (prandom_u32() & 1)
 		return do_read();
 	else
 		return do_write();
diff --git a/drivers/mtd/ubi/debug.h b/drivers/mtd/ubi/debug.h
index 33f8f3b..cba89fc 100644
--- a/drivers/mtd/ubi/debug.h
+++ b/drivers/mtd/ubi/debug.h
@@ -86,7 +86,7 @@ static inline int ubi_dbg_is_bgt_disabled(const struct ubi_device *ubi)
 static inline int ubi_dbg_is_bitflip(const struct ubi_device *ubi)
 {
 	if (ubi->dbg.emulate_bitflips)
-		return !(random32() % 200);
+		return !(prandom_u32() % 200);
 	return 0;
 }
 
@@ -100,7 +100,7 @@ static inline int ubi_dbg_is_bitflip(const struct ubi_device *ubi)
 static inline int ubi_dbg_is_write_failure(const struct ubi_device *ubi)
 {
 	if (ubi->dbg.emulate_io_failures)
-		return !(random32() % 500);
+		return !(prandom_u32() % 500);
 	return 0;
 }
 
@@ -114,7 +114,7 @@ static inline int ubi_dbg_is_write_failure(const struct ubi_device *ubi)
 static inline int ubi_dbg_is_erase_failure(const struct ubi_device *ubi)
 {
 	if (ubi->dbg.emulate_io_failures)
-		return !(random32() % 400);
+		return !(prandom_u32() % 400);
 	return 0;
 }
 
-- 
1.7.11.7

