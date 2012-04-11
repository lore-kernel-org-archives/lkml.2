Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab2DKQE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:04:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59008 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab2DKQE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:04:57 -0400
MIME-Version: 1.0
In-Reply-To: <1334061766-20577-1-git-send-email-tom_lin@emc.com.tw>
References: <1334061766-20577-1-git-send-email-tom_lin@emc.com.tw>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 12 Apr 2012 00:04:35 +0800
X-Google-Sender-Auth: 0Gm_A4Y488z-6R_jhjt_QUcSOqM
Message-ID: <CAGS+omAwuW+gPaO9Qh9zfvu7t1FEVj=-6rsfRpR7Y8sHd5Z0vg@mail.gmail.com>
Subject: Re: [PATCH v3] Input: Elan HID-I2C device driver
To: Tom Lin <tom_lin@emc.com.tw>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 8:42 PM, Tom Lin <tom_lin@emc.com.tw> wrote:
> This patch adds driver for Elan I2C touchpad. These protocol of HID-I2C was
> defined by Microsoft. The kernel driver would use the multi-touch protocol
> format B.
>
> Signed-off-by:Tom Lin(Lin Yen Yu) <tom_lin@emc.com.tw>
> ---
>  drivers/input/mouse/Kconfig        |    8 +
>  drivers/input/mouse/Makefile       |    1 +
>  drivers/input/mouse/elantech_i2c.c |  504 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 513 insertions(+)
>  create mode 100644 drivers/input/mouse/elantech_i2c.c
>
> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> index 9b8db82..345cf8c 100644
> --- a/drivers/input/mouse/Kconfig
> +++ b/drivers/input/mouse/Kconfig
> @@ -339,4 +339,12 @@ config MOUSE_SYNAPTICS_USB
>          To compile this driver as a module, choose M here: the
>          module will be called synaptics_usb.
>
> +config MOUSE_ELANTECH_I2C

I think the KConfig is supposed to be alphabetized...  but the Kconfig
file looks like it is already pretty jumbled.  I'll leave it to the
experts to express the official opinion.

> +       tristate "Elan I2C Touchpad support"
> +       depends on I2C
> +       help
> +        Say Y here if you want to use a Elan HID-I2C touchpad.
> +
> +        To compile this driver as a module, choose M here: the
> +        module will be called elantech_i2c.
>  endif
> diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
> index 4718eff..6f092a3 100644
> --- a/drivers/input/mouse/Makefile
> +++ b/drivers/input/mouse/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_MOUSE_SERIAL)            += sermouse.o
>  obj-$(CONFIG_MOUSE_SYNAPTICS_I2C)      += synaptics_i2c.o
>  obj-$(CONFIG_MOUSE_SYNAPTICS_USB)      += synaptics_usb.o
>  obj-$(CONFIG_MOUSE_VSXXXAA)            += vsxxxaa.o
> +obj-$(CONFIG_MOUSE_ELANTECH_I2C)       += elantech_i2c.o

Please alphabetize.

