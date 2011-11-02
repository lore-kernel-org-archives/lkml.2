Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1KBVOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:14:17 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:38207 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751461Ab1KBVOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:14:15 -0400
Date: Wed, 2 Nov 2011 14:14:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Zhu, DengCheng" <dczhu@mips.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulus@samba.org" <paulus@samba.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "Barzilay, Eyal" <eyal@mips.com>, "Fortuna, Zenon" <zenon@mips.com>,
        "dengcheng.zhu@gmail.com" <dengcheng.zhu@gmail.com>
Subject: Re: [RESEND PATCH v3 0/2] Pass resources to pci_create_bus() and
 fix MIPS PCI resources
Message-ID: <20111102141410.4d44a4eb@jbarnes-desktop>
In-Reply-To: <CAErSpo5rU8aa=-joApUTYbsQrbrRz9x-7VA3V3H9gDg7k7nj+w@mail.gmail.com>
References: <1314845309-3277-1-git-send-email-dczhu@mips.com>
	<CAErSpo5py82G1=6BOTG4RSAj6_SRzN4fng6sECU2sS+u9quixw@mail.gmail.com>
	<CAErSpo5HNKi7NSKBbyL3o39Ow+Xkncyccrj5PQNaoeMdLHJsFQ@mail.gmail.com>
	<BD04AF0D5BE72443A0B69C1C0486AD3ECE8D8973@exchdb03.mips.com>
	<1318319295.29415.452.camel@pasglop>
	<CAErSpo5rU8aa=-joApUTYbsQrbrRz9x-7VA3V3H9gDg7k7nj+w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IPN3op2zGUlE=tSFZ7HMhhw"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IPN3op2zGUlE=tSFZ7HMhhw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Oct 2011 10:15:34 -0600
Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Tue, Oct 11, 2011 at 1:48 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>=20
> > I must admit I don't completely understand what this patch is about,
> > other than it will most probably break the way we do resource management
> > on powerpc :-)
> >
> > I don't understand the point about conflicts in scan_slot and I don't
> > see what you win by "settling down early". Also keep in mind that the
> > resources read from the device need to be remapped on some archs like
> > powerpc which we do from a header quirk at the moment.
>=20
> These patches only deal with root bus resources, i.e., the
> non-architected PCI host bridge windows.  They don't have anything to
> do with normal PCI BARs.
>=20
> MIPS sets up root buses differently than powerpc, so it has a problem
> that powerpc doesn't have.  Here's the original MIPS flow (before this
> series):
>=20
>               pci_scan_bus
>                 pci_scan_bus_parented
>                   pci_create_bus        <-- A create root bus
>                   pci_scan_child_bus
>                     pci_scan_slot
>                       pci_scan_single_device
>                         pci_scan_device
>                           pci_setup_device
>                             pci_fixup_device (pci_fixup_early)  <-- B
>                         pci_device_add
>                           pci_fixup_device (pci_fixup_header)   <-- C
>                     pcibios_fixup_bus   <-- D fill in root bus resources
>=20
> At point A, we allocate a struct pci_bus for the root bus.
> pci_create_bus() fills in defaults for the resources available on that
> bus: ioport_resource and iomem_resource, which cover all possible
> address space.  Later at point D, we replace those defaults with the
> correct resources (hose->io_resource and hose->mem_resource in this
> MIPS case).
>=20
> The problem is that the root bus resources are wrong during the
> interval between A and D.  Anything that looks at them may break.  In
> the case Deng-Cheng found, the quirk_piix4_acpi() fixup at point C
> claimed a region, which incorrectly became the child of
> ioport_resource instead of host->io_resource.
>=20
> Deng-Cheng's patches close this window by basically combining the
> fixup at D with the root bus creation at A.
>=20
> Powerpc doesn't have the same problem because it calls
> pci_create_bus() directly so it can fix the root bus resources with
> pcibios_setup_phb_resources() *before* it scans the bus.
>=20
> Even though powerpc and many other architectures don't have the MIPS
> problem, I think it's worth changing the code because the existing
> pattern is poor.  In almost all cases, we know what the host bridge
> apertures are before we create the root bus.  It's error-prone to have
> pci_create_bus() fill in default resources, then rely on the
> architecture to fix that up later.  I think it's better to supply the
> resources up front.

Ben, with the above explained are you ok with this change?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/IPN3op2zGUlE=tSFZ7HMhhw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsbKiAAoJEIEoDkX4Qk9hLVMP/A/Hcx7QVf6fNazf/DMx4cTi
XSvCvHTTk0HVrGEzHN74ckwsZH1cuSgimrEFmTGPxuD4DWICJPGuXw7RtbJNWrTz
9FRh/xqJPaU2F4idipDb7abg7v8PqWJjhNg8U9dmz6PRX/rgToBFZ+fsyCJ9FXug
hmBkS8xI/9DQ5l1QVxLPJbjlYnJ58AjhAYmseEY1hGsw0s5x+6yAyFEtND8G0/A6
T2hYCXT8qwtcKNGCerPjS2nzYEmRFuOe32nxImAft1Y+xzE04FDA7T0NyV8pjw/t
8V9rI4815pIxItAI/dVLK6Tv8aal8qbjO0XNLF2FBtCNA665i0hiYGM8wIkEKdVR
ZoQPlFTZeSfUHB9zVnRMLy+LxrtiCl336ZSuQvmnqdcE1ds/PUAtNkDhb3h4lYR4
c8lH2XTeMneXyFSCIRA9gGieoNXUsy/78MvB0vZ6LQg2Nu2zZRmvPpeaJRyY8ioB
dTtAD3XuWckA/u4Q+Vy2tgx1aeWa7Iy05HXQvp+W77C65RFONde9kVaIpIK/kxTq
rncQsTKv7RPmgRX1zsYsL+If0mq4hwOq+pFsRbOSXARM/x7BpO49DyALV87rUt0g
ye4t9Ib5La5RTYIIsfDlmuJsaJfbnKkpI3oKIuSvvL7XjyjOW4y4wI5fToIS+YC/
iqFutzhEiNjyAmL3FkiZ
=GdAt
-----END PGP SIGNATURE-----

--Sig_/IPN3op2zGUlE=tSFZ7HMhhw--
