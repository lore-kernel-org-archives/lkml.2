Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1K1WkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:40:19 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48784 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab1K1WkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:40:17 -0500
Subject: [PATCH 09/14] Add two changes that improve the performance of x86
	systems
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
Date: Mon, 28 Nov 2011 14:38:07 -0800
Message-ID: <20111128223807.28705.45122.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20111128223659.28705.56719.stgit@elm3c44.beaverton.ibm.com>
References: <20111128223659.28705.56719.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11112822-3534-0000-0000-00000306A321
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1. replace main loop with incrementing counter
	   this change improves the performance of the selftest
	   by about 5-6% on Nehalem CPUs. The apparent
	   reason is that the compiler can use the loop index
	   to perform an indexed memory access. This is
	   reported to make the performance of PowerPC CPUs
	   to get worse.
	2. replace the rem_len loop with incrementing counter
	   this change improves the performance of the selftest,
	   which has more than the usual number of occurances,
	   by about 1-2% on x86 CPUs. In actual work loads
	   the length is most often a multiple of 4 bytes and
	   this code does not get executed as often if at all.
	   Again this change is reported to make the performance
	   of PowerPC get worse.

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
---
 lib/crc32.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index 6311712..2c8e8c0 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -66,6 +66,9 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 # endif
 	const u32 *b;
 	size_t rem_len;
+# ifdef CONFIG_X86
+	size_t i;
+# endif
 	const u32 *t0 = tab[0], *t1 = tab[1], *t2 = tab[2], *t3 = tab[3];
 	const u32 *t4 = tab[4], *t5 = tab[5], *t6 = tab[6], *t7 = tab[7];
 	u32 q;
@@ -86,7 +89,12 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 # endif
 
 	b = (const u32 *)buf;
+# ifdef CONFIG_X86
+	--b;
+	for (i = 0; i < len; i++) {
+# else
 	for (--b; len; --len) {
+# endif
 		q = crc ^ *++b; /* use pre increment for speed */
 # if CRC_LE_BITS == 32
 		crc = DO_CRC4;
@@ -100,9 +108,14 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 	/* And the last few bytes */
 	if (len) {
 		u8 *p = (u8 *)(b + 1) - 1;
+# ifdef CONFIG_X86
+		for (i = 0; i < len; i++)
+			DO_CRC(*++p); /* use pre increment for speed */
+# else
 		do {
 			DO_CRC(*++p); /* use pre increment for speed */
 		} while (--len);
+# endif
 	}
 	return crc;
 #undef DO_CRC

