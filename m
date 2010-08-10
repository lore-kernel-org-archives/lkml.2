Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab0HJIPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 04:15:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:46340 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0HJIPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 04:15:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,347,1278313200"; 
   d="scan'208";a="310141292"
From: ling.ma@intel.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Ma Ling <ling.ma@intel.com>
Subject: [PATCH RFC] [X86] Fix potential issue on memmove
Date: Tue, 10 Aug 2010 09:17:07 +0800
Message-Id: <1281403027-12324-1-git-send-email-ling.ma@intel.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma@intel.com>

memmove allow source and destination address to be overlap, 
but no limitation for memcpy. So memmove use forward or
backward copy mode to handle src > dest and dest > src cases respectively.
However memcpy has not address overlap, it may use any copy mode
theoretically. Our original memmove will call memcpy and assume
it must use forward copy mode, otherwise the system will crash,
it is potential issue. The patch avoid assumption, meanwhile
re-active patch id a1e5278e40f16a4611264f8da9e557c16cb6f6ed,
which will use forward/backward copy mode according to offset address.

Signed-off-by: Ma Ling <ling.ma@intel.com>
---
 arch/x86/lib/memcpy_32.c  |    4 +++-
 arch/x86/lib/memmove_64.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index 5415a9d..4f56139 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -25,7 +25,9 @@ void *memmove(void *dest, const void *src, size_t n)
 	int d0, d1, d2;
 
 	if (dest < src) {
-		memcpy(dest, src, n);
+		int i;
+		for(i = 0; i < n; i++)
+			*((char *)dest + i) = *((char *)src + i);
 	} else {
 		__asm__ __volatile__(
 			"std\n\t"
diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
index 0a33909..0dded09 100644
--- a/arch/x86/lib/memmove_64.c
+++ b/arch/x86/lib/memmove_64.c
@@ -9,7 +9,9 @@
 void *memmove(void *dest, const void *src, size_t count)
 {
 	if (dest < src) {
-		return memcpy(dest, src, count);
+		int i;
+		for(i = 0; i < count; i++)
+			*((char *)dest + i) = *((char *)src + i);
 	} else {
 		char *p = dest + count;
 		const char *s = src + count;
-- 
1.6.5.2

