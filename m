Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2DQKyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:54:22 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:54707 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab2DQKyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:54:20 -0400
X-IronPort-AV: E=Sophos;i="4.75,434,1330905600"; 
   d="scan'208";a="11974194"
Date: Tue, 17 Apr 2012 11:58:58 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] xen-blkfront: set pages are FOREIGN_FRAME when sharing
 them
In-Reply-To: <20120416195258.GA14982@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1204171138020.26786@kaball-desktop>
References: <1334075119-25102-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120416195258.GA14982@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 10, 2012 at 05:25:19PM +0100, Stefano Stabellini wrote:
> > Set pages as FOREIGN_FRAME whenever blkfront shares them with another
> > domain. Then when blkfront un-share them, also removes the
> > FOREIGN_FRAME_BIT from the p2m.
> > 
> > We do it so that when the source and the destination domain are the same
> > (blkfront connected to blkback in the same domain) we can more easily
> 
> Hm, however you mention qdisk which does not use blkback?

yes, sorry for the confusion, I meant "disk backend" rather than blkback


> > recognize which ones are the source pfns and which ones are the
> > destination pfns (both are going to be pointing to the same mfns).
> 
> OK, so what happens if we do not do this?

see below

> > Without this patch enstablishing a connection between blkfront and QEMU
> > qdisk in the same domain causes QEMU to hang and never return.
> 
> What is the reason behind it..?
> 
> Just to make sure I got it right:
> 
> The scenario is where a PV guest launches and inside it, it runs
> QEMU exporting its disk (xvda, or some sda if iSCSI or FCoE) to some
> other domain. In other words - a stubdomain, right? That would
> imply that we have xen-blkfront, xen-blkback [or not?], and QEMU
> using gntdev on the same page at some point.
> 
> So if we have a request from the other guest to read, it would be:
>  - QEMU allocates some pages.
>  - QEMU qdisk getting kicked.
>  - QEMU using gntdev to IOCTL_GNTDEV_MAP_GRANT_REF the appropiate
>    page
>  - gntdev ends up calling gnttab_map_refs. The gnttab_map_refs then
>    uses the m2p_add_override, which calls set_phys_to_machine(pfn, FOREIGN_FRAME(mfn)).
>  - QEMU passes the mentioned page to the kernel using the libaio.
>  - libaio does its syscall to sys_aio? which then maps the 'struct page'
>    in the kernel space. The PFN has FOREIGN_FRAME set.
>  - kernel aio code passes the 'struct page' to xen-blkfront.
>  - xen-blkfront now (with your patch) makes sure to re-stamp FOREIGN_FRAME on the
>    PFN.
>    
>  - once xen-blkfront is done, it returns to libaio. libaio calls
>    QEMU and it calls gntdev to unmap. The grant dev does it, and calls
>    m2p_remove_override on the PFN [the one that had the FOREIGN_FRAME bit set].
>    
> Hm, I think I lost myself here.  Is the case here that QEMU does not
> do the IOCTL_GNTDEV_MAP_GRANT_REF so in reality the PFN that is provided
> to xen-blkfront does not have FOREIGN_FRAME stamped?

Nope, the scenario is local attach in dom0: we have a PV disk image in
qcow format and we need to create a corresponding xvda device in dom0 so
that we can use pygrub on it to extract kernel and initramfs.

To solve this problem we create a disk frontend/backend pair both in
dom0, using qdisk as backend.
In this scenario, the mfns shared by the frontend are going to back two
different sets of pfns: the original pfns allocated by the frontend and
the new ones allocated by gntdev for the backend.

Now the problem is that when Linux calls mfn_to_pfn, passing as argument
one of the mfn shared by the frontend, we want to get the pfn returned by
m2p_find_override_pfn (that is the pfn setup by gntdev) but actually we
get the original pfn allocated by the frontend because considering that
the frontend and the backend are in the same domain:

pfn = machine_to_phys_mapping[mfn];
mfn2 = get_phys_to_machine(pfn);

in this case mfn == mfn2.


One possible solution would be to always call m2p_find_override_pfn to
check out whether we have an entry for a given mfn.
However it is not very efficient or scalable.
The other option (that this patch is implementing) is to mark the pages
shared by the frontend as "foreign", so that mfn != mfn2 again.
It makes sense because from the frontend point of view they are donated
to the backend and while so they are not supposed to be used by the
frontend. In a way, they don't belong to the frontend anymore, at least
temporarily.
