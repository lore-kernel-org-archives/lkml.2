Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935Ab2HPP4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:56:45 -0400
Received: from smtp.citrix.com ([66.165.176.89]:7070 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823Ab2HPP4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:56:40 -0400
X-IronPort-AV: E=Sophos;i="4.77,778,1336363200"; 
   d="scan'208";a="34872775"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <tim@xen.org>, <Ian.Campbell@citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 18/25] xen: allow privcmd for HVM guests
Date: Thu, 16 Aug 2012 16:36:10 +0100
Message-ID: <1345131377-14713-18-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the "return -ENOSYS" for auto_translated_physmap
guests from privcmd_mmap, thus it allows ARM guests to issue privcmd
mmap calls. However privcmd mmap calls are still going to fail for HVM
and hybrid guests on x86 because the xen_remap_domain_mfn_range
implementation is currently PV only.

Changes in v2:

- better commit message;
- return -EINVAL from xen_remap_domain_mfn_range if
  auto_translated_physmap.


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c    |    3 +++
 drivers/xen/privcmd.c |    4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 3a73785..885a223 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2310,6 +2310,9 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 	unsigned long range;
 	int err = 0;
 
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return -EINVAL;
+
 	prot = __pgprot(pgprot_val(prot) | _PAGE_IOMAP);
 
 	BUG_ON(!((vma->vm_flags & (VM_PFNMAP | VM_RESERVED | VM_IO)) ==
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index ccee0f1..85226cb 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -380,10 +380,6 @@ static struct vm_operations_struct privcmd_vm_ops = {
 
 static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	/* Unsupported for auto-translate guests. */
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return -ENOSYS;
-
 	/* DONTCOPY is essential for Xen because copy_page_range doesn't know
 	 * how to recreate these mappings */
 	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY | VM_PFNMAP;
-- 
1.7.2.5

