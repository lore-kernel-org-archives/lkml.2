Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab2G0OLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 10:11:09 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:62364 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2G0OLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 10:11:07 -0400
X-IronPort-AV: E=Sophos;i="4.77,667,1336348800"; 
   d="scan'208";a="13736617"
Date: Fri, 27 Jul 2012 15:10:13 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Jan Beulich <JBeulich@suse.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>
Subject: Re: [Xen-devel] [PATCH 17/24] xen: allow privcmd for HVM guests
In-Reply-To: <5012598C0200007800090DB9@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.02.1207271502480.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-17-git-send-email-stefano.stabellini@eu.citrix.com> <5012598C0200007800090DB9@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012, Jan Beulich wrote:
> >>> On 26.07.12 at 17:33, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > In order for privcmd mmap to work correctly, xen_remap_domain_mfn_range
> > needs to be implemented for HVM guests.
> > If it is not, mmap is going to fail later on.
> 
> Somehow, for me at least, this description doesn't connect to the
> actual change.

We can remove the "return -ENOSYS" from privcmd_mmap but the actual mmap
is still not going to work unless xen_remap_domain_mfn_range is
implemented correctly.
The x86 implementation of xen_remap_domain_mfn_range is PV only so it is
not going to work for HVM or auto_translated_physmap guests.
As a result mmap_batch_fn is going to fail.


> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  drivers/xen/privcmd.c |    4 ----
> >  1 files changed, 0 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
> > index ccee0f1..85226cb 100644
> > --- a/drivers/xen/privcmd.c
> > +++ b/drivers/xen/privcmd.c
> > @@ -380,10 +380,6 @@ static struct vm_operations_struct privcmd_vm_ops = {
> >  
> >  static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
> >  {
> > -	/* Unsupported for auto-translate guests. */
> > -	if (xen_feature(XENFEAT_auto_translated_physmap))
> > -		return -ENOSYS;
> > -
> 
> Is this safe on x86?
> 

It is safe in the sense that is not going to crash dom0 or the
hypervisor, but it is not going to work.

Actually in order for it to be safe we need this additional change:

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

