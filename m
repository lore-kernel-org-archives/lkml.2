Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab2CUPHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:07:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57726 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2CUPHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:07:16 -0400
Date: Thu, 22 Mar 2012 02:07:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mark Salter <msalter@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: build failure in linux-next
Message-Id: <20120322020708.0a0583b11f03d24fd1198013@canb.auug.org.au>
In-Reply-To: <20120321145934.GA24602@redhat.com>
References: <1332340575.12353.55.camel@deneb.redhat.com>
	<20120321145934.GA24602@redhat.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Mar_2012_02_07_08_+1100_iv8d_ORCP9EYDqk4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Mar_2012_02_07_08_+1100_iv8d_ORCP9EYDqk4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Cc: akpm]

On Wed, 21 Mar 2012 15:59:34 +0100 Andrea Arcangeli <aarcange@redhat.com> w=
rote:
>
> On Wed, Mar 21, 2012 at 10:36:14AM -0400, Mark Salter wrote:
> > I'm seeing a build failure in linux-next:
> >=20
> >   CC      init/main.o
> > In file included from /es/linux/linux-next/arch/c6x/include/asm/pgtable=
.h:76:0,
> >                  from /es/linux/linux-next/include/linux/mm.h:44,
> >                  from /es/linux/linux-next/include/linux/ring_buffer.h:=
5,
> >                  from /es/linux/linux-next/include/linux/ftrace_event.h=
:4,
> >                  from /es/linux/linux-next/include/trace/syscall.h:6,
> >                  from /es/linux/linux-next/include/linux/syscalls.h:78,
> >                  from /es/linux/linux-next/init/main.c:16:
> > /es/linux/linux-next/include/asm-generic/pgtable.h: In function 'pmd_no=
ne_or_trans_huge_or_clear_bad':
> > /es/linux/linux-next/include/asm-generic/pgtable.h:476:4: error: implic=
it declaration of function 'pmd_clear_bad' [-Werror=3Dimplicit-function-dec=
laration]
> >=20
> >=20
> > This patch added some functions to asm-generic/pgtable.h which should
> > have been placed in the CONFIG_MMU conditional block:
> >=20
> >   Author: Andrea Arcangeli <aarcange@redhat.com>
> >   Date:   Wed Mar 21 10:48:00 2012 +1100
> >=20
> >       mm: thp: fix pmd_bad() triggering in code paths holding mmap_sem =
read mode
> >=20
> >=20
> > The following patch fixes the build problem for me:
>=20
> Thanks for noticing this problem.
>=20
>=20
>=20
> >=20
> > diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtabl=
e.h
> > index 202c010..8ba3ba5 100644
> > --- a/include/asm-generic/pgtable.h
> > +++ b/include/asm-generic/pgtable.h
> > @@ -342,6 +342,64 @@ static inline void ptep_modify_prot_commit(struct =
mm_struct *mm,
> >  	__ptep_modify_prot_commit(mm, addr, ptep, pte);
> >  }
> >  #endif /* __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION */
> > +
> > +/*
> > + * This function is meant to be used by sites walking pagetables with
> > + * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
> > + * transhuge page faults. MADV_DONTNEED can convert a transhuge pmd
> > + * into a null pmd and the transhuge page fault can convert a null pmd
> > + * into an hugepmd or into a regular pmd (if the hugepage allocation
> > + * fails). While holding the mmap_sem in read mode the pmd becomes
> > + * stable and stops changing under us only if it's not null and not a
> > + * transhuge pmd. When those races occurs and this function makes a
> > + * difference vs the standard pmd_none_or_clear_bad, the result is
> > + * undefined so behaving like if the pmd was none is safe (because it
> > + * can return none anyway). The compiler level barrier() is critically
> > + * important to compute the two checks atomically on the same pmdval.
> > + */
> > +static inline int pmd_none_or_trans_huge_or_clear_bad(pmd_t *pmd)
> > +{
> > +	/* depend on compiler for an atomic pmd read */
> > +	pmd_t pmdval =3D *pmd;
> > +	/*
> > +	 * The barrier will stabilize the pmdval in a register or on
> > +	 * the stack so that it will stop changing under the code.
> > +	 */
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +	barrier();
> > +#endif
> > +	if (pmd_none(pmdval))
> > +		return 1;
> > +	if (unlikely(pmd_bad(pmdval))) {
> > +		if (!pmd_trans_huge(pmdval))
> > +			pmd_clear_bad(pmd);
>=20
> Problem is, this fixes MMU=3Dn but it'll break x86 with MMU=3Dy and THP=
=3Dn.
>=20
> These functions shall be placed after pmd_trans_huge you see at the
> end of asm-generic/pgtable.h .
>=20
> The simplest fix is that you add #ifdef CONFIG_MMU around it instead
> of moving (I guess you can keep pmd_trans_huge and the rest at the end
> of the file inside CONFIG_MMU too as it shall never be called as it
> all takes pmds/ptes as parameter).
>=20
> Thanks,
> Andrea

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Mar_2012_02_07_08_+1100_iv8d_ORCP9EYDqk4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPae6cAAoJEECxmPOUX5FECL4P/2yq6kUL/mV3U7wfABDVwswh
oEZS+fmGXgDxElHpXf3U4z3FLuUyGIc2aBg/pFxiLvTwiToEiHZW2Xd8hPyBFySz
LmBRE6WjshiliOo3Zihk6lVO/hXhHPaUH7d5BJE4DjEBpw00XAIroW0Iz2maln7i
ckfZampstSEnG3cr5gSdDl9ug8R85FNe4fiU9KY3IZGNxjcOkYAdxa/zzFaPt55x
ZVdO3AoTCed1R5Mguf41nLxt3Lq7wxcGSk9v2QwdrzKMi7r8Wu1cQ5b2At6gn34V
aO4+0eTDnANvn0ItHk6SUmKt3zmNdFxfp+qwmT2Vh3b9cXB0PLT7bGh0iBcnF49E
eEXyZx364OSfT6EraBQuUrGi3kbIYb1JtRp7phtGOckCt1IZJYl306b9kiygtwYt
Hpq8+CHyhiFAoAl83Jt7rSPxfMf4Xc3AhbpGe0jOGnWbN/nvxjQeK+6EPWZsXl3y
3RH6K49QWyN0wadJpqZXd2PTXuOM6u0pkEchiAq/URoba4z4J1ojJjDh0sU++XjW
hk6ulEpTFiRddiP5OTASoGyTznwNZ0qMgluHUJb+9trAz86X+eCTwwbOuLYc92tf
1TLsaVbUBUZymszdR/HJg44A/sDJZZS/ouGi+WqloXMudgUo/nByS9Sjvu1z45bi
1yD22dWQbB8vuQErYLWT
=fFWr
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Mar_2012_02_07_08_+1100_iv8d_ORCP9EYDqk4--
