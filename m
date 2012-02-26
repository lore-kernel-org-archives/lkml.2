Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2BZXpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:45:13 -0500
Received: from uucp.gnuu.de ([83.246.114.63]:1106 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab2BZXpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:45:10 -0500
Date: Sun, 26 Feb 2012 01:06:30 +0100
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Alexander Graf <agraf@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Message-ID: <20120226000630.GC22460@alea.gnuu.de>
References: <20111107194838.GA23558@alea.gnuu.de>
 <20111122200414.GA28205@alea.gnuu.de>
 <E687C074-57CC-41AD-BA0E-0C957679E900@suse.de>
 <20120220173844.GA2546@alea.gnuu.de>
 <8F6910F4-7F2E-44FE-B0C2-1A2FF95888D2@suse.de>
 <20120221083213.GA19059@alea.gnuu.de>
 <20120225145115.GB22460@alea.gnuu.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <20120225145115.GB22460@alea.gnuu.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

J=C3=B6rg Sommer hat am Sat 25. Feb, 15:51 (+0100) geschrieben:
> J=C3=B6rg Sommer hat am Tue 21. Feb, 09:32 (+0100) geschrieben:
> > Alexander Graf hat am Mon 20. Feb, 22:27 (+0100) geschrieben:
> > > On 20.02.2012, at 18:38, J=C3=B6rg Sommer wrote:
> > > > Alexander Graf hat am Tue 22. Nov, 22:29 (+0100) geschrieben:
> > > >> On 22.11.2011, at 21:04, J=C3=B6rg Sommer wrote:
> > > >>> [1] =C2=BBkernel BUG at include/linux/kvm_host.h:603!=C2=AB
> > > >>> http://www.mail-archive.com/kvm@vger.kernel.org/msg61433.html
> > > >>=20
> > > >> This is unfortunately still there. It's because of preemption being
> > > >> enabled. Please just use CONFIG_PREEMPT_NONE for the time being
> > > >=20
> > > > This doesn't help. I've build with CONFIG_PREEMPT_NONE, but I'm get=
ting
> > > > this Oops, when I start qemu.
> > >=20
> > > Could you please try git://git.kernel.org/pub/scm/virt/kvm/kvm.git? I
> > > fixed a bunch of things with preemption since then and it definitely
> > > worked for me. If it still fails in that tree, I can try again to
> > > reproduce it :).
> >=20
> > This kernel (e9badff4b38a3f8b2c20aa8a30db210caf85a497) fails to build:
> >=20
> >   CC [M]  arch/powerpc/kvm/book3s_pr.o
> > arch/powerpc/kvm/book3s_pr.c: In function =E2=80=98kvm_vcpu_ioctl_get_o=
ne_reg=E2=80=99:
> > arch/powerpc/kvm/book3s_pr.c:883:45: error: cast to pointer from intege=
r of different size [-Werror=3Dint-to-pointer-cast]
> > arch/powerpc/kvm/book3s_pr.c:883:80: error: cast to pointer from intege=
r of different size [-Werror=3Dint-to-pointer-cast]
> > arch/powerpc/kvm/book3s_pr.c:883:284: error: cast to pointer from integ=
er of different size [-Werror=3Dint-to-pointer-cast]
> > arch/powerpc/kvm/book3s_pr.c:883:327: error: cast to pointer from integ=
er of different size [-Werror=3Dint-to-pointer-cast]
> > arch/powerpc/kvm/book3s_pr.c:883:459: error: cast to pointer from integ=
er of different size [-Werror=3Dint-to-pointer-cast]
> > arch/powerpc/kvm/book3s_pr.c:883:748: error: cast to pointer from integ=
er of different size [-Werror=3Dint-to-pointer-cast]
> > arch/powerpc/kvm/book3s_pr.c:883:1112: error: cast to pointer from inte=
ger of different size [-Werror=3Dint-to-pointer-cast]
> > arch/powerpc/kvm/book3s_pr.c:883:1476: error: cast to pointer from inte=
ger of different size [-Werror=3Dint-to-pointer-cast]
> > arch/powerpc/kvm/book3s_pr.c:883:1867: error: cast to pointer from inte=
ger of different size [-Werror=3Dint-to-pointer-cast]

> @@ -652,6 +653,11 @@ static int kvm_vcpu_ioctl_get_one_reg(struct kvm_vcp=
u *vcpu,
>         int r =3D -EINVAL;
> =20
>         switch (reg->id) {
> +#ifdef CONFIG_PPC_BOOK3S
> +       case KVM_REG_PPC_HIOR:
> +               r =3D put_user(to_book3s(vcpu)->hior, (u64 __user *)reg->=
addr);
> +               break;
> +#endif
>         default:
>                 break;
>         }

Is this the right fix for this code?

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index ee222ec..a5d061c 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -880,7 +880,7 @@ int kvm_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu, s=
truct kvm_one_reg *reg)
=20
        switch (reg->id) {
        case KVM_REG_PPC_HIOR:
-               r =3D put_user(to_book3s(vcpu)->hior, (u64 __user *)reg->ad=
dr);
+               r =3D put_user(to_book3s(vcpu)->hior, (u64 __user *)&reg->a=
ddr);
                break;
        default:
                break;
@@ -895,7 +895,7 @@ int kvm_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu, s=
truct kvm_one_reg *reg)
=20
        switch (reg->id) {
        case KVM_REG_PPC_HIOR:
-               r =3D get_user(to_book3s(vcpu)->hior, (u64 __user *)reg->ad=
dr);
+               r =3D get_user(to_book3s(vcpu)->hior, (u64 __user *)&reg->a=
ddr);
                if (!r)
                        to_book3s(vcpu)->hior_explicit =3D true;
                break;

Bye, J=C3=B6rg.
--=20
If Java had true garbage collection, most programs would delete
themselves upon execution

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9Jd4UACgkQwe0mZwH1VIDnTwCgrmTJyVFHY/dyWIyqAbdilDUQ
O1MAnjGhcLCKZEau29xlrV7Gl8QNLnux
=+JNY
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
