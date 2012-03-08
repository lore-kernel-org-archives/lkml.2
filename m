Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2CHHlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:41:17 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37418 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2CHHlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:41:13 -0500
Date: Thu, 8 Mar 2012 18:41:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120308184105.5b03ec90bcddf90562181277@canb.auug.org.au>
In-Reply-To: <20120307233220.5a76aa3c.akpm@linux-foundation.org>
References: <20120308175307.b295b1013728a5666fe4571a@canb.auug.org.au>
	<20120307233220.5a76aa3c.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_18_41_05_+1100_HEmuPgeUYwJSaHvB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_18_41_05_+1100_HEmuPgeUYwJSaHvB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 7 Mar 2012 23:32:20 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> Actually they're different.  I reworked the earlier patch as below.

OK.  But some comments.

> diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_=
unmapped_area_topdown arch/x86/mm/hugetlbpage.c
> --- a/arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unma=
pped_area_topdown
> +++ a/arch/x86/mm/hugetlbpage.c
> @@ -308,7 +308,7 @@ static unsigned long hugetlb_get_unmappe
>  {
>  	struct hstate *h =3D hstate_file(file);
>  	struct mm_struct *mm =3D current->mm;
> -	struct vm_area_struct *vma, *prev_vma;
> +	struct vm_area_struct *vma;

You still remove prev_vma ...

>  	unsigned long base =3D mm->mmap_base, addr =3D addr0;
>  	unsigned long largest_hole =3D mm->cached_hole_size;
>  	int first_time =3D 1;
> @@ -334,25 +334,16 @@ try_again:
>  		 * i.e. return with success:
>  		 */
>  		vma =3D find_vma(mm, addr);
> -		if (!vma)
> -			return addr;
> -
> -		/*
> -		 * new region fits between prev_vma->vm_end and
> -		 * vma->vm_start, use it:
> -		 */
> -		prev_vma =3D vma->vm_prev;
> -		if (addr + len <=3D vma->vm_start &&
> -		            (!prev_vma || (addr >=3D prev_vma->vm_end))) {
> +		if (vma)
> +			prev_vma =3D vma->vm_prev;

But then assign to it ...

> +		if (!vma || addr + len <=3D vma->vm_start) {
>  			/* remember the address as a hint for next time */
>  		        mm->cached_hole_size =3D largest_hole;
>  		        return (mm->free_area_cache =3D addr);
> -		} else {
> +		} else if (mm->free_area_cache =3D=3D vma->vm_end) {
>  			/* pull free_area_cache down to the first hole */
> -		        if (mm->free_area_cache =3D=3D vma->vm_end) {
> -				mm->free_area_cache =3D vma->vm_start;
> -				mm->cached_hole_size =3D largest_hole;
> -			}
> +			mm->free_area_cache =3D vma->vm_start;
> +			mm->cached_hole_size =3D largest_hole;
>  		}
> =20
>  		/* remember the largest hole we saw so far */

But it never gets used.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Mar_2012_18_41_05_+1100_HEmuPgeUYwJSaHvB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWGKRAAoJEECxmPOUX5FEY7MQAIKecA7hTkBGubvosobfYzni
+DCOt0kEQdqw7L2XiA1IbNHjwokSGbK/0EN3oOiGItaiJcf7ZhFZgzCm7/KUTPTe
F1lpH0a8ZAm+vlHL2/3X5IBWZltipMD2rwTWSNrN6pUGMMcR+Gnm0JTScdVH3UlW
FGh4fmhec+zn2iM3jgKVEIFRzOiAjPSHKJFxFCYjsSpCQJfNueBii/oig8Y3KYaH
v0smJYbV3wZ6JD1pj0bvv6tJPnPw6xNn8WIwt/QqgAICAPJiaG52rC8EWzPc8Bgr
l3bEN0hhM6mkPh3FebdpA9B5E7PZ2IW+iTV5fHdRgKjyjv7898K272ZebmkKa5Vk
+/rujugH/CISgzFe8amF4ZvuguyxcMF54OOVbVwqWk1AkTFk8gPxQHNx44+fNEIT
BufQDn/4ftJGUBa78iG42dTeyInql62UlYHBEkmNR7aAAPLTGemX8OpPzoRMIYJA
mk5wgCOmJHC/8aCgXJJxTyW3HS38ax96mcyzy5xMymv/CSXgLN0h8uI6XVsvv7Gk
YOYCCNoZEWXUUN1dksPuqBcp9BrCQiZn80OaL2q0glmRGOeqnGTO+ZdSWbXjtcKZ
UibWw+OD6M/DElfYG/gKWAv29AUWNYv8/VYnaTUeVnBUG1LSvvLbDPA4t6Xoqybo
Fv/iRisnVkE0Xfi6435j
=fZUC
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_18_41_05_+1100_HEmuPgeUYwJSaHvB--
