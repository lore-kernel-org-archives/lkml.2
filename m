Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab0FPFwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:52:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28521 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab0FPFqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:46:15 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/37] x86, lmb: Add lmb_find_in_range_size()
Date: Tue, 15 Jun 2010 22:42:17 -0700
Message-Id: <1276666966-14259-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
References: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C186507.00B7,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size is returned according free range.
Will be used to find free ranges for early_memtest and memory corruption check

Do not mess it up with lib/lmb.c yet.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/lmb.h |    8 ++++
 arch/x86/mm/Makefile       |    2 +
 arch/x86/mm/lmb.c          |   88 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/lmb.h
 create mode 100644 arch/x86/mm/lmb.c

diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
new file mode 100644
index 0000000..9d26895
--- /dev/null
+++ b/arch/x86/include/asm/lmb.h
@@ -0,0 +1,8 @@
+#ifndef _X86_LMB_H
+#define _X86_LMB_H
+
+#define ARCH_DISCARD_LMB
+
+u64 lmb_find_in_range_size(u64 start, u64 *sizep, u64 align);
+
+#endif
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index a4c7683..8ab0505 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -26,4 +26,6 @@ obj-$(CONFIG_NUMA)		+= numa.o numa_$(BITS).o
 obj-$(CONFIG_K8_NUMA)		+= k8topology_64.o
 obj-$(CONFIG_ACPI_NUMA)		+= srat_$(BITS).o
 
+obj-$(CONFIG_HAVE_LMB)		+= lmb.o
+
 obj-$(CONFIG_MEMTEST)		+= memtest.o
diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
new file mode 100644
index 0000000..4335f48
--- /dev/null
+++ b/arch/x86/mm/lmb.c
@@ -0,0 +1,88 @@
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/bitops.h>
+#include <linux/lmb.h>
+#include <linux/bootmem.h>
+#include <linux/mm.h>
+#include <linux/range.h>
+
+/* Check for already reserved areas */
+static inline bool __init bad_addr_size(u64 *addrp, u64 *sizep, u64 align)
+{
+	struct lmb_region *r;
+	u64 addr = *addrp, last;
+	u64 size = *sizep;
+	bool changed = false;
+
+again:
+	last = addr + size;
+	for_each_lmb(reserved, r) {
+		if (last > r->base && addr < r->base) {
+			size = r->base - addr;
+			changed = true;
+			goto again;
+		}
+		if (last > (r->base + r->size) && addr < (r->base + r->size)) {
+			addr = round_up(r->base + r->size, align);
+			size = last - addr;
+			changed = true;
+			goto again;
+		}
+		if (last <= (r->base + r->size) && addr >= r->base) {
+			(*sizep)++;
+			return false;
+		}
+	}
+	if (changed) {
+		*addrp = addr;
+		*sizep = size;
+	}
+	return changed;
+}
+
+static u64 __init __lmb_find_in_range_size(u64 ei_start, u64 ei_last, u64 start,
+			 u64 *sizep, u64 align)
+{
+	u64 addr, last;
+
+	addr = round_up(ei_start, align);
+	if (addr < start)
+		addr = round_up(start, align);
+	if (addr >= ei_last)
+		goto out;
+	*sizep = ei_last - addr;
+	while (bad_addr_size(&addr, sizep, align) && addr + *sizep <= ei_last)
+		;
+	last = addr + *sizep;
+	if (last > ei_last)
+		goto out;
+
+	return addr;
+
+out:
+	return LMB_ERROR;
+}
+
+/*
+ * Find next free range after start, and size is returned in *sizep
+ */
+u64 __init lmb_find_in_range_size(u64 start, u64 *sizep, u64 align)
+{
+	struct lmb_region *r;
+
+	for_each_lmb(memory, r) {
+		u64 ei_start = r->base;
+		u64 ei_last = ei_start + r->size;
+		u64 addr;
+
+		addr = __lmb_find_in_range_size(ei_start, ei_last, start,
+					 sizep, align);
+
+		if (addr != LMB_ERROR)
+			return addr;
+	}
+
+	return LMB_ERROR;
+}
+
-- 
1.6.4.2

