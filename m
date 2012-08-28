Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab2H1OBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 10:01:14 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:53673 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602Ab2H1OBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 10:01:13 -0400
Date: Tue, 28 Aug 2012 16:57:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: otg: Move phy interface to separate file.
Message-ID: <20120828135657.GA4201@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1346156411-20761-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <1346156411-20761-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 28, 2012 at 05:50:11PM +0530, Venu Byravarasu wrote:
> As otg.h is containing lots of phy interface related
> stuff, moving all phy interface related stuff to new
> file named phy.h
>=20
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

this should be ok.. I'll apply it once v3.6-rc4 is out unless someone
has something against it :-)

> ---
>  include/linux/usb/otg.h |  211 +----------------------------------------=
----
>  include/linux/usb/phy.h |  222 +++++++++++++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 223 insertions(+), 210 deletions(-)
>  create mode 100644 include/linux/usb/phy.h
>=20
> diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
> index 45824be..ccd3511 100644
> --- a/include/linux/usb/otg.h
> +++ b/include/linux/usb/otg.h
> @@ -10,6 +10,7 @@
>  #define __LINUX_USB_OTG_H
> =20
>  #include <linux/notifier.h>
> +#include <linux/usb/phy.h>
> =20
>  /* OTG defines lots of enumeration states before device reset */
>  enum usb_otg_state {
> @@ -35,31 +36,6 @@ enum usb_otg_state {
>  	OTG_STATE_A_VBUS_ERR,
>  };
> =20
> -enum usb_phy_events {
> -	USB_EVENT_NONE,         /* no events or cable disconnected */
> -	USB_EVENT_VBUS,         /* vbus valid event */
> -	USB_EVENT_ID,           /* id was grounded */
> -	USB_EVENT_CHARGER,      /* usb dedicated charger */
> -	USB_EVENT_ENUMERATED,   /* gadget driver enumerated */
> -};
> -
> -/* associate a type with PHY */
> -enum usb_phy_type {
> -	USB_PHY_TYPE_UNDEFINED,
> -	USB_PHY_TYPE_USB2,
> -	USB_PHY_TYPE_USB3,
> -};
> -
> -struct usb_phy;
> -
> -/* for transceivers connected thru an ULPI interface, the user must
> - * provide access ops
> - */
> -struct usb_phy_io_ops {
> -	int (*read)(struct usb_phy *x, u32 reg);
> -	int (*write)(struct usb_phy *x, u32 val, u32 reg);
> -};
> -
>  struct usb_otg {
>  	u8			default_a;
> =20
> @@ -85,134 +61,9 @@ struct usb_otg {
> =20
>  };
> =20
> -/*
> - * the otg driver needs to interact with both device side and host side
> - * usb controllers.  it decides which controller is active at a given
> - * moment, using the transceiver, ID signal, HNP and sometimes static
> - * configuration information (including "board isn't wired for otg").
> - */
> -struct usb_phy {
> -	struct device		*dev;
> -	const char		*label;
> -	unsigned int		 flags;
> -
> -	enum usb_phy_type	type;
> -	enum usb_otg_state	state;
> -	enum usb_phy_events	last_event;
> -
> -	struct usb_otg		*otg;
> -
> -	struct device		*io_dev;
> -	struct usb_phy_io_ops	*io_ops;
> -	void __iomem		*io_priv;
> -
> -	/* for notification of usb_phy_events */
> -	struct atomic_notifier_head	notifier;
> -
> -	/* to pass extra port status to the root hub */
> -	u16			port_status;
> -	u16			port_change;
> -
> -	/* to support controllers that have multiple transceivers */
> -	struct list_head	head;
> -
> -	/* initialize/shutdown the OTG controller */
> -	int	(*init)(struct usb_phy *x);
> -	void	(*shutdown)(struct usb_phy *x);
> -
> -	/* effective for B devices, ignored for A-peripheral */
> -	int	(*set_power)(struct usb_phy *x,
> -				unsigned mA);
> -
> -	/* for non-OTG B devices: set transceiver into suspend mode */
> -	int	(*set_suspend)(struct usb_phy *x,
> -				int suspend);
> -
> -	/* notify phy connect status change */
> -	int	(*notify_connect)(struct usb_phy *x, int port);
> -	int	(*notify_disconnect)(struct usb_phy *x, int port);
> -};
> -
> -
> -/* for board-specific init logic */
> -extern int usb_add_phy(struct usb_phy *, enum usb_phy_type type);
> -extern void usb_remove_phy(struct usb_phy *);
> -
> -#if defined(CONFIG_NOP_USB_XCEIV) || (defined(CONFIG_NOP_USB_XCEIV_MODUL=
E) && defined(MODULE))
> -/* sometimes transceivers are accessed only through e.g. ULPI */
> -extern void usb_nop_xceiv_register(void);
> -extern void usb_nop_xceiv_unregister(void);
> -#else
> -static inline void usb_nop_xceiv_register(void)
> -{
> -}
> -
> -static inline void usb_nop_xceiv_unregister(void)
> -{
> -}
> -#endif
> -
> -/* helpers for direct access thru low-level io interface */
> -static inline int usb_phy_io_read(struct usb_phy *x, u32 reg)
> -{
> -	if (x->io_ops && x->io_ops->read)
> -		return x->io_ops->read(x, reg);
> -
> -	return -EINVAL;
> -}
> -
> -static inline int usb_phy_io_write(struct usb_phy *x, u32 val, u32 reg)
> -{
> -	if (x->io_ops && x->io_ops->write)
> -		return x->io_ops->write(x, val, reg);
> -
> -	return -EINVAL;
> -}
> -
> -static inline int
> -usb_phy_init(struct usb_phy *x)
> -{
> -	if (x->init)
> -		return x->init(x);
> -
> -	return 0;
> -}
> -
> -static inline void
> -usb_phy_shutdown(struct usb_phy *x)
> -{
> -	if (x->shutdown)
> -		x->shutdown(x);
> -}
> -
> -/* for usb host and peripheral controller drivers */
>  #ifdef CONFIG_USB_OTG_UTILS
> -extern struct usb_phy *usb_get_phy(enum usb_phy_type type);
> -extern struct usb_phy *devm_usb_get_phy(struct device *dev,
> -	enum usb_phy_type type);
> -extern void usb_put_phy(struct usb_phy *);
> -extern void devm_usb_put_phy(struct device *dev, struct usb_phy *x);
>  extern const char *otg_state_string(enum usb_otg_state state);
>  #else
> -static inline struct usb_phy *usb_get_phy(enum usb_phy_type type)
> -{
> -	return NULL;
> -}
> -
> -static inline struct usb_phy *devm_usb_get_phy(struct device *dev,
> -	enum usb_phy_type type)
> -{
> -	return NULL;
> -}
> -
> -static inline void usb_put_phy(struct usb_phy *x)
> -{
> -}
> -
> -static inline void devm_usb_put_phy(struct device *dev, struct usb_phy *=
x)
> -{
> -}
> -
>  static inline const char *otg_state_string(enum usb_otg_state state)
>  {
>  	return NULL;
> @@ -262,42 +113,6 @@ otg_set_peripheral(struct usb_otg *otg, struct usb_g=
adget *periph)
>  }
> =20
>  static inline int
> -usb_phy_set_power(struct usb_phy *x, unsigned mA)
> -{
> -	if (x && x->set_power)
> -		return x->set_power(x, mA);
> -	return 0;
> -}
> -
> -/* Context: can sleep */
> -static inline int
> -usb_phy_set_suspend(struct usb_phy *x, int suspend)
> -{
> -	if (x->set_suspend !=3D NULL)
> -		return x->set_suspend(x, suspend);
> -	else
> -		return 0;
> -}
> -
> -static inline int
> -usb_phy_notify_connect(struct usb_phy *x, int port)
> -{
> -	if (x->notify_connect)
> -		return x->notify_connect(x, port);
> -	else
> -		return 0;
> -}
> -
> -static inline int
> -usb_phy_notify_disconnect(struct usb_phy *x, int port)
> -{
> -	if (x->notify_disconnect)
> -		return x->notify_disconnect(x, port);
> -	else
> -		return 0;
> -}
> -
> -static inline int
>  otg_start_srp(struct usb_otg *otg)
>  {
>  	if (otg && otg->start_srp)
> @@ -306,31 +121,7 @@ otg_start_srp(struct usb_otg *otg)
>  	return -ENOTSUPP;
>  }
> =20
> -/* notifiers */
> -static inline int
> -usb_register_notifier(struct usb_phy *x, struct notifier_block *nb)
> -{
> -	return atomic_notifier_chain_register(&x->notifier, nb);
> -}
> -
> -static inline void
> -usb_unregister_notifier(struct usb_phy *x, struct notifier_block *nb)
> -{
> -	atomic_notifier_chain_unregister(&x->notifier, nb);
> -}
> -
>  /* for OTG controller drivers (and maybe other stuff) */
>  extern int usb_bus_start_enum(struct usb_bus *bus, unsigned port_num);
> =20
> -static inline const char *usb_phy_type_string(enum usb_phy_type type)
> -{
> -	switch (type) {
> -	case USB_PHY_TYPE_USB2:
> -		return "USB2 PHY";
> -	case USB_PHY_TYPE_USB3:
> -		return "USB3 PHY";
> -	default:
> -		return "UNKNOWN PHY TYPE";
> -	}
> -}
>  #endif /* __LINUX_USB_OTG_H */
> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
> new file mode 100644
> index 0000000..5a2bcbe
> --- /dev/null
> +++ b/include/linux/usb/phy.h
> @@ -0,0 +1,222 @@
> +/* USB OTG (On The Go) defines */
> +/*
> + *
> + * These APIs may be used between USB controllers.  USB device drivers
> + * (for either host or peripheral roles) don't use these calls; they
> + * continue to use just usb_device and usb_gadget.
> + */
> +
> +#ifndef __LINUX_USB_PHY_H
> +#define __LINUX_USB_PHY_H
> +
> +#include <linux/notifier.h>
> +
> +enum usb_phy_events {
> +	USB_EVENT_NONE,         /* no events or cable disconnected */
> +	USB_EVENT_VBUS,         /* vbus valid event */
> +	USB_EVENT_ID,           /* id was grounded */
> +	USB_EVENT_CHARGER,      /* usb dedicated charger */
> +	USB_EVENT_ENUMERATED,   /* gadget driver enumerated */
> +};
> +
> +/* associate a type with PHY */
> +enum usb_phy_type {
> +	USB_PHY_TYPE_UNDEFINED,
> +	USB_PHY_TYPE_USB2,
> +	USB_PHY_TYPE_USB3,
> +};
> +
> +struct usb_phy;
> +struct usb_otg;
> +
> +/* for transceivers connected thru an ULPI interface, the user must
> + * provide access ops
> + */
> +struct usb_phy_io_ops {
> +	int (*read)(struct usb_phy *x, u32 reg);
> +	int (*write)(struct usb_phy *x, u32 val, u32 reg);
> +};
> +
> +struct usb_phy {
> +	struct device		*dev;
> +	const char		*label;
> +	unsigned int		 flags;
> +
> +	enum usb_phy_type	type;
> +	enum usb_phy_events	last_event;
> +
> +	struct usb_otg		*otg;
> +
> +	struct device		*io_dev;
> +	struct usb_phy_io_ops	*io_ops;
> +	void __iomem		*io_priv;
> +
> +	/* for notification of usb_phy_events */
> +	struct atomic_notifier_head	notifier;
> +
> +	/* to pass extra port status to the root hub */
> +	u16			port_status;
> +	u16			port_change;
> +
> +	/* to support controllers that have multiple transceivers */
> +	struct list_head	head;
> +
> +	/* initialize/shutdown the OTG controller */
> +	int	(*init)(struct usb_phy *x);
> +	void	(*shutdown)(struct usb_phy *x);
> +
> +	/* effective for B devices, ignored for A-peripheral */
> +	int	(*set_power)(struct usb_phy *x,
> +				unsigned mA);
> +
> +	/* for non-OTG B devices: set transceiver into suspend mode */
> +	int	(*set_suspend)(struct usb_phy *x,
> +				int suspend);
> +
> +	/* notify phy connect status change */
> +	int	(*notify_connect)(struct usb_phy *x, int port);
> +	int	(*notify_disconnect)(struct usb_phy *x, int port);
> +};
> +
> +
> +/* for board-specific init logic */
> +extern int usb_add_phy(struct usb_phy *, enum usb_phy_type type);
> +extern void usb_remove_phy(struct usb_phy *);
> +
> +#if defined(CONFIG_NOP_USB_XCEIV) || (defined(CONFIG_NOP_USB_XCEIV_MODUL=
E) && defined(MODULE))
> +/* sometimes transceivers are accessed only through e.g. ULPI */
> +extern void usb_nop_xceiv_register(void);
> +extern void usb_nop_xceiv_unregister(void);
> +#else
> +static inline void usb_nop_xceiv_register(void)
> +{
> +}
> +
> +static inline void usb_nop_xceiv_unregister(void)
> +{
> +}
> +#endif
> +
> +/* helpers for direct access thru low-level io interface */
> +static inline int usb_phy_io_read(struct usb_phy *x, u32 reg)
> +{
> +	if (x->io_ops && x->io_ops->read)
> +		return x->io_ops->read(x, reg);
> +
> +	return -EINVAL;
> +}
> +
> +static inline int usb_phy_io_write(struct usb_phy *x, u32 val, u32 reg)
> +{
> +	if (x->io_ops && x->io_ops->write)
> +		return x->io_ops->write(x, val, reg);
> +
> +	return -EINVAL;
> +}
> +
> +static inline int
> +usb_phy_init(struct usb_phy *x)
> +{
> +	if (x->init)
> +		return x->init(x);
> +
> +	return 0;
> +}
> +
> +static inline void
> +usb_phy_shutdown(struct usb_phy *x)
> +{
> +	if (x->shutdown)
> +		x->shutdown(x);
> +}
> +
> +/* for usb host and peripheral controller drivers */
> +#ifdef CONFIG_USB_OTG_UTILS
> +extern struct usb_phy *usb_get_phy(enum usb_phy_type type);
> +extern struct usb_phy *devm_usb_get_phy(struct device *dev,
> +	enum usb_phy_type type);
> +extern void usb_put_phy(struct usb_phy *);
> +extern void devm_usb_put_phy(struct device *dev, struct usb_phy *x);
> +#else
> +static inline struct usb_phy *usb_get_phy(enum usb_phy_type type)
> +{
> +	return NULL;
> +}
> +
> +static inline struct usb_phy *devm_usb_get_phy(struct device *dev,
> +	enum usb_phy_type type)
> +{
> +	return NULL;
> +}
> +
> +static inline void usb_put_phy(struct usb_phy *x)
> +{
> +}
> +
> +static inline void devm_usb_put_phy(struct device *dev, struct usb_phy *=
x)
> +{
> +}
> +
> +#endif
> +
> +static inline int
> +usb_phy_set_power(struct usb_phy *x, unsigned mA)
> +{
> +	if (x && x->set_power)
> +		return x->set_power(x, mA);
> +	return 0;
> +}
> +
> +/* Context: can sleep */
> +static inline int
> +usb_phy_set_suspend(struct usb_phy *x, int suspend)
> +{
> +	if (x->set_suspend !=3D NULL)
> +		return x->set_suspend(x, suspend);
> +	else
> +		return 0;
> +}
> +
> +static inline int
> +usb_phy_notify_connect(struct usb_phy *x, int port)
> +{
> +	if (x->notify_connect)
> +		return x->notify_connect(x, port);
> +	else
> +		return 0;
> +}
> +
> +static inline int
> +usb_phy_notify_disconnect(struct usb_phy *x, int port)
> +{
> +	if (x->notify_disconnect)
> +		return x->notify_disconnect(x, port);
> +	else
> +		return 0;
> +}
> +
> +/* notifiers */
> +static inline int
> +usb_register_notifier(struct usb_phy *x, struct notifier_block *nb)
> +{
> +	return atomic_notifier_chain_register(&x->notifier, nb);
> +}
> +
> +static inline void
> +usb_unregister_notifier(struct usb_phy *x, struct notifier_block *nb)
> +{
> +	atomic_notifier_chain_unregister(&x->notifier, nb);
> +}
> +
> +static inline const char *usb_phy_type_string(enum usb_phy_type type)
> +{
> +	switch (type) {
> +	case USB_PHY_TYPE_USB2:
> +		return "USB2 PHY";
> +	case USB_PHY_TYPE_USB3:
> +		return "USB3 PHY";
> +	default:
> +		return "UNKNOWN PHY TYPE";
> +	}
> +}
> +#endif /* __LINUX_USB_PHY_H */
> --=20
> 1.7.1.1
>=20

