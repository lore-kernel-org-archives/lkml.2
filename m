Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab2BWUZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:25:46 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:37999 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756839Ab2BWUZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:25:44 -0500
Date: Thu, 23 Feb 2012 12:25:36 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 09/24] PCI, powerpc: Register busn_res for root buses
Message-ID: <20120223122536.6a2a7a6b@jbarnes-desktop>
In-Reply-To: <1328823358.2903.77.camel@pasglop>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
	<1328425088-6562-10-git-send-email-yinghai@kernel.org>
	<CAErSpo6BwznWf3rq4J2Ao+rrgR4yWqQ0mQGygkd2KmBuA1OD8g@mail.gmail.com>
	<1328738567.2903.45.camel@pasglop>
	<CAErSpo7ekGn-+Mnyz7KL=fVFH3Ed19AeE3MKkZWJ4bd0Jo7kCw@mail.gmail.com>
	<1328823358.2903.77.camel@pasglop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EH_1rNzz=+bF6q7Uxt/U3oK"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/EH_1rNzz=+bF6q7Uxt/U3oK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Feb 2012 08:35:58 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Thu, 2012-02-09 at 11:24 -0800, Bjorn Helgaas wrote:
> > My point is that the interface between the arch and the PCI core
> > should be simply the arch telling the core "this is the range of bus
> > numbers you can use."  If the firmware doesn't give you the HW limits,
> > that's the arch's problem.  If you want to assume 0..255 are
> > available, again, that's the arch's decision.
> >=20
> > But the answer to the question "what bus numbers are available to me"
> > depends only on the host bridge HW configuration.  It does not depend
> > on what pci_scan_child_bus() found.  Therefore, I think we can come up
> > with a design where pci_bus_update_busn_res_end() is unnecessary.
>=20
> In an ideal world yes. In a world where there are reverse engineered
> platforms on which we aren't 100% sure how thing actually work under the
> hood and have the code just adapt on "what's there" (and try to fix it
> up -sometimes-), thinks can get a bit murky :-)
>=20
> But yes, I see your point. As for what is the "correct" setting that
> needs to be done so that the patch doesn't end up a regression for us,
> I'll have to dig into some ancient HW to dbl check a few things. I hope
> 0...255 will just work but I can't guarantee it.
>=20
> What I'll probably do is constraint the core to the values in
> hose->min/max, and update selected platforms to put 0..255 in there when
> I know for sure they can cope.

But I think the point is, can't we intiialize the busn resource after
the first & last bus numbers have been determined?  E.g. rather than
Yinghai's current:
+	pci_bus_insert_busn_res(bus, hose->first_busno, hose->last_busno);
+
 	/* Get probe mode and perform scan */
 	mode =3D PCI_PROBE_NORMAL;
 	if (node && ppc_md.pci_probe_mode)
@@ -1742,8 +1744,11 @@ void __devinit pcibios_scan_phb(struct pci_controlle=
r *hose)
 		of_scan_bus(node, bus);
 	}
=20
-	if (mode =3D=3D PCI_PROBE_NORMAL)
+	if (mode =3D=3D PCI_PROBE_NORMAL) {
+		pci_bus_update_busn_res_end(bus, 255);
 		hose->last_busno =3D bus->subordinate =3D pci_scan_child_bus(bus);
+		pci_bus_update_busn_res_end(bus, bus->subordinate);
+	}

we'd have something more like:

 	/* Get probe mode and perform scan */
 	mode =3D PCI_PROBE_NORMAL;
 	if (node && ppc_md.pci_probe_mode)
@@ -1742,8 +1744,11 @@ void __devinit pcibios_scan_phb(struct pci_controlle=
r *hose)
 		of_scan_bus(node, bus);
 	}
=20
	if (mode =3D=3D PCI_PROBE_NORMAL)
 		hose->last_busno =3D bus->subordinate =3D pci_scan_child_bus(bus);

+	pci_bus_insert_busn_res(bus, hose->first_busno, hose->last_busno);

since we should have the final bus range by then?  Setting the end to
255 and then changing it again doesn't make sense; and definitely makes
the code hard to follow.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/EH_1rNzz=+bF6q7Uxt/U3oK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRqDAAAoJEIEoDkX4Qk9hm+cP/065v5yKJo5X/EGRaPYMdxMZ
p0baPsakzhpnGlWdQRtG2uPe/fULxRxDwTyummq2WpdJGxmclwc3d5QFbzhjxnDC
6dGtqIlEOy6uaDkJOmZnMBsHF8MGF6IPk5XPPGckploJTmbzhSEPqXlh1rFjH85M
XyTrmAAq4zOxx+uIaVy7Ybk+hWDUfc0kAKXfjnWdBcNtLB+NCqOXpAHjQC5T90gi
pnQrdu3FL67HtDtSDNMYoD2bOP4lSBMRNvE91jW4x15nqX5XF4Kx/H6Zf38iJLqz
myowYRvG2nNOzRsqs1r6gLGnzPF/1+5GStzz+UqdAHMcwfYg6/yXpX3o312U+h5z
ududWD1jYi6+F/ZqFmmLMdT0SeEEmVgoIbucdFd+q2+xYqvx3QBVuoEaSNaM+eg3
t56RbLJbWrVQpEN6vrqQW5IPF5ddy0JrC6VuyYjMP0lhRF8OW3xnufvPvhTDFzie
OEgoTiBVEXKtNONIIvz7GXNxQORh83tE0gaE573UTFpHL77sSibrSxVKU6ojMVA3
5HlTXePke+Sy3aysw01OdivVVrSyph+JPUl4iR3Qx7rCPbU2dvNd33jLuXP3uKCg
7UoIa8sMM8dVST4o0SixLORAVGivpQ89G5WTePUDtb3kjxWaIFuowl5LbMWJfaNr
qU/DD5Oy07EY4ec2xlgr
=jCti
-----END PGP SIGNATURE-----

--Sig_/EH_1rNzz=+bF6q7Uxt/U3oK--
