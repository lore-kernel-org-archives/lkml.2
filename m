Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab2HPPgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:36:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:63112 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399Ab2HPPgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:36:37 -0400
X-IronPort-AV: E=Sophos;i="4.77,778,1336363200"; 
   d="scan'208";a="205386124"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <tim@xen.org>, <Ian.Campbell@citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 03/25] xen/arm: page.h definitions
Date: Thu, 16 Aug 2012 16:35:55 +0100
Message-ID: <1345131377-14713-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM Xen guests always use paging in hardware, like PV on HVM guests in
the X86 world.

Changes in v3:

- improve comments.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/include/asm/xen/page.h |   82 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/asm/xen/page.h

diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
new file mode 100644
index 0000000..1742023
--- /dev/null
+++ b/arch/arm/include/asm/xen/page.h
@@ -0,0 +1,82 @@
+#ifndef _ASM_ARM_XEN_PAGE_H
+#define _ASM_ARM_XEN_PAGE_H
+
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+#include <linux/pfn.h>
+#include <linux/types.h>
+
+#include <xen/interface/grant_table.h>
+
+#define pfn_to_mfn(pfn)			(pfn)
+#define phys_to_machine_mapping_valid	(1)
+#define mfn_to_pfn(mfn)			(mfn)
+#define mfn_to_virt(m)			(__va(mfn_to_pfn(m) << PAGE_SHIFT))
+
+#define pte_mfn	    pte_pfn
+#define mfn_pte	    pfn_pte
+
+/* Xen machine address */
+typedef struct xmaddr {
+	phys_addr_t maddr;
+} xmaddr_t;
+
+/* Xen pseudo-physical address */
+typedef struct xpaddr {
+	phys_addr_t paddr;
+} xpaddr_t;
+
+#define XMADDR(x)	((xmaddr_t) { .maddr = (x) })
+#define XPADDR(x)	((xpaddr_t) { .paddr = (x) })
+
+static inline xmaddr_t phys_to_machine(xpaddr_t phys)
+{
+	unsigned offset = phys.paddr & ~PAGE_MASK;
+	return XMADDR(PFN_PHYS(pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
+}
+
+static inline xpaddr_t machine_to_phys(xmaddr_t machine)
+{
+	unsigned offset = machine.maddr & ~PAGE_MASK;
+	return XPADDR(PFN_PHYS(mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
+}
+/* VIRT <-> MACHINE conversion */
+#define virt_to_machine(v)	(phys_to_machine(XPADDR(__pa(v))))
+#define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
+#define virt_to_mfn(v)		(pfn_to_mfn(virt_to_pfn(v)))
+#define mfn_to_virt(m)		(__va(mfn_to_pfn(m) << PAGE_SHIFT))
+
+static inline xmaddr_t arbitrary_virt_to_machine(void *vaddr)
+{
+	/* TODO: assuming it is mapped in the kernel 1:1 */
+	return virt_to_machine(vaddr);
+}
+
+/* TODO: this shouldn't be here but it is because the frontend drivers
+ * are using it (its rolled in headers) even though we won't hit the code path.
+ * So for right now just punt with this.
+ */
+static inline pte_t *lookup_address(unsigned long address, unsigned int *level)
+{
+	BUG();
+	return NULL;
+}
+
+static inline int m2p_add_override(unsigned long mfn, struct page *page,
+		struct gnttab_map_grant_ref *kmap_op)
+{
+	return 0;
+}
+
+static inline int m2p_remove_override(struct page *page, bool clear_pte)
+{
+	return 0;
+}
+
+static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	BUG();
+	return false;
+}
+#endif /* _ASM_ARM_XEN_PAGE_H */
-- 
1.7.2.5

