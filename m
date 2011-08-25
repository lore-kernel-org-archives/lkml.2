Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1HYSEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:04:34 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:59539 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab1HYSEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:04:32 -0400
X-SENDER-IP: [85.230.168.63]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Avd0AE2NVk5V5qg/PGdsb2JhbABDiRKecAsBAQEBNzKBQAEBBAEnExwjBQsIA0YUJQoaE4dyArplDoVeYASYNIti
X-IronPort-AV: E=Sophos;i="4.68,281,1312149600"; 
   d="scan'208";a="213697084"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 25 Aug 2011 20:06:32 +0200
To: Dudley Du <dudl@cypress.com>
Cc: "rubini@ipvvis.unipv.it" <rubini@cvml.unipv.it>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] input:cyapa: Add new I2C-based input touchpad driver for
 Cypress I2C touchpad devices
Message-ID: <20110825180632.GA6112@polaris.bitmath.org>
References: <B27AC323FA92C946BA36D2913DDC8E370226D9457E6B@VMBX126.ihostexchange.net>
 <B27AC323FA92C946BA36D2913DDC8E370226D9457E7B@VMBX126.ihostexchange.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B27AC323FA92C946BA36D2913DDC8E370226D9457E7B@VMBX126.ihostexchange.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dudley,

Thanks for the driver, please find some comments on the MT implementation below.

> diff --git a/drivers/input/mouse/cypress_i2c.c b/drivers/input/mouse/cypress_i2c.c
> new file mode 100644
> index 0000000..61d5f7f
> --- /dev/null
> +++ b/drivers/input/mouse/cypress_i2c.c
> @@ -0,0 +1,1721 @@
> +/*
> + * Cypress APA trackpad with I2C interface
> + *
> + * Copyright (C) 2009 Compulab, Ltd.
> + * Dudley Du <dudl@cypress.com>
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file COPYING in the main directory of this archive for
> + * more details.
> + */
> +
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/i2c.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/input.h>
> +#include <linux/delay.h>
> +#include <linux/workqueue.h>
> +#include <linux/slab.h>
> +#include <linux/gpio.h>
> +#include <linux/spinlock.h>
> +#include <linux/mutex.h>
> +#include <linux/uaccess.h>
> +#include <linux/miscdevice.h>
> +#include <linux/fs.h>
> +#include <linux/input/mt.h>
> +
> +#include <linux/cyapa.h>
> +
> +
> +/* DEBUG: debug switch macro */
> +#define DBG_CYAPA_READ_BLOCK_DATA 0
> +
> +
> +/*
> + * Cypress I2C APA trackpad driver version is defined as below:
> + * CYAPA_MAJOR_VER.CYAPA_MINOR_VER.CYAPA_REVISION_VER
> + */
> +#define CYAPA_MAJOR_VER        1
> +#define CYAPA_MINOR_VER        1
> +#define CYAPA_REVISION_VER     0

Versions are best handled by git.

> +
> +#define CYAPA_MT_MAX_TOUCH  255
> +#define CYAPA_MT_MAX_WIDTH  255
> +
> +#define MAX_FINGERS    5
> +#define CYAPA_TOOL_WIDTH 50
> +#define CYAPA_DEFAULT_TOUCH_PRESSURE 50
> +#define CYAPA_MT_TOUCH_MAJOR  50

Most of the constants above seem unused.

> +/*
> + * In the special case, where a finger is removed and makes contact
> + * between two packets, there will be two touches for that finger,
> + * with different tracking_ids.
> + * Thus, the maximum number of slots must be twice the maximum number
> + * of fingers.
> + */
> +#define MAX_MT_SLOTS  (2 * MAX_FINGERS)

Alternatively, it could be equal to the number of tracking ids
recycled by the device, i.e., 16.

