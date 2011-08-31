Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab1HaWaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:30:46 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:36691 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757159Ab1HaWak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:30:40 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=eBnEfeSLl9YA:10 a=nZ14g1a9BacA:10 a=ozIaqLvjkoIA:10 a=8nJEP1OIZ-IA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=YORvzBCaAAAA:8 a=LIaQXV1QFOvQ1FkKHUYA:9 a=2ALJh5DMJD8b7ebLMjsA:7 a=wPNLvfGTeEIA:10 a=VV2__AUApEoA:10 a=hL1QiGWMrjOO0wtC:21 a=1CHVr3Rbf7uvBLYb:21 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
Message-ID: <4E5EB60E.3030908@systemfabricworks.com>
Date: Wed, 31 Aug 2011 17:30:38 -0500
From: Bob Pearson <rpearson@systemfabricworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: fzago@systemfabricworks.com, rpearson@systemfabricworks.com,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        George Spelvin <linux@horizon.com>, akpm@linux-foundation.org
Subject: [PATCH v6 09/10] crc32-optimize-loops-for-x86.diff
References: <20110831213729.395283830@systemfabricworks.com>
In-Reply-To: <20110831213729.395283830@systemfabricworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two changes that improve the performance of x86 systems
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
 1 file changed, 13 insertions(+)

Index: for-next/lib/crc32.c
===================================================================
--- for-next.orig/lib/crc32.c
+++ for-next/lib/crc32.c
@@ -66,6 +66,9 @@ crc32_body(u32 crc, unsigned char const 
 # endif
 	const u32 *b;
 	size_t rem_len;
+# ifdef CONFIG_X86
+	size_t i;
+# endif
 	const u32 *t0 = tab[0], *t1 = tab[1], *t2 = tab[2], *t3 = tab[3];
 	const u32 *t4 = tab[4], *t5 = tab[5], *t6 = tab[6], *t7 = tab[7];
 	u32 q;
@@ -86,7 +89,12 @@ crc32_body(u32 crc, unsigned char const 
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
@@ -100,9 +108,14 @@ crc32_body(u32 crc, unsigned char const 
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


