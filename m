Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab2BJTy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:54:57 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:44966 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754167Ab2BJTyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:54:55 -0500
Date: Fri, 10 Feb 2012 11:54:52 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: svaidy@linux.vnet.ibm.com
Cc: Ram Pai <linuxram@us.ibm.com>, Yinghai Lu <yinghai.lu@oracle.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH] pci: check for 4k resource_size alignment in
 sriov_init
Message-ID: <20120210115452.4bfefa05@jbarnes-desktop>
In-Reply-To: <20120201130206.GD3510@dirshya.in.ibm.com>
References: <20120127191032.GA22999@dirshya.in.ibm.com>
	<20120130031845.GA2359@ram-ThinkPad-T61>
	<20120131174402.GA6172@dirshya.in.ibm.com>
	<20120201062145.GA11505@ram-ThinkPad-T61>
	<20120201130206.GD3510@dirshya.in.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Os6L+TyjwXI/a1glasdhALD"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Os6L+TyjwXI/a1glasdhALD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Feb 2012 18:32:06 +0530
Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> * Ram Pai <linuxram@us.ibm.com> [2012-02-01 14:21:45]:
>=20
> > On Tue, Jan 31, 2012 at 11:14:02PM +0530, Vaidyanathan Srinivasan wrote:
> > > * Ram Pai <linuxram@us.ibm.com> [2012-01-30 11:18:45]:
> > >=20
> > > > On Sat, Jan 28, 2012 at 12:40:32AM +0530, Vaidyanathan Srinivasan w=
rote:
> > > > > Hi Ram and Jesse,
> > > > >=20
> > > > > I found a trivial issue with page size alignment check on IBM POW=
ER
> > > > > box with 64k base page size.  In sriov_init(), changing the check=
 from
> > > > > PAGE_SIZE (arch and config dependent) to HW_PAGE_SIZE (always 4k)=
 was
> > > > > required to use one of the sriov adapter as PF since the
> > > > > resource_size() comes up as 0x8000 and PAGE_SIZE would be 0x10000=
 for
> > > > > pseries boxes.
> > > > >=20
> > > > > I think resource_size() could be less than SystemPageSize, but I =
would
> > > > > like your comments/ack/nack on any consequences of checking for o=
nly
> > > > > 4k alignment here in a system with larger base page size.
> > > >=20
> > > > As per the SRIOV specs, the  resource has to be System page size al=
igned.
> > > >=20
> > > > PFs are required to support 4-KB, 8-KB, 64-KB, 256-KB, 1-MB, and 4-=
MB
> > > > page sizes. In your case if your adapter's PF is not supporting 64K=
 page size
