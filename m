Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab0JMVsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 17:48:42 -0400
Received: from senator.holtmann.net ([87.106.208.187]:37204 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab0JMVsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 17:48:41 -0400
Subject: Re: [PATCH 6/6] This patch adds support for using the ST-Ericsson
 CG2900
From: Marcel Holtmann <marcel@holtmann.org>
To: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Pavan Savoy <pavan_savoy@sify.com>
In-Reply-To: <AANLkTinCUscmm=1t7iEAz2LQ0O_TM5-G7zANhLcuA-d9@mail.gmail.com>
References: <AANLkTimOai9_92VuJUZMo26es9Wsu_6d+z36Sv_Q4i+L@mail.gmail.com>
	 <1286270443.17473.62.camel@aeonflux>
	 <AANLkTinCUscmm=1t7iEAz2LQ0O_TM5-G7zANhLcuA-d9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 00:48:36 +0300
Message-ID: <1287006516.3316.17.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Par-Gunnar,

> Sorry for not answering to your mail earlier. I've been on a business
> trip whole last week where I just did not have the possibility to
> answer.
> 
> We are currently working on a new version of our driver, both the MFD
> and the Bluetooth part, where we address the comments that we have so
> far received. Hopefully I will able to send it later this week.
> 
> As answer to last mail: yes, we will change our debug system to be
> reuse existing functionality in the Kernel.

sounds good to me. dynamic debug is actually pretty nice :)

> 
> /P-G
> 
> 2010/10/5 Marcel Holtmann <marcel@holtmann.org>:
> > Hi Par-Gunnar,
> >
> >> This patch adds support for using the ST-Ericsson CG2900
> >>  connectivity controller as a driver for the BlueZ Bluetooth
> >>  stack.
> >>  This patch registers as a driver into the BlueZ framework and, when
> >>  opened by BlueZ, it registers as user for bt_cmd, bt_acl, and bt_evt
> >>  channels.
> >>
> >> Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
> >> ---
> >>  drivers/bluetooth/Kconfig      |    7 +
> >>  drivers/bluetooth/Makefile     |    2 +
> >>  drivers/bluetooth/cg2900_hci.c |  896 ++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 905 insertions(+), 0 deletions(-)
> >>  create mode 100644 drivers/bluetooth/cg2900_hci.c
> >>
> >> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> >> index 02deef4..9ca8d69 100644
> >> --- a/drivers/bluetooth/Kconfig
> >> +++ b/drivers/bluetooth/Kconfig
> >> @@ -219,4 +219,11 @@ config BT_ATH3K
> >>         Say Y here to compile support for "Atheros firmware download driver"
> >>         into the kernel or say M to compile it as module (ath3k).
> >>
> >> +config BT_CG2900
> >> +     tristate "ST-Ericsson CG2900 driver"
> >> +     depends on MFD_CG2900 && BT
> >> +     help
> >> +       Select if ST-Ericsson CG2900 Connectivity controller shall be used as
> >> +       Bluetooth controller for BlueZ.
> >> +
> >>  endmenu
> >> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> >> index 71bdf13..a479c16 100644
> >> --- a/drivers/bluetooth/Makefile
> >> +++ b/drivers/bluetooth/Makefile
> >> @@ -19,6 +19,8 @@ obj-$(CONFIG_BT_ATH3K)              += ath3k.o
> >>  obj-$(CONFIG_BT_MRVL)                += btmrvl.o
> >>  obj-$(CONFIG_BT_MRVL_SDIO)   += btmrvl_sdio.o
> >>
> >> +obj-$(CONFIG_BT_CG2900)              += cg2900_hci.o
> >> +
> >
> > Please sort this after ath3k and before btmvrl config.
> >
> > And for the name either just use cg2900 if it uniquely identifies the
> > Bluetooth chip used in the combo or use btcg2900.o as module name if it
> > is the name of the combo module.
> >
> > We clearly moved into the direction of either unique hardware names
> > without bt prefix or we have the bt prefix in front of it. The fully
> > generic term hci will be phased out of the driver names.
> >
> 
> I can change the name to btcg2900.o since the whole chip is called
> cg2900 and this file is just for the BT part of it.
> I will also sort it correctly into the file.

Actually btcg2900.ko sounds good to me.

> >>  btmrvl-y                     := btmrvl_main.o
> >>  btmrvl-$(CONFIG_DEBUG_FS)    += btmrvl_debugfs.o
> >>
> >> diff --git a/drivers/bluetooth/cg2900_hci.c b/drivers/bluetooth/cg2900_hci.c
> >> new file mode 100644
> >> index 0000000..de1ada8
> >> --- /dev/null
> >> +++ b/drivers/bluetooth/cg2900_hci.c
> >> @@ -0,0 +1,896 @@
> >> +/*
> >> + * drivers/bluetooth/cg2900_hci.c
> >> + *
> >> + * Copyright (C) ST-Ericsson SA 2010
> >> + * Authors:
> >> + * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
> >> ST-Ericsson.
> >> + * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
> >> + * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
> >> + * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
> >> + * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
> >> + * License terms:  GNU General Public License (GPL), version 2
> >> + *
> >> + * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 connectivity
> >> controller
> >> + * towards the BlueZ Bluetooth stack.
> >> + */
> >
> > Drop the filename in this header and don't bother with the description
> > towards BlueZ or Bluetooth subsystem. That is clear from the location of
> > the file.
> >
> > Also what is up with the "for ST-Ericsson"?
> >
> 
> OK regarding the header comments. We have been instructed to use "for
> ST-Ericsson" when writing author name. Is that a problem?

