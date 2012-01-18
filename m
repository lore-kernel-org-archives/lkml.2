Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2ARW3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:29:33 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:58748 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab2ARW32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:29:28 -0500
Subject: [PATCH 05/13] crc32: Fix mixing of endian-specific types
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
Date: Wed, 18 Jan 2012 14:28:07 -0800
Message-ID: <20120118222807.4079.77106.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20120118222733.4079.13377.stgit@elm3c44.beaverton.ibm.com>
References: <20120118222733.4079.13377.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011822-7408-0000-0000-000001FD5EBA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crc32.c in its original version freely mixed u32, __le32 and __be32 types
which caused warnings from sparse with __CHECK_ENDIAN__.
This patch fixes these by forcing the types to u32.

From: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/crc32.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index bf03922..7394288 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -28,13 +28,13 @@
 #include "crc32defs.h"
 
 #if CRC_LE_BITS == 8
-# define tole(x) __constant_cpu_to_le32(x)
+# define tole(x) ((__force u32) __constant_cpu_to_le32(x))
 #else
 # define tole(x) (x)
 #endif
 
 #if CRC_BE_BITS == 8
-# define tobe(x) __constant_cpu_to_be32(x)
+# define tobe(x) ((__force u32) __constant_cpu_to_be32(x))
 #else
 # define tobe(x) (x)
 #endif
@@ -128,9 +128,9 @@ u32 __pure crc32_le(u32 crc, unsigned char const *p, size_t len)
 # elif CRC_LE_BITS == 8
 	const u32      (*tab)[] = crc32table_le;
 
-	crc = __cpu_to_le32(crc);
+	crc = (__force u32) __cpu_to_le32(crc);
 	crc = crc32_body(crc, p, len, tab);
-	crc = __le32_to_cpu(crc);
+	crc = __le32_to_cpu((__force __le32)crc);
 #endif
 	return crc;
 }
@@ -171,9 +171,9 @@ u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 # elif CRC_BE_BITS == 8
 	const u32      (*tab)[] = crc32table_be;
 
-	crc = __cpu_to_be32(crc);
+	crc = (__force u32) __cpu_to_be32(crc);
 	crc = crc32_body(crc, p, len, tab);
-	crc = __be32_to_cpu(crc);
+	crc = __be32_to_cpu((__force __be32)crc);
 # endif
 	return crc;
 }

