Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab1HKRl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:41:56 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:63041 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845Ab1HKRly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:41:54 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=869cbtyjxWwA:10 a=XcRkQUfW1jQA:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=YORvzBCaAAAA:8 a=7qDXwE2b6jsLCtT0l_4A:9 a=Zk2Y0ZZTx6kWqbwW1CEA:7 a=wPNLvfGTeEIA:10 a=VV2__AUApEoA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
Message-ID: <4E441461.4050202@systemfabricworks.com>
Date: Thu, 11 Aug 2011 12:41:53 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, joakim.tjernlund@transmode.se,
        akpm@linux-foundation.org, linux@horizon.com,
        fzago@systemfabricworks.com
Subject: [patch v5 resending 5/5] crc32: fix-check-endian-warnings.diff
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


crc32.c freely mixes u32, __le32 and __be32 types. Fix warnings from
sparse with "-D__CHECK_ENDIAN__" by some emphatic casts.

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>

---
 lib/crc32.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: infiniband/lib/crc32.c
===================================================================
--- infiniband.orig/lib/crc32.c
+++ infiniband/lib/crc32.c
@@ -26,13 +26,13 @@
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
@@ -126,9 +126,9 @@ u32 __pure crc32_le(u32 crc, unsigned ch
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
@@ -169,9 +169,9 @@ u32 __pure crc32_be(u32 crc, unsigned ch
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