I find this fully pointless since a) you have an stericsson.com email
address and b) the code is copyright by ST-Ericsson. So my take is, yes,
we get it ST-Ericsson has written this code.

> >> +
> >> +#include <linux/module.h>
> >> +#include <linux/types.h>
> >> +#include <linux/skbuff.h>
> >> +#include <asm/byteorder.h>
> >> +#include <net/bluetooth/bluetooth.h>
> >> +#include <net/bluetooth/hci.h>
> >> +#include <net/bluetooth/hci_core.h>
> >> +
> >> +#include <linux/workqueue.h>
> >> +#include <linux/wait.h>
> >> +#include <linux/time.h>
> >> +#include <linux/jiffies.h>
> >> +#include <linux/sched.h>
> >> +#include <linux/timer.h>
> >> +
> >> +#include <linux/mfd/cg2900.h>
> >> +#include <mach/cg2900_devices.h>
> >> +
> >> +/* module_param declared in cg2900_core.c */
> >> +extern int cg2900_debug_level;
> >> +
> >> +#define NAME                 "CG2900 HCI"
> >> +
> >> +/* Debug defines */
> >> +#define CG2900_DBG_DATA(fmt, arg...)                         \
> >> +do {                                                         \
> >> +     if (cg2900_debug_level >= 25)                           \
> >> +             printk(KERN_DEBUG NAME " %s: " fmt "\n" , __func__ , ## arg); \
> >> +} while (0)
> >> +
> >> +#define CG2900_DBG(fmt, arg...)                              \
> >> +do {                                                         \
> >> +     if (cg2900_debug_level >= 20)                           \
> >> +             printk(KERN_DEBUG NAME " %s: " fmt "\n" , __func__ , ## arg); \
> >> +} while (0)
> >> +
> >> +#define CG2900_INFO(fmt, arg...)                             \
> >> +do {                                                         \
> >> +     if (cg2900_debug_level >= 10)                           \
> >> +             printk(KERN_INFO NAME ": " fmt "\n" , ## arg); \
> >> +} while (0)
> >> +
> >> +#define CG2900_ERR(fmt, arg...)                                      \
> >> +do {                                                         \
> >> +     if (cg2900_debug_level >= 1)                            \
> >> +             printk(KERN_ERR NAME " %s: " fmt "\n" , __func__ , ## arg); \
> >> +} while (0)
> >
> > Remove all this debug stuff. Use BT_DBG, BT_ERR etc.
> 
> OK
> 
> >
> >> +#define CG2900_SET_STATE(__name, __var, __new_state)                 \
> >> +do {                                                                 \
> >> +     CG2900_DBG("New %s: 0x%X", __name, (uint32_t)__new_state);      \
> >> +     __var = __new_state;                                            \
> >> +} while (0)
> >
> > What is this for? Please don't do that. It just obfuscates the code.
> >
> 
> Is it OK to use inline functions instead of defines? It's pretty
> useful to be able to printout when changing state.
> So something like:
> 
> static inline void set_reset_state(enum reset_state new_state)
> {
>   BT_DBG("New reset state: %x", new_state);
>   hci_info->reset_state = new_state;
> }

Not really. It just clutters the code. Do the debugging with dynamic
debug and keep the code readable.

I do see where you are coming from and it might be useful during initial
development. For longterm maintainability this is not helping.

> >> +/* HCI device type */
> >> +#define HCI_CG2900           HCI_VIRTUAL
> >
> > This is the wrong type. Don't do that. And don't create a new define for
> > it. Use the standard types. I assume that HCI_UART is most likely what
> > you want here.
> >
> 
> The problem here is that the physical transport used is not shown for
> this module. It is handled with the CG2900 MFD driver. But I guess I
> could expose the type through an API function.

Yes, please do that instead, but essentially HCI_UART is a way better
fit than HCI_VIRTUAL if you are in doubt.

> >> +/* Wait for 5 seconds for a response to our requests */
> >> +#define RESP_TIMEOUT         5000
> >> +
> >> +/* State-setting defines */
> >> +#define SET_RESET_STATE(__hci_reset_new_state) \
> >> +     CG2900_SET_STATE("reset_state", hci_info->reset_state, \
> >> +                      __hci_reset_new_state)
> >> +#define SET_ENABLE_STATE(__hci_enable_new_state) \
> >> +     CG2900_SET_STATE("enable_state", hci_info->enable_state, \
> >> +                      __hci_enable_new_state)
> >
> > Don't do this. It is just highly obfuscating the code flow.
> >
> 
> As stated above, is it OK to use static inline functions instead?

No. Just fix the code to do it properly there. You will see that it is
just fine.

> >> +/* Bluetooth error codes */
> >> +#define HCI_ERR_NO_ERROR                     0x00
> >> +#define HCI_ERR_CMD_DISALLOWED                       0x0C
> >> +
> >> +/**
> >> + * enum reset_state - RESET-states of the HCI driver.
> >> + *
> >> + * @RESET_IDLE:              No reset in progress.
> >> + * @RESET_ACTIVATED: Reset in progress.
> >> + * @RESET_UNREGISTERED:      hdev is unregistered.
> >> + */
> >> +
> >> +enum reset_state {
> >> +     RESET_IDLE,
> >> +     RESET_ACTIVATED,
> >> +     RESET_UNREGISTERED
> >> +};
> >> +
> >> +/**
> >> + * enum enable_state - ENABLE-states of the HCI driver.
> >> + *
> >> + * @ENABLE_IDLE:                     The HCI driver is loaded but not opened.
> >> + * @ENABLE_WAITING_BT_ENABLED_CC:    The HCI driver is waiting for a command
> >> + *                                   complete event from the BT chip as a
> >> + *                                   response to a BT Enable (true) command.
> >> + * @ENABLE_BT_ENABLED:                       The BT chip is enabled.
> >> + * @ENABLE_WAITING_BT_DISABLED_CC:   The HCI driver is waiting for a command
> >> + *                                   complete event from the BT chip as a
> >> + *                                   response to a BT Enable (false) command.
> >> + * @ENABLE_BT_DISABLED:                      The BT chip is disabled.
> >> + * @ENABLE_BT_ERROR:                 The HCI driver is in a bad state, some
> >> + *                                   thing has failed and is not expected to
> >> + *                                   work properly.
> >> + */
> >> +enum enable_state {
> >> +     ENABLE_IDLE,
> >> +     ENABLE_WAITING_BT_ENABLED_CC,
> >> +     ENABLE_BT_ENABLED,
> >> +     ENABLE_WAITING_BT_DISABLED_CC,
> >> +     ENABLE_BT_DISABLED,
> >> +     ENABLE_BT_ERROR
> >> +};
> >> +
> >> +/**
> >> + * struct hci_info - Specifies HCI driver private data.
> >> + *
> >> + * This type specifies CG2900 HCI driver private data.
> >> + *
> >> + * @bt_cmd:          Device structure for BT command channel.
> >> + * @bt_evt:          Device structure for BT event channel.
> >> + * @bt_acl:          Device structure for BT ACL channel.
> >> + * @hdev:            Device structure for HCI device.
> >> + * @reset_state:     Device enum for HCI driver reset state.
> >> + * @enable_state:    Device enum for HCI driver BT enable state.
> >> + */
> >> +struct hci_info {
> >> +     struct cg2900_device    *bt_cmd;
> >> +     struct cg2900_device    *bt_evt;
> >> +     struct cg2900_device    *bt_acl;
> >> +     struct hci_dev          *hdev;
> >> +     enum reset_state        reset_state;
> >> +     enum enable_state       enable_state;
> >> +};
> >> +
> >> +/**
> >> + * struct dev_info - Specifies private data used when receiving
> >> callbacks from CPD.
> >> + *
> >> + * @hdev:            Device structure for HCI device.
> >> + * @hci_data_type:   Type of data according to BlueZ.
> >> + */
> >> +struct dev_info {
> >> +     struct hci_dev  *hdev;
> >> +     u8              hci_data_type;
> >> +};
> >> +
> >> +/* Variables where LSB and MSB for bt_enable command is stored */
> >> +static u16 bt_enable_cmd;
> >> +
> >> +static struct hci_info *hci_info;
> >> +
> >> +/*
> >> + * hci_wait_queue - Main Wait Queue in HCI driver.
> >> + */
> >> +static DECLARE_WAIT_QUEUE_HEAD(hci_wait_queue);
> >> +
> >> +/* Internal function declarations */
> >> +static int register_to_bluez(void);
> >
> > Don't use bluez in kernel code. Just use bluetooth or bt.
> >
> 
> OK
> 
> >> +/* Internal functions */
> >> +
> >> +/**
> >> + * remove_bt_users() - Unregister and remove any existing BT users.
> >> + * @info:    HCI driver info structure.
> >> + */
> >> +static void remove_bt_users(struct hci_info *info)
> >> +{
> >> +     if (info->bt_cmd) {
> >> +             kfree(info->bt_cmd->user_data);
> >> +             info->bt_cmd->user_data = NULL;
> >> +             cg2900_deregister_user(info->bt_cmd);
> >> +             info->bt_cmd = NULL;
> >> +     }
> >> +
> >> +     if (info->bt_evt) {
> >> +             kfree(info->bt_evt->user_data);
> >> +             info->bt_evt->user_data = NULL;
> >> +             cg2900_deregister_user(info->bt_evt);
> >> +             info->bt_evt = NULL;
> >> +     }
> >> +
> >> +     if (info->bt_acl) {
> >> +             kfree(info->bt_acl->user_data);
> >> +             info->bt_acl->user_data = NULL;
> >> +             cg2900_deregister_user(info->bt_acl);
> >> +             info->bt_acl = NULL;
> >> +     }
> >> +}
> >> +
> >> +/**
> >> + * hci_read_cb() - Callback for handling data received from CG2900 driver.
> >> + * @dev:     Device receiving data.
> >> + * @skb:     Buffer with data coming from device.
> >> + */
> >> +static void hci_read_cb(struct cg2900_device *dev, struct sk_buff *skb)
> >> +{
> >> +     int err = 0;
> >> +     struct dev_info *dev_info;
> >> +     struct hci_event_hdr *evt;
> >> +     struct hci_ev_cmd_complete *cmd_complete;
> >> +     struct hci_ev_cmd_status *cmd_status;
> >> +     u8 status;
> >> +
> >> +     if (!skb) {
> >> +             CG2900_ERR("NULL supplied for skb");
> >> +             return;
> >> +     }
> >> +
> >> +     if (!dev) {
> >> +             CG2900_ERR("dev == NULL");
> >> +             goto fin_free_skb;
> >> +     }
> >> +
> >> +     dev_info = (struct dev_info *)dev->user_data;
> >> +
> >> +     if (!dev_info) {
> >> +             CG2900_ERR("dev_info == NULL");
> >> +             goto fin_free_skb;
> >> +     }
> >> +
> >> +     evt = (struct hci_event_hdr *)skb->data;
> >> +     cmd_complete = (struct hci_ev_cmd_complete *)(skb->data + sizeof(*evt));
> >> +     cmd_status = (struct hci_ev_cmd_status *)(skb->data + sizeof(*evt));
> >> +
> >> +     /*
> >> +      * Check if HCI Driver it self is expecting a Command Complete packet
> >> +      * from the chip after a BT Enable command.
> >> +      */
> >> +     if ((hci_info->enable_state == ENABLE_WAITING_BT_ENABLED_CC ||
> >> +          hci_info->enable_state == ENABLE_WAITING_BT_DISABLED_CC) &&
> >> +         hci_info->bt_evt->h4_channel == dev->h4_channel &&
> >> +         evt->evt == HCI_EV_CMD_COMPLETE &&
> >> +         le16_to_cpu(cmd_complete->opcode) == bt_enable_cmd) {
> >> +             /*
> >> +              * This is the command complete event for
> >> +              * the HCI_Cmd_VS_Bluetooth_Enable.
> >> +              * Check result and update state.
> >> +              *
> >> +              * The BT chip is enabled/disabled. Either it was enabled/
> >> +              * disabled now (status NO_ERROR) or it was already enabled/
> >> +              * disabled (assuming status CMD_DISALLOWED is already enabled/
> >> +              * disabled).
> >> +              */
> >> +             status = *(skb->data + sizeof(*evt) + sizeof(*cmd_complete));
> >> +             if (status != HCI_ERR_NO_ERROR &&
> >> +                 status != HCI_ERR_CMD_DISALLOWED) {
> >> +                     CG2900_ERR("Could not enable/disable BT core (0x%X)",
> >> +                                status);
> >> +                     SET_ENABLE_STATE(ENABLE_BT_ERROR);
> >> +                     goto fin_free_skb;
> >> +             }
> >> +
> >> +             if (hci_info->enable_state == ENABLE_WAITING_BT_ENABLED_CC) {
> >> +                     SET_ENABLE_STATE(ENABLE_BT_ENABLED);
> >> +                     CG2900_INFO("BT core is enabled");
> >> +             } else {
> >> +                     SET_ENABLE_STATE(ENABLE_BT_DISABLED);
> >> +                     CG2900_INFO("BT core is disabled");
> >> +             }
> >> +
> >> +             /* Wake up whom ever is waiting for this result. */
> >> +             wake_up_interruptible(&hci_wait_queue);
> >> +             goto fin_free_skb;
> >> +     } else if ((hci_info->enable_state == ENABLE_WAITING_BT_DISABLED_CC ||
> >> +                 hci_info->enable_state == ENABLE_WAITING_BT_ENABLED_CC) &&
> >> +                hci_info->bt_evt->h4_channel == dev->h4_channel &&
> >> +                evt->evt == HCI_EV_CMD_STATUS &&
> >> +                le16_to_cpu(cmd_status->opcode) == bt_enable_cmd) {
> >> +             /*
> >> +              * Clear the status events since the Bluez is not expecting
> >> +              * them.
> >> +              */
> >> +             CG2900_DBG("HCI Driver received Command Status(for "
> >> +                        "BT enable): 0x%X", cmd_status->status);
> >> +             /*
> >> +              * This is the command status event for
> >> +              * the HCI_Cmd_VS_Bluetooth_Enable.
> >> +              * Just free the packet.
> >> +              */
> >> +             goto fin_free_skb;
> >> +     } else {
> >> +             bt_cb(skb)->pkt_type = dev_info->hci_data_type;
> >> +             skb->dev = (struct net_device *)dev_info->hdev;
> >> +             /* Update BlueZ stats */
> >> +             dev_info->hdev->stat.byte_rx += skb->len;
> >> +             if (bt_cb(skb)->pkt_type == HCI_ACLDATA_PKT)
> >> +                     dev_info->hdev->stat.acl_rx++;
> >> +             else
> >> +                     dev_info->hdev->stat.evt_rx++;
> >> +
> >> +             CG2900_DBG_DATA("Data receive %d bytes", skb->len);
> >> +
> >> +             /* Provide BlueZ with received frame*/
> >> +             err = hci_recv_frame(skb);
> >> +             /* If err, skb have been freed in hci_recv_frame() */
> >> +             if (err)
> >> +                     CG2900_ERR("Failed in supplying packet to BlueZ (%d)",
> >> +                                err);
> >> +     }
> >> +
> >> +     return;
> >> +
> >> +fin_free_skb:
> >> +     kfree_skb(skb);
> >> +}
> >> +
> >> +/**
> >> + * hci_reset_cb() - Callback for handling reset from CG2900 driver.
> >> + * @dev:     CPD device resetting.
> >> + */
> >> +static void hci_reset_cb(struct cg2900_device *dev)
> >> +{
> >> +     int err;
> >> +     struct hci_dev *hdev;
> >> +     struct dev_info *dev_info;
> >> +     struct hci_info *info;
> >> +
> >> +     CG2900_INFO("BluezDriver: hci_reset_cb");
> >> +
> >> +     if (!dev) {
> >> +             CG2900_ERR("NULL supplied for dev");
> >> +             return;
> >> +     }
> >> +
> >> +     dev_info = (struct dev_info *)dev->user_data;
> >> +     if (!dev_info) {
> >> +             CG2900_ERR("NULL supplied for dev_info");
> >> +             return;
> >> +     }
> >> +
> >> +     hdev = dev_info->hdev;
> >> +     if (!hdev) {
> >> +             CG2900_ERR("NULL supplied for hdev");
> >> +             return;
> >> +     }
> >> +
> >> +     info = (struct hci_info *)hdev->driver_data;
> >> +     if (!info) {
> >> +             CG2900_ERR("NULL supplied for driver_data");
> >> +             return;
> >> +     }
> >> +
> >> +     switch (dev_info->hci_data_type) {
> >> +
> >> +     case HCI_EVENT_PKT:
> >> +             info->bt_evt = NULL;
> >> +             break;
> >> +
> >> +     case HCI_COMMAND_PKT:
> >> +             info->bt_cmd = NULL;
> >> +             break;
> >> +
> >> +     case HCI_ACLDATA_PKT:
> >> +             info->bt_acl = NULL;
> >> +             break;
> >> +
> >> +     default:
> >> +             CG2900_ERR("Unknown HCI data type:%d",
> >> +                        dev_info->hci_data_type);
> >> +             return;
> >> +     }
> >> +
> >> +     SET_RESET_STATE(RESET_ACTIVATED);
> >> +
> >> +     /* Free userdata as device info structure will be freed by CG2900
> >> +      * when this callback returns */
> >> +     kfree(dev->user_data);
> >> +     dev->user_data = NULL;
> >> +
> >> +     /*
> >> +      * Continue to deregister hdev if all channels has been reset else
> >> +      * return.
> >> +      */
> >> +     if (info->bt_evt || info->bt_cmd || info->bt_acl)
> >> +             return;
> >> +
> >> +     /*
> >> +      * Deregister HCI device. Close and Destruct functions should
> >> +      * in turn be called by BlueZ.
> >> +      */
> >> +     CG2900_INFO("Deregister HCI device");
> >> +     err = hci_unregister_dev(hdev);
> >> +     if (err)
> >> +             CG2900_ERR("Can not deregister HCI device! (%d)", err);
> >> +             /*
> >> +              * Now we are in trouble. Try to register a new hdev
> >> +              * anyway even though this will cost some memory.
> >> +              */
> >> +
> >> +     wait_event_interruptible_timeout(hci_wait_queue,
> >> +                             (RESET_UNREGISTERED == hci_info->reset_state),
> >> +                             msecs_to_jiffies(RESP_TIMEOUT));
> >> +     if (RESET_UNREGISTERED != hci_info->reset_state)
> >> +             /*
> >> +              * Now we are in trouble. Try to register a new hdev
> >> +              * anyway even though this will cost some memory.
> >> +              */
> >> +             CG2900_ERR("Timeout expired. Could not deregister HCI device");
> >> +
> >> +     /* Init and register hdev */
> >> +     CG2900_INFO("Register HCI device");
> >> +     err = register_to_bluez();
> >> +     if (err)
> >> +             CG2900_ERR("HCI Device registration error (%d).", err);
> >> +}
> >> +
> >> +/*
> >> + * struct cg2900_cb - Specifies callback structure for CG2900 user.
> >> + *
> >> + * @read_cb: Callback function called when data is received from
> >> + *           the controller.
> >> + * @reset_cb:        Callback function called when the controller has been reset.
> >> + */
> >> +static struct cg2900_callbacks cg2900_cb = {
> >> +     .read_cb = hci_read_cb,
> >> +     .reset_cb = hci_reset_cb
> >> +};
> >> +
> >> +/**
> >> + * open_from_hci() - Open HCI interface.
> >> + * @hdev:    HCI device being opened.
> >> + *
> >> + * BlueZ callback function for opening HCI interface to device.
> >> + *
> >> + * Returns:
> >> + *   0 if there is no error.
> >> + *   -EINVAL if NULL pointer is supplied.
> >> + *   -EOPNOTSUPP if supplied packet type is not supported.
> >> + *   -EBUSY if device is already opened.
> >> + *   -EACCES if opening of channels failed.
> >> + */
> >> +static int open_from_hci(struct hci_dev *hdev)
> >> +{
> >> +     struct hci_info *info;
> >> +     struct dev_info *dev_info;
> >> +     struct sk_buff *enable_cmd;
> >> +     int err;
> >> +
> >> +     CG2900_INFO("Open ST-Ericsson connectivity HCI driver");
> >> +
> >> +     if (!hdev) {
> >> +             CG2900_ERR("NULL supplied for hdev");
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     info = (struct hci_info *)hdev->driver_data;
> >> +     if (!info) {
> >> +             CG2900_ERR("NULL supplied for driver_data");
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     if (test_and_set_bit(HCI_RUNNING, &(hdev->flags))) {
> >> +             CG2900_ERR("Device already opened!");
> >> +             return -EBUSY;
> >> +     }
> >> +
> >> +     if (!(info->bt_cmd)) {
> >> +             info->bt_cmd = cg2900_register_user(CG2900_BT_CMD,
> >> +                                                  &cg2900_cb);
> >> +             if (info->bt_cmd) {
> >> +                     dev_info = kmalloc(sizeof(*dev_info), GFP_KERNEL);
> >> +                     if (dev_info) {
> >> +                             dev_info->hdev = hdev;
> >> +                             dev_info->hci_data_type = HCI_COMMAND_PKT;
> >> +                     }
> >> +                     info->bt_cmd->user_data = dev_info;
> >> +             } else {
> >> +                     CG2900_ERR("Couldn't register CG2900_BT_CMD to CG2900");
> >> +                     err = -EACCES;
> >> +                     goto handle_error;
> >> +             }
> >> +     }
> >> +
> >> +     if (!(info->bt_evt)) {
> >> +             info->bt_evt = cg2900_register_user(CG2900_BT_EVT,
> >> +                                                  &cg2900_cb);
> >> +             if (info->bt_evt) {
> >> +                     dev_info = kmalloc(sizeof(*dev_info), GFP_KERNEL);
> >> +                     if (dev_info) {
> >> +                             dev_info->hdev = hdev;
> >> +                             dev_info->hci_data_type = HCI_EVENT_PKT;
> >> +                     }
> >> +                     info->bt_evt->user_data = dev_info;
> >> +             } else {
> >> +                     CG2900_ERR("Couldn't register CG2900_BT_EVT to CG2900");
> >> +                     err = -EACCES;
> >> +                     goto handle_error;
> >> +             }
> >> +     }
> >> +
> >> +     if (!(info->bt_acl)) {
> >> +             info->bt_acl = cg2900_register_user(CG2900_BT_ACL,
> >> +                                                  &cg2900_cb);
> >> +             if (info->bt_acl) {
> >> +                     dev_info = kmalloc(sizeof(*dev_info), GFP_KERNEL);
> >> +                     if (dev_info) {
> >> +                             dev_info->hdev = hdev;
> >> +                             dev_info->hci_data_type = HCI_ACLDATA_PKT;
> >> +                     }
> >> +                     info->bt_acl->user_data = dev_info;
> >> +             } else {
> >> +                     CG2900_ERR("Couldn't register CG2900_BT_ACL to CG2900");
> >> +                     err = -EACCES;
> >> +                     goto handle_error;
> >> +             }
> >> +     }
> >> +
> >> +     if (info->reset_state == RESET_ACTIVATED)
> >> +             SET_RESET_STATE(RESET_IDLE);
> >> +
> >> +     /*
> >> +      * Call platform specific function that returns the chip dependent
> >> +      * bt enable(true) HCI command.
> >> +      * If NULL is returned, then no bt_enable command should be sent to the
> >> +      * chip.
> >> +      */
> >> +     enable_cmd = cg2900_devices_get_bt_enable_cmd(&bt_enable_cmd, true);
> >> +     if (!enable_cmd) {
> >> +             /* The chip is enabled by default */
> >> +             SET_ENABLE_STATE(ENABLE_BT_ENABLED);
> >> +             return 0;
> >> +     }
> >> +
> >> +     /* Set the HCI state before sending command to chip. */
> >> +     SET_ENABLE_STATE(ENABLE_WAITING_BT_ENABLED_CC);
> >> +
> >> +     /* Send command to chip */
> >> +     cg2900_write(info->bt_cmd, enable_cmd);
> >> +
> >> +     /*
> >> +      * Wait for callback to receive command complete and then wake us up
> >> +      * again.
> >> +      */
> >> +     wait_event_interruptible_timeout(hci_wait_queue,
> >> +                             (info->enable_state == ENABLE_BT_ENABLED),
> >> +                             msecs_to_jiffies(RESP_TIMEOUT));
> >> +     /* Check the current state to se that it worked. */
> >> +     if (info->enable_state != ENABLE_BT_ENABLED) {
> >> +             CG2900_ERR("Could not enable BT core (%d)", info->enable_state);
> >> +             err = -EACCES;
> >> +             SET_ENABLE_STATE(ENABLE_BT_DISABLED);
> >> +             goto handle_error;
> >> +     }
> >> +
> >> +     return 0;
> >> +
> >> +handle_error:
> >> +     remove_bt_users(info);
> >> +     clear_bit(HCI_RUNNING, &(hdev->flags));
> >> +     return err;
> >> +
> >> +}
> >> +
> >> +/**
> >> + * flush_from_hci() - Flush HCI interface.
> >> + * @hdev:    HCI device being flushed.
> >> + *
> >> + * Returns:
> >> + *   0 if there is no error.
> >> + *   -EINVAL if NULL pointer is supplied.
> >> + */
> >> +static int flush_from_hci(struct hci_dev *hdev)
> >> +{
> >> +     CG2900_INFO("flush_from_hci");
> >> +
> >> +     if (!hdev) {
> >> +             CG2900_ERR("NULL supplied for hdev");
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +/**
> >> + * close_from_hci() - Close HCI interface.
> >> + * @hdev:    HCI device being closed.
> >> + *
> >> + * BlueZ callback function for closing HCI interface.
> >> + * It flushes the interface first.
> >> + *
> >> + * Returns:
> >> + *   0 if there is no error.
> >> + *   -EINVAL if NULL pointer is supplied.
> >> + *   -EOPNOTSUPP if supplied packet type is not supported.
> >> + *   -EBUSY if device is not opened.
> >> + */
> >> +static int close_from_hci(struct hci_dev *hdev)
> >> +{
> >> +     struct hci_info *info = NULL;
> >> +     struct sk_buff *enable_cmd;
> >> +
> >> +     CG2900_INFO("close_from_hci");
> >> +
> >> +     if (!hdev) {
> >> +             CG2900_ERR("NULL supplied for hdev");
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     info = (struct hci_info *)hdev->driver_data;
> >> +     if (!info) {
> >> +             CG2900_ERR("NULL supplied for driver_data");
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     if (!test_and_clear_bit(HCI_RUNNING, &(hdev->flags))) {
> >> +             CG2900_ERR("Device already closed!");
> >> +             return -EBUSY;
> >> +     }
> >> +
> >> +     flush_from_hci(hdev);
> >> +
> >> +     /* Do not do this if there is an reset ongoing */
> >> +     if (hci_info->reset_state == RESET_ACTIVATED)
> >> +             goto remove_users;
> >> +
> >> +     /*
> >> +      * Get the chip dependent BT Enable HCI command. The command parameter
> >> +      * shall be set to false to disable the BT core.
> >> +      * If NULL is returned, then no BT Enable command should be sent to the
> >> +      * chip.
> >> +      */
> >> +     enable_cmd = cg2900_devices_get_bt_enable_cmd(&bt_enable_cmd, false);
> >> +     if (!enable_cmd) {
> >> +             /*
> >> +              * The chip is enabled by default and we should not disable it.
> >> +              */
> >> +             SET_ENABLE_STATE(ENABLE_BT_ENABLED);
> >> +             goto remove_users;
> >> +     }
> >> +
> >> +     /* Set the HCI state before sending command to chip */
> >> +     SET_ENABLE_STATE(ENABLE_WAITING_BT_DISABLED_CC);
> >> +
> >> +     /* Send command to chip */
> >> +     cg2900_write(info->bt_cmd, enable_cmd);
> >> +
> >> +     /*
> >> +      * Wait for callback to receive command complete and then wake us up
> >> +      * again.
> >> +      */
> >> +     wait_event_interruptible_timeout(hci_wait_queue,
> >> +                             (info->enable_state == ENABLE_BT_DISABLED),
> >> +                             msecs_to_jiffies(RESP_TIMEOUT));
> >> +     /* Check the current state to se that it worked. */
> >> +     if (info->enable_state != ENABLE_BT_DISABLED) {
> >> +             CG2900_ERR("Could not disable BT core.");
> >> +             SET_ENABLE_STATE(ENABLE_BT_ENABLED);
> >> +     }
> >> +
> >> +remove_users:
> >> +     /* Finally deregister all users and free allocated data */
> >> +     remove_bt_users(info);
> >> +     return 0;
> >> +}
> >> +
> >> +/**
> >> + * send_from_hci() - Send packet to device.
> >> + * @skb:     sk buffer to be sent.
> >> + *
> >> + * BlueZ callback function for sending sk buffer.
> >> + *
> >> + * Returns:
> >> + *   0 if there is no error.
> >> + *   -EINVAL if NULL pointer is supplied.
> >> + *   -EOPNOTSUPP if supplied packet type is not supported.
> >> + *   Error codes from cg2900_write.
> >> + */
> >> +static int send_from_hci(struct sk_buff *skb)
> >> +{
> >> +     struct hci_dev *hdev;
> >> +     struct hci_info *info;
> >> +     int err = 0;
> >> +
> >> +     if (!skb) {
> >> +             CG2900_ERR("NULL supplied for skb");
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     hdev = (struct hci_dev *)(skb->dev);
> >> +     if (!hdev) {
> >> +             CG2900_ERR("NULL supplied for hdev");
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     info = (struct hci_info *)hdev->driver_data;
> >> +     if (!info) {
> >> +             CG2900_ERR("NULL supplied for info");
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     /* Update BlueZ stats */
> >> +     hdev->stat.byte_tx += skb->len;
> >> +
> >> +     CG2900_DBG_DATA("Data transmit %d bytes", skb->len);
> >> +
> >> +     switch (bt_cb(skb)->pkt_type) {
> >> +     case HCI_COMMAND_PKT:
> >> +             CG2900_DBG("Sending HCI_COMMAND_PKT");
> >> +             err = cg2900_write(info->bt_cmd, skb);
> >> +             hdev->stat.cmd_tx++;
> >> +             break;
> >> +     case HCI_ACLDATA_PKT:
> >> +             CG2900_DBG("Sending HCI_ACLDATA_PKT");
> >> +             err = cg2900_write(info->bt_acl, skb);
> >> +             hdev->stat.acl_tx++;
> >> +             break;
> >> +     default:
> >> +             CG2900_ERR("Trying to transmit unsupported packet type "
> >> +                        "(0x%.2X)", bt_cb(skb)->pkt_type);
> >> +             err = -EOPNOTSUPP;
> >> +             break;
> >> +     };
> >> +
> >> +     return err;
> >> +}
> >> +
> >> +/**
> >> + * destruct_from_hci() - Destruct HCI interface.
> >> + * @hdev:    HCI device being destructed.
> >> + */
> >> +static void destruct_from_hci(struct hci_dev *hdev)
> >> +{
> >> +     CG2900_INFO("destruct_from_hci");
> >> +
> >> +     if (!hci_info)
> >> +             return;
> >> +
> >> +     /* When being reset, register a new hdev when hdev is deregistered */
> >> +     if (hci_info->reset_state == RESET_ACTIVATED) {
> >> +             if (hci_info->hdev)
> >> +                     hci_free_dev(hci_info->hdev);
> >> +             SET_RESET_STATE(RESET_UNREGISTERED);
> >> +     }
> >> +}
> >
> > Please name thse cg2900_destruct or btcg2900_destruct. And not from_hci.
> > Follow how the other Bluetooth drivers do the naming.
> >
> > And the destruct callback is for freeing memory. I am also not sure how
> > reset and unregister/re-register HCI is a good idea.
> >
> 
> Regarding naming: no problem, we'll change that. We will see how we
> solve the reset. It's a bit tricky to get it working correctly, but
> we'll see what we can do. We have to be able in some way to handle if
> another stack, such as GPS or FM, suddenly reset the chip.

It sounds wrong to me, but please enlighten me.

> >> +/**
> >> + * notify_from_hci() - Notification from the HCI interface.
> >> + * @hdev:    HCI device notifying.
> >> + * @evt:     Notification event.
> >> + */
> >> +static void notify_from_hci(struct hci_dev *hdev, unsigned int evt)
> >> +{
> >> +     CG2900_INFO("notify_from_hci - evt = 0x%.2X", evt);
> >> +}
> >
> > If you don't use it, then just leave it out.
> >
> 
> OK
> 
> >> +/**
> >> + * ioctl_from_hci() - Handle IOCTL call to the HCI interface.
> >> + * @hdev: HCI device.
> >> + * @cmd:  IOCTL command.
> >> + * @arg:  IOCTL argument.
> >> + *
> >> + * Returns:
> >> + *   -EINVAL if NULL is supplied for hdev.
> >> + *   -EPERM otherwise since current driver supports no IOCTL.
> >> + */
> >> +static int ioctl_from_hci(struct hci_dev *hdev, unsigned int cmd,
> >> +                       unsigned long arg)
> >> +{
> >> +     CG2900_INFO("ioctl_from_hci - cmd 0x%X", cmd);
> >> +     CG2900_DBG("DIR: %d, TYPE: %d, NR: %d, SIZE: %d",
> >> +                _IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd),
> >> +                _IOC_SIZE(cmd));
> >> +
> >> +     if (!hdev) {
> >> +             CG2900_ERR("NULL supplied for hdev");
> >> +             return -EINVAL;;
> >> +     }
> >> +
> >> +     return -EPERM;
> >> +}
> >
> > Since you are not using anything with the ioctl, just leave it out. The
> > Bluetooth subsystem will do the right thing.
> >
> 
> OK
> 
> >> +/**
> >> + * register_to_bluez() - Initialize module.
> >> + *
> >> + * Alloc, init, and register HCI device to BlueZ.
> >> + *
> >> + * Returns:
> >> + *   0 if there is no error.
> >> + *   -ENOMEM if allocation fails.
> >> + *   Error codes from hci_register_dev.
> >> + */
> >> +static int register_to_bluez(void)
> >> +{
> >> +     int err;
> >> +
> >> +     hci_info->hdev = hci_alloc_dev();
> >> +     if (!hci_info->hdev) {
> >> +             CG2900_ERR("Could not allocate mem for HCI driver");
> >> +             return -ENOMEM;
> >> +     }
> >> +
> >> +     hci_info->hdev->bus = HCI_CG2900;
> >> +     hci_info->hdev->driver_data = hci_info;
> >> +     hci_info->hdev->owner = THIS_MODULE;
> >> +     hci_info->hdev->open = open_from_hci;
> >> +     hci_info->hdev->close = close_from_hci;
> >> +     hci_info->hdev->flush = flush_from_hci;
> >> +     hci_info->hdev->send = send_from_hci;
> >> +     hci_info->hdev->destruct = destruct_from_hci;
> >> +     hci_info->hdev->notify = notify_from_hci;
> >> +     hci_info->hdev->ioctl = ioctl_from_hci;
> >> +
> >> +     err = hci_register_dev(hci_info->hdev);
> >> +     if (err) {
> >> +             CG2900_ERR("Can not register HCI device (%d)", err);
> >> +             hci_free_dev(hci_info->hdev);
> >> +     }
> >> +
> >> +     SET_ENABLE_STATE(ENABLE_IDLE);
> >> +     SET_RESET_STATE(RESET_IDLE);
> >> +
> >> +     return err;
> >> +}
> >
> > So whenever the module is loaded it registers the HCI device. That is
> > not really useful here. This driver needs to be able to be compiled into
> > the kernel (or as module) and run on hardware that doesn't have this
> > chip built in.
> >
> 
> OK. We will think this through and solve it in a better way.

The TI guys seem to favoring a platform device. So either you have to do
that or create your own bus.

Regards

Marcel


