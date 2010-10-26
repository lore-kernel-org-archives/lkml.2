Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab0JZGy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 02:54:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63646 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab0JZGy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 02:54:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nEskO3fpgI5qKuAE4WN7wKnPdX+zw6Q42jbRmV1JWT1+oMdrzSPAZhw+1nzAM9zC8d
         oMaZuljaFfOYmqr+L7hHm2FKd4lm3wmCogX/9ShvFNVdiW9DNCqreobNdTPCVyz3q3Uf
         +HeUbeM9za78bH11xqta+/XOMmHRCh6uZJ8u4=
MIME-Version: 1.0
In-Reply-To: <201010221736.57671.arnd@arndb.de>
References: <AANLkTineXA2ZY0J7+dZhqywz+4aAVgzihu+LDDbsL8mu@mail.gmail.com>
	<201010221736.57671.arnd@arndb.de>
Date: Tue, 26 Oct 2010 08:54:55 +0200
Message-ID: <AANLkTinY0qmt6uFo4PZ3xH2BF5-AJ0C7ptctzNdOkRU2@mail.gmail.com>
Subject: Re: [PATCH 1/9] mfd: Add support for the ST-Ericsson CG2900.
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linus.walleij@stericsson.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for your comments. See below for answers.

/P-G

2010/10/22 Arnd Bergmann <arnd@arndb.de>:
> On Friday 22 October 2010 12:35:16 Par-Gunnar Hjalmdahl wrote:
>> This patch adds support for the ST-Ericsson CG2900 Connectivity
>> Combo controller.
>> This patch adds the central framework to be able to register CG2900 users,
>> transports, and chip handlers.
>>
>> Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
>
> Looks ok from a coding style perspective, but some important information is
> missing from the description:
>
> * What is a CG2900?
> * Why is it a MFD device rather than e.g. a bus or a subsystem?
>

I will add some more info:
 - CG2900 is a GPS, Bluetooth, FM controller
 - I do not really know what makes a device qualify as a certain type,
but at least for us this is a multifunction device. But I can't really
say that it isn't really a bus (could be stated as multifunction HCI
bus). I guess it could be qualified as a subsystem as well, but I
cannot give you a reason to have it as either.

>> +config MFD_CG2900
>> +     tristate "Support ST-Ericsson CG2900 main structure"
>> +     depends on NET
>> +     help
>> +       Support for ST-Ericsson CG2900 Connectivity Combo controller main structure.
>> +       Supports multiple functionalities muxed over a Bluetooth HCI H:4 interface.
>> +       CG2900 support Bluetooth, FM radio, and GPS.
>> +
>
> Can you explain what it means to mux over a H:4 interface? Does this mean
> you use bluetooth infrastructure that is designed for wireless communication
> in order to connect on-board or on-chip devices?
>

The H:4 protocol is defined in the Bluetooth Core specification. It
uses a single byte first in the data packet to determine an HCI
channel. In the Bluetooth Core specification there are 4 channels
specified, 0x01-0x04 (0x01 is BT command, etc). The rest of the
channels are reserved, but these have been used on a proprietary basis
to transport data to different IPs within the controller. In our API
we have chosen to have a channel separation on an API basis and the
H:4 byte is then added within the driver. So we have multiple channels
coming in from the users that we mux onto a single data transport.
That's what I mean in the text. I guess I could rewrite it a bit to
make it clearer.

>> @@ -0,0 +1,2401 @@
>> +/*
>> + * drivers/mfd/cg2900/cg2900_core.c
>> + *
>> + * Copyright (C) ST-Ericsson SA 2010
>> + * Authors:
>> + * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
>> ST-Ericsson.
>
> Your email client rewraps lines. You need to fix so that other people
> can apply your patches.
>

I will fix this.

>> +/*
>> + * chip_handlers - List of the register handlers for different chips.
>> + */
>> +LIST_HEAD(chip_handlers);
>
> Should this be static? Don't you need a lock to access the list?
>

