Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab2BXWYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:24:41 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:56266 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756478Ab2BXWYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:24:37 -0500
Date: Fri, 24 Feb 2012 14:24:30 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yinghai Lu <yinghai@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 09/24] PCI, powerpc: Register busn_res for root buses
Message-ID: <20120224142430.58f5e5ef@jbarnes-desktop>
In-Reply-To: <CAErSpo7_WGjitDZz4XH+77f65Uz1ynd5_USN+D17D09Eux1iQQ@mail.gmail.com>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
	<1328425088-6562-10-git-send-email-yinghai@kernel.org>
	<CAErSpo6BwznWf3rq4J2Ao+rrgR4yWqQ0mQGygkd2KmBuA1OD8g@mail.gmail.com>
	<1328738567.2903.45.camel@pasglop>
	<CAErSpo7ekGn-+Mnyz7KL=fVFH3Ed19AeE3MKkZWJ4bd0Jo7kCw@mail.gmail.com>
	<1328823358.2903.77.camel@pasglop>
	<20120223122536.6a2a7a6b@jbarnes-desktop>
	<CAErSpo7_WGjitDZz4XH+77f65Uz1ynd5_USN+D17D09Eux1iQQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_oYi=Ku5vodv6+RAGbh9W1f"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_oYi=Ku5vodv6+RAGbh9W1f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Feb 2012 12:51:30 -0800
Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Thu, Feb 23, 2012 at 12:25 PM, Jesse Barnes <jbarnes@virtuousgeek.org>=
 wrote:
> > On Fri, 10 Feb 2012 08:35:58 +1100
> > Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> >
> >> On Thu, 2012-02-09 at 11:24 -0800, Bjorn Helgaas wrote:
> >> > My point is that the interface between the arch and the PCI core
> >> > should be simply the arch telling the core "this is the range of bus
> >> > numbers you can use." =C2=A0If the firmware doesn't give you the HW =
limits,
> >> > that's the arch's problem. =C2=A0If you want to assume 0..255 are
> >> > available, again, that's the arch's decision.
> >> >
> >> > But the answer to the question "what bus numbers are available to me"
> >> > depends only on the host bridge HW configuration. =C2=A0It does not =
depend
> >> > on what pci_scan_child_bus() found. =C2=A0Therefore, I think we can =
come up
> >> > with a design where pci_bus_update_busn_res_end() is unnecessary.
> >>
> >> In an ideal world yes. In a world where there are reverse engineered
> >> platforms on which we aren't 100% sure how thing actually work under t=
he
> >> hood and have the code just adapt on "what's there" (and try to fix it
> >> up -sometimes-), thinks can get a bit murky :-)
> >>
> >> But yes, I see your point. As for what is the "correct" setting that
> >> needs to be done so that the patch doesn't end up a regression for us,
> >> I'll have to dig into some ancient HW to dbl check a few things. I hope
> >> 0...255 will just work but I can't guarantee it.
> >>
> >> What I'll probably do is constraint the core to the values in
> >> hose->min/max, and update selected platforms to put 0..255 in there wh=
en
> >> I know for sure they can cope.
> >
> > But I think the point is, can't we intiialize the busn resource after
> > the first & last bus numbers have been determined? =C2=A0E.g. rather th=
an
> > Yinghai's current:
> > + =C2=A0 =C2=A0 =C2=A0 pci_bus_insert_busn_res(bus, hose->first_busno, =
hose->last_busno);
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Get probe mode and perform scan */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0mode =3D PCI_PROBE_NORMAL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (node && ppc_md.pci_probe_mode)
> > @@ -1742,8 +1744,11 @@ void __devinit pcibios_scan_phb(struct pci_contr=
oller *hose)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0of_scan_bus(node=
, bus);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 if (mode =3D=3D PCI_PROBE_NORMAL)
> > + =C2=A0 =C2=A0 =C2=A0 if (mode =3D=3D PCI_PROBE_NORMAL) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_bus_update_busn_=
res_end(bus, 255);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0hose->last_busno=
 =3D bus->subordinate =3D pci_scan_child_bus(bus);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_bus_update_busn_=
