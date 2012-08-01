Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2HAO5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:57:19 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39003 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab2HAO5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:57:17 -0400
Date: Wed, 1 Aug 2012 10:47:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 17/24] xen: allow privcmd for HVM guests
Message-ID: <20120801144751.GN7227@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
 <1343316846-25860-17-git-send-email-stefano.stabellini@eu.citrix.com>
 <5012598C0200007800090DB9@nat28.tlf.novell.com>
 <alpine.DEB.2.02.1207271502480.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207271502480.26163@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 03:10:13PM +0100, Stefano Stabellini wrote:
> On Fri, 27 Jul 2012, Jan Beulich wrote:
> > >>> On 26.07.12 at 17:33, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > > In order for privcmd mmap to work correctly, xen_remap_domain_mfn_range
> > > needs to be implemented for HVM guests.
> > > If it is not, mmap is going to fail later on.
> > 
> > Somehow, for me at least, this description doesn't connect to the
> > actual change.
> 
> We can remove the "return -ENOSYS" from privcmd_mmap but the actual mmap
> is still not going to work unless xen_remap_domain_mfn_range is
> implemented correctly.
> The x86 implementation of xen_remap_domain_mfn_range is PV only so it is
> not going to work for HVM or auto_translated_physmap guests.
> As a result mmap_batch_fn is going to fail.

So what you are saying is that this check is redundant and that earlier
on in the call stack this check is made?

I am not seeing it? I am seeing an:

289         if (!xen_initial_domain())
290                 return -EPERM;

But that would still work.

Perhaps adding an:

	if (xen_hvm_domain())
		return -ENOSYS

is more appropiate in privcmd_ioctl_mmap_batch?

Irrespective of HVM guests, I recall that it is possible to run PV guests
with XENFEAT_auto_translated_physmap? How will this be impacted?

> 
> 
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > ---
> > >  drivers/xen/privcmd.c |    4 ----
> > >  1 files changed, 0 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
> > > index ccee0f1..85226cb 100644
> > > --- a/drivers/xen/privcmd.c
> > > +++ b/drivers/xen/privcmd.c
> > > @@ -380,10 +380,6 @@ static struct vm_operations_struct privcmd_vm_ops = {
> > >  
> > >  static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
> > >  {
> > > -	/* Unsupported for auto-translate guests. */
> > > -	if (xen_feature(XENFEAT_auto_translated_physmap))
> > > -		return -ENOSYS;
> > > -
> > 
> > Is this safe on x86?
> > 
> 
> It is safe in the sense that is not going to crash dom0 or the
> hypervisor, but it is not going to work.
> 
> Actually in order for it to be safe we need this additional change:
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 3a73785..885a223 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -2310,6 +2310,9 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
>  	unsigned long range;
>  	int err = 0;
>  
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return -EINVAL;
> +
>  	prot = __pgprot(pgprot_val(prot) | _PAGE_IOMAP);
>  
>  	BUG_ON(!((vma->vm_flags & (VM_PFNMAP | VM_RESERVED | VM_IO)) ==
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
