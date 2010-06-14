Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0FNUXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:23:30 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:50466 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab0FNUX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:23:29 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jun 2010 16:23:29 EDT
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH 2/4] x86: ioremap: fix physical address check
Date: Mon, 14 Jun 2010 22:16:36 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.85; i686; ; )
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
References: <4C11FF10.4060203@jp.fujitsu.com> <4C15F2BD.9020904@jp.fujitsu.com> <4C160D27.1050809@jp.fujitsu.com>
In-Reply-To: <4C160D27.1050809@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5256271.Xt28rHopTh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201006142216.42864.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5256271.Xt28rHopTh
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Kenji Kaneshige wrote:
> (2010/06/14 18:13), Kenji Kaneshige wrote:
> > Thank you Hiroyuki.
> >=20
> > So many bugs in ioremap()...
> >=20
> > Will try with those bugs fixed.
> >=20
> > Thanks,
> > Kenji Kaneshige
>=20
> The problem seems to be fixed by the following patch. This is still
> under testing. I will post the patch as v2 after testing.
>=20
> Thanks,
> Kenji Kaneshige
>=20
>=20
> Current x86 ioremap() doesn't handle physical address higher than
> 32-bit properly in X86_32 PAE mode. When physical address higher than
> 32-bit is passed to ioremap(), higher 32-bits in physical address is
> cleared wrongly. Due to this bug, ioremap() can map wrong address to
> linear address space.
>=20
> In my case, 64-bit MMIO region was assigned to a PCI device (ioat
> device) on my system. Because of the ioremap()'s bug, wrong physical
> address (instead of MMIO region) was mapped to linear address space.
> Because of this, loading ioatdma driver caused unexpected behavior
> (kernel panic, kernel hangup, ...).
>=20
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>=20
> ---
>  arch/x86/mm/ioremap.c   |   11 +++++------
>  include/linux/io.h      |    4 ++--
>  include/linux/vmalloc.h |    2 +-
>  lib/ioremap.c           |   10 +++++-----
>  4 files changed, 13 insertions(+), 14 deletions(-)
>=20
> Index: linux-2.6.34/arch/x86/mm/ioremap.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.34.orig/arch/x86/mm/ioremap.c
> +++ linux-2.6.34/arch/x86/mm/ioremap.c
> @@ -62,7 +62,8 @@ int ioremap_change_attr(unsigned long va
>  static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>  		unsigned long size, unsigned long prot_val, void *caller)
>  {
> -	unsigned long pfn, offset, vaddr;
> +	u64 pfn, last_pfn;
> +	unsigned long offset, vaddr;
>  	resource_size_t last_addr;
>  	const resource_size_t unaligned_phys_addr =3D phys_addr;
>  	const unsigned long unaligned_size =3D size;

Why do you use u64 and not resource_size_t for those? That way this would n=
ot=20
be needlessly big for "real" 32 bit platforms.

Eike

--nextPart5256271.Xt28rHopTh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwWjioACgkQXKSJPmm5/E4WxQCeIQVB08zbJZO2EI5dzzfqqwan
HBUAoJ0zuGwtdJmexBVRqxVPkA6NJ5qA
=WAgj
-----END PGP SIGNATURE-----

--nextPart5256271.Xt28rHopTh--
