Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab2AGFvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 00:51:35 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46030 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2AGFvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 00:51:19 -0500
Subject: [PATCH 04/14] crc32: Speed up memory table access on powerpc
To: Andrew Morton <akpm@linux-foundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Darrick J. Wong" <djwong@us.ibm.com>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Theodore Tso <tytso@mit.edu>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
Date: Fri, 06 Jan 2012 21:51:09 -0800
Message-ID: <20120107055109.31315.85783.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20120107055042.31315.63119.stgit@elm3c44.beaverton.ibm.com>
References: <20120107055042.31315.63119.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12010705-2398-0000-0000-0000033A016C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace 2D array references by pointer references in loops.
This change has no effect on X86 code but improves PPC
performance.

From: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/crc32.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index 7a0e5a9..c93c9ae 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -53,20 +53,21 @@ static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
-#  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
-		tab[2][(crc >> 8) & 255] ^ \
-		tab[1][(crc >> 16) & 255] ^ \
-		tab[0][(crc >> 24) & 255]
+#  define DO_CRC(x) (crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8))
+#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
+			t2[(crc >> 8) & 255] ^ \
+			t1[(crc >> 16) & 255] ^ \
+			t0[(crc >> 24) & 255]
 # else
-#  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
-#  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
-		tab[1][(crc >> 8) & 255] ^ \
-		tab[2][(crc >> 16) & 255] ^ \
-		tab[3][(crc >> 24) & 255]
+#  define DO_CRC(x) (crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8))
+#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
+			t1[(crc >> 8) & 255] ^ \
+			t2[(crc >> 16) & 255] ^ \
+			t3[(crc >> 24) & 255]
 # endif
 	const u32 *b;
 	size_t    rem_len;
+	const u32 *t0 = tab[0], *t1 = tab[1], *t2 = tab[2], *t3 = tab[3];
 
 	/* Align it */
 	if (unlikely((long)buf & 3 && len)) {

