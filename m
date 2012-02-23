Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab2BWUUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:20:33 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:43644 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756828Ab2BWUU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:20:29 -0500
Date: Thu, 23 Feb 2012 12:20:23 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/24] PCI: Add busn_res tracking in core
Message-ID: <20120223122023.4a196fff@jbarnes-desktop>
In-Reply-To: <CAE9FiQWBLpK-Tzmvf1dHeub4Yy2ziRBpnzYuEdBvdJASnbDqYw@mail.gmail.com>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
	<1328425088-6562-7-git-send-email-yinghai@kernel.org>
	<CAErSpo4cd2TR4207RUk53B+jDK_DONduo8pU8EWWOgdGeg7CeQ@mail.gmail.com>
	<CAE9FiQWBLpK-Tzmvf1dHeub4Yy2ziRBpnzYuEdBvdJASnbDqYw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d6OEr0w9Vs1nzEWkbL0/zfJ"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/d6OEr0w9Vs1nzEWkbL0/zfJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Feb 2012 09:26:52 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On Wed, Feb 8, 2012 at 8:08 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Sat, Feb 4, 2012 at 10:57 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> update pci_scan_root_bus, and pci_scan_bus to insert root bus busn into
> >> iobusn_resource tree.
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> ---
> >> =C2=A0drivers/pci/probe.c =C2=A0| =C2=A0 30 ++++++++++++++++++++++++++=
----
> >> =C2=A0drivers/pci/remove.c | =C2=A0 =C2=A01 +
> >> =C2=A0include/linux/pci.h =C2=A0| =C2=A0 =C2=A04 ++++
> >> =C2=A03 files changed, 31 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> >> index fabf9d0..cdd6e83 100644
> >> --- a/drivers/pci/probe.c
> >> +++ b/drivers/pci/probe.c
> >> @@ -1667,8 +1667,9 @@ void pci_bus_release_busn_res(struct pci_bus *b)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0res, ret ? "can not be" : "is");
> >> =C2=A0}
> >>
> >> -struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, i=
nt bus,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct pci_ops *ops=
, void *sysdata, struct list_head *resources)
> >> +struct pci_bus * __devinit pci_scan_root_bus_max(struct device *paren=
t, int bus,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int bus_max, struct=
 pci_ops *ops, void *sysdata,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct list_head *r=
esources)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pci_bus *b;
> >>
> >> @@ -1676,10 +1677,26 @@ struct pci_bus * __devinit pci_scan_root_bus(s=
truct device *parent, int bus,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!b)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> >>
> >> + =C2=A0 =C2=A0 =C2=A0 pci_bus_insert_busn_res(b, bus, bus_max);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0b->subordinate =3D pci_scan_child_bus(b);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0pci_bus_add_devices(b);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0return b;
> >> =C2=A0}
> >> +EXPORT_SYMBOL(pci_scan_root_bus_max);
> >> +
> >> +struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, i=
nt bus,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct pci_ops *ops=
, void *sysdata,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct list_head *r=
esources)
> >> +{
> >> + =C2=A0 =C2=A0 =C2=A0 struct pci_bus *b;
> >> +
> >> + =C2=A0 =C2=A0 =C2=A0 b =3D pci_scan_root_bus_max(parent, bus, 255, o=
ps, sysdata, resources);
> >> +
> >> + =C2=A0 =C2=A0 =C2=A0 if (b)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_bus_update_busn=
_res_end(b, b->subordinate);
> >> +
> >> + =C2=A0 =C2=A0 =C2=A0 return b;
> >> +}
> >> =C2=A0EXPORT_SYMBOL(pci_scan_root_bus);
> >>
> >> =C2=A0/* Deprecated; use pci_scan_root_bus() instead */
> >> @@ -1692,9 +1709,11 @@ struct pci_bus * __devinit pci_scan_bus_parente=
d(struct device *parent,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0pci_add_resource(&resources, &ioport_resour=
ce);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0pci_add_resource(&resources, &iomem_resourc=
e);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D pci_create_root_bus(parent, bus, ops,=
 sysdata, &resources);
> >> - =C2=A0 =C2=A0 =C2=A0 if (b)
> >> + =C2=A0 =C2=A0 =C2=A0 if (b) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_bus_insert_busn=
_res(b, bus, 255);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b->subordinate =
=3D pci_scan_child_bus(b);
> >> - =C2=A0 =C2=A0 =C2=A0 else
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_bus_update_busn=
_res_end(b, b->subordinate);
> >> + =C2=A0 =C2=A0 =C2=A0 } else
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pci_free_resour=
ce_list(&resources);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0return b;
> >> =C2=A0}
> >> @@ -1710,7 +1729,10 @@ struct pci_bus * __devinit pci_scan_bus(int bus=
, struct pci_ops *ops,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0pci_add_resource(&resources, &iomem_resourc=
e);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0b =3D pci_create_root_bus(NULL, bus, ops, s=
ysdata, &resources);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (b) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_bus_insert_busn=
_res(b, bus, 255);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b->subordinate =
=3D pci_scan_child_bus(b);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_bus_update_busn=
_res_end(b, b->subordinate);
> >> +
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pci_bus_add_dev=
ices(b);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pci_free_resour=
ce_list(&resources);
> >> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> >> index 82f8ae5..5b679d2 100644
> >> --- a/drivers/pci/remove.c
> >> +++ b/drivers/pci/remove.c
> >> @@ -68,6 +68,7 @@ void pci_remove_bus(struct pci_bus *pci_bus)
> >>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0down_write(&pci_bus_sem);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0list_del(&pci_bus->node);
> >> + =C2=A0 =C2=A0 =C2=A0 pci_bus_release_busn_res(pci_bus);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0up_write(&pci_bus_sem);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pci_bus->is_added)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> >> diff --git a/include/linux/pci.h b/include/linux/pci.h
> >> index 3da935c..d5b6786 100644
> >> --- a/include/linux/pci.h
> >> +++ b/include/linux/pci.h
> >> @@ -668,6 +668,10 @@ struct pci_bus *pci_create_root_bus(struct device=
 *parent, int bus,
> >> =C2=A0void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus=
max);
> >> =C2=A0void pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
> >> =C2=A0void pci_bus_release_busn_res(struct pci_bus *b);
> >> +struct pci_bus * __devinit pci_scan_root_bus_max(struct device *paren=
t, int bus,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0int busmax, struct pci_ops *ops,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0void *sysdata,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0struct list_head *resources);
> >> =C2=A0struct pci_bus * __devinit pci_scan_root_bus(struct device *pare=
nt, int bus,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 struct pci_ops *ops, void *sysdata,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 struct list_head *resources);
> >
> > Now we have both pci_bus_insert_busn_res() and
> > pci_scan_root_bus_max(). =C2=A0Why do we need both? =C2=A0I think it's =
too much
> > of a burden on architectures to expect them to understand both.
> >
> > Maybe some sample pseudo-code using both interfaces would help me
> > understand what you expect a typical architecture to do.
>=20
> We need to call pci_bus_insert_busn_res for root bus:
> 1. after that bus is allocated (...) : that busn_res is in the bus struct.
> 2. before pci_scan_child_bus

