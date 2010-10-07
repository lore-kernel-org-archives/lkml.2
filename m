Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661Ab0JGO7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:59:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46774 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab0JGO7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 10:59:43 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 7 Oct 2010 20:29:31 +0530
Subject: RE: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Thread-Topic: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Thread-Index: ActmBzyyRd9GHjrLSZWqLVhrbuc8SgAKA3rQ
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21D19E@dbde02.ent.ti.com>
References: <1286404493-23816-1-git-send-email-pavan-savoy@ti.com>
	 <1286404493-23816-2-git-send-email-pavan-savoy@ti.com>
 <1286445948.6145.70.camel@aeonflux>
In-Reply-To: <1286445948.6145.70.camel@aeonflux>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Marcel Holtmann [mailto:marcel@holtmann.org]
> Sent: Thursday, October 07, 2010 5:06 AM
> To: pavan-savoy@ti.com
> Cc: linux-bluetooth@vger.kernel.org; johan.hedberg@gmail.com; greg@kroah.com;
> linux-kernel@vger.kernel.org; Savoy, Pavan
> Subject: Re: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
>
> Hi Pavan,
>
> > This is the bluetooth protocol driver for the TI WiLink7 chipsets.
> > Texas Instrument's WiLink chipsets combine wireless technologies
> > like BT, FM, GPS and WLAN onto a single chip.
> >
> > This Bluetooth driver works on top of the TI_ST shared transport
> > line discipline driver which also allows other drivers like
> > FM V4L2 and GPS character driver to make use of the same UART interface.
> >
> > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > ---
> >  drivers/bluetooth/bt_ti.c      |  463 ++++++++++++++++++++++++++++++++++++
> >  drivers/staging/ti-st/bt_drv.c |  509 -------------------------------------
> ---
> >  drivers/staging/ti-st/bt_drv.h |   61 -----
> >  3 files changed, 463 insertions(+), 570 deletions(-)
> >  create mode 100644 drivers/bluetooth/bt_ti.c
> >  delete mode 100644 drivers/staging/ti-st/bt_drv.c
> >  delete mode 100644 drivers/staging/ti-st/bt_drv.h
>
> I don't care about staging at all. So you sort that out with Greg.
>
> Submit your driver for upstream inclusion. And once accepted you can pin
> Greg about removing it.
>
> > diff --git a/drivers/bluetooth/bt_ti.c b/drivers/bluetooth/bt_ti.c
> > new file mode 100644
> > index 0000000..4f3d3aa
> > --- /dev/null
> > +++ b/drivers/bluetooth/bt_ti.c
> > @@ -0,0 +1,463 @@
> > +/*
> > + *  Texas Instrument's Bluetooth Driver For Shared Transport.
> > + *
> > + *  Bluetooth Driver acts as interface between HCI CORE and
> > + *  TI Shared Transport Layer.
> > + *
> > + *  Copyright (C) 2009-2010 Texas Instruments
> > + *  Author: Raja Mani <raja_mani@ti.com>
> > + * Pavan Savoy <pavan_savoy@ti.com>
> > + *
> > + *  This program is free software; you can redistribute it and/or modify
> > + *  it under the terms of the GNU General Public License version 2 as
> > + *  published by the Free Software Foundation.
> > + *
> > + *  This program is distributed in the hope that it will be useful,
> > + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *  GNU General Public License for more details.
> > + *
> > + *  You should have received a copy of the GNU General Public License
> > + *  along with this program; if not, write to the Free Software
> > + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
> USA
> > + *
> > + */
> > +
> > +#define pr_fmt(fmt)        "(tibt): " fmt
>
> Don't do this. Just use BT_DBG, BT_ERR, BT_INFO etc.

Yes, Will do it.