> +
> +/* When in IRQ mode read the device every THREAD_IRQ_SLEEP_SECS */
> +#define CYAPA_THREAD_IRQ_SLEEP_SECS    2
> +#define CYAPA_THREAD_IRQ_SLEEP_MSECS (CYAPA_THREAD_IRQ_SLEEP_SECS * MSEC_PER_SEC)
> +/*
> + * When in Polling mode and no data received for CYAPA_NO_DATA_THRES msecs
> + * reduce the polling rate to CYAPA_NO_DATA_SLEEP_MSECS
> + */
> +#define CYAPA_NO_DATA_THRES    (MSEC_PER_SEC)
> +#define CYAPA_NO_DATA_SLEEP_MSECS      (MSEC_PER_SEC / 4)

As Dmitry already pointed out, polling mode should be skipped altogether.

> + * APA trackpad device states.
> + * Used in register 0x00, bit1-0, DeviceStatus field.
> + */
> +#define CYAPA_MAX_TOUCHES (MAX_FINGERS)

Why two variables with the same meaning?

> +#define CYAPA_ONE_TIME_GESTURES  (1)

Gestures should be removed since the are not propagated.

> +
> +struct cyapa_touch {
> +       int x;
> +       int y;
> +       int pressure;
> +       int tracking_id;
> +};

There is no need to store the touches separately, cyapa_touch_gen3 will suffice.

> +
> +struct cyapa_gesture {
> +       u8 id;
> +       u8 param1;
> +       u8 param2;
> +};

This one falls out.

> +
> +struct cyapa_touch_gen3 {
> +       /*
> +        * high bits or x/y position value
> +        * bit 7 - 4: high 4 bits of x position value
> +        * bit 3 - 0: high 4 bits of y position value
> +        */
> +       u8 xy;
> +       u8 x;  /* low 8 bits of x position value. */
> +       u8 y;  /* low 8 bits of y position value. */
> +       u8 pressure;
> +       /*
> +        * The range of tracking_id is 0 - 15,
> +        * it is incremented every time a finger makes contact
> +        * with the trackpad.
> +        */
> +       u8 tracking_id;
> +};

Since the set of tracking ids is so limited, the simplest
implementation is to equate the device tracking ids with the MT
slots. A book-keeping bit field can be used to keep track of what
slots should be cleared in a round.

> +
> +struct cyapa_reg_data_gen3 {
> +       /*
> +        * bit 0 - 1: device status
> +        * bit 3 - 2: power mode
> +        * bit 6 - 4: reserved
> +        * bit 7: interrupt valid bit
> +        */
> +       u8 device_status;
> +       /*
> +        * bit 7 - 4: number of fingers currently touching pad
> +        * bit 3: valid data check bit
> +        * bit 2: middle mechanism button state if exists
> +        * bit 1: right mechanism button state if exists
> +        * bit 0: left mechanism button state if exists
> +        */
> +       u8 finger_btn;
> +       struct cyapa_touch_gen3 touches[CYAPA_MAX_TOUCHES];
> +};
> +
> +union cyapa_reg_data {
> +       struct cyapa_reg_data_gen3 gen3_data;
> +};

This one goes...

> +
> +struct cyapa_report_data {
> +       u8 button;
> +       u8 reserved1;
> +       u8 reserved2;
> +       u8 avg_pressure;
> +       int rel_deltaX;
> +       int rel_deltaY;
> +
> +       int touch_fingers;
> +       struct cyapa_touch touches[CYAPA_MAX_TOUCHES];
> +
> +       int gesture_count;
> +       struct cyapa_gesture gestures[CYAPA_ONE_TIME_GESTURES];
> +};

This struct wont be needed.

> +
> +
> +struct cyapa_mt_slot {
> +       struct cyapa_touch contact;
> +       bool touch_state;  /* true: is touched, false: not touched. */
> +       bool slot_updated;
> +};

This struct wont be needed.

