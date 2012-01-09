Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2AIIYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:24:15 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:36818 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab2AIIYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:24:13 -0500
Date: Mon, 9 Jan 2012 10:24:07 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH] usb/gadget/pch_udc: Fix ether gadget connect/disconnect
 issue
Message-ID: <20120109082405.GA3167@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1324872283-12813-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <1324872283-12813-1-git-send-email-tomoya.rohm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 26, 2011 at 01:04:43PM +0900, Tomoya MORINAGA wrote:
> ISSUE:
> After a USB cable is connect/disconnected, the system rarely freeze.
> CAUSE:
> Since the USB device controller cannot know to disconnect the USB cable,=
=20
> when it is used without detecting VBUS by GPIO, the UDC driver does not=
=20
> notify to USB Gadget.
> Since USB Gadget cannot know to disconnect, a false setting occurred=20
> when the USB cable is connected/disconnect repeatedly.

you are doing much, much more then what's here. You really need to break
this patch up.

> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> ---
>  drivers/usb/gadget/pch_udc.c |  115 ++++++++++++++++++++++++++++++++++++=
++----
>  1 files changed, 105 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
> index 5048a0c..454028d 100644
> --- a/drivers/usb/gadget/pch_udc.c
> +++ b/drivers/usb/gadget/pch_udc.c
> @@ -311,6 +311,8 @@ struct pch_udc_ep {
>   * @registered:		driver regsitered with system
>   * @suspended:		driver in suspended state
>   * @connected:		gadget driver associated
> + * @pullup:		required pullup state
> + * @vbus_session:	required vbus_session state
>   * @set_cfg_not_acked:	pending acknowledgement 4 setup
>   * @waiting_zlp_ack:	pending acknowledgement 4 ZLP
>   * @data_requests:	DMA pool for data requests
> @@ -337,6 +339,8 @@ struct pch_udc_dev {
>  			registered:1,
>  			suspended:1,
>  			connected:1,
> +			pullup:1,
> +			vbus_session:1,
>  			set_cfg_not_acked:1,
>  			waiting_zlp_ack:1;
>  	struct pci_pool		*data_requests;
> @@ -554,6 +558,29 @@ static void pch_udc_clear_disconnect(struct pch_udc_=
dev *dev)
>  }
> =20
>  /**
> + * pch_udc_reconnect() - This API initializes usb device controller,
> + *						and clear the disconnect status.
> + * @dev:		Reference to pch_udc_regs structure
> + */
> +static void pch_udc_init(struct pch_udc_dev *dev);
> +static void pch_udc_reconnect(struct pch_udc_dev *dev)
> +{
> +	pch_udc_init(dev);
> +
> +	/* enable device interrupts */
> +	/* pch_udc_enable_interrupts() */
> +	pch_udc_bit_clr(dev, UDC_DEVIRQMSK_ADDR,
> +			UDC_DEVINT_UR | UDC_DEVINT_ENUM);
> +
> +	/* Clear the disconnect */
> +	pch_udc_bit_set(dev, UDC_DEVCTL_ADDR, UDC_DEVCTL_RES);
> +	pch_udc_bit_clr(dev, UDC_DEVCTL_ADDR, UDC_DEVCTL_SD);
> +	mdelay(1);
> +	/* Resume USB signalling */
> +	pch_udc_bit_clr(dev, UDC_DEVCTL_ADDR, UDC_DEVCTL_RES);
> +}
> +
> +/**
>   * pch_udc_vbus_session() - set or clearr the disconnect status.
>   * @dev:	Reference to pch_udc_regs structure
>   * @is_active:	Parameter specifying the action
> @@ -563,10 +590,23 @@ static void pch_udc_clear_disconnect(struct pch_udc=
_dev *dev)
>  static inline void pch_udc_vbus_session(struct pch_udc_dev *dev,
>  					  int is_active)
>  {
> -	if (is_active)
> -		pch_udc_clear_disconnect(dev);
> -	else
> +	if (is_active) {
> +		if (dev->pullup =3D=3D 1) {
> +			if (dev->vbus_session =3D=3D 1)
> +				pch_udc_clear_disconnect(dev);
> +			else
> +				pch_udc_reconnect(dev);
> +		}
> +		dev->vbus_session =3D 1;
> +	} else {
> +		if (dev->driver && dev->driver->disconnect) {
> +			spin_unlock(&dev->lock);
> +			dev->driver->disconnect(&dev->gadget);
> +			spin_lock(&dev->lock);
> +		}
>  		pch_udc_set_disconnect(dev);
> +		dev->vbus_session =3D 0;
> +	}
>  }
> =20
>  /**
> @@ -1126,7 +1166,23 @@ static int pch_udc_pcd_pullup(struct usb_gadget *g=
adget, int is_on)
>  	if (!gadget)
>  		return -EINVAL;
>  	dev =3D container_of(gadget, struct pch_udc_dev, gadget);
> -	pch_udc_vbus_session(dev, is_on);
> +	if (is_on) {
> +		if (dev->pullup =3D=3D 1) {
> +			pch_udc_clear_disconnect(dev);
> +		} else {
> +			pch_udc_reconnect(dev);
> +			dev->pullup =3D 1;
> +		}
> +	} else {
> +		if (dev->driver && dev->driver->disconnect) {
> +			spin_unlock(&dev->lock);
> +			dev->driver->disconnect(&dev->gadget);
> +			spin_lock(&dev->lock);

this looks very wrong. ->pullup() should not call into the gadget
driver. Looking over your driver, it seems that one of the issues is
that you have a race between ->vbus_session() and ->pullup() because
they both call your pch_udc_vbus_session() without taking care of
locking those two.

> +		}
> +		pch_udc_set_disconnect(dev);
> +		dev->pullup =3D 0;
> +	}
> +
>  	return 0;
>  }
> =20
> @@ -2335,8 +2391,11 @@ static void pch_udc_svc_ur_interrupt(struct pch_ud=
c_dev *dev)
>  		/* Complete request queue */
>  		empty_req_queue(ep);
>  	}
> -	if (dev->driver && dev->driver->disconnect)
> +	if (dev->driver && dev->driver->disconnect) {
> +		spin_unlock(&dev->lock);
>  		dev->driver->disconnect(&dev->gadget);
> +		spin_lock(&dev->lock);

this needs to be fixed, indeed. And maybe it's the only thing which fits
under $SUBJECT. Can you describe better the problem you're seeing ?
Maybe showing any WARN()/BUG() output which showed up ?

> @@ -2371,6 +2430,11 @@ static void pch_udc_svc_enum_interrupt(struct pch_=
udc_dev *dev)
>  	pch_udc_set_dma(dev, DMA_DIR_TX);
>  	pch_udc_set_dma(dev, DMA_DIR_RX);
>  	pch_udc_ep_set_rrdy(&(dev->ep[UDC_EP0OUT_IDX]));
> +
> +	/* enable device interrupts */
> +	pch_udc_enable_interrupts(dev, UDC_DEVINT_UR | UDC_DEVINT_US |
> +					UDC_DEVINT_ES | UDC_DEVINT_ENUM |
> +					UDC_DEVINT_SI | UDC_DEVINT_SC);

doesn't fit under $SUBJECT.

> @@ -2460,11 +2524,15 @@ static void pch_udc_svc_cfg_interrupt(struct pch_=
udc_dev *dev)
>  static void pch_udc_dev_isr(struct pch_udc_dev *dev, u32 dev_intr)
>  {
>  	/* USB Reset Interrupt */
> -	if (dev_intr & UDC_DEVINT_UR)
> +	if (dev_intr & UDC_DEVINT_UR) {
>  		pch_udc_svc_ur_interrupt(dev);
> +		dev_dbg(&dev->pdev->dev, "USB_RESET\n");

all these debugging message are _not_ part of $SUBJECT.

> @@ -2472,8 +2540,25 @@ static void pch_udc_dev_isr(struct pch_udc_dev *de=
v, u32 dev_intr)
>  	if (dev_intr & UDC_DEVINT_SC)
>  		pch_udc_svc_cfg_interrupt(dev);
>  	/* USB Suspend interrupt */
> -	if (dev_intr & UDC_DEVINT_US)
> +	if (dev_intr & UDC_DEVINT_US) {
> +		if (dev->gadget.speed !=3D USB_SPEED_UNKNOWN

In fact, I would WARN() if your speed isn't known at this spot. This
would mean you have a big fat bug on your controller driver.

> +			&& dev->driver
> +			&& dev->driver->suspend) {
> +			spin_unlock(&dev->lock);
> +			dev->driver->suspend(&dev->gadget);
> +			spin_lock(&dev->lock);

Indeed, this is the right way, but not part of $SUBJECT.

> +		}
> +
> +		if ((dev->vbus_session =3D=3D 0) && (dev->pullup =3D=3D 1)) {
> +			if (dev->driver && dev->driver->disconnect) {
> +				spin_unlock(&dev->lock);
> +				dev->driver->disconnect(&dev->gadget);
> +				spin_lock(&dev->lock);

also correct, and looks part of $SUBJECT.

> @@ -2499,6 +2584,14 @@ static irqreturn_t pch_udc_isr(int irq, void *pdev)
>  	dev_intr =3D pch_udc_read_device_interrupts(dev);
>  	ep_intr =3D pch_udc_read_ep_interrupts(dev);
> =20
> +	/* For a hot plug, this find that the controller is hung up. */
> +	if (dev_intr =3D=3D ep_intr)
> +		if (dev_intr =3D=3D pch_udc_readl(dev, UDC_DEVCFG_ADDR)) {
> +			dev_dbg(&dev->pdev->dev, "UDC: Hung up\n");
> +			/* The controller is reset */
> +			pch_udc_writel(dev, UDC_SRST, UDC_SRST_ADDR);
> +			return IRQ_HANDLED;
> +		}
>  	if (dev_intr)
>  		/* Clear device interrupts */
>  		pch_udc_write_device_interrupts(dev, dev_intr);
> @@ -2725,7 +2818,7 @@ static int pch_udc_start(struct usb_gadget_driver *=
driver,
>  	pch_udc_setup_ep0(dev);
> =20
>  	/* clear SD */
> -	pch_udc_clear_disconnect(dev);
> +	pch_udc_pcd_pullup(&dev->gadget, 1);

this rings a bell, why do you need to change this ?

> @@ -2912,8 +3005,10 @@ static int pch_udc_probe(struct pci_dev *pdev,
>  	}
>  	pch_udc =3D dev;
>  	/* initialize the hardware */
> -	if (pch_udc_pcd_init(dev))
> +	if (pch_udc_pcd_init(dev)) {
> +		retval =3D -ENODEV;

not part of $SUBJECT but how about passing the return value from
pch_udc_pcd_init() to upper layer instead of changing it here ?

ret =3D pch_udc_pcd_init(dev);
if (ret) {
	....

--=20
balbi

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPCqQlAAoJEIaOsuA1yqREDBYP/iDngid43NLQsG7arBCpAwo/
Vv1FXzkBqRVeDRJwPNPiMP9SgiJDofPB1d5piRM0kQzABVYmyTAFZBaNj/L15pg/
YsiGLib1ZNBBlYATBbSJddVlYYR0EBgr8KNlf/jaljrIEQJ2uwoAA6Z9Xy2tFvhS
q8KcOV32ULFMXUklRXDL7Jcd3pyvP1TR0PcnM47QUOGle4qO5A+uH2ysLqVXYeYj
u19HFTPkCX8k61RPSqShV8TfPropLGPlaX99KLP1Aj2Zmf7U5w4/2IQ8h/5vK6fL
lFxngi4vSgpHjSloBPsizSE4htTzgRjCFAcYv++UONfba/kmFdWpeuQQvrSVN72B
Ybr69kzSIspQSTCyMY1Ol9Pj2/IydDIG6ObPq6LGw05kjokz6Z3v/gZYO+y8BbZH
HIm4w5gwqyUbpC3epLclQasP/QkmHhB45eBjtxw2zW1dHNHficbc8qfq7RSWSDAD
RgTMh1mEkz/yUjMvdarvoIZRgJVxdouTCYRVBo9RJ2BZNqG0ewMlZKdNFN131ecU
jgmrKSL8tdjen9YQMxQTDDHNDaFUWOek/Nuw5xCRJJyvyHMAl+Fa+8hBaQ5uIvdi
MvsLFS+Nj/RhaPjGZQDy8NjKgT6mxlIpSrwC6tRsWnrMTgTGdcQyeAtpxheb7sA6
yKim5cXDGPLEmwqrEWvR
=QOei
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
