Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0HZX2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:28:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:57746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab0HZX20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:28:26 -0400
Date: Thu, 26 Aug 2010 23:27:51 GMT
From: tip-bot for Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, fujita.tomonori@lab.ntt.co.jp,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, fujita.tomonori@lab.ntt.co.jp,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1282845485-8991-2-git-send-email-konrad.wilk@oracle.com>
References: <1282845485-8991-2-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86, iommu: Add IOMMU_INIT macros, .iommu_table section, and iommu_table_entry structure
Message-ID: <tip-0444ad93ea2449963132d68753020a6a24d69895@git.kernel.org>
Git-Commit-ID: 0444ad93ea2449963132d68753020a6a24d69895
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 23:27:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0444ad93ea2449963132d68753020a6a24d69895
Gitweb:     http://git.kernel.org/tip/0444ad93ea2449963132d68753020a6a24d69895
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Thu, 26 Aug 2010 13:57:56 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 26 Aug 2010 15:12:53 -0700

x86, iommu: Add IOMMU_INIT macros, .iommu_table section, and iommu_table_entry structure

This patch set adds a mechanism to "modularize" the IOMMUs we have
on X86. Currently the count of IOMMUs is up to six and they have a complex
relationship that requires careful execution order. 'pci_iommu_alloc'
does that today, but most folks are unhappy with how it does it.
This patch set addresses this and also paves a mechanism to jettison
unused IOMMUs during run-time. For details that sparked this, please
refer to: http://lkml.org/lkml/2010/8/2/282

The first solution that comes to mind is to convert wholesale
the IOMMU detection routines to be called during initcall
time frame. Unfortunately that misses the dependency relationship
that some of the IOMMUs have (for example: for AMD-Vi IOMMU to work,
GART detection MUST run first, and before all of that SWIOTLB MUST run).

The second solution would be to introduce a registration call wherein
the IOMMU would provide its detection/init routines and as well on what
MUST run before it. That would work, except that the 'pci_iommu_alloc'
which would run through this list, is called during mem_init. This means we
don't have any memory allocator, and it is so early that we haven't yet
started running through the initcall_t list.

This solution borrows concepts from the 2nd idea and from how
MODULE_INIT works. A macro is provided that each IOMMU uses to define
it's detect function and early_init (before the memory allocate is
active), and as well what other IOMMU MUST run before us.  Since most IOMMUs
depend on having SWIOTLB run first ("pci_swiotlb_detect") a convenience macro
to depends on that is also provided.

This macro is similar in design to MODULE_PARAM macro wherein
we setup a .iommu_table section in which we populate it with the values
that match a struct iommu_table_entry. During bootup we will sort
through the array so that the IOMMUs that MUST run before us are first
elements in the array. And then we just iterate through them calling the
detection routine and if appropiate, the init routines.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <1282845485-8991-2-git-send-email-konrad.wilk@oracle.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/iommu_table.h |   95 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux.lds.S      |    7 +++
 2 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
