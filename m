Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0HZX3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:29:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:57930 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab0HZX3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:29:01 -0400
Date: Thu, 26 Aug 2010 23:28:35 GMT
From: tip-bot for Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, fujita.tomonori@lab.ntt.co.jp,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, fujita.tomonori@lab.ntt.co.jp,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1282845485-8991-4-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-4-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86, iommu: Add proper dependency sort routine (and sanity check).
Message-ID: <tip-5bef80a4b826b9cee1c6aec7ecc371ec395260cc@git.kernel.org>
Git-Commit-ID: 5bef80a4b826b9cee1c6aec7ecc371ec395260cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 23:28:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5bef80a4b826b9cee1c6aec7ecc371ec395260cc
Gitweb:     http://git.kernel.org/tip/5bef80a4b826b9cee1c6aec7ecc371ec395260cc
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Thu, 26 Aug 2010 13:57:58 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 26 Aug 2010 15:13:19 -0700

x86, iommu: Add proper dependency sort routine (and sanity check).

We are using a very simple sort routine which sorts the .iommu_table
array in the order of dependencies. Specifically each structure
of iommu_table_entry has a field 'depend' which contains the function
pointer to the IOMMU that MUST be run before us. We sort the array
of structures so that the struct iommu_table_entry with no
'depend' field are first, and then the subsequent ones are the
ones for which the 'depend' function has been already invoked
(in other words, precede us).

Using the kernel's version 'sort', which is a mergeheap is
feasible, but would require making the comparison operator
scan recursivly the array to satisfy the "heapify" process: setting the
levels properly. The end result would much more complex than it should
be an it is just much simpler to utilize this simple sort routine.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <1282845485-8991-4-git-send-email-konrad.wilk@oracle.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/iommu_table.h |    6 ++
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/pci-iommu_table.c  |   89 ++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
index 435176f..2124e3e 100644
--- a/arch/x86/include/asm/iommu_table.h
+++ b/arch/x86/include/asm/iommu_table.h
@@ -92,4 +92,10 @@ struct iommu_table_entry {
 #define IOMMU_INIT(_detect, _depend, _init, _late_init)			\
 	__IOMMU_INIT(_detect, _depend, _init, _late_init, 0)
 
+void sort_iommu_table(struct iommu_table_entry *start,
+		      struct iommu_table_entry *finish);
+
+void check_iommu_entries(struct iommu_table_entry *start,
+			 struct iommu_table_entry *finish);
+
 #endif /* _ASM_X86_IOMMU_TABLE_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..6817546 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -42,6 +42,7 @@ obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
 obj-y			+= tsc.o io_delay.o rtc.o
+obj-y			+= pci-iommu_table.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
diff --git a/arch/x86/kernel/pci-iommu_table.c b/arch/x86/kernel/pci-iommu_table.c
new file mode 100644
index 0000000..55d745e
--- /dev/null
+++ b/arch/x86/kernel/pci-iommu_table.c
@@ -0,0 +1,89 @@
+#include <linux/dma-mapping.h>
+#include <asm/iommu_table.h>
+#include <linux/string.h>
+#include <linux/kallsyms.h>
+
+
+#define DEBUG 1
+
+static struct iommu_table_entry * __init
+find_dependents_of(struct iommu_table_entry *start,
+		   struct iommu_table_entry *finish,
+		   struct iommu_table_entry *q)
+{
+	struct iommu_table_entry *p;
+
+	if (!q)
+		return NULL;
+
+	for (p = start; p < finish; p++)
+		if (p->detect == q->depend)
+			return p;
+
+	return NULL;
+}
+
+
+void __init sort_iommu_table(struct iommu_table_entry *start,
+			     struct iommu_table_entry *finish) {
+
+	struct iommu_table_entry *p, *q, tmp;
+
+	for (p = start; p < finish; p++) {
+again:
+		q = find_dependents_of(start, finish, p);
+		/* We are bit sneaky here. We use the memory address to figure
+		 * out if the node we depend on is past our point, if so, swap.
+		 */
+		if (q > p) {
+			tmp = *p;
+			memmove(p, q, sizeof(*p));
+			*q = tmp;
+			goto again;
+		}
+	}
+
+}
+
+#ifdef DEBUG
+void __init check_iommu_entries(struct iommu_table_entry *start,
+				struct iommu_table_entry *finish)
+{
+	struct iommu_table_entry *p, *q, *x;
+	char sym_p[KSYM_SYMBOL_LEN];
+	char sym_q[KSYM_SYMBOL_LEN];
+
+	/* Simple cyclic dependency checker. */
+	for (p = start; p < finish; p++) {
+		q = find_dependents_of(start, finish, p);
+		x = find_dependents_of(start, finish, q);
+		if (p == x) {
+			sprint_symbol(sym_p, (unsigned long)p->detect);
+			sprint_symbol(sym_q, (unsigned long)q->detect);
+
+			printk(KERN_ERR "CYCLIC DEPENDENCY FOUND! %s depends" \
+					" on %s and vice-versa. BREAKING IT.\n",
+					sym_p, sym_q);
+			/* Heavy handed way..*/
+			x->depend = 0;
+		}
+	}
+
+	for (p = start; p < finish; p++) {
+		q = find_dependents_of(p, finish, p);
+		if (q && q > p) {
+			sprint_symbol(sym_p, (unsigned long)p->detect);
+			sprint_symbol(sym_q, (unsigned long)q->detect);
+
+			printk(KERN_ERR "EXECUTION ORDER INVALID! %s "\
+					"should be called before %s!\n",
+					sym_p, sym_q);
+		}
+	}
+}
+#else
+inline void check_iommu_entries(struct iommu_table_entry *start,
+				       struct iommu_table_entry *finish)
+{
+}
+#endif
