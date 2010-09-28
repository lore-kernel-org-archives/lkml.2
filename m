Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab0I1JOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:14:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34855 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab0I1JO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CPecRoqzQTNGfX8viLIoaST/UAGodXAz6xp+JrcPQQ6fMYOdUaXelWoRCo//ToTFtP
         UeBYvDyIrnAWnnNbPzAUYfi59dVsRp7tu9JpKt0HzV8bJgZkro0Vc/dsUMo/rrPIFImg
         wizU5nhSmeOc6QTW1vdQA2I+ThADZWjXr0Cms=
MIME-Version: 1.0
In-Reply-To: <20100927164502.GB30310@vigoh>
References: <AANLkTimOai9_92VuJUZMo26es9Wsu_6d+z36Sv_Q4i+L@mail.gmail.com>
	<20100927164502.GB30310@vigoh>
Date: Tue, 28 Sep 2010 11:14:26 +0200
Message-ID: <AANLkTimdAxaF2gyXXXgYtjQ5+3eXuTpnpQ5n2KFtDwth@mail.gmail.com>
Subject: Re: [PATCH 6/6] This patch adds support for using the ST-Ericsson CG2900
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Pavan Savoy <pavan_savoy@sify.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

Thanks for your comments. See below for answers.

/P-G

2010/9/27 Gustavo F. Padovan <padovan@profusion.mobi>:
> Hi Par-Gunnar,
>
> * Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com> [2010-09-24 15:52:16 +0200]:
>
>> This patch adds support for using the ST-Ericsson CG2900
>>  connectivity controller as a driver for the BlueZ Bluetooth
>>  stack.
>>  This patch registers as a driver into the BlueZ framework and, when
>>  opened by BlueZ, it registers as user for bt_cmd, bt_acl, and bt_evt
>>  channels.
>
> First of all your your commit message and subject should be improved.
> The subject should bee something like:
>
> "Bluetooth: Add support for ST-Ericsson CG2900"
>
> and in the commit message you explain the details of the patch.
> And normally we do not use the BlueZ word in kernelspace.
>

OK. This is the first patch I've created within the community and of
course there are bound to be errors... ;-)
Since it was part of a big patch delivery I used quite similar names
across the different patches and I understand that this is an error
since the different patches are targeting different communities.

>>
>> Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
>> ---
>>  drivers/bluetooth/Kconfig      |    7 +
>>  drivers/bluetooth/Makefile     |    2 +
>>  drivers/bluetooth/cg2900_hci.c |  896 ++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 905 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/bluetooth/cg2900_hci.c
>
> Your patch looks a way complicated to a UART driver. Look at the others
> drivers at drivers/bluetooth/ and see how we implemented other UART
> drivers.
>

Well, mainly that's because it is not a UART driver. It is a driver
against CG2900 which currently have only UART as transport but quite
soon will get SPI as transport as well. For this Bluetooth driver the
actual physical transport used is not known. It just knows it has a
reliable transport below which delivers complete Bluetooth packets.

>>
>> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
>> index 02deef4..9ca8d69 100644
>> --- a/drivers/bluetooth/Kconfig
>> +++ b/drivers/bluetooth/Kconfig
>> @@ -219,4 +219,11 @@ config BT_ATH3K
>>         Say Y here to compile support for "Atheros firmware download driver"
>>         into the kernel or say M to compile it as module (ath3k).
>>
>> +config BT_CG2900
>> +     tristate "ST-Ericsson CG2900 driver"
>> +     depends on MFD_CG2900 && BT
>> +     help
>> +       Select if ST-Ericsson CG2900 Connectivity controller shall be used as
>> +       Bluetooth controller for BlueZ.
>> +
>>  endmenu
>> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
>> index 71bdf13..a479c16 100644
>> --- a/drivers/bluetooth/Makefile
>> +++ b/drivers/bluetooth/Makefile
>> @@ -19,6 +19,8 @@ obj-$(CONFIG_BT_ATH3K)              += ath3k.o
>>  obj-$(CONFIG_BT_MRVL)                += btmrvl.o
>>  obj-$(CONFIG_BT_MRVL_SDIO)   += btmrvl_sdio.o
>>
>> +obj-$(CONFIG_BT_CG2900)              += cg2900_hci.o
>> +
>>  btmrvl-y                     := btmrvl_main.o
>>  btmrvl-$(CONFIG_DEBUG_FS)    += btmrvl_debugfs.o
>>
>> diff --git a/drivers/bluetooth/cg2900_hci.c b/drivers/bluetooth/cg2900_hci.c
>> new file mode 100644
>> index 0000000..de1ada8
>> --- /dev/null
>> +++ b/drivers/bluetooth/cg2900_hci.c
>> @@ -0,0 +1,896 @@
>> +/*
>> + * drivers/bluetooth/cg2900_hci.c
>> + *
>> + * Copyright (C) ST-Ericsson SA 2010
>> + * Authors:
>> + * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
>> ST-Ericsson.
>> + * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
>> + * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
>> + * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
>> + * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
>> + * License terms:  GNU General Public License (GPL), version 2
>> + *
>> + * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 connectivity
>> controller
>> + * towards the BlueZ Bluetooth stack.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/types.h>
>> +#include <linux/skbuff.h>
>> +#include <asm/byteorder.h>
>> +#include <net/bluetooth/bluetooth.h>
>> +#include <net/bluetooth/hci.h>
>> +#include <net/bluetooth/hci_core.h>
>> +
>> +#include <linux/workqueue.h>
>> +#include <linux/wait.h>
>> +#include <linux/time.h>
>> +#include <linux/jiffies.h>
>> +#include <linux/sched.h>
>> +#include <linux/timer.h>
>> +
>> +#include <linux/mfd/cg2900.h>
>> +#include <mach/cg2900_devices.h>
>> +
>> +/* module_param declared in cg2900_core.c */
>> +extern int cg2900_debug_level;
>
> You don't need that, just use dynamic debug instead
>

