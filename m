Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0JSO4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:56:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60469 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab0JSO4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <1287441278-11284-1-git-send-email-pavan_savoy@ti.com>
References: <1287441278-11284-1-git-send-email-pavan_savoy@ti.com>
Date: Tue, 19 Oct 2010 10:56:00 -0400
Message-ID: <AANLkTi=BYbrVh=oCxZ0xektSxFkg58WJmADS=Ld5f53c@mail.gmail.com>
Subject: Re: [PATCH v2] Bluetooth: btwilink driver
From: Anderson Lizardo <anderson.lizardo@openbossa.org>
To: pavan_savoy@ti.com
Cc: padovan@profusion.mobi, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 6:34 PM,  <pavan_savoy@ti.com> wrote:
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index 02deef4..e0d67dd 100644
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -219,4 +219,14 @@ config BT_ATH3K
>          Say Y here to compile support for "Atheros firmware download driver"
>          into the kernel or say M to compile it as module (ath3k).
>
> +config BT_WILINK
> +       tristate "BlueZ bluetooth driver for TI ST"

I think this has been mentioned before: "BlueZ" is not used in this
context on the kernel. It is also not consistent with the config name
"BT_WILINK". You can follow the pattern from the other entries and
use:

tristate "Texas Instruments WinLink7 driver"

> +       depends on TI_ST
> +       help
> +         This enables the Bluetooth driver for Texas Instrument's BT/FM/GPS
> +         combo devices. This makes use of shared transport line discipline
> +         core driver to communicate with the BT core of the combo chip.
> +
> +         Say Y here to compile support for Texas Instrument's WiLink7 driver
> +         into the kernel or say M to compile it as module.
>  endmenu
> [...]
> diff --git a/drivers/bluetooth/btwilink.c b/drivers/bluetooth/btwilink.c
> new file mode 100644
> index 0000000..e6e2e64
> --- /dev/null
> +++ b/drivers/bluetooth/btwilink.c
> [...]
> +/* Defines number of seconds to wait for reg completion
> + * callback getting called from ST (in case,registration
> + * with ST returns PENDING status)
> + */

I suggest rewriting this comment into:

"Number of seconds to wait for registration completion when ST returns
PENDING status"

> +#define BT_REGISTER_TIMEOUT   6000     /* 6 sec */
> +
> +/**
> + * struct ti_st - BT driver operation structure
> + * @hdev: hci device pointer which binds to bt driver

Just drop "BT" and "bt" here. I think it is clear you are referring to
the Bluetooth driver.

> + * @flags: used locally,to maintain various BT driver status

Suggestion: @flags: driver status flags

(if you can be more specific to which kind of status, it would be even better)

> + * @streg_cbdata: to hold ST registration callback status

You can drop "to hold" here.

> + * @st_write: write function pointer of ST driver

IMHO this description does not add anything to what st_write is for.

> + * @wait_reg_completion - completion sync between ti_st_open
> + *     and ti_st_registration_completion_cb.
> + */
> +struct ti_st {
> +       struct hci_dev *hdev;
> +       char streg_cbdata;
> +       long (*st_write) (struct sk_buff *);
> +       struct completion wait_reg_completion;
> +};
> +
> +static int reset;
> +
> +/* Increments HCI counters based on pocket ID (cmd,acl,sco) */
> +static inline void ti_st_tx_complete(struct ti_st *hst, int pkt_type)
> +{
> +       struct hci_dev *hdev;
> +       hdev = hst->hdev;
> +
> +       /* Update HCI stat counters */
> +       switch (pkt_type) {
> +       case HCI_COMMAND_PKT:
> +               hdev->stat.cmd_tx++;
> +               break;
> +
> +       case HCI_ACLDATA_PKT:
> +               hdev->stat.acl_tx++;
> +               break;
> +
> +       case HCI_SCODATA_PKT:
> +               hdev->stat.sco_tx++;
> +               break;
> +       }
> +}
> +
> +/* ------- Interfaces to Shared Transport ------ */
> +
> +/* Called by ST layer to indicate protocol registration completion
> + * status.ti_st_open() function will wait for signal from this
> + * API when st_register() function returns ST_PENDING.
> + */
> +static void st_registration_completion_cb(void *priv_data, char data)
> +{
> +       struct ti_st *lhst = (struct ti_st *)priv_data;

Is this explicit cast necessary?

> +
> +       /* ti_st_open() function needs value of 'data' to know
> +        * the registration status(success/fail),So have a back
> +        * up of it.
> +        */

Suggestion:  /* Save registration status for use in ti_st_open() */

> +       lhst->streg_cbdata = data;
> +
> +       /* Got a feedback from ST for BT driver registration
> +        * request.Wackup ti_st_open() function to continue
> +        * it's open operation.
> +        */

Too much BT here. If it means "Bluetooth", you don't need to use it
every time. Additionally, I don't get what the above comment means.

> +       complete(&lhst->wait_reg_completion);
> +}
> +
> +/* Called by Shared Transport layer when receive data is
> + * available */
> +static long st_receive(void *priv_data, struct sk_buff *skb)

