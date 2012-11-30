Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2K3O5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 09:57:23 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:26385 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2K3O5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 09:57:21 -0500
Date: Fri, 30 Nov 2012 15:56:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, JJ Ding <jj_ding@emc.com.tw>,
        Jiri Slaby <jslaby@suse.cz>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] i2c-hid: introduce HID over i2c specification
 implementation
Message-ID: <20121130155650.69407e9f@endymion.delvare>
In-Reply-To: <1352731379-24683-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352731379-24683-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin, Jiri,

Sorry for the late review. But better late than never I guess...

On Mon, 12 Nov 2012 15:42:59 +0100, Benjamin Tissoires wrote:
> Microsoft published the protocol specification of HID over i2c:
> http://msdn.microsoft.com/en-us/library/windows/hardware/hh852380.aspx
> 
> This patch introduces an implementation of this protocol.
> 
> This implementation does not includes the ACPI part of the specification.
> This will come when ACPI 5.0 devices enumeration will be available.
> 
> Once the ACPI part is done, OEM will not have to declare HID over I2C
> devices in their platform specific driver.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
> (..)
>  drivers/hid/Kconfig           |   2 +
>  drivers/hid/Makefile          |   1 +
>  drivers/hid/i2c-hid/Kconfig   |  21 +
>  drivers/hid/i2c-hid/Makefile  |   5 +
>  drivers/hid/i2c-hid/i2c-hid.c | 974 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/i2c-hid.h   |  35 ++
>  6 files changed, 1038 insertions(+)
>  create mode 100644 drivers/hid/i2c-hid/Kconfig
>  create mode 100644 drivers/hid/i2c-hid/Makefile
>  create mode 100644 drivers/hid/i2c-hid/i2c-hid.c
>  create mode 100644 include/linux/i2c/i2c-hid.h

Looks much better. I still have several random comments which you may
be interested in.

> (...)
> diff --git a/drivers/hid/i2c-hid/Kconfig b/drivers/hid/i2c-hid/Kconfig
> new file mode 100644
> index 0000000..5b7d4d8
> --- /dev/null
> +++ b/drivers/hid/i2c-hid/Kconfig
> @@ -0,0 +1,21 @@
> +menu "I2C HID support"
> +	depends on I2C
> +
> +config I2C_HID
> +	tristate "HID over I2C transport layer"
> +	default n
> +	depends on I2C && INPUT
> +	select HID
> +	---help---
> +	  Say Y here if you want to use the HID over i2c protocol
> +	  implementation.


s/i2c/I2C/

The USB equivalent lists a number of examples, maybe you could do the
same here so that the reader knows if he/she needs this driver.

> +
> +	  If unsure, say N.
> +
> +	  This support is also available as a module.  If so, the module
> +	  will be called i2c-hid.
> +
> +comment "Input core support is needed for HID over I2C input layer"
> +	depends on I2C_HID && INPUT=n

Given that the HID menu itself depends on INPUT, I fail to see how this
comment would ever be displayed. Same question holds for the USB
equivalent.

> +
> +endmenu
> (...)
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> new file mode 100644
> index 0000000..11140bd
> --- /dev/null
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> (...)
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

Whether you like it or not, that's still an error for checkpatch:
ERROR: do not initialise statics to 0 or NULL
#240: FILE: drivers/hid/i2c-hid/i2c-hid.c:49:
+static bool debug = false;

The rationale is that the compiler can write more efficient code if
initializations to 0 or NULL are implicit.

