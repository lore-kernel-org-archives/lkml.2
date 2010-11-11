Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0KKP5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:57:35 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:27650 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab0KKP5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:57:34 -0500
X-IronPort-AV: E=Sophos;i="4.59,183,1288569600"; 
   d="scan'208";a="2821860"
Date: Thu, 11 Nov 2010 15:55:49 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH] xen: set vma flag VM_PFNMAP in the privcmd mmap file_op
Message-ID: <alpine.DEB.2.00.1011111550230.1407@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch fixes the dom0 kernel crash when creating a VM.
Now I am able to create VMs successfully on 2.6.37 rc1, even though
without disk or network access.

---

xen: set vma flag VM_PFNMAP in the privcmd mmap file_op

Set VM_PFNMAP in the privcmd mmap file_op, rather than later in
xen_remap_domain_mfn_range when it is too late because
vma_wants_writenotify has already been called and vm_page_prot has
already been modified.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index c237b81..2be1f36 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2627,7 +2627,7 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 
 	prot = __pgprot(pgprot_val(prot) | _PAGE_IOMAP);
 
-	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
+	BUG_ON(!(vma->vm_flags & (VM_PFNMAP | VM_RESERVED | VM_IO)));
 
 	rmd.mfn = mfn;
 	rmd.prot = prot;
diff --git a/drivers/xen/xenfs/privcmd.c b/drivers/xen/xenfs/privcmd.c
index f80be7f..9aab216 100644
--- a/drivers/xen/xenfs/privcmd.c
+++ b/drivers/xen/xenfs/privcmd.c
@@ -385,7 +385,7 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
 		return -ENOSYS;
 
 	/* DONTCOPY is essential for Xen as copy_page_range is broken. */
-	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY;
+	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY | VM_PFNMAP;
 	vma->vm_ops = &privcmd_vm_ops;
 	vma->vm_private_data = NULL;
 
