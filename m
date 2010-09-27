Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877Ab0I0QpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:45:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33883 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734Ab0I0QpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:45:04 -0400
Date: Mon, 27 Sep 2010 13:45:02 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: pghatwork@gmail.com
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Pavan Savoy <pavan_savoy@sify.com>
Subject: Re: [PATCH 6/6] This patch adds support for using the ST-Ericsson
 CG2900
Message-ID: <20100927164502.GB30310@vigoh>
References: <AANLkTimOai9_92VuJUZMo26es9Wsu_6d+z36Sv_Q4i+L@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimOai9_92VuJUZMo26es9Wsu_6d+z36Sv_Q4i+L@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Par-Gunnar,

* Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com> [2010-09-24 15:52:16 +0200]:

> This patch adds support for using the ST-Ericsson CG2900
>  connectivity controller as a driver for the BlueZ Bluetooth
>  stack.
>  This patch registers as a driver into the BlueZ framework and, when
>  opened by BlueZ, it registers as user for bt_cmd, bt_acl, and bt_evt
>  channels.

First of all your your commit message and subject should be improved.
The subject should bee something like:

"Bluetooth: Add support for ST-Ericsson CG2900"

and in the commit message you explain the details of the patch.
And normally we do not use the BlueZ word in kernelspace.

> 
> Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
> ---
>  drivers/bluetooth/Kconfig      |    7 +
>  drivers/bluetooth/Makefile     |    2 +
>  drivers/bluetooth/cg2900_hci.c |  896 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 905 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/bluetooth/cg2900_hci.c

Your patch looks a way complicated to a UART driver. Look at the others
drivers at drivers/bluetooth/ and see how we implemented other UART
drivers.

> 
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index 02deef4..9ca8d69 100644
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -219,4 +219,11 @@ config BT_ATH3K
>  	  Say Y here to compile support for "Atheros firmware download driver"
>  	  into the kernel or say M to compile it as module (ath3k).
> 
> +config BT_CG2900
> +	tristate "ST-Ericsson CG2900 driver"
> +	depends on MFD_CG2900 && BT
> +	help
> +	  Select if ST-Ericsson CG2900 Connectivity controller shall be used as
> +	  Bluetooth controller for BlueZ.
> +
>  endmenu
> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> index 71bdf13..a479c16 100644
> --- a/drivers/bluetooth/Makefile
> +++ b/drivers/bluetooth/Makefile
> @@ -19,6 +19,8 @@ obj-$(CONFIG_BT_ATH3K)		+= ath3k.o
>  obj-$(CONFIG_BT_MRVL)		+= btmrvl.o
>  obj-$(CONFIG_BT_MRVL_SDIO)	+= btmrvl_sdio.o
> 
> +obj-$(CONFIG_BT_CG2900)		+= cg2900_hci.o
> +
>  btmrvl-y			:= btmrvl_main.o
>  btmrvl-$(CONFIG_DEBUG_FS)	+= btmrvl_debugfs.o
> 
> diff --git a/drivers/bluetooth/cg2900_hci.c b/drivers/bluetooth/cg2900_hci.c
> new file mode 100644
> index 0000000..de1ada8
> --- /dev/null
> +++ b/drivers/bluetooth/cg2900_hci.c
> @@ -0,0 +1,896 @@
> +/*
> + * drivers/bluetooth/cg2900_hci.c
> + *
> + * Copyright (C) ST-Ericsson SA 2010
> + * Authors:
> + * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for
> ST-Ericsson.
> + * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
> + * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
> + * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
> + * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
> + * License terms:  GNU General Public License (GPL), version 2
> + *
> + * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 connectivity
> controller
> + * towards the BlueZ Bluetooth stack.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/skbuff.h>
> +#include <asm/byteorder.h>
> +#include <net/bluetooth/bluetooth.h>
> +#include <net/bluetooth/hci.h>
> +#include <net/bluetooth/hci_core.h>
> +
> +#include <linux/workqueue.h>
> +#include <linux/wait.h>
> +#include <linux/time.h>
> +#include <linux/jiffies.h>
> +#include <linux/sched.h>
> +#include <linux/timer.h>
> +
> +#include <linux/mfd/cg2900.h>
> +#include <mach/cg2900_devices.h>
> +
> +/* module_param declared in cg2900_core.c */
> +extern int cg2900_debug_level;

You don't need that, just use dynamic debug instead 

> +
> +#define NAME			"CG2900 HCI"
> +
> +/* Debug defines */
> +#define CG2900_DBG_DATA(fmt, arg...)				\
> +do {								\
> +	if (cg2900_debug_level >= 25)				\
> +		printk(KERN_DEBUG NAME " %s: " fmt "\n" , __func__ , ## arg); \
> +} while (0)
> +
> +#define CG2900_DBG(fmt, arg...)				\
> +do {								\
> +	if (cg2900_debug_level >= 20)				\
> +		printk(KERN_DEBUG NAME " %s: " fmt "\n" , __func__ , ## arg); \
> +} while (0)
> +
> +#define CG2900_INFO(fmt, arg...)				\
> +do {								\
> +	if (cg2900_debug_level >= 10)				\
> +		printk(KERN_INFO NAME ": " fmt "\n" , ## arg); \
> +} while (0)
> +
> +#define CG2900_ERR(fmt, arg...)					\
> +do {								\
> +	if (cg2900_debug_level >= 1)				\
> +		printk(KERN_ERR NAME " %s: " fmt "\n" , __func__ , ## arg); \
> +} while (0)i

and BT_DBG, BT_INFO, BT_ERR instead of these macros.

> +
> +#define CG2900_SET_STATE(__name, __var, __new_state)			\
> +do {									\
> +	CG2900_DBG("New %s: 0x%X", __name, (uint32_t)__new_state);	\
> +	__var = __new_state;						\
> +} while (0)

Don't hide your operation with a macro, that is a simple attribution, so
no need for a macro for that.

> +
> +/* HCI device type */
> +#define HCI_CG2900		HCI_VIRTUAL
> +
> +/* Wait for 5 seconds for a response to our requests */
> +#define RESP_TIMEOUT		5000
> +
> +/* State-setting defines */
> +#define SET_RESET_STATE(__hci_reset_new_state) \
> +	CG2900_SET_STATE("reset_state", hci_info->reset_state, \
> +			 __hci_reset_new_state)
> +#define SET_ENABLE_STATE(__hci_enable_new_state) \
> +	CG2900_SET_STATE("enable_state", hci_info->enable_state, \
> +			 __hci_enable_new_state)

Same here.

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
