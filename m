Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2BWMl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:41:56 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:57320 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab2BWMly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:41:54 -0500
Date: Thu, 23 Feb 2012 14:41:48 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alex Shi <alex.shi@intel.com>, Felipe Balbi <balbi@ti.com>,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, andiry.xu@amd.com, clemens@ladisch.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] usb: enable pci MSI/MSIX in usb core
Message-ID: <20120223124147.GL18463@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1329728733-32419-1-git-send-email-alex.shi@intel.com>
 <1329728733-32419-2-git-send-email-alex.shi@intel.com>
 <1329728733-32419-3-git-send-email-alex.shi@intel.com>
 <20120223034147.GD27250@xanatos>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DVzT7whm/e/NFCC3"
Content-Disposition: inline
In-Reply-To: <20120223034147.GD27250@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DVzT7whm/e/NFCC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Feb 22, 2012 at 07:41:47PM -0800, Sarah Sharp wrote:
> On Mon, Feb 20, 2012 at 05:05:32PM +0800, Alex Shi wrote:
> > MSI/MSIX is the favorite interrupt for PCIe device. PCIe usb HCD should
> > be used more and more in future, but current USB core still just wants
> > line IRQ, only XHCI usb driver enabled MSI/MSIX.
> >=20
> > This patch enabled pci MSI/MSIX in usb core for HCD, and removed MSI/MS=
IX
> > setup code from XHCI since it becomes redundant now.
> > There 3 places need prepare to enable MSI/MSIX in usb driver.
> > 1, set HCD_MSI_FIRST in driver->flags to enable MSI/MSIX.
> > 2, prepare a get_msix_num() to get msix vector numb.
> > 3, prepare msi/msix_irq handler if needed.
> >=20
> > XHCI is a good example for this.
> >=20
> > Thanks for Sarah's effort on the MSI/MSIX enabling in XHCI. In fact most
> > of MSI/MSIX setup functions reuse from XHCI.
>=20
> Comments below.
>=20
> Felipe, can you please review this patch for the effects on non-PCI
> hosts?  I think nothing will change, since this patchset just modifies
> the USB core PCI initialization flow, but I need your eyes on this. :)

Sure thing :-)