res_end(bus, bus->subordinate);
> > + =C2=A0 =C2=A0 =C2=A0 }
> >
> > we'd have something more like:
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Get probe mode and perform scan */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0mode =3D PCI_PROBE_NORMAL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (node && ppc_md.pci_probe_mode)
> > @@ -1742,8 +1744,11 @@ void __devinit pcibios_scan_phb(struct pci_contr=
oller *hose)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0of_scan_bus(node=
, bus);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mode =3D=3D PCI_PROBE_NORMAL)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0hose->last_busno=
 =3D bus->subordinate =3D pci_scan_child_bus(bus);
> >
> > + =C2=A0 =C2=A0 =C2=A0 pci_bus_insert_busn_res(bus, hose->first_busno, =
hose->last_busno);
> >
> > since we should have the final bus range by then? =C2=A0Setting the end=
 to
> > 255 and then changing it again doesn't make sense; and definitely makes
> > the code hard to follow.
>=20
> I have two issues here:
>=20
> 1) hose->last_busno is currently the highest bus number found by
> pci_scan_child_bus().  If I understand correctly,
> pci_bus_insert_busn_res() is supposed to update the core's idea of the
> host bridge's bus number aperture.  (Actually, I guess it just updates
> the *end* of the aperture, since we supply the start directly to
> pci_scan_root_bus()).  The aperture and the highest bus number we
> found are not related, except that we should have:
>=20
>     hose->first_busno <=3D bus->subordinate <=3D hose->last_busno
>=20
> If we set the aperture to [first_busno - last_busno], we artificially
> prevent some hotplug.

Oh true, we'll need to allocate any extra bus number space somehow so
that hot plug of bridges is possible in the future w/o renumbering
(until our glorious future when we can move resources on the fly by
stopping drivers).

>=20
> 2) We already have a way to add resources to a root bus: the
> pci_add_resource() used to add I/O port and MMIO apertures.  I think
> it'd be a lot simpler to just use that same interface for the bus
> number aperture, e.g.,
>=20
>     pci_add_resource(&resources, hose->io_space);
>     pci_add_resource(&resources, hose->mem_space);
>     pci_add_resource(&resources, hose->busnr_space);
>     bus =3D pci_scan_root_bus(dev, next_busno, pci_ops, sysdata, &resourc=
es);
>=20
> This is actually a bit redundant, since "next_busno" should be the
> same as hose->busnr_space->start.  So if we adopted this approach, we
> might want to eventually drop the "next_busno" argument.

Yeah that would be nice, the call would certainly make more sense that
way.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/_oYi=Ku5vodv6+RAGbh9W1f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPSA4eAAoJEIEoDkX4Qk9hA+8QAMJy+pML3aLyytzosLwa7yaA
1dYdTLyIFb62aORfMR5EUmhX8ZAO92aDRgF6ntbOY31hjdsWwCCeOoVRlSmWq5RO
IovEI0c9sjbZ5xFtVc4qsZdiHi/0jfacCeVKewbFEsknL8wUtOnFmQuuF7wfvNKf
sQilT9KVk5z/sX4XRiIVnvktJ+WNdW3bbmbD0/iTqsWBpIzToU6XKAcuP3XgmdsX
jvZxNDlznXQ4x4wa3Oj8LDEZuJGLG04y5tcezR1CsOGHzPzLu5bXL3QPY4vQA6Yj
j9+/pHxOk+N9rb6hdKfWF2Xb8AQ8Rz9TB4wgnPepFKYyRYoUqUZV2iUDAuKcVuuE
E0297INBinVGCufC4IeYvbzNlvigILTypIr0WhCtecD4213o2RI/t7OCKyLjqQaq
Quuq86+8p+/DmDf6em+afuIzEnT6vapsu6FbnN+U6lgr6mwfCvZNaCk7xY8VQ7VJ
IikmSk4CB9+RPsurByIbBprfqPdKskVm1koVOC6P3LGAF/shJFAMmADF15SkJiLQ
ZBydoaw23CbC7IsczEPO6QZIkP7NBOrkrmLTZld0NqMOVGb9R9EWcf3RPFpKJulv
Kt1jQ3jjS4c/lgNbzUkXQI0ikTAfee7Qtpd42ZDLG+Gv2o5oZHiS7/U4/FkhKTX6
8tY5XsHPqsPHuPcSyD5x
=tt6K
-----END PGP SIGNATURE-----

--Sig_/_oYi=Ku5vodv6+RAGbh9W1f--
