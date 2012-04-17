Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2DQOVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:21:44 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:39110 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2DQOVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:21:43 -0400
X-IronPort-AV: E=Sophos;i="4.75,435,1330905600"; 
   d="scan'208";a="11980571"
Date: Tue, 17 Apr 2012 15:26:05 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] xen: enter/exit lazy_mmu_mode around m2p_override
 calls
In-Reply-To: <20120417130340.GA25593@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1204171457360.26786@kaball-desktop>
References: <1334075375-25442-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120417130340.GA25593@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 10, 2012 at 05:29:34PM +0100, Stefano Stabellini wrote:
> > This patch is a significant performance improvement for the
> > m2p_override: about 6% using the gntdev device.
> > 
> > Each m2p_add/remove_override call issues a MULTI_grant_table_op and a
> > __flush_tlb_single if kmap_op != NULL.  Batching all the calls together
> > is a great performance benefit because it means issuing one hypercall
> > total rather than two hypercall per page.
> > If paravirt_lazy_mode is set PARAVIRT_LAZY_MMU, all these calls are
> > going to be batched together, otherwise they are issued one at a time.
> > 
> > Adding arch_enter_lazy_mmu_mode/arch_leave_lazy_mmu_mode around the
> > m2p_add/remove_override calls forces paravirt_lazy_mode to
> > PARAVIRT_LAZY_MMU, therefore makes sure that they are always batched.
> > 
> > 
> > Changes in v3:
> > - do not call arch_enter/leave_lazy_mmu_mode in xen_blkbk_unmap, that
> > can be called in interrupt context.
> 
> This is with RHEL5 (somehow the pvops kernels don't trigger this):

Do you mean RHEL5 as a guest? Are you using blkback or qdisk?
How can I repro the bug?


In any case it looks like a similar kind of issue to the one I fixed
before: paravirt_enter_lazy_mmu is probably called with
paravirt_lazy_mode == PARAVIRT_LAZY_MMU, in this case by
gnttab_unmap_refs.
But I don't understand how gnttab_unmap_refs can be called when you seem
to be using blkback.

Anyhow gnttab_unmap_refs can be called by:

- mmu_notifier on invalidate_range_start;
- vm_operations_struct on close;
- file_operations on release;
- the unmap gntdev ioctl.

I guess the mmu_notifier or vm_operations_struct could be the ones
calling gnttab_unmap_refs with lazy_mode set to PARAVIRT_LAZY_MMU.

I suspect that something like the following code would fix the issue but
it is pretty ugly and I need to test it before a submitting it as a fix:


@@ -780,7 +780,7 @@ EXPORT_SYMBOL_GPL(gnttab_map_refs);
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
                      struct page **pages, unsigned int count, bool clear_pte)
 {
-       int i, ret;
+       int i, ret, lazy = 0;
 
        ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
        if (ret)

@@ -789,7 +789,10 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
        if (xen_feature(XENFEAT_auto_translated_physmap))
                return ret;
 
-       arch_enter_lazy_mmu_mode();
+       if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
+               arch_enter_lazy_mmu_mode();
+               lazy = 1;
+       }
 
        for (i = 0; i < count; i++) {
                ret = m2p_remove_override(pages[i], clear_pte);
@@ -797,7 +800,8 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
                        return ret;
        }
 
-       arch_leave_lazy_mmu_mode();
+       if (lazy)
+               arch_leave_lazy_mmu_mode();
 
        return ret;
 }

