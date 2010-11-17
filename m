Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab0KQFfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:35:03 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54304 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0KQFfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:35:01 -0500
MIME-Version: 1.0
X-Originating-IP: [192.163.20.232]
In-Reply-To: <20101116225418.GA15101@vigoh>
References: <1289394446-14021-1-git-send-email-pavan_savoy@ti.com>
	<20101116225418.GA15101@vigoh>
Date: Wed, 17 Nov 2010 11:04:59 +0530
Message-ID: <AANLkTikbhaZOvM43Vv6wdcbmK8nh2Nq2Hc1i_naxWjYM@mail.gmail.com>
Subject: Re: [PATCH v5] Bluetooth: btwilink driver
From: Pavan Savoy <pavan_savoy@sify.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gustavo,

On Wed, Nov 17, 2010 at 4:24 AM, Gustavo F. Padovan
<padovan@profusion.mobi> wrote:
> Hi Pavan,
>
> * pavan_savoy@ti.com <pavan_savoy@ti.com> [2010-11-10 08:07:26 -0500]:
>
>> From: Pavan Savoy <pavan_savoy@ti.com>
>>
>> Marcel,
>>
>> Thanks for the comments...
>> This patch contains,
>> v5 comments :-
>> declaration and assiging of variables and private data fixed up.
>> proper casting.
>> removed redundant un-necessary checks in send_frame.
>> HCI_RUNNING fixes in terms of test_and_set/clear bit instead of set and
>> clear.
>> removed redundant checks for hdev, skb being NULL.
>> removed module_param of reset, also WiLink don't need HCI_RESET anyways.
>> removed ti_st_register_dev function and functionality moved to _probe.
>> module_init/exit function names fixed up.
>>
>> stat byte counter increments and tx_complete is similar to hci_ldisc.
>> Also I have not implemented the flush routine, since the functionality
>> which needs to be done in flush routine is done in the underlying driver
>> which is the shared transport driver and moreover the btwilink driver by
>> itself doesn't maintains queue or data relevant to transport, so nothing
>> to do.
>>
>> And Yes, I have verified this driver with multiple up/down reset on
>> hci0.
>> Also I generally test a2dp/ftp to verify large data transfers.
>
> Before re-submit a patch you have to fix all issues reported by the
> reviewer or reply to patch thread why do you think you right and don't
> want to change that. That is not happening with your patches, you are
> not fixing all the stuff before re-submiting and it is not the first
> time.  If you do it right we can review it fast and your code goes
> earlier to mainline.
> You should also answer the questions first  like "Where is the
> ti_st_proto.write coming from?" You just ignored the
> review and submitted a new patch.

This is the reason, I tend to keep the patch comments in the mail.
I have mentioned here the
1. comments I have taken care of,
2. few comments which I don't understand why it is like that and which
are not taken care of.

Also the question on ti_st_proto.write, I have answered it twice in
mail, once to you and once to marcel, for more clarity I have even
added it in the code comments, Please have a look @ line
>> +     /* ti_st_proto.write is filled up by the underlying shared
>> +      * transport driver upon registration
>> +      */
As to why this function is not EXPORT_SYMBOL and just an function
pointer, Yes I had it as function pointer - But since something like
_read is  callback from the protocol driver perspective - to maintain
uniformity I have this as function pointer.
(Note: comments to other drivers which are based on ST driver intended
read/write to be pointers which register/unregister to be EXPORTs).

Ok, apart from this there was an open question as why I am checking
for only 2 error conditions, it is because the underlying driver only
can send those 2 errors and nothing else (st_register has few errors
it can throw...)

I understand my problem with test_and_set_bit, I will correct it, But
I still feel I do nothing critical before test/set so as to return
error if already opened - But will correct it and do it at the
beginning ...

Also what should I be doing regarding the deferred stats update? I
checked up hci_ldisc which is what this code is pretty much based on,
and see that it does pretty much the same thing ....
hci_uart_tx_complete is called after the tty->ops->write correct ?

I also now understand the issue in module_init regarding the
platform_driver registration and will fix that.

