Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab0ENTsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:48:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59889 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab0ENTsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:48:43 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 19/37] x86, lmb: Add x86 version of __lmb_find_area()
Date: Fri, 14 May 2010 12:45:45 -0700
Message-Id: <1273866363-14249-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BEDA8E9.00A3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic version is going from high to low, and it seems it can not find
right area compact enough.

the x86 version will go from goal to limit and just like the way We used
for early_res

use ARCH_FIND_LMB_AREA to select from them.

-v2: default to no

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/Kconfig  |    8 +++++
 arch/x86/mm/lmb.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d80d2ab..36a5665 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -584,6 +584,14 @@ config PARAVIRT_DEBUG
 	  Enable to debug paravirt_ops internals.  Specifically, BUG if
 	  a paravirt_op is missing when it is called.
 
+config ARCH_LMB_FIND_AREA
+	default n
+	bool "Use x86 own lmb_find_area()"
+	---help---
+	  Use lmb_find_area() version instead of generic version, it get free
+	  area up from low.
+	  Generic one try to get free area down from limit.
+
 config NO_BOOTMEM
 	default y
 	bool "Disable Bootmem code"
diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
index 5007dbf..eaa45ca 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -415,3 +415,81 @@ u64 __init lmb_hole_size(u64 start, u64 end)
 	return end - start - ((u64)ram << PAGE_SHIFT);
 }
 
+#ifdef CONFIG_ARCH_LMB_FIND_AREA
+static int __init find_overlapped_early(u64 start, u64 end)
+{
+	int i;
+	struct lmb_region *r;
+
+	for (i = 0; i < lmb.reserved.cnt && lmb.reserved.regions[i].size; i++) {
+		r = &lmb.reserved.regions[i];
+		if (end > r->base && start < (r->base + r->size))
+			break;
+	}
+
+	return i;
+}
+
+/* Check for already reserved areas */
+static inline bool __init bad_addr(u64 *addrp, u64 size, u64 align)
+{
+	int i;
+	u64 addr = *addrp;
+	bool changed = false;
+	struct lmb_region *r;
+again:
+	i = find_overlapped_early(addr, addr + size);
+	r = &lmb.reserved.regions[i];
+	if (i < lmb.reserved.cnt && r->size) {
+		*addrp = addr = round_up(r->base + r->size, align);
+		changed = true;
+		goto again;
+	}
+	return changed;
+}
+
+u64 __init __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
+				 u64 size, u64 align)
+{
+	u64 addr, last;
+
+	addr = round_up(ei_start, align);
+	if (addr < start)
+		addr = round_up(start, align);
+	if (addr >= ei_last)
+		goto out;
+	while (bad_addr(&addr, size, align) && addr+size <= ei_last)
+		;
+	last = addr + size;
+	if (last > ei_last)
+		goto out;
+	if (last > end)
+		goto out;
+
+	return addr;
+
+out:
+	return LMB_ERROR;
+}
+
+/*
+ * Find a free area with specified alignment in a specific range.
+ */
+u64 __init lmb_find_area(u64 start, u64 end, u64 size, u64 align)
+{
+	int i;
+
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		u64 ei_start = lmb.memory.regions[i].base;
+		u64 ei_last = ei_start + lmb.memory.regions[i].size;
+		u64 addr;
+
+		addr = __lmb_find_area(ei_start, ei_last, start, end,
+					 size, align);
+
+		if (addr != LMB_ERROR)
+			return addr;
+	}
+	return LMB_ERROR;
+}
+#endif
-- 
1.6.4.2

