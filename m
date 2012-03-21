Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab2CUPDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:03:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45923 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab2CUPDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:03:11 -0400
Date: Thu, 22 Mar 2012 02:02:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Salter <msalter@redhat.com>
Cc: aarcange@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: build failure in linux-next
Message-Id: <20120322020255.69abea4d758e92a210f1790d@canb.auug.org.au>
In-Reply-To: <1332340575.12353.55.camel@deneb.redhat.com>
References: <1332340575.12353.55.camel@deneb.redhat.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Mar_2012_02_02_55_+1100_uUOAy_Q3DUI3vfnT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Mar_2012_02_02_55_+1100_uUOAy_Q3DUI3vfnT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[cc: akpm]

On Wed, 21 Mar 2012 10:36:14 -0400 Mark Salter <msalter@redhat.com> wrote:
>
> I'm seeing a build failure in linux-next:
>=20
>   CC      init/main.o
> In file included from /es/linux/linux-next/arch/c6x/include/asm/pgtable.h=
:76:0,
>                  from /es/linux/linux-next/include/linux/mm.h:44,
>                  from /es/linux/linux-next/include/linux/ring_buffer.h:5,
>                  from /es/linux/linux-next/include/linux/ftrace_event.h:4,
>                  from /es/linux/linux-next/include/trace/syscall.h:6,
>                  from /es/linux/linux-next/include/linux/syscalls.h:78,
>                  from /es/linux/linux-next/init/main.c:16:
> /es/linux/linux-next/include/asm-generic/pgtable.h: In function 'pmd_none=
_or_trans_huge_or_clear_bad':
> /es/linux/linux-next/include/asm-generic/pgtable.h:476:4: error: implicit=
 declaration of function 'pmd_clear_bad' [-Werror=3Dimplicit-function-decla=
ration]
>=20
>=20
> This patch added some functions to asm-generic/pgtable.h which should
> have been placed in the CONFIG_MMU conditional block:
>=20
>   Author: Andrea Arcangeli <aarcange@redhat.com>
>   Date:   Wed Mar 21 10:48:00 2012 +1100
>=20
>       mm: thp: fix pmd_bad() triggering in code paths holding mmap_sem re=
ad mode
>=20
>=20
> The following patch fixes the build problem for me:
>=20
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index 202c010..8ba3ba5 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -342,6 +342,64 @@ static inline void ptep_modify_prot_commit(struct mm=
_struct *mm,
>  	__ptep_modify_prot_commit(mm, addr, ptep, pte);
>  }
>  #endif /* __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION */
> +
> +/*
> + * This function is meant to be used by sites walking pagetables with
> + * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
> + * transhuge page faults. MADV_DONTNEED can convert a transhuge pmd
> + * into a null pmd and the transhuge page fault can convert a null pmd
> + * into an hugepmd or into a regular pmd (if the hugepage allocation
> + * fails). While holding the mmap_sem in read mode the pmd becomes
> + * stable and stops changing under us only if it's not null and not a
> + * transhuge pmd. When those races occurs and this function makes a
> + * difference vs the standard pmd_none_or_clear_bad, the result is
> + * undefined so behaving like if the pmd was none is safe (because it
> + * can return none anyway). The compiler level barrier() is critically
> + * important to compute the two checks atomically on the same pmdval.
> + */
> +static inline int pmd_none_or_trans_huge_or_clear_bad(pmd_t *pmd)
> +{
> +	/* depend on compiler for an atomic pmd read */
> +	pmd_t pmdval =3D *pmd;
> +	/*
> +	 * The barrier will stabilize the pmdval in a register or on
> +	 * the stack so that it will stop changing under the code.
> +	 */
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	barrier();
> +#endif
> +	if (pmd_none(pmdval))
> +		return 1;
> +	if (unlikely(pmd_bad(pmdval))) {
> +		if (!pmd_trans_huge(pmdval))
> +			pmd_clear_bad(pmd);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * This is a noop if Transparent Hugepage Support is not built into
> + * the kernel. Otherwise it is equivalent to
> + * pmd_none_or_trans_huge_or_clear_bad(), and shall only be called in
> + * places that already verified the pmd is not none and they want to
> + * walk ptes while holding the mmap sem in read mode (write mode don't
> + * need this). If THP is not enabled, the pmd can't go away under the
> + * code even if MADV_DONTNEED runs, but if THP is enabled we need to
> + * run a pmd_trans_unstable before walking the ptes after
> + * split_huge_page_pmd returns (because it may have run when the pmd
> + * become null, but then a page fault can map in a THP and not a
> + * regular page).
> + */
> +static inline int pmd_trans_unstable(pmd_t *pmd)
> +{
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	return pmd_none_or_trans_huge_or_clear_bad(pmd);
> +#else
> +	return 0;
> +#endif
> +}
> +
>  #endif /* CONFIG_MMU */
> =20
>  /*
> @@ -444,63 +502,6 @@ static inline int pmd_write(pmd_t pmd)
>  #endif /* __HAVE_ARCH_PMD_WRITE */
>  #endif
> =20
> -/*
> - * This function is meant to be used by sites walking pagetables with
> - * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
> - * transhuge page faults. MADV_DONTNEED can convert a transhuge pmd
> - * into a null pmd and the transhuge page fault can convert a null pmd
> - * into an hugepmd or into a regular pmd (if the hugepage allocation
> - * fails). While holding the mmap_sem in read mode the pmd becomes
> - * stable and stops changing under us only if it's not null and not a
> - * transhuge pmd. When those races occurs and this function makes a
> - * difference vs the standard pmd_none_or_clear_bad, the result is
> - * undefined so behaving like if the pmd was none is safe (because it
> - * can return none anyway). The compiler level barrier() is critically
> - * important to compute the two checks atomically on the same pmdval.
> - */
> -static inline int pmd_none_or_trans_huge_or_clear_bad(pmd_t *pmd)
> -{
> -	/* depend on compiler for an atomic pmd read */
> -	pmd_t pmdval =3D *pmd;
> -	/*
> -	 * The barrier will stabilize the pmdval in a register or on
> -	 * the stack so that it will stop changing under the code.
> -	 */
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	barrier();
> -#endif
> -	if (pmd_none(pmdval))
> -		return 1;
> -	if (unlikely(pmd_bad(pmdval))) {
> -		if (!pmd_trans_huge(pmdval))
> -			pmd_clear_bad(pmd);
> -		return 1;
> -	}
> -	return 0;
> -}
> -
> -/*
> - * This is a noop if Transparent Hugepage Support is not built into
> - * the kernel. Otherwise it is equivalent to
> - * pmd_none_or_trans_huge_or_clear_bad(), and shall only be called in
> - * places that already verified the pmd is not none and they want to
> - * walk ptes while holding the mmap sem in read mode (write mode don't
> - * need this). If THP is not enabled, the pmd can't go away under the
> - * code even if MADV_DONTNEED runs, but if THP is enabled we need to
> - * run a pmd_trans_unstable before walking the ptes after
> - * split_huge_page_pmd returns (because it may have run when the pmd
> - * become null, but then a page fault can map in a THP and not a
> - * regular page).
> - */
> -static inline int pmd_trans_unstable(pmd_t *pmd)
> -{
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	return pmd_none_or_trans_huge_or_clear_bad(pmd);
> -#else
> -	return 0;
> -#endif
> -}
> -
>  #endif /* !__ASSEMBLY__ */
> =20
>  #endif /* _ASM_GENERIC_PGTABLE_H */
>=20
>=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__22_Mar_2012_02_02_55_+1100_uUOAy_Q3DUI3vfnT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPae2fAAoJEECxmPOUX5FEh3kQAKDb7e2LxvX13RN72zjGmlLq
vbDzLnvTJ35APs32WhZhfvJKwmUPg3xbHWARguYTaU9Vrmbp9rgIBJOUSqij7YWn
9mWiq3hen4013Ic2BBifZEq8uf2FmrBwIKSpjZNapCgrpdA6OwMiM26OJIPJQrEl
/jUFZockWmN2aTMC/ez7vDUyQUKHegccz0mZFM+YaM3rPdZzk+sUfXbzAlSxgprG
pbRNOfcHo2o1YjVBR2AUKx3IaGHstQ9/CDCNmSP4MifJ62fBiLuvCPlhL46UGBFi
kV+M7qhyWmuyvbcs0IQPVhJsxGL7tkuz4rEuPJJ+oQ90+M2xHnzf/wti6UMY6hax
RBy7GsDvIPdZMYUgeTzLQpr4YRnHO7ZUCGcsNxdIijQ1IntM1HITzVGh8JobDDav
uKHR3Jryd5bvYoDAfIwAUMAWyjR8AKXt89hpi9jRX3CewrfyS8IFkoIXl5ilLwQA
BedKNM8lEm3sHacQTO+UT/IxoUVkjV7CNsuOHMe588Po3ON1NCqZFcqASHUAA8/U
E9rYFEXFd7655nJBvgDNxYoDoQyIyVMBPlF11pBD9UhGdcfnBYTCxMESyWr4mmOi
ZWdzPBW4FgHC+qJPRqDad7OwYeOxNG89LD1oTUGMFVH+OjjyHQagg2eursirdvgg
ntnD/BFm9/K9H7FngZoh
=wVSk
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Mar_2012_02_02_55_+1100_uUOAy_Q3DUI3vfnT--
