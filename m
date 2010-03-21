Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0CUDqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 23:46:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54793 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0CUDqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 23:46:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=IpVPzuY9aT7eaksYH4hBzfSegYGr0J/+vGE8M+qcfkrQ/iFhrEP02PPwrgo6Tog77O
         ItIjEYz+frko2z/u7ecUuA46AyzF2BjTS4ylBkXjzIacuQH9MUKnpNHBALSwvTA1Lq7x
         XF1Aip8Vdzew752Nl8aySb7JEbTv0QuZOJUDA=
Date: Sat, 20 Mar 2010 20:46:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v2 1/6] hid: new driver for PicoLCD device
Message-ID: <20100321034600.GE29360@core.coreip.homeip.net>
References: <20100320170014.440959a8@neptune.home>
 <20100320170241.55258b0d@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100320170241.55258b0d@neptune.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 05:02:41PM +0100, Bruno Prémont wrote:
> +/* Input device
> + *
> + * The PicoLCD has an IR receiver header, a built-in keypad with 5 keys
> + * and header for 4x4 key matrix. The built-in keys are part of the matrix.
> + */
> +#define PICOLCD_KEYS 17
> +
> +static const int def_keymap[PICOLCD_KEYS] = {

def_keymap[] = {
...
};
#define PICOLCD_KEYS ARRAY_SIZE(def_keymap);

would be safe.  Also unsigned short should cover it.

> +	KEY_RESERVED,	/* none */
> +	KEY_BACK,	/* col 4 + row 1 */
> +	KEY_HOMEPAGE,	/* col 3 + row 1 */
> +	KEY_RESERVED,	/* col 2 + row 1 */
> +	KEY_RESERVED,	/* col 1 + row 1 */
> +	KEY_SCROLLUP,	/* col 4 + row 2 */
> +	KEY_OK,		/* col 3 + row 2 */
> +	KEY_SCROLLDOWN,	/* col 2 + row 2 */
> +	KEY_RESERVED,	/* col 1 + row 2 */
> +	KEY_RESERVED,	/* col 4 + row 3 */
> +	KEY_RESERVED,	/* col 3 + row 3 */
> +	KEY_RESERVED,	/* col 2 + row 3 */
> +	KEY_RESERVED,	/* col 1 + row 3 */
> +	KEY_RESERVED,	/* col 4 + row 4 */
> +	KEY_RESERVED,	/* col 3 + row 4 */
> +	KEY_RESERVED,	/* col 2 + row 4 */
> +	KEY_RESERVED,	/* col 1 + row 4 */
> +};
> +
> +/* Description of in-progress IO operation, used for operations
> + * that trigger response from device */
> +struct picolcd_pending {
> +	struct hid_report *out_report;
> +	struct hid_report *in_report;
> +	int raw_size;
> +	u8 raw_data[64];
> +};
> +
> +/* Per device data structure */
> +struct picolcd_data {
> +	struct hid_device *hdev;
> +#ifdef CONFIG_DEBUG_FS
> +	int addr_sz;
> +#endif
> +	u8 version[2];
> +	/* input stuff */
> +	u8 pressed_keys[2];
> +	struct input_dev *input_keys;
> +	struct input_dev *input_cir;
> +	int keycode[PICOLCD_KEYS];
> +
> +	/* Housekeeping stuff */
> +	spinlock_t lock;
> +	struct picolcd_pending *pending;
> +	struct completion ready;
> +	int status;
> +#define PICOLCD_BUSY 1
> +#define PICOLCD_FAILED 4
> +#define PICOLCD_BOOTLOADER 8
> +};
> +
> +
> +/* Find a given report */
> +#define picolcd_in_report(id, dev) picolcd_report(id, dev, HID_INPUT_REPORT)
> +#define picolcd_out_report(id, dev) picolcd_report(id, dev, HID_OUTPUT_REPORT)
> +
> +static struct hid_report *picolcd_report(int id, struct hid_device *hdev, int dir)
> +{
> +	struct list_head *feature_report_list = &hdev->report_enum[dir].report_list;
> +	struct hid_report *report = NULL;
> +
> +	list_for_each_entry(report, feature_report_list, list) {
> +		if (report->id == id)
> +			return report;
> +	}
> +	dev_warn(&hdev->dev, "No report with id 0x%x found\n", id);
> +	return NULL;
> +}
> +
> +#ifdef CONFIG_DEBUG_FS
> +static void picolcd_debug_out_report(struct picolcd_data *data,
> +		struct hid_device *hdev, struct hid_report *report);
> +#define usbhid_submit_report(a, b, c) \
> +	picolcd_debug_out_report(hid_get_drvdata(a), a, b); \
> +	usbhid_submit_report(a, b, c)
> +#endif
> +
> +/* Submit a report and wait for a reply from device - if device fades away
> + * or does not respond in time, return NULL */
> +static struct picolcd_pending* picolcd_send_and_wait(struct hid_device *hdev,
> +		int report_id, const u8 *raw_data, int size)
> +{
> +	struct picolcd_data *data = hid_get_drvdata(hdev);
> +	struct picolcd_pending *work;
> +	struct hid_report *report = picolcd_out_report(report_id, hdev);
> +	unsigned long flags;
> +	int status, i, j, k;
> +
> +	if (!report)
> +		return NULL;
> +	work = kzalloc(sizeof(*work), GFP_KERNEL);
> +	if (!work)
> +		return NULL;
> +
> +	work->out_report = report;
> +	work->in_report  = NULL;
> +	work->raw_size   = 0;
> +
> +retry:
> +	/* try to get lock and enqueue our job */
> +	spin_lock_irqsave(&data->lock, flags);
> +	status = data->status;
> +	if (data->pending || (status & PICOLCD_FAILED)) {
> +		/* some job already pending,
> +		 * wait for it to complete and try again */
> +		spin_unlock_irqrestore(&data->lock, flags);
> +		if (status & PICOLCD_FAILED) {
> +			kfree(work);
> +			return NULL;
> +		}
> +		wait_for_completion_interruptible_timeout(&data->ready, HZ*2);
> +		goto retry;

Umm, can we do this with a mutex? Like you take a mutex and don't
release till you are done talking to the device. So that other guy will
wait on the mutex instead of waking up and rechecking condition.

> +	}
> +	data->status |= PICOLCD_BUSY;
> +	data->pending = work;
> +	for (i = k = 0; i < report->maxfield; i++)
> +		for (j = 0; j < report->field[i]->report_count; j++) {
> +			hid_set_field(report->field[i], j, k < size ? raw_data[k] : 0);
> +			k++;
> +		}
> +	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
> +	complete_all(&data->ready);
> +	INIT_COMPLETION(data->ready);

Umm, what does this do, exactly?

> +	spin_unlock_irqrestore(&data->lock, flags);
> +	/* wait for our job to complete */
> +	wait_for_completion_interruptible_timeout(&data->ready, HZ*2);
> +
> +	spin_lock_irqsave(&data->lock, flags);
> +	if (data->pending == work) {
> +		data->status  &= ~PICOLCD_BUSY;
> +		data->pending = NULL;
> +		complete_all(&data->ready);
> +		spin_unlock_irqrestore(&data->lock, flags);
> +		return work;
> +	} else {
> +		spin_unlock_irqrestore(&data->lock, flags);
> +		kfree(work);
> +		return NULL;
> +	}
> +}
> +
> +/*
> + * input class device
> + */
> +static int picolcd_raw_keypad(struct hid_device *hdev,
> +		struct hid_report *report, u8 *raw_data, int size)
> +{
> +	/*
> +	 * Keypad event
> +	 * First and second data bytes list currently pressed keys,
> +	 * 0x00 means no key and at most 2 keys may be pressed at same time
> +	 */
> +	struct picolcd_data *data = hid_get_drvdata(hdev);
> +	int i, j;
> +
> +	/* determine newly pressed keys */
> +	for (i = 0; i < size; i++) {
> +		int key_code;
> +		if (raw_data[i] == 0)
> +			continue;
> +		for (j = 0; j < sizeof(data->pressed_keys); j++)
> +			if (data->pressed_keys[j] == raw_data[i])
> +				goto key_already_down;
> +		for (j = 0; j < sizeof(data->pressed_keys); j++)
> +			if (data->pressed_keys[j] == 0) {
> +				data->pressed_keys[j] = raw_data[i];
> +				break;
> +			}
> +		input_event(data->input_keys, EV_MSC, MSC_SCAN, raw_data[i]);
> +		if (input_get_keycode(data->input_keys, raw_data[i], &key_code))
> +			key_code = KEY_UNKNOWN;

Just get keycode directly from the driver's table, no need to jump through hoops
here,

> +		if (key_code != KEY_UNKNOWN) {
> +			dbg_hid(PICOLCD_NAME " got key press for %u:%d", raw_data[i], key_code);
> +			input_report_key(data->input_keys, key_code, 1);
> +		}
> +		input_sync(data->input_keys);
> +key_already_down:
> +		continue;
> +	}
> +
> +	/* determine newly released keys */
> +	for (j = 0; j < sizeof(data->pressed_keys); j++) {
> +		int key_code;
> +		if (data->pressed_keys[j] == 0)
> +			continue;
> +		for (i = 0; i < size; i++)
> +			if (data->pressed_keys[j] == raw_data[i])
> +				goto key_still_down;
> +		input_event(data->input_keys, EV_MSC, MSC_SCAN, data->pressed_keys[j]);
> +		if (input_get_keycode(data->input_keys, data->pressed_keys[j], &key_code))
> +			key_code = KEY_UNKNOWN;
> +		if (key_code != KEY_UNKNOWN) {
> +			dbg_hid(PICOLCD_NAME " got key release for %u:%d", data->pressed_keys[j], key_code);
> +			input_report_key(data->input_keys, key_code, 0);
> +		}
> +		input_sync(data->input_keys);
> +		data->pressed_keys[j] = 0;
> +key_still_down:
> +		continue;
> +	}
> +	return 1;
> +}
> +
> +static int picolcd_raw_cir(struct hid_device *hdev,
> +		struct hid_report *report, u8 *raw_data, int size)
> +{
> +	/* Need understanding of CIR data format to implement ... */
> +	return 1;
> +}
> +
> +
> +
> +/*
> + * Reset our device and wait for answer to VERSION request
> + */
> +static int picolcd_reset(struct hid_device *hdev)
> +{
> +	struct picolcd_data *data = hid_get_drvdata(hdev);
> +	struct hid_report *report = picolcd_out_report(REPORT_RESET, hdev);
> +	struct picolcd_pending *verinfo;
> +	unsigned long flags;
> +
> +	if (!data || !report || report->maxfield != 1)
> +		return -ENODEV;
> +
> +	spin_lock_irqsave(&data->lock, flags);
> +	complete_all(&data->ready);
> +	INIT_COMPLETION(data->ready);
> +	if (hdev->product == USB_DEVICE_ID_PICOLCD_BOOTLOADER)
> +		data->status |= PICOLCD_BOOTLOADER;
> +
> +	/* perform the reset */
> +	hid_set_field(report->field[0], 0, 1);
> +	usbhid_submit_report(hdev, report, USB_DIR_OUT);
> +	spin_unlock_irqrestore(&data->lock, flags);
> +
> +	verinfo = picolcd_send_and_wait(hdev, REPORT_VERSION, NULL, 0);
> +	if (verinfo && verinfo->raw_size == 2) {
> +		if (data->status & PICOLCD_BOOTLOADER) {
> +			dev_info(&hdev->dev, "PicoLCD reset successful, bootloader version %d.%d\n",
> +					verinfo->raw_data[0], verinfo->raw_data[1]);
> +			data->version[0] = verinfo->raw_data[0];
> +			data->version[1] = verinfo->raw_data[1];
> +		} else {
> +			dev_info(&hdev->dev, "PicoLCD reset successful, firmware version %d.%d\n",
> +					verinfo->raw_data[1], verinfo->raw_data[0]);
> +			data->version[0] = verinfo->raw_data[1];
> +			data->version[1] = verinfo->raw_data[0];
> +		}
> +		kfree(verinfo);
> +		verinfo = NULL;
> +	} else if (verinfo) {
> +		dev_err(&hdev->dev, "confused, got unexpected version response from PicoLCD after reset\n");
> +		kfree(verinfo);
> +		verinfo = NULL;
> +	} else {
> +		dev_err(&hdev->dev, "no version response from PicoLCD after reset");
> +		return -EBUSY;
> +	}
> +

I am pretty sure it could be written clearer instead of checking for
verinfo several times...

	if (!verinfo) {
		dev_err(..);
		return -EBUSY;
	}

	if (verinfo->raw_size == 2) {
		...
	} else {
		dev_err(...)
	}

	kfree(verinfo);

> +	return 0;
> +}
> +
> +/*
> + * The "operation_mode" sysfs attribute
> + */
> +static ssize_t picolcd_operation_mode_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct picolcd_data *data = dev_get_drvdata(dev);
> +
> +	if (data->status & PICOLCD_BOOTLOADER)
> +		return snprintf(buf, PAGE_SIZE, "<bootloader> lcd\n");
> +	else
> +		return snprintf(buf, PAGE_SIZE, "bootloader <lcd>\n");
> +}
> +
> +static ssize_t picolcd_operation_mode_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct picolcd_data *data = dev_get_drvdata(dev);
> +	struct hid_report *report = NULL;
> +	size_t cnt = count;
> +	int timeout = 5000;
> +	unsigned u;
> +	unsigned long flags;
> +
> +	if (cnt >= 3 && strncmp("lcd", buf, 3) == 0) {
> +		if (data->status & PICOLCD_BOOTLOADER)
> +			report = picolcd_out_report(REPORT_EXIT_FLASHER, data->hdev);
> +		buf += 3;
> +		cnt -= 3;
> +	} else if (cnt >= 10 && strncmp("bootloader", buf, 10) == 0) {
> +		if (!(data->status & PICOLCD_BOOTLOADER))
> +			report = picolcd_out_report(REPORT_EXIT_KEYBOARD, data->hdev);
> +		buf += 10;
> +		cnt -= 10;
> +	}
> +	if (!report)
> +		return -EINVAL;
> +
> +	while (cnt > 0 && (*buf == ' ' || *buf == '\t')) {
> +		buf++;
> +		cnt--;
> +	}
> +	while (cnt > 0 && (buf[cnt-1] == '\n' || buf[cnt-1] == '\r'))
> +		cnt--;
> +	if (cnt > 0) {
> +		if (sscanf(buf, "%u", &u) != 1)
> +			return -EINVAL;
> +		if (u > 30000)
> +			return -EINVAL;
> +		else
> +			timeout = u;
> +	}
> +
> +	spin_lock_irqsave(&data->lock, flags);
> +	hid_set_field(report->field[0], 0, timeout & 0xff);
> +	hid_set_field(report->field[0], 1, (timeout >> 8) & 0xff);
> +	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
> +	spin_unlock_irqrestore(&data->lock, flags);
> +	return count;
> +}
> +
> +static DEVICE_ATTR(operation_mode, 0644, picolcd_operation_mode_show,
> +		picolcd_operation_mode_store);
> +
> +
> +#ifdef CONFIG_DEBUG_FS
> +/*
> + * Helper code for HID report level dumping/debugging
> + */
> +static const char *error_codes[] = {
> +	"success", "parameter missing", "data_missing", "block readonly", "block not erasable",
> +	"block too big", "section overflow", "invalid command length", "invalid data length",
> +};
> +
> +static void dump_buff_as_hex(char *dst, size_t dst_sz, const u8 *data,
> +		const size_t data_len)
> +{
> +	int i, j;
> +	for (i = j = 0; i < data_len && j + 3 < dst_sz; i++) {
> +		dst[j++] = hex_asc[(data[i] >> 4) & 0x0f];
> +		dst[j++] = hex_asc[data[i] & 0x0f];
> +		dst[j++] = ' ';
> +	}
> +	if (j < dst_sz) {
> +		dst[j--] = '\0';
> +		dst[j] = '\n';
> +	} else
> +		dst[j] = '\0';
> +}
> +
> +static void picolcd_debug_out_report(struct picolcd_data *data,
> +		struct hid_device *hdev, struct hid_report *report)
> +{
> +	u8 raw_data[70];
> +	int raw_size = (report->size >> 3) + 1;
> +	char *buff;
> +#define BUFF_SZ 256
> +
> +	/* Avoid unnecessary overhead if debugfs is disabled */
> +	if (!hdev->debug_events)
> +		return;
> +
> +	buff = kmalloc(BUFF_SZ, GFP_ATOMIC);
> +	if (!buff)
> +		return;
> +
> +	snprintf(buff, BUFF_SZ, "\nout report %d (size %d) =  ",
> +			report->id, raw_size);
> +	hid_debug_event(hdev, buff);
> +	if (raw_size + 5 > sizeof(raw_data)) {
> +		hid_debug_event(hdev, " TOO BIG\n");
> +		return;
> +	} else {
> +		raw_data[0] = report->id;
> +		hid_output_report(report, raw_data);
> +		dump_buff_as_hex(buff, BUFF_SZ, raw_data, raw_size);
> +		hid_debug_event(hdev, buff);
> +	}
> +
> +	switch (report->id) {
> +	case REPORT_LED_STATE:
> +		/* 1 data byte with GPO state */
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_LED_STATE", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tGPO state: 0x%02x\n", raw_data[1]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_BRIGHTNESS:
> +		/* 1 data byte with brightness */
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_BRIGHTNESS", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tBrightness: 0x%02x\n", raw_data[1]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_CONTRAST:
> +		/* 1 data byte with contrast */
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_CONTRAST", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tContrast: 0x%02x\n", raw_data[1]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_RESET:
> +		/* 2 data bytes with reset duration in ms */
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_RESET", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tDuration: 0x%02x%02x (%dms)\n",
> +				raw_data[2], raw_data[1], raw_data[2] << 8 | raw_data[1]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_LCD_CMD:
> +		/* 63 data bytes with LCD commands */
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_LCD_CMD", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		/* TODO: format decoding */
> +		break;
> +	case REPORT_LCD_DATA:
> +		/* 63 data bytes with LCD data */
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_LCD_CMD", report->id, raw_size-1);
> +		/* TODO: format decoding */
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_LCD_CMD_DATA:
> +		/* 63 data bytes with LCD commands and data */
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_LCD_CMD", report->id, raw_size-1);
> +		/* TODO: format decoding */
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_EE_READ:
> +		/* 3 data bytes with read area description */
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_EE_READ", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tData address: 0x%02x%02x\n", raw_data[2], raw_data[1]);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tData length: %d\n", raw_data[3]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_EE_WRITE:
> +		/* 3+1..20 data bytes with write area description */
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_EE_WRITE", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tData address: 0x%02x%02x\n", raw_data[2], raw_data[1]);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tData length: %d\n", raw_data[3]);
> +		hid_debug_event(hdev, buff);
> +		if (raw_data[3] == 0) {
> +			snprintf(buff, BUFF_SZ, "\tNo data\n");
> +		} else if (raw_data[3] + 4 <= raw_size) {
> +			snprintf(buff, BUFF_SZ, "\tData: ");
> +			hid_debug_event(hdev, buff);
> +			dump_buff_as_hex(buff, BUFF_SZ, raw_data+4, raw_data[3]);
> +		} else {
> +			snprintf(buff, BUFF_SZ, "\tData overflowed\n");
> +		}
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_ERASE_MEMORY:
> +	case REPORT_BL_ERASE_MEMORY:
> +		/* 3 data bytes with pointer inside erase block */
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_ERASE_MEMORY", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		switch (data->addr_sz) {
> +		case 2:
> +			snprintf(buff, BUFF_SZ, "\tAddress inside 64 byte block: 0x%02x%02x\n",
> +					raw_data[2], raw_data[1]);
> +			break;
> +		case 3:
> +			snprintf(buff, BUFF_SZ, "\tAddress inside 64 byte block: 0x%02x%02x%02x\n",
> +					raw_data[3], raw_data[2], raw_data[1]);
> +			break;
> +		default:
> +			snprintf(buff, BUFF_SZ, "\tNot supported\n");
> +		}
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_READ_MEMORY:
> +	case REPORT_BL_READ_MEMORY:
> +		/* 4 data bytes with read area description */
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_READ_MEMORY", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		switch (data->addr_sz) {
> +		case 2:
> +			snprintf(buff, BUFF_SZ, "\tData address: 0x%02x%02x\n",
> +					raw_data[2], raw_data[1]);
> +			hid_debug_event(hdev, buff);
> +			snprintf(buff, BUFF_SZ, "\tData length: %d\n", raw_data[3]);
> +			break;
> +		case 3:
> +			snprintf(buff, BUFF_SZ, "\tData address: 0x%02x%02x%02x\n",
> +					raw_data[3], raw_data[2], raw_data[1]);
> +			hid_debug_event(hdev, buff);
> +			snprintf(buff, BUFF_SZ, "\tData length: %d\n", raw_data[4]);
> +			break;
> +		default:
> +			snprintf(buff, BUFF_SZ, "\tNot supported\n");
> +		}
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_WRITE_MEMORY:
> +	case REPORT_BL_WRITE_MEMORY:
> +		/* 4+1..32 data bytes with write adrea description */
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_WRITE_MEMORY", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		switch (data->addr_sz) {
> +		case 2:
> +			snprintf(buff, BUFF_SZ, "\tData address: 0x%02x%02x\n",
> +					raw_data[2], raw_data[1]);
> +			hid_debug_event(hdev, buff);
> +			snprintf(buff, BUFF_SZ, "\tData length: %d\n", raw_data[3]);
> +			hid_debug_event(hdev, buff);
> +			if (raw_data[3] == 0) {
> +				snprintf(buff, BUFF_SZ, "\tNo data\n");
> +			} else if (raw_data[3] + 4 <= raw_size) {
> +				snprintf(buff, BUFF_SZ, "\tData: ");
> +				hid_debug_event(hdev, buff);
> +				dump_buff_as_hex(buff, BUFF_SZ, raw_data+4, raw_data[3]);
> +			} else {
> +				snprintf(buff, BUFF_SZ, "\tData overflowed\n");
> +			}
> +			break;
> +		case 3:
> +			snprintf(buff, BUFF_SZ, "\tData address: 0x%02x%02x%02x\n",
> +					raw_data[3], raw_data[2], raw_data[1]);
> +			hid_debug_event(hdev, buff);
> +			snprintf(buff, BUFF_SZ, "\tData length: %d\n", raw_data[4]);
> +			hid_debug_event(hdev, buff);
> +			if (raw_data[4] == 0) {
> +				snprintf(buff, BUFF_SZ, "\tNo data\n");
> +			} else if (raw_data[4] + 5 <= raw_size) {
> +				snprintf(buff, BUFF_SZ, "\tData: ");
> +				hid_debug_event(hdev, buff);
> +				dump_buff_as_hex(buff, BUFF_SZ, raw_data+5, raw_data[4]);
> +			} else {
> +				snprintf(buff, BUFF_SZ, "\tData overflowed\n");
> +			}
> +			break;
> +		default:
> +			snprintf(buff, BUFF_SZ, "\tNot supported\n");
> +		}
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_SPLASH_RESTART:
> +		/* TODO */
> +		break;
> +	case REPORT_EXIT_KEYBOARD:
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_EXIT_KEYBOARD", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tRestart delay: %dms (0x%02x%02x)\n",
> +				raw_data[1] | (raw_data[2] << 8),
> +				raw_data[2], raw_data[1]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_VERSION:
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_VERSION", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_DEVID:
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_DEVID", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_SPLASH_SIZE:
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_SPLASH_SIZE", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_HOOK_VERSION:
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_HOOK_VERSION", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_EXIT_FLASHER:
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"REPORT_VERSION", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tRestart delay: %dms (0x%02x%02x)\n",
> +				raw_data[1] | (raw_data[2] << 8),
> +				raw_data[2], raw_data[1]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	default:
> +		snprintf(buff, BUFF_SZ, "out report %s (%d, size=%d)\n",
> +			"<unknown>", report->id, raw_size-1);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	}
> +	wake_up_interruptible(&hdev->debug_wait);
> +	kfree(buff);
> +}
> +
> +static inline void picolcd_debug_raw_event(struct picolcd_data *data,
> +		struct hid_device *hdev, struct hid_report *report,
> +		u8 *raw_data, int size)
> +{
> +	char *buff;
> +
> +#define BUFF_SZ 256
> +	/* Avoid unnecessary overhead if debugfs is disabled */
> +	if (!hdev->debug_events)
> +		return;
> +
> +	buff = kmalloc(BUFF_SZ, GFP_ATOMIC);
> +	if (!buff)
> +		return;
> +
> +	switch (report->id) {
> +	case REPORT_ERROR_CODE:
> +		/* 2 data bytes with affected report and error code */
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"REPORT_ERROR_CODE", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		if (raw_data[2] < ARRAY_SIZE(error_codes))
> +			snprintf(buff, BUFF_SZ, "\tError code 0x%02x (%s) in reply to report 0x%02x\n",
> +					raw_data[2], error_codes[raw_data[2]], raw_data[1]);
> +		else
> +			snprintf(buff, BUFF_SZ, "\tError code 0x%02x in reply to report 0x%02x\n",
> +					raw_data[2], raw_data[1]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_KEY_STATE:
> +		/* 2 data bytes with key state */
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"REPORT_KEY_STATE", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		if (raw_data[1] == 0)
> +			snprintf(buff, BUFF_SZ, "\tNo key pressed\n");
> +		else if (raw_data[2] == 0)
> +			snprintf(buff, BUFF_SZ, "\tOne key pressed: 0x%02x (%d)\n",
> +					raw_data[1], raw_data[1]);
> +		else
> +			snprintf(buff, BUFF_SZ, "\tTwo keys pressed: 0x%02x (%d), 0x%02x (%d)\n",
> +					raw_data[1], raw_data[1], raw_data[2], raw_data[2]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_IR_DATA:
> +		/* Up to 20 byes of IR scancode data */
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"REPORT_IR_DATA", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		if (raw_data[1] == 0) {
> +			snprintf(buff, BUFF_SZ, "\tUnexpectedly 0 data length\n");
> +			hid_debug_event(hdev, buff);
> +		} else if (raw_data[1] + 1 <= size) {
> +			snprintf(buff, BUFF_SZ, "\tData length: %d\n\tIR Data: ",
> +					raw_data[1]-1);
> +			hid_debug_event(hdev, buff);
> +			dump_buff_as_hex(buff, BUFF_SZ, raw_data+2, raw_data[1]-1);
> +			hid_debug_event(hdev, buff);
> +		} else {
> +			snprintf(buff, BUFF_SZ, "\tOverflowing data length: %d\n",
> +					raw_data[1]-1);
> +			hid_debug_event(hdev, buff);
> +		}
> +		break;
> +	case REPORT_EE_DATA:
> +		/* Data buffer in response to REPORT_EE_READ or REPORT_EE_WRITE */
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"REPORT_EE_DATA", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tData address: 0x%02x%02x\n", raw_data[2], raw_data[1]);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tData length: %d\n", raw_data[3]);
> +		hid_debug_event(hdev, buff);
> +		if (raw_data[3] == 0) {
> +			snprintf(buff, BUFF_SZ, "\tNo data\n");
> +			hid_debug_event(hdev, buff);
> +		} else if (raw_data[3] + 4 <= size) {
> +			snprintf(buff, BUFF_SZ, "\tData: ");
> +			hid_debug_event(hdev, buff);
> +			dump_buff_as_hex(buff, BUFF_SZ, raw_data+4, raw_data[3]);
> +			hid_debug_event(hdev, buff);
> +		} else {
> +			snprintf(buff, BUFF_SZ, "\tData overflowed\n");
> +			hid_debug_event(hdev, buff);
> +		}
> +		break;
> +	case REPORT_MEMORY:
> +		/* Data buffer in response to REPORT_READ_MEMORY or REPORT_WRTIE_MEMORY */
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"REPORT_MEMORY", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		switch (data->addr_sz) {
> +		case 2:
> +			snprintf(buff, BUFF_SZ, "\tData address: 0x%02x%02x\n",
> +					raw_data[2], raw_data[1]);
> +			hid_debug_event(hdev, buff);
> +			snprintf(buff, BUFF_SZ, "\tData length: %d\n", raw_data[3]);
> +			hid_debug_event(hdev, buff);
> +			if (raw_data[3] == 0) {
> +				snprintf(buff, BUFF_SZ, "\tNo data\n");
> +			} else if (raw_data[3] + 4 <= size) {
> +				snprintf(buff, BUFF_SZ, "\tData: ");
> +				hid_debug_event(hdev, buff);
> +				dump_buff_as_hex(buff, BUFF_SZ, raw_data+4, raw_data[3]);
> +			} else {
> +				snprintf(buff, BUFF_SZ, "\tData overflowed\n");
> +			}
> +			break;
> +		case 3:
> +			snprintf(buff, BUFF_SZ, "\tData address: 0x%02x%02x%02x\n",
> +					raw_data[3], raw_data[2], raw_data[1]);
> +			hid_debug_event(hdev, buff);
> +			snprintf(buff, BUFF_SZ, "\tData length: %d\n", raw_data[4]);
> +			hid_debug_event(hdev, buff);
> +			if (raw_data[4] == 0) {
> +				snprintf(buff, BUFF_SZ, "\tNo data\n");
> +			} else if (raw_data[4] + 5 <= size) {
> +				snprintf(buff, BUFF_SZ, "\tData: ");
> +				hid_debug_event(hdev, buff);
> +				dump_buff_as_hex(buff, BUFF_SZ, raw_data+5, raw_data[4]);
> +			} else {
> +				snprintf(buff, BUFF_SZ, "\tData overflowed\n");
> +			}
> +			break;
> +		default:
> +			snprintf(buff, BUFF_SZ, "\tNot supported\n");
> +		}
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_VERSION:
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"REPORT_VERSION", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tFirmware version: %d.%d\n",
> +				raw_data[2], raw_data[1]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_BL_ERASE_MEMORY:
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"REPORT_BL_ERASE_MEMORY", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		/* TODO */
> +		break;
> +	case REPORT_BL_READ_MEMORY:
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"REPORT_BL_READ_MEMORY", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		/* TODO */
> +		break;
> +	case REPORT_BL_WRITE_MEMORY:
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"REPORT_BL_WRITE_MEMORY", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		/* TODO */
> +		break;
> +	case REPORT_DEVID:
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"REPORT_DEVID", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tSerial: 0x%02x%02x%02x%02x\n",
> +				raw_data[1], raw_data[2], raw_data[3], raw_data[4]);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tType: 0x%02x\n",
> +				raw_data[5]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_SPLASH_SIZE:
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"REPORT_SPLASH_SIZE", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tTotal splash space: %d\n",
> +				(raw_data[2] << 8) | raw_data[1]);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tUsed splash space: %d\n",
> +				(raw_data[4] << 8) | raw_data[3]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	case REPORT_HOOK_VERSION:
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"REPORT_HOOK_VERSION", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		snprintf(buff, BUFF_SZ, "\tFirmware version: %d.%d\n",
> +				raw_data[1], raw_data[2]);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	default:
> +		snprintf(buff, BUFF_SZ, "report %s (%d, size=%d)\n",
> +			"<unknown>", report->id, size-1);
> +		hid_debug_event(hdev, buff);
> +		break;
> +	}
> +	wake_up_interruptible(&hdev->debug_wait);
> +	kfree(buff);
> +}
> +#else
> +#define picolcd_debug_raw_event(data, hdev, report, raw_data, size)
> +#endif
> +
> +/*
> + * Handle raw report as sent by device
> + */
> +static int picolcd_raw_event(struct hid_device *hdev,
> +		struct hid_report *report, u8 *raw_data, int size)
> +{
> +	struct picolcd_data *data = hid_get_drvdata(hdev);
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	if (data == NULL)
> +		return 1;
> +
> +	if (report->id == REPORT_KEY_STATE) {
> +		if (data->input_keys)
> +			ret = picolcd_raw_keypad(hdev, report, raw_data+1, size-1);
> +	} else if (report->id == REPORT_IR_DATA) {
> +		if (data->input_cir)
> +			ret = picolcd_raw_cir(hdev, report, raw_data+1, size-1);
> +	} else {
> +		spin_lock_irqsave(&data->lock, flags);
> +		/*
> +		 * We let the caller of picolcd_send_and_wait() check if the report
> +		 * we got is one of the expected ones or not.
> +		 */
> +		if (data->pending) {
> +			memcpy(data->pending->raw_data, raw_data+1, size-1);
> +			data->pending->raw_size  = size-1;
> +			data->pending->in_report = report;
> +			complete_all(&data->ready);
> +		}
> +		spin_unlock_irqrestore(&data->lock, flags);
> +	}
> +
> +	picolcd_debug_raw_event(data, hdev, report, raw_data, size);
> +	return 1;
> +}
> +
> +#ifdef CONFIG_PM
> +static int picolcd_suspend(struct hid_device *hdev)
> +{
> +	dbg_hid(PICOLCD_NAME " device ready for suspend\n");
> +	return 0;
> +}
> +
> +static int picolcd_resume(struct hid_device *hdev)
> +{
> +	return 0;
> +}
> +
> +static int picolcd_reset_resume(struct hid_device *hdev)
> +{
> +	int ret;
> +	ret = picolcd_reset(hdev);
> +	if (ret)
> +		dbg_hid(PICOLCD_NAME " resetting our device failed: %d\n", ret);
> +	return 0;
> +}
> +#endif
> +
> +/* initialize keypad input device */
> +static inline int picolcd_init_keys(struct picolcd_data *data,
> +		struct hid_report *report)
> +{
> +	struct hid_device *hdev = data->hdev;
> +	struct input_dev *idev;
> +	int error, i;
> +
> +	if (!report)
> +		return -ENODEV;
> +	if (report->maxfield != 1 || report->field[0]->report_count != 2 ||
> +			report->field[0]->report_size != 8) {
> +		dev_err(&hdev->dev, "unsupported KEY_STATE report");
> +		return -EINVAL;
> +	}
> +
> +	idev = input_allocate_device();
> +	if (idev == NULL) {
> +		dev_err(&hdev->dev, "failed to allocate input device");
> +		return -ENOMEM;
> +	}
> +	input_set_drvdata(idev, hdev);
> +	memcpy(data->keycode, def_keymap, sizeof(def_keymap));
> +	idev->name = hdev->name;
> +	idev->phys = hdev->phys;
> +	idev->uniq = hdev->uniq;
> +	idev->id.bustype = hdev->bus;
> +	idev->id.vendor  = hdev->vendor;
> +	idev->id.product = hdev->product;
> +	idev->id.version = hdev->version;
> +	idev->dev.parent = hdev->dev.parent;
> +	idev->keycode     = &data->keycode;
> +	idev->keycodemax  = PICOLCD_KEYS;
> +	idev->keycodesize = sizeof(int);
> +	input_set_capability(idev, EV_MSC, MSC_SCAN);
> +	set_bit(EV_REP, idev->evbit);
> +	for (i = 0; i < PICOLCD_KEYS; i++) {
> +		int key = ((int *)idev->keycode)[i];
> +		if (key < KEY_MAX && key >= 0)
> +			input_set_capability(idev, EV_KEY, key);
> +	}
> +	error = input_register_device(idev);
> +	if (error) {
> +		dev_err(&hdev->dev, "error registering the input device");
> +		input_free_device(idev);
> +		return error;
> +	}
> +	data->input_keys = idev;
> +	return 0;
> +}
> +
> +static void picolcd_exit_keys(struct picolcd_data *data)
> +{
> +	struct input_dev *idev = data->input_keys;
> +
> +	data->input_keys = NULL;
> +	if (idev)
> +		input_unregister_device(idev);
> +}
> +
> +/* initialize CIR input device */
> +static inline int picolcd_init_cir(struct picolcd_data *data, struct hid_report *report)
> +{
> +	/* support not implemented yet */
> +	return 0;
> +}
> +
> +static void picolcd_exit_cir(struct picolcd_data *data)
> +{
> +}
> +
> +static inline int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data *data)
> +{
> +	struct picolcd_pending *verinfo;
> +	struct hid_report *report;
> +	int error;
> +
> +	verinfo = picolcd_send_and_wait(hdev, REPORT_VERSION, NULL, 0);
> +	if (!verinfo || !verinfo->in_report) {
> +		kfree(verinfo);
> +		dev_err(&hdev->dev, "failed to query FW version of device\n");
> +		return -ENODEV;
> +	} else if (verinfo->in_report->id == REPORT_VERSION && verinfo->raw_size == 2) {
> +		dev_info(&hdev->dev, "detected PicoLCD with firmware version %d.%d\n",
> +				verinfo->raw_data[0], verinfo->raw_data[1]);
> +		data->version[0] = verinfo->raw_data[1];
> +		data->version[1] = verinfo->raw_data[0];
> +		if (data->version[0] != 0 && data->version[1] != 3)
> +			dev_info(&hdev->dev, "Device with untested firmware revision, "
> +				"please submit /sys/kernel/debug/hid/%s/rdesc for this device.\n",
> +				dev_name(&hdev->dev));
> +		kfree(verinfo);
> +		verinfo = NULL;
> +	} else {
> +		dev_err(&hdev->dev, "unexpected version response from PicoLCD"
> +				" (report=0x%02x, size=%d)\n",
> +				verinfo->in_report->id, verinfo->raw_size);
> +		kfree(verinfo);
> +		verinfo = NULL;
> +		return -ENODEV;
> +	}


Please consolidate freeing of acquired resources.

> +
> +	/* Setup keypad input device */
> +	error = picolcd_init_keys(data, picolcd_in_report(REPORT_KEY_STATE, hdev));
> +	if (error)
> +		goto err;
> +
> +	/* Setup CIR input device */
> +	error = picolcd_init_cir(data, picolcd_in_report(REPORT_IR_DATA, hdev));
> +	if (error)
> +		goto err;
> +
> +#ifdef CONFIG_DEBUG_FS
> +	report = picolcd_out_report(REPORT_READ_MEMORY, hdev);
> +	if (report && report->maxfield == 1 && report->field[0]->report_size == 8)
> +		data->addr_sz = report->field[0]->report_count - 1;
> +	else
> +		data->addr_sz = -1;
> +#endif
> +	return 0;
> +err:
> +	picolcd_exit_cir(data);
> +	picolcd_exit_keys(data);
> +	return error;
> +}
> +
> +static inline int picolcd_probe_bootloader(struct hid_device *hdev, struct picolcd_data *data)
> +{
> +	struct picolcd_pending *verinfo;
> +	struct hid_report *report;
> +
> +	verinfo = picolcd_send_and_wait(hdev, REPORT_VERSION, NULL, 0);
> +	if (!verinfo || !verinfo->in_report) {
> +		kfree(verinfo);
> +		dev_err(&hdev->dev, "failed to query FW version of device\n");
> +		return -ENODEV;
> +	} else if (verinfo->in_report->id == REPORT_VERSION && verinfo->raw_size == 2) {
> +		dev_info(&hdev->dev, "detected PicoLCD with bootloader version %d.%d\n",
> +				verinfo->raw_data[1], verinfo->raw_data[0]);
> +		data->version[0] = verinfo->raw_data[1];
> +		data->version[1] = verinfo->raw_data[0];
> +		if (data->version[0] != 1 && data->version[1] != 0)
> +			dev_info(&hdev->dev, "Device with untested bootloader revision, "
> +				"please submit /sys/kernel/debug/hid/%s/rdesc for this device.\n",
> +				dev_name(&hdev->dev));
> +		kfree(verinfo);
> +		verinfo = NULL;
> +	} else {
> +		dev_err(&hdev->dev, "unexpected version response from PicoLCD"
> +				" (report=0x%02x, size=%d)\n",
> +				verinfo->in_report->id, verinfo->raw_size);
> +		kfree(verinfo);
> +		verinfo = NULL;
> +		return -ENODEV;
> +	}
> 

Please consolidate freeing of acquired resources. Wait, I just saw
afucntion like that... can we combine them somehow?

+
> +#ifdef CONFIG_DEBUG_FS
> +	report = picolcd_out_report(REPORT_BL_READ_MEMORY, hdev);
> +	if (report && report->maxfield == 1 && report->field[0]->report_size == 8)
> +		data->addr_sz = report->field[0]->report_count - 1;
> +	else
> +		data->addr_sz = -1;
> +#endif
> +	return 0;
> +}
> +
> +static int picolcd_probe(struct hid_device *hdev,
> +		     const struct hid_device_id *id)
> +{
> +	struct picolcd_data *data;
> +	int error = -ENOMEM;
> +
> +	dbg_hid(PICOLCD_NAME " hardware probe...\n");
> +
> +	/*
> +	 * Let's allocate the picolcd data structure, set some reasonable
> +	 * defaults, and associate it with the device
> +	 */
> +	data = kzalloc(sizeof(struct picolcd_data), GFP_KERNEL);
> +	if (data == NULL) {
> +		dev_err(&hdev->dev, "can't allocate space for Minibox PicoLCD device data\n");
> +		error = -ENOMEM;
> +		goto err_no_cleanup;
> +	}
> +
> +	spin_lock_init(&data->lock);
> +	init_completion(&data->ready);
> +	data->hdev = hdev;
> +	if (hdev->product == USB_DEVICE_ID_PICOLCD_BOOTLOADER)
> +		data->status |= PICOLCD_BOOTLOADER;
> +	hid_set_drvdata(hdev, data);
> +
> +	/* Parse the device reports and start it up */
> +	error = hid_parse(hdev);
> +	if (error) {
> +		dev_err(&hdev->dev, "device report parse failed\n");
> +		goto err_cleanup_data;
> +	}
> +
> +	/* We don't use hidinput but hid_hw_start() fails if nothing is
> +	 * claimed. So spoof claimed input. */
> +	hdev->claimed = HID_CLAIMED_INPUT;
> +	error = hid_hw_start(hdev, 0);
> +	hdev->claimed = 0;
> +	if (error) {
> +		dev_err(&hdev->dev, "hardware start failed\n");
> +		goto err_cleanup_data;
> +	}
> +
> +	error = hdev->ll_driver->open(hdev);
> +	if (error) {
> +		dev_err(&hdev->dev, "failed to open input interrupt pipe for key and IR events\n");
> +		goto err_cleanup_hid_hw;
> +	}
> +
> +	error = sysfs_create_file(&(hdev->dev.kobj), &dev_attr_operation_mode.attr);

device_create_file?

> +	if (error) {
> +		dev_err(&hdev->dev, "failed to create sysfs attributes\n");
> +		goto err_cleanup_hid_ll;
> +	}
> +
> +	if (data->status & PICOLCD_BOOTLOADER)
> +		error = picolcd_probe_bootloader(hdev, data);
> +	else
> +		error = picolcd_probe_lcd(hdev, data);
> +	if (error)
> +		goto err_cleanup_sysfs;
> +
> +	dbg_hid(PICOLCD_NAME " activated and initialized\n");
> +	return 0;
> +
> +err_cleanup_sysfs:
> +	sysfs_remove_file(&(hdev->dev.kobj), &dev_attr_operation_mode.attr);
> +err_cleanup_hid_ll:
> +	hdev->ll_driver->close(hdev);
> +err_cleanup_hid_hw:
> +	hid_hw_stop(hdev);
> +err_cleanup_data:
> +	kfree(data);
> +err_no_cleanup:
> +	hid_set_drvdata(hdev, NULL);
> +
> +	return error;
> +}
> +
> +static void picolcd_remove(struct hid_device *hdev)
> +{
> +	struct picolcd_data *data = hid_get_drvdata(hdev);
> +	unsigned long flags;
> +
> +	dbg_hid(PICOLCD_NAME " hardware remove...\n");
> +	spin_lock_irqsave(&data->lock, flags);
> +	data->status |= PICOLCD_FAILED;
> +	spin_unlock_irqrestore(&data->lock, flags);
> +
> +	sysfs_remove_file(&(hdev->dev.kobj), &dev_attr_operation_mode.attr);
> +	hdev->ll_driver->close(hdev);
> +	hid_hw_stop(hdev);
> +
> +	/* Cleanup input */
> +	picolcd_exit_cir(data);
> +	picolcd_exit_keys(data);
> +
> +	/* Finally, clean up the picolcd data itself */
> +	kfree(data);
> +}
> +
> +static const struct hid_device_id picolcd_devices[] = {
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICOLCD) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICOLCD_BOOTLOADER) },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(hid, picolcd_devices);
> +
> +static struct hid_driver picolcd_driver = {
> +	.name =          "hid-picolcd",
> +	.id_table =      picolcd_devices,
> +	.probe =         picolcd_probe,
> +	.remove =        picolcd_remove,
> +	.raw_event =     picolcd_raw_event,
> +#ifdef CONFIG_PM
> +	.suspend =       picolcd_suspend,
> +	.resume =        picolcd_resume,
> +	.reset_resume =  picolcd_reset_resume,
> +#endif
> +};
> +
> +static int __init picolcd_init(void)
> +{
> +	return hid_register_driver(&picolcd_driver);
> +}
> +
> +static void __exit picolcd_exit(void)
> +{
> +	hid_unregister_driver(&picolcd_driver);
> +}
> +
> +module_init(picolcd_init);
> +module_exit(picolcd_exit);
> +MODULE_DESCRIPTION("Minibox graphics PicoLCD Driver");
> +MODULE_LICENSE("GPL v2");
> -- 
> 1.6.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Dmitry
