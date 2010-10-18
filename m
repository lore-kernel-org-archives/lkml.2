Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab0JRUKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:10:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62953 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab0JRUKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:10:24 -0400
Date: Mon, 18 Oct 2010 18:10:14 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: "marcel@holtmann.org" <marcel@holtmann.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth: btwilink driver
Message-ID: <20101018201014.GH2468@vigoh>
References: <1287176299-19313-1-git-send-email-pavan_savoy@ti.com>
 <20101018194811.GG2468@vigoh>
 <19F8576C6E063C45BE387C64729E739404AA4E759A@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E739404AA4E759A@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Savoy, Pavan <pavan_savoy@ti.com> [2010-10-19 01:23:54 +0530]:

> 
> > -----Original Message-----
> > From: Gustavo F. Padovan [mailto:pao@profusion.mobi] On Behalf Of Gustavo F.
> > Padovan
> > Sent: Monday, October 18, 2010 2:48 PM
> > To: Savoy, Pavan
> > Cc: marcel@holtmann.org; linux-bluetooth@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH] Bluetooth: btwilink driver
> >
> > Hi Pavan,
> >
> > * pavan_savoy@ti.com <pavan_savoy@ti.com> [2010-10-15 16:58:19 -0400]:
> >
> > > From: Pavan Savoy <pavan_savoy@ti.com>
> > >
> > > Gustavo, Marcel,
> > >
> > > Renaming the patch, since the driver is renamed to btwilink.
> > > Thanks for the comments,
> > > Please review and provide your comments on this version of patch,
> > >
> > > -- patch description --
> > >
> > > This is the bluetooth protocol driver for the TI WiLink7 chipsets.
> > > Texas Instrument's WiLink chipsets combine wireless technologies
> > > like BT, FM, GPS and WLAN onto a single chip.
> > >
> > > This Bluetooth driver works on top of the TI_ST shared transport
> > > line discipline driver which also allows other drivers like
> > > FM V4L2 and GPS character driver to make use of the same UART interface.
> > >
> > > Kconfig and Makefile modifications to enable the Bluetooth
> > > driver for Texas Instrument's WiLink 7 chipset.
> > >
> > > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > > ---
> > >  drivers/bluetooth/Kconfig    |   10 +
> > >  drivers/bluetooth/Makefile   |    1 +
> > >  drivers/bluetooth/btwilink.c |  424
> > ++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 435 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/bluetooth/btwilink.c
> > >
> > > diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> > > index 02deef4..e0d67dd 100644
> > > --- a/drivers/bluetooth/Kconfig
> > > +++ b/drivers/bluetooth/Kconfig
> > > @@ -219,4 +219,14 @@ config BT_ATH3K
> > >       Say Y here to compile support for "Atheros firmware download driver"
> > >       into the kernel or say M to compile it as module (ath3k).
> > >
> > > +config BT_WILINK
> > > +   tristate "BlueZ bluetooth driver for TI ST"
> > > +   depends on TI_ST
> > > +   help
> > > +     This enables the Bluetooth driver for Texas Instrument's BT/FM/GPS
> > > +     combo devices. This makes use of shared transport line discipline
> > > +     core driver to communicate with the BT core of the combo chip.
> > > +
> > > +     Say Y here to compile support for Texas Instrument's WiLink7 driver
> > > +     into the kernel or say M to compile it as module.
> > >  endmenu
> > > diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> > > index 71bdf13..f4460f4 100644
> > > --- a/drivers/bluetooth/Makefile
> > > +++ b/drivers/bluetooth/Makefile
> > > @@ -18,6 +18,7 @@ obj-$(CONFIG_BT_HCIBTSDIO)        += btsdio.o
> > >  obj-$(CONFIG_BT_ATH3K)             += ath3k.o
> > >  obj-$(CONFIG_BT_MRVL)              += btmrvl.o
> > >  obj-$(CONFIG_BT_MRVL_SDIO) += btmrvl_sdio.o
> > > +obj-$(CONFIG_BT_WILINK)            += btwilink.o
> > >
> > >  btmrvl-y                   := btmrvl_main.o
> > >  btmrvl-$(CONFIG_DEBUG_FS)  += btmrvl_debugfs.o
> > > diff --git a/drivers/bluetooth/btwilink.c b/drivers/bluetooth/btwilink.c
> > > new file mode 100644
> > > index 0000000..f67791f
> > > --- /dev/null
> > > +++ b/drivers/bluetooth/btwilink.c
> > > @@ -0,0 +1,424 @@
> > > +/*
> > > + *  Texas Instrument's Bluetooth Driver For Shared Transport.
> > > + *
> > > + *  Bluetooth Driver acts as interface between HCI CORE and
> > > + *  TI Shared Transport Layer.
> > > + *
> > > + *  Copyright (C) 2009-2010 Texas Instruments
> > > + *  Author: Raja Mani <raja_mani@ti.com>
> > > + * Pavan Savoy <pavan_savoy@ti.com>
> > > + *
> > > + *  This program is free software; you can redistribute it and/or modify
> > > + *  it under the terms of the GNU General Public License version 2 as
> > > + *  published by the Free Software Foundation.
> > > + *
> > > + *  This program is distributed in the hope that it will be useful,
> > > + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + *  GNU General Public License for more details.
> > > + *
> > > + *  You should have received a copy of the GNU General Public License
> > > + *  along with this program; if not, write to the Free Software
> > > + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
> > USA
> > > + *
> > > + */
> > > +
> > > +#include <linux/platform_device.h>
> > > +#include <net/bluetooth/bluetooth.h>
> > > +#include <net/bluetooth/hci_core.h>
> > > +
> > > +#include <linux/ti_wilink_st.h>
> > > +
> > > +/* Bluetooth Driver Version */
> > > +#define VERSION               "1.0"
> > > +
> > > +/* Defines number of seconds to wait for reg completion
> > > + * callback getting called from ST (in case,registration
> > > + * with ST returns PENDING status)
> > > + */
> > > +#define BT_REGISTER_TIMEOUT   6000 /* 6 sec */
> > > +
> > > +/**
> > > + * struct ti_st - BT driver operation structure
> > > + * @hdev: hci device pointer which binds to bt driver
> > > + * @flags: used locally,to maintain various BT driver status
> > > + * @streg_cbdata: to hold ST registration callback status
> > > + * @st_write: write function pointer of ST driver
> > > + * @wait_reg_completion - completion sync between ti_st_open
> > > + * and ti_st_registration_completion_cb.
> > > + */
> > > +struct ti_st {
> > > +   struct hci_dev *hdev;
> > > +   char streg_cbdata;
> > > +   long (*st_write) (struct sk_buff *);
> > > +   struct completion wait_reg_completion;
> > > +};
> > > +
> > > +static int reset;
> > > +
> > > +/* Increments HCI counters based on pocket ID (cmd,acl,sco) */
> > > +static inline void ti_st_tx_complete(struct ti_st *hst, int pkt_type)
> > > +{
> > > +   struct hci_dev *hdev;
> > > +   hdev = hst->hdev;
> > > +
> > > +   /* Update HCI stat counters */
> > > +   switch (pkt_type) {
> > > +   case HCI_COMMAND_PKT:
> > > +           hdev->stat.cmd_tx++;
> > > +           break;
> > > +
> > > +   case HCI_ACLDATA_PKT:
> > > +           hdev->stat.acl_tx++;
> > > +           break;
> > > +
> > > +   case HCI_SCODATA_PKT:
> > > +           hdev->stat.sco_tx++;
> > > +           break;
> > > +   }
> > > +}
> > > +
> > > +/* ------- Interfaces to Shared Transport ------ */
> > > +
> > > +/* Called by ST layer to indicate protocol registration completion
> > > + * status.ti_st_open() function will wait for signal from this
> > > + * API when st_register() function returns ST_PENDING.
> > > + */
> > > +static void st_registration_completion_cb(void *priv_data, char data)
> > > +{
> > > +   struct ti_st *lhst = (struct ti_st *)priv_data;
> >
> > Blank line here.
> >
> > > +   /* ti_st_open() function needs value of 'data' to know
> > > +    * the registration status(success/fail),So have a back
> > > +    * up of it.
> > > +    */
> > > +   lhst->streg_cbdata = data;
> > > +
> > > +   /* Got a feedback from ST for BT driver registration
> > > +    * request.Wackup ti_st_open() function to continue
> > > +    * it's open operation.
> > > +    */
> > > +   complete(&lhst->wait_reg_completion);
> > > +}
> > > +
> > > +/* Called by Shared Transport layer when receive data is
> > > + * available */
> > > +static long st_receive(void *priv_data, struct sk_buff *skb)
> > > +{
> > > +   int err;
> > > +   struct ti_st *lhst = (struct ti_st *)priv_data;
> > > +
> > > +   if (!skb)
> > > +           return -EFAULT;
> > > +
> > > +   if (!lhst) {
> > > +           kfree_skb(skb);
> > > +           return -EFAULT;
> > > +   }
> > > +
> > > +   skb->dev = (struct net_device *)lhst->hdev;
> > > +
> > > +   /* Forward skb to HCI CORE layer */
> > > +   err = hci_recv_frame(skb);
> > > +   if (err) {
> > > +           kfree_skb(skb);
> > > +           BT_ERR("Unable to push skb to HCI CORE(%d)", err);
> >
> > s/CORE/core/
> >
> > > +           return err;
> > > +   }
> > > +
> > > +   lhst->hdev->stat.byte_rx += skb->len;
> > > +   return 0;
> > > +}
> > > +
> > > +/* ------- Interfaces to HCI layer ------ */
> > > +/* protocol structure registered with shared transport */
> > > +static struct st_proto_s ti_st_proto = {
> > > +   .type = ST_BT,
> > > +   .recv = st_receive,
> > > +   .reg_complete_cb = st_registration_completion_cb,
> > > +   .priv_data = NULL,
> > > +};
> > > +
> > > +/* Called from HCI core to initialize the device */
> > > +static int ti_st_open(struct hci_dev *hdev)
> > > +{
> > > +   unsigned long timeleft;
> > > +   struct ti_st *hst;
> > > +   int err;
> > > +
> > > +   BT_DBG("%s %p", hdev->name, hdev);
> > > +
> > > +   /* provide contexts for callbacks from ST */
> > > +   hst = hdev->driver_data;
> > > +   ti_st_proto.priv_data = hst;
> > > +
> > > +   err = st_register(&ti_st_proto);
> > > +   if (err == -EINPROGRESS) {
> > > +           /* Prepare wait-for-completion handler data structures.
> > > +            * Needed to syncronize this and st_registration_completion_cb()
> > > +            * functions.
> > > +            */
> > > +           init_completion(&hst->wait_reg_completion);
> > > +
> > > +           /* Reset ST registration callback status flag , this value
> > > +            * will be updated in ti_st_registration_completion_cb()
> > > +            * function whenever it called from ST driver.
> > > +            */
> > > +           hst->streg_cbdata = -EINPROGRESS;
> > > +
> > > +           /* ST is busy with other protocol registration(may be busy with
> > > +            * firmware download).So,Wait till the registration callback
> > > +            * (passed as a argument to st_register() function) getting
> > > +            * called from ST.
> > > +            */
> > > +           BT_DBG(" waiting for reg completion signal from ST");
> > > +
> > > +           timeleft = wait_for_completion_timeout
> > > +                   (&hst->wait_reg_completion,
> > > +                    msecs_to_jiffies(BT_REGISTER_TIMEOUT));
> > > +           if (!timeleft) {
> > > +                   BT_ERR("Timeout(%d sec),didn't get reg"
> > > +                                   "completion signal from ST",
> > > +                                   BT_REGISTER_TIMEOUT / 1000);
> >
> > How does this get printed. "...regcompletion..." ?
> >
> > > +                   return -ETIMEDOUT;
> > > +           }
> > > +
> > > +           /* Is ST registration callback called with ERROR value? */
> > > +           if (hst->streg_cbdata != 0) {
> > > +                   BT_ERR("ST reg completion CB called with invalid"
> > > +                                   "status %d", hst->streg_cbdata);
> > > +                   return -EAGAIN;
> > > +           }
> > > +           err = 0;
> > > +   } else if (err == -EPERM) {
> > > +           BT_ERR("st_register failed %d", err);
> > > +           return -EAGAIN;
> >
> > Why? if -EPERM return -EAGAIN?
> >
> > > +   }
> > > +
> > > +   /* Do we have proper ST write function? */
> > > +   if (ti_st_proto.write != NULL) {
> > > +           /* We need this pointer for sending any Bluetooth pkts */
> > > +           hst->st_write = ti_st_proto.write;
> >
> > I asked in the other e-mail:  Who sets ti_st_proto.write()? I didn't get
> > this.
> 
> The write function is set by the TI-ST driver.
> This was in order to avoid another EXPORT_SYMBOL(st_write) or so.
> So, as soon as some protocol driver registers to shared transport driver, the
> registration function inside the driver will set it's write function to this
> function pointer.

The usual approach is to export the symbol and use it inside your
driver. That is what most of our drivers do (if not all of them).
So I recommend you to change that in your driver.

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