> +module_param(debug, bool, 0444);
> +MODULE_PARM_DESC(debug, "print a lot of debug information");
> +
> +#define i2c_hid_dbg(ihid, fmt, arg...)	\
> +	if (debug)			\
> +		dev_printk(KERN_DEBUG, &(ihid)->client->dev, fmt, ##arg)

This is considered an error by checkpatch too:
ERROR: Macros with complex values should be enclosed in parenthesis
#244: FILE: drivers/hid/i2c-hid/i2c-hid.c:53:
+#define i2c_hid_dbg(ihid, fmt, arg...)	\
+	if (debug)			\
+		dev_printk(KERN_DEBUG, &(ihid)->client->dev, fmt, ##arg)

And I wouldn't disagree, as the construct above can lead to bugs which
are hard to see... Consider the following piece of code:

	if (condition)
		i2c_hid_dbg(ihid, "Blah blah %d\n", i);
	else
		do_something_very_important();

It looks correct, however with the macro definition above, this expands
to the unexpected:

	if (condition) {
		if (debug)			\
			dev_printk(KERN_DEBUG, &ihid->client->dev,
				   "Blah blah %d\n", i);
		else
			do_something_very_important();
	}

That is, the condition to call do_something_very_important() is
condition && !debug, and not !condition as the code suggests. This is
only an example and your driver doesn't currently use any such
construct. Still I believe this should be fixed.

> (...)
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

The previous four are never used.

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

These two are never used either.

> (...)
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
> +		dev_err(&client->dev,
> +			"failed to retrieve report from device.\n");
> +		return -EINVAL;

Why don't you pass the error value from __i2c_hid_command to the
caller? -EINVAL is for invalid input parameters, which isn't the case
here.

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
> +
> +	/* hidraw already checked that data_len < HID_MAX_BUFFER_SIZE */
> +	u16 size =	2			/* size */ +
> +			(reportID ? 1 : 0)	/* reportID */ +
> +			data_len		/* buf */;
> +	int args_len =	(reportID >= 0x0F ? 1 : 0) /* optional third byte */ +
> +			2			/* dataRegister */ +
> +			size			/* args */;
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
> +	args[index++] = size & 0xFF;
> +	args[index++] = size >> 8;
> +
> +	if (reportID)
> +		args[index++] = reportID;
> +
> +	memcpy(&args[index], buf, data_len);
> +
> +	ret = __i2c_hid_command(client, &hid_set_report_cmd, reportID,
> +		reportType, args, args_len, NULL, 0);
> +	if (ret) {
> +		dev_err(&client->dev, "failed to set a report to device.\n");
> +		return -EINVAL;

Same here, returning "ret" would be more informative than hard-coding
an arbitrary error code.

> +	}
> +
> +	return data_len;
> +}
> + (...)
> +static int i2c_hid_get_input(struct i2c_hid *ihid)

The caller never checks the return value. If there is nothing useful
the caller can do with the value then you should consider making
i2c_hid_get_input return void.

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

If you don't change this function to return void, you should return
-Esomething instead of ret here, so that the caller doesn't get an
unexpected positive number.

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
> + (...)
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

This can fail.

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

No error logged, no error reported to the caller?

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
> (...)
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

If it is important to set ihid->inbuf and ihid->argsbuf back to NULL in
the error path below, then I suppose it is equally important to set
ihid->inbuf back to NULL here. BTW, I would like to suggest an easier
and more efficient way to handle this, see below.

> +		return -ENOMEM;
> +	}
> +
> +	ihid->cmdbuf = kzalloc(sizeof(union command) + args_len, GFP_KERNEL);
> +
> +	if (!ihid->cmdbuf) {
> +		kfree(ihid->inbuf);
> +		kfree(ihid->argsbuf);
> +		ihid->inbuf = NULL;
> +		ihid->argsbuf = NULL;
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +

With proper function ordering, the above could be simplified to:

static int i2c_hid_alloc_buffers(struct i2c_hid *ihid)
{
	/* the worst case is computed from the set_report command with a
	 * reportID > 15 and the maximum report length */
	int args_len = sizeof(__u8) + /* optional ReportID byte */
		       sizeof(__u16) + /* data register */
		       sizeof(__u16) + /* size of the report */
		       ihid->bufsize; /* report */

	ihid->inbuf = kzalloc(ihid->bufsize, GFP_KERNEL);
	ihid->argsbuf = kzalloc(args_len, GFP_KERNEL);
	ihid->cmdbuf = kzalloc(sizeof(union command) + args_len, GFP_KERNEL);

	if (!ihid->inbuf || !ihid->argsbuf || !ihid->cmdbuf) {
		i2c_hid_free_buffers(hid);
		return -ENOMEM;
	}

	return 0;
}

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
> +	if (report_type == HID_OUTPUT_REPORT)
> +		return -EINVAL;
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

What guarantee do you have that count is not larger than buf's length?
I hope you don't just count on all hardware out there being nice and
sane, do you? ;)