You're right. I need to have mutex for this and it can just as well be
in the allocated cg2900_info structure.

>> +/**
>> + * find_h4_user() - Get H4 user based on supplied H4 channel.
>> + * @h4_channel:      H4 channel.
>> + * @dev:     Stored CG2900 device.
>> + * @skb:     (optional) skb with received packet. Set to NULL if NA.
>> + *
>> + * Returns:
>> + *   0 if there is no error.
>> + *   -EINVAL if bad channel is supplied or no user was found.
>> + *   -ENXIO if channel is audio channel but not registered with CG2900.
>> + */
>> +static int find_h4_user(int h4_channel, struct cg2900_device **dev,
>> +                     const struct sk_buff * const skb)
>> +{
>> +     int err = 0;
>> +     struct cg2900_users *users = &(core_info->users);
>> +     struct cg2900_h4_channels *chan = &(core_info->h4_channels);
>> +
>> +     if (h4_channel == chan->bt_cmd_channel) {
>> +             *dev = users->bt_cmd;
>> +     } else if (h4_channel == chan->bt_acl_channel) {
>> +             *dev = users->bt_acl;
>> +     } else if (h4_channel == chan->bt_evt_channel) {
>> +             *dev = users->bt_evt;
>> +             /* Check if it's event generated by previously sent audio user
>> +              * command. If so then that event should be dispatched to audio
>> +              * user*/
>> +             err = find_bt_audio_user(h4_channel, dev, skb);
>> +     } else if (h4_channel == chan->gnss_channel) {
>> +             *dev = users->gnss;
>> +     } else if (h4_channel == chan->fm_radio_channel) {
>> +             *dev = users->fm_radio;
>> +             /* Check if it's an event generated by previously sent audio
>> +              * user command. If so then that event should be dispatched to
>> +              * audio user */
>> +             err = find_fm_audio_user(h4_channel, dev, skb);
>> +     } else if (h4_channel == chan->debug_channel) {
>> +             *dev = users->debug;
>> +     } else if (h4_channel == chan->ste_tools_channel) {
>> +             *dev = users->ste_tools;
>> +     } else if (h4_channel == chan->hci_logger_channel) {
>> +             *dev = users->hci_logger;
>> +     } else if (h4_channel == chan->us_ctrl_channel) {
>> +             *dev = users->us_ctrl;
>> +     } else if (h4_channel == chan->core_channel) {
>> +             *dev = users->core;
>> +     } else {
>> +             *dev = NULL;
>> +             CG2900_ERR("Bad H:4 channel supplied: 0x%X", h4_channel);
>> +             return -EINVAL;
>> +     }
>> +
>> +     return err;
>> +}
>
> You seem to have a number of functions that need to go through each
> possible user/channel/submodule. This looks like somethin is not
> abstracted well enough.
>

This is part of what I stated in the cover letter "Future
development". We will move this functionality out to each chip handler
file. I agree that current code is not the perfect abstraction
level... ;-)

