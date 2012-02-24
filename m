Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab2BXKA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:00:59 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:52929 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756690Ab2BXKA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:00:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of balbi@ti.com designates 10.152.144.39 as permitted sender) smtp.mail=balbi@ti.com
Date: Fri, 24 Feb 2012 12:00:53 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: balbi@ti.com, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, andiry.xu@amd.com, clemens@ladisch.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] usb: enable pci MSI/MSIX in usb core
Message-ID: <20120224100051.GF17178@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1329728733-32419-1-git-send-email-alex.shi@intel.com>
 <1329728733-32419-2-git-send-email-alex.shi@intel.com>
 <1329728733-32419-3-git-send-email-alex.shi@intel.com>
 <20120223034147.GD27250@xanatos>
 <20120223124147.GL18463@legolas.emea.dhcp.ti.com>
 <1330048028.21053.1176.camel@debian>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhtSGe8h3+lMyY1M"
Content-Disposition: inline
In-Reply-To: <1330048028.21053.1176.camel@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhtSGe8h3+lMyY1M
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2012 at 09:47:08AM +0800, Alex,Shi wrote:
>=20
> > > Felipe, can you please review this patch for the effects on non-PCI
> > > hosts?  I think nothing will change, since this patchset just modifies
> > > the USB core PCI initialization flow, but I need your eyes on this. :)
> >=20
> > Sure thing :-)
>=20
> Thanks a lot!
>=20
> > > > +/* Check for buggy HCD devices, and driver's expectation for MSI.
> >=20
> > please use the preferred multi-line comment style.
>=20
> See and thanks!
>=20
> > > > +			retval =3D request_irq(hcd->msix_entries[i].vector,
> > > > +					(irq_handler_t)hcd->driver->msix_irq,
> >=20
> > do you really need this cast here ?
>=20
> Yes, otherwise the complain like here:
> drivers/usb/core/hcd-pci.c:330: warning: passing argument 2 of =E2=80=98r=
equest_irq=E2=80=99 from incompatible pointer type
> include/linux/interrupt.h:134: note: expected =E2=80=98irq_handler_t=E2=
=80=99 but argument is of type =E2=80=98enum irqreturn_t (* const)(int,  st=
ruct usb_hcd *)=E2=80=99

Alan, Sarah, is the definition of the IRQ handler wrong on the hc_driver
structure ?

Alex, I think you should fix your definition for the msix_irq handler.

> > > > +int usb_hcd_request_irqs(struct usb_hcd *hcd, unsigned int irqnum,
> > > > +		unsigned long irqflags)
> > > > +{
> > > > +	int retval =3D 1;
> > > > +
> > > > +#ifdef CONFIG_PCI
> > > > +	retval =3D usb_hcd_request_msi_msix_irqs(hcd, irqnum, irqflags);
> > > > +#endif
> >=20
> > I would like it better if the #ifdef is in the function body, something
> > like:
> >=20
> > int usb_hcd_request_msi_msix_irqs(struct hcd *hcd, int irqnum, int irqf=
lags)
> > {
> > #ifdef CONFIG_PCI
> > 	/* blablabla */
> > #else
> > 	return -ENODEV;
> > #endif
> > }
>=20
> The function usb_hcd_request_msi_msix_irqs() is defined in hcd-pci.c. If
> you don't like to see '#ifdef CONFIG_PCI' in hcd.c, maybe we can add a
> same name function usb_hcd_request_msi_msix_irqs() in hcd.h for non-pci
> environment.  Is that ok of the following?=20
> ------
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 579cbd3..9bc6568 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -2365,12 +2365,9 @@ static int usb_hcd_request_default_irqs(struct usb=
_hcd *hcd,
>  int usb_hcd_request_irqs(struct usb_hcd *hcd, unsigned int irqnum,
>                 unsigned long irqflags)
>  {
> -       int retval =3D 1;
> +       int retval =3D 0;
> =20
> -#ifdef CONFIG_PCI
> -       retval =3D usb_hcd_request_msi_msix_irqs(hcd, irqnum, irqflags);
> -#endif
> -       if (retval)
> +       if (usb_hcd_request_msi_msix_irqs(hcd, irqnum, irqflags))
>                 retval =3D usb_hcd_request_default_irqs(hcd, irqnum, irqf=
lags);
> =20
>         return retval;
> diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
> index 5253c02..6743ed8 100644
> --- a/include/linux/usb/hcd.h
> +++ b/include/linux/usb/hcd.h
> @@ -413,6 +413,13 @@ extern int usb_hcd_register_msi_msix_irqs(struct usb=
_hcd *hcd);
>  #ifdef CONFIG_PM_SLEEP
>  extern const struct dev_pm_ops usb_hcd_pci_pm_ops;
>  #endif
> +
> +#else
> +extern int usb_hcd_request_msi_msix_irqs(struct usb_hcd *hcd,
> +               unsigned int irqnum, unsigned long irqflags)
> +{
> +       return -ENODEV;
> +}
>  #endif /* CONFIG_PCI */

sure, makes sense, but that should be static inline I guess.

>  /* pci-ish (pdev null is ok) buffer alloc/mapping support */
>=20
> > Yeah, I don't think this will break anything for my non-PCI stuff, but
> > the very fact that usbcore knows so much about PCI is quite a bummer. I
> > think usbcore should know about USB Devices and HCDs, no matter if it's
> > PCI or platform BUS or whatever else, but that's just me and changing
> > that would be quite a big re-work.
> >=20
>=20
> Thanks again for all comments!

np.

--=20
balbi

--zhtSGe8h3+lMyY1M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPR1/TAAoJEIaOsuA1yqREo2UQAKItllZ4wqW+SnWK37R4rnvt
LxZPp93x70yljftFtkrbpDvvreTFvEJ4hbuOw6uOwCITG7P4FOt7967ln+c1c80U
n8ortmq52dSuMuKiZJ3QyEJPRNAZpQuyCFnixD9iuNbhuLmXmPGedS3jmkM8f4AS
o1wuvnq2gRSpbFD96hCeioKALILHrmak90UBZ25yMm6VrvKG6mhi7FUZ+jgL6mZl
5rEN5RHKYaXDFRfWBKbZfV9B8eCFKkFB8os4AeSSV2IuBiEp5QMVmfQbg3wO3+jo
h5E9Zaj3yFC8MA1qKSdWHV7QzPjIfj3VZylVLU/OisccrD8nDp5Kv68sANwNnv3l
OoK16Qw+ms/qXFeyxpw6YaiJVKnLUJCe9lI0xJRdF+q3PD7XAV12QDUwVkr7xF28
PfaHr/9VOXA/lKVXzQ0XsusnmL1KR/tV1IJ0k422Vk1LZ7gfpNvZKHXfSY/TwCuR
UXSp6MdyojwkvDScrd+/GAuidUtsYLSqcydYlRh7wt4wPuQBrwbEzkUTaGu5GohC
F412u7W/kuBY/NFIndXBP/Okdy3XkcamJkPonWvgLt3/sC8Ucd5hRXulqrTIrhx1
si5iH9hN2+7ZizbKv3iZ3dQiKzY2EiEFNOxRp0IQmWbdhsfzvzxAeGJP9Wt5hhQE
JeDYRYrXuLl3ybPlCt3h
=y8yU
-----END PGP SIGNATURE-----

--zhtSGe8h3+lMyY1M--