--=20
balbi

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQPM4pAAoJEIaOsuA1yqREUToQAJD6tTxcQrBtUsAcrwgvmIK8
SU7vXi+QIhLtYkvrdOc4zTztwSD0E61Jp/lx+WuQZJ3d/UgosjkJHB1tAzMCpn77
IAt3lOoHP7AnR6h8lnd4OfsP03mftcjZPYat6c8CosISmxyvkJdELstl598aECRk
SZgyPdwj5BYEACohCd6iM6Re+qXcnH/RfPeSlwrIqN1Oe9TmmIQ1YYmi7GkHxMgQ
ZtcB6PNpqvKdozg+6c+zfye7H8Bu1cG3ppK/oHgeJX5h40TinTl9z0SwF8Xdz+ue
0nfDhxykoN+ogf2sXU4ph3p4vVlz+mo4D6ww7bkfbJhtvaPxAtAmDKK7OdNsivV+
c8MpIn57IrvqWXCfy8riC/f7PhuYv3FZRrRFxYjtUCxMNieBwbz0N98+LH3/2/lH
Wg6kLJKi87qiNRout1hQFsIzDwznrMThqRqW0wOQIhNRLONmM+unH4P4UXhg8AKW
+RHx+nDEGhxZTFW4CzmKRSOrJLDa4CRWTErNz/7BxKVHv+5jszbR8cGRnIpx+tHv
R9fbj5S5eCUCnqNB+NUjP7R8m98zlplu5rRQG/kR6wyofIQGoFjsNL57ZazeIsDu
Snxpd96CLALnwFdgpGFgE4TgvDtiY5Ik7ftPFWBMlczel3Nr54Ikomu//FB+h30f
DV3tHhVVGM89bsGoOY+D
=wq4b
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