> +
> +	return count;
> +}
> + (...)
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

hid_err() would suit better IMHO.

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

Here too, if this is an unexpected event hid_warn() or hid_err() would
be better.

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

I don't quite get this condition. As far as I can see, either all 3
buffers are allocated, or none is. A single test should tell you. If
you set ihid->bufsize to 0 on memory allocation failure, testing for
ihid->bufsize > old_bufsize should be sufficient.

> +		i2c_hid_free_buffers(ihid);
> +
> +		ret = i2c_hid_alloc_buffers(ihid);
> +
> +		if (ret) {
> +			ihid->bufsize = old_bufsize;

Not really... If we fail here, this means that all 3 buffers have been
freed, so ihid->bufsize is more like 0.

> +			return ret;
> +		}
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

This looks racy. The usbhid driver protects hid->open with a mutex and
I suspect you should do the same.

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
> (...)
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

hid_set_field() can fail, so maybe

	return hid_set_field(field, offset, value);

> +}
> + (...)
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

dev_warn()? Indentation is broken too.

> +
> +		return ret;
> +	}
> +
> +	ihid->irq = client->irq;

I don't think you need this. Everywhere you use ihid->irq, you have
client at hand so you could as well use client->irq. This would avoid
inconsistencies like free_irq(ihid->irq, ihid) in probing error path
vs. free_irq(client->irq, ihid) in removal path, or
enable_irq_wake(ihid->irq) vs. disable_irq_wake(client->irq) in
suspend/resume.

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
> +			ret);

This message is a little confusing as HID_DESCR_LENGTH_CMD no longer
exists.

