Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab0JGVyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:54:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41138 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab0JGVyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:54:09 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
CC: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Oct 2010 03:23:57 +0530
Subject: RE: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Thread-Topic: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Thread-Index: ActmaPDp5rW/SklJQYyCyhm5EbJKrwAAGo7Q
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21D25D@dbde02.ent.ti.com>
References: <1286477237-7526-1-git-send-email-pavan_savoy@ti.com>
 <1286477237-7526-2-git-send-email-pavan_savoy@ti.com>
 <20101007184534.GB13602@vigoh>
In-Reply-To: <20101007184534.GB13602@vigoh>
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

Gustavo / Marcel,
 

> -----Original Message-----
> From: Gustavo F. Padovan [mailto:pao@profusion.mobi] On Behalf Of Gustavo F.
> Padovan
> Sent: Thursday, October 07, 2010 1:46 PM
> To: Savoy, Pavan
> Cc: linux-bluetooth@vger.kernel.org; marcel@holtmann.org; greg@kroah.com;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
> 
> Hi Pavan,
> 
> Change the commit subject to "Bluetooth: TI_ST bluetooth driver"
> 
> * pavan_savoy@ti.com <pavan_savoy@ti.com> [2010-10-07 14:47:16 -0400]:
> 
> > From: Pavan Savoy <pavan_savoy@ti.com>
> >
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
> >  drivers/bluetooth/bt_ti.c |  489
> +++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 489 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/bluetooth/bt_ti.c
> 
> We don't have filename with bt_.. in drivers/bluetooth/. Maybe ti_st.c
> should be a better name, or something like that.
> 
> >
> > diff --git a/drivers/bluetooth/bt_ti.c b/drivers/bluetooth/bt_ti.c
> > new file mode 100644
> > index 0000000..dffbb56
> > --- /dev/null
> > +++ b/drivers/bluetooth/bt_ti.c
> > @@ -0,0 +1,489 @@
> > +/*
> > + *  Texas Instrument's Bluetooth Driver For Shared Transport.
> > + *
> > + *  Bluetooth Driver acts as interface between HCI CORE and
> > + *  TI Shared Transport Layer.
> > + *
> > + *  Copyright (C) 2009-2010 Texas Instruments
> > + *  Author: Raja Mani <raja_mani@ti.com>
> > + *	Pavan Savoy <pavan_savoy@ti.com>
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
> > +#include <linux/platform_device.h>
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
> > +#define BT_REGISTER_TIMEOUT   6000	/* 6 sec */
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
> > + *	and hci_st_registration_completion_cb.
> > + */
> > +struct hci_st {
> > +	struct hci_dev *hdev;
> > +	unsigned long flags;
> > +	char streg_cbdata;
> > +	long (*st_write) (struct sk_buff *);
> > +	struct completion wait_for_btdrv_reg_completion;
> > +};
> > +
> > +static int reset;
> > +
> > +/* Increments HCI counters based on pocket ID (cmd,acl,sco) */
> > +static inline void hci_st_tx_complete(struct hci_st *hst, int pkt_type)
> > +{
> > +	struct hci_dev *hdev;
> > +	hdev = hst->hdev;
> > +
> > +	/* Update HCI stat counters */
> > +	switch (pkt_type) {
> > +	case HCI_COMMAND_PKT:
> > +		hdev->stat.cmd_tx++;
> > +		break;
> > +
> > +	case HCI_ACLDATA_PKT:
> > +		hdev->stat.acl_tx++;
> > +		break;
> > +
> > +	case HCI_SCODATA_PKT:
> > +		hdev->stat.cmd_tx++;
> 
> it should be sco_tx here.
> 
> > +		break;
> > +	}
> > +}
> > +
> > +/* ------- Interfaces to Shared Transport ------ */
> > +
> > +/* Called by ST layer to indicate protocol registration completion
> > + * status.hci_st_open() function will wait for signal from this
> > + * API when st_register() function returns ST_PENDING.
> > + */
> > +static void hci_st_registration_completion_cb(void *priv_data, char data)
> 
> That is not the hci layer, so rename this function (and the others) to
> something that reflect where they are really doing.
> 
> > +{
> > +	struct hci_st *lhst = (struct hci_st *)priv_data;
> > +	/* hci_st_open() function needs value of 'data' to know
> > +	 * the registration status(success/fail),So have a back
> > +	 * up of it.
> > +	 */
> > +	lhst->streg_cbdata = data;
> > +
> > +	/* Got a feedback from ST for BT driver registration
> > +	 * request.Wackup hci_st_open() function to continue
> > +	 * it's open operation.
> > +	 */
> > +	complete(&lhst->wait_for_btdrv_reg_completion);
> > +}
> > +
> > +/* Called by Shared Transport layer when receive data is
> > + * available */
> > +static long hci_st_receive(void *priv_data, struct sk_buff *skb)
> > +{
> > +	int err;
> > +	int len;
> 
> you can put err and len in the same line.
> 
> > +	struct hci_st *lhst = (struct hci_st *)priv_data;
> > +
> > +	err = 0;
> > +	len = 0;
> 
> and no need to set them to 0 here.
> 
> > +
> > +	if (skb == NULL) {
> > +		BT_ERR("Invalid SKB received from ST");
> > +		return -EFAULT;
> > +	}
> 
> We need a empty line here.
> 
> > +	if (!lhst) {
> > +		kfree_skb(skb);
> > +		BT_ERR("Invalid hci_st memory,freeing SKB");
> > +		return -EFAULT;
> > +	}
> 
> And also here. Check the rest of the code for similar issues.
> 
> > +	if (!test_bit(BT_DRV_RUNNING, &lhst->flags)) {
> > +		kfree_skb(skb);
> > +		BT_ERR("Device is not running,freeing SKB");
> > +		return -EINVAL;
> > +	}
> 
> If you are here, your device is running, right? Or am I missing
> something?
> 
> > +
> > +	len = skb->len;
> > +	skb->dev = (struct net_device *)lhst->hdev;
> > +
> > +	/* Forward skb to HCI CORE layer */
> > +	err = hci_recv_frame(skb);
> > +	if (err) {
> > +		kfree_skb(skb);
> > +		BT_ERR("Unable to push skb to HCI CORE(%d),freeing SKB",
> > +				err);
> > +		return err;
> > +	}
> > +	lhst->hdev->stat.byte_rx += len;
> 
> actually you even don't need len, just use skb->len
> 
> > +
> > +	return 0;
> > +}
> > +
> > +/* ------- Interfaces to HCI layer ------ */
> > +
> > +/* Called from HCI core to initialize the device */
> > +static int hci_st_open(struct hci_dev *hdev)
> > +{
> > +	static struct st_proto_s hci_st_proto;
> > +	unsigned long timeleft;
> > +	struct hci_st *hst;
> > +	int err;
> > +	err = 0;
> > +
> > +	BT_DBG("%s %p", hdev->name, hdev);
> > +	hst = hdev->driver_data;
> > +
> > +	/* Populate BT driver info required by ST */
> > +	memset(&hci_st_proto, 0, sizeof(hci_st_proto));
> > +
> > +	/* BT driver ID */
> > +	hci_st_proto.type = ST_BT;
> > +
> > +	/* Receive function which called from ST */
> > +	hci_st_proto.recv = hci_st_receive;
> > +
> > +	/* Packet match function may used in future */
> > +	hci_st_proto.match_packet = NULL;
> 
> It is already NULL, you dua a memset.
> 
> > +
> > +	/* Callback to be called when registration is pending */
> > +	hci_st_proto.reg_complete_cb = hci_st_registration_completion_cb;
> > +
> > +	/* This is write function pointer of ST. BT driver will make use of
> this
> > +	 * for sending any packets to chip. ST will assign and give to us, so
> > +	 * make it as NULL */
> > +	hci_st_proto.write = NULL;
> 
> Same here.
> 
> > +
> > +	/* send in the hst to be received at registration complete callback
> > +	 * and during st's receive
> > +	 */
> > +	hci_st_proto.priv_data = hst;
> > +
> > +	/* Register with ST layer */
> > +	err = st_register(&hci_st_proto);
> > +	if (err == -EINPROGRESS) {
> > +		/* Prepare wait-for-completion handler data structures.
> > +		 * Needed to syncronize this and st_registration_completion_cb()
> > +		 * functions.
> > +		 */
> > +		init_completion(&hst->wait_for_btdrv_reg_completion);
> 
> I'm not liking that, but I'll leave for Marcel and others comment.

Thanks for the comments, I will take care of them all, but I want to
tell why I do this here.
"st_register" function takes time. It takes about 2 seconds for us
to download the firmware. (or longer based on UART baud-rate).

This is intended to happen in the process context. Say hciconfig hci0 up
takes a while longer than usual or if someone doing an ioctl(HCIDEVUP)
and this is also the reason I have a callback, as and when firmware download
completes, I call the Bluetooth driver's callback.

and I await marcel's comment on this.

> > +
> > +		/* Reset ST registration callback status flag , this value
> > +		 * will be updated in hci_st_registration_completion_cb()
> > +		 * function whenever it called from ST driver.
> > +		 */
> > +		hst->streg_cbdata = -EINPROGRESS;
> > +
> > +		/* ST is busy with other protocol registration(may be busy with
> > +		 * firmware download).So,Wait till the registration callback
> > +		 * (passed as a argument to st_register() function) getting
> > +		 * called from ST.
> > +		 */
> > +		BT_DBG(" %s waiting for reg completion signal from ST",
> > +				__func__);
> > +
> > +		timeleft =
> > +			wait_for_completion_timeout
> > +			(&hst->wait_for_btdrv_reg_completion,
> > +			 msecs_to_jiffies(BT_REGISTER_TIMEOUT));
> > +		if (!timeleft) {
> > +			BT_ERR("Timeout(%d sec),didn't get reg"
> > +					"completion signal from ST",
> > +					BT_REGISTER_TIMEOUT / 1000);
> > +			return -ETIMEDOUT;
> > +		}
> > +
> > +		/* Is ST registration callback called with ERROR value? */
> > +		if (hst->streg_cbdata != 0) {
> > +			BT_ERR("ST reg completion CB called with invalid"
> > +					"status %d", hst->streg_cbdata);
> > +			return -EAGAIN;
> > +		}
> > +		err = 0;
> > +	} else if (err == -1) {
> 
> Use the proper error macro instead "-1"
> 
> > +		BT_ERR("st_register failed %d", err);
> > +		return -EAGAIN;
> > +	}
> > +
> > +	/* Do we have proper ST write function? */
> > +	if (hci_st_proto.write != NULL) {
> > +		/* We need this pointer for sending any Bluetooth pkts */
> > +		hst->st_write = hci_st_proto.write;
> > +	} else {
> > +		BT_ERR("failed to get ST write func pointer");
> > +
> > +		/* Undo registration with ST */
> > +		err = st_unregister(ST_BT);
> > +		if (err < 0)
> > +			BT_ERR("st_unregister failed %d", err);
> > +
> > +		hst->st_write = NULL;
> > +		return -EAGAIN;
> > +	}
> > +
> > +	/* Registration with ST layer is completed successfully,
> > +	 * now chip is ready to accept commands from HCI CORE.
> > +	 * Mark HCI Device flag as RUNNING
> > +	 */
> > +	set_bit(HCI_RUNNING, &hdev->flags);
> > +
> > +	/* Registration with ST successful */
> > +	set_bit(BT_ST_REGISTERED, &hst->flags);
> > +
> > +	return err;
> > +}
> > +
> > +/* Close device */
> > +static int hci_st_close(struct hci_dev *hdev)
> > +{
> > +	int err;
> > +	struct hci_st *hst;
> 
> Skip a line after declarations.
> 
> > +	err = 0;
> 
> you can set err to 0 in the declaration if you really need that.
> 
> > +
> > +	hst = hdev->driver_data;
> > +	/* Unregister from ST layer */
> > +	if (test_and_clear_bit(BT_ST_REGISTERED, &hst->flags)) {
> > +		err = st_unregister(ST_BT);
> > +		if (err != 0) {
> > +			BT_ERR("st_unregister failed %d", err);
> > +			return -EBUSY;
> > +		}
> > +	}
> > +
> > +	hst->st_write = NULL;
> > +
> > +	/* ST layer would have moved chip to inactive state.
> > +	 * So,clear HCI device RUNNING flag.
> > +	 */
> > +	if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
> > +		return 0;
> 
> Looks you are screwing up the flags here, if it fails on st_unregister()
> and returns HCI_RUNNING should keep set?
> 
> > +
> > +	return err;
> 
> Rethink how you are doing error handling here, it should no be
> complicated like that.
> 
> > +}
> > +
> > +/* Called from HCI CORE , Sends frames to Shared Transport */
> > +static int hci_st_send_frame(struct sk_buff *skb)
> > +{
> > +	struct hci_dev *hdev;
> > +	struct hci_st *hst;
> > +	long len;
> > +
> > +	if (skb == NULL) {
> > +		BT_ERR("Invalid skb received from HCI CORE");
> > +		return -ENOMEM;
> > +	}
> > +	hdev = (struct hci_dev *)skb->dev;
> > +	if (!hdev) {
> > +		BT_ERR("SKB received for invalid HCI Device (hdev=NULL)");
> > +		return -ENODEV;
> > +	}
> > +	if (!test_bit(HCI_RUNNING, &hdev->flags)) {
> > +		BT_ERR("Device is not running");
> > +		return -EBUSY;
> > +	}
> > +
> > +	hst = (struct hci_st *)hdev->driver_data;
> > +
> > +	/* Prepend skb with frame type */
> > +	memcpy(skb_push(skb, 1), &bt_cb(skb)->pkt_type, 1);
> > +
> > +	BT_DBG(" %s: type %d len %d", hdev->name, bt_cb(skb)->pkt_type,
> > +			skb->len);
> > +
> > +	/* Insert skb to shared transport layer's transmit queue.
> > +	 * Freeing skb memory is taken care in shared transport layer,
> > +	 * so don't free skb memory here.
> > +	 */
> > +	if (!hst->st_write) {
> > +		kfree_skb(skb);
> > +		BT_ERR(" Can't write to ST, st_write null?");
> > +		return -EAGAIN;
> > +	}
> > +	len = hst->st_write(skb);
> > +	if (len < 0) {
> > +		/* Something went wrong in st write , free skb memory */
> 
> IMHO we don't need comments like that, clearly we now that something
> went wrong.
> 
> > +		kfree_skb(skb);
> > +		BT_ERR(" ST write failed (%ld)", len);
> > +		return -EAGAIN;
> > +	}
> > +
> > +	/* ST accepted our skb. So, Go ahead and do rest */
> > +	hdev->stat.byte_tx += len;
> > +	hci_st_tx_complete(hst, bt_cb(skb)->pkt_type);
> > +
> > +	return 0;
> 
> goto might be better to handle error here.
> 
> 
> --
> Gustavo F. Padovan
> ProFUSION embedded systems - http://profusion.mobi