> +
> +/* The main device structure */
> +struct cyapa_i2c {
> +       /* synchronize i2c bus operations. */
> +       struct semaphore reg_io_sem;
> +       /* synchronize accessing members of cyapa_i2c data structure. */
> +       spinlock_t miscdev_spinlock;
> +       /* synchronize accessing and updating file->f_pos. */
> +       struct mutex misc_mutex;
> +       int misc_open_count;
> +       /* indicate interrupt enabled by cyapa driver. */
> +       bool irq_enabled;
> +       /* indicate interrupt enabled by trackpad device. */
> +       bool bl_irq_enable;
> +       enum cyapa_work_mode fw_work_mode;
> +
> +       struct i2c_client       *client;
> +       struct input_dev        *input;
> +       struct delayed_work dwork;
> +       struct work_struct detect_work;
> +       struct workqueue_struct *detect_wq;
> +       enum cyapa_detect_status detect_status;
> +       /* synchronize access to dwork. */
> +       spinlock_t lock;
> +       int no_data_count;
> +       int scan_ms;
> +       int open_count;
> +
> +       int irq;
> +       /* driver using polling mode if failed to request irq. */
> +       bool polling_mode_enabled;
> +       struct cyapa_platform_data *pdata;
> +       unsigned short data_base_offset;
> +       unsigned short control_base_offset;
> +       unsigned short command_base_offset;
> +       unsigned short query_base_offset;
> +
> +       struct cyapa_mt_slot mt_slots[MAX_MT_SLOTS];

This can be skipped.

> +
> +       /* read from query data region. */
> +       char product_id[16];
> +       unsigned char capability[14];
> +       unsigned char fw_maj_ver;  /* firmware major version. */
> +       unsigned char fw_min_ver;  /* firmware minor version. */
> +       unsigned char hw_maj_ver;  /* hardware major version. */
> +       unsigned char hw_min_ver;  /* hardware minor version. */
> +       int max_abs_x;
> +       int max_abs_y;
> +       int physical_size_x;
> +       int physical_size_y;
> +};
> +
> +#if DBG_CYAPA_READ_BLOCK_DATA
> +#define DUMP_BUF_SIZE (40 * 3 + 20)  /* max will dump 40 bytes data. */
> +void cyapa_dump_data_block(const char *func, u8 reg, u8 length, void *data)
> +{
> +       char buf[DUMP_BUF_SIZE];
> +       unsigned buf_len = sizeof(buf);
> +       char *p = buf;
> +       int i;
> +       int l;
> +
> +       l = snprintf(p, buf_len, "reg 0x%04x: ", reg);
> +       buf_len -= l;
> +       p += l;
> +       for (i = 0; i < length && buf_len; i++, p += l, buf_len -= l)
> +               l = snprintf(p, buf_len, "%02x ", *((char *)data + i));
> +       pr_info("%s: data block length = %d\n", func, length);
> +       pr_info("%s: %s\n", func, buf);
> +}
> +
> +void cyapa_dump_report_data(const char *func,
> +                               struct cyapa_report_data *report_data)
> +{
> +       int i;
> +
> +       pr_info("%s: ------------------------------------\n", func);
> +       pr_info("%s: report_data.button = 0x%02x\n",
> +               func, report_data->button);
> +       pr_info("%s: report_data.avg_pressure = %d\n",
> +               func, report_data->avg_pressure);
> +       pr_info("%s: report_data.touch_fingers = %d\n",
> +               func, report_data->touch_fingers);
> +       for (i = 0; i < report_data->touch_fingers; i++) {
> +               pr_info("%s: report_data.touches[%d].x = %d\n",
> +                       func, i, report_data->touches[i].x);
> +               pr_info("%s: report_data.touches[%d].y = %d\n",
> +                       func, i, report_data->touches[i].y);
> +               pr_info("%s: report_data.touches[%d].pressure = %d\n",
> +                       func, i, report_data->touches[i].pressure);
> +               if (report_data->touches[i].tracking_id != -1)
> +                       pr_info("%s: report_data.touches[%d].tracking_id = %d\n",
> +                               func, i, report_data->touches[i].tracking_id);
> +       }
> +       pr_info("%s: report_data.gesture_count = %d\n",
> +                       func, report_data->gesture_count);
> +       for (i = 0; i < report_data->gesture_count; i++) {
> +               pr_info("%s: report_data.gestures[%d].id = 0x%02x\n",
> +                       func, i, report_data->gestures[i].id);
> +               pr_info("%s: report_data.gestures[%d].param1 = 0x%02x\n",
> +                       func, i, report_data->gestures[i].param1);
> +               pr_info("%s: report_data.gestures[%d].param2 = 0x%02x\n",
> +                       func, i, report_data->gestures[i].param2);
> +       }
> +       pr_info("%s: -------------------------------------\n", func);
> +}
> +#else
> +void cyapa_dump_data_block(const char *func, u8 reg, u8 length, void *data) {}
> +void cyapa_dump_report_data(const char *func,
> +               struct cyapa_report_data *report_data) {}
> +#endif

