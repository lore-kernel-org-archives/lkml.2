Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0CUQiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 12:38:23 -0400
Received: from legolas.restena.lu ([158.64.1.34]:60439 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab0CUQiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 12:38:20 -0400
Date: Sun, 21 Mar 2010 17:37:37 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v2 1/6] hid: new driver for PicoLCD device
Message-ID: <20100321173737.5fcf3580@neptune.home>
In-Reply-To: <20100321034600.GE29360@core.coreip.homeip.net>
References: <20100320170014.440959a8@neptune.home>
	<20100320170241.55258b0d@neptune.home>
	<20100321034600.GE29360@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 March 2010 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Sat, Mar 20, 2010 at 05:02:41PM +0100, Bruno Prémont wrote:
> > +/* Input device
> > + *
> > + * The PicoLCD has an IR receiver header, a built-in keypad with 5 keys
> > + * and header for 4x4 key matrix. The built-in keys are part of the matrix.
> > + */
> > +#define PICOLCD_KEYS 17
> > +
> > +static const int def_keymap[PICOLCD_KEYS] = {
> 
> def_keymap[] = {
> ...
> };
> #define PICOLCD_KEYS ARRAY_SIZE(def_keymap);
> 
> would be safe.  Also unsigned short should cover it.

Ok

> > +	KEY_RESERVED,	/* none */
> > +	KEY_BACK,	/* col 4 + row 1 */
> > +	KEY_HOMEPAGE,	/* col 3 + row 1 */
> > +	KEY_RESERVED,	/* col 2 + row 1 */
> > +	KEY_RESERVED,	/* col 1 + row 1 */
> > +	KEY_SCROLLUP,	/* col 4 + row 2 */
> > +	KEY_OK,		/* col 3 + row 2 */
> > +	KEY_SCROLLDOWN,	/* col 2 + row 2 */
> > +	KEY_RESERVED,	/* col 1 + row 2 */
> > +	KEY_RESERVED,	/* col 4 + row 3 */
> > +	KEY_RESERVED,	/* col 3 + row 3 */
> > +	KEY_RESERVED,	/* col 2 + row 3 */
> > +	KEY_RESERVED,	/* col 1 + row 3 */
> > +	KEY_RESERVED,	/* col 4 + row 4 */
> > +	KEY_RESERVED,	/* col 3 + row 4 */
> > +	KEY_RESERVED,	/* col 2 + row 4 */
> > +	KEY_RESERVED,	/* col 1 + row 4 */
> > +};
> > +
> > +/* Description of in-progress IO operation, used for operations
> > + * that trigger response from device */
> > +struct picolcd_pending {
> > +	struct hid_report *out_report;
> > +	struct hid_report *in_report;
> > +	int raw_size;
> > +	u8 raw_data[64];
> > +};
> > +
> > +/* Per device data structure */
> > +struct picolcd_data {
> > +	struct hid_device *hdev;
> > +#ifdef CONFIG_DEBUG_FS
> > +	int addr_sz;
> > +#endif
> > +	u8 version[2];
> > +	/* input stuff */
> > +	u8 pressed_keys[2];
> > +	struct input_dev *input_keys;
> > +	struct input_dev *input_cir;
> > +	int keycode[PICOLCD_KEYS];
> > +
> > +	/* Housekeeping stuff */
> > +	spinlock_t lock;
> > +	struct picolcd_pending *pending;
> > +	struct completion ready;
> > +	int status;
> > +#define PICOLCD_BUSY 1
> > +#define PICOLCD_FAILED 4
> > +#define PICOLCD_BOOTLOADER 8
> > +};
> > +
> > +
> > +/* Find a given report */
> > +#define picolcd_in_report(id, dev) picolcd_report(id, dev, HID_INPUT_REPORT)
> > +#define picolcd_out_report(id, dev) picolcd_report(id, dev, HID_OUTPUT_REPORT)
> > +
> > +static struct hid_report *picolcd_report(int id, struct hid_device *hdev, int dir)
> > +{
> > +	struct list_head *feature_report_list = &hdev->report_enum[dir].report_list;
> > +	struct hid_report *report = NULL;
> > +
> > +	list_for_each_entry(report, feature_report_list, list) {
> > +		if (report->id == id)
> > +			return report;
> > +	}
> > +	dev_warn(&hdev->dev, "No report with id 0x%x found\n", id);
> > +	return NULL;
> > +}
> > +
> > +#ifdef CONFIG_DEBUG_FS
> > +static void picolcd_debug_out_report(struct picolcd_data *data,
> > +		struct hid_device *hdev, struct hid_report *report);
> > +#define usbhid_submit_report(a, b, c) \
> > +	picolcd_debug_out_report(hid_get_drvdata(a), a, b); \
> > +	usbhid_submit_report(a, b, c)
> > +#endif
> > +
> > +/* Submit a report and wait for a reply from device - if device fades away
> > + * or does not respond in time, return NULL */
> > +static struct picolcd_pending* picolcd_send_and_wait(struct hid_device *hdev,
> > +		int report_id, const u8 *raw_data, int size)
> > +{
> > +	struct picolcd_data *data = hid_get_drvdata(hdev);
> > +	struct picolcd_pending *work;
> > +	struct hid_report *report = picolcd_out_report(report_id, hdev);
> > +	unsigned long flags;
> > +	int status, i, j, k;
> > +
> > +	if (!report)
> > +		return NULL;
> > +	work = kzalloc(sizeof(*work), GFP_KERNEL);
> > +	if (!work)
> > +		return NULL;
> > +
> > +	work->out_report = report;
> > +	work->in_report  = NULL;
> > +	work->raw_size   = 0;
> > +
> > +retry:
> > +	/* try to get lock and enqueue our job */
> > +	spin_lock_irqsave(&data->lock, flags);
> > +	status = data->status;
> > +	if (data->pending || (status & PICOLCD_FAILED)) {
> > +		/* some job already pending,
> > +		 * wait for it to complete and try again */
> > +		spin_unlock_irqrestore(&data->lock, flags);
> > +		if (status & PICOLCD_FAILED) {
> > +			kfree(work);
> > +			return NULL;
> > +		}
> > +		wait_for_completion_interruptible_timeout(&data->ready, HZ*2);
> > +		goto retry;
> 
> Umm, can we do this with a mutex? Like you take a mutex and don't
> release till you are done talking to the device. So that other guy will
> wait on the mutex instead of waking up and rechecking condition.
> 
> > +	}
> > +	data->status |= PICOLCD_BUSY;
> > +	data->pending = work;
> > +	for (i = k = 0; i < report->maxfield; i++)
> > +		for (j = 0; j < report->field[i]->report_count; j++) {
> > +			hid_set_field(report->field[i], j, k < size ? raw_data[k] : 0);
> > +			k++;
> > +		}
> > +	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
> > +	complete_all(&data->ready);
> > +	INIT_COMPLETION(data->ready);
> 
> Umm, what does this do, exactly?

It wakes up anyone waiting on the completion and then resets the completion
as otherwise any future attempt to wait on it would succeed immediately.

The complete_all() instead of just complete() comes from the reset() function.
I can probably reduce it here.

Will check this combined with your mutex suggestion above.

> > +	spin_unlock_irqrestore(&data->lock, flags);
> > +	/* wait for our job to complete */
> > +	wait_for_completion_interruptible_timeout(&data->ready, HZ*2);
> > +
> > +	spin_lock_irqsave(&data->lock, flags);
> > +	if (data->pending == work) {
> > +		data->status  &= ~PICOLCD_BUSY;
> > +		data->pending = NULL;
> > +		complete_all(&data->ready);
> > +		spin_unlock_irqrestore(&data->lock, flags);
> > +		return work;
> > +	} else {
> > +		spin_unlock_irqrestore(&data->lock, flags);
> > +		kfree(work);
> > +		return NULL;
> > +	}
> > +}
> > +
> > +/*
> > + * input class device
> > + */
> > +static int picolcd_raw_keypad(struct hid_device *hdev,
> > +		struct hid_report *report, u8 *raw_data, int size)
> > +{
> > +	/*
> > +	 * Keypad event
> > +	 * First and second data bytes list currently pressed keys,
> > +	 * 0x00 means no key and at most 2 keys may be pressed at same time
> > +	 */
> > +	struct picolcd_data *data = hid_get_drvdata(hdev);
> > +	int i, j;
> > +
> > +	/* determine newly pressed keys */
> > +	for (i = 0; i < size; i++) {
> > +		int key_code;
> > +		if (raw_data[i] == 0)
> > +			continue;
> > +		for (j = 0; j < sizeof(data->pressed_keys); j++)
> > +			if (data->pressed_keys[j] == raw_data[i])
> > +				goto key_already_down;
> > +		for (j = 0; j < sizeof(data->pressed_keys); j++)
> > +			if (data->pressed_keys[j] == 0) {
> > +				data->pressed_keys[j] = raw_data[i];
> > +				break;
> > +			}
> > +		input_event(data->input_keys, EV_MSC, MSC_SCAN, raw_data[i]);
> > +		if (input_get_keycode(data->input_keys, raw_data[i], &key_code))
> > +			key_code = KEY_UNKNOWN;
> 
> Just get keycode directly from the driver's table, no need to jump through hoops
> here,

Ok

> > +		if (key_code != KEY_UNKNOWN) {
> > +			dbg_hid(PICOLCD_NAME " got key press for %u:%d", raw_data[i], key_code);
> > +			input_report_key(data->input_keys, key_code, 1);
> > +		}
> > +		input_sync(data->input_keys);
> > +key_already_down:
> > +		continue;
> > +	}
> > +
> > +	/* determine newly released keys */
> > +	for (j = 0; j < sizeof(data->pressed_keys); j++) {
> > +		int key_code;
> > +		if (data->pressed_keys[j] == 0)
> > +			continue;
> > +		for (i = 0; i < size; i++)
> > +			if (data->pressed_keys[j] == raw_data[i])
> > +				goto key_still_down;
> > +		input_event(data->input_keys, EV_MSC, MSC_SCAN, data->pressed_keys[j]);
> > +		if (input_get_keycode(data->input_keys, data->pressed_keys[j], &key_code))
> > +			key_code = KEY_UNKNOWN;
> > +		if (key_code != KEY_UNKNOWN) {
> > +			dbg_hid(PICOLCD_NAME " got key release for %u:%d", data->pressed_keys[j], key_code);
> > +			input_report_key(data->input_keys, key_code, 0);
> > +		}
> > +		input_sync(data->input_keys);
> > +		data->pressed_keys[j] = 0;
> > +key_still_down:
> > +		continue;
> > +	}
> > +	return 1;
> > +}
> > +
> > +static int picolcd_raw_cir(struct hid_device *hdev,
> > +		struct hid_report *report, u8 *raw_data, int size)
> > +{
> > +	/* Need understanding of CIR data format to implement ... */
> > +	return 1;
> > +}
> > +
> > +
> > +
> > +/*
> > + * Reset our device and wait for answer to VERSION request
> > + */
> > +static int picolcd_reset(struct hid_device *hdev)
> > +{
> > +	struct picolcd_data *data = hid_get_drvdata(hdev);
> > +	struct hid_report *report = picolcd_out_report(REPORT_RESET, hdev);
> > +	struct picolcd_pending *verinfo;
> > +	unsigned long flags;
> > +
> > +	if (!data || !report || report->maxfield != 1)
> > +		return -ENODEV;
> > +
> > +	spin_lock_irqsave(&data->lock, flags);
> > +	complete_all(&data->ready);
> > +	INIT_COMPLETION(data->ready);
> > +	if (hdev->product == USB_DEVICE_ID_PICOLCD_BOOTLOADER)
> > +		data->status |= PICOLCD_BOOTLOADER;
> > +
> > +	/* perform the reset */
> > +	hid_set_field(report->field[0], 0, 1);
> > +	usbhid_submit_report(hdev, report, USB_DIR_OUT);
> > +	spin_unlock_irqrestore(&data->lock, flags);
> > +
> > +	verinfo = picolcd_send_and_wait(hdev, REPORT_VERSION, NULL, 0);
> > +	if (verinfo && verinfo->raw_size == 2) {
> > +		if (data->status & PICOLCD_BOOTLOADER) {
> > +			dev_info(&hdev->dev, "PicoLCD reset successful, bootloader version %d.%d\n",
> > +					verinfo->raw_data[0], verinfo->raw_data[1]);
> > +			data->version[0] = verinfo->raw_data[0];
> > +			data->version[1] = verinfo->raw_data[1];
> > +		} else {
> > +			dev_info(&hdev->dev, "PicoLCD reset successful, firmware version %d.%d\n",
> > +					verinfo->raw_data[1], verinfo->raw_data[0]);
> > +			data->version[0] = verinfo->raw_data[1];
> > +			data->version[1] = verinfo->raw_data[0];
> > +		}
> > +		kfree(verinfo);
> > +		verinfo = NULL;
> > +	} else if (verinfo) {
> > +		dev_err(&hdev->dev, "confused, got unexpected version response from PicoLCD after reset\n");
> > +		kfree(verinfo);
> > +		verinfo = NULL;
> > +	} else {
> > +		dev_err(&hdev->dev, "no version response from PicoLCD after reset");
> > +		return -EBUSY;
> > +	}
> > +
> 
> I am pretty sure it could be written clearer instead of checking for
> verinfo several times...
> 
> 	if (!verinfo) {
> 		dev_err(..);
> 		return -EBUSY;
> 	}
> 
> 	if (verinfo->raw_size == 2) {
> 		...
> 	} else {
> 		dev_err(...)
> 	}
> 
> 	kfree(verinfo);

See below

> > +	return 0;
> > +}
> > +
> > +/*
> > + * The "operation_mode" sysfs attribute
> > + */
> > +static ssize_t picolcd_operation_mode_show(struct device *dev,
> > +		struct device_attribute *attr, char *buf)
> > +{
> > +	struct picolcd_data *data = dev_get_drvdata(dev);
> > +
> > +	if (data->status & PICOLCD_BOOTLOADER)
> > +		return snprintf(buf, PAGE_SIZE, "<bootloader> lcd\n");
> > +	else
> > +		return snprintf(buf, PAGE_SIZE, "bootloader <lcd>\n");
> > +}
> > +
> > +static ssize_t picolcd_operation_mode_store(struct device *dev,
> > +		struct device_attribute *attr, const char *buf, size_t count)
> > +{
> > +	struct picolcd_data *data = dev_get_drvdata(dev);
> > +	struct hid_report *report = NULL;
> > +	size_t cnt = count;
> > +	int timeout = 5000;
> > +	unsigned u;
> > +	unsigned long flags;
> > +
> > +	if (cnt >= 3 && strncmp("lcd", buf, 3) == 0) {
> > +		if (data->status & PICOLCD_BOOTLOADER)
> > +			report = picolcd_out_report(REPORT_EXIT_FLASHER, data->hdev);
> > +		buf += 3;
> > +		cnt -= 3;
> > +	} else if (cnt >= 10 && strncmp("bootloader", buf, 10) == 0) {
> > +		if (!(data->status & PICOLCD_BOOTLOADER))
> > +			report = picolcd_out_report(REPORT_EXIT_KEYBOARD, data->hdev);
> > +		buf += 10;
> > +		cnt -= 10;
> > +	}
> > +	if (!report)
> > +		return -EINVAL;
> > +
> > +	while (cnt > 0 && (*buf == ' ' || *buf == '\t')) {
> > +		buf++;
> > +		cnt--;
> > +	}
> > +	while (cnt > 0 && (buf[cnt-1] == '\n' || buf[cnt-1] == '\r'))
> > +		cnt--;
> > +	if (cnt > 0) {
> > +		if (sscanf(buf, "%u", &u) != 1)
> > +			return -EINVAL;
> > +		if (u > 30000)
> > +			return -EINVAL;
> > +		else
> > +			timeout = u;
> > +	}
> > +
> > +	spin_lock_irqsave(&data->lock, flags);
> > +	hid_set_field(report->field[0], 0, timeout & 0xff);
> > +	hid_set_field(report->field[0], 1, (timeout >> 8) & 0xff);
> > +	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
> > +	spin_unlock_irqrestore(&data->lock, flags);
> > +	return count;
> > +}
> > +
> > +static DEVICE_ATTR(operation_mode, 0644, picolcd_operation_mode_show,
> > +		picolcd_operation_mode_store);
> > +
> > +
> > +#ifdef CONFIG_DEBUG_FS

