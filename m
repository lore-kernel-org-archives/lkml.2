Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab2JGPJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:09:10 -0400
Received: from mail.servus.at ([193.170.194.20]:53326 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab2JGPJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:09:06 -0400
Date: Sun, 7 Oct 2012 17:09:02 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
To: linux-kernel@vger.kernel.org
Cc: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Stezenbach <js@sig21.net>,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: [PATCH 3/3] lib/lzo: Optimize code for CPUs with inefficient
 unaligned access
Message-ID: <5f702781f158cb59075cfa97e5c21f52275057f1.1349621096.git.markus@oberhumer.com>
References: <cover.1349621096.git.markus@oberhumer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1349621096.git.markus@oberhumer.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some code paths are only benefical on machines with fast unaligned
loads, so only use these if CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
defined.

Signed-off-by: Markus F.X.J. Oberhumer <markus@oberhumer.com>
---
 lib/lzo/lzo1x_compress.c        |    4 ++--
 lib/lzo/lzo1x_decompress_safe.c |   15 ++++++++++++---
 lib/lzo/lzodefs.h               |    2 +-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/lib/lzo/lzo1x_compress.c b/lib/lzo/lzo1x_compress.c
index d42efe5..1593dba 100644
--- a/lib/lzo/lzo1x_compress.c
+++ b/lib/lzo/lzo1x_compress.c
@@ -90,7 +90,7 @@ next:
 
 		m_len = 4;
 		{
-#if defined(LZO_USE_CTZ64)
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && defined(LZO_USE_CTZ64)
 		u64 v;
 		v = get_unaligned((const u64 *) (ip + m_len)) ^
 		    get_unaligned((const u64 *) (m_pos + m_len));
@@ -110,7 +110,7 @@ next:
 #  else
 #    error "missing endian definition"
 #  endif
-#elif defined(LZO_USE_CTZ32)
+#elif defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && defined(LZO_USE_CTZ32)
 		u32 v;
 		v = get_unaligned((const u32 *) (ip + m_len)) ^
 		    get_unaligned((const u32 *) (m_pos + m_len));
diff --git a/lib/lzo/lzo1x_decompress_safe.c b/lib/lzo/lzo1x_decompress_safe.c
index 0dba30c..569985d 100644
--- a/lib/lzo/lzo1x_decompress_safe.c
+++ b/lib/lzo/lzo1x_decompress_safe.c
@@ -64,6 +64,7 @@ int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 				}
 				t += 3;
 copy_literal_run:
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 				if (likely(HAVE_IP(t + 15) && HAVE_OP(t + 15))) {
 					const unsigned char *ie = ip + t;
 					unsigned char *oe = op + t;
@@ -77,7 +78,9 @@ copy_literal_run:
 					} while (ip < ie);
 					ip = ie;
 					op = oe;
-				} else {
+				} else
+#endif
+				{
 					NEED_OP(t);
 					NEED_IP(t + 3);
 					do {
@@ -148,6 +151,7 @@ copy_literal_run:
 			m_pos -= 0x4000;
 		}
 		TEST_LB(m_pos);
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 		if (op - m_pos >= 8) {
 			unsigned char *oe = op + t;
 			if (likely(HAVE_OP(t + 15))) {
@@ -173,7 +177,9 @@ copy_literal_run:
 					*op++ = *m_pos++;
 				} while (op < oe);
 			}
-		} else {
+		} else
+#endif
+		{
 			unsigned char *oe = op + t;
 			NEED_OP(t);
 			op[0] = m_pos[0];
@@ -187,11 +193,14 @@ copy_literal_run:
 match_next:
 		state = next;
 		t = next;
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 		if (likely(HAVE_IP(6) && HAVE_OP(4))) {
 			COPY4(op, ip);
 			op += t;
 			ip += t;
-		} else {
+		} else
+#endif
+		{
 			NEED_IP(t + 3);
 			NEED_OP(t);
 			while (t > 0) {
diff --git a/lib/lzo/lzodefs.h b/lib/lzo/lzodefs.h
index ddc8db5..5a4beb2 100644
--- a/lib/lzo/lzodefs.h
+++ b/lib/lzo/lzodefs.h
@@ -29,7 +29,7 @@
 #define LZO_USE_CTZ32	1
 #elif defined(__i386__) || defined(__powerpc__)
 #define LZO_USE_CTZ32	1
-#else
+#elif defined(__arm__) && (__LINUX_ARM_ARCH__ >= 5)
 #define LZO_USE_CTZ32	1
 #endif
 
-- 
1.7.1

