Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab2AUAg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 19:36:58 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55654 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2AUAg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 19:36:56 -0500
Date: Fri, 20 Jan 2012 16:36:52 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] crc32: Don't reference unnecessary crc32 tables in
	single-bit mode
Message-ID: <20120121003652.GD2749@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012100-1780-0000-0000-000002815F53
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00106705; UDB=6.00026825; UTC=2012-01-21
 00:36:55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling with single bit mode (CRC32_BIT=y) we shouldn't reference the
crc32 tables, since they aren't built in single-bit mode.  Many thanks to Randy
Dunlap for finding this bug:
http://marc.info/?l=linux-kernel&m=132709702422141&w=2

This patch is against next-20120120.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 lib/crc32.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index ebc5911..b0d278f 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -174,16 +174,26 @@ static inline u32 __pure crc32_le_generic(u32 crc, unsigned char const *p,
 	return crc;
 }
 
+#if CRC_LE_BITS == 1
+u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
+{
+	return crc32_le_generic(crc, p, len, NULL, CRCPOLY_LE);
+}
+u32 __pure __crc32c_le(u32 crc, unsigned char const *p, size_t len)
+{
+	return crc32_le_generic(crc, p, len, NULL, CRC32C_POLY_LE);
+}
+#else
 u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len, crc32table_le, CRCPOLY_LE);
 }
-EXPORT_SYMBOL(crc32_le);
-
 u32 __pure __crc32c_le(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_le_generic(crc, p, len, crc32ctable_le, CRC32C_POLY_LE);
 }
+#endif
+EXPORT_SYMBOL(crc32_le);
 EXPORT_SYMBOL(__crc32c_le);
 
 /**
@@ -233,10 +243,17 @@ static inline u32 __pure crc32_be_generic(u32 crc, unsigned char const *p,
 	return crc;
 }
 
+#if CRC_LE_BITS == 1
+u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
+{
+	return crc32_be_generic(crc, p, len, NULL, CRCPOLY_BE);
+}
+#else
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_be_generic(crc, p, len, crc32table_be, CRCPOLY_BE);
 }
+#endif
 EXPORT_SYMBOL(crc32_be);
 
 #ifdef CONFIG_CRC32_SELFTEST

