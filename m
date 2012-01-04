Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2ADRft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:35:49 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:55605 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754169Ab2ADRfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:35:46 -0500
Date: Wed, 4 Jan 2012 09:35:42 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Hao, Xudong" <xudong.hao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: Re: [PATCH] PCI: Enable ATS at the device state restore
Message-ID: <20120104093542.1f498a30@jbarnes-desktop>
In-Reply-To: <BC00F5384FCFC9499AF06F92E8B78A9E28904877DA@shsmsx502.ccr.corp.intel.com>
References: <BC00F5384FCFC9499AF06F92E8B78A9E28904877DA@shsmsx502.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ob6Cp_FqKLZr5XsK/26gkW5"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ob6Cp_FqKLZr5XsK/26gkW5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

No looks fine, just applied to my linux-next branch.  Thanks.

Jesse

On Tue, 20 Dec 2011 18:15:42 +0800
"Hao, Xudong" <xudong.hao@intel.com> wrote:

> Hi, Jesse
> Do you have any comments for this fix patch?
>=20
> Thanks,
> -Xudong
>=20
> > -----Original Message-----
> > From: Hao, Xudong
> > Sent: Saturday, December 17, 2011 9:25 PM
> > To: 'jbarnes@virtuousgeek.org'; 'linux-pci@vger.kernel.org'
> > Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Zhang, Xiantao
> > Subject: [PATCH] PCI: Enable ATS at the device state restore
> >=20
> > When system go to S3 or S4 sleep and then return, some register of PCI =
device
> > does not be restored correctly, such as ATS capability. The same problem
> > happen on pci reset function.
> >=20
> > This patch enables ATS at the device state restore if PCI device has ATS
> > capability.
> >=20
> > Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> > Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
> > ---
> >  drivers/pci/ats.c |   17 +++++++++++++++++
> >  drivers/pci/pci.c |    1 +
> >  drivers/pci/pci.h |    8 ++++++++
> >  3 files changed, 26 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c index 7ec56fb..a6c2b=
35 100644
> > --- a/drivers/pci/ats.c
> > +++ b/drivers/pci/ats.c
> > @@ -127,6 +127,23 @@ void pci_disable_ats(struct pci_dev *dev)  }
> > EXPORT_SYMBOL_GPL(pci_disable_ats);
> >=20
> > +void pci_restore_ats_state(struct pci_dev *dev) {
> > +	u16 ctrl;
> > +
> > +	if (!pci_ats_enabled(dev))
> > +		return;
> > +	if (!pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ATS))
> > +		BUG();
> > +
> > +	ctrl =3D PCI_ATS_CTRL_ENABLE;
> > +	if (!dev->is_virtfn)
> > +		ctrl |=3D PCI_ATS_CTRL_STU(dev->ats->stu - PCI_ATS_MIN_STU);
> > +
> > +	pci_write_config_word(dev, dev->ats->pos + PCI_ATS_CTRL, ctrl); }
> > +EXPORT_SYMBOL_GPL(pci_restore_ats_state);
> > +
> >  /**
> >   * pci_ats_queue_depth - query the ATS Invalidate Queue Depth
> >   * @dev: the PCI device
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c index 6f45a73..6dafc=
1d 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -956,6 +956,7 @@ void pci_restore_state(struct pci_dev *dev)
> >=20
> >  	/* PCI Express register must be restored first */
> >  	pci_restore_pcie_state(dev);
> > +	pci_restore_ats_state(dev);
> >=20
> >  	/*
> >  	 * The Base Address register should be programmed before the command
> > diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h index b74084e..a4f31=
40 100644
> > --- a/drivers/pci/pci.h
> > +++ b/drivers/pci/pci.h
> > @@ -249,6 +249,14 @@ struct pci_sriov {
> >  	u8 __iomem *mstate;	/* VF Migration State Array */
> >  };
> >=20
> > +#ifdef CONFIG_PCI_ATS
> > +extern void pci_restore_ats_state(struct pci_dev *dev); #else static
> > +inline void pci_restore_ats_state(struct pci_dev *dev) { } #endif /*
> > +CONFIG_PCI_ATS */
> > +
> >  #ifdef CONFIG_PCI_IOV
> >  extern int pci_iov_init(struct pci_dev *dev);  extern void
> > pci_iov_release(struct pci_dev *dev);
>=20



--Sig_/Ob6Cp_FqKLZr5XsK/26gkW5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPBI3uAAoJEIEoDkX4Qk9hDLYP/3KOUwPXVKMIWwdZNJPMX/F3
gmC8O20AHC0YQzhF5IFPe5bjLx48H0PHAzReKsTeXjbDN4Uo8kytNiOwsHVrlVBf
86X5l/HZ+N8PutbRudsjIk9GBabRVKFlwjKKD9MuOGpfYwOkQqtmxEem69AUxdrL
a6CIliOhZFGzYfbuazMhuHbl0UkeINpDVjhzq9Ed/qz2C3Rovupo9YqNbbcfJHmD
JTHe4A/xMCQpoL9n8KkB3Fau3Xa52tKKligVdJ3JH/1MXXvjfNuYkjqBcVvuLVPZ
FeN7fp3YLRF3O6t7/sG6nAzroFUzmAZBKTG7521CYfm6KOtx+aJttA+taVo7I0oO
sShJ+w0X8UYYNNRSrQ+NC5sGBZuWgDsgZae9GwnSwkTtADskUhW7cjdLcrqTzh1u
6EbKwOgBsZOhdePkXtp5Kh120joWrrZHLfryKn3FtZ9pyzxmtJQj3MV65rxGjhtV
UDhH6nHk4OYSJMMhEwxaIpWH6/cWqAxTMlIGkXcUoc8xPxW84CWi5p+0au1LIN1A
c25/tNOChr7FeyzpkRWhAmh0q9WjtnixFrQJBDRzYUyU6d7Hm2bQZ5MuemAc1fnS
MOvMR65U5dal+GpeETfNCh096ROt2J/OLdxWifu3izPi7PadaJCQ1tHqKR4L/IcL
v5+VwAXU87WOHUHjYmuw
=1sL7
-----END PGP SIGNATURE-----

--Sig_/Ob6Cp_FqKLZr5XsK/26gkW5--
