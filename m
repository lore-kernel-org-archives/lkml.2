Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1KCJ2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 05:28:41 -0400
Received: from gw1.transmode.se ([195.58.98.146]:52883 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1KCJ2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 05:28:39 -0400
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: [PATCH] crc32: Optimize inner loop.
Date: Thu, 3 Nov 2011 10:28:25 +0100
Message-Id: <1320312505-30612-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: git-send-email 1.7.3.4
X-MIMETrack: Itemize by SMTP Server on mail1/Transmode(Release 8.5.3|September 15, 2011) at
 11/03/2011 10:28:36,
	Serialize by Router on mail1/Transmode(Release 8.5.3|September 15, 2011) at
 11/03/2011 10:28:36,
	Serialize complete at 11/03/2011 10:28:36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

taking a pointer reference to each row in the crc table matrix,
one can reduce the inner loop with a few insn's

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
---

 As the slice by 8 CRC32 optimizations seems stalled, I figured
 I send in this generic one.

 lib/crc32.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index 4855995..b06d1e7 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -51,20 +51,21 @@ static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
-#  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
-		tab[2][(crc >> 8) & 255] ^ \
-		tab[1][(crc >> 16) & 255] ^ \
-		tab[0][(crc >> 24) & 255]
+#  define DO_CRC(x) crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8)
+#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
+		t2[(crc >> 8) & 255] ^ \
+		t1[(crc >> 16) & 255] ^ \
+		t0[(crc >> 24) & 255]
 # else
-#  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
-#  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
-		tab[1][(crc >> 8) & 255] ^ \
-		tab[2][(crc >> 16) & 255] ^ \
-		tab[3][(crc >> 24) & 255]
+#  define DO_CRC(x) crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
+#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
+		t1[(crc >> 8) & 255] ^  \
+		t2[(crc >> 16) & 255] ^	\
+		t3[(crc >> 24) & 255]
 # endif
 	const u32 *b;
 	size_t    rem_len;
+	const u32 *t0=tab[0], *t1=tab[1], *t2=tab[2], *t3=tab[3];
 
 	/* Align it */
 	if (unlikely((long)buf & 3 && len)) {
-- 
1.7.3.4