I agree with Bjorn; at the very least this has a really bad name.  How
are people supposed to know which function to call?  If it's just for
the primary scan at init, then it should be named as such.  But ideally
it would be inside the existing scan_root_bus...

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/d6OEr0w9Vs1nzEWkbL0/zfJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRp+HAAoJEIEoDkX4Qk9hY1kQAIV9PPIcReHWAdpVb4Y1zudg
LsPnX/Kb8sc89HbrOYz4FUXpYb4uUK/FTIBiY1AO2VmYSt6DcO79h3p+dUMENodV
3TDRAZK3Y2aClUCR+BA+fZV7WYmVSLiHob2+iXET6Qso7SfcSh0ZRfBBeOTyS2tG
2IAieGYy4SWxKGgqqBQRbNKwlyusdbHveiwwlUQnPzX6j/ZjseBkpRS7tuHXri26
pnIOQLWx7P41Quk+rK20oNeo+UxHwin08h8ErCPiA/Q62CCJo5RyzLxNrHgS6p79
TWqwy2iNhBHowoEF3xjjaYmug8PJqU0CRv2txWRZqXew2wNjDaKoy2r1GuDeX1e4
5+suQqt0hWbmTzNwCIs7QVks5guCs6hIKwcRRd0d/znubXit3Op+74Olc6NvTeQ6
x5RUW3gXWL7/dZdJ7q83csDZRXjPZOoMx1Hfw69GVeNGoxsXZx59/XsxjWLgqeE9
PKk3+rodqUQHjF2tkVbfVYF0G2AOlEv/dpoV/REL9d4tEjzQoa4iBVt/UlrF9wa9
zHxCX0BXXY/3LcK7+hvspGe8qDuE0X1f3oR1Kr9kGvbig94f5KRhHCPztVEV+gU6
/C6RMWrQOWZTKOJD5PezaYVfAfBb8PJca8u5oZB0KahRfEFqoN2fZPH7KLLNsid6
qL9Tdk9bkB/ZlwDAngcA
=20DN
-----END PGP SIGNATURE-----

--Sig_/d6OEr0w9Vs1nzEWkbL0/zfJ--
