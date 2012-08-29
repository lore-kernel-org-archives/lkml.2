Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab2H2G4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 02:56:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5105 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2H2G4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 02:56:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 28 Aug 2012 23:56:40 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Peter Chen <hzpeterchen@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Wed, 29 Aug 2012 12:26:34 +0530
Subject: RE: [PATCH] usb: otg: Move phy interface to separate file.
Thread-Topic: [PATCH] usb: otg: Move phy interface to separate file.
Thread-Index: Ac2FijNoFbhDHzufQbC0vqtmBIoT9QAKSceQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDE14DDF2@BGMAIL02.nvidia.com>
References: <1346156411-20761-1-git-send-email-vbyravarasu@nvidia.com>
 <CAL411-pBpa=x5m5-yGw_i3=4ug4a3rBajwS8_SoFYUAb52pTKA@mail.gmail.com>
In-Reply-To: <CAL411-pBpa=x5m5-yGw_i3=4ug4a3rBajwS8_SoFYUAb52pTKA@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Peter Chen [mailto:hzpeterchen@gmail.com]
> Sent: Wednesday, August 29, 2012 7:30 AM
> To: Venu Byravarasu
> Cc: gregkh@linuxfoundation.org; balbi@ti.com; linux-
> kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH] usb: otg: Move phy interface to separate file.
>
> >
> >  #include <linux/notifier.h>
> > +#include <linux/usb/phy.h>
> >
> one small thing:  <linux/notifier.h> is only needed at phy.h.

Thanks Peter, for your comment.
Will send an updated patch.

