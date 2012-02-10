Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140Ab2BJXvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:51:54 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:35190 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753709Ab2BJXvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 18:51:52 -0500
Date: Fri, 10 Feb 2012 15:51:45 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PCI / PM: Disable wakeup during shutdown for devices
 not enabled to wake up
Message-ID: <20120210155145.74aafa88@jbarnes-desktop>
In-Reply-To: <201202102340.29644.rjw@sisk.pl>
References: <201202070050.35931.rjw@sisk.pl>
	<20120210123407.7087d6a4@jbarnes-desktop>
	<201202102340.29644.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j+A.+vQ7juseHx1+48YA8dR"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/j+A.+vQ7juseHx1+48YA8dR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Feb 2012 23:40:29 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Friday, February 10, 2012, Jesse Barnes wrote:
> > On Tue, 7 Feb 2012 00:50:35 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >=20
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >=20
> > > If a PCI device is enabled to generate wakeup signals (PME) when put
> > > into a low-power state by runtime PM, it will be still enabled to
> > > generate those signals after the system shutdown, unless its driver's
> > > .shutdown() callback takes care of the wakeup signals generation
> > > setting.  Moreover, there are devices that are not enabled to wake
> > > up the system and that are configured by runtime PM to generate
> > > wakeup signals so that (runtime) remote wakeup works with them.
> > > Those devices should be reconfigured during system shutdown so that
> > > they don't generate wakeup signals, but at least some drivers don't
> > > do that.  However, that very well may be done by the PCI core so
> > > that drivers don't have to worry about it.  For this reason, modify
> > > pci_device_shutdown() to disable the generation of wakeup events for
> > > devices not supposed to wake up the system.
> > >=20
> > > References: https://bugzilla.kernel.org/show_bug.cgi?id=3D37952
> > > Reported-and-tested-by: Kamil Iskra <kamil.54002@iskra.name>
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > ---
> > >  drivers/pci/pci-driver.c |   10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >=20
> > > Index: linux/drivers/pci/pci-driver.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- linux.orig/drivers/pci/pci-driver.c
> > > +++ linux/drivers/pci/pci-driver.c
> > > @@ -430,6 +430,16 @@ static void pci_device_shutdown(struct d
> > >  		drv->shutdown(pci_dev);
> > >  	pci_msi_shutdown(pci_dev);
> > >  	pci_msix_shutdown(pci_dev);
> > > +
> > > +	/*
> > > +	 * Devices may be enabled to wake up by runtime PM, but they need n=
ot
> > > +	 * be supposed to wake up the system from its "power off" state (e.=
g.
> > > +	 * ACPI S5).  Therefore disable wakeup for all devices that aren't
> > > +	 * supposed to wake up the system at this point.  The state argument
> > > +	 * will be ignored by pci_enable_wake().
> > > +	 */
> > > +	if (!device_may_wakeup(dev))
> > > +		pci_enable_wake(pci_dev, PCI_UNKNOWN, false);
> > >  }
> > > =20
> > >  #ifdef CONFIG_PM
> > >=20
> >=20
> > So where do we end up setting the right wakeup state for devices we
> > actually *do* want to wake the system from S5?  Presumably later in the
> > shutdown sequence?
>=20
> Yes, in general.  However, device_may_wakeup(dev) has to return true for =
those
> devices, so they aren't affected by this change.

Ok thanks Rafael, applied.  Now to do a little testing...

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/j+A.+vQ7juseHx1+48YA8dR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNa2RAAoJEIEoDkX4Qk9h3DUP+gPi3lXHOGiAp0R0H0aTJY5v
YMNqzcV11cdw1D5q03NtrQmIdAw8QIB7BBoy6pY2n9AsTB4VCbHn1Y1R1H2JJur+
2eKnTASdAe5wbJSQ+LB30Y6zeU8yl6MeX2em58L7sZjnZCVkda5VmdTeQeMRs6oi
EXQuOrs1pAs2UoXtrBs7W/H0eJMBkLP7PjnciNI9waaoiXA4VMy6p/0AcBzCdcK5
EV7EhL/s1BjFq1GkA0Z7owHRhTyXXpyLdDGpDFNaHImB26gyq2GSPjSKgYdOqW+S
KmteEG3vSQQgnGgdlGGtN1zulCXrP4h19uxP1cSGzexiH2+QeLF3ccaGgOftD0Vv
s2MPQa1OeKnt8Adu9fz3QqYI33J3dLMPigwViEv05N7hDhYVC5txUnVno/a3joHd
UdmxDDxrjBaQEYyzzfYVMFSV2KPeSseFfYwh2REylR/5NXeFglxxYI7tJ/eB5swV
FGS3FWyuCJip91ftWFzoVyAeEy5uXX+N8Mbg6GT5hitiXfNIAK0QbX5VXArg2yN/
gdB9ss505hIJ5238KUO7Qny1KcMOJX3waaMdw1IA9FRJ1UBHcNGL33Xy7Gp4rOlM
EQTlR6yDYVT5LeyulYgYBZo0aW18szMncsR5zV8jMk2DP41IEmEtdpxo20B2hzBG
IxSFOLeleb9rJ6F5RzbY
=N2dB
-----END PGP SIGNATURE-----

--Sig_/j+A.+vQ7juseHx1+48YA8dR--