>
>  psmouse-objs := psmouse-base.o synaptics.o
>
> diff --git a/drivers/input/mouse/elantech_i2c.c b/drivers/input/mouse/elantech_i2c.c
> new file mode 100644
> index 0000000..3e4b5d4
> --- /dev/null
> +++ b/drivers/input/mouse/elantech_i2c.c
> @@ -0,0 +1,504 @@
> +/*
> + * Elantech I2C Touchpad diver
> + *
> + * Copyright (c) 2011-2012 Tom Lin (Lin Yen Yu) <tom_lin@emc.com.tw>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * Trademarks are the property of their respective owners.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/gpio.h>
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/input.h>
> +#include <linux/input/mt.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/workqueue.h>
> +
> +#define DRIVER_NAME            "elantech_i2c"
> +#define ETP_FINGER_DATA_OFFSET 4
> +#define ETP_FINGER_DATA_LEN    5
> +#define ETP_I2C_COMMAND_TRIES  3
> +#define ETP_I2C_COMMAND_DELAY  500
> +/*length of Elan Touchpad information*/
> +#define ETP_INF_LENGTH         2
> +#define ETP_MAX_FINGERS                5
> +#define ETP_PACKET_LENGTH      30
> +#define ETP_REPORT_ID          0X5d
> +#define HID_DES_LENGTH_OFFSET  1
> +
> +static bool elan_i2c_debug;
> +module_param_named(debug, elan_i2c_debug, bool, 0600);
> +MODULE_PARM_DESC(debug, "Turn Elan i2c TP  debugging mode on and off");
> +
> +#define elantech_debug(fmt, ...)                               \
> +       do {                                                    \
> +               if (elan_i2c_debug)                             \
> +                       printk(KERN_DEBUG KBUILD_MODNAME        \
> +                                       fmt, ##__VA_ARGS__);    \

Why not use dev_dbg()

> +       } while (0)
> +
> +enum etd_i2c_command {
> +       ETP_HID_DESCR_LENGTH_CMD,
> +       ETP_HID_DESCR_CMD,
> +       ETP_HID_WAKE_UP_CMD,
> +       ETP_HID_RESET_CMD,
> +       ETP_HID_REPORT_DESCR_CMD,
> +       ETP_TRACE_NUM_CMD,
> +       ETP_X_AXIS_MAX_CMD,
> +       ETP_Y_AXIS_MAX_CMD,
> +       ETP_DPI_VALUE_CMD,
> +       ETP_ENABLE_ABS_CMD
> +};
> +
> +static const u8 hid_descriptor[] = {0x01, 0x00};
> +static const u8 hid_wake_up[] = {0x05, 0x00, 0x00, 0x08};
> +static const u8 hid_reset_cmd[] = {0x05, 0x00, 0x00, 0x01};
> +static const u8 hid_report_descriptor[] = {0x02, 0x00};
> +static const u8 trace_num_xy[] = {0x05, 0x01};
> +static const u8 x_axis_max[] = {0x06, 0x01};
> +static const u8 y_axis_max[] = {0x07, 0x01};
> +static const u8 dpi_value[] = {0x08, 0x01};
> +static const u8 enable_abs[] = {0x00, 0x03, 0x01, 0x00};

If these are all etc commands, start their names with etc_ and end with _cmd.
In fact, just use a lower case version of the corresponding value from the enum.

> +
> +/* The main device structure */
> +struct elantech_i2c {
> +       struct i2c_client       *client;
> +       struct input_dev        *input;
> +       struct work_struct      work;
> +       unsigned int            gpio;
> +       unsigned int            max_x;
> +       unsigned int            max_y;
> +       unsigned int            width_x;
> +       unsigned int            width_y;
> +       int                     irq;
> +       u8                      pre_recv[28];
> +};
> +
> +static int elantech_i2c_command(struct i2c_client *client, int  command,
> +                               unsigned char *buf_recv, int data_len)
> +{
> +       const u8 *cmd = NULL;
> +       unsigned char *rec_buf = buf_recv;
> +       int ret;
> +       int tries = ETP_I2C_COMMAND_TRIES;
> +       int length = 0;
> +       struct i2c_msg msg[2];
> +       int msg_num = 0;
> +
> +       switch (command) {
> +       case ETP_HID_DESCR_LENGTH_CMD:
> +       case ETP_HID_DESCR_CMD:
> +               cmd = hid_descriptor;
> +               length = sizeof(hid_descriptor);
> +               msg[1].len = data_len;
> +               msg_num = 2;
> +               break;
> +       case ETP_HID_WAKE_UP_CMD:
> +               cmd = hid_wake_up;
> +               length = sizeof(hid_wake_up);
> +               msg_num = 1;
> +               break;
> +       case ETP_HID_RESET_CMD:
> +               cmd = hid_reset_cmd;
> +               length = sizeof(hid_reset_cmd);
> +               msg_num = 1;
> +               break;
> +       case ETP_HID_REPORT_DESCR_CMD:
> +               cmd = hid_report_descriptor;
> +               length = sizeof(hid_report_descriptor);
> +               msg[1].len = data_len;
> +               msg_num = 2;
> +               break;
> +       case ETP_TRACE_NUM_CMD:
> +               cmd = trace_num_xy;
> +               length = sizeof(trace_num_xy);
> +               msg[1].len = data_len;
> +               msg_num = 2;
> +               break;
> +       case ETP_X_AXIS_MAX_CMD:
> +               cmd = x_axis_max;
> +               length = sizeof(x_axis_max);
> +               msg[1].len = data_len;
> +               msg_num = 2;
> +               break;
> +       case ETP_Y_AXIS_MAX_CMD:
> +               cmd = y_axis_max;
> +               length = sizeof(y_axis_max);
> +               msg[1].len = data_len;
> +               msg_num = 2;
> +               break;
> +       case ETP_DPI_VALUE_CMD:
> +               cmd = dpi_value;
> +               length = sizeof(dpi_value);
> +               msg[1].len = data_len;
> +               msg_num = 2;
> +               break;
> +       case ETP_ENABLE_ABS_CMD:
> +               cmd = enable_abs;
> +               length = sizeof(enable_abs);
> +               msg_num = 1;
> +               break;
> +       default:
> +               elantech_debug("%s command=%d unknow.\n",
> +                        __func__, command);
> +               return -1;
> +       }
> +
> +       msg[0].addr = client->addr;
> +       msg[0].flags = client->flags & I2C_M_TEN;
> +       msg[0].len = length;
> +       msg[0].buf = (char *) cmd;
> +       msg[1].addr = client->addr;
> +       msg[1].flags = client->flags & I2C_M_TEN;
> +       msg[1].flags |= I2C_M_RD;
> +       msg[1].buf = rec_buf;
> +
> +       do {
> +               ret = i2c_transfer(client->adapter, msg, msg_num);
> +               if (ret != msg_num && elan_i2c_debug)
> +                       print_hex_dump_bytes("Elan I2C Touch data :",
> +                               DUMP_PREFIX_NONE, rec_buf, msg[1].len);
> +               if (ret > 0)
> +                       break;
> +               tries--;
> +               elantech_debug("retrying elantech_i2c_command:%d (%d)\n",
> +                       command, tries);
> +       } while (tries > 0);
> +
> +       return ret;
> +}
> +
> +static bool elantech_i2c_hw_init(struct i2c_client *client)
> +{
> +       int rc;
> +       uint8_t buf_recv[79];

Why 79?  A named constant would be better.

> +       int hid_descr_len;
> +       int hid_report_len;
> +
> +       /*Fetch the length of HID description*/
/* Fetch HID descriptor length */

Note the space after /* and before the trailing */.  This applies to
all of your comments.

> +       rc = elantech_i2c_command(client, ETP_HID_DESCR_LENGTH_CMD, buf_recv,
> +                       HID_DES_LENGTH_OFFSET);
> +       if (rc != 2)
> +               return false;
> +       else

else not needed

> +               hid_descr_len = buf_recv[0];
> +
> +       /*Fetch the lenght of HID report description*/

/* Fetch HID descriptor and parse HID report descriptor form length
from byte 4 */

Why ignore the rest if the HID descriptor?
What does it contain?
I am not familiar with the HID spec.  Perhaps this is well defined elsewhere.

> +       rc = elantech_i2c_command(client, ETP_HID_DESCR_CMD, buf_recv, hid_descr_len);
> +       if (rc != 2)
> +               return false;
> +       else
else not needed

> +               hid_report_len = buf_recv[4];
> +
> +       rc = elantech_i2c_command(client, ETP_HID_WAKE_UP_CMD, buf_recv, 0);
> +       if (rc != 1)
> +               return false;
> +
> +       rc = elantech_i2c_command(client, ETP_HID_RESET_CMD, buf_recv, 0);
> +       if (rc != 1)
> +               return false;
> +
> +       msleep(ETP_I2C_COMMAND_DELAY);

It is generally not a good idea to put a 500 ms msleep in the middle
of a driver probe.  This directly affects boot time.
The rest of this initialization should be done in a workqueue in
response to the interrupt that should occur after reset (according to
the HID-I2C doc that you referenced).


> +       rc = i2c_master_recv(client, buf_recv, 2);
> +       if (rc != 2 || (buf_recv[0] != 0 && buf_recv[1] != 0))
> +               return false;
> +
> +       rc = elantech_i2c_command(client, ETP_HID_REPORT_DESCR_CMD, buf_recv,
> +               hid_report_len);
> +       if (rc != 2)
> +               return false;
> +
> +       return true;
> +}
> +
> +static void elantech_i2c_report_absolute(struct elantech_i2c *touch,
> +                                uint8_t *buf)
> +{
> +       unsigned char *packet = buf;
Why do you need a separate variable?

> +       unsigned char *finger_data;
            uint8_t *finger_data = &packet[ETP_FINGER_DATA_OFFSET];
> +       struct input_dev *input = touch->input;
> +       int finger_status[5];

  bool finger_status;

No need for an array

> +       int i;
> +       int position_x, position_y;
> +       int mky_value, mkx_value, h_value;
> +
> +       dyn_data_i = 0;

> +       for (i = 0 ; i < ETP_MAX_FINGERS ; i++) {
> +               finger_status[i] = (packet[3] >> (3+i)) & 0x01;
> +               if (finger_status[i]) {

> +                       position_x = ((finger_data[0] & 0xf0) << 4) | finger_data[1];
> +                       position_y = touch->max_y -
> +                               (((finger_data[0] & 0x0f) << 8) | finger_data[2]);
> +                       mkx_value = (finger_data[3] & 0x0f) * touch->width_x;
> +                       mky_value = (finger_data[3] >> 4) * touch->width_y;
> +                       h_value = finger_data[4];

                            finger_data += ETP_FINGER_DATA_LEN;

> +                       input_mt_slot(input, i);
> +                       input_mt_report_slot_state(input, MT_TOOL_FINGER, true);
> +
> +                       input_report_abs(input, ABS_MT_POSITION_X, position_x);
> +                       input_report_abs(input, ABS_MT_POSITION_Y, position_y);
> +                       input_report_abs(input, ABS_MT_PRESSURE, h_value);
> +                       input_report_abs(input, ABS_MT_TOUCH_MAJOR, mkx_value);
> +                       input_report_abs(input, ABS_MT_TOUCH_MINOR, mky_value);
> +               } else if (finger_status[i] == 0) {

} else {

> +                       input_mt_slot(input, i);
> +                       input_mt_report_slot_state(input, MT_TOOL_FINGER, false);
> +               }
> +       }
> +       input_report_key(input, BTN_LEFT, ((packet[3] & 0x01) == 1));
> +       input_report_key(input, BTN_RIGHT, ((packet[3] & 0x02) == 2));
> +       input_report_key(input, BTN_MIDDLE, ((packet[3] & 0x04) == 4));
> +       input_mt_report_pointer_emulation(input, true);
> +       input_sync(input);
> +}
> +
> +static irqreturn_t elantech_i2c_isr(int irq, void *dev_id)
> +{
> +       struct elantech_i2c *elantech_i2c_priv = dev_id;
> +       unsigned char buf_recv[30] = {0};

uint8_t buf_recv[ETP_PACKET_LENGTH];

> +       int rc;
> +       int length;
> +
> +       rc = i2c_master_recv(elantech_i2c_priv->client, buf_recv, ETP_PACKET_LENGTH);

  if (rc != ETP_PACKET_LENGTH)
    goto elantech_isr_end;
  ...

> +       if (rc == ETP_PACKET_LENGTH) {
> +               length = (buf_recv[1] << 8) | buf_recv[0];

If you are sanity checking the packet, perhaps you should check this
length, too?

> +               if (!memcmp(elantech_i2c_priv->pre_recv, buf_recv, length))
> +                       goto elantech_isr_end;

Why are you checking that the packet is the same as before and exiting if it is?
Let the evdev layer handle event compression.

> +
> +               memcpy(elantech_i2c_priv->pre_recv, buf_recv, length);
> +               /*Packet check*/
> +               if (buf_recv[2] == ETP_REPORT_ID && buf_recv[length - 1] == 0x00)
> +                       elantech_i2c_report_absolute(elantech_i2c_priv, buf_recv);
> +               else if (elan_i2c_debug)
> +                       print_hex_dump_bytes("Elan I2C Touch data :",
> +                               DUMP_PREFIX_NONE, buf_recv, length);
> +       }
> +
> +elantech_isr_end:
> +       return IRQ_HANDLED;
> +}
> +
> +static struct elantech_i2c *elantech_i2c_priv_create(struct i2c_client *client)
> +{
> +       struct elantech_i2c *elantech_i2c_priv;
> +       struct input_dev *dev;
> +       unsigned int gpio;
> +       const char *label = "elantech_i2c";
> +       int rc = 0;
> +       int Pressure_value_data;

use lower case pressure

> +       unsigned char buf_recv[2];
> +
> +       elantech_i2c_priv = kzalloc(sizeof(struct elantech_i2c), GFP_KERNEL);
> +       if (!elantech_i2c_priv)
> +               return NULL;
> +
> +       elantech_i2c_priv->client = client;
> +       elantech_i2c_priv->irq = client->irq;
> +       elantech_i2c_priv->input = input_allocate_device();
> +       if (elantech_i2c_priv->input == NULL)
> +               goto err_input_allocate_device;
> +
> +       elantech_i2c_priv->input->name = "ELANTECH_I2C";
> +       elantech_i2c_priv->input->phys = client->adapter->name;
> +       elantech_i2c_priv->input->id.bustype = BUS_I2C;
> +
> +       dev = elantech_i2c_priv->input;
> +       __set_bit(EV_KEY, dev->evbit);
> +       __set_bit(EV_ABS, dev->evbit);
> +
> +       __set_bit(BTN_LEFT, dev->keybit);
> +       __set_bit(BTN_RIGHT, dev->keybit);
> +       __set_bit(BTN_MIDDLE, dev->keybit);
> +
> +       __set_bit(BTN_TOUCH, dev->keybit);
> +       __set_bit(BTN_TOOL_FINGER, dev->keybit);
> +       __set_bit(BTN_TOOL_DOUBLETAP, dev->keybit);
> +       __set_bit(BTN_TOOL_TRIPLETAP, dev->keybit);
> +       __set_bit(BTN_TOOL_QUADTAP, dev->keybit);
> +
> +       elantech_i2c_command(client, ETP_X_AXIS_MAX_CMD, buf_recv, ETP_INF_LENGTH);
> +       elantech_i2c_priv->max_x = (0x0f & buf_recv[1]) << 8 | buf_recv[0];
> +       elantech_i2c_command(client, ETP_Y_AXIS_MAX_CMD, buf_recv, ETP_INF_LENGTH);
> +       elantech_i2c_priv->max_y = (0x0f & buf_recv[1]) << 8 | buf_recv[0];
> +       printk(KERN_INFO "%s max_x = %d\n", __func__, elantech_i2c_priv->max_x);

dev_info()

> +       printk(KERN_INFO "%s max_y = %d\n", __func__, elantech_i2c_priv->max_y);
> +       elantech_i2c_command(client, ETP_TRACE_NUM_CMD, buf_recv, ETP_INF_LENGTH);
> +       elantech_i2c_priv->width_x = elantech_i2c_priv->max_x / (buf_recv[0] - 1);
> +       elantech_i2c_priv->width_y = elantech_i2c_priv->max_y / (buf_recv[1] - 1);
> +       Pressure_value_data = 0xff;
> +
> +       /* X Y Value*/
> +       input_set_abs_params(dev, ABS_X, 0, elantech_i2c_priv->max_x, 0, 0);
> +       input_set_abs_params(dev, ABS_Y, 0, elantech_i2c_priv->max_y, 0, 0);
> +       /* Palme Value */
> +       input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
> +
> +       /* Finger Pressure value */
> +       input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, Pressure_value_data, 0, 0);
> +
> +       /* Finger Pressure value */
> +       input_mt_init_slots(dev, ETP_MAX_FINGERS);
> +       input_set_abs_params(dev, ABS_MT_POSITION_X, 0, elantech_i2c_priv->max_x, 0, 0);
> +       input_set_abs_params(dev, ABS_MT_POSITION_Y, 0, elantech_i2c_priv->max_y, 0, 0);
> +       input_set_abs_params(dev, ABS_MT_PRESSURE, 0, Pressure_value_data, 0, 0);
> +       input_set_abs_params(dev, ABS_MT_TOUCH_MAJOR, 0, Pressure_value_data, 0, 0);
> +       input_set_abs_params(dev, ABS_MT_TOUCH_MINOR, 0, Pressure_value_data, 0, 0);
> +
> +       /* Enable ABS mode*/
> +       elantech_i2c_command(client, ETP_ENABLE_ABS_CMD, buf_recv, ETP_INF_LENGTH);
> +       gpio = irq_to_gpio(client->irq);
> +       rc = gpio_request(gpio, label);
> +       if (rc < 0) {
> +               dev_dbg(&client->dev, "gpio_request failed for input %d rc = %d\n", gpio, rc);
> +               goto    err_gpio_request;
> +       }
> +       rc = gpio_direction_input(gpio);
> +       if (rc < 0) {
> +               dev_dbg(&client->dev, "gpio_direction_input failed for input %d\n", gpio);
> +               goto    err_gpio_request;
> +       }
> +       elantech_i2c_priv->gpio = gpio;
> +       rc = request_threaded_irq(client->irq, NULL, elantech_i2c_isr,
> +                       IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +                       client->name, elantech_i2c_priv);
> +        if (rc < 0) {
> +               dev_dbg(&client->dev, "Could not register for %s interrupt, irq = %d, rc = %d\n",
> +               label, client->irq, rc);
> +               goto    err_gpio_request_irq_fail;
> +       }
> +
> +       return elantech_i2c_priv;
> +
> +err_gpio_request_irq_fail:
> +       gpio_free(gpio);
> +err_gpio_request:
> +       input_free_device(elantech_i2c_priv->input);
> +err_input_allocate_device:

if you get here via the goto err_input_allocate_device,
elantech_i2c_priv is already NULL so you don't need to free it.

> +       kfree(elantech_i2c_priv);
> +       return NULL;
> +}
> +
> +static int elantech_i2c_probe(struct i2c_client *client,
> +                             const struct i2c_device_id *dev_id)
> +
> +{
> +       int ret = 0;
> +       struct elantech_i2c *elantech_i2c_priv;
> +       unsigned int gpio;
> +
> +       if (!elantech_i2c_hw_init(client)) {
> +               ret = -EINVAL;
> +               goto err_hw_init;
> +       }
> +       elantech_i2c_priv = elantech_i2c_priv_create(client);
> +       if (!elantech_i2c_priv) {
> +               ret = -EINVAL;
> +               goto err_elantech_i2c_priv;
> +       }
> +
> +       ret = input_register_device(elantech_i2c_priv->input);
> +       if (ret < 0)
> +               goto err_input_register_device;
> +
> +       i2c_set_clientdata(client, elantech_i2c_priv);
> +       device_init_wakeup(&client->dev, 1);
> +
> +       return 0;
> +
> +err_input_register_device:
> +       gpio = elantech_i2c_priv->gpio;
> +       gpio_free(gpio);
> +       free_irq(elantech_i2c_priv->irq, elantech_i2c_priv);
> +       input_free_device(elantech_i2c_priv->input);
> +       kfree(elantech_i2c_priv);
> +err_elantech_i2c_priv:

Remove redundant label.

> +err_hw_init:
> +       return ret;
> +}
> +
> +static int elantech_i2c_remove(struct i2c_client *client)
> +{
> +       struct elantech_i2c *elantech_i2c_priv = i2c_get_clientdata(client);
> +
> +       if (elantech_i2c_priv) {
> +               if (elantech_i2c_priv->gpio > 0)
> +                       gpio_free(elantech_i2c_priv->gpio);
> +               free_irq(elantech_i2c_priv->irq, elantech_i2c_priv);
> +               input_unregister_device(elantech_i2c_priv->input);
> +               kfree(elantech_i2c_priv);
> +       }
> +
> +       return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int elantech_i2c_suspend(struct device *dev)
> +{
> +       struct i2c_client *client = to_i2c_client(dev);
> +
> +       if (device_may_wakeup(&client->dev))
> +               enable_irq_wake(client->irq);
> +
> +       return 0;
> +}
> +
> +static int elantech_i2c_resume(struct device *dev)
> +{
> +       struct i2c_client *client = to_i2c_client(dev);
> +
> +       if (device_may_wakeup(&client->dev))
> +               enable_irq_wake(client->irq);
> +
> +       return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(elan_i2c_touchpad_pm_ops,
> +               elantech_i2c_suspend, elantech_i2c_resume);
> +
> +static const struct i2c_device_id elantech_i2c_id_table[] = {
> +       { "elantech_i2c", 0 },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(i2c, elantech_i2c_id_table);
> +
> +static struct i2c_driver elantech_i2c_driver = {
> +       .driver = {
> +               .name   = DRIVER_NAME,
> +               .owner  = THIS_MODULE,
> +               .pm     = &elan_i2c_touchpad_pm_ops,
> +       },
> +       .probe          = elantech_i2c_probe,
> +       .remove         = __devexit_p(elantech_i2c_remove),
> +       .id_table       = elantech_i2c_id_table,
> +};
> +
> +static int __init elantech_i2c_init(void)
> +{
> +       return i2c_add_driver(&elantech_i2c_driver);
> +}
> +
> +static void __exit elantech_i2c_exit(void)
> +{
> +       i2c_del_driver(&elantech_i2c_driver);
> +}
> +
> +module_init(elantech_i2c_init);
> +module_exit(elantech_i2c_exit);
> +
> +MODULE_AUTHOR("Tom Lin (Lin Yen Yu) <tom_lin@emc.com.tw>");
> +MODULE_DESCRIPTION("Elan I2C Touch Pad driver");
> +MODULE_LICENSE("GPL");
> --
> 1.7.9.2
>
