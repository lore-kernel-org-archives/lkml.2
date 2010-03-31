Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab0CaC2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:28:07 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:57492 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab0CaCVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:21:23 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 21/33] x86, lmb: Add x86 version of __lmb_find_area()
Date: Tue, 30 Mar 2010 19:17:06 -0700
Message-Id: <1270001838-15857-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
References: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BB2B11E.0073,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic version is going from high to low, and it seems it can not find
right area compact enough.

the x86 version will go from goal to limit and just like the way We used
for early_res

use ARCH_FIND_LMB_AREA to select from them.

For 32 bit have to use CONFIG_ARCH_FIND_LMB_AREA=y, because some alloc_bootmem
in nobootmem config, hard code -1ULL as limit

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/Kconfig  |    8 +++++++
 arch/x86/mm/lmb.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a80bce..0052d27 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -585,6 +585,14 @@ config PARAVIRT_DEBUG
 	  Enable to debug paravirt_ops internals.  Specifically, BUG if
 	  a paravirt_op is missing when it is called.
 
+config ARCH_LMB_FIND_AREA
+	default y
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
index 3229e9e..d221672 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -86,3 +86,60 @@ u64 __init lmb_find_area_size(u64 start, u64 *sizep, u64 align)
 	return -1ULL;
 }
 
+#ifdef CONFIG_ARCH_LMB_FIND_AREA
+static int __init find_overlapped_early(u64 start, u64 end)
+{
+	int i;
+	struct lmb_property *r;
+
+	for (i = 0; i < lmb.reserved.cnt && lmb.reserved.region[i].size; i++) {
+		r = &lmb.reserved.region[i];
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
+	struct lmb_property *r;
+again:
+	i = find_overlapped_early(addr, addr + size);
+	r = &lmb.reserved.region[i];
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
+	return -1ULL;
+}
+#endif
-- 
1.6.4.2