new file mode 100644
index 0000000..435176f
--- /dev/null
+++ b/arch/x86/include/asm/iommu_table.h
@@ -0,0 +1,95 @@
+
+#ifndef _ASM_X86_IOMMU_TABLE_H
+#define _ASM_X86_IOMMU_TABLE_H
+
+#include <asm/swiotlb.h>
+
+/*
+ * History lesson:
+ * The execution chain of IOMMUs in 2.6.36 looks as so:
+ *
+ *            [xen-swiotlb]
+ *                 |
+ *         +----[swiotlb *]--+
+ *        /         |         \
+ *       /          |          \
+ *    [GART]     [Calgary]  [Intel VT-d]
+ *     /
+ *    /
+ * [AMD-Vi]
+ *
+ * *: if SWIOTLB detected 'iommu=soft'/'swiotlb=force' it would skip
+ * over the rest of IOMMUs and unconditionally initialize the SWIOTLB.
+ * Also it would surreptitiously initialize set the swiotlb=1 if there were
+ * more than 4GB and if the user did not pass in 'iommu=off'. The swiotlb
+ * flag would be turned off by all IOMMUs except the Calgary one.
+ *
+ * The IOMMU_INIT* macros allow a similar tree (or more complex if desired)
+ * to be built by defining who we depend on.
+ *
+ * And all that needs to be done is to use one of the macros in the IOMMU
+ * and the pci-dma.c will take care of the rest.
+ */
+
+struct iommu_table_entry {
+	initcall_t	detect;
+	initcall_t	depend;
+	void		(*early_init)(void); /* No memory allocate available. */
+	void		(*late_init)(void); /* Yes, can allocate memory. */
+#define IOMMU_FINISH_IF_DETECTED (1<<0)
+#define IOMMU_DETECTED		 (1<<1)
+	int		flags;
+};
+/*
+ * Macro fills out an entry in the .iommu_table that is equivalent
+ * to the fields that 'struct iommu_table_entry' has. The entries
+ * that are put in the .iommu_table section are not put in any order
+ * hence during boot-time we will have to resort them based on
+ * dependency. */
+
+
+#define __IOMMU_INIT(_detect, _depend, _early_init, _late_init, _finish)\
+	static const struct iommu_table_entry const			\
+		__iommu_entry_##_detect __used				\
+	__attribute__ ((unused, __section__(".iommu_table"),		\
+			aligned((sizeof(void *)))))	\
+	= {_detect, _depend, _early_init, _late_init,			\
+	   _finish ? IOMMU_FINISH_IF_DETECTED : 0}
+/*
+ * The simplest IOMMU definition. Provide the detection routine
+ * and it will be run after the SWIOTLB and the other IOMMUs
+ * that utilize this macro. If the IOMMU is detected (ie, the
+ * detect routine returns a positive value), the other IOMMUs
+ * are also checked. You can use IOMMU_INIT_FINISH if you prefer
+ * to stop detecting the other IOMMUs after yours has been detected.
+ */
+#define IOMMU_INIT_POST(_detect)					\
+	__IOMMU_INIT(_detect, pci_swiotlb_detect,  0, 0, 0)
+
+#define IOMMU_INIT_POST_FINISH(detect)					\
+	__IOMMU_INIT(_detect, pci_swiotlb_detect,  0, 0, 1)
+
+/*
+ * A more sophisticated version of IOMMU_INIT. This variant requires:
+ *  a). A detection routine function.
+ *  b). The name of the detection routine we depend on to get called
+ *      before us.
+ *  c). The init routine which gets called if the detection routine
+ *      returns a positive value from the pci_iommu_alloc. This means
+ *      no presence of a memory allocator.
+ *  d). Similar to the 'init', except that this gets called from pci_iommu_init
+ *      where we do have a memory allocator.
+ *
+ * The _CONT vs the _EXIT differs in that the _CONT variant will
+ * continue detecting other IOMMUs in the call list after the
+ * the detection routine returns a positive number. The _EXIT will
+ * stop the execution chain. Both will still call the 'init' and
+ * 'late_init' functions if they are set.
+ */
+#define IOMMU_INIT_FINISH(_detect, _depend, _init, _late_init)		\
+	__IOMMU_INIT(_detect, _depend, _init, _late_init, 1)
+
+#define IOMMU_INIT(_detect, _depend, _init, _late_init)			\
+	__IOMMU_INIT(_detect, _depend, _init, _late_init, 0)
+
+#endif /* _ASM_X86_IOMMU_TABLE_H */
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index d0bb522..b92e040 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -260,6 +260,13 @@ SECTIONS
 		*(.altinstr_replacement)
 	}
 
+	.iommu_table : AT(ADDR(.iommu_table) - LOAD_OFFSET) {
+		__iommu_table = .;
+		*(.iommu_table)
+		. = ALIGN(8);
+		__iommu_table_end = .;
+	}
+
 	/*
 	 * .exit.text is discard at runtime, not link time, to deal with
 	 *  references from .altinstructions and .eh_frame