>> +
>> +/**
>> + * add_h4_user() - Add H4 user to user storage based on supplied H4 channel.
>> + * @dev:     Stored CG2900 device.
>> + * @name:    Device name to identify different devices that are using
>> + *           the same H4 channel.
>> + *
>> + * Returns:
>> + *   0 if there is no error.
>> + *   -EINVAL if NULL pointer or bad channel is supplied.
>> + *   -EBUSY if there already is a user for supplied channel.
>> + */
>> +static int add_h4_user(struct cg2900_device *dev, const char * const name)
>> +{
>
> Where does that name come from? Why not just use an enum if the name is
> only use for strncmp?
>

At a point in time we used to have an enum, but from what I can see it
is easier to keep an API stable if you use name lookup instead. If we
want to have minimal changes to the API in the future this is quite a
flexible solution, but this code should be moved to each respective
chip handler.

>> +static ssize_t test_char_dev_read(struct file *filp, char __user *buf,
>> +                               size_t count, loff_t *f_pos)
>> +{
>> +     struct sk_buff *skb;
>> +     int bytes_to_copy;
>> +     int err;
>> +     struct sk_buff_head *rx_queue = &core_info->test_char_dev->rx_queue;
>
> What is this read/write interface used for?
>
> The name suggests that this is only for testing and not an essential
> part of your driver. Could this be made a separate driver?
>
> It also looks like you do socket communication here, can't you use
> a proper AF_BLUETOOTH socket to do the same?
>

This interface can be used for module testing where you can have a
test engine in user space that acts as a chip. Yes, it could be made
into a separate driver but it would be a very small driver. Don't know
if it will be worth having it in a separate file...
We use the sk_buffer, which I guess is the reason that you mention
sockets. We could of course use a socket instead of a char dev, both
here and in the cg2900_char_dev file (which of course then would be
renamed). It was just a choice we made during development. We think
that the transport as such is more like a streaming interface, but I
see no real problem to have sockets. We already have several users
using char dev though so I would prefer to keep char dev rather than
switching to sockets unless you have a strong reason for this.
I see no reason to use AF_BLUETOOTH though, the transport is not only
for Bluetooth.

>> +     CG2900_INFO("test_char_dev_read");
>> +
>> +     if (skb_queue_empty(rx_queue))
>> +             wait_event_interruptible(char_wait_queue,
>> +                                      !(skb_queue_empty(rx_queue)));
>> +
>> +     skb = skb_dequeue(rx_queue);
>> +     if (!skb) {
>> +             CG2900_INFO("skb queue is empty - return with zero bytes");
>> +             bytes_to_copy = 0;
>> +             goto finished;
>> +     }
>> +
>> +     bytes_to_copy = min(count, skb->len);
>> +     err = copy_to_user(buf, skb->data, bytes_to_copy);
>> +     if (err) {
>> +             skb_queue_head(rx_queue, skb);
>> +             return -EFAULT;
>> +     }
>> +
>> +     skb_pull(skb, bytes_to_copy);
>> +
>> +     if (skb->len > 0)
>> +             skb_queue_head(rx_queue, skb);
>> +     else
>> +             kfree_skb(skb);
>> +
>> +finished:
>> +     return bytes_to_copy;
>> +}
>
> This does not handle short/continued reads.
>

As I mentioned above this interface is used for testing and we
therefore have some restriction of usage. I don't think we need to
impose all things necessary for a full interface upon it.

>> +EXPORT_SYMBOL(cg2900_reset);
>
> How about making your symbols EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL?
>

I have no problems with this. I will check with our company policy
first though before I give a final answer.
But as far as I can see we can use EXPORT_SYMBOL_GPL.

>> +module_param(cg2900_debug_level, int, S_IRUGO | S_IWUSR | S_IWGRP);
>> +MODULE_PARM_DESC(cg2900_debug_level,
>> +              "Debug level. Default 1. Possible values:\n"
>> +              "\t0  = No debug\n"
>> +              "\t1  = Error prints\n"
>> +              "\t10 = General info, e.g. function entries\n"
>> +              "\t20 = Debug info, e.g. steps in a functionality\n"
>> +              "\t25 = Data info, i.e. prints when data is transferred\n"
>> +              "\t30 = Data content, i.e. contents of the transferred data");
>
> Please don't introduce new debugging frameworks, we have enough of them
> already. Syslog handles different levels of output just fine, so just
> remove all your debugging stuff and use dev_dbg, dev_info, etc to print
> messages about the device if you must.
>
> Many messages can probably be removed entirely.
>

I have already received comments for this so this will be remade, or
rather removed...

>> +#define CG2900_DEFAULT_DEBUG_LEVEL 1
>> +
>> +/* module_param declared in cg2900_core.c */
>> +extern int cg2900_debug_level;
>> +
>> +#if defined(NDEBUG) || CG2900_DEFAULT_DEBUG_LEVEL == 0
>> +     #define CG2900_DBG_DATA_CONTENT(__prefix, __buf, __len)
>> +     #define CG2900_DBG_DATA(fmt, arg...)
>> +     #define CG2900_DBG(fmt, arg...)
>> +     #define CG2900_INFO(fmt, arg...)
>> +     #define CG2900_ERR(fmt, arg...)
>> +#else
>> +
>> +     #define CG2900_DBG_DATA_CONTENT(__prefix, __buf, __len)         \
>> +     do {                                                            \
>> +             if (cg2900_debug_level >= 30)                           \
>> +                     print_hex_dump_bytes("CG2900 " __prefix ": " ,  \
>> +                                          DUMP_PREFIX_NONE, __buf, __len); \
>> +     } while (0)
>> +
>> +     #define CG2900_DBG_DATA(fmt, arg...)                            \
>> +     do {                                                            \
>> +             if (cg2900_debug_level >= 25)                           \
>> +                     pr_debug("CG2900 %s: " fmt "\n" , __func__ , ## arg); \
>> +     } while (0)
>> +
>> +     #define CG2900_DBG(fmt, arg...)                                 \
>> +     do {                                                            \
>> +             if (cg2900_debug_level >= 20)                           \
>> +                     pr_debug("CG2900 %s: " fmt "\n" , __func__ , ## arg); \
>> +     } while (0)
>> +
>> +     #define CG2900_INFO(fmt, arg...)                                \
>> +     do {                                                            \
>> +             if (cg2900_debug_level >= 10)                           \
>> +                     pr_info("CG2900: " fmt "\n" , ## arg);          \
>> +     } while (0)
>> +
>> +     #define CG2900_ERR(fmt, arg...)                                 \
>> +     do {                                                            \
>> +             if (cg2900_debug_level >= 1)                            \
>> +                     pr_err("CG2900 %s: " fmt "\n" , __func__ , ## arg); \
>> +     } while (0)
>> +
>> +#endif /* NDEBUG */
>
> You'll feel relieved when all this is gone...
>

The only thing is it's been pretty nice to have it, but I will remove it.
Is it OK to keep defines so we can have "CG2900" in front and "\n"
after the text?

>> +
>> +#ifndef _BLUETOOTH_DEFINES_H_
>> +#define _BLUETOOTH_DEFINES_H_
>> +
>> +#include <linux/types.h>
>> +
>> +/* H:4 offset in an HCI packet */
>> +#define HCI_H4_POS                           0
>> +#define HCI_H4_SIZE                          1
>> +
>> +/* Standardized Bluetooth H:4 channels */
>> +#define HCI_BT_CMD_H4_CHANNEL                        0x01
>> +#define HCI_BT_ACL_H4_CHANNEL                        0x02
>> +#define HCI_BT_SCO_H4_CHANNEL                        0x03
>> +#define HCI_BT_EVT_H4_CHANNEL                        0x04
>> +
>> +/* Bluetooth Opcode Group Field (OGF) */
>> +#define HCI_BT_OGF_LINK_CTRL                 0x01
>> +#define HCI_BT_OGF_LINK_POLICY                       0x02
>> +#define HCI_BT_OGF_CTRL_BB                   0x03
>> +#define HCI_BT_OGF_LINK_INFO                 0x04
>> +#define HCI_BT_OGF_LINK_STATUS                       0x05
>> +#define HCI_BT_OGF_LINK_TESTING                      0x06
>> +#define HCI_BT_OGF_VS                                0x3F
>
> These all look like generic bluetooth definitions, not cg2900
> specific. Should they be part of global headers? Are they perhaps
> already?
>
>        Arnd
>

The H4 defines are standardized values and can be in a common h-file.
I don't know if they should be in e.g. include/net/bluetooth/hci.h,
but there are no other H4 defines there and I'm not sure if they would
fit there. Regarding the last defines (the OGFs) they should fit in
hci.h, but I don't know if anyone else would use them. I'm not
actually sure that we use them ourselves anymore so we might be able
to just remove them.
In short, I will check this up and change as needed.