Are these debug functions really necessary?

> +static inline void cyapa_report_fingers(struct input_dev *input, int fingers)
> +{
> +       input_report_key(input, BTN_TOOL_FINGER, (fingers == 1));
> +       input_report_key(input, BTN_TOOL_DOUBLETAP, (fingers == 2));
> +       input_report_key(input, BTN_TOOL_TRIPLETAP, (fingers == 3));
> +       input_report_key(input, BTN_TOOL_QUADTAP, (fingers > 3));
> +}

This functionality is found in input_mt_report_finger_count() and
input_mt_report_pointer_emulation().

> +
> +static void cyapa_parse_gen3_data(struct cyapa_i2c *touch,
> +               struct cyapa_reg_data_gen3 *reg_data,
> +               struct cyapa_report_data *report_data)
> +{
> +       int i;
> +       int fingers;
> +
> +       /* only report left button. */
> +       report_data->button = reg_data->finger_btn & OP_DATA_BTN_MASK;
> +       report_data->avg_pressure = 0;
> +       /* parse number of touching fingers. */
> +       fingers = (reg_data->finger_btn >> 4) & 0x0F;
> +       report_data->touch_fingers = min(CYAPA_MAX_TOUCHES, fingers);
> +
> +       /* parse data for each touched finger. */
> +       for (i = 0; i < report_data->touch_fingers; i++) {
> +               report_data->touches[i].x =
> +                       ((reg_data->touches[i].xy & 0xF0) << 4) |
> +                               reg_data->touches[i].x;
> +               report_data->touches[i].y =
> +                       ((reg_data->touches[i].xy & 0x0F) << 8) |
> +                               reg_data->touches[i].y;
> +               report_data->touches[i].pressure =
> +                       reg_data->touches[i].pressure;
> +               report_data->touches[i].tracking_id =
> +                       reg_data->touches[i].tracking_id;
> +       }
> +       report_data->gesture_count = 0;
> +
> +       /* DEBUG: dump parsed report data */
> +       cyapa_dump_report_data(__func__, report_data);
> +}

This function could be expanded to handle input reporting directly. Something like:

int num_fingers = (reg_data->finger_btn >> 4) & 0x0F;
int mask = 0;

for (i = 0; i < num_fingers; i++) {
	const struct cyapa_touch_gen3 *touch = &reg_data->touches[i];
	int slot = touch->tracking_id;
	int x = ((touch->xy & 0xF0) << 4) | touch->x;
	int y = ((touch->xy & 0x0F) << 8) | touch->y;

	input_mt_slot(input, slot);
	input_mt_report_slot_state(input, MT_TOOL_FINGER, true);
	input_report_abs(input, ABS_MT_POSITION_X, x);
	input_report_abs(input, ABS_MT_POSITION_Y, y);
	input_report_abs(input, ABS_MT_PRESSURE, touch->pressure);

	mask |= (1 << slot);
}