> > > > then I think it is not conforming to the PCI SRIOV spec.
> > >=20
> > > Hi Ram,
> > >=20
> > > Thanks for the pointer.  I did some more experiments and found that
> > > the card does support 64k page size, but the PCI_SRIOV_SYS_PGSIZE was
> > > set to default 4k when we do the query and check resource_size().
> > >=20
> > > You were correct, the resource_size() has to come up with 64k on 64k
> > > PAGE_SIZE system.  We should not change that check.  I was able to
> > > get a working solution by setting PCI_SRIOV_SYS_PGSIZE to 64k before
> > > we do the query.
> > >=20
> > > This was the case in the original code before you moved these to
> > > sriov_enable().  If it is ok to leave the SYS_PGSIZE setting in
> > > sriov_init(), then I have the following fix that works for me.
> > >=20
> > > Please review and let me know your comments.
> > >=20
> > > Thanks,
> > > Vaidy
> > > ---
> > >=20
> > >     	pci: set pci sriov page size before reading sriov bar
> > >    =20
> > >     	For an SRIOV device, PCI_SRIOV_SYS_PGSIZE should be set before
> > >     	the PCI_SRIOV_BAR is queried.  The sys pagesize defaults to 4k,
> > >     	so this change is required on powerpc box with 64k base page siz=
e.
> > >    =20
> > >     	This is a regression caused due to moving SRIOV init to sriov_en=
able().
> > >    =20
> > >     	| commit afd24ece5c76af87f6fc477f2747b83a764f161c
> > >     	| Author: Ram Pai <linuxram@us.ibm.com>
> > >    =20
> > >     	| PCI: delay configuration of SRIOV capability
> > >     	| The SRIOV capability, namely page size and total_vfs of a devi=
ce are
> > >     	| configured during enumeration phase of the device.  This can p=
otentially
> > >     	| interfere with the PCI operations of the platform, if the IOV =
capability
> > >     	| of the device is not enabled.
> > >    =20
> > >     Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> > >=20
> > > diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> > > index 0321fa3..0dab5ec 100644
> > > --- a/drivers/pci/iov.c
> > > +++ b/drivers/pci/iov.c
> > > @@ -347,8 +347,6 @@ static int sriov_enable(struct pci_dev *dev, int =
nr_virtfn)
> > >  			return rc;
> > >  	}
> > >=20
> > > -	pci_write_config_dword(dev, iov->pos + PCI_SRIOV_SYS_PGSIZE, iov->p=
gsz);
> > > -
> > >  	iov->ctrl |=3D PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
> > >  	pci_cfg_access_lock(dev);
> > >  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
> > > @@ -466,6 +464,7 @@ found:
> > >  		return -EIO;
> > >=20
> > >  	pgsz &=3D ~(pgsz - 1);
> > > +	pci_write_config_dword(dev, pos + PCI_SRIOV_SYS_PGSIZE, pgsz);
> > >=20
> > >  	nres =3D 0;
> > >  	for (i =3D 0; i < PCI_SRIOV_NUM_BARS; i++) {
> >=20
> >=20
> > ACK. I think it is better to revert  afd24ece5c76af87f6fc477f2747b83a76=
4f161c.
>=20
> Hi Ram,
>=20
> Thanks for the ack.  But afd24ece5c76af87f6fc477f2747b83a764f161c has
> one more change of moving=20
> pci_write_config_word(dev, pos + PCI_SRIOV_NUM_VF, total) to sriov_enable=
().
>=20
> This change is required so that we set the PCI_SRIOV_NUM_VF only
> during sriov_enable.
>=20
> So we should not revert the entire commit, we can just add this change.

So which is it Ram, the ack or the revert? :)

Having the right page size early seems like the right solution...

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/Os6L+TyjwXI/a1glasdhALD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNXYMAAoJEIEoDkX4Qk9hR0MP/AnZ2E8YOhHVrpZ8fUSqo2PR
v4XpHTW/mX400xlQw4brFcqGHt/Mjyjx46OKZ3hE9RyGNIWO+jSa7+1GqhEzyqGC
MzBHTApJ7wOqQGYUUchLRLuv7NepTvnE9Gol1SwusSldwFIe8fhQd25VRZUzBPcP
eroNXpY9dKQjJsjRV/hZr+wilJDcxhlNCojrZjTk1l0RDtGKoWydIJXVsKuPM2UL
kjLKcz9mqPxGT1RjUsGn9RYZNJEyDeSCh0LuGdG3enNq41t8WKXFrMCiEsWHVlS7
tn2Wz3gEkgi09FxYCAR8YdRqLFJ80zMude+zJMMGhpSTMbZBcOlVfOLB6fRfIV8i
at6KApKnYumCum3exKvqfEe3hQ9qwue5WnP33zKv46IQYDgX/SwnsI6+tfLm6rVN
Wj2m4L2uFmRWbVdr73AGNTmkaGaIzO2lWmcgn59BrIaWP2E67dmHX0V7BsAN514t
D86RRBkCv6WRUCiuFk0vWmQ4j0PmgyKLCPVCbvg+s+HnN2AqNU7iiPPPHuolxXB6
XxPBc4Nhzo3Pa3ig85KYjVL2mCTkTmdElxpeNwsOhuEHQzln/Hhzhn1n90M7izN4
YACKblxeUfgdu60n4zp5gYkz9s7+H8zQVyE9P+kk3Dz1a8UrnrMPhGNDiLjQ41UP
EnMLjXJE/8fg9P7ARXB+
=LCxn
-----END PGP SIGNATURE-----

--Sig_/Os6L+TyjwXI/a1glasdhALD--
