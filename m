Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2HGSlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:41:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17069 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab2HGSlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:41:35 -0400
Date: Tue, 7 Aug 2012 14:31:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        catalin.marinas@arm.com, arnd@arndb.de
Subject: Re: [PATCH v2 18/23] xen: allow privcmd for HVM guests
Message-ID: <20120807183155.GU15053@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-18-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344263246-28036-18-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:27:21PM +0100, Stefano Stabellini wrote:
> This patch removes the "return -ENOSYS" for auto_translated_physmap
> guests from privcmd_mmap, thus it allows ARM guests to issue privcmd
> mmap calls. However privcmd mmap calls are still going to fail for HVM
> and hybrid guests on x86 because the xen_remap_domain_mfn_range
> implementation is currently PV only.

Looks good. Ack from me.
> 
> Changes in v2:
> 
> - better commit message;
> - return -EINVAL from xen_remap_domain_mfn_range if
>   auto_translated_physmap.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/mmu.c    |    3 +++
>  drivers/xen/privcmd.c |    4 ----
>  2 files changed, 3 insertions(+), 4 deletions(-)
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
> diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
> index ccee0f1..85226cb 100644
> --- a/drivers/xen/privcmd.c
> +++ b/drivers/xen/privcmd.c
> @@ -380,10 +380,6 @@ static struct vm_operations_struct privcmd_vm_ops = {
>  
>  static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> -	/* Unsupported for auto-translate guests. */
> -	if (xen_feature(XENFEAT_auto_translated_physmap))
> -		return -ENOSYS;
> -
>  	/* DONTCOPY is essential for Xen because copy_page_range doesn't know
>  	 * how to recreate these mappings */
>  	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY | VM_PFNMAP;
> -- 
> 1.7.2.5