Regarding the debug we know we have made an debug implementation that
might be controversial. We have used defines to output debug at
different levels and a module param to control the debug level in
runtime. I know that rest of the Kernel use other ways for debug and
if our way is not accepted we will of course modify the debug in the
driver to use standard Kernel methods.

I personally prefer to use defines because it makes it easy to add a
file name or similar at the start of the printout and also always use
'\n' in the end of each debug line. But if you don't like it that way
we will of course change that as well.

>> +
>> +#define NAME                 "CG2900 HCI"
>> +
>> +/* Debug defines */
>> +#define CG2900_DBG_DATA(fmt, arg...)                         \
>> +do {                                                         \
>> +     if (cg2900_debug_level >= 25)                           \
>> +             printk(KERN_DEBUG NAME " %s: " fmt "\n" , __func__ , ## arg); \
>> +} while (0)
>> +
>> +#define CG2900_DBG(fmt, arg...)                              \
>> +do {                                                         \
>> +     if (cg2900_debug_level >= 20)                           \
>> +             printk(KERN_DEBUG NAME " %s: " fmt "\n" , __func__ , ## arg); \
>> +} while (0)
>> +
>> +#define CG2900_INFO(fmt, arg...)                             \
>> +do {                                                         \
>> +     if (cg2900_debug_level >= 10)                           \
>> +             printk(KERN_INFO NAME ": " fmt "\n" , ## arg); \
>> +} while (0)
>> +
>> +#define CG2900_ERR(fmt, arg...)                                      \
>> +do {                                                         \
>> +     if (cg2900_debug_level >= 1)                            \
>> +             printk(KERN_ERR NAME " %s: " fmt "\n" , __func__ , ## arg); \
>> +} while (0)i
>
> and BT_DBG, BT_INFO, BT_ERR instead of these macros.

OK.

>
>> +
>> +#define CG2900_SET_STATE(__name, __var, __new_state)                 \
>> +do {                                                                 \
>> +     CG2900_DBG("New %s: 0x%X", __name, (uint32_t)__new_state);      \
>> +     __var = __new_state;                                            \
>> +} while (0)
>
> Don't hide your operation with a macro, that is a simple attribution, so
> no need for a macro for that.
>

OK. I prefer to be able to get a printout 'automatically' every time
state is changed, but it is no big issue to do this directly in the
code instead.

>> +
>> +/* HCI device type */
>> +#define HCI_CG2900           HCI_VIRTUAL
>> +
>> +/* Wait for 5 seconds for a response to our requests */
>> +#define RESP_TIMEOUT         5000
>> +
>> +/* State-setting defines */
>> +#define SET_RESET_STATE(__hci_reset_new_state) \
>> +     CG2900_SET_STATE("reset_state", hci_info->reset_state, \
>> +                      __hci_reset_new_state)
>> +#define SET_ENABLE_STATE(__hci_enable_new_state) \
>> +     CG2900_SET_STATE("enable_state", hci_info->enable_state, \
>> +                      __hci_enable_new_state)
>
> Same here.
>

OK.

> --
> Gustavo F. Padovan
> ProFUSION embedded systems - http://profusion.mobi
>