> +		return -ENODEV;
> +	}
> +
> +	dsize = le16_to_cpu(hdesc->wHIDDescLength);
> +	if (!dsize || dsize > HID_MAX_DESCRIPTOR_SIZE) {
> +		dev_err(&client->dev, "weird size of HID descriptor (%u)\n",
> +			dsize);
> +		return -ENODEV;
> +	}
> +
> +	/* check bcdVersion == 1.0 */
> +	if (le16_to_cpu(hdesc->bcdVersion) != 0x0100) {
> +		dev_err(&client->dev,
> +			"unexpected HID descriptor bcdVersion (0x%04x)\n",

Should be 0x%04hx.

> +			le16_to_cpu(hdesc->bcdVersion));
> +		return -ENODEV;
> +	}
> +
> +	i2c_hid_dbg(ihid, "Fetching the HID descriptor\n");
> +
> +	ret = i2c_hid_command(client, &hid_descr_cmd, ihid->hdesc_buffer,
> +				dsize);
> +	if (ret) {
> +		dev_err(&client->dev, "hid_descr_cmd Fail\n");
> +		return -ENODEV;
> +	}
> +
> +	i2c_hid_dbg(ihid, "HID Descriptor: %*ph\n", dsize, ihid->hdesc_buffer);
> +
> +	return 0;
> +}
> +
> +static int __devinit i2c_hid_probe(struct i2c_client *client,
> +		const struct i2c_device_id *dev_id)
> +{
> +	int ret;
> +	struct i2c_hid *ihid;
> +	struct hid_device *hid;
> +	__u16 hidRegister;
> +	struct i2c_hid_platform_data *platform_data = client->dev.platform_data;
> +
> +	dbg_hid("HID probe called for i2c 0x%02x\n", client->addr);
> +
> +	if (!platform_data) {
> +		dev_err(&client->dev, "HID register address not provided\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!client->irq) {
> +		dev_err(&client->dev,
> +			"HID over i2c has not been provided an Int IRQ\n");
> +		return -EINVAL;
> +	}
> +
> +	ihid = kzalloc(sizeof(struct i2c_hid), GFP_KERNEL);
> +	if (!ihid)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(client, ihid);
> +
> +	ihid->client = client;
> +
> +	hidRegister = platform_data->hid_descriptor_address;
> +	ihid->wHIDDescRegister = cpu_to_le16(hidRegister);
> +
> +	init_waitqueue_head(&ihid->wait);
> +
> +	/* we need to allocate the command buffer without knowing the maximum
> +	 * size of the reports. Let's use HID_MIN_BUFFER_SIZE, then we do the
> +	 * real computation later. */
> +	ihid->bufsize = HID_MIN_BUFFER_SIZE;
> +	i2c_hid_alloc_buffers(ihid);

This could fail, yet you don't check for an error.

> +
> +	ret = i2c_hid_fetch_hid_descriptor(ihid);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = i2c_hid_init_irq(client);
> +	if (ret < 0)
> +		goto err;
> +
> +	hid = hid_allocate_device();
> +	if (IS_ERR(hid)) {
> +		ret = PTR_ERR(hid);
> +		goto err;
> +	}
> +
> +	ihid->hid = hid;
> +
> +	hid->driver_data = client;
> +	hid->ll_driver = &i2c_hid_ll_driver;
> +	hid->hid_get_raw_report = i2c_hid_get_raw_report;
> +	hid->hid_output_raw_report = i2c_hid_output_raw_report;
> +	hid->dev.parent = &client->dev;
> +	hid->bus = BUS_I2C;
> +	hid->version = le16_to_cpu(ihid->hdesc.bcdVersion);
> +	hid->vendor = le16_to_cpu(ihid->hdesc.wVendorID);
> +	hid->product = le16_to_cpu(ihid->hdesc.wProductID);
> +
> +	snprintf(hid->name, sizeof(hid->name), "%s %04X:%04X",

Should be %04hX:%04hX.

> +		 client->name, hid->vendor, hid->product);
> +
> +	ret = hid_add_device(hid);
> +	if (ret) {
> +		if (ret != -ENODEV)
> +			hid_err(client, "can't add hid device: %d\n", ret);
> +		goto err_mem_free;
> +	}
> +
> +	return 0;
> +
> +err_mem_free:
> +	hid_destroy_device(hid);
> +
> +err:
> +	if (ihid->irq)
> +		free_irq(ihid->irq, ihid);
> +
> +	kfree(ihid);
> +	return ret;
> +}
> +
> +static int __devexit i2c_hid_remove(struct i2c_client *client)
> +{
> +	struct i2c_hid *ihid = i2c_get_clientdata(client);
> +	struct hid_device *hid;
> +
> +	if (WARN_ON(!ihid))
> +		return -1;

This just can't happen...?

> +
> +	hid = ihid->hid;
> +	hid_destroy_device(hid);
> +
> +	free_irq(client->irq, ihid);
> +

Is there any guarantee that i2c_hid_stop() has been called before
i2c_hid_remove() is? If not, you're missing a call to
i2c_hid_free_buffers() here. BTW I'm not quite sure why
i2c_hid_remove() frees the buffers in the first place, but then again I
don't know a thing about the HID infrastructure.

> +	kfree(ihid);
> +
> +	return 0;
> +}
> +(...)
> +static const struct i2c_device_id i2c_hid_id_table[] = {
> +	{ "i2c_hid", 0 },

I am just realizing "i2c_hid" is a little redundant as an i2c device
name. Can we make this just "hid"?

> +	{ },
> +};
> +MODULE_DEVICE_TABLE(i2c, i2c_hid_id_table);

-- 
Jean Delvare