Can this function return "int" instead? It is more common for
functions which return just a error value.

> +{
> +       int err;
> +       struct ti_st *lhst = (struct ti_st *)priv_data;

Again, is this cast necessary?

> +
> +       if (!skb)
> +               return -EFAULT;
> +
> +       if (!lhst) {
> +               kfree_skb(skb);
> +               return -EFAULT;
> +       }
> +
> +       skb->dev = (struct net_device *)lhst->hdev;
> +
> +       /* Forward skb to HCI core layer */
> +       err = hci_recv_frame(skb);
> +       if (err) {
> +               kfree_skb(skb);
> +               BT_ERR("Unable to push skb to HCI core(%d)", err);
> +               return err;
> +       }
> +
> +       lhst->hdev->stat.byte_rx += skb->len;

Add a blank like here.

> +       return 0;
> +}
> +
> +/* ------- Interfaces to HCI layer ------ */
> +/* protocol structure registered with shared transport */
> +static struct st_proto_s ti_st_proto = {
> +       .type = ST_BT,
> +       .recv = st_receive,
> +       .reg_complete_cb = st_registration_completion_cb,
> +       .priv_data = NULL,
> +};
> +
> +/* Called from HCI core to initialize the device */
> +static int ti_st_open(struct hci_dev *hdev)
> +{
> +       unsigned long timeleft;
> +       struct ti_st *hst;
> +       int err;
> +
> +       BT_DBG("%s %p", hdev->name, hdev);
> +
> +       /* provide contexts for callbacks from ST */
> +       hst = hdev->driver_data;
> +       ti_st_proto.priv_data = hst;
> +
> +       err = st_register(&ti_st_proto);
> +       if (err == -EINPROGRESS) {
> +               /* Prepare wait-for-completion handler data structures.
> +                * Needed to syncronize this and st_registration_completion_cb()
> +                * functions.
> +                */

syncronize -> synchronize

> +               init_completion(&hst->wait_reg_completion);
> +
> +               /* Reset ST registration callback status flag , this value
> +                * will be updated in ti_st_registration_completion_cb()
> +                * function whenever it called from ST driver.
> +                */
> +               hst->streg_cbdata = -EINPROGRESS;

If this field is used solely for holding status values, why not call
it "reg_status" or something like that? "cbdata" is more for opaque
parameters IMHO.

> +
> +               /* ST is busy with other protocol registration(may be busy with
> +                * firmware download).So,Wait till the registration callback
> +                * (passed as a argument to st_register() function) getting
> +                * called from ST.
> +                */

"ST is busy with either protocol registration or firmware download.
Wait until the registration callback is called."

Is it clearer?

> +               BT_DBG(" waiting for reg completion signal from ST");

BT_DBG("Waiting for registration completion signal from ST");

> +
> +               timeleft = wait_for_completion_timeout
> +                       (&hst->wait_reg_completion,
> +                        msecs_to_jiffies(BT_REGISTER_TIMEOUT));
> +               if (!timeleft) {
> +                       BT_ERR("Timeout(%d sec),didn't get reg "
> +                                       "completion signal from ST",
> +                                       BT_REGISTER_TIMEOUT / 1000);
> +                       return -ETIMEDOUT;
> +               }
> +
> +               /* Is ST registration callback called with ERROR value? */

ERROR value -> "error status"

> +               if (hst->streg_cbdata != 0) {
> +                       BT_ERR("ST reg completion CB called with invalid"
> +                                       "status %d", hst->streg_cbdata);

Too much abbreviations here:

reg -> registration
CB -> callback

Also you are truncating the C string wrong here (and maybe in other
places). It will be print as "invalidstatus". Use either
"...invalid<space>" (1st line) or "<space>status..." (2nd line).

> +                       return -EAGAIN;
> +               }
> +               err = 0;
> +       } else if (err == -EPERM) {
> +               BT_ERR("st_register failed %d", err);
> +               return err;
> +       }
> +

You could assign hst->st_write right here:

hst->st_write = ti_st_proto.write;

And simplify the if/else below to:

if (!hst->st_write) {
    BT_ERR(....);
...
}

(i.e. invert the check logic and drop the "!= NULL" case)

> +       /* Do we have proper ST write function? */
> +       if (ti_st_proto.write != NULL) {
> +               /* We need this pointer for sending any Bluetooth pkts */
> +               hst->st_write = ti_st_proto.write;
> +       } else {
> +               BT_ERR("failed to get ST write func pointer");

This error message could be:

BT_ERR("undefined ST write function");

*Although* I think the whole check is in the wrong place. I think this
check should be inside the function which sets ti_st_proto.write.

> +
> +               /* Undo registration with ST */
> +               err = st_unregister(ST_BT);
> +               if (err)
> +                       BT_ERR("st_unregister failed %d", err);

Suggestion:

BT_ERR("st_unregister() failed with error %d", err);

> +
> +               hst->st_write = NULL;
> +               return err;
> +       }
> +
> +       /* Registration with ST layer is completed successfully,
> +        * now chip is ready to accept commands from HCI core.
> +        * Mark HCI Device flag as RUNNING
> +        */

The comment above could be summed as:

/* Registration with ST layer was successful and hardware is ready to
accept commands from HCI core. */

> +       set_bit(HCI_RUNNING, &hdev->flags);

Add a blank line here.

> +       return err;
> +}
> +
> +/* Close device */
> +static int ti_st_close(struct hci_dev *hdev)
> +{
> +       int err;
> +       struct ti_st *hst = hdev->driver_data;
> +
> +       /* continue to unregister from transport */
> +       err = st_unregister(ST_BT);
> +       if (err)
> +               BT_ERR("st_unregister failed %d", err);

BT_ERR("st_unregister() failed with error %d", err);

> +
> +       hst->st_write = NULL;

Add a blank line here.

> +       return err;
> +}
> +
> +/* Called from HCI core, Sends frames to Shared Transport */

