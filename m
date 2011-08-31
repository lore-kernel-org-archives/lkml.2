Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab1HaWac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:30:32 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:36653 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757143Ab1HaWaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:30:20 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=eBnEfeSLl9YA:10 a=yUa7xT9Cjx4A:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=YORvzBCaAAAA:8 a=P5YA-2q8UHrXKQrOib4A:9 a=z9QDvnF2ZemaGa6VP64A:7 a=wPNLvfGTeEIA:10 a=VV2__AUApEoA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
Message-ID: <4E5EB5FB.5030405@systemfabricworks.com>
Date: Wed, 31 Aug 2011 17:30:19 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: fzago@systemfabricworks.com, rpearson@systemfabricworks.com,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        George Spelvin <linux@horizon.com>, akpm@linux-foundation.org
Subject: [PATCH v6 06/10] crc32-fix-check-endian-warnings.diff
References: <20110831213729.395283830@systemfabricworks.com>
In-Reply-To: <20110831213729.395283830@systemfabricworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crc32.c in its original version freely mixed u32, __le32 and __be32 types
which caused warnings from sparse with __CHECK_ENDIAN__.
This patch fixes these by forcing the types to u32.

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>

---
 lib/crc32.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: for-next/lib/crc32.c
===================================================================
--- for-next.orig/lib/crc32.c
+++ for-next/lib/crc32.c
@@ -28,13 +28,13 @@
 #include "crc32defs.h"
 
 #if CRC_LE_BITS == 8
-# define tole(x) __constant_cpu_to_le32(x)
+# define tole(x) (__force u32) __constant_cpu_to_le32(x)
 #else
 # define tole(x) (x)
 #endif
 
 #if CRC_BE_BITS == 8
-# define tobe(x) __constant_cpu_to_be32(x)
+# define tobe(x) (__force u32) __constant_cpu_to_be32(x)
 #else
 # define tobe(x) (x)
 #endif
@@ -128,9 +128,9 @@ u32 __pure crc32_le(u32 crc, unsigned ch
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
@@ -171,9 +171,9 @@ u32 __pure crc32_be(u32 crc, unsigned ch
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


