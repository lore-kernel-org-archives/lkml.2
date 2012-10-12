Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2JLJL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:11:29 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:43943 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab2JLJL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:11:26 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344211200"; 
   d="scan'208";a="15121333"
Message-ID: <1350033084.14806.60.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V2 7/7]: PVH: privcmd changes.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Oct 2012 10:11:24 +0100
In-Reply-To: <20121011150207.431a087b@mantra.us.oracle.com>
References: <20121011150207.431a087b@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -260,15 +268,24 @@ struct mmap_batch_state {
>  	xen_pfn_t __user *user_mfn;
>  };
>  
> +/* auto translated dom0 note: if domU being created is PV, then mfn is
> + * mfn(addr on bus). If it's auto xlated, then mfn is pfn (input to HAP).
> + */
>  static int mmap_batch_fn(void *data, void *state)
>  {
>  	xen_pfn_t *mfnp = data;
>  	struct mmap_batch_state *st = state;
> +	struct vm_area_struct *vma = st->vma;
> +	struct page **pages = vma->vm_private_data;
> +	struct page *cur_page = NULL;
>  	int ret;
>  
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		cur_page = pages[st->index++];

Shame we can't pass the batchiness of mmap_batch_fn through to
remap_domain_mfn_range. Perhaps one for future work.

> +
>  	ret = xen_remap_domain_mfn_range(st->vma, st->va & PAGE_MASK, *mfnp, 1,
>  					 st->vma->vm_page_prot, st->domain,
> -					 NULL);
> +					 &cur_page);
>  
>  	/* Store error code for second pass. */
>  	*(st->err++) = ret;
> @@ -439,6 +490,20 @@ static long privcmd_ioctl(struct file *file,
>  	return ret;
>  }
>  
> +static void privcmd_close(struct vm_area_struct *vma)
> +{
> +	struct page **pages = vma ? vma->vm_private_data : NULL;
> +	int numpgs = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> +
> +	if (!pages || !numpgs || !xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
> +
> +	xen_unmap_domain_mfn_range(vma);
> +	while (numpgs--)
> +		free_xenballooned_pages(1, &pages[numpgs]);

Does free_xenballooned_pages(numpgs, pages) not do what I expect?

> +	kfree(pages);
> +}
> +
>  static int privcmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
>  	printk(KERN_DEBUG "privcmd_fault: vma=%p %lx-%lx, pgoff=%lx, uv=%p\n",
> @@ -449,6 +514,7 @@ static int privcmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  }
>  
>  static struct vm_operations_struct privcmd_vm_ops = {
> +	.close = privcmd_close,
>  	.fault = privcmd_fault
>  };
>  
> @@ -465,7 +531,7 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
>  
>  static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma)
>  {
> -	return (xchg(&vma->vm_private_data, (void *)1) == NULL);
> +	return !cmpxchg(&vma->vm_private_data, NULL, PRIV_VMA_LOCKED);

Looks good, thanks.

>  }
>  
>  const struct file_operations xen_privcmd_fops = {


