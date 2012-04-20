Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab2DTKxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:53:55 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:8136 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab2DTKxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:53:44 -0400
X-IronPort-AV: E=Sophos;i="4.75,453,1330905600"; 
   d="scan'208";a="12045604"
Date: Fri, 20 Apr 2012 11:58:53 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] xen: enter/exit lazy_mmu_mode around m2p_override
 calls
In-Reply-To: <20120417144318.GA28477@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1204201141300.26786@kaball-desktop>
References: <1334075375-25442-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120417130340.GA25593@phenom.dumpdata.com> <alpine.DEB.2.00.1204171457360.26786@kaball-desktop> <20120417144318.GA28477@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 17, 2012 at 03:26:05PM +0100, Stefano Stabellini wrote:
> > On Tue, 17 Apr 2012, Konrad Rzeszutek Wilk wrote:
> > > On Tue, Apr 10, 2012 at 05:29:34PM +0100, Stefano Stabellini wrote:
> > > > This patch is a significant performance improvement for the
> > > > m2p_override: about 6% using the gntdev device.
> > > > 
> > > > Each m2p_add/remove_override call issues a MULTI_grant_table_op and a
> > > > __flush_tlb_single if kmap_op != NULL.  Batching all the calls together
> > > > is a great performance benefit because it means issuing one hypercall
> > > > total rather than two hypercall per page.
> > > > If paravirt_lazy_mode is set PARAVIRT_LAZY_MMU, all these calls are
> > > > going to be batched together, otherwise they are issued one at a time.
> > > > 
> > > > Adding arch_enter_lazy_mmu_mode/arch_leave_lazy_mmu_mode around the
> > > > m2p_add/remove_override calls forces paravirt_lazy_mode to
> > > > PARAVIRT_LAZY_MMU, therefore makes sure that they are always batched.
> > > > 
> > > > 
> > > > Changes in v3:
> > > > - do not call arch_enter/leave_lazy_mmu_mode in xen_blkbk_unmap, that
> > > > can be called in interrupt context.
> > > 
> > > This is with RHEL5 (somehow the pvops kernels don't trigger this):
> > 
> > Do you mean RHEL5 as a guest? Are you using blkback or qdisk?
> 
> blkback:
> 
> memory = 1024
> name = "RHEL5-64"
> hvm_loader="/usr/bin/pygrub"
> vfb = [ 'vnc=1, vnclisten=0.0.0.0,vncunused=1']
> vcpus=2
> vif = [ ' mac=00:0F:4B:00:00:74,bridge=switch' ]
> disk = [ 'phy:/dev/guests/RHEL5-64,xvda,w' ]
> boot = "dnc"
> device_model = 'qemu-dm'
> vnc=1
> videoram=8
> vnclisten="0.0.0.0"
> vncpasswd=''
> stdvga=0
> serial='pty'
> tsc_mode=0
> usb=1
> usbdevice='tablet'
> xen_platform_pci=1


The reason why I haven't seen this before is that my patch conflicts
with 13e461d2ac176f6a5b4a4ee4ce69b8e870fd0ea6 "xen/blkback: use
grant-table.c hypercall wrappers": gnttab_unmap_refs is called by
xen_blkbk_unmap in interrupt context again.

I am attaching a new version of this patch, based on your testing branch
(after reverting the current version of the patch).

Considering that the only places where the m2p functions are called are
gnttab_(un)map_refs now, it makes it easier to do the right thing with
hypercall batching and check whether it is safe to call
arch_enter_lazy_mmu_mode, so we don't have to worry about who calls what
when.

---


[PATCH v4] xen: enter/exit lazy_mmu_mode around m2p_override calls

This patch is a significant performance improvement for the
m2p_override: about 6% using the gntdev device.

Each m2p_add/remove_override call issues a MULTI_grant_table_op and a
__flush_tlb_single if kmap_op != NULL.  Batching all the calls together
is a great performance benefit because it means issuing one hypercall
total rather than two hypercall per page.
If paravirt_lazy_mode is set PARAVIRT_LAZY_MMU, all these calls are
going to be batched together, otherwise they are issued one at a time.

Adding arch_enter_lazy_mmu_mode/arch_leave_lazy_mmu_mode around the
m2p_add/remove_override calls forces paravirt_lazy_mode to
PARAVIRT_LAZY_MMU, therefore makes sure that they are always batched.

However it is not safe to call arch_enter_lazy_mmu_mode if we are in
interrupt context or if we are already in PARAVIRT_LAZY_MMU mode, so
check for both conditions before doing so.

Changes in v4:
- rebased on 3.4-rc3: all the m2p_override users call gnttab_unmap_refs
and gnttab_map_refs;
- check whether we are in interrupt context and the lazy_mode we are in
before calling arch_enter/leave_lazy_mmu_mode.

Changes in v3:
- do not call arch_enter/leave_lazy_mmu_mode in xen_blkbk_unmap, that
can be called in interrupt context.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index e570c6f..a18a3e8 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -38,6 +38,7 @@
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/hardirq.h>
 
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
@@ -826,7 +827,7 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 		    struct gnttab_map_grant_ref *kmap_ops,
 		    struct page **pages, unsigned int count)
 {
-	int i, ret;
+	int i, ret, lazy = 0;
 	pte_t *pte;
 	unsigned long mfn;
 
@@ -837,6 +838,11 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return ret;
 
+	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
+		arch_enter_lazy_mmu_mode();
+		lazy = 1;
+	}
+
 	for (i = 0; i < count; i++) {
 		/* Do not add to override if the map failed. */
 		if (map_ops[i].status)
@@ -855,6 +861,9 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 			return ret;
 	}
 
+	if (lazy)
+		arch_leave_lazy_mmu_mode();
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(gnttab_map_refs);
@@ -862,7 +871,7 @@ EXPORT_SYMBOL_GPL(gnttab_map_refs);
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		      struct page **pages, unsigned int count, bool clear_pte)
 {
-	int i, ret;
+	int i, ret, lazy = 0;
 
 	ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
 	if (ret)
@@ -871,12 +880,20 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return ret;
 
+	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
+		arch_enter_lazy_mmu_mode();
+		lazy = 1;
+	}
+
 	for (i = 0; i < count; i++) {
 		ret = m2p_remove_override(pages[i], clear_pte);
 		if (ret)
 			return ret;
 	}
 
+	if (lazy)
+		arch_leave_lazy_mmu_mode();
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