for (i = 0; i < MAX_MT_SLOTS; i++) {
	if (mask & (1 << i))
		continue;
	input_mt_slot(input, i);
	input_mt_report_slot_state(input, MT_TOOL_FINGER, false);
}


input_mt_report_pointer_emulation(input, true);
input_report_key(input, BTN_LEFT, reg_data->finger_btn & OP_DATA_BTN_MASK);
input_sync(input);

> +
> +
> +static int cyapa_find_mt_slot(struct cyapa_i2c *touch,
> +               struct cyapa_touch *contact)
> +{
> +       int i;
> +       int empty_slot = -1;
> +
> +       for (i = 0; i < MAX_MT_SLOTS; i++) {
> +               if ((touch->mt_slots[i].contact.tracking_id == contact->tracking_id) &&
> +                       touch->mt_slots[i].touch_state)
> +                       return i;
> +
> +               if (!touch->mt_slots[i].touch_state && empty_slot == -1)
> +                       empty_slot = i;
> +       }
> +
> +       return empty_slot;
> +}

This wont be necessary.

> +
> +static void cyapa_update_mt_slots(struct cyapa_i2c *touch,
> +               struct cyapa_report_data *report_data)
> +{
> +       int i;
> +       int slotnum;
> +
> +       for (i = 0; i < report_data->touch_fingers; i++) {
> +               slotnum = cyapa_find_mt_slot(touch, &report_data->touches[i]);
> +               if (slotnum < 0)
> +                       continue;
> +
> +               memcpy(&touch->mt_slots[slotnum].contact,
> +                               &report_data->touches[i],
> +                               sizeof(struct cyapa_touch));
> +               touch->mt_slots[slotnum].slot_updated = true;
> +               touch->mt_slots[slotnum].touch_state = true;
> +       }
> +}

This wont be necessary.

> +
> +static void cyapa_send_mtb_event(struct cyapa_i2c *touch,
> +               struct cyapa_report_data *report_data)
> +{
> +       int i;
> +       struct cyapa_mt_slot *slot;
> +       struct input_dev *input = touch->input;
> +
> +       cyapa_update_mt_slots(touch, report_data);
> +
> +       for (i = 0; i < MAX_MT_SLOTS; i++) {
> +               slot = &touch->mt_slots[i];
> +               if (!slot->slot_updated)
> +                       slot->touch_state = false;
> +
> +               input_mt_slot(input, i);
> +               input_mt_report_slot_state(input, MT_TOOL_FINGER, slot->touch_state);
> +               if (slot->touch_state) {
> +                       input_report_abs(input, ABS_MT_POSITION_X, slot->contact.x);
> +                       input_report_abs(input, ABS_MT_POSITION_Y, slot->contact.y);
> +                       input_report_abs(input, ABS_MT_PRESSURE, slot->contact.pressure);
> +               }
> +               slot->slot_updated = false;
> +       }
> +
> +       input_mt_report_pointer_emulation(input, true);
> +       input_report_key(input, BTN_LEFT, report_data->button);
> +       input_sync(input);
> +}

This could be folded into the parsing function.

> +
> +static int cyapa_handle_input_report_data(struct cyapa_i2c *touch,
> +               struct cyapa_report_data *report_data)
> +{
> +       cyapa_send_mtb_event(touch, report_data);
> +
> +       return report_data->touch_fingers | report_data->button;
> +}

This wont be necessary.

