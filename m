Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1LTSNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:13:35 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:24686 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1LTSNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:13:30 -0500
Date: Tue, 20 Dec 2011 13:11:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Adin Scannell <adin@scannell.ca>
Cc: xen-devel@lists.xensource.com, konrad@darnok.org, andres@gridcentric.ca,
        adin@gridcentric.com, olaf@aepfle.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Port of mmap_batch_v2 to support paging in Xen
Message-ID: <20111220181122.GA7152@phenom.dumpdata.com>
References: <1324363013-11031-1-git-send-email-adin@scannell.ca>
 <1324363013-11031-4-git-send-email-adin@scannell.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324363013-11031-4-git-send-email-adin@scannell.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4EF0D00D.0057,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 01:36:53AM -0500, Adin Scannell wrote:
> This wasn't ported from any patch, but was rewritten based on the XCP 2.6.32
> tree.  The code structure is significantly different and this patch mirrors the
> existing Linux code.
> 
> An important reason to add the V2 interface is to support foreign mappings
> (i.e.  qemu-dm) of paged-out pages.  The kernel generally has to do nothing
> beyond implementing this ioctl in order to provide this support.  The V2
> interface is needed only to pass back full error codes from the mmu_update()'s.
> Xen and libxc have a mutual understanding that when you receive an ENOENT error
> code, you back off and try again. The libxc code will already retry mappings
> when an ENOENT is returned.

Can you say what is the difference between V1 and V2? It looks to be just
that V2 adds an array of return values and not overloading the array of
MFNs with the "top nibble for set on err".

> 
> The only exception to the above case is backend drivers using grant operations.
> To support paging, these drivers must appropriately retry grant operations when
> they receive an EAGAIN error code.  This is implemented in a separate patch.

patches. You need one for netback and one for blkback b/c they go to different
maintainers.

> 
> Signed-off-by: Adin Scannell <adin@scannell.ca>
> ---
>  drivers/xen/privcmd.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/xen/privcmd.h |   10 +++++
>  2 files changed, 100 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
> index 161681f..dd77d5c 100644
> --- a/drivers/xen/privcmd.c
> +++ b/drivers/xen/privcmd.c
> @@ -251,6 +251,15 @@ struct mmap_batch_state {
>  	xen_pfn_t __user *user;
>  };
>  
> +struct mmap_batch_v2_state {
> +	domid_t domain;
> +	unsigned long va;
> +	struct vm_area_struct *vma;
> +	unsigned long paged_out;
> +
> +	int __user *err;

The more I look at this along with the previous structure (struct mmap_batch_state)
they more they look like they could be squashed together.

The two differences are the 'paged_out' and *user. You could sqush them
together and use an union to carry those two. 

And then also make the mmap_batch_fn and mmap_batch_v2_fn be almost the
same and unify those two (in a seperate patch of course).

> +};
> +
>  static int mmap_batch_fn(void *data, void *state)
>  {
>  	xen_pfn_t *mfnp = data;
> @@ -268,6 +277,22 @@ static int mmap_batch_fn(void *data, void *state)
>  	return 0;
>  }
>  
> +static int mmap_batch_v2_fn(void *data, void *state)
> +{
> +	xen_pfn_t *mfnp = data;
> +	struct mmap_batch_v2_state *st = state;
> +
> +	BUG_ON(st == NULL || st->vma == NULL);
> +
> +	int rc = xen_remap_domain_mfn_range(st->vma, st->va & PAGE_MASK, *mfnp,
> +				       1, st->vma->vm_page_prot, st->domain);
> +	if (rc == -ENOENT)
> +		st->paged_out++;
> +	st->va += PAGE_SIZE;
> +
> +	return put_user(rc, st->err++);
> +}
> +
>  static int mmap_return_errors(void *data, void *state)
>  {
>  	xen_pfn_t *mfnp = data;
> @@ -340,6 +365,67 @@ out:
>  	return ret;
>  }
>  
> +static long privcmd_ioctl_mmap_batch_v2(void __user *udata)
> +{
> +	int ret;
> +	struct privcmd_mmapbatch_v2 m;
> +	struct mm_struct *mm = current->mm;
> +	struct vm_area_struct *vma = NULL;
> +	unsigned long nr_pages;
> +	LIST_HEAD(pagelist);
> +	struct mmap_batch_v2_state state;
> +
> +	if (!xen_initial_domain())
> +		return -EPERM;
> +
> +	if (copy_from_user(&m, udata, sizeof(m)))
> +		return -EFAULT;
> +
> +	nr_pages = m.num;
> +	if ((m.num <= 0) || (nr_pages > (ULONG_MAX >> PAGE_SHIFT)))
> +		return -EINVAL;
> +
> +	ret = gather_array(&pagelist, m.num, sizeof(xen_pfn_t),
> +			   m.arr);
> +
> +	if (ret || list_empty(&pagelist))
> +		goto out;
> +
> +	down_write(&mm->mmap_sem);
> +
> +	vma = find_vma(mm, m.addr);
> +	ret = -EINVAL;
> +	/* We allow multiple shots here, because this interface
> +	 * is used by libxc and mappings for specific pages will
> +	 * be retried when pages are paged-out (ENOENT). */
> +	if (!vma ||
> +	    vma->vm_ops != &privcmd_vm_ops ||
> +	    (m.addr < vma->vm_start) ||
> +	    ((m.addr + (nr_pages << PAGE_SHIFT)) > vma->vm_end)) {
> +		up_write(&mm->mmap_sem);
> +		goto out;
> +	}
> +
> +	state.domain = m.dom;
> +	state.vma = vma;
> +	state.va = m.addr;
> +	state.err = m.err;
> +	state.paged_out = 0;
> +
> +	up_write(&mm->mmap_sem);
> +
> +	ret = traverse_pages(m.num, sizeof(xen_pfn_t),
> +			     &pagelist, mmap_batch_v2_fn, &state);
> +
> +out:
> +	free_page_list(&pagelist);
> +
> +	if ((ret == 0) && (state.paged_out > 0))
> +		return -ENOENT;
> +	else
> +		return ret;
> +}
> +

