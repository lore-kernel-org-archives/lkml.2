Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab1LNRim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:38:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49802 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1LNRij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:38:39 -0500
Date: Wed, 14 Dec 2011 20:42:25 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Aboriginal Linux <aboriginal@lists.landley.net>,
        linux-kernel@vger.kernel.org, davem@davemloft.net, tytso@mit.edu,
        sparclinux@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>
Subject: Re: Sparc-32 doesn't work in 3.1.
Message-ID: <20111214204225.7c8ec86c@sf.home>
In-Reply-To: <4EE80891.70604@landley.net>
References: <4EBEAB5A.5020809@landley.net>
	<4EBF0A25.20604@landley.net>
	<20111211111801.5942ab39@sf.home>
	<4EE80891.70604@landley.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Z/GcynxzqpySNDJb.h1nNxy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Z/GcynxzqpySNDJb.h1nNxy
Content-Type: multipart/mixed; boundary="MP_/f69+LHTAsAtznPEK/_6kdBP"

--MP_/f69+LHTAsAtznPEK/_6kdBP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

[ CCed Jakub ]

>>>   Boot time fixup v1.6. 4/Mar/98 Jakub Jelinek (jj@ultra.linux.cz).
>>>   Patching kernel for srmmu[Fujitsu TurboSparc]/iommu
>>>   Fixup i f029ddfc doesn't refer to a valid instruction at
>>>   f00de648[95eea000]
>>>   halt, power off

> I put the broken image up at http://landley.net/sparc-image for the
> moment, but if you build 3.1 with the attached .config and the toolchain
> mentioned last time, it should reproduce for you.  It's 100% reliable
> for me...

Nice! With this config it breaks for me on your and mine toolchains.
The offending function is ext4_kvmalloc (and similar ext4_kvzalloc).

The usual relocation in sparc looks like a pair of instructions loading
two pats of address in 2 instructions:

Like that:
>        sethi   %hi(ext4_fill_super), %o4       !, tmp113
>        or      %o4, %lo(ext4_fill_super), %o4  ! tmp113,, tmp28

In our case relocatable symbol sits in tail call, so %lo part is in "unusua=
l"
RESTORE instruction:

> ext4_kvmalloc:
...
>         sethi  %hi(___i_page_kernel), %i2      !, tmp112
>        call    __vmalloc, 0    !
>         restore %i2, %lo(___i_page_kernel), %o2        ! tmp112,,
...

David: is this code correct? Or it's a compiler bug? I am sparc32 newbie.
(C source and asm sources of function are in [1])

I think this kind of code is generated only in -Os.
So to workaround it I tried this hack:

> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
>         ret =3D kmalloc(size, flags);
>         if (!ret)
>                 ret =3D __vmalloc(size, flags, PAGE_KERNEL);
> +
> +       asm __volatile__("nop":::"memory");
> +
>         return ret;
>  }
(for both ext4_kvmalloc / ext4_kvzalloc. Attached workaround as a patch.)

It forces compiler to geterate "usual" pattern for relocation.

I think of 2 solutions:

1. trying to fix sparc/boot/btfixupprep.c and arch/sparc/mm/btfixup.c
   to distinct HI22 and LO10 relocations as different ones.
   Right now they are merged into one 'i' type and rely on instruction heur=
istics to fix it.
2. Add a hack to arch/sparc/mm/btfixup.c to recognize restore instruction a=
s well

Any others?

Hope that helps.

[1]:

void *ext4_kvmalloc(size_t size, gfp_t flags)
{
        void *ret;

        ret =3D kmalloc(size, flags);
        if (!ret)
                ret =3D __vmalloc(size, flags, PAGE_KERNEL);
        return ret;
}

        .global ext4_kvmalloc
        .type   ext4_kvmalloc, #function
        .proc   0120
ext4_kvmalloc:
        save    %sp, -96, %sp   !
        mov     %i0, %o0        ! size,
        call    __kmalloc, 0    !,
         mov    %i1, %o1        ! flags,
        cmp     %o0, 0  ! ret,
        bne     .LL274  !
         sethi  %hi(___i_page_kernel), %i2      !, tmp112
        call    __vmalloc, 0    !
         restore %i2, %lo(___i_page_kernel), %o2        ! tmp112,,
.LL274:
        jmp     %i7+8
         restore %g0, %o0, %o0  ! ret,
        .size   ext4_kvmalloc, .-ext4_kvmalloc

--=20

  Sergei

--MP_/f69+LHTAsAtznPEK/_6kdBP
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=pessimizing-hack.patch

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 44d0c8d..570d45e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -117,6 +117,7 @@ void *ext4_kvmalloc(size_t size, gfp_t flags)
 	ret =3D kmalloc(size, flags);
 	if (!ret)
 		ret =3D __vmalloc(size, flags, PAGE_KERNEL);
+	mb(); /* hack to pessimize code */
 	return ret;
 }
=20
@@ -127,6 +128,7 @@ void *ext4_kvzalloc(size_t size, gfp_t flags)
 	ret =3D kzalloc(size, flags);
 	if (!ret)
 		ret =3D __vmalloc(size, flags | __GFP_ZERO, PAGE_KERNEL);
+	mb(); /* hack to pessimize code */
 	return ret;
 }
=20

--MP_/f69+LHTAsAtznPEK/_6kdBP--

--Sig_/Z/GcynxzqpySNDJb.h1nNxy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk7o4AgACgkQcaHudmEf86qwdwCggFtWNXzRiHukG9fDU7CnK769
7HoAnjKR5f0T7t+sMEUqd5+7hdSAP6Fc
=WkJk
-----END PGP SIGNATURE-----

--Sig_/Z/GcynxzqpySNDJb.h1nNxy--
