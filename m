Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab2JCDI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 23:08:28 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:55723 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2JCDIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 23:08:24 -0400
From: Jian-Jhong Ding <jj_ding@emc.com.tw>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        fabien.andre@gmail.com, scott.liu@emc.com.tw,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification implementation
In-Reply-To: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 03 Oct 2012 11:08:17 +0800
Message-ID: <87ehlgmevy.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

I have one little question about __i2chid_command(), please see below.

"benjamin.tissoires" <benjamin.tissoires@gmail.com> writes:
> From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>
> Microsoft published the protocol specification of HID over i2c:
> http://msdn.microsoft.com/en-us/library/windows/hardware/hh852380.aspx
>
> This patch introduces an implementation of this protocol.
>
> This implementation does not includes the ACPI part of the specification.
> This will come when ACPI 5.0 devices will be available.
>
> Once the ACPI part will be done, OEM will not have to declare HID over I2C
> devices in their platform specific driver.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
>
> Hi,
>
> this is finally my first implementation of HID over I2C.
>
> This has been tested on an Elan Microelectronics HID over I2C device, with
> a Samsung Exynos 4412 board.
>
> Any comments are welcome.
>
> Cheers,
> Benjamin
>
>  drivers/i2c/Kconfig         |    8 +
>  drivers/i2c/Makefile        |    1 +
>  drivers/i2c/i2c-hid.c       | 1027 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/i2c-hid.h |   35 ++
>  4 files changed, 1071 insertions(+)
>  create mode 100644 drivers/i2c/i2c-hid.c
>  create mode 100644 include/linux/i2c/i2c-hid.h
>
> diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
> index 5a3bb3d..5adf65a 100644
> --- a/drivers/i2c/Kconfig
> +++ b/drivers/i2c/Kconfig
> @@ -47,6 +47,14 @@ config I2C_CHARDEV
>  	  This support is also available as a module.  If so, the module 
>  	  will be called i2c-dev.
>  
> +config I2C_HID
> +	tristate "HID over I2C bus"
> +	help
> +	  Say Y here to use the HID over i2c protocol implementation.
> +
> +	  This support is also available as a module.  If so, the module
> +	  will be called i2c-hid.
> +
>  config I2C_MUX
>  	tristate "I2C bus multiplexing support"
>  	help
> diff --git a/drivers/i2c/Makefile b/drivers/i2c/Makefile
> index beee6b2..8f38116 100644
> --- a/drivers/i2c/Makefile
> +++ b/drivers/i2c/Makefile
> @@ -6,6 +6,7 @@ obj-$(CONFIG_I2C_BOARDINFO)	+= i2c-boardinfo.o
>  obj-$(CONFIG_I2C)		+= i2c-core.o
>  obj-$(CONFIG_I2C_SMBUS)		+= i2c-smbus.o
>  obj-$(CONFIG_I2C_CHARDEV)	+= i2c-dev.o
> +obj-$(CONFIG_I2C_HID)		+= i2c-hid.o
>  obj-$(CONFIG_I2C_MUX)		+= i2c-mux.o
>  obj-y				+= algos/ busses/ muxes/
>  
> diff --git a/drivers/i2c/i2c-hid.c b/drivers/i2c/i2c-hid.c
> new file mode 100644
> index 0000000..eb17d8c
> --- /dev/null
> +++ b/drivers/i2c/i2c-hid.c
> @@ -0,0 +1,1027 @@
> +/*
> + * HID over I2C protocol implementation
> + *
> + * Copyright (c) 2012 Benjamin Tissoires <benjamin.tissoires@gmail.com>
> + * Copyright (c) 2012 Ecole Nationale de l'Aviation Civile, France
> + *
> + * This code is partly based on "USB HID support for Linux":
> + *
> + *  Copyright (c) 1999 Andreas Gal
> + *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
> + *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
> + *  Copyright (c) 2007-2008 Oliver Neukum
> + *  Copyright (c) 2006-2010 Jiri Kosina
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file COPYING in the main directory of this archive for
> + * more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/irq.h>
> +#include <linux/gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/input.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/pm.h>
> +
> +#include <linux/i2c/i2c-hid.h>
> +
> +#include <linux/hid.h>
> +#include <linux/hiddev.h>
> +#include <linux/hidraw.h>
> +
> +#define DRIVER_NAME		"i2chid"
> +#define DRIVER_DESC		"HID over I2C core driver"
> +
> +#define I2C_HID_COMMAND_TRIES	3
> +
> +/* flags */
> +#define I2C_HID_STARTED		(1 << 0)
> +#define I2C_HID_OUT_RUNNING	(1 << 1)
> +#define I2C_HID_IN_RUNNING	(1 << 2)
> +#define I2C_HID_RESET_PENDING	(1 << 3)
> +#define I2C_HID_SUSPENDED	(1 << 4)
> +
> +#define I2C_HID_PWR_ON		0x00
> +#define I2C_HID_PWR_SLEEP	0x01
> +
> +/* debug option */
> +static bool debug = false;
> +module_param(debug, bool, 0444);
> +MODULE_PARM_DESC(debug, "print a lot of debug informations");
> +
> +struct i2chid_desc {
> +	__le16 wHIDDescLength;
> +	__le16 bcdVersion;
> +	__le16 wReportDescLength;
> +	__le16 wReportDescRegister;
> +	__le16 wInputRegister;
> +	__le16 wMaxInputLength;
> +	__le16 wOutputRegister;
> +	__le16 wMaxOutputLength;
> +	__le16 wCommandRegister;
> +	__le16 wDataRegister;
> +	__le16 wVendorID;
> +	__le16 wProductID;
> +	__le16 wVersionID;
> +} __packed;
> +
> +struct i2chid_cmd {
> +	enum {
> +		/* fecth HID descriptor */
> +		HID_DESCR_CMD,
> +
> +		/* fetch report descriptors */
> +		HID_REPORT_DESCR_CMD,
> +
> +		/* commands */
> +		HID_RESET_CMD,
> +		HID_GET_REPORT_CMD,
> +		HID_SET_REPORT_CMD,
> +		HID_GET_IDLE_CMD,
> +		HID_SET_IDLE_CMD,
> +		HID_GET_PROTOCOL_CMD,
> +		HID_SET_PROTOCOL_CMD,
> +		HID_SET_POWER_CMD,
> +
> +		/* read/write data register */
> +		HID_DATA_CMD,
> +	} name;
> +	unsigned int registerIndex;
> +	__u8 opcode;
> +	unsigned int length;
> +	bool wait;
> +};
> +
> +union command {
> +	u8 data[0];
> +	struct cmd {
> +		__le16 reg;
> +		__u8 reportTypeID;
> +		__u8 opcode;
> +	} __packed c;
> +};
> +
> +#define I2C_HID_CMD(name_, opcode_) \
> +	.name = name_, .opcode = opcode_, .length = 4, \
> +	.registerIndex = offsetof(struct i2chid_desc, wCommandRegister)
> +
> +static const struct i2chid_cmd cmds[] = {
> +	{ I2C_HID_CMD(HID_RESET_CMD,		0x01), .wait = true },
> +	{ I2C_HID_CMD(HID_GET_REPORT_CMD,	0x02) },
> +	{ I2C_HID_CMD(HID_SET_REPORT_CMD,	0x03) },
> +	{ I2C_HID_CMD(HID_GET_IDLE_CMD,		0x04) },
> +	{ I2C_HID_CMD(HID_SET_IDLE_CMD,		0x05) },
> +	{ I2C_HID_CMD(HID_GET_PROTOCOL_CMD,	0x06) },
> +	{ I2C_HID_CMD(HID_SET_PROTOCOL_CMD,	0x07) },
> +	{ I2C_HID_CMD(HID_SET_POWER_CMD,	0x08) },
> +
> +	{.name = HID_DESCR_CMD,
> +	 .length = 2},
> +
> +	{.name = HID_REPORT_DESCR_CMD,
> +	 .registerIndex = offsetof(struct i2chid_desc, wReportDescRegister),
> +	 .opcode = 0x00,
> +	 .length = 2},
> +
> +	{.name = HID_DATA_CMD,
> +	 .registerIndex = offsetof(struct i2chid_desc, wDataRegister),
> +	 .opcode = 0x00,
> +	 .length = 2},
> +
> +	{}, /* terminating */
> +};
> +
> +/* The main device structure */
> +struct i2chid {
> +	struct i2c_client	*client;	/* i2c client */
> +	struct hid_device	*hid;	/* pointer to corresponding HID dev */
> +	union {
> +		__u8 hdesc_buffer[sizeof(struct i2chid_desc)];
> +		struct i2chid_desc hdesc;	/* the HID Descriptor */
> +	};
> +	__le16			wHIDDescRegister; /* location of the i2c
> +						   * register of the HID
> +						   * descriptor. */
> +	unsigned int		bufsize;	/* i2c buffer size */
> +	char			*inbuf;		/* Input buffer */
> +
> +	spinlock_t		flock;		/* flags spinlock */
> +	unsigned long		flags;		/* device flags */
> +
> +	int			irq;		/* the interrupt line irq */
> +
> +	wait_queue_head_t	wait;		/* For waiting the interrupt */
> +};
> +
> +void i2chid_print_buffer(struct i2chid *ihid, u8 *buf, unsigned int n)
> +{
> +	int i;
> +	char *string = kzalloc((n*3+1)*sizeof(char), GFP_KERNEL);
> +	char tmpbuf[4] = "";
> +
> +	for (i = 0; i < n; ++i) {
> +		sprintf(tmpbuf, "%02x ", buf[i] & 0xFF);
> +		strcat(string, tmpbuf);
> +	}
> +
> +	dev_err(&ihid->client->dev, "%s\n", string);
> +	kfree(string);
> +}
> +
> +static int __i2chid_command(struct i2c_client *client, int command, u8 reportID,
> +		u8 reportType, u8 *args, int args_len,
> +		unsigned char *buf_recv, int data_len)
> +{
> +	struct i2chid *ihid = i2c_get_clientdata(client);
> +	union command *cmd;
> +	unsigned char *rec_buf = buf_recv;
> +	int ret;
> +	int tries = I2C_HID_COMMAND_TRIES;
> +	int length = 0;
> +	struct i2c_msg msg[2];
> +	int msg_num = 0;
> +	int i;
> +	bool wait = false;
> +
> +	if (WARN_ON(!ihid))
> +		return -ENODEV;
> +
> +	cmd = kmalloc(args_len + sizeof(union command), GFP_KERNEL);
> +	if (!cmd)
> +		return -ENOMEM;
> +
> +	for (i = 0; cmds[i].length; i++) {
> +		unsigned int registerIndex;
> +
> +		if (cmds[i].name != command)
> +			continue;
> +
> +		registerIndex = cmds[i].registerIndex;
> +		cmd->data[0] = ihid->hdesc_buffer[registerIndex];
> +		cmd->data[1] = ihid->hdesc_buffer[registerIndex + 1];
> +		cmd->c.opcode = cmds[i].opcode;
> +		length = cmds[i].length;
> +		wait = cmds[i].wait;
> +	}
> +
> +	/* special case for HID_DESCR_CMD */
> +	if (command == HID_DESCR_CMD)
> +		cmd->c.reg = ihid->wHIDDescRegister;
> +
> +	cmd->c.reportTypeID = reportID | reportType << 4;
> +
> +	memcpy(cmd->data + length, args, args_len);
> +	length += args_len;
> +
> +	if (debug) {
> +		char tmpstr[4] = "";
> +		char strbuf[50] = "";
> +		int i;
> +		for (i = 0; i < length; i++) {
> +			sprintf(tmpstr, "%02x ", cmd->data[i] & 0xFF);
> +			strcat(strbuf, tmpstr);
> +		}
> +		dev_err(&client->dev, "%s, cmd=%s\n", __func__, strbuf);
> +	}
> +
> +	msg[0].addr = client->addr;
> +	msg[0].flags = client->flags & I2C_M_TEN;
> +	msg[0].len = length;
> +	msg[0].buf = (char *) cmd->data;
> +	msg[1].addr = client->addr;
> +	msg[1].flags = client->flags & I2C_M_TEN;
> +	msg[1].flags |= I2C_M_RD;
> +	msg[1].len = data_len;
> +	msg[1].buf = rec_buf;
> +
> +	msg_num = data_len > 0 ? 2 : 1;
> +
> +	if (wait) {
> +		spin_lock_irq(&ihid->flock);
> +		set_bit(I2C_HID_RESET_PENDING, &ihid->flags);
> +		spin_unlock_irq(&ihid->flock);
> +	}
> +
> +	do {
> +		ret = i2c_transfer(client->adapter, msg, msg_num);
> +		if (ret > 0)
> +			break;
> +		tries--;
> +		dev_dbg(&client->dev, "retrying i2chid_command:%d (%d)\n",
> +			command, tries);
> +	} while (tries > 0);

Do we have to do this retry here?  In i2c_transfer() it already does
retry automatically on arbitration loss (please see __i2c_transfer() in
drivers/i2c/i2c-core.c) that's defined by individual bus driver.  Maybe
we don't have to retry here and make the code a bit simpler.

Thanks,
JJ

> +	if (wait && ret > 0) {
> +		if (debug)
> +			dev_err(&client->dev, "%s: waiting....\n", __func__);
> +		if (!wait_event_timeout(ihid->wait,
> +				!test_bit(I2C_HID_RESET_PENDING, &ihid->flags),
> +				msecs_to_jiffies(5000)))
> +			ret = -ENODATA;
> +		if (debug)
> +			dev_err(&client->dev, "%s: finished.\n", __func__);
> +	}
> +
> +	kfree(cmd);
> +
> +	return ret > 0 ? ret != msg_num : ret;
> +}
> +
> +static int i2chid_command(struct i2c_client *client, int command,
> +		unsigned char *buf_recv, int data_len)
> +{
> +	return __i2chid_command(client, command, 0, 0, NULL, 0,
> +				buf_recv, data_len);
> +}