... snip reports dumping to debugfs's events ...

> > +#else
> > +#define picolcd_debug_raw_event(data, hdev, report, raw_data, size)
> > +#endif
> > +
> > +/*
> > + * Handle raw report as sent by device
> > + */
> > +static int picolcd_raw_event(struct hid_device *hdev,
> > +		struct hid_report *report, u8 *raw_data, int size)
> > +{
> > +	struct picolcd_data *data = hid_get_drvdata(hdev);
> > +	unsigned long flags;
> > +	int ret = 0;
> > +
> > +	if (data == NULL)
> > +		return 1;
> > +
> > +	if (report->id == REPORT_KEY_STATE) {
> > +		if (data->input_keys)
> > +			ret = picolcd_raw_keypad(hdev, report, raw_data+1, size-1);
> > +	} else if (report->id == REPORT_IR_DATA) {
> > +		if (data->input_cir)
> > +			ret = picolcd_raw_cir(hdev, report, raw_data+1, size-1);
> > +	} else {
> > +		spin_lock_irqsave(&data->lock, flags);
> > +		/*
> > +		 * We let the caller of picolcd_send_and_wait() check if the report
> > +		 * we got is one of the expected ones or not.
> > +		 */
> > +		if (data->pending) {
> > +			memcpy(data->pending->raw_data, raw_data+1, size-1);
> > +			data->pending->raw_size  = size-1;
> > +			data->pending->in_report = report;
> > +			complete_all(&data->ready);
> > +		}
> > +		spin_unlock_irqrestore(&data->lock, flags);
> > +	}
> > +
> > +	picolcd_debug_raw_event(data, hdev, report, raw_data, size);
> > +	return 1;
> > +}
> > +
> > +#ifdef CONFIG_PM
> > +static int picolcd_suspend(struct hid_device *hdev)
> > +{
> > +	dbg_hid(PICOLCD_NAME " device ready for suspend\n");
> > +	return 0;
> > +}
> > +
> > +static int picolcd_resume(struct hid_device *hdev)
> > +{
> > +	return 0;
> > +}
> > +
> > +static int picolcd_reset_resume(struct hid_device *hdev)
> > +{
> > +	int ret;
> > +	ret = picolcd_reset(hdev);
> > +	if (ret)
> > +		dbg_hid(PICOLCD_NAME " resetting our device failed: %d\n", ret);
> > +	return 0;
> > +}
> > +#endif
> > +
> > +/* initialize keypad input device */
> > +static inline int picolcd_init_keys(struct picolcd_data *data,
> > +		struct hid_report *report)
> > +{
> > +	struct hid_device *hdev = data->hdev;
> > +	struct input_dev *idev;
> > +	int error, i;
> > +
> > +	if (!report)
> > +		return -ENODEV;
> > +	if (report->maxfield != 1 || report->field[0]->report_count != 2 ||
> > +			report->field[0]->report_size != 8) {
> > +		dev_err(&hdev->dev, "unsupported KEY_STATE report");
> > +		return -EINVAL;
> > +	}
> > +
> > +	idev = input_allocate_device();
> > +	if (idev == NULL) {
> > +		dev_err(&hdev->dev, "failed to allocate input device");
> > +		return -ENOMEM;
> > +	}
> > +	input_set_drvdata(idev, hdev);
> > +	memcpy(data->keycode, def_keymap, sizeof(def_keymap));
> > +	idev->name = hdev->name;
> > +	idev->phys = hdev->phys;
> > +	idev->uniq = hdev->uniq;
> > +	idev->id.bustype = hdev->bus;
> > +	idev->id.vendor  = hdev->vendor;
> > +	idev->id.product = hdev->product;
> > +	idev->id.version = hdev->version;
> > +	idev->dev.parent = hdev->dev.parent;
> > +	idev->keycode     = &data->keycode;
> > +	idev->keycodemax  = PICOLCD_KEYS;
> > +	idev->keycodesize = sizeof(int);
> > +	input_set_capability(idev, EV_MSC, MSC_SCAN);
> > +	set_bit(EV_REP, idev->evbit);
> > +	for (i = 0; i < PICOLCD_KEYS; i++) {
> > +		int key = ((int *)idev->keycode)[i];
> > +		if (key < KEY_MAX && key >= 0)
> > +			input_set_capability(idev, EV_KEY, key);
> > +	}
> > +	error = input_register_device(idev);
> > +	if (error) {
> > +		dev_err(&hdev->dev, "error registering the input device");
> > +		input_free_device(idev);
> > +		return error;
> > +	}
> > +	data->input_keys = idev;
> > +	return 0;
> > +}
> > +
> > +static void picolcd_exit_keys(struct picolcd_data *data)
> > +{
> > +	struct input_dev *idev = data->input_keys;
> > +
> > +	data->input_keys = NULL;
> > +	if (idev)
> > +		input_unregister_device(idev);
> > +}
> > +
> > +/* initialize CIR input device */
> > +static inline int picolcd_init_cir(struct picolcd_data *data, struct hid_report *report)
> > +{
> > +	/* support not implemented yet */
> > +	return 0;
> > +}
> > +
> > +static void picolcd_exit_cir(struct picolcd_data *data)
> > +{
> > +}
> > +
> > +static inline int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data *data)
> > +{
> > +	struct picolcd_pending *verinfo;
> > +	struct hid_report *report;
> > +	int error;
> > +
> > +	verinfo = picolcd_send_and_wait(hdev, REPORT_VERSION, NULL, 0);
> > +	if (!verinfo || !verinfo->in_report) {
> > +		kfree(verinfo);
> > +		dev_err(&hdev->dev, "failed to query FW version of device\n");
> > +		return -ENODEV;
> > +	} else if (verinfo->in_report->id == REPORT_VERSION && verinfo->raw_size == 2) {
> > +		dev_info(&hdev->dev, "detected PicoLCD with firmware version %d.%d\n",
> > +				verinfo->raw_data[0], verinfo->raw_data[1]);
> > +		data->version[0] = verinfo->raw_data[1];
> > +		data->version[1] = verinfo->raw_data[0];
> > +		if (data->version[0] != 0 && data->version[1] != 3)
> > +			dev_info(&hdev->dev, "Device with untested firmware revision, "
> > +				"please submit /sys/kernel/debug/hid/%s/rdesc for this device.\n",
> > +				dev_name(&hdev->dev));
> > +		kfree(verinfo);
> > +		verinfo = NULL;
> > +	} else {
> > +		dev_err(&hdev->dev, "unexpected version response from PicoLCD"
> > +				" (report=0x%02x, size=%d)\n",
> > +				verinfo->in_report->id, verinfo->raw_size);
> > +		kfree(verinfo);
> > +		verinfo = NULL;
> > +		return -ENODEV;
> > +	}
> 
> 
> Please consolidate freeing of acquired resources.

See below

> > +
> > +	/* Setup keypad input device */
> > +	error = picolcd_init_keys(data, picolcd_in_report(REPORT_KEY_STATE, hdev));
> > +	if (error)
> > +		goto err;
> > +
> > +	/* Setup CIR input device */
> > +	error = picolcd_init_cir(data, picolcd_in_report(REPORT_IR_DATA, hdev));
> > +	if (error)
> > +		goto err;
> > +
> > +#ifdef CONFIG_DEBUG_FS
> > +	report = picolcd_out_report(REPORT_READ_MEMORY, hdev);
> > +	if (report && report->maxfield == 1 && report->field[0]->report_size == 8)
> > +		data->addr_sz = report->field[0]->report_count - 1;
> > +	else
> > +		data->addr_sz = -1;
> > +#endif
> > +	return 0;
> > +err:
> > +	picolcd_exit_cir(data);
> > +	picolcd_exit_keys(data);
> > +	return error;
> > +}
> > +
> > +static inline int picolcd_probe_bootloader(struct hid_device *hdev, struct picolcd_data *data)
> > +{
> > +	struct picolcd_pending *verinfo;
> > +	struct hid_report *report;
> > +
> > +	verinfo = picolcd_send_and_wait(hdev, REPORT_VERSION, NULL, 0);
> > +	if (!verinfo || !verinfo->in_report) {
> > +		kfree(verinfo);
> > +		dev_err(&hdev->dev, "failed to query FW version of device\n");
> > +		return -ENODEV;
> > +	} else if (verinfo->in_report->id == REPORT_VERSION && verinfo->raw_size == 2) {
> > +		dev_info(&hdev->dev, "detected PicoLCD with bootloader version %d.%d\n",
> > +				verinfo->raw_data[1], verinfo->raw_data[0]);
> > +		data->version[0] = verinfo->raw_data[1];
> > +		data->version[1] = verinfo->raw_data[0];
> > +		if (data->version[0] != 1 && data->version[1] != 0)
> > +			dev_info(&hdev->dev, "Device with untested bootloader revision, "
> > +				"please submit /sys/kernel/debug/hid/%s/rdesc for this device.\n",
> > +				dev_name(&hdev->dev));
> > +		kfree(verinfo);
> > +		verinfo = NULL;
> > +	} else {
> > +		dev_err(&hdev->dev, "unexpected version response from PicoLCD"
> > +				" (report=0x%02x, size=%d)\n",
> > +				verinfo->in_report->id, verinfo->raw_size);
> > +		kfree(verinfo);
> > +		verinfo = NULL;
> > +		return -ENODEV;
> > +	}
> > 
> 
> Please consolidate freeing of acquired resources. Wait, I just saw
> afucntion like that... can we combine them somehow?

Yeah, there are 3 blocks of very similar code though the important
difference is the operation mode (bootloader versus firmware).
According to the behavior and what bootloader mode displays
the version numbers are not in the same order for both cases.

The code distribution was looking worse some internal revisions ago
as by then I did allocate verinfo->raw_data separately ...

Will try to extract version check to a function.

> > +
> > +#ifdef CONFIG_DEBUG_FS
> > +	report = picolcd_out_report(REPORT_BL_READ_MEMORY, hdev);
> > +	if (report && report->maxfield == 1 && report->field[0]->report_size == 8)
> > +		data->addr_sz = report->field[0]->report_count - 1;
> > +	else
> > +		data->addr_sz = -1;
> > +#endif
> > +	return 0;
> > +}
> > +
> > +static int picolcd_probe(struct hid_device *hdev,
> > +		     const struct hid_device_id *id)
> > +{
> > +	struct picolcd_data *data;
> > +	int error = -ENOMEM;
> > +
> > +	dbg_hid(PICOLCD_NAME " hardware probe...\n");
> > +
> > +	/*
> > +	 * Let's allocate the picolcd data structure, set some reasonable
> > +	 * defaults, and associate it with the device
> > +	 */
> > +	data = kzalloc(sizeof(struct picolcd_data), GFP_KERNEL);
> > +	if (data == NULL) {
> > +		dev_err(&hdev->dev, "can't allocate space for Minibox PicoLCD device data\n");
> > +		error = -ENOMEM;
> > +		goto err_no_cleanup;
> > +	}
> > +
> > +	spin_lock_init(&data->lock);
> > +	init_completion(&data->ready);
> > +	data->hdev = hdev;
> > +	if (hdev->product == USB_DEVICE_ID_PICOLCD_BOOTLOADER)
> > +		data->status |= PICOLCD_BOOTLOADER;
> > +	hid_set_drvdata(hdev, data);
> > +
> > +	/* Parse the device reports and start it up */
> > +	error = hid_parse(hdev);
> > +	if (error) {
> > +		dev_err(&hdev->dev, "device report parse failed\n");
> > +		goto err_cleanup_data;
> > +	}
> > +
> > +	/* We don't use hidinput but hid_hw_start() fails if nothing is
> > +	 * claimed. So spoof claimed input. */
> > +	hdev->claimed = HID_CLAIMED_INPUT;
> > +	error = hid_hw_start(hdev, 0);
> > +	hdev->claimed = 0;
> > +	if (error) {
> > +		dev_err(&hdev->dev, "hardware start failed\n");
> > +		goto err_cleanup_data;
> > +	}
> > +
> > +	error = hdev->ll_driver->open(hdev);
> > +	if (error) {
> > +		dev_err(&hdev->dev, "failed to open input interrupt pipe for key and IR events\n");
> > +		goto err_cleanup_hid_hw;
> > +	}
> > +
> > +	error = sysfs_create_file(&(hdev->dev.kobj), &dev_attr_operation_mode.attr);
> 
> device_create_file?

Thanks for the pointer, will switch

> > +	if (error) {
> > +		dev_err(&hdev->dev, "failed to create sysfs attributes\n");
> > +		goto err_cleanup_hid_ll;
> > +	}
> > +

Thanks for your review,
Bruno
