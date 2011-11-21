Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1KUQOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:14:55 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:37341 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab1KUQOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:14:54 -0500
Date: Mon, 21 Nov 2011 11:14:48 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Ken Chen <kenchen@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch] hugetlb: add mremap support for static hugepage mapping.
Message-ID: <20111121161448.GB7722@mgebm.net>
References: <20111103215253.7EF1E122186@elm.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <20111103215253.7EF1E122186@elm.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 03 Nov 2011, Ken Chen wrote:

> hugetlb: add mremap support for static hugepage mapping.
>=20
> This commit adds mm support to perform mremap() on mapping that were
> backed by static hugepages.  The operation is fairly straightforward
> where we need to check basic address alignment and size constraints.
> For cases where page table need to be relocated, a hugetlb specific
> function is introduced to perform the operation.
>=20
> mremap() is an ideal syscall interface for applications that want to
> expand an existing mapping, or relocate virtual address to another place.
> Over the year, hugetlb page has gained more support in the mm subsystem
> and natually as more application uses them, it requires more comprehensive
> support in the API.  There are several applications where we would like
> to use mremap() on a hugetlb backed mapping.  This commit adds the
> necessary support.
>=20
> Signed-off-by: Ken Chen <kenchen@google.com>

Acked-by: Eric B Munson <emunson@mgebm.net>


>=20
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 19644e0..c36d851 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -26,6 +26,8 @@ int hugetlb_mempolicy_sysctl_handler(
>  					void __user *, size_t *, loff_t *);
>  #endif
> =20
> +int move_hugetlb_page_tables(struct vm_area_struct *vma, unsigned long o=
ld_addr,
> +			     unsigned long new_addr, unsigned long len);
>  int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, stru=
ct vm_area_struct *);
>  int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
>  			struct page **, struct vm_area_struct **,
> @@ -87,6 +89,7 @@ static inline unsigned long hugetlb_total_pages(void)
> =20
>  #define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
>  #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
> +#define move_hugetlb_page_tables(vma, old_addr, new_addr, len) ({ BUG();=
 0; })