This looks so similar to the the v1 version. Can you extract the generic
parts of privcmd_ioctl_mmap_batch out to a function and just use the
_v1 and _v2 for .. well the things that they differ with?

>  static long privcmd_ioctl(struct file *file,
>  			  unsigned int cmd, unsigned long data)
>  {
> @@ -359,6 +445,10 @@ static long privcmd_ioctl(struct file *file,
>  		ret = privcmd_ioctl_mmap_batch(udata);
>  		break;
>  
> +	case IOCTL_PRIVCMD_MMAPBATCH_V2:
> +		ret = privcmd_ioctl_mmap_batch_v2(udata);
> +		break;
> +
>  	default:
>  		ret = -EINVAL;
>  		break;
> diff --git a/include/xen/privcmd.h b/include/xen/privcmd.h
> index 17857fb..39b92b1 100644
> --- a/include/xen/privcmd.h
> +++ b/include/xen/privcmd.h
> @@ -62,6 +62,14 @@ struct privcmd_mmapbatch {
>  	xen_pfn_t __user *arr; /* array of mfns - top nibble set on err */
>  };
>  
> +struct privcmd_mmapbatch_v2 {
> +	int num;          /* number of pages to populate */
> +	domid_t dom;      /* target domain */
> +	__u64 addr;       /* virtual address */
> +	const xen_pfn_t __user *arr; /* array of mfns */
> +	int __user *err;  /* array of error codes */
> +};
> +
>  /*
>   * @cmd: IOCTL_PRIVCMD_HYPERCALL
>   * @arg: &privcmd_hypercall_t
> @@ -73,5 +81,7 @@ struct privcmd_mmapbatch {
>  	_IOC(_IOC_NONE, 'P', 2, sizeof(struct privcmd_mmap))
>  #define IOCTL_PRIVCMD_MMAPBATCH					\
>  	_IOC(_IOC_NONE, 'P', 3, sizeof(struct privcmd_mmapbatch))
> +#define IOCTL_PRIVCMD_MMAPBATCH_V2				\
> +	_IOC(_IOC_NONE, 'P', 4, sizeof(struct privcmd_mmapbatch_v2))
>  
>  #endif /* __LINUX_PUBLIC_PRIVCMD_H__ */
> -- 
> 1.6.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
