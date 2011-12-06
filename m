Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1LFR0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:26:22 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:43589 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751846Ab1LFR0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:26:18 -0500
Date: Tue, 6 Dec 2011 09:28:56 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the pci tree
Message-ID: <20111206092856.61d759dd@jbarnes-desktop>
In-Reply-To: <CAErSpo6YrEZZjd=j6xoUfSvDHTT+-9g0zAb=ff2F1jA-0V9rHw@mail.gmail.com>
References: <20111206111852.6931fd03f0b1a86e318a29e3@canb.auug.org.au>
	<CAErSpo6YrEZZjd=j6xoUfSvDHTT+-9g0zAb=ff2F1jA-0V9rHw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/L16Zns18.C_g+H7ORtf0pij"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/L16Zns18.C_g+H7ORtf0pij
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 20:16:54 -0700
Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Mon, Dec 5, 2011 at 5:18 PM, Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> > Hi Jesse,
> >
> > After merging the pci tree, today's linux-next build
> > (powerpc_ppc64_defconfig) failed like this:
> >
> > arch/powerpc/kernel/pci_64.c: In function 'pcibios_map_io_space':
> > arch/powerpc/kernel/pci_64.c:201:2: error: implicit declaration of func=
tion 'pcibios_phb_map_phb_io_space' [-Werror=3Dimplicit-function-declaratio=
n]
> >
> > Caused by commit fb8fca4ff3f7 ("powerpc/PCI: split PHB part out of
> > pcibios_map_io_space()").
> >
> > arch/powerpc/kernel/pci-common.c: In function 'pcibios_scan_phb':
> > arch/powerpc/kernel/pci-common.c:1726:7: error: incompatible type for a=
rgument 5 of 'pci_create_root_bus'
> > include/linux/pci.h:665:17: note: expected 'struct list_head *' but arg=
ument is of type 'struct list_head'
> >
> > Caused by commit 3c73944e7ace ("powerpc/PCI: convert to
> > pci_create_root_bus()").
> >
> > I have used the pci tree from next-20111205 for today.
> > --
> > Cheers,
> > Stephen Rothwell =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sfr@canb.auug.o=
rg.au
> > http://www.canb.auug.org.au/~sfr/
>=20
> I fixed these; the updated patches are on
> git://github.com/bjorn-helgaas/linux.git on
> the "pci-scan-v4" branch (head f9da8b214fef1ac4072e4af2a663293ab965f796).
>=20
> Here's the incremental diff from v3 to v4 (hand-created and whitespace-da=
maged):
>=20
> diff --git a/c4677881a:arch/powerpc/kernel/pci_64.c
> b/f9da8b214:arch/powerpc/kernel/pci_64.c
> index 4401425..3318d39 100644
> --- a/c4677881a:arch/powerpc/kernel/pci_64.c
> +++ b/f9da8b214:arch/powerpc/kernel/pci_64.c
> @@ -197,7 +198,7 @@ int __devinit pcibios_map_io_space(struct pci_bus *bu=
s)
>                 return 0;
>         }
>=20
> -       return pcibios_phb_map_phb_io_space(pci_bus_to_host(bus));
> +       return pcibios_map_phb_io_space(pci_bus_to_host(bus));
>  }
>  EXPORT_SYMBOL_GPL(pcibios_map_io_space);
>=20
> diff --git a/c4677881a:arch/powerpc/kernel/pci-common.c
> b/f9da8b214:arch/powerpc/kernel/pci-common.c
> index 8c47c57..2aa707b 100644
> --- a/c4677881a:arch/powerpc/kernel/pci-common.c
> +++ b/f9da8b214:arch/powerpc/kernel/pci-common.c
> @@ -1711,7 +1712,7 @@ void __devinit pcibios_scan_phb(struct
> pci_controller *hose)
>=20
>         /* Create an empty bus for the toplevel */
>         bus =3D pci_create_root_bus(hose->parent, hose->first_busno,
> -                                 hose->ops, hose, resources);
> +                                 hose->ops, hose, &resources);
>         if (bus =3D=3D NULL) {
>                 pr_err("Failed to create bus for PCI domain %04x\n",
>                         hose->global_number);
>=20

I merged this fix into the original commit as a v2 patch, hope today's
linux-next builds.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/L16Zns18.C_g+H7ORtf0pij
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO3lDYAAoJEIEoDkX4Qk9h5hMQALG1cRoRLjOyT98DzuoYZZ0I
bhguISCd8IjyKWh6pq2mD75JLDt0y1OkgYIqEdWgM17mCyNzDzQr052GQU3xUSpF
qK4KAg0k2zyt/eUW+30gkWiCO6nYz3xcD7ozqFZ/z7LtcDRaFbrjT7wTbK2bCuAo
yAUJ7V4aQOkz3HDDsEgmqFMTthD3r/kNM0Q/4sjQ2emNZt4zSv82+m7Hu+FFGUfe
fxTvuLP0zrhbA6MhI5VGnELPtWdbx9snjz7eV71dH61HS+fz4TQZGYF5H5n0JHFB
uZpZS8ddB/+JMpGeC+LNyYkrnB0Kgvxl/GEhV9swd0Ah9TmLbo8PZezk/aQGN63A
09fVlWpdhnK6CuzV102+NTGGlQei4ZDsKoMoPMj+6irWB4GOXvsD4i/IWJ6tN2u/
TRK+X7ptdCv1gKRgeRZ10/0JypSP5BiNYTMvQLHOqLQGYYq+1857AetB9LVDKj53
alMwmFKbBfVxgs1IhN5I447MrZtdp+JyBEZk88ePJpPpePvuNN0p3yITxmSchA8E
ENpWhPPbzvhL8ykaQihUOQgbutVT8CBMvHrPoFBQnLeM4ens7RhI0RB58S3m68YB
L432EiDA2Xqq8YJF5+YNrOH1kxl1vnprpqStYugAVUWmcCEChzwS5gwjoRJEm4WB
9UsnpSDC/f1qRho13ewk
=3eLt
-----END PGP SIGNATURE-----

--Sig_/L16Zns18.C_g+H7ORtf0pij--