Thanks,
Pavan
>>
>> v4 comments :-
>> module init now returns what platform_driver_register returns.
>> type casting of void* private data has been removed
>>
>> v3 comments :-
>> Lizardo,
>> I have taken care of most of the comments you had.
>> Have re-wrote some of the code commenting you've mentioned.
>> Thanks for the comments,
>>
>> The other few like -EPERM for platform driver registration is to keep
>> it similar to other drivers, type casting is maintained just to feel safe
>> and have style similar to other drivers.
>> BT_WILINK in Kconfig is similar to BT_MRVL.
>> I hope those aren't too critical.
>>
>> -- patch description --
>>
>> This is the bluetooth protocol driver for the TI WiLink7 chipsets.
>> Texas Instrument's WiLink chipsets combine wireless technologies
>> like BT, FM, GPS and WLAN onto a single chip.
>>
>> This Bluetooth driver works on top of the TI_ST shared transport
>> line discipline driver which also allows other drivers like
>> FM V4L2 and GPS character driver to make use of the same UART interface.
>>
>> Kconfig and Makefile modifications to enable the Bluetooth
>> driver for Texas Instrument's WiLink 7 chipset.
>>
>> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
>> ---
>>  drivers/bluetooth/Kconfig    |   10 +
>>  drivers/bluetooth/Makefile   |    1 +
>>  drivers/bluetooth/btwilink.c |  379 ++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 390 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/bluetooth/btwilink.c
>>
>> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
>> index 02deef4..8e0de9a 100644
>> --- a/drivers/bluetooth/Kconfig
>> +++ b/drivers/bluetooth/Kconfig
>> @@ -219,4 +219,14 @@ config BT_ATH3K
>>         Say Y here to compile support for "Atheros firmware download driver"
>>         into the kernel or say M to compile it as module (ath3k).
>>
>> +config BT_WILINK
>> +     tristate "Texas Instruments WiLink7 driver"
>> +     depends on TI_ST
>> +     help
>> +       This enables the Bluetooth driver for Texas Instrument's BT/FM/GPS
>> +       combo devices. This makes use of shared transport line discipline
>> +       core driver to communicate with the BT core of the combo chip.
>> +
>> +       Say Y here to compile support for Texas Instrument's WiLink7 driver
>> +       into the kernel or say M to compile it as module.
>>  endmenu
>> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
>> index 71bdf13..f4460f4 100644
>> --- a/drivers/bluetooth/Makefile
>> +++ b/drivers/bluetooth/Makefile
>> @@ -18,6 +18,7 @@ obj-$(CONFIG_BT_HCIBTSDIO)  += btsdio.o
>>  obj-$(CONFIG_BT_ATH3K)               += ath3k.o
>>  obj-$(CONFIG_BT_MRVL)                += btmrvl.o
>>  obj-$(CONFIG_BT_MRVL_SDIO)   += btmrvl_sdio.o
>> +obj-$(CONFIG_BT_WILINK)              += btwilink.o
>>
>>  btmrvl-y                     := btmrvl_main.o
>>  btmrvl-$(CONFIG_DEBUG_FS)    += btmrvl_debugfs.o
>> diff --git a/drivers/bluetooth/btwilink.c b/drivers/bluetooth/btwilink.c
>> new file mode 100644
>> index 0000000..1b1c4bc
>> --- /dev/null
>> +++ b/drivers/bluetooth/btwilink.c
>> @@ -0,0 +1,379 @@
>> +/*
>> + *  Texas Instrument's Bluetooth Driver For Shared Transport.
>> + *
>> + *  Bluetooth Driver acts as interface between HCI core and
>> + *  TI Shared Transport Layer.
>> + *
>> + *  Copyright (C) 2009-2010 Texas Instruments
>> + *  Author: Raja Mani <raja_mani@ti.com>
>> + *   Pavan Savoy <pavan_savoy@ti.com>
>> + *
>> + *  This program is free software; you can redistribute it and/or modify
>> + *  it under the terms of the GNU General Public License version 2 as
>> + *  published by the Free Software Foundation.
>> + *
>> + *  This program is distributed in the hope that it will be useful,
>> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + *  GNU General Public License for more details.
>> + *
>> + *  You should have received a copy of the GNU General Public License
>> + *  along with this program; if not, write to the Free Software
>> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + *
>> + */
>> +
>> +#include <linux/platform_device.h>
>> +#include <net/bluetooth/bluetooth.h>
>> +#include <net/bluetooth/hci_core.h>
>> +
>> +#include <linux/ti_wilink_st.h>
>> +
>> +/* Bluetooth Driver Version */
>> +#define VERSION               "1.0"
>> +
>> +/* Number of seconds to wait for registration completion
>> + * when ST returns PENDING status.
>> + */
>> +#define BT_REGISTER_TIMEOUT   6000   /* 6 sec */
>> +
>> +/**
>> + * struct ti_st - driver operation structure
>> + * @hdev: hci device pointer which binds to bt driver
>> + * @reg_status: ST registration callback status
>> + * @st_write: write function provided by the ST driver
>> + *   to be used by the driver during send_frame.
>> + * @wait_reg_completion - completion sync between ti_st_open
>> + *   and ti_st_registration_completion_cb.
>> + */
>> +struct ti_st {
>> +     struct hci_dev *hdev;
>> +     char reg_status;
>> +     long (*st_write) (struct sk_buff *);
>> +     struct completion wait_reg_completion;
>> +};
>> +
>> +/* Increments HCI counters based on pocket ID (cmd,acl,sco) */
>> +static inline void ti_st_tx_complete(struct ti_st *hst, int pkt_type)
>> +{
>> +     struct hci_dev *hdev = hst->hdev;
>> +
>> +     /* Update HCI stat counters */
>> +     switch (pkt_type) {
>> +     case HCI_COMMAND_PKT:
>> +             hdev->stat.cmd_tx++;
>> +             break;
>> +
>> +     case HCI_ACLDATA_PKT:
>> +             hdev->stat.acl_tx++;
>> +             break;
>> +
>> +     case HCI_SCODATA_PKT:
>> +             hdev->stat.sco_tx++;
>> +             break;
>> +     }
>> +}
>> +
>> +/* ------- Interfaces to Shared Transport ------ */
>> +
>> +/* Called by ST layer to indicate protocol registration completion
>> + * status.ti_st_open() function will wait for signal from this
>> + * API when st_register() function returns ST_PENDING.
>> + */
>> +static void st_registration_completion_cb(void *priv_data, char data)
>> +{
>> +     struct ti_st *lhst = priv_data;
>> +
>> +     /* Save registration status for use in ti_st_open() */
>> +     lhst->reg_status = data;
>> +     /* complete the wait in ti_st_open() */
>> +     complete(&lhst->wait_reg_completion);
>> +}
>> +
>> +/* Called by Shared Transport layer when receive data is
>> + * available */
>> +static long st_receive(void *priv_data, struct sk_buff *skb)
>> +{
>> +     struct ti_st *lhst = priv_data;
>> +     int err;
>> +
>> +     if (!skb)
>> +             return -EFAULT;
>> +
>> +     if (!lhst) {
>> +             kfree_skb(skb);
>> +             return -EFAULT;
>> +     }
>> +
>> +     skb->dev = (void *) lhst->hdev;
>> +
>> +     /* Forward skb to HCI core layer */
>> +     err = hci_recv_frame(skb);
>> +     if (err < 0) {
>> +             BT_ERR("Unable to push skb to HCI core(%d)", err);
>> +             return err;
>> +     }
>> +
>> +     lhst->hdev->stat.byte_rx += skb->len;
>> +
>> +     return 0;
>> +}
>> +
>> +/* ------- Interfaces to HCI layer ------ */
>> +/* protocol structure registered with shared transport */
>> +static struct st_proto_s ti_st_proto = {
>> +     .type = ST_BT,
>> +     .recv = st_receive,
>> +     .reg_complete_cb = st_registration_completion_cb,
>> +};
>> +
>> +/* Called from HCI core to initialize the device */
>> +static int ti_st_open(struct hci_dev *hdev)
>> +{
>> +     unsigned long timeleft;
>> +     struct ti_st *hst;
>> +     int err;
>> +
>> +     BT_DBG("%s %p", hdev->name, hdev);
>> +
>> +     /* provide contexts for callbacks from ST */
>> +     hst = hdev->driver_data;
>> +     ti_st_proto.priv_data = hst;
>> +
>> +     err = st_register(&ti_st_proto);
>> +     if (err == -EINPROGRESS) {
>> +             /* Prepare wait-for-completion handler data structures.
>> +              * Needed to synchronize this and
>> +              * st_registration_completion_cb() functions.
>> +              */
>> +             init_completion(&hst->wait_reg_completion);
>> +
>> +             /* Reset ST registration callback status flag , this value
>> +              * will be updated in ti_st_registration_completion_cb()
>> +              * function whenever it called from ST driver.
>> +              */
>> +             hst->reg_status = -EINPROGRESS;
>> +
>> +             /* ST is busy with either protocol registration or firmware
>> +              * download. Wait until the registration callback is called
>> +              */
>> +             BT_DBG(" waiting for registration completion signal from ST");
>> +
>> +             timeleft = wait_for_completion_timeout
>> +                     (&hst->wait_reg_completion,
>> +                      msecs_to_jiffies(BT_REGISTER_TIMEOUT));
>> +             if (!timeleft) {
>> +                     BT_ERR("Timeout(%d sec),didn't get reg "
>> +                                     "completion signal from ST",
>> +                                     BT_REGISTER_TIMEOUT / 1000);
>> +                     return -ETIMEDOUT;
>> +             }
>> +
>> +             /* Is ST registration callback called with ERROR status? */
>> +             if (hst->reg_status != 0) {
>> +                     BT_ERR("ST registration completed with invalid "
>> +                                     "status %d", hst->reg_status);
>> +                     return -EAGAIN;
>> +             }
>> +             err = 0;
>> +     } else if (err == -EPERM) {
>> +             BT_ERR("st_register failed %d", err);
>> +             return err;
>> +     }
>
>
> Again, you are checking for only EPERM and EINPROGRESS. You should check
> for everything. I actually don't undertand why you have a special check
> for EPERM.
>
>> +
>> +     /* ti_st_proto.write is filled up by the underlying shared
>> +      * transport driver upon registration
>> +      */
>> +     hst->st_write = ti_st_proto.write;
>
> I do not like that, the underlying should export the write function.
>
>> +     if (!hst->st_write) {
>> +             BT_ERR("undefined ST write function");
>> +
>> +             /* Undo registration with ST */
>> +             err = st_unregister(ST_BT);
>> +             if (err)
>> +                     BT_ERR("st_unregister() failed with error %d", err);
>> +
>> +             hst->st_write = NULL;
>> +             return err;
>> +     }
>> +
>> +     /* Registration with ST layer is successful,
>> +      * hardware is ready to accept commands from HCI core.
>> +      */
>> +     if (test_and_set_bit(HCI_RUNNING, &hdev->flags)) {
>> +             clear_bit(HCI_RUNNING, &hdev->flags);
>> +             err = st_unregister(ST_BT);
>> +             if (err)
>> +                     BT_ERR("st_unregister() failed with error %d", err);
>> +             hst->st_write = NULL;
>> +     }
>
>
> What are you trying to do here? test_and_set_bit() result doesn't say
> nothing about error and you shall put test_and_set_bit should be in the
> beginning, to know if your device is already opened or not and then
> clear_bit if some error ocurrs during the function.
>
>> +
>> +     return err;
>> +}
>> +
>> +/* Close device */
>> +static int ti_st_close(struct hci_dev *hdev)
>> +{
>> +     int err;
>> +     struct ti_st *hst = hdev->driver_data;
>> +
>> +     /* continue to unregister from transport */
>> +     err = st_unregister(ST_BT);
>> +     if (err)
>> +             BT_ERR("st_unregister() failed with error %d", err);
>> +
>> +     hst->st_write = NULL;
>> +
>> +     if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
>> +             return 0;
>
> test_and_clear_bit should come first to check if your device is already
> closed.
>
>> +
>> +     return err;
>> +}
>> +
>> +static int ti_st_send_frame(struct sk_buff *skb)
>> +{
>> +     struct hci_dev *hdev;
>> +     struct ti_st *hst;
>> +     long len;
>> +
>> +     hdev = (struct hci_dev *)skb->dev;
>> +
>> +     if (!test_bit(HCI_RUNNING, &hdev->flags))
>> +             return -EBUSY;
>> +
>> +     hst = hdev->driver_data;
>> +
>> +     /* Prepend skb with frame type */
>> +     memcpy(skb_push(skb, 1), &bt_cb(skb)->pkt_type, 1);
>> +
>> +     BT_DBG(" %s: type %d len %d", hdev->name, bt_cb(skb)->pkt_type,
>> +                     skb->len);
>> +
>> +     /* Insert skb to shared transport layer's transmit queue.
>> +      * Freeing skb memory is taken care in shared transport layer,
>> +      * so don't free skb memory here.
>> +      */
>> +     len = hst->st_write(skb);
>> +     if (len < 0) {
>> +             kfree_skb(skb);
>> +             BT_ERR(" ST write failed (%ld)", len);
>> +             return -EAGAIN;
>
> Why EAGAIN?
>
>> +     }
>> +
>> +     /* ST accepted our skb. So, Go ahead and do rest */
>> +     hdev->stat.byte_tx += len;
>> +     ti_st_tx_complete(hst, bt_cb(skb)->pkt_type);
>
> From Marcel in the other thread:
> "What is the reason for this deferred stats update. That code looks
> pretty much hackish to me."
>
>> +
>> +     return 0;
>> +}
>> +
>> +static void ti_st_destruct(struct hci_dev *hdev)
>> +{
>> +     BT_DBG("%s", hdev->name);
>> +
>> +     /* free ti_st memory */
>
> get ride of the comment, it's pointless
>
>> +     kfree(hdev->driver_data);
>> +
>> +     return;
>
> No return; here
>
>> +}
>> +
>> +static int bt_ti_probe(struct platform_device *pdev)
>> +{
>> +     static struct ti_st *hst;
>> +     struct hci_dev *hdev;
>> +     int err;
>> +
>> +     hst = kzalloc(sizeof(struct ti_st), GFP_KERNEL);
>> +     if (!hst)
>> +             return -ENOMEM;
>> +
>> +     /* Expose "hciX" device to user space */
>> +     hdev = hci_alloc_dev();
>> +     if (!hdev)
>> +             return -ENOMEM;
>
> You are leaking hst, if hci_alloc_dev() fails.
>
>> +
>> +     BT_DBG("hdev %p", hdev);
>> +
>> +     hst->hdev = hdev;
>> +     hdev->bus = HCI_UART;
>> +     hdev->driver_data = hst;
>> +     hdev->open = ti_st_open;
>> +     hdev->close = ti_st_close;
>> +     hdev->flush = NULL;
>> +     hdev->send = ti_st_send_frame;
>> +     hdev->destruct = ti_st_destruct;
>> +     hdev->owner = THIS_MODULE;
>> +
>> +     err = hci_register_dev(hdev);
>> +     if (err < 0) {
>> +             BT_ERR("Can't register HCI device error %d", err);
>> +             hci_free_dev(hdev);
>> +             return err;
>> +     }
>> +
>> +     BT_DBG(" HCI device registered (hdev %p)", hdev);
>> +
>> +     dev_set_drvdata(&pdev->dev, hst);
>> +     return err;
>> +}
>> +
>> +static int bt_ti_remove(struct platform_device *pdev)
>> +{
>> +     struct hci_dev *hdev;
>> +     struct ti_st *hst = dev_get_drvdata(&pdev->dev);
>> +
>> +     if (!hst)
>> +             return -EFAULT;
>> +
>> +     hdev = hst->hdev;
>> +     ti_st_close(hdev);
>> +     hci_unregister_dev(hdev);
>> +
>> +     /* Free HCI device memory */
>> +     hci_free_dev(hdev);
>> +
>> +     /* Free driver data memory */
>
> get ride of both commnets here. The name of the funcion is already
> saying that.
>
>> +     kfree(hst);
>> +
>> +     dev_set_drvdata(&pdev->dev, NULL);
>> +     return 0;
>> +}
>> +
>> +static struct platform_driver btwilink_driver = {
>> +     .probe = bt_ti_probe,
>> +     .remove = bt_ti_remove,
>> +     .driver = {
>> +             .name = "btwilink",
>> +             .owner = THIS_MODULE,
>> +     },
>> +};
>> +
>> +/* ------- Module Init/Exit interfaces ------ */
>> +static int __init btwilink_init(void)
>> +{
>> +     long ret;
>> +
>> +     BT_INFO(" Bluetooth Driver for TI WiLink - Version %s", VERSION);
>> +
>> +     ret = platform_driver_register(&btwilink_driver);
>> +     if (ret != 0) {
>> +             BT_ERR("btwilink platform driver registration failed");
>> +             return ret;
>> +     }
>> +     return 0;
>
> Old issue again:
>
> From Marcel: please just do like we do with all other drivers;
>
>        BT_INFO(...)
>
>        return platform_driver_register(&btwilink_driver);
>
> --
> Gustavo F. Padovan
> http://profusion.mobi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