> > +#include <net/bluetooth/bluetooth.h>
> > +#include <net/bluetooth/hci_core.h>
> > +
> > +#include <linux/ti_wilink_st.h>
> > +
> > +/* Bluetooth Driver Version */
> > +#define VERSION               "1.0"
> > +
> > +/* Defines number of seconds to wait for reg completion
> > + * callback getting called from ST (in case,registration
> > + * with ST returns PENDING status)
> > + */
> > +#define BT_REGISTER_TIMEOUT   6000 /* 6 sec */
> > +
> > +/* BT driver's local status */
> > +#define BT_DRV_RUNNING        0
> > +#define BT_ST_REGISTERED      1
> > +
> > +/**
> > + * struct hci_st - BT driver operation structure
> > + * @hdev: hci device pointer which binds to bt driver
> > + * @flags: used locally,to maintain various BT driver status
> > + * @streg_cbdata: to hold ST registration callback status
> > + * @st_write: write function pointer of ST driver
> > + * @wait_for_btdrv_reg_completion - completion sync between hci_st_open
> > + * and hci_st_registration_completion_cb.
> > + */
> > +struct hci_st {
> > +   struct hci_dev *hdev;
> > +   unsigned long flags;
> > +   char streg_cbdata;
> > +   long (*st_write) (struct sk_buff *);
> > +   struct completion wait_for_btdrv_reg_completion;
> > +};
> > +
> > +static struct hci_st *hst;
> > +static int reset;
> > +
> > +/* Increments HCI counters based on pocket ID (cmd,acl,sco) */
> > +static inline void hci_st_tx_complete(struct hci_st *hst, int pkt_type)
> > +{
> > +   struct hci_dev *hdev;
> > +   hdev = hst->hdev;
> > +
> > +   /* Update HCI stat counters */
> > +   switch (pkt_type) {
> > +   case HCI_COMMAND_PKT:
> > +           hdev->stat.cmd_tx++;
> > +           break;
> > +
> > +   case HCI_ACLDATA_PKT:
> > +           hdev->stat.acl_tx++;
> > +           break;
> > +
> > +   case HCI_SCODATA_PKT:
> > +           hdev->stat.cmd_tx++;
> > +           break;
> > +   }
> > +}
> > +
> > +/* ------- Interfaces to Shared Transport ------ */
> > +
> > +/* Called by ST layer to indicate protocol registration completion
> > + * status.hci_st_open() function will wait for signal from this
> > + * API when st_register() function returns ST_PENDING.
> > + */
> > +static void hci_st_registration_completion_cb(void *priv_data, char data)
> > +{
> > +   struct hci_st *lhst = (struct hci_st *)priv_data;
> > +   /* hci_st_open() function needs value of 'data' to know
> > +    * the registration status(success/fail),So have a back
> > +    * up of it.
> > +    */
> > +   lhst->streg_cbdata = data;
> > +
> > +   /* Got a feedback from ST for BT driver registration
> > +    * request.Wackup hci_st_open() function to continue
> > +    * it's open operation.
> > +    */
> > +   complete(&lhst->wait_for_btdrv_reg_completion);
> > +}
> > +
> > +/* Called by Shared Transport layer when receive data is
> > + * available */
> > +static long hci_st_receive(void *priv_data, struct sk_buff *skb)
> > +{
> > +   int err;
> > +   int len;
> > +   struct hci_st *lhst = (struct hci_st *)priv_data;
> > +
> > +   err = 0;
> > +   len = 0;
> > +
> > +   if (skb == NULL) {
> > +           pr_err("Invalid SKB received from ST");
> > +           return -EFAULT;
> > +   }
> > +   if (!lhst) {
> > +           kfree_skb(skb);
> > +           pr_err("Invalid hci_st memory,freeing SKB");
> > +           return -EFAULT;
> > +   }
> > +   if (!test_bit(BT_DRV_RUNNING, &lhst->flags)) {
> > +           kfree_skb(skb);
> > +           pr_err("Device is not running,freeing SKB");
> > +           return -EINVAL;
> > +   }
> > +
> > +   len = skb->len;
> > +   skb->dev = (struct net_device *)lhst->hdev;
> > +
> > +   /* Forward skb to HCI CORE layer */
> > +   err = hci_recv_frame(skb);
> > +   if (err) {
> > +           kfree_skb(skb);
> > +           pr_err("Unable to push skb to HCI CORE(%d),freeing SKB",
> > +                           err);
> > +           return err;
> > +   }
> > +   lhst->hdev->stat.byte_rx += len;
> > +
> > +   return 0;
> > +}
> > +
> > +/* ------- Interfaces to HCI layer ------ */
> > +
> > +/* Called from HCI core to initialize the device */
> > +static int hci_st_open(struct hci_dev *hdev)
> > +{
> > +   static struct st_proto_s hci_st_proto;
> > +   unsigned long timeleft;
> > +   int err;
> > +   err = 0;
> > +
> > +   pr_debug("%s %p", hdev->name, hdev);
> > +
> > +   /* Already registered with ST ? */
> > +   if (test_bit(BT_ST_REGISTERED, &hst->flags)) {
> > +           pr_err("Registered with ST already,open called again?");
> > +           return 0;
> > +   }
>
> Why are you testing against this. This should be not needed at all.

Oh yes, Agree, the HCI sock/core doesn't allow hci0 to be HCIDEVUP-ed twice.

> > +   /* Populate BT driver info required by ST */
> > +   memset(&hci_st_proto, 0, sizeof(hci_st_proto));
> > +
> > +   /* BT driver ID */
> > +   hci_st_proto.type = ST_BT;
> > +
> > +   /* Receive function which called from ST */
> > +   hci_st_proto.recv = hci_st_receive;
> > +
> > +   /* Packet match function may used in future */
> > +   hci_st_proto.match_packet = NULL;
> > +
> > +   /* Callback to be called when registration is pending */
> > +   hci_st_proto.reg_complete_cb = hci_st_registration_completion_cb;
> > +
> > +   /* This is write function pointer of ST. BT driver will make use of
> this
> > +    * for sending any packets to chip. ST will assign and give to us, so
> > +    * make it as NULL */
> > +   hci_st_proto.write = NULL;
> > +
> > +   /* send in the hst to be received at registration complete callback
> > +    * and during st's receive
> > +    */
> > +   hci_st_proto.priv_data = hst;
> > +
> > +   /* Register with ST layer */
> > +   err = st_register(&hci_st_proto);
>
> I am still against just claiming the st_ prefix where a company called
> ST is active in the kernel as well. Is the Shared Transport really a
> proper standard?

The driver is called TI_ST, I can rename it no problem, I'm not 100% convinced with this either, any suggestions for names?

> > +   if (err == -EINPROGRESS) {
> > +           /* Prepare wait-for-completion handler data structures.
> > +            * Needed to syncronize this and st_registration_completion_cb()
> > +            * functions.
> > +            */
> > +           init_completion(&hst->wait_for_btdrv_reg_completion);
> > +
> > +           /* Reset ST registration callback status flag , this value
> > +            * will be updated in hci_st_registration_completion_cb()
> > +            * function whenever it called from ST driver.
> > +            */
> > +           hst->streg_cbdata = -EINPROGRESS;
> > +
> > +           /* ST is busy with other protocol registration(may be busy with
> > +            * firmware download).So,Wait till the registration callback
> > +            * (passed as a argument to st_register() function) getting
> > +            * called from ST.
> > +            */
> > +           pr_debug(" %s waiting for reg completion signal from ST",
> > +                           __func__);
> > +
> > +           timeleft =
> > +                   wait_for_completion_timeout
> > +                   (&hst->wait_for_btdrv_reg_completion,
> > +                    msecs_to_jiffies(BT_REGISTER_TIMEOUT));
> > +           if (!timeleft) {
> > +                   pr_err("Timeout(%d sec),didn't get reg"
> > +                                   "completion signal from ST",
> > +                                   BT_REGISTER_TIMEOUT / 1000);
> > +                   return -ETIMEDOUT;
> > +           }
> > +
> > +           /* Is ST registration callback called with ERROR value? */
> > +           if (hst->streg_cbdata != 0) {
> > +                   pr_err("ST reg completion CB called with invalid"
> > +                                   "status %d", hst->streg_cbdata);
> > +                   return -EAGAIN;
> > +           }
> > +           err = 0;
> > +   } else if (err == -1) {
> > +           pr_err("st_register failed %d", err);
> > +           return -EAGAIN;
> > +   }
> > +
> > +   /* Do we have proper ST write function? */
> > +   if (hci_st_proto.write != NULL) {
> > +           /* We need this pointer for sending any Bluetooth pkts */
> > +           hst->st_write = hci_st_proto.write;
> > +   } else {
> > +           pr_err("failed to get ST write func pointer");
> > +
> > +           /* Undo registration with ST */
> > +           err = st_unregister(ST_BT);
> > +           if (err < 0)
> > +                   pr_err("st_unregister failed %d", err);
> > +
> > +           hst->st_write = NULL;
> > +           return -EAGAIN;
> > +   }
> > +
> > +   /* Registration with ST layer is completed successfully,
> > +    * now chip is ready to accept commands from HCI CORE.
> > +    * Mark HCI Device flag as RUNNING
> > +    */
> > +   set_bit(HCI_RUNNING, &hdev->flags);
> > +
> > +   /* Registration with ST successful */
> > +   set_bit(BT_ST_REGISTERED, &hst->flags);
> > +
> > +   return err;
> > +}
> > +
> > +/* Close device */
> > +static int hci_st_close(struct hci_dev *hdev)
> > +{
> > +   int err;
> > +   err = 0;
> > +
> > +   /* Unregister from ST layer */
> > +   if (test_and_clear_bit(BT_ST_REGISTERED, &hst->flags)) {
> > +           err = st_unregister(ST_BT);
> > +           if (err != 0) {
> > +                   pr_err("st_unregister failed %d", err);
> > +                   return -EBUSY;
> > +           }
> > +   }
> > +
> > +   hst->st_write = NULL;
> > +
> > +   /* ST layer would have moved chip to inactive state.
> > +    * So,clear HCI device RUNNING flag.
> > +    */
> > +   if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
> > +           return 0;
> > +
> > +   return err;
> > +}
> > +
> > +/* Called from HCI CORE , Sends frames to Shared Transport */
> > +static int hci_st_send_frame(struct sk_buff *skb)
> > +{
> > +   struct hci_dev *hdev;
> > +   struct hci_st *hst;
> > +   long len;
> > +
> > +   if (skb == NULL) {
> > +           pr_err("Invalid skb received from HCI CORE");
> > +           return -ENOMEM;
> > +   }
> > +   hdev = (struct hci_dev *)skb->dev;
> > +   if (!hdev) {
> > +           pr_err("SKB received for invalid HCI Device (hdev=NULL)");
> > +           return -ENODEV;
> > +   }
> > +   if (!test_bit(HCI_RUNNING, &hdev->flags)) {
> > +           pr_err("Device is not running");
> > +           return -EBUSY;
> > +   }
> > +
> > +   hst = (struct hci_st *)hdev->driver_data;
> > +
> > +   /* Prepend skb with frame type */
> > +   memcpy(skb_push(skb, 1), &bt_cb(skb)->pkt_type, 1);
> > +
> > +   pr_debug(" %s: type %d len %d", hdev->name, bt_cb(skb)->pkt_type,
> > +                   skb->len);
> > +
> > +   /* Insert skb to shared transport layer's transmit queue.
> > +    * Freeing skb memory is taken care in shared transport layer,
> > +    * so don't free skb memory here.
> > +    */
> > +   if (!hst->st_write) {
> > +           kfree_skb(skb);
> > +           pr_err(" Can't write to ST, st_write null?");
> > +           return -EAGAIN;
> > +   }
> > +   len = hst->st_write(skb);
> > +   if (len < 0) {
> > +           /* Something went wrong in st write , free skb memory */
> > +           kfree_skb(skb);
> > +           pr_err(" ST write failed (%ld)", len);
> > +           return -EAGAIN;
> > +   }
> > +
> > +   /* ST accepted our skb. So, Go ahead and do rest */
> > +   hdev->stat.byte_tx += len;
> > +   hci_st_tx_complete(hst, bt_cb(skb)->pkt_type);
> > +
> > +   return 0;
> > +}
> > +
> > +static void hci_st_destruct(struct hci_dev *hdev)
> > +{
> > +   if (!hdev) {
> > +           pr_err("Destruct called with invalid HCI Device"
> > +                           "(hdev=NULL)");
> > +           return;
> > +   }
> > +
> > +   pr_debug("%s", hdev->name);
> > +
> > +   /* free hci_st memory */
> > +   if (hdev->driver_data != NULL)
> > +           kfree(hdev->driver_data);
> > +
> > +   return;
> > +}
> > +
> > +/* Creates new HCI device */
> > +static int hci_st_register_dev(struct hci_st *hst)
> > +{
> > +   struct hci_dev *hdev;
> > +
> > +   /* Initialize and register HCI device */
> > +   hdev = hci_alloc_dev();
> > +   if (!hdev) {
> > +           pr_err("Can't allocate HCI device");
> > +           return -ENOMEM;
> > +   }
> > +   pr_debug(" HCI device allocated. hdev= %p", hdev);
> > +
> > +   hst->hdev = hdev;
> > +   hdev->bus = HCI_UART;
> > +   hdev->driver_data = hst;
> > +   hdev->open = hci_st_open;
> > +   hdev->close = hci_st_close;
> > +   hdev->flush = NULL;
> > +   hdev->send = hci_st_send_frame;
> > +   hdev->destruct = hci_st_destruct;
> > +   hdev->owner = THIS_MODULE;
> > +
> > +   if (reset)
> > +           set_bit(HCI_QUIRK_NO_RESET, &hdev->quirks);
> > +
> > +   if (hci_register_dev(hdev) < 0) {
> > +           pr_err("Can't register HCI device");
> > +           hci_free_dev(hdev);
> > +           return -ENODEV;
> > +   }
> > +
> > +   pr_debug(" HCI device registered. hdev= %p", hdev);
> > +   return 0;
> > +}
> > +
> > +/* ------- Module Init interface ------ */
> > +
> > +static int __init bt_drv_init(void)
> > +{
> > +   int err;
> > +   err = 0;
> > +
> > +   pr_debug(" Bluetooth Driver Version %s", VERSION);
> > +
> > +   /* Allocate local resource memory */
> > +   hst = kzalloc(sizeof(struct hci_st), GFP_KERNEL);
> > +   if (!hst) {
> > +           pr_err("Can't allocate control structure");
> > +           return -ENFILE;
> > +   }
> > +
> > +   /* Expose "hciX" device to user space */
> > +   err = hci_st_register_dev(hst);
> > +   if (err) {
> > +           /* Release local resource memory */
> > +           kfree(hst);
> > +
> > +           pr_err("Unable to expose hci0 device(%d)", err);
> > +           return err;
> > +   }
> > +   set_bit(BT_DRV_RUNNING, &hst->flags);
> > +   return err;
> > +}
> > +
> > +/* ------- Module Exit interface ------ */
> > +
> > +static void __exit bt_drv_exit(void)
> > +{
> > +   /* Deallocate local resource's memory  */
> > +   if (hst) {
> > +           struct hci_dev *hdev = hst->hdev;
> > +           if (hdev == NULL) {
> > +                   pr_err("Invalid hdev memory");
> > +                   kfree(hst);
> > +           } else {
> > +                   hci_st_close(hdev);
> > +                   if (test_and_clear_bit(BT_DRV_RUNNING, &hst->flags)) {
> > +                           /* Remove HCI device (hciX) created
> > +                            * in module init.
> > +                            */
> > +                           hci_unregister_dev(hdev);
> > +                           /* Free HCI device memory */
> > +                           hci_free_dev(hdev);
> > +                   }
> > +           }
> > +   }
> > +}
>
> Registering the Bluetooth HCI driver in module_init/module_exit is not
> acceptable. Turn your shared transport into a proper bus.

Yes, you did comment on it before, I remember, I did prototype the driver as
a bus driver, However I didn't find any advantages by converting it to a bus
driver.
As in, currently the shared transport driver is a line discipline driver because
it is the only way it can communicate over TTY without being tightly coupled with the UART driver.

> We want to be able to have generic kernels where this module is enabled,
> but no Shared Transport is available.

Oh if this is the reason I cannot have hci_register/_unregister in module_init/_exit, Can I do this module "depends" on TI_ST, Then it would not
even be visible to build if TI_ST is not selected.

> Regards
>
> Marcel
>