> +
> +static bool cyapa_i2c_get_input(struct cyapa_i2c *touch)
> +{
> +       int ret_read_size;
> +       int read_length;
> +       union cyapa_reg_data reg_data;
> +       struct cyapa_reg_data_gen3 *gen3_data;
> +       struct cyapa_report_data report_data;
> +
> +       /* read register data from trackpad. */
> +       gen3_data = &reg_data.gen3_data;
> +       read_length = (int)sizeof(struct cyapa_reg_data_gen3);
> +
> +       ret_read_size = cyapa_i2c_reg_read_block(touch,
> +                                       DATA_REG_START_OFFSET,
> +                                       read_length,
> +                                       (char *)&reg_data);
> +       if (ret_read_size < 0)
> +               return 0;
> +
> +       if (cyapa_verify_data_device(touch, &reg_data) < 0)
> +               return 0;
> +
> +       /* process and parse raw data read from Trackpad. */
> +       cyapa_parse_gen3_data(touch, gen3_data, &report_data);

Reporting could be done here in a straight-forward fashion.

> +
> +       /* report data to input subsystem. */
> +       return cyapa_handle_input_report_data(touch, &report_data);

Skipping this abstraction entirely.
> +static int cyapa_create_input_dev(struct cyapa_i2c *touch)
> +{
> +       int ret;
> +       struct input_dev *input = NULL;
> +
> +       input = touch->input = input_allocate_device();
> +       if (!touch->input) {
> +               pr_err("Allocate memory for Input device failed\n");
> +               return -ENOMEM;
> +       }
> +
> +       input->name = "cyapa_i2c_trackpad";
> +       input->phys = touch->client->adapter->name;
> +       input->id.bustype = BUS_I2C;
> +       input->id.version = 1;
> +       input->id.product = 0;  /* means any product in eventcomm. */
> +       input->dev.parent = &touch->client->dev;
> +
> +       input->open = cyapa_i2c_open;
> +       input->close = cyapa_i2c_close;
> +       input_set_drvdata(input, touch);
> +
> +       __set_bit(EV_ABS, input->evbit);
> +
> +       /*
> +        * set and report not-MT axes to support synaptics X Driver.
> +        * When multi-fingers on trackpad, only the first finger touch
> +        * will be reported as X/Y axes values.
> +        */
> +       input_set_abs_params(input, ABS_X, 0, touch->max_abs_x, 0, 0);
> +       input_set_abs_params(input, ABS_Y, 0, touch->max_abs_y, 0, 0);
> +       input_set_abs_params(input, ABS_PRESSURE, 0, 255, 0, 0);
> +       input_set_abs_params(input, ABS_TOOL_WIDTH, 0, 255, 0, 0);
> +
> +       /* finger position */
> +       input_set_abs_params(input, ABS_MT_POSITION_X, 0, touch->max_abs_x, 0, 0);
> +       input_set_abs_params(input, ABS_MT_POSITION_Y, 0, touch->max_abs_y, 0, 0);
> +       input_set_abs_params(input, ABS_MT_PRESSURE, 0, 255, 0, 0);
> +
> +       ret = input_mt_init_slots(input, MAX_MT_SLOTS);
> +       if (ret < 0)
> +               return ret;
> +
> +       if (touch->physical_size_x && touch->physical_size_y) {
> +               input_abs_set_res(input, ABS_X,
> +                       touch->max_abs_x / touch->physical_size_x);
> +               input_abs_set_res(input, ABS_Y,
> +                       touch->max_abs_y / touch->physical_size_y);
> +               input_abs_set_res(input, ABS_MT_POSITION_X,
> +                       touch->max_abs_x / touch->physical_size_x);
> +               input_abs_set_res(input, ABS_MT_POSITION_Y,
> +                       touch->max_abs_y / touch->physical_size_y);
> +       }
> +
> +       __set_bit(EV_KEY, input->evbit);
> +       __set_bit(BTN_TOUCH, input->keybit);
> +       __set_bit(BTN_TOOL_FINGER, input->keybit);
> +       __set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
> +       __set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
> +       __set_bit(BTN_TOOL_QUADTAP, input->keybit);
> +
> +       __set_bit(BTN_LEFT, input->keybit);
> +
> +       /* Register the device in input subsystem */
> +       ret = input_register_device(touch->input);
> +       if (ret) {
> +               pr_err("Input device register failed, %d\n", ret);
> +               input_free_device(input);
> +       }
> +
> +       return ret;
> +}
> +

Thanks,
Henrik