>  #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
>  #define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
>  #define unmap_hugepage_range(vma, start, end, page)	BUG()
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index dae27ba..6f5b56f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2207,6 +2207,49 @@ static int is_hugetlb_entry_hwpoisoned(pte_t pte)
>  		return 0;
>  }
> =20
> +int move_hugetlb_page_tables(struct vm_area_struct *vma, unsigned long o=
ld_addr,
> +			     unsigned long new_addr, unsigned long len)
> +{
> +	struct hstate *h =3D hstate_vma(vma);
> +	unsigned long sz =3D huge_page_size(h);
> +	struct mm_struct *mm =3D vma->vm_mm;
> +	unsigned long old_end =3D old_addr + len;
> +	pte_t *src_pte, *dst_pte, entry;
> +	struct address_space *mapping =3D NULL;
> +
> +	if (vma->vm_file) {
> +		mapping =3D vma->vm_file->f_mapping;
> +		mutex_lock(&mapping->i_mmap_mutex);
> +	}
> +
> +	mmu_notifier_invalidate_range_start(vma->vm_mm, old_addr, old_end);
> +
> +	for (; old_addr < old_end; old_addr +=3D sz, new_addr +=3D sz) {
> +
> +		src_pte =3D huge_pte_offset(mm, old_addr);
> +		if (!src_pte)
> +			continue;
> +		if (huge_pte_none(huge_ptep_get(src_pte)))
> +			continue;
> +		dst_pte =3D huge_pte_alloc(mm, new_addr, sz);
> +		if (!dst_pte)
> +			break;
> +
> +		spin_lock(&mm->page_table_lock);
> +		entry =3D huge_ptep_get_and_clear(mm, old_addr, src_pte);
> +		set_huge_pte_at(mm, new_addr, dst_pte, entry);
> +		spin_unlock(&mm->page_table_lock);
> +	}
> +
> +	flush_tlb_range(vma, old_end - len, old_end);
> +	mmu_notifier_invalidate_range_end(vma->vm_mm, old_end-len, old_end);
> +
> +	if (mapping)
> +		mutex_unlock(&mapping->i_mmap_mutex);
> +
> +	return len + old_addr - old_end;
> +}
> +
>  void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long st=
art,
>  			    unsigned long end, struct page *ref_page)
>  {
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 506fa44..9f6c903 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -138,6 +138,9 @@ unsigned long move_page_tables(struct vm_area_struct =
*vma,
>  	old_end =3D old_addr + len;
>  	flush_cache_range(vma, old_addr, old_end);
> =20
> +	if (is_vm_hugetlb_page(vma))
> +		return move_hugetlb_page_tables(vma, old_addr, new_addr, len);
> +
>  	for (; old_addr < old_end; old_addr +=3D extent, new_addr +=3D extent) {
>  		cond_resched();
>  		next =3D (old_addr + PMD_SIZE) & PMD_MASK;
> @@ -269,9 +272,6 @@ static struct vm_area_struct *vma_to_resize(
>  	if (!vma || vma->vm_start > addr)
>  		goto Efault;
> =20
> -	if (is_vm_hugetlb_page(vma))
> -		goto Einval;
> -
>  	/* We can't remap across vm area boundaries */
>  	if (old_len > vma->vm_end - addr)
>  		goto Efault;
> @@ -423,6 +423,20 @@ unsigned long do_mremap(unsigned long addr,
>  	old_len =3D PAGE_ALIGN(old_len);
>  	new_len =3D PAGE_ALIGN(new_len);
> =20
> +	vma =3D find_vma(mm, addr);
> +	if (!vma || vma->vm_start > addr)
> +		goto out;
> +
> +	if (is_vm_hugetlb_page(vma)) {
> +		struct hstate *h =3D hstate_vma(vma);
> +
> +		if (addr & ~huge_page_mask(h))
> +			goto out;
> +
> +		old_len =3D ALIGN(old_len, huge_page_size(h));
> +		new_len =3D ALIGN(new_len, huge_page_size(h));
> +	}
> +
>  	/*
>  	 * We allow a zero old-len as a special case
>  	 * for DOS-emu "duplicate shm area" thing. But
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOynj4AAoJEKhG9nGc1bpJXEsP/R6b4sqPi1KIk5+U1ITZ00GK
fBNnC4Tg9dillkbHLpL/bULt2nU6pa2e71+yQMQWTubVDSp/erEPyW+X4x51eIjm
0Kro9VYy0D93a47m0Xz7+f135Xl3lOlzXzCvMdlRkU9qYfd+TnxCUQn3EbUSNI8/
dape09AyHwdqDjfBGfwcC/CEu6B+KT08VjBn+w/hvDQYkI4gw9KND1FEWI05QJDw
nQgudCECsc5zT7Wobr41yqfBY10d2T5SA9vHymH2aU9NGRYe1piIHsT+vWvbQZdm
XGMOOGV7gia7ABF4eIC9HtC93Zp1O6ZlGY/SMfQwunmUN5KdYBR+Wmxrw28UM9gg
HykMUbp5zov1XvFFtPwWXYlGm+/G+wTRnwSDpoqT2R9uIdn/SWjktqEk5s5xMl0P
KLxQnb9C0PHPpWYcUknldqOPOMpnZqwkX/ldhR0sUaNJa0sHg5Jh9YMa9iYxCXaC
dJlkubLE8Fojpuy7CGev2XuZsJjvP5K6CNH7ud6wvLLJgenhMv7sQAJQAwAOOXLN
qUNrIRcNlik16eYxlUfvt/DYlNXu76II5ihfu3sL56QoLejUv/Mj944ZZrubk/tg
yWxSAOLLI7qODakLvbI1dJlV4Z/LO3xiSiV2tu4krA++KNqJLAl43B9b7VJxoUxt
5QoDWRLdcnTVdU1NUHON
=VIjN
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
