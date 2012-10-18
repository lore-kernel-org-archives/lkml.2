Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2JRJHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:07:14 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:61777 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2JRJHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:07:10 -0400
From: Jian-Jhong Ding <jj_ding@emc.com.tw>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        fabien.andre@gmail.com, scott.liu@emc.com.tw,
        Jean Delvare <khali@linux-fr.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c-hid: introduce HID over i2c specification implementation
In-Reply-To: <1350333533-13366-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1350333533-13366-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 18 Oct 2012 17:07:04 +0800
Message-ID: <87zk3kjghz.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

Some suggestions to make the error messages more "human", and a little
question on the return value of i2c_hid_fetch_hid_descriptor.  Please see below:

Benjamin Tissoires <benjamin.tissoires@gmail.com> writes:
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> new file mode 100644
> index 0000000..8b6c31a
> --- /dev/null
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -0,0 +1,990 @@
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
> +#include <linux/interrupt.h>
> +#include <linux/input.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/pm.h>
> +#include <linux/device.h>
> +#include <linux/wait.h>
> +#include <linux/err.h>
> +#include <linux/string.h>
> +#include <linux/list.h>
> +#include <linux/jiffies.h>
> +#include <linux/kernel.h>
> +#include <linux/bug.h>
> +#include <linux/hid.h>
> +
> +#include <linux/i2c/i2c-hid.h>
> +
> +/* flags */
> +#define I2C_HID_STARTED		(1 << 0)
> +#define I2C_HID_RESET_PENDING	(1 << 1)
> +#define I2C_HID_READ_PENDING	(1 << 2)
> +
> +#define I2C_HID_PWR_ON		0x00
> +#define I2C_HID_PWR_SLEEP	0x01
> +
> +/* debug option */
> +static bool debug = false;
> +module_param(debug, bool, 0444);
> +MODULE_PARM_DESC(debug, "print a lot of debug information");
> +
> +#define i2c_hid_dbg(ihid, fmt, arg...)	\
> +	if (debug)			\
> +		dev_printk(KERN_DEBUG, &(ihid)->client->dev, fmt, ##arg)
> +
> +struct i2c_hid_desc {
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
> +struct i2c_hid_cmd {
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
> +#define I2C_HID_CMD(opcode_) \
> +	.opcode = opcode_, .length = 4, \
> +	.registerIndex = offsetof(struct i2c_hid_desc, wCommandRegister)
> +
> +/* fetch HID descriptor */
> +static const struct i2c_hid_cmd hid_descr_cmd = { .length = 2 };
> +/* fetch report descriptors */
> +static const struct i2c_hid_cmd hid_report_descr_cmd = {
> +		.registerIndex = offsetof(struct i2c_hid_desc,
> +			wReportDescRegister),
> +		.opcode = 0x00,
> +		.length = 2 };
> +/* commands */
> +static const struct i2c_hid_cmd hid_reset_cmd =		{ I2C_HID_CMD(0x01),
> +							  .wait = true };
> +static const struct i2c_hid_cmd hid_get_report_cmd =	{ I2C_HID_CMD(0x02) };
> +static const struct i2c_hid_cmd hid_set_report_cmd =	{ I2C_HID_CMD(0x03) };
> +static const struct i2c_hid_cmd hid_get_idle_cmd =	{ I2C_HID_CMD(0x04) };
> +static const struct i2c_hid_cmd hid_set_idle_cmd =	{ I2C_HID_CMD(0x05) };
> +static const struct i2c_hid_cmd hid_get_protocol_cmd =	{ I2C_HID_CMD(0x06) };
> +static const struct i2c_hid_cmd hid_set_protocol_cmd =	{ I2C_HID_CMD(0x07) };
> +static const struct i2c_hid_cmd hid_set_power_cmd =	{ I2C_HID_CMD(0x08) };
> +/* read/write data register */
> +static const struct i2c_hid_cmd hid_data_cmd = {
> +		.registerIndex = offsetof(struct i2c_hid_desc, wDataRegister),
> +		.opcode = 0x00,
> +		.length = 2 };
> +/* write output reports */
> +static const struct i2c_hid_cmd hid_out_cmd = {
> +		.registerIndex = offsetof(struct i2c_hid_desc,
> +			wOutputRegister),
> +		.opcode = 0x00,
> +		.length = 2 };
> +
> +/* The main device structure */
> +struct i2c_hid {
> +	struct i2c_client	*client;	/* i2c client */
> +	struct hid_device	*hid;	/* pointer to corresponding HID dev */
> +	union {
> +		__u8 hdesc_buffer[sizeof(struct i2c_hid_desc)];
> +		struct i2c_hid_desc hdesc;	/* the HID Descriptor */
> +	};
> +	__le16			wHIDDescRegister; /* location of the i2c
> +						   * register of the HID
> +						   * descriptor. */
> +	unsigned int		bufsize;	/* i2c buffer size */
> +	char			*inbuf;		/* Input buffer */
> +	char			*cmdbuf;	/* Command buffer */
> +	char			*argsbuf;	/* Command arguments buffer */
> +
> +	unsigned long		flags;		/* device flags */
> +
> +	int			irq;		/* the interrupt line irq */
> +
> +	wait_queue_head_t	wait;		/* For waiting the interrupt */
> +};
> +
> +static int __i2c_hid_command(struct i2c_client *client,
> +		const struct i2c_hid_cmd *command, u8 reportID,
> +		u8 reportType, u8 *args, int args_len,
> +		unsigned char *buf_recv, int data_len)
> +{
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	union command *cmd = (union command *)ihid->cmdbuf;
> +	int ret;
> +	struct i2c_msg msg[2];
> +	int msg_num = 1;
> +
> +	int length = command->length;
> +	bool wait = command->wait;
> +	unsigned int registerIndex = command->registerIndex;
> +
> +	/* special case for hid_descr_cmd */
> +	if (command == &hid_descr_cmd) {
> +		cmd->c.reg = ihid->wHIDDescRegister;
> +	} else {
> +		cmd->data[0] = ihid->hdesc_buffer[registerIndex];
> +		cmd->data[1] = ihid->hdesc_buffer[registerIndex + 1];
> +	}
> +
> +	if (length > 2) {
> +		cmd->c.opcode = command->opcode;
> +		cmd->c.reportTypeID = reportID | reportType << 4;
> +	}
> +
> +	memcpy(cmd->data + length, args, args_len);
> +	length += args_len;
> +
> +	i2c_hid_dbg(ihid, "%s: cmd=%*ph\n", __func__, length, cmd->data);
> +
> +	msg[0].addr = client->addr;
> +	msg[0].flags = client->flags & I2C_M_TEN;
> +	msg[0].len = length;
> +	msg[0].buf = cmd->data;
> +	if (data_len > 0) {
> +		msg[1].addr = client->addr;
> +		msg[1].flags = client->flags & I2C_M_TEN;
> +		msg[1].flags |= I2C_M_RD;
> +		msg[1].len = data_len;
> +		msg[1].buf = buf_recv;
> +		msg_num = 2;
> +		set_bit(I2C_HID_READ_PENDING, &ihid->flags);
> +	}
> +
> +	if (wait)
> +		set_bit(I2C_HID_RESET_PENDING, &ihid->flags);
> +
> +	ret = i2c_transfer(client->adapter, msg, msg_num);
> +
> +	if (data_len > 0)
> +		clear_bit(I2C_HID_READ_PENDING, &ihid->flags);
> +
> +	if (ret != msg_num)
> +		return ret < 0 ? ret : -EIO;
> +
> +	ret = 0;
> +
> +	if (wait) {
> +		i2c_hid_dbg(ihid, "%s: waiting...\n", __func__);
> +		if (!wait_event_timeout(ihid->wait,
> +				!test_bit(I2C_HID_RESET_PENDING, &ihid->flags),
> +				msecs_to_jiffies(5000)))
> +			ret = -ENODATA;
> +		i2c_hid_dbg(ihid, "%s: finished.\n", __func__);
> +	}
> +
> +	return ret;
> +}
> +
> +static int i2c_hid_command(struct i2c_client *client,
> +		const struct i2c_hid_cmd *command,
> +		unsigned char *buf_recv, int data_len)
> +{
> +	return __i2c_hid_command(client, command, 0, 0, NULL, 0,
> +				buf_recv, data_len);
> +}
> +
> +static int i2c_hid_get_report(struct i2c_client *client, u8 reportType,
> +		u8 reportID, unsigned char *buf_recv, int data_len)
> +{
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	u8 args[3];
> +	int ret;
> +	int args_len = 0;
> +	u16 readRegister = le16_to_cpu(ihid->hdesc.wDataRegister);
> +
> +	i2c_hid_dbg(ihid, "%s\n", __func__);
> +
> +	if (reportID >= 0x0F) {
> +		args[args_len++] = reportID;
> +		reportID = 0x0F;
> +	}
> +
> +	args[args_len++] = readRegister & 0xFF;
> +	args[args_len++] = readRegister >> 8;
> +
> +	ret = __i2c_hid_command(client, &hid_get_report_cmd, reportID,
> +		reportType, args, args_len, buf_recv, data_len);
> +	if (ret) {
> +		dev_err(&client->dev, "hid_get_report_cmd Fail\n");

                How about "failed to retrieve report from device.\n"?

> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
> +		u8 reportID, unsigned char *buf, size_t data_len)
> +{
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	u8 *args = ihid->argsbuf;
> +	int ret;
> +	u16 dataRegister = le16_to_cpu(ihid->hdesc.wDataRegister);
> +	int args_len =  (reportID >= 0x0F ? 1 : 0) +
> +			2 /* dataRegister */ +
> +			2 /* data_len */ +
> +			data_len;
> +	int index = 0;
> +
> +	i2c_hid_dbg(ihid, "%s\n", __func__);
> +
> +	if (reportID >= 0x0F) {
> +		args[index++] = reportID;
> +		reportID = 0x0F;
> +	}
> +
> +	args[index++] = dataRegister & 0xFF;
> +	args[index++] = dataRegister >> 8;
> +
> +	/* hidraw already checked that data_len < HID_MAX_BUFFER_SIZE */
> +	args[index++] = data_len & 0xFF;
> +	args[index++] = (data_len >> 8) & 0xFF;
> +
> +	memcpy(&args[index], buf, data_len);
> +
> +	ret = __i2c_hid_command(client, &hid_set_report_cmd, reportID,
> +		reportType, args, args_len, NULL, 0);
> +	if (ret) {
> +		dev_err(&client->dev, "hid_set_report_cmd Fail\n");

                How about "failed to set a report to device.\n"?

> +		return -EINVAL;
> +	}
> +
> +	return data_len;
> +}
> +
> +static int i2c_hid_write_out_report(struct i2c_client *client,
> +		u8 reportID, unsigned char *buf, size_t data_len)
> +{
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	u8 *args = ihid->argsbuf;
> +	int ret;
> +	int args_len =  1 /* reportID */ +
> +			2 /* data_len */ +
> +			data_len;
> +	int index = 0;
> +
> +	i2c_hid_dbg(ihid, "%s\n", __func__);
> +
> +	args[index++] = reportID;
> +
> +	/* hidraw already checked that data_len < HID_MAX_BUFFER_SIZE */
> +	args[index++] = data_len & 0xFF;
> +	args[index++] = (data_len >> 8) & 0xFF;
> +
> +	memcpy(&args[index], buf, data_len);
> +
> +	ret = __i2c_hid_command(client, &hid_out_cmd, 0, 0, args, args_len,
> +		NULL, 0);
> +	if (ret) {
> +		dev_err(&client->dev, "hid_out_cmd Fail\n");

                How about "failed to write output report.\n"?

> +		return -EINVAL;
> +	}
> +
> +	return data_len;
> +}
> +
> +static int i2c_hid_set_power(struct i2c_client *client, int power_state)
> +{
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	int ret;
> +
> +	i2c_hid_dbg(ihid, "%s\n", __func__);
> +
> +	ret = __i2c_hid_command(client, &hid_set_power_cmd, power_state,
> +		0, NULL, 0, NULL, 0);
> +	if (ret)
> +		dev_err(&client->dev, "hid_set_power_cmd Fail\n");

                How about "failed to change power setting.\n"?
> +
> +	return ret;
> +}
> +
> +static int i2c_hid_hwreset(struct i2c_client *client)
> +{
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	int ret;
> +
> +	i2c_hid_dbg(ihid, "%s\n", __func__);
> +
> +	ret = i2c_hid_set_power(client, I2C_HID_PWR_ON);
> +	if (ret)
> +		return ret;
> +
> +	i2c_hid_dbg(ihid, "resetting...\n");
> +
> +	ret = i2c_hid_command(client, &hid_reset_cmd, NULL, 0);
> +	if (ret) {
> +		dev_err(&client->dev, "hid_reset_cmd Fail\n");

                How about "failed to reset device.\n"?

> +		i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int i2c_hid_get_input(struct i2c_hid *ihid)
> +{
> +	int ret, ret_size;
> +	int size = le16_to_cpu(ihid->hdesc.wMaxInputLength);
> +
> +	ret = i2c_master_recv(ihid->client, ihid->inbuf, size);
> +	if (ret != size) {
> +		if (ret < 0)
> +			return ret;
> +
> +		dev_err(&ihid->client->dev, "%s: got %d data instead of %d\n",
> +			__func__, ret, size);
> +		return ret;
> +	}
> +
> +	ret_size = ihid->inbuf[0] | ihid->inbuf[1] << 8;
> +
> +	if (!ret_size) {
> +		/* host or device initiated RESET completed */
> +		if (test_and_clear_bit(I2C_HID_RESET_PENDING, &ihid->flags))
> +			wake_up(&ihid->wait);
> +		return 0;
> +	}
> +
> +	if (ret_size > size) {
> +		dev_err(&ihid->client->dev, "%s: incomplete report (%d/%d)\n",
> +			__func__, size, ret_size);
> +		return -EIO;
> +	}
> +
> +	i2c_hid_dbg(ihid, "input: %*ph\n", ret_size, ihid->inbuf);
> +
> +	if (test_bit(I2C_HID_STARTED, &ihid->flags))
> +		hid_input_report(ihid->hid, HID_INPUT_REPORT, ihid->inbuf + 2,
> +				ret_size - 2, 1);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t i2c_hid_irq(int irq, void *dev_id)
> +{
> +	struct i2c_hid *ihid = dev_id;
> +
> +	if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
> +		return IRQ_HANDLED;
> +
> +	i2c_hid_get_input(ihid);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int i2c_hid_get_report_length(struct hid_report *report)
> +{
> +	return ((report->size - 1) >> 3) + 1 +
> +		report->device->report_enum[report->type].numbered + 2;
> +}
> +
> +static void i2c_hid_init_report(struct hid_report *report, u8 *buffer,
> +	size_t bufsize)
> +{
> +	struct hid_device *hid = report->device;
> +	struct i2c_client *client = hid->driver_data;
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	unsigned int size, ret_size;
> +
> +	size = i2c_hid_get_report_length(report);
> +	i2c_hid_get_report(client,
> +			report->type == HID_FEATURE_REPORT ? 0x03 : 0x01,
> +			report->id, buffer, size);
> +
> +	i2c_hid_dbg(ihid, "report (len=%d): %*ph\n", size, size, ihid->inbuf);
> +
> +	ret_size = buffer[0] | (buffer[1] << 8);
> +
> +	if (ret_size != size) {
> +		dev_err(&client->dev, "error in %s size:%d / ret_size:%d\n",
> +			__func__, size, ret_size);
> +		return;
> +	}
> +
> +	/* hid->driver_lock is held as we are in probe function,
> +	 * we just need to setup the input fields, so using
> +	 * hid_report_raw_event is safe. */
> +	hid_report_raw_event(hid, report->type, buffer + 2, size - 2, 1);
> +}
> +
> +/*
> + * Initialize all reports
> + */
> +static void i2c_hid_init_reports(struct hid_device *hid)
> +{
> +	struct hid_report *report;
> +	struct i2c_client *client = hid->driver_data;
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	u8 *inbuf = kzalloc(ihid->bufsize, GFP_KERNEL);
> +
> +	if (!inbuf)
> +		return;
> +
> +	list_for_each_entry(report,
> +		&hid->report_enum[HID_INPUT_REPORT].report_list, list)
> +		i2c_hid_init_report(report, inbuf, ihid->bufsize);
> +
> +	list_for_each_entry(report,
> +		&hid->report_enum[HID_FEATURE_REPORT].report_list, list)
> +		i2c_hid_init_report(report, inbuf, ihid->bufsize);
> +
> +	kfree(inbuf);
> +}
> +
> +/*
> + * Traverse the supplied list of reports and find the longest
> + */
> +static void i2c_hid_find_max_report(struct hid_device *hid, unsigned int type,
> +		unsigned int *max)
> +{
> +	struct hid_report *report;
> +	unsigned int size;
> +
> +	/* We should not rely on wMaxInputLength, as some devices may set it to
> +	 * a wrong length. */
> +	list_for_each_entry(report, &hid->report_enum[type].report_list, list) {
> +		size = i2c_hid_get_report_length(report);
> +		if (*max < size)
> +			*max = size;
> +	}
> +}
> +
> +static int i2c_hid_alloc_buffers(struct i2c_hid *ihid)
> +{
> +	/* the worst case is computed from the set_report command with a
> +	 * reportID > 15 and the maximum report length */
> +	int args_len = sizeof(__u8) + /* optional ReportID byte */
> +		       sizeof(__u16) + /* data register */
> +		       sizeof(__u16) + /* size of the report */
> +		       ihid->bufsize; /* report */
> +
> +	ihid->inbuf = kzalloc(ihid->bufsize, GFP_KERNEL);
> +
> +	if (!ihid->inbuf)
> +		return -ENOMEM;
> +
> +	ihid->argsbuf = kzalloc(args_len, GFP_KERNEL);
> +
> +	if (!ihid->argsbuf) {
> +		kfree(ihid->inbuf);
> +		return -ENOMEM;
> +	}
> +
> +	ihid->cmdbuf = kzalloc(sizeof(union command) + args_len, GFP_KERNEL);
> +
> +	if (!ihid->cmdbuf) {
> +		kfree(ihid->inbuf);
> +		kfree(ihid->argsbuf);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static void i2c_hid_free_buffers(struct i2c_hid *ihid)
> +{
> +	kfree(ihid->inbuf);
> +	kfree(ihid->argsbuf);
> +	kfree(ihid->cmdbuf);
> +	ihid->inbuf = NULL;
> +	ihid->cmdbuf = NULL;
> +	ihid->argsbuf = NULL;
> +}
> +
> +static int i2c_hid_get_raw_report(struct hid_device *hid,
> +		unsigned char report_number, __u8 *buf, size_t count,
> +		unsigned char report_type)
> +{
> +	struct i2c_client *client = hid->driver_data;
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	int ret;
> +
> +	if (count > ihid->bufsize)
> +		count = ihid->bufsize;
> +
> +	ret = i2c_hid_get_report(client,
> +			report_type == HID_FEATURE_REPORT ? 0x03 : 0x01,
> +			report_number, ihid->inbuf, count);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	count = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
> +
> +	memcpy(buf, ihid->inbuf + 2, count);
> +
> +	return count;
> +}
> +
> +static int i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
> +		size_t count, unsigned char report_type)
> +{
> +	struct i2c_client *client = hid->driver_data;
> +	int report_id = buf[0];
> +
> +	if (report_type == HID_OUTPUT_REPORT)
> +		return i2c_hid_write_out_report(client, report_id, buf, count);
> +
> +	return i2c_hid_set_report(client,
> +				report_type == HID_FEATURE_REPORT ? 0x03 : 0x01,
> +				report_id, buf, count);
> +}
> +
> +static int i2c_hid_parse(struct hid_device *hid)
> +{
> +	struct i2c_client *client = hid->driver_data;
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	struct i2c_hid_desc *hdesc = &ihid->hdesc;
> +	unsigned int rsize;
> +	char *rdesc;
> +	int ret;
> +	int tries = 3;
> +
> +	i2c_hid_dbg(ihid, "entering %s\n", __func__);
> +
> +	rsize = le16_to_cpu(hdesc->wReportDescLength);
> +	if (!rsize || rsize > HID_MAX_DESCRIPTOR_SIZE) {
> +		dbg_hid("weird size of report descriptor (%u)\n", rsize);
> +		return -EINVAL;
> +	}
> +
> +	do {
> +		ret = i2c_hid_hwreset(client);
> +		if (ret)
> +			msleep(1000);
> +	} while (tries-- > 0 && ret);
> +
> +	if (ret)
> +		return ret;
> +
> +	rdesc = kzalloc(rsize, GFP_KERNEL);
> +
> +	if (!rdesc) {
> +		dbg_hid("couldn't allocate rdesc memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	i2c_hid_dbg(ihid, "asking HID report descriptor\n");
> +
> +	ret = i2c_hid_command(client, &hid_report_descr_cmd, rdesc, rsize);
> +	if (ret) {
> +		hid_err(hid, "reading report descriptor failed\n");
> +		kfree(rdesc);
> +		return -EIO;
> +	}
> +
> +	i2c_hid_dbg(ihid, "Report Descriptor: %*ph\n", rsize, rdesc);
> +
> +	ret = hid_parse_report(hid, rdesc, rsize);
> +	kfree(rdesc);
> +	if (ret) {
> +		dbg_hid("parsing report descriptor failed\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int i2c_hid_start(struct hid_device *hid)
> +{
> +	struct i2c_client *client = hid->driver_data;
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	int ret;
> +	int old_bufsize = ihid->bufsize;
> +
> +	ihid->bufsize = HID_MIN_BUFFER_SIZE;
> +	i2c_hid_find_max_report(hid, HID_INPUT_REPORT, &ihid->bufsize);
> +	i2c_hid_find_max_report(hid, HID_OUTPUT_REPORT, &ihid->bufsize);
> +	i2c_hid_find_max_report(hid, HID_FEATURE_REPORT, &ihid->bufsize);
> +
> +	if (ihid->bufsize > old_bufsize || !ihid->inbuf || !ihid->cmdbuf) {
> +		i2c_hid_free_buffers(ihid);
> +
> +		ret = i2c_hid_alloc_buffers(ihid);
> +
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (!(hid->quirks & HID_QUIRK_NO_INIT_REPORTS))
> +		i2c_hid_init_reports(hid);
> +
> +	return 0;
> +}
> +
> +static void i2c_hid_stop(struct hid_device *hid)
> +{
> +	struct i2c_client *client = hid->driver_data;
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +
> +	hid->claimed = 0;
> +
> +	i2c_hid_free_buffers(ihid);
> +}
> +
> +static int i2c_hid_open(struct hid_device *hid)
> +{
> +	struct i2c_client *client = hid->driver_data;
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	int ret;
> +
> +	if (!hid->open++) {
> +		ret = i2c_hid_set_power(client, I2C_HID_PWR_ON);
> +		if (ret) {
> +			hid->open--;
> +			return -EIO;
> +		}
> +		set_bit(I2C_HID_STARTED, &ihid->flags);
> +	}
> +	return 0;
> +}
> +
> +static void i2c_hid_close(struct hid_device *hid)
> +{
> +	struct i2c_client *client = hid->driver_data;
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +
> +	/* protecting hid->open to make sure we don't restart
> +	 * data acquistion due to a resumption we no longer
> +	 * care about
> +	 */
> +	if (!--hid->open) {
> +		clear_bit(I2C_HID_STARTED, &ihid->flags);
> +
> +		/* Save some power */
> +		i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
> +	}
> +}
> +
> +static int i2c_hid_power(struct hid_device *hid, int lvl)
> +{
> +	struct i2c_client *client = hid->driver_data;
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	int ret = 0;
> +
> +	i2c_hid_dbg(ihid, "%s lvl:%d\n", __func__, lvl);
> +
> +	switch (lvl) {
> +	case PM_HINT_FULLON:
> +		ret = i2c_hid_set_power(client, I2C_HID_PWR_ON);
> +		break;
> +	case PM_HINT_NORMAL:
> +		ret = i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
> +		break;
> +	}
> +	return ret;
> +}
> +
> +static int i2c_hid_hidinput_input_event(struct input_dev *dev,
> +		unsigned int type, unsigned int code, int value)
> +{
> +	struct hid_device *hid = input_get_drvdata(dev);
> +	struct hid_field *field;
> +	int offset;
> +
> +	if (type == EV_FF)
> +		return input_ff_event(dev, type, code, value);
> +
> +	if (type != EV_LED)
> +		return -1;
> +
> +	offset = hidinput_find_field(hid, type, code, &field);
> +
> +	if (offset == -1) {
> +		hid_warn(dev, "event field not found\n");
> +		return -1;
> +	}
> +
> +	hid_set_field(field, offset, value);
> +
> +	return 0;
> +}
> +
> +static struct hid_ll_driver i2c_hid_ll_driver = {
> +	.parse = i2c_hid_parse,
> +	.start = i2c_hid_start,
> +	.stop = i2c_hid_stop,
> +	.open = i2c_hid_open,
> +	.close = i2c_hid_close,
> +	.power = i2c_hid_power,
> +	.hidinput_input_event = i2c_hid_hidinput_input_event,
> +};
> +
> +static int __devinit i2c_hid_init_irq(struct i2c_client *client)
> +{
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	int ret;
> +
> +	dev_dbg(&client->dev, "Requesting IRQ: %d\n", client->irq);
> +
> +	ret = request_threaded_irq(client->irq, NULL, i2c_hid_irq,
> +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +			client->name, ihid);
> +	if (ret < 0) {
> +		dev_dbg(&client->dev,
> +			"Could not register for %s interrupt, irq = %d,"
> +			" ret = %d\n",
> +		client->name, client->irq, ret);
> +
> +		return ret;
> +	}
> +
> +	ihid->irq = client->irq;
> +
> +	return 0;
> +}
> +
> +static int __devinit i2c_hid_fetch_hid_descriptor(struct i2c_hid *ihid)
> +{
> +	struct i2c_client *client = ihid->client;
> +	struct i2c_hid_desc *hdesc = &ihid->hdesc;
> +	unsigned int dsize;
> +	int ret;
> +
> +	/* Fetch the length of HID description, retrieve the 4 first bytes:
> +	 * bytes 0-1 -> length
> +	 * bytes 2-3 -> bcdVersion (has to be 1.00) */
> +	ret = i2c_hid_command(client, &hid_descr_cmd, ihid->hdesc_buffer, 4);
> +
> +	i2c_hid_dbg(ihid, "%s, ihid->hdesc_buffer: %*ph\n",
> +			__func__, 4, ihid->hdesc_buffer);
> +
> +	if (ret) {
> +		dev_err(&client->dev, "HID_DESCR_LENGTH_CMD Fail (ret=%d)\n",

                How about "failed to get descriptor length (ret = %d).\n"?

> +			ret);
> +		return -ENODEV;

                In this function, would it be more approriate to return -EINVAL?

> +	}
> +
> +	dsize = le16_to_cpu(hdesc->wHIDDescLength);
> +	if (!dsize || dsize > HID_MAX_DESCRIPTOR_SIZE) {
> +		dev_err(&client->dev, "weird size of HID descriptor (%u)\n",
> +			dsize);
> +		return -ENODEV;
                       -EINVAL?
> +	}
> +
> +	/* check bcdVersion == 1.0 */
> +	if (le16_to_cpu(hdesc->bcdVersion) != 0x0100) {
> +		dev_err(&client->dev,
> +			"unexpected HID descriptor bcdVersion (0x%04x)\n",
> +			le16_to_cpu(hdesc->bcdVersion));
> +		return -ENODEV;
                       -EINVAL?
> +	}
> +
> +	i2c_hid_dbg(ihid, "Fetching the HID descriptor\n");
> +
> +	ret = i2c_hid_command(client, &hid_descr_cmd, ihid->hdesc_buffer,
> +				dsize);
> +	if (ret) {
> +		dev_err(&client->dev, "hid_descr_cmd Fail\n");

                How about "failed to fetch HID descriptor.\n"?

> +		return -ENODEV;
                       -EINVAL?

Thanks,
-JJ

> +	}
> +
> +	i2c_hid_dbg(ihid, "HID Descriptor: %*ph\n", dsize, ihid->hdesc_buffer);
> +
> +	return 0;
> +}
> +