> > Signed-off-by: Alex Shi <alex.shi@intel.com>
> > ---
> >  drivers/usb/core/hcd-pci.c  |  223 +++++++++++++++++++++++++++++++++++=
+++++++-
> >  drivers/usb/core/hcd.c      |   22 ++++-
> >  drivers/usb/host/xhci-pci.c |   16 ++--
> >  drivers/usb/host/xhci.c     |  216 +++--------------------------------=
-------
> >  drivers/usb/host/xhci.h     |    5 +-
> >  include/linux/usb/hcd.h     |   17 ++++
> >  6 files changed, 276 insertions(+), 223 deletions(-)
> >=20
> > diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
> > index 81e2c0d..8475b25 100644
> > --- a/drivers/usb/core/hcd-pci.c
> > +++ b/drivers/usb/core/hcd-pci.c
> > @@ -153,6 +153,218 @@ static inline void wait_for_companions(struct pci=
_dev *d, struct usb_hcd *h) {}
> > =20
> >  /*--------------------------------------------------------------------=
-----*/
> > =20
> > +static int hcd_free_msix(struct usb_hcd *hcd)
> > +{
> > +	int i;
> > +	struct pci_dev  *pdev =3D to_pci_dev(hcd->self.controller);
> > +
> > +	if (!hcd->msix_entries) {
> > +		printk(KERN_ERR "No msix entries found!\n");
> > +		return -EINVAL;
> > +	}
> > +	for (i =3D 0; i < hcd->msix_count; i++)
> > +		if (hcd->msix_entries[i].vector)
> > +			free_irq(hcd->msix_entries[i].vector,
> > +					hcd);
> > +
> > +	pci_disable_msix(pdev);
> > +	kfree(hcd->msix_entries);
> > +	hcd->msix_entries =3D NULL;
> > +	hcd->msix_enabled =3D 0;
> > +
> > +	return 0;
> > +}
> > +
> > +static int hcd_free_msi(struct usb_hcd *hcd)
> > +{
> > +	struct pci_dev  *pdev =3D to_pci_dev(hcd->self.controller);
> > +
> > +	if (pdev->irq > 0 && hcd->irq <0)
> > +		free_irq(pdev->irq, hcd);
> > +
> > +	pci_disable_msi(pdev);
> > +	return 0;
> > +}
> > +
> > +/* Free and disable msi/msix */
> > +void usb_hcd_free_msi_msix(struct usb_hcd *hcd)
> > +{
> > +	if (hcd->msix_entries)
> > +		hcd_free_msix(hcd);
> > +	else
> > +		hcd_free_msi(hcd);
> > +
> > +	return;
> > +}
> > +EXPORT_SYMBOL_GPL(usb_hcd_free_msi_msix);
> > +
> > +void usb_hcd_msix_sync_irqs(struct usb_hcd *hcd)
> > +{
> > +	int i;
> > +	if (hcd->msix_entries) {
> > +		for (i =3D 0; i < hcd->msix_count; i++)
> > +			synchronize_irq(hcd->msix_entries[i].vector);
> > +	}
> > +
> > +}
> > +EXPORT_SYMBOL_GPL(usb_hcd_msix_sync_irqs);
> > +
> > +/*
> > + * Set up MSI
> > + */
> > +static int hcd_setup_msi(struct pci_dev *pdev, struct usb_hcd *hcd)
> > +{
> > +	int ret;
> > +
> > +	ret =3D pci_enable_msi(pdev);
> > +	if (ret)
> > +		dev_dbg(&pdev->dev, "failed to allocate MSI entry\n");
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Set up MSI-X
> > + */
> > +static int hcd_setup_msix(struct pci_dev *pdev, struct usb_hcd *hcd)
> > +{
> > +	int i, ret =3D 0;
> > +
> > +	/*
> > +	 * calculate number of msi-x vectors supported.
> > +	 * Add additional 1 vector to ensure always available interrupt.
> > +	 */
> > +	hcd->msix_count =3D min((int)num_online_cpus() + 1,
> > +				hcd->driver->get_msix_num(hcd));
> > +
> > +	hcd->msix_entries =3D
> > +		kmalloc((sizeof(struct msix_entry))*hcd->msix_count,
> > +				GFP_KERNEL);
> > +	if (!hcd->msix_entries) {
> > +		dev_err(&pdev->dev, "Failed to allocate MSI-X entries\n");
> > +		hcd->msix_count =3D 0;
> > +		return -ENOMEM;
> > +	}
> > +
> > +	for (i =3D 0; i < hcd->msix_count; i++) {
> > +		hcd->msix_entries[i].entry =3D i;
> > +		hcd->msix_entries[i].vector =3D 0;
> > +	}
> > +
> > +	ret =3D pci_enable_msix(pdev, hcd->msix_entries, hcd->msix_count);
> > +	if (ret) {
> > +		dev_dbg(&pdev->dev, "Failed to enable MSI-X\n");
> > +		goto free_entries;
> > +	}
> > +
> > +	return ret;
> > +
> > +free_entries:
> > +	kfree(hcd->msix_entries);
> > +	hcd->msix_entries =3D NULL;
> > +	hcd->msix_count =3D 0;
> > +	return ret;
> > +}
> > +
> > +/* Device for a quirk */
> > +#define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
> > +#define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
>=20
> This PCI device and vendor ID is now used in two drivers (xhci and USB
> core).  Please create a separate patch to add this ID to the pci_ids.h
> file, and remove the reference here and in the xHCI driver.

Yeah, makes sense

> > +/* Check for buggy HCD devices, and driver's expectation for MSI.

please use the preferred multi-line comment style.

> > + * Now, only xhci driver want it by HCD_MSI_FIRST setting. Other driver
> > + * like ehci/uhci can follow this setting, if they want.
> > + */
> > +static int hcd_no_msi(struct pci_dev *pdev, struct usb_hcd *hcd)
> > +{
> > +	if (pdev->vendor =3D=3D PCI_VENDOR_ID_FRESCO_LOGIC &&
> > +			pdev->device =3D=3D PCI_DEVICE_ID_FRESCO_LOGIC_PDK) {
> > +
> > +		/* Fresco Logic confirms: all revisions of this chip do not
> > +		 * support MSI, even though some of them claim to in their PCI
> > +		 * capabilities.
> > +		 */
> > +		dev_dbg(&pdev->dev, "QUIRK: Fresco Logic revision %u "
> > +				"has broken MSI implementation\n",
> > +				pdev->revision);
> > +		return 1;
> > +	}
> > +	if (!(hcd->driver->flags & HCD_MSI_FIRST))
> > +		return 1;
> > +
> > +	return 0;
> > +}
> > +
> > +/* setup msi/msix interrupts. if fails, fallback to line irq */
> > +static int hcd_setup_int(struct pci_dev *pdev, struct usb_hcd *hcd)
> > +{
> > +	int ret;
> > +
> > +	hcd->irq =3D -1;
> > +
> > +	if (!hcd_no_msi(pdev, hcd)) {
>=20
> Why don't you rename hcd_no_msi() to hcd_supports_msi() and remove the
> negation of the return value?

I agree.

> > +		ret =3D hcd_setup_msix(pdev, hcd);
> > +		if (ret)
> > +			/* fall back to msi*/
> > +			ret =3D hcd_setup_msi(pdev, hcd);
> > +
> > +		if (!ret)
> > +			/* hcd->irq is -1, we have MSI */
> > +			return 0;
> > +	}
> > +
> > +	if (!pdev->irq) {
> > +		dev_err(&pdev->dev, "No msi or line irq found!\n");
> > +		return -1;
> > +	}
> > +	/* fallback to line irq */
> > +	hcd->irq =3D pdev->irq;
> > +	return 0;
> > +}
> > +
> > +int usb_hcd_request_msi_msix_irqs(struct usb_hcd *hcd, unsigned int ir=
qnum,
> > +					unsigned long irqflags)
> > +{
> > +	int retval =3D 1;
> > +	if (hcd->msix_entries && hcd->driver->msix_irq) {
> > +		int i;
> > +		/* register hc_driver's msix_irq handler */
> > +		for (i =3D 0; i < hcd->msix_count; i++) {
> > +			retval =3D request_irq(hcd->msix_entries[i].vector,
> > +					(irq_handler_t)hcd->driver->msix_irq,

do you really need this cast here ?

> > +					0, hcd->driver->description, hcd);
>=20
> I really think you need to allow the host controller driver to set
> different pointers for the msix data pointer.  It's something that we
> need to figure out, so that we can have the infrastructure in place for
> multiple event rings.
>=20
> I'm not sure whether the new get MSIX count needs to allow the xHCI
> driver to return an array of pointers, or if the driver can modify the
> irq pointer later?  I don't think you can modify the irq data pointer
> after it's been requested (that would lead to all kinds of race
> conditions, I think).
>=20
> It's probably better to allow the xHCI driver to pass this function the
> pointers it needs for each MSI-X vector.  You'll always call
> usb_hcd_request_msi_msix_irqs() after you call xhci_init(), correct?  At
> that point, we should have allocated the multiple event rings, so it
> should be easy to pass the pointers to this function.
>=20
> > +			if (retval) {
> > +				hcd_free_msix(hcd);
> > +				break;
> > +			}
> > +		}
> > +		if (i =3D=3D hcd->msix_count)
> > +			hcd->msix_enabled =3D 1;
> > +	} else if (hcd->irq =3D=3D -1 && hcd->driver->msi_irq) {
> > +		/* register hc_driver's msi_irq handler */
> > +		retval =3D request_irq(irqnum,
> > +					(irq_handler_t)hcd->driver->msi_irq,
> > +					0, hcd->driver->description, hcd);
> > +		if (retval)
> > +			hcd_free_msi(hcd);
> > +	}
> > +
> > +	return retval;
> > +}
> > +EXPORT_SYMBOL_GPL(usb_hcd_request_msi_msix_irqs);
> > +
> > +/* setup msi/msix interrupts and requestion irqs for them */
> > +int usb_hcd_register_msi_msix_irqs(struct usb_hcd *hcd)
> > +{
> > +	struct pci_dev *pdev =3D to_pci_dev(hcd->self.controller);
> > +	int ret =3D -1;
> > +
> > +	if (!hcd_setup_int(pdev, hcd))
> > +		ret =3D usb_hcd_request_msi_msix_irqs(hcd,
> > +				pdev->irq, IRQF_SHARED);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(usb_hcd_register_msi_msix_irqs);
> > +
> >  /* configure so an HC device and id are always provided */
> >  /* always called with process context; sleeping is OK */
> > =20
> > @@ -187,10 +399,8 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const s=
truct pci_device_id *id)
> >  		return -ENODEV;
> >  	dev->current_state =3D PCI_D0;
> > =20
> > -	/* The xHCI driver supports MSI and MSI-X,
> > -	 * so don't fail if the BIOS doesn't provide a legacy IRQ.
> > -	 */
> > -	if (!dev->irq && (driver->flags & HCD_MASK) !=3D HCD_USB3) {
> > +	/* skip irq check if hcd wants MSI firstly. */
> > +	if (!(driver->flags & HCD_MSI_FIRST) && !dev->irq) {
> >  		dev_err(&dev->dev,
> >  			"Found HC with no IRQ.  Check BIOS/PCI %s setup!\n",
> >  			pci_name(dev));
> > @@ -245,6 +455,11 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const s=
truct pci_device_id *id)
> > =20
> >  	pci_set_master(dev);
> > =20
> > +	/* try enable MSI, if fail, seek line irq */
> > +	retval =3D hcd_setup_int(dev, hcd);
> > +	if (retval !=3D 0)
> > +		goto unmap_registers;
> > +
> >  	retval =3D usb_add_hcd(hcd, dev->irq, IRQF_SHARED);
> >  	if (retval !=3D 0)
> >  		goto unmap_registers;
> > diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> > index e128232..579cbd3 100644
> > --- a/drivers/usb/core/hcd.c
> > +++ b/drivers/usb/core/hcd.c
> > @@ -2322,7 +2322,7 @@ int usb_hcd_is_primary_hcd(struct usb_hcd *hcd)
> >  }
> >  EXPORT_SYMBOL_GPL(usb_hcd_is_primary_hcd);
> > =20
> > -static int usb_hcd_request_irqs(struct usb_hcd *hcd,
> > +static int usb_hcd_request_default_irqs(struct usb_hcd *hcd,
> >  		unsigned int irqnum, unsigned long irqflags)
> >  {
> >  	int retval;
> > @@ -2362,6 +2362,20 @@ static int usb_hcd_request_irqs(struct usb_hcd *=
hcd,
> >  	return 0;
> >  }
> > =20
> > +int usb_hcd_request_irqs(struct usb_hcd *hcd, unsigned int irqnum,
> > +		unsigned long irqflags)
> > +{
> > +	int retval =3D 1;
> > +
> > +#ifdef CONFIG_PCI
> > +	retval =3D usb_hcd_request_msi_msix_irqs(hcd, irqnum, irqflags);
> > +#endif

I would like it better if the #ifdef is in the function body, something
like:

int usb_hcd_request_msi_msix_irqs(struct hcd *hcd, int irqnum, int irqflags)
{
#ifdef CONFIG_PCI
	/* blablabla */
#else
	return -ENODEV;
#endif
}

> > @@ -2447,10 +2461,8 @@ int usb_add_hcd(struct usb_hcd *hcd,
> >  			&& device_can_wakeup(&hcd->self.root_hub->dev))
> >  		dev_dbg(hcd->self.controller, "supports USB remote wakeup\n");
> > =20
> > -	/* enable irqs just before we start the controller,
> > -	 * if the BIOS provides legacy PCI irqs.
> > -	 */
> > -	if (usb_hcd_is_primary_hcd(hcd) && irqnum) {
> > +	/* enable irqs just before we start the controller */
> > +	if (usb_hcd_is_primary_hcd(hcd)) {
> >  		retval =3D usb_hcd_request_irqs(hcd, irqnum, irqflags);
> >  		if (retval)
> >  			goto err_request_irq;
> > diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> > index ef98b38..39be795 100644
> > --- a/drivers/usb/host/xhci-pci.c
> > +++ b/drivers/usb/host/xhci-pci.c
> > @@ -64,14 +64,6 @@ static void xhci_pci_quirks(struct device *dev, stru=
ct xhci_hcd *xhci)
> >  			xhci_dbg(xhci, "QUIRK: Fresco Logic xHC needs configure"
> >  					" endpoint cmd after reset endpoint\n");
> >  		}
> > -		/* Fresco Logic confirms: all revisions of this chip do not
> > -		 * support MSI, even though some of them claim to in their PCI
> > -		 * capabilities.
> > -		 */
> > -		xhci->quirks |=3D XHCI_BROKEN_MSI;
> > -		xhci_dbg(xhci, "QUIRK: Fresco Logic revision %u "
> > -				"has broken MSI implementation\n",
> > -				pdev->revision);
> >  	}
> > =20
> >  	if (pdev->vendor =3D=3D PCI_VENDOR_ID_NEC)
> > @@ -124,6 +116,7 @@ static int xhci_pci_setup(struct usb_hcd *hcd)
> >  	return retval;
> >  }
> > =20
> > +
>=20
> Don't add spaces here.
>=20
> >  /*
> >   * We need to register our own PCI probe function (instead of the USB =
core's
> >   * function) in order to create a second roothub under xHCI.
> > @@ -136,6 +129,7 @@ static int xhci_pci_probe(struct pci_dev *dev, cons=
t struct pci_device_id *id)
> >  	struct usb_hcd *hcd;
> > =20
> >  	driver =3D (struct hc_driver *)id->driver_data;
> > +
>=20
> Or here.
>=20
> >  	/* Register the USB 2.0 roothub.
> >  	 * FIXME: USB core must know to register the USB 2.0 roothub first.
> >  	 * This is sort of silly, because we could just set the HCD driver fl=
ags
> > @@ -243,13 +237,17 @@ static const struct hc_driver xhci_pci_hc_driver =
=3D {
> >  	 * generic hardware linkage
> >  	 */
> >  	.irq =3D			xhci_irq,
> > -	.flags =3D		HCD_MEMORY | HCD_USB3 | HCD_SHARED,
> > +	.msi_irq =3D		xhci_msi_irq,
> > +	.msix_irq =3D		xhci_msi_irq,
> > +	.flags =3D		HCD_MEMORY | HCD_USB3 | HCD_SHARED |
> > +				HCD_MSI_FIRST,
> > =20
> >  	/*
> >  	 * basic lifecycle operations
> >  	 */
> >  	.reset =3D		xhci_pci_setup,
> >  	.start =3D		xhci_run,
> > +	.get_msix_num =3D		xhci_get_msix_num,
> >  #ifdef CONFIG_PM
> >  	.pci_suspend =3D          xhci_pci_suspend,
> >  	.pci_resume =3D           xhci_pci_resume,
> > diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> > index c939f5f..95dc48f 100644
> > --- a/drivers/usb/host/xhci.c
> > +++ b/drivers/usb/host/xhci.c
> > @@ -176,210 +176,24 @@ int xhci_reset(struct xhci_hcd *xhci)
> >  }
> > =20
> >  #ifdef CONFIG_PCI
> > -static int xhci_free_msi(struct xhci_hcd *xhci)
> > -{
> > -	int i;
> > -
> > -	if (!xhci->msix_entries)
> > -		return -EINVAL;
> > -
> > -	for (i =3D 0; i < xhci->msix_count; i++)
> > -		if (xhci->msix_entries[i].vector)
> > -			free_irq(xhci->msix_entries[i].vector,
> > -					xhci_to_hcd(xhci));
> > -	return 0;
> > -}
> > -
> > -/*
> > - * Set up MSI
> > - */
> > -static int xhci_setup_msi(struct xhci_hcd *xhci)
> > -{
> > -	int ret;
> > -	struct pci_dev  *pdev =3D to_pci_dev(xhci_to_hcd(xhci)->self.controll=
er);
> > -
> > -	ret =3D pci_enable_msi(pdev);
> > -	if (ret) {
> > -		xhci_dbg(xhci, "failed to allocate MSI entry\n");
> > -		return ret;
> > -	}
> > -
> > -	ret =3D request_irq(pdev->irq, (irq_handler_t)xhci_msi_irq,
> > -				0, "xhci_hcd", xhci_to_hcd(xhci));
> > -	if (ret) {
> > -		xhci_dbg(xhci, "disable MSI interrupt\n");
> > -		pci_disable_msi(pdev);
> > -	}
> > -
> > -	return ret;
> > -}
> > -
> > -/*
> > - * Free IRQs
> > - * free all IRQs request
> > - */
> > -static void xhci_free_irq(struct xhci_hcd *xhci)
> > -{
> > -	struct pci_dev *pdev =3D to_pci_dev(xhci_to_hcd(xhci)->self.controlle=
r);
> > -	int ret;
> > -
> > -	/* return if using legacy interrupt */
> > -	if (xhci_to_hcd(xhci)->irq >=3D 0)
> > -		return;
> > -
> > -	ret =3D xhci_free_msi(xhci);
> > -	if (!ret)
> > -		return;
> > -	if (pdev->irq >=3D 0)
> > -		free_irq(pdev->irq, xhci_to_hcd(xhci));
> > -
> > -	return;
> > -}
> > -
> > -/*
> > - * Set up MSI-X
> > - */
> > -static int xhci_setup_msix(struct xhci_hcd *xhci)
> > -{
> > -	int i, ret =3D 0;
> > -	struct usb_hcd *hcd =3D xhci_to_hcd(xhci);
> > -	struct pci_dev *pdev =3D to_pci_dev(hcd->self.controller);
> > -
> > -	/*
> > -	 * calculate number of msi-x vectors supported.
> > -	 * - HCS_MAX_INTRS: the max number of interrupts the host can handle,
> > -	 *   with max number of interrupters based on the xhci HCSPARAMS1.
> > -	 * - num_online_cpus: maximum msi-x vectors per CPUs core.
> > -	 *   Add additional 1 vector to ensure always available interrupt.
> > -	 */
> > -	xhci->msix_count =3D min(num_online_cpus() + 1,
> > -				HCS_MAX_INTRS(xhci->hcs_params1));
> > -
> > -	xhci->msix_entries =3D
> > -		kmalloc((sizeof(struct msix_entry))*xhci->msix_count,
> > -				GFP_KERNEL);
> > -	if (!xhci->msix_entries) {
> > -		xhci_err(xhci, "Failed to allocate MSI-X entries\n");
> > -		return -ENOMEM;
> > -	}
> > -
> > -	for (i =3D 0; i < xhci->msix_count; i++) {
> > -		xhci->msix_entries[i].entry =3D i;
> > -		xhci->msix_entries[i].vector =3D 0;
> > -	}
> > -
> > -	ret =3D pci_enable_msix(pdev, xhci->msix_entries, xhci->msix_count);
> > -	if (ret) {
> > -		xhci_dbg(xhci, "Failed to enable MSI-X\n");
> > -		goto free_entries;
> > -	}
> > -
> > -	for (i =3D 0; i < xhci->msix_count; i++) {
> > -		ret =3D request_irq(xhci->msix_entries[i].vector,
> > -				(irq_handler_t)xhci_msi_irq,
> > -				0, "xhci_hcd", xhci_to_hcd(xhci));
> > -		if (ret)
> > -			goto disable_msix;
> > -	}
> > -
> > -	hcd->msix_enabled =3D 1;
> > -	return ret;
> > -
> > -disable_msix:
> > -	xhci_dbg(xhci, "disable MSI-X interrupt\n");
> > -	xhci_free_irq(xhci);
> > -	pci_disable_msix(pdev);
> > -free_entries:
> > -	kfree(xhci->msix_entries);
> > -	xhci->msix_entries =3D NULL;
> > -	return ret;
> > -}
> > -
> > -/* Free any IRQs and disable MSI-X */
> > -static void xhci_cleanup_msix(struct xhci_hcd *xhci)
> > -{
> > -	struct usb_hcd *hcd =3D xhci_to_hcd(xhci);
> > -	struct pci_dev *pdev =3D to_pci_dev(hcd->self.controller);
> > -
> > -	xhci_free_irq(xhci);
> > -
> > -	if (xhci->msix_entries) {
> > -		pci_disable_msix(pdev);
> > -		kfree(xhci->msix_entries);
> > -		xhci->msix_entries =3D NULL;
> > -	} else {
> > -		pci_disable_msi(pdev);
> > -	}
> > -
> > -	hcd->msix_enabled =3D 0;
> > -	return;
> > -}
> > =20
> >  static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
> >  {
> > -	int i;
> > -
> > -	if (xhci->msix_entries) {
> > -		for (i =3D 0; i < xhci->msix_count; i++)
> > -			synchronize_irq(xhci->msix_entries[i].vector);
> > -	}
> > +	usb_hcd_msix_sync_irqs(xhci_to_hcd(xhci));
> >  }
> > =20
> > -static int xhci_try_enable_msi(struct usb_hcd *hcd)
> > +/* called in interrupt setup during pci probe() */
> > +int xhci_get_msix_num(struct usb_hcd *hcd)
> >  {
> >  	struct xhci_hcd *xhci =3D hcd_to_xhci(hcd);
> > -	struct pci_dev  *pdev =3D to_pci_dev(xhci_to_hcd(xhci)->self.controll=
er);
> > -	int ret;
> > -
> > -	/*
> > -	 * Some Fresco Logic host controllers advertise MSI, but fail to
> > -	 * generate interrupts.  Don't even try to enable MSI.
> > -	 */
> > -	if (xhci->quirks & XHCI_BROKEN_MSI)
> > -		return 0;
> > -
> > -	/* unregister the legacy interrupt */
> > -	if (hcd->irq)
> > -		free_irq(hcd->irq, hcd);
> > -	hcd->irq =3D -1;
> > =20
> > -	ret =3D xhci_setup_msix(xhci);
> > -	if (ret)
> > -		/* fall back to msi*/
> > -		ret =3D xhci_setup_msi(xhci);
> > -
> > -	if (!ret)
> > -		/* hcd->irq is -1, we have MSI */
> > -		return 0;
> > -
> > -	if (!pdev->irq) {
> > -		xhci_err(xhci, "No msi-x/msi found and no IRQ in BIOS\n");
> > -		return -EINVAL;
> > -	}
> > -
> > -	/* fall back to legacy interrupt*/
> > -	ret =3D request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
> > -			hcd->irq_descr, hcd);
> > -	if (ret) {
> > -		xhci_err(xhci, "request interrupt %d failed\n",
> > -				pdev->irq);
> > -		return ret;
> > -	}
> > -	hcd->irq =3D pdev->irq;
> > -	return 0;
> > +	/* danger: xhci may be null, but it's useless in xhci_readl() now */
> > +	return HCS_MAX_INTRS(xhci_readl(xhci,
> > +			&((struct xhci_cap_regs *)hcd->regs)->hcs_params1));
> >  }
> > =20
> >  #else
> > =20
> > -static int xhci_try_enable_msi(struct usb_hcd *hcd)
> > -{
> > -	return 0;
> > -}
> > -
> > -static void xhci_cleanup_msix(struct xhci_hcd *xhci)
> > -{
> > -}
> > -
> >  static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
> >  {
> >  }
> > @@ -411,7 +225,6 @@ int xhci_init(struct usb_hcd *hcd)
> > =20
> >  	return retval;
> >  }
> > -
> >  /*--------------------------------------------------------------------=
-----*/
> > =20
> > =20
> > @@ -497,7 +310,6 @@ int xhci_run(struct usb_hcd *hcd)
> >  {
> >  	u32 temp;
> >  	u64 temp_64;
> > -	int ret;
> >  	struct xhci_hcd *xhci =3D hcd_to_xhci(hcd);
> > =20
> >  	/* Start the xHCI host controller running only after the USB 2.0 root=
hub
> > @@ -510,10 +322,6 @@ int xhci_run(struct usb_hcd *hcd)
> > =20
> >  	xhci_dbg(xhci, "xhci_run\n");
> > =20
> > -	ret =3D xhci_try_enable_msi(hcd);
> > -	if (ret)
> > -		return ret;
> > -
> >  #ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
> >  	init_timer(&xhci->event_ring_timer);
> >  	xhci->event_ring_timer.data =3D (unsigned long) xhci;
> > @@ -609,7 +417,7 @@ void xhci_stop(struct usb_hcd *hcd)
> >  	xhci_reset(xhci);
> >  	spin_unlock_irq(&xhci->lock);
> > =20
> > -	xhci_cleanup_msix(xhci);
> > +	usb_hcd_free_msi_msix(hcd);
> > =20
> >  #ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
> >  	/* Tell the event ring poll function not to reschedule */
> > @@ -651,7 +459,7 @@ void xhci_shutdown(struct usb_hcd *hcd)
> >  	xhci_halt(xhci);
> >  	spin_unlock_irq(&xhci->lock);
> > =20
> > -	xhci_cleanup_msix(xhci);
> > +	usb_hcd_free_msi_msix(hcd);
> > =20
> >  	xhci_dbg(xhci, "xhci_shutdown completed - status =3D %x\n",
> >  		    xhci_readl(xhci, &xhci->op_regs->status));
> > @@ -853,7 +661,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hiberna=
ted)
> >  		xhci_halt(xhci);
> >  		xhci_reset(xhci);
> >  		spin_unlock_irq(&xhci->lock);
> > -		xhci_cleanup_msix(xhci);
> > +		usb_hcd_free_msi_msix(hcd);
> > =20
> >  #ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
> >  		/* Tell the event ring poll function not to reschedule */
> > @@ -888,7 +696,11 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibern=
ated)
> >  		if (retval)
> >  			return retval;
> >  		xhci_dbg(xhci, "Start the primary HCD\n");
> > -		retval =3D xhci_run(hcd->primary_hcd);
> > +		if (dev_is_pci(hcd->self.controller))
> > +			retval =3D usb_hcd_register_msi_msix_irqs(
> > +						hcd->primary_hcd);
>=20
> Why not change this function to take a count of msix vectors and
> pointers for data?  Then you don't need the new usb_hcd driver method
> for getting the msix count.
>=20
> > +		if (!retval)
> > +			retval =3D xhci_run(hcd->primary_hcd);
> >  		if (!retval) {
> >  			xhci_dbg(xhci, "Start the secondary HCD\n");
> >  			retval =3D xhci_run(secondary_hcd);
> > diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> > index fb99c83..8d511dd 100644
> > --- a/drivers/usb/host/xhci.h
> > +++ b/drivers/usb/host/xhci.h
> > @@ -1388,9 +1388,6 @@ struct xhci_hcd {
> >  	int		page_size;
> >  	/* Valid values are 12 to 20, inclusive */
> >  	int		page_shift;
> > -	/* msi-x vectors */
> > -	int		msix_count;
> > -	struct msix_entry	*msix_entries;
> >  	/* data structures */
> >  	struct xhci_device_context_array *dcbaa;
> >  	struct xhci_ring	*cmd_ring;
> > @@ -1643,9 +1640,11 @@ void xhci_free_command(struct xhci_hcd *xhci,
> >  /* xHCI PCI glue */
> >  int xhci_register_pci(void);
> >  void xhci_unregister_pci(void);
> > +int xhci_get_msix_num(struct usb_hcd *hcd);
> >  #else
> >  static inline int xhci_register_pci(void) { return 0; }
> >  static inline void xhci_unregister_pci(void) {}
> > +static inline int xhci_get_msix_num(struct usb_hcd *hcd) { return 0; }
> >  #endif
> > =20
> >  /* xHCI host controller glue */
> > diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
> > index b2f62f3..5253c02 100644
> > --- a/include/linux/usb/hcd.h
> > +++ b/include/linux/usb/hcd.h
> > @@ -22,6 +22,7 @@
> >  #ifdef __KERNEL__
> > =20
> >  #include <linux/rwsem.h>
> > +#include <linux/pci.h>		/* for struct msix_entry */
> > =20
> >  #define MAX_TOPO_LEVEL		6
> > =20
> > @@ -133,6 +134,12 @@ struct usb_hcd {
> >  	u64			rsrc_len;	/* memory/io resource length */
> >  	unsigned		power_budget;	/* in mA, 0 =3D no limit */
> > =20
> > +#ifdef CONFIG_PCI
> > +	/* msi-x vectors */
> > +	int			msix_count;
> > +	struct msix_entry	*msix_entries;
> > +#endif
> > +
> >  	/* bandwidth_mutex should be taken before adding or removing
> >  	 * any new bus bandwidth constraints:
> >  	 *   1. Before adding a configuration for a new device.
> > @@ -205,11 +212,14 @@ struct hc_driver {
> > =20
> >  	/* irq handler */
> >  	irqreturn_t	(*irq) (struct usb_hcd *hcd);
> > +	irqreturn_t	(*msi_irq) (int irq, struct usb_hcd *hcd);
> > +	irqreturn_t	(*msix_irq) (int irq, struct usb_hcd *hcd);
> > =20
> >  	int	flags;
> >  #define	HCD_MEMORY	0x0001		/* HC regs use memory (else I/O) */
> >  #define	HCD_LOCAL_MEM	0x0002		/* HC needs local memory */
> >  #define	HCD_SHARED	0x0004		/* Two (or more) usb_hcds share HW */
> > +#define	HCD_MSI_FIRST	0x0008		/* Try to get MSI first, PCI only */
> >  #define	HCD_USB11	0x0010		/* USB 1.1 */
> >  #define	HCD_USB2	0x0020		/* USB 2.0 */
> >  #define	HCD_USB3	0x0040		/* USB 3.0 */
> > @@ -218,6 +228,7 @@ struct hc_driver {
> >  	/* called to init HCD and root hub */
> >  	int	(*reset) (struct usb_hcd *hcd);
> >  	int	(*start) (struct usb_hcd *hcd);
> > +	int	(*get_msix_num) (struct usb_hcd *hcd);
> > =20
> >  	/* NOTE:  these suspend/resume calls relate to the HC as
> >  	 * a whole, not just the root hub; they're for PCI bus glue.
> > @@ -393,6 +404,12 @@ extern int usb_hcd_pci_probe(struct pci_dev *dev,
> >  extern void usb_hcd_pci_remove(struct pci_dev *dev);
> >  extern void usb_hcd_pci_shutdown(struct pci_dev *dev);
> > =20
> > +extern void usb_hcd_free_msi_msix(struct usb_hcd *hcd);
> > +extern void usb_hcd_msix_sync_irqs(struct usb_hcd *hcd);
> > +extern int usb_hcd_request_msi_msix_irqs(struct usb_hcd *hcd,
> > +		unsigned int irqnum, unsigned long irqflags);
> > +extern int usb_hcd_register_msi_msix_irqs(struct usb_hcd *hcd);
> > +
> >  #ifdef CONFIG_PM_SLEEP
> >  extern const struct dev_pm_ops usb_hcd_pci_pm_ops;
> >  #endif
> > --=20
> > 1.6.3.3

Yeah, I don't think this will break anything for my non-PCI stuff, but
the very fact that usbcore knows so much about PCI is quite a bummer. I
think usbcore should know about USB Devices and HCDs, no matter if it's
PCI or platform BUS or whatever else, but that's just me and changing
that would be quite a big re-work.

--=20
balbi

--DVzT7whm/e/NFCC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRjQLAAoJEIaOsuA1yqREblgP/1s8hvo4c8l5DABH2RfC2gB/
8Ra0y045BlpC1jRfzJVhr6KN5yzvzYHlSflYApOgxuhl6EN1ROyDd+vp5GDcvGyl
YYw7STysxO2+lZvMO5988mNTGfvEafK4tUFuPmXl5uqwQAXz2ZpmJwSNYlLPlrB4
KlmvBOqdEYomFGCl8bi7FTQfzTs8wJWcnHCGDBVc/TW564mAt5SnqJKn7nmT5h8n
GQ82LUWBxwLUa4Os/GGbWHYq9sDo+YyCGVcUksmyqERwdepsIKq45lz9AIO5aAkY
Bhp7agD7BEU/KWHqjjjM+OI1CQfI48dkxu8Mx2WFv3mronJGJj2S7vXkLPga6U9Q
TFKCQguMDBKUI44f/vjG6kvFmGpi6NC5HUKey4LjeOaatPkOntnLWJKSQVRgyLl2
FnvbkaBRPdDZ09GYt8Rldv2nsWK/TqlWuRjvqQkg9gwyxr9UaDLxc/l/gtcIenEq
ubGMAfQbavIIdkML3jUNkduLxKtggrTUev+k/z3Tua88lL96WwSro62QAriXDfhG
tiYyO5/l42G8NyKyX+7qmgDaemBWidhJJ+Q/0DII1eMUEDIeYr+5Gq8nNByIEioo
Gu6NzVjd3RKuMa0AyVrJ5lLLMEja0IfPtytAYgmRht8rD5PHrUBafMTWx3xv0Wg9
HeVFY2UzLgC7iFFRSIDU
=zUke
-----END PGP SIGNATURE-----

--DVzT7whm/e/NFCC3--