IMHO the comment above can be dropped (it is too obvious).

> +static int ti_st_send_frame(struct sk_buff *skb)
> +{
> +       struct hci_dev *hdev;
> +       struct ti_st *hst;
> +       long len;
> +
> +       if (!skb)
> +               return -ENOMEM;
> +
> +       hdev = (struct hci_dev *)skb->dev;
> +       if (!hdev)
> +               return -ENODEV;
> +
> +       if (!test_bit(HCI_RUNNING, &hdev->flags))
> +               return -EBUSY;
> +
> +       hst = (struct ti_st *)hdev->driver_data;
> +
> +       /* Prepend skb with frame type */
> +       memcpy(skb_push(skb, 1), &bt_cb(skb)->pkt_type, 1);
> +
> +       BT_DBG(" %s: type %d len %d", hdev->name, bt_cb(skb)->pkt_type,
> +                       skb->len);
> +
> +       /* Insert skb to shared transport layer's transmit queue.
> +        * Freeing skb memory is taken care in shared transport layer,
> +        * so don't free skb memory here.
> +        */
> +       if (!hst->st_write) {
> +               kfree_skb(skb);
> +               BT_ERR(" Can't write to ST, st_write null?");

Suggestion: BT_ERR("Could not write to ST (st_write is NULL)");

> +               return -EAGAIN;
> +       }
> +
> +       len = hst->st_write(skb);
> +       if (len < 0) {
> +               kfree_skb(skb);
> +               BT_ERR(" ST write failed (%ld)", len);
> +               return -EAGAIN;
> +       }
> +
> +       /* ST accepted our skb. So, Go ahead and do rest */
> +       hdev->stat.byte_tx += len;
> +       ti_st_tx_complete(hst, bt_cb(skb)->pkt_type);
> +
> +       return 0;
> +}
> +
> +static void ti_st_destruct(struct hci_dev *hdev)
> +{
> +       if (!hdev)
> +               BT_ERR("Destruct called with invalid HCI Device"
> +                               "(hdev=NULL)");

There is a "return" missing here. Also I don't think this error
message is necessary at all. You could have just:

if (!hdev)
    return;

> +
> +       BT_DBG("%s", hdev->name);
> +
> +       /* free ti_st memory */
> +       kfree(hdev->driver_data);

add a blank line here.

> +       return;
> +}
> +
> +/* Creates new HCI device */
> +static int ti_st_register_dev(struct ti_st *hst)
> +{
> +       int err;
> +       struct hci_dev *hdev;
> +
> +       /* Initialize and register HCI device */
> +       hdev = hci_alloc_dev();
> +       if (!hdev)
> +               return -ENOMEM;
> +
> +       BT_DBG("hdev= %p", hdev);

BT_DBG("hdev %p", hdev);

> +
> +       hst->hdev = hdev;
> +       hdev->bus = HCI_UART;
> +       hdev->driver_data = hst;
> +       hdev->open = ti_st_open;
> +       hdev->close = ti_st_close;
> +       hdev->flush = NULL;
> +       hdev->send = ti_st_send_frame;
> +       hdev->destruct = ti_st_destruct;
> +       hdev->owner = THIS_MODULE;
> +
> +       if (reset)
> +               set_bit(HCI_QUIRK_NO_RESET, &hdev->quirks);
> +
> +       err = hci_register_dev(hdev);
> +       if (err < 0) {
> +               BT_ERR("Can't register HCI device");

Print the err value on the message above.

> +               hci_free_dev(hdev);
> +               return err;
> +       }
> +
> +       BT_DBG(" HCI device registered. hdev= %p", hdev);

Suggestion:  BT_DBG("HCI device registered (hdev %p)", hdev);

> +       return 0;
> +}
> +
> +
> +static int bt_ti_probe(struct platform_device *pdev)
> +{
> +       int err;
> +       static struct ti_st *hst;
> +
> +       BT_DBG(" Bluetooth Driver Version %s", VERSION);
> +
> +       hst = kzalloc(sizeof(struct ti_st), GFP_KERNEL);
> +       if (!hst)
> +               return -ENOMEM;
> +
> +       /* Expose "hciX" device to user space */
> +       err = ti_st_register_dev(hst);
> +       if (err) {
> +               kfree(hst);
> +               return err;
> +       }
> +
> +       dev_set_drvdata(&pdev->dev, hst);
> +       return err;
> +}
> +
> +static int bt_ti_remove(struct platform_device *pdev)
> +{
> +       struct ti_st *hst;
> +
> +       hst = dev_get_drvdata(&pdev->dev);
> +       /* Deallocate local resource's memory  */

You can invert the hst check:

if (!hst)
    return <some_error_code>;

And reduce put the code below outside the if(). Also note that the
current code always returns 0. It should return error for hst == NULL
and hdev == NULL.

> +       if (hst) {
> +               struct hci_dev *hdev = hst->hdev;
> +               if (!hdev) {
> +                       BT_ERR("Invalid hdev memory");

The error message above is not informative.

> +                       kfree(hst);
> +               } else {
> +                       ti_st_close(hdev);
> +                       hci_unregister_dev(hdev);
> +                       /* Free HCI device memory */
> +                       hci_free_dev(hdev);
> +               }
> +       }
> +       return 0;
> +}
> +
> +static struct platform_driver btwilink_driver = {
> +       .probe = bt_ti_probe,
> +       .remove = bt_ti_remove,
> +       .driver = {
> +               .name = "btwilink",
> +               .owner = THIS_MODULE,
> +       },
> +};
> +
> +/* ------- Module Init/Exit interfaces ------ */
> +static int __init bt_drv_init(void)
> +{
> +       long ret;
> +
> +       ret = platform_driver_register(&btwilink_driver);
> +       if (ret != 0) {
> +               BT_ERR("btwilink platform driver registration failed");
> +               return -EPERM;

-EPERM for a registration failure? Looks strange to me.

> +       }
> +       return 0;
> +}
> +
> +static void __exit bt_drv_exit(void)
> +{
> +       platform_driver_unregister(&btwilink_driver);
> +}
> +
> +module_init(bt_drv_init);
> +module_exit(bt_drv_exit);
> +
> +/* ------ Module Info ------ */
> +
> +module_param(reset, bool, 0644);
> +MODULE_PARM_DESC(reset, "Send HCI reset command on initialization");
> +MODULE_AUTHOR("Raja Mani <raja_mani@ti.com>");
> +MODULE_DESCRIPTION("Bluetooth Driver for TI Shared Transport" VERSION);
> +MODULE_VERSION(VERSION);
> +MODULE_LICENSE("GPL");
> --
> 1.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


Regards,
-- 
Anderson Lizardo
OpenBossa Labs - INdT
Manaus - Brazil