>
> >  /* OTG defines lots of enumeration states before device reset */
> >  enum usb_otg_state {
> > @@ -35,31 +36,6 @@ enum usb_otg_state {
> >         OTG_STATE_A_VBUS_ERR,
> >  };
> >
> > -enum usb_phy_events {
> > -       USB_EVENT_NONE,         /* no events or cable disconnected */
> > -       USB_EVENT_VBUS,         /* vbus valid event */
> > -       USB_EVENT_ID,           /* id was grounded */
> > -       USB_EVENT_CHARGER,      /* usb dedicated charger */
> > -       USB_EVENT_ENUMERATED,   /* gadget driver enumerated */
> > -};
> > -
> > -/* associate a type with PHY */
> > -enum usb_phy_type {
> > -       USB_PHY_TYPE_UNDEFINED,
> > -       USB_PHY_TYPE_USB2,
> > -       USB_PHY_TYPE_USB3,
> > -};
> > -
> > -struct usb_phy;
> > -
> > -/* for transceivers connected thru an ULPI interface, the user must
> > - * provide access ops
> > - */
> > -struct usb_phy_io_ops {
> > -       int (*read)(struct usb_phy *x, u32 reg);
> > -       int (*write)(struct usb_phy *x, u32 val, u32 reg);
> > -};
> > -
> >  struct usb_otg {
> >         u8                      default_a;
> >
> > @@ -85,134 +61,9 @@ struct usb_otg {
> >
> >  };
> >
> > -/*
> > - * the otg driver needs to interact with both device side and host side
> > - * usb controllers.  it decides which controller is active at a given
> > - * moment, using the transceiver, ID signal, HNP and sometimes static
> > - * configuration information (including "board isn't wired for otg").
> > - */
> > -struct usb_phy {
> > -       struct device           *dev;
> > -       const char              *label;
> > -       unsigned int             flags;
> > -
> > -       enum usb_phy_type       type;
> > -       enum usb_otg_state      state;
> > -       enum usb_phy_events     last_event;
> > -
> > -       struct usb_otg          *otg;
> > -
> > -       struct device           *io_dev;
> > -       struct usb_phy_io_ops   *io_ops;
> > -       void __iomem            *io_priv;
> > -
> > -       /* for notification of usb_phy_events */
> > -       struct atomic_notifier_head     notifier;
> > -
> > -       /* to pass extra port status to the root hub */
> > -       u16                     port_status;
> > -       u16                     port_change;
> > -
> > -       /* to support controllers that have multiple transceivers */
> > -       struct list_head        head;
> > -
> > -       /* initialize/shutdown the OTG controller */
> > -       int     (*init)(struct usb_phy *x);
> > -       void    (*shutdown)(struct usb_phy *x);
> > -
> > -       /* effective for B devices, ignored for A-peripheral */
> > -       int     (*set_power)(struct usb_phy *x,
> > -                               unsigned mA);
> > -
> > -       /* for non-OTG B devices: set transceiver into suspend mode */
> > -       int     (*set_suspend)(struct usb_phy *x,
> > -                               int suspend);
> > -
> > -       /* notify phy connect status change */
> > -       int     (*notify_connect)(struct usb_phy *x, int port);
> > -       int     (*notify_disconnect)(struct usb_phy *x, int port);
> > -};
> > -
> > -
> > -/* for board-specific init logic */
> > -extern int usb_add_phy(struct usb_phy *, enum usb_phy_type type);
> > -extern void usb_remove_phy(struct usb_phy *);
> > -
> > -#if defined(CONFIG_NOP_USB_XCEIV) ||
> (defined(CONFIG_NOP_USB_XCEIV_MODULE) && defined(MODULE))
> > -/* sometimes transceivers are accessed only through e.g. ULPI */
> > -extern void usb_nop_xceiv_register(void);
> > -extern void usb_nop_xceiv_unregister(void);
> > -#else
> > -static inline void usb_nop_xceiv_register(void)
> > -{
> > -}
> > -
> > -static inline void usb_nop_xceiv_unregister(void)
> > -{
> > -}
> > -#endif
> > -
> > -/* helpers for direct access thru low-level io interface */
> > -static inline int usb_phy_io_read(struct usb_phy *x, u32 reg)
> > -{
> > -       if (x->io_ops && x->io_ops->read)
> > -               return x->io_ops->read(x, reg);
> > -
> > -       return -EINVAL;
> > -}
> > -
> > -static inline int usb_phy_io_write(struct usb_phy *x, u32 val, u32 reg)
> > -{
> > -       if (x->io_ops && x->io_ops->write)
> > -               return x->io_ops->write(x, val, reg);
> > -
> > -       return -EINVAL;
> > -}
> > -
> > -static inline int
> > -usb_phy_init(struct usb_phy *x)
> > -{
> > -       if (x->init)
> > -               return x->init(x);
> > -
> > -       return 0;
> > -}
> > -
> > -static inline void
> > -usb_phy_shutdown(struct usb_phy *x)
> > -{
> > -       if (x->shutdown)
> > -               x->shutdown(x);
> > -}
> > -
> > -/* for usb host and peripheral controller drivers */
> >  #ifdef CONFIG_USB_OTG_UTILS
> > -extern struct usb_phy *usb_get_phy(enum usb_phy_type type);
> > -extern struct usb_phy *devm_usb_get_phy(struct device *dev,
> > -       enum usb_phy_type type);
> > -extern void usb_put_phy(struct usb_phy *);
> > -extern void devm_usb_put_phy(struct device *dev, struct usb_phy *x);
> >  extern const char *otg_state_string(enum usb_otg_state state);
> >  #else
> > -static inline struct usb_phy *usb_get_phy(enum usb_phy_type type)
> > -{
> > -       return NULL;
> > -}
> > -
> > -static inline struct usb_phy *devm_usb_get_phy(struct device *dev,
> > -       enum usb_phy_type type)
> > -{
> > -       return NULL;
> > -}
> > -
> > -static inline void usb_put_phy(struct usb_phy *x)
> > -{
> > -}
> > -
> > -static inline void devm_usb_put_phy(struct device *dev, struct usb_phy
> *x)
> > -{
> > -}
> > -
> >  static inline const char *otg_state_string(enum usb_otg_state state)
> >  {
> >         return NULL;
> > @@ -262,42 +113,6 @@ otg_set_peripheral(struct usb_otg *otg, struct
> usb_gadget *periph)
> >  }
> >
> >  static inline int
> > -usb_phy_set_power(struct usb_phy *x, unsigned mA)
> > -{
> > -       if (x && x->set_power)
> > -               return x->set_power(x, mA);
> > -       return 0;
> > -}
> > -
> > -/* Context: can sleep */
> > -static inline int
> > -usb_phy_set_suspend(struct usb_phy *x, int suspend)
> > -{
> > -       if (x->set_suspend != NULL)
> > -               return x->set_suspend(x, suspend);
> > -       else
> > -               return 0;
> > -}
> > -
> > -static inline int
> > -usb_phy_notify_connect(struct usb_phy *x, int port)
> > -{
> > -       if (x->notify_connect)
> > -               return x->notify_connect(x, port);
> > -       else
> > -               return 0;
> > -}
> > -
> > -static inline int
> > -usb_phy_notify_disconnect(struct usb_phy *x, int port)
> > -{
> > -       if (x->notify_disconnect)
> > -               return x->notify_disconnect(x, port);
> > -       else
> > -               return 0;
> > -}
> > -
> > -static inline int
> >  otg_start_srp(struct usb_otg *otg)
> >  {
> >         if (otg && otg->start_srp)
> > @@ -306,31 +121,7 @@ otg_start_srp(struct usb_otg *otg)
> >         return -ENOTSUPP;
> >  }
> >
> > -/* notifiers */
> > -static inline int
> > -usb_register_notifier(struct usb_phy *x, struct notifier_block *nb)
> > -{
> > -       return atomic_notifier_chain_register(&x->notifier, nb);
> > -}
> > -
> > -static inline void
> > -usb_unregister_notifier(struct usb_phy *x, struct notifier_block *nb)
> > -{
> > -       atomic_notifier_chain_unregister(&x->notifier, nb);
> > -}
> > -
> >  /* for OTG controller drivers (and maybe other stuff) */
> >  extern int usb_bus_start_enum(struct usb_bus *bus, unsigned port_num);
> >
> > -static inline const char *usb_phy_type_string(enum usb_phy_type type)
> > -{
> > -       switch (type) {
> > -       case USB_PHY_TYPE_USB2:
> > -               return "USB2 PHY";
> > -       case USB_PHY_TYPE_USB3:
> > -               return "USB3 PHY";
> > -       default:
> > -               return "UNKNOWN PHY TYPE";
> > -       }
> > -}
> >  #endif /* __LINUX_USB_OTG_H */
> > diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
> > new file mode 100644
> > index 0000000..5a2bcbe
> > --- /dev/null
> > +++ b/include/linux/usb/phy.h
> > @@ -0,0 +1,222 @@
> > +/* USB OTG (On The Go) defines */
> > +/*
> > + *
> > + * These APIs may be used between USB controllers.  USB device drivers
> > + * (for either host or peripheral roles) don't use these calls; they
> > + * continue to use just usb_device and usb_gadget.
> > + */
> > +
> > +#ifndef __LINUX_USB_PHY_H
> > +#define __LINUX_USB_PHY_H
> > +
> > +#include <linux/notifier.h>
> > +
> > +enum usb_phy_events {
> > +       USB_EVENT_NONE,         /* no events or cable disconnected */
> > +       USB_EVENT_VBUS,         /* vbus valid event */
> > +       USB_EVENT_ID,           /* id was grounded */
> > +       USB_EVENT_CHARGER,      /* usb dedicated charger */
> > +       USB_EVENT_ENUMERATED,   /* gadget driver enumerated */
> > +};
> > +
> > +/* associate a type with PHY */
> > +enum usb_phy_type {
> > +       USB_PHY_TYPE_UNDEFINED,
> > +       USB_PHY_TYPE_USB2,
> > +       USB_PHY_TYPE_USB3,
> > +};
> > +
> > +struct usb_phy;
> > +struct usb_otg;
> > +
> > +/* for transceivers connected thru an ULPI interface, the user must
> > + * provide access ops
> > + */
> > +struct usb_phy_io_ops {
> > +       int (*read)(struct usb_phy *x, u32 reg);
> > +       int (*write)(struct usb_phy *x, u32 val, u32 reg);
> > +};
> > +
> > +struct usb_phy {
> > +       struct device           *dev;
> > +       const char              *label;
> > +       unsigned int             flags;
> > +
> > +       enum usb_phy_type       type;
> > +       enum usb_phy_events     last_event;
> > +
> > +       struct usb_otg          *otg;
> > +
> > +       struct device           *io_dev;
> > +       struct usb_phy_io_ops   *io_ops;
> > +       void __iomem            *io_priv;
> > +
> > +       /* for notification of usb_phy_events */
> > +       struct atomic_notifier_head     notifier;
> > +
> > +       /* to pass extra port status to the root hub */
> > +       u16                     port_status;
> > +       u16                     port_change;
> > +
> > +       /* to support controllers that have multiple transceivers */
> > +       struct list_head        head;
> > +
> > +       /* initialize/shutdown the OTG controller */
> > +       int     (*init)(struct usb_phy *x);
> > +       void    (*shutdown)(struct usb_phy *x);
> > +
> > +       /* effective for B devices, ignored for A-peripheral */
> > +       int     (*set_power)(struct usb_phy *x,
> > +                               unsigned mA);
> > +
> > +       /* for non-OTG B devices: set transceiver into suspend mode */
> > +       int     (*set_suspend)(struct usb_phy *x,
> > +                               int suspend);
> > +
> > +       /* notify phy connect status change */
> > +       int     (*notify_connect)(struct usb_phy *x, int port);
> > +       int     (*notify_disconnect)(struct usb_phy *x, int port);
> > +};
> > +
> > +
> > +/* for board-specific init logic */
> > +extern int usb_add_phy(struct usb_phy *, enum usb_phy_type type);
> > +extern void usb_remove_phy(struct usb_phy *);
> > +
> > +#if defined(CONFIG_NOP_USB_XCEIV) ||
> (defined(CONFIG_NOP_USB_XCEIV_MODULE) && defined(MODULE))
> > +/* sometimes transceivers are accessed only through e.g. ULPI */
> > +extern void usb_nop_xceiv_register(void);
> > +extern void usb_nop_xceiv_unregister(void);
> > +#else
> > +static inline void usb_nop_xceiv_register(void)
> > +{
> > +}
> > +
> > +static inline void usb_nop_xceiv_unregister(void)
> > +{
> > +}
> > +#endif
> > +
> > +/* helpers for direct access thru low-level io interface */
> > +static inline int usb_phy_io_read(struct usb_phy *x, u32 reg)
> > +{
> > +       if (x->io_ops && x->io_ops->read)
> > +               return x->io_ops->read(x, reg);
> > +
> > +       return -EINVAL;
> > +}
> > +
> > +static inline int usb_phy_io_write(struct usb_phy *x, u32 val, u32 reg)
> > +{
> > +       if (x->io_ops && x->io_ops->write)
> > +               return x->io_ops->write(x, val, reg);
> > +
> > +       return -EINVAL;
> > +}
> > +
> > +static inline int
> > +usb_phy_init(struct usb_phy *x)
> > +{
> > +       if (x->init)
> > +               return x->init(x);
> > +
> > +       return 0;
> > +}
> > +
> > +static inline void
> > +usb_phy_shutdown(struct usb_phy *x)
> > +{
> > +       if (x->shutdown)
> > +               x->shutdown(x);
> > +}
> > +
> > +/* for usb host and peripheral controller drivers */
> > +#ifdef CONFIG_USB_OTG_UTILS
> > +extern struct usb_phy *usb_get_phy(enum usb_phy_type type);
> > +extern struct usb_phy *devm_usb_get_phy(struct device *dev,
> > +       enum usb_phy_type type);
> > +extern void usb_put_phy(struct usb_phy *);
> > +extern void devm_usb_put_phy(struct device *dev, struct usb_phy *x);
> > +#else
> > +static inline struct usb_phy *usb_get_phy(enum usb_phy_type type)
> > +{
> > +       return NULL;
> > +}
> > +
> > +static inline struct usb_phy *devm_usb_get_phy(struct device *dev,
> > +       enum usb_phy_type type)
> > +{
> > +       return NULL;
> > +}
> > +
> > +static inline void usb_put_phy(struct usb_phy *x)
> > +{
> > +}
> > +
> > +static inline void devm_usb_put_phy(struct device *dev, struct usb_phy
> *x)
> > +{
> > +}
> > +
> > +#endif
> > +
> > +static inline int
> > +usb_phy_set_power(struct usb_phy *x, unsigned mA)
> > +{
> > +       if (x && x->set_power)
> > +               return x->set_power(x, mA);
> > +       return 0;
> > +}
> > +
> > +/* Context: can sleep */
> > +static inline int
> > +usb_phy_set_suspend(struct usb_phy *x, int suspend)
> > +{
> > +       if (x->set_suspend != NULL)
> > +               return x->set_suspend(x, suspend);
> > +       else
> > +               return 0;
> > +}
> > +
> > +static inline int
> > +usb_phy_notify_connect(struct usb_phy *x, int port)
> > +{
> > +       if (x->notify_connect)
> > +               return x->notify_connect(x, port);
> > +       else
> > +               return 0;
> > +}
> > +
> > +static inline int
> > +usb_phy_notify_disconnect(struct usb_phy *x, int port)
> > +{
> > +       if (x->notify_disconnect)
> > +               return x->notify_disconnect(x, port);
> > +       else
> > +               return 0;
> > +}
> > +
> > +/* notifiers */
> > +static inline int
> > +usb_register_notifier(struct usb_phy *x, struct notifier_block *nb)
> > +{
> > +       return atomic_notifier_chain_register(&x->notifier, nb);
> > +}
> > +
> > +static inline void
> > +usb_unregister_notifier(struct usb_phy *x, struct notifier_block *nb)
> > +{
> > +       atomic_notifier_chain_unregister(&x->notifier, nb);
> > +}
> > +
> > +static inline const char *usb_phy_type_string(enum usb_phy_type type)
> > +{
> > +       switch (type) {
> > +       case USB_PHY_TYPE_USB2:
> > +               return "USB2 PHY";
> > +       case USB_PHY_TYPE_USB3:
> > +               return "USB3 PHY";
> > +       default:
> > +               return "UNKNOWN PHY TYPE";
> > +       }
> > +}
> > +#endif /* __LINUX_USB_PHY_H */
> > --
> > 1.7.1.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
