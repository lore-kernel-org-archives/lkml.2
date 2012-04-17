Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2DQOs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:48:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19875 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab2DQOs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:48:26 -0400
Date: Tue, 17 Apr 2012 10:43:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] xen: enter/exit lazy_mmu_mode around m2p_override
 calls
Message-ID: <20120417144318.GA28477@phenom.dumpdata.com>
References: <1334075375-25442-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <20120417130340.GA25593@phenom.dumpdata.com>
 <alpine.DEB.2.00.1204171457360.26786@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204171457360.26786@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F8D82B4.00BE,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 03:26:05PM +0100, Stefano Stabellini wrote:
> On Tue, 17 Apr 2012, Konrad Rzeszutek Wilk wrote:
> > On Tue, Apr 10, 2012 at 05:29:34PM +0100, Stefano Stabellini wrote:
> > > This patch is a significant performance improvement for the
> > > m2p_override: about 6% using the gntdev device.
> > > 
> > > Each m2p_add/remove_override call issues a MULTI_grant_table_op and a
> > > __flush_tlb_single if kmap_op != NULL.  Batching all the calls together
> > > is a great performance benefit because it means issuing one hypercall
> > > total rather than two hypercall per page.
> > > If paravirt_lazy_mode is set PARAVIRT_LAZY_MMU, all these calls are
> > > going to be batched together, otherwise they are issued one at a time.
> > > 
> > > Adding arch_enter_lazy_mmu_mode/arch_leave_lazy_mmu_mode around the
> > > m2p_add/remove_override calls forces paravirt_lazy_mode to
> > > PARAVIRT_LAZY_MMU, therefore makes sure that they are always batched.
> > > 
> > > 
> > > Changes in v3:
> > > - do not call arch_enter/leave_lazy_mmu_mode in xen_blkbk_unmap, that
> > > can be called in interrupt context.
> > 
> > This is with RHEL5 (somehow the pvops kernels don't trigger this):
> 
> Do you mean RHEL5 as a guest? Are you using blkback or qdisk?

blkback:

memory = 1024
name = "RHEL5-64"
hvm_loader="/usr/bin/pygrub"
vfb = [ 'vnc=1, vnclisten=0.0.0.0,vncunused=1']
vcpus=2
vif = [ ' mac=00:0F:4B:00:00:74,bridge=switch' ]
disk = [ 'phy:/dev/guests/RHEL5-64,xvda,w' ]
boot = "dnc"
device_model = 'qemu-dm'
vnc=1
videoram=8
vnclisten="0.0.0.0"
vncpasswd=''
stdvga=0
serial='pty'
tsc_mode=0
usb=1
usbdevice='tablet'
xen_platform_pci=1

Thought looking at that guest config I am not sure what it boots as
anymore :-(


> How can I repro the bug?

I just bootup the RHEL5 guest and when it tries to get an DHCP address
it then blows up. Hm, maybe the issue is with network - tap vs netfront ?

> 
> 
> In any case it looks like a similar kind of issue to the one I fixed
> before: paravirt_enter_lazy_mmu is probably called with
> paravirt_lazy_mode == PARAVIRT_LAZY_MMU, in this case by
> gnttab_unmap_refs.
> But I don't understand how gnttab_unmap_refs can be called when you seem
> to be using blkback.
> 
> Anyhow gnttab_unmap_refs can be called by:
> 
> - mmu_notifier on invalidate_range_start;
> - vm_operations_struct on close;
> - file_operations on release;
> - the unmap gntdev ioctl.
> 
> I guess the mmu_notifier or vm_operations_struct could be the ones
> calling gnttab_unmap_refs with lazy_mode set to PARAVIRT_LAZY_MMU.
> 
> I suspect that something like the following code would fix the issue but
> it is pretty ugly and I need to test it before a submitting it as a fix:
> 
> 
> @@ -780,7 +780,7 @@ EXPORT_SYMBOL_GPL(gnttab_map_refs);
>  int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
>                       struct page **pages, unsigned int count, bool clear_pte)
>  {
> -       int i, ret;
> +       int i, ret, lazy = 0;
>  
>         ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
>         if (ret)
> 
> @@ -789,7 +789,10 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
>         if (xen_feature(XENFEAT_auto_translated_physmap))
>                 return ret;
>  
> -       arch_enter_lazy_mmu_mode();
> +       if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
> +               arch_enter_lazy_mmu_mode();
> +               lazy = 1;
> +       }
>  
>         for (i = 0; i < count; i++) {
>                 ret = m2p_remove_override(pages[i], clear_pte);
> @@ -797,7 +800,8 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
>                         return ret;
>         }
>  
> -       arch_leave_lazy_mmu_mode();
> +       if (lazy)
> +               arch_leave_lazy_mmu_mode();
>  
>         return ret;
>  }
