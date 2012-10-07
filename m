Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2JGQ5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 12:57:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46674 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2JGQ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 12:57:37 -0400
MIME-Version: 1.0
In-Reply-To: <20121007162838.01f36b7c@endymion.delvare>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
	<20121007162838.01f36b7c@endymion.delvare>
Date: Sun, 7 Oct 2012 18:57:36 +0200
Message-ID: <CAN+gG=E3nmXZ9RL3wN2tvKqSOu5hWYLXLf+Z=ag7VvZGJfhQ-w@mail.gmail.com>
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification implementation
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jean,

many thanks for this detailed review. I agree to almost all of your
comments, so I didn't add an 'ok' after each remark.
This review will give me some work, but the driver will be much better.

On Sun, Oct 7, 2012 at 4:28 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Salut Benjamin,
>
> On Fri, 14 Sep 2012 15:41:43 +0200, benjamin.tissoires wrote:
>> From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>>
>> Microsoft published the protocol specification of HID over i2c:
>> http://msdn.microsoft.com/en-us/library/windows/hardware/hh852380.aspx
>>
>> This patch introduces an implementation of this protocol.
>>
>> This implementation does not includes the ACPI part of the specification.
>> This will come when ACPI 5.0 devices will be available.
>>
>> Once the ACPI part will be done, OEM will not have to declare HID over I2C
>> devices in their platform specific driver.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> ---
>>
>> Hi,
>>
>> this is finally my first implementation of HID over I2C.
>>
>> This has been tested on an Elan Microelectronics HID over I2C device, with
>> a Samsung Exynos 4412 board.
>>
>> Any comments are welcome.
>
> Code review follows. It is by no way meant to be complete, as I don't
> know a thing about HID. I hope you'll find it useful nevertheless.
>
>>
>> Cheers,
>> Benjamin
>>
>>  drivers/i2c/Kconfig         |    8 +
>>  drivers/i2c/Makefile        |    1 +
>>  drivers/i2c/i2c-hid.c       | 1027 +++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/i2c/i2c-hid.h |   35 ++
>>  4 files changed, 1071 insertions(+)
>>  create mode 100644 drivers/i2c/i2c-hid.c
>>  create mode 100644 include/linux/i2c/i2c-hid.h
>>
>> diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
>> index 5a3bb3d..5adf65a 100644
>> --- a/drivers/i2c/Kconfig
>> +++ b/drivers/i2c/Kconfig
>> @@ -47,6 +47,14 @@ config I2C_CHARDEV
>>         This support is also available as a module.  If so, the module
>>         will be called i2c-dev.
>>
>> +config I2C_HID
>> +     tristate "HID over I2C bus"
>
> You are definitely missing dependencies here, CONFIG_HID at least.
>
>> +     help
>> +       Say Y here to use the HID over i2c protocol implementation.
>> +
>> +       This support is also available as a module.  If so, the module
>> +       will be called i2c-hid.
>> +
>>  config I2C_MUX
>>       tristate "I2C bus multiplexing support"
>>       help
>> diff --git a/drivers/i2c/Makefile b/drivers/i2c/Makefile
>> index beee6b2..8f38116 100644
>> --- a/drivers/i2c/Makefile
>> +++ b/drivers/i2c/Makefile
>> @@ -6,6 +6,7 @@ obj-$(CONFIG_I2C_BOARDINFO)   += i2c-boardinfo.o
>>  obj-$(CONFIG_I2C)            += i2c-core.o
>>  obj-$(CONFIG_I2C_SMBUS)              += i2c-smbus.o
>>  obj-$(CONFIG_I2C_CHARDEV)    += i2c-dev.o
>> +obj-$(CONFIG_I2C_HID)                += i2c-hid.o
>>  obj-$(CONFIG_I2C_MUX)                += i2c-mux.o
>>  obj-y                                += algos/ busses/ muxes/
>>
>> diff --git a/drivers/i2c/i2c-hid.c b/drivers/i2c/i2c-hid.c
>> new file mode 100644
>> index 0000000..eb17d8c
>> --- /dev/null
>> +++ b/drivers/i2c/i2c-hid.c
>> @@ -0,0 +1,1027 @@
>> +/*
>> + * HID over I2C protocol implementation
>> + *
>> + * Copyright (c) 2012 Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> + * Copyright (c) 2012 Ecole Nationale de l'Aviation Civile, France
>> + *
>> + * This code is partly based on "USB HID support for Linux":
>> + *
>> + *  Copyright (c) 1999 Andreas Gal
>> + *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
>> + *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
>> + *  Copyright (c) 2007-2008 Oliver Neukum
>> + *  Copyright (c) 2006-2010 Jiri Kosina
>> + *
>> + * This file is subject to the terms and conditions of the GNU General Public
>> + * License.  See the file COPYING in the main directory of this archive for
>> + * more details.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/i2c.h>
>> +#include <linux/irq.h>
>
> I don't think you need to include that one, everything irq-related you
> need comes with <linux/interrupt.h> below. The header comment in that
> file actually says: "Please do not include this file in generic code."
>
>> +#include <linux/gpio.h>
>
> Your driver makes no use of GPIO.
>
>> +#include <linux/interrupt.h>
>> +#include <linux/input.h>
>> +#include <linux/delay.h>
>> +#include <linux/slab.h>
>> +#include <linux/pm.h>
>
> You are missing <linux/spinlock.h> for
> spin_lock_irq()/spin_unlock_irq(), <linux/device.h> for
> device_may_wakeup(), <linux/wait.h> for wait_event_timeout(),
> <linux/err.h> for IS_ERR(), <linux/string.h> for strcat()/memcpy(),
> <linux/list.h> for list_for_each_entry() and <linux/jiffies.h> for
> msecs_to_jiffies(). I'd suggest including <linux/kernel.h> as well, for
> sprintf() if nothing else, and <linux/bug.h> for WARN_ON().

It seems like I've been to lazy with the includes... Thanks!

>
>> +
>> +#include <linux/i2c/i2c-hid.h>
>> +
>> +#include <linux/hid.h>
>> +#include <linux/hiddev.h>
>> +#include <linux/hidraw.h>
>
> I don't think you using anything from <linux/hidraw.h>, do you?

oops...

>
>> +
>> +#define DRIVER_NAME          "i2chid"
>> +#define DRIVER_DESC          "HID over I2C core driver"
>
> I see little interest in this define, as you're only using it once.
> Even DRIVER_NAME isn't so useful, 2 of the 3 occurrences would be
> replaced with client->name.&
>
>> +
>> +#define I2C_HID_COMMAND_TRIES        3
>> +
>> +/* flags */
>> +#define I2C_HID_STARTED              (1 << 0)
>> +#define I2C_HID_OUT_RUNNING  (1 << 1)
>> +#define I2C_HID_IN_RUNNING   (1 << 2)
>> +#define I2C_HID_RESET_PENDING        (1 << 3)
>> +#define I2C_HID_SUSPENDED    (1 << 4)
>
> 3 of these are never used, so why define them?

This seems to came out from the different pre-releases of the patch.
I'll have a look at them and keep the right ones.

>
>> +
>> +#define I2C_HID_PWR_ON               0x00
>> +#define I2C_HID_PWR_SLEEP    0x01
>> +
>> +/* debug option */
>> +static bool debug = false;
>
> checkpatch.pl says:
>
> ERROR: do not initialise statics to 0 or NULL
> #206: FILE: drivers/i2c/i2c-hid.c:52:
> +static bool debug = false;

Yep, I saw that, but I was not confident in putting this option
uninitialized. I think it's better to keep it initialized.
However, I'll see if I keep it at the end with the refactoring of the
debug system.

>
>
>> +module_param(debug, bool, 0444);
>> +MODULE_PARM_DESC(debug, "print a lot of debug informations");
>
> Spelling: information (in English, "information" is already a plural.)
>
>> +
>> +struct i2chid_desc {
>> +     __le16 wHIDDescLength;
>> +     __le16 bcdVersion;
>> +     __le16 wReportDescLength;
>> +     __le16 wReportDescRegister;
>> +     __le16 wInputRegister;
>> +     __le16 wMaxInputLength;
>> +     __le16 wOutputRegister;
>> +     __le16 wMaxOutputLength;
>> +     __le16 wCommandRegister;
>> +     __le16 wDataRegister;
>> +     __le16 wVendorID;
>> +     __le16 wProductID;
>> +     __le16 wVersionID;
>> +} __packed;
>> +
>> +struct i2chid_cmd {
>> +     enum {
>> +             /* fecth HID descriptor */
>
> Typo: fetch
>
>> +             HID_DESCR_CMD,
>> +
>> +             /* fetch report descriptors */
>> +             HID_REPORT_DESCR_CMD,
>> +
>> +             /* commands */
>> +             HID_RESET_CMD,
>> +             HID_GET_REPORT_CMD,
>> +             HID_SET_REPORT_CMD,
>> +             HID_GET_IDLE_CMD,
>> +             HID_SET_IDLE_CMD,
>> +             HID_GET_PROTOCOL_CMD,
>> +             HID_SET_PROTOCOL_CMD,
>> +             HID_SET_POWER_CMD,
>> +
>> +             /* read/write data register */
>> +             HID_DATA_CMD,
>> +     } name;
>> +     unsigned int registerIndex;
>> +     __u8 opcode;
>> +     unsigned int length;
>> +     bool wait;
>> +};
>> +
>> +union command {
>> +     u8 data[0];
>> +     struct cmd {
>> +             __le16 reg;
>> +             __u8 reportTypeID;
>> +             __u8 opcode;
>> +     } __packed c;
>> +};
>> +
>> +#define I2C_HID_CMD(name_, opcode_) \
>> +     .name = name_, .opcode = opcode_, .length = 4, \
>> +     .registerIndex = offsetof(struct i2chid_desc, wCommandRegister)
>> +
>> +static const struct i2chid_cmd cmds[] = {
>> +     { I2C_HID_CMD(HID_RESET_CMD,            0x01), .wait = true },
>> +     { I2C_HID_CMD(HID_GET_REPORT_CMD,       0x02) },
>> +     { I2C_HID_CMD(HID_SET_REPORT_CMD,       0x03) },
>> +     { I2C_HID_CMD(HID_GET_IDLE_CMD,         0x04) },
>> +     { I2C_HID_CMD(HID_SET_IDLE_CMD,         0x05) },
>> +     { I2C_HID_CMD(HID_GET_PROTOCOL_CMD,     0x06) },
>> +     { I2C_HID_CMD(HID_SET_PROTOCOL_CMD,     0x07) },
>> +     { I2C_HID_CMD(HID_SET_POWER_CMD,        0x08) },
>> +
>> +     {.name = HID_DESCR_CMD,
>> +      .length = 2},
>> +
>> +     {.name = HID_REPORT_DESCR_CMD,
>> +      .registerIndex = offsetof(struct i2chid_desc, wReportDescRegister),
>> +      .opcode = 0x00,
>> +      .length = 2},
>> +
>> +     {.name = HID_DATA_CMD,
>> +      .registerIndex = offsetof(struct i2chid_desc, wDataRegister),
>> +      .opcode = 0x00,
>> +      .length = 2},
>
> Please use consistent spacing.
>
>> +
>> +     {}, /* terminating */
>
> I suspect it would be more efficient to not terminate the array and use
> ARRAY_SIZE() when needed.
>
>> +};
>> +
>> +/* The main device structure */
>> +struct i2chid {
>> +     struct i2c_client       *client;        /* i2c client */
>> +     struct hid_device       *hid;   /* pointer to corresponding HID dev */
>> +     union {
>> +             __u8 hdesc_buffer[sizeof(struct i2chid_desc)];
>> +             struct i2chid_desc hdesc;       /* the HID Descriptor */
>> +     };
>> +     __le16                  wHIDDescRegister; /* location of the i2c
>> +                                                * register of the HID
>> +                                                * descriptor. */
>> +     unsigned int            bufsize;        /* i2c buffer size */
>> +     char                    *inbuf;         /* Input buffer */
>> +
>> +     spinlock_t              flock;          /* flags spinlock */
>> +     unsigned long           flags;          /* device flags */
>> +
>> +     int                     irq;            /* the interrupt line irq */
>> +
>> +     wait_queue_head_t       wait;           /* For waiting the interrupt */
>> +};
>> +
>> +void i2chid_print_buffer(struct i2chid *ihid, u8 *buf, unsigned int n)
>
> Should be static and buf should be declared const.
>
>> +{
>> +     int i;
>> +     char *string = kzalloc((n*3+1)*sizeof(char), GFP_KERNEL);
>
> This could fail, you have to check for it.
>
>> +     char tmpbuf[4] = "";
>
> Useless initialization.
>
>> +
>> +     for (i = 0; i < n; ++i) {
>> +             sprintf(tmpbuf, "%02x ", buf[i] & 0xFF);
>
> Useless mask.
>
>> +             strcat(string, tmpbuf);
>> +     }
>> +
>> +     dev_err(&ihid->client->dev, "%s\n", string);
>> +     kfree(string);
>> +}
>
> This is horribly inefficient. I don't know what usual value you expect
> for "n", but the above algorithm has a O(n^2) complexity for no good
> reason. As a rule of thumb, every time you use strcat() in a loop, you
> can be sure you did something wrong ;)
>
> The efficient way of doing the above is to remember where you are in
> the output buffer, and sprintf at this location directly:
>
>         int i;
>         char *string = kzalloc((n*3+1)*sizeof(char), GFP_KERNEL);
>         char *p = string;
>
>         for (i = 0; i < n; ++i)
>                 p += sprintf(p, "%02x ", buf[i]);
>
> I would also suggest that you put some introduction work in the log
> message, otherwise it looks like mere garbage. Doing so will also give
> you the opportunity to put the spaces before the numbers rather than
> after them, so you don't print a useless trailing space.

This is all right and I appreciate the explanations.
Nevertheless, Dmitry proposed a much better way to write my debugging
outputs with dev_XXX(&ihid->client->dev, "%*ph\n", n, buf); No sprintf
required anymore.

>
>> +
>> +static int __i2chid_command(struct i2c_client *client, int command, u8 reportID,
>> +             u8 reportType, u8 *args, int args_len,
>> +             unsigned char *buf_recv, int data_len)
>> +{
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +     union command *cmd;
>> +     unsigned char *rec_buf = buf_recv;
>
> Useless variable, use buf_recv directly.
>
>> +     int ret;
>> +     int tries = I2C_HID_COMMAND_TRIES;
>> +     int length = 0;
>> +     struct i2c_msg msg[2];
>> +     int msg_num = 0;
>> +     int i;
>> +     bool wait = false;
>> +
>> +     if (WARN_ON(!ihid))
>> +             return -ENODEV;
>> +
>> +     cmd = kmalloc(args_len + sizeof(union command), GFP_KERNEL);
>
> Your intent would be clearer with sizeof(union command) + args_len.
> Also, what excuse do you have for not using kzalloc?

None.... :-(
And above all, I think I have already been confronted to the problem
of a non-filled buffer with almost good values.

>
>> +     if (!cmd)
>> +             return -ENOMEM;
>> +
>> +     for (i = 0; cmds[i].length; i++) {
>> +             unsigned int registerIndex;
>> +
>> +             if (cmds[i].name != command)
>> +                     continue;
>> +
>> +             registerIndex = cmds[i].registerIndex;
>> +             cmd->data[0] = ihid->hdesc_buffer[registerIndex];
>> +             cmd->data[1] = ihid->hdesc_buffer[registerIndex + 1];
>> +             cmd->c.opcode = cmds[i].opcode;
>> +             length = cmds[i].length;
>> +             wait = cmds[i].wait;
>> +     }
>
> This again is horribly inefficient. Just order the commands properly in
> cmds[] and you can access them by index. This will be much faster.
>
>> +
>> +     /* special case for HID_DESCR_CMD */
>> +     if (command == HID_DESCR_CMD)
>> +             cmd->c.reg = ihid->wHIDDescRegister;
>> +
>> +     cmd->c.reportTypeID = reportID | reportType << 4;
>> +
>> +     memcpy(cmd->data + length, args, args_len);
>> +     length += args_len;
>> +
>> +     if (debug) {
>> +             char tmpstr[4] = "";
>> +             char strbuf[50] = "";
>> +             int i;
>> +             for (i = 0; i < length; i++) {
>> +                     sprintf(tmpstr, "%02x ", cmd->data[i] & 0xFF);
>> +                     strcat(strbuf, tmpstr);
>> +             }
>> +             dev_err(&client->dev, "%s, cmd=%s\n", __func__, strbuf);
>> +     }
>
> AFAICS this is mostly duplicating i2chid_print_buffer().
>
>> +
>> +     msg[0].addr = client->addr;
>> +     msg[0].flags = client->flags & I2C_M_TEN;
>> +     msg[0].len = length;
>> +     msg[0].buf = (char *) cmd->data;
>
> Useless cast.
>
>> +     msg[1].addr = client->addr;
>> +     msg[1].flags = client->flags & I2C_M_TEN;
>> +     msg[1].flags |= I2C_M_RD;
>> +     msg[1].len = data_len;
>> +     msg[1].buf = rec_buf;
>> +
>> +     msg_num = data_len > 0 ? 2 : 1;
>
> If !data_len you have been initializing 4 fields for nothing right
> above. Test first and you'll make your code faster for that specific
> case.
>
>> +
>> +     if (wait) {
>> +             spin_lock_irq(&ihid->flock);
>> +             set_bit(I2C_HID_RESET_PENDING, &ihid->flags);
>> +             spin_unlock_irq(&ihid->flock);
>> +     }
>> +
>> +     do {
>> +             ret = i2c_transfer(client->adapter, msg, msg_num);
>> +             if (ret > 0)
>
> Success here is ret == msg_num, not ret > 0.
>
>> +                     break;
>> +             tries--;
>> +             dev_dbg(&client->dev, "retrying i2chid_command:%d (%d)\n",
>> +                     command, tries);
>> +     } while (tries > 0);
>> +
>> +     if (wait && ret > 0) {
>> +             if (debug)
>> +                     dev_err(&client->dev, "%s: waiting....\n", __func__);
>
> Ellipsis is usually 3 dots not 4.
>
>> +             if (!wait_event_timeout(ihid->wait,
>> +                             !test_bit(I2C_HID_RESET_PENDING, &ihid->flags),
>> +                             msecs_to_jiffies(5000)))
>> +                     ret = -ENODATA;
>> +             if (debug)
>> +                     dev_err(&client->dev, "%s: finished.\n", __func__);
>> +     }
>> +
>> +     kfree(cmd);
>> +
>> +     return ret > 0 ? ret != msg_num : ret;
>
> Makes no sense to me. You should return 0 if ret == msg_num, and a
> negative error code otherwise.
>
>> +}
>> +
>> +static int i2chid_command(struct i2c_client *client, int command,
>> +             unsigned char *buf_recv, int data_len)
>> +{
>> +     return __i2chid_command(client, command, 0, 0, NULL, 0,
>> +                             buf_recv, data_len);
>> +}
>> +
>> +static int i2chid_get_report(struct i2c_client *client, u8 reportType,
>> +             u32 reportID, unsigned char *buf_recv, int data_len)
>> +{
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +     u8 args[6];
>> +     int ret;
>> +     int args_len = 0;
>> +     u16 readRegister = ihid->hdesc.wDataRegister;
>
> This is missing le16_to_cpu().

I agree this is awful, but not putting it allows me to not have to
check the endianness when I'm using it.
But I may be totally wrong on this.

>
>> +
>> +     if (debug)
>> +             dev_err(&client->dev, "%s\n", __func__);
>> +
>> +     if (reportID >= 15) {
>
> Mixing decimal and hexadecimal is confusing.
>
>> +             args[args_len++] = (reportID >> 0) & 0xFF;
>> +             args[args_len++] = (reportID >> 8) & 0xFF;
>> +             args[args_len++] = (reportID >> 16) & 0xFF;
>> +             args[args_len++] = (reportID >> 24) & 0xFF;
>> +             reportID = 0x0F;
>> +     }
>> +
>> +     args[args_len++] = readRegister & 0xff;
>> +     args[args_len++] = (readRegister >> 8) & 0xff;
>
> Useless mask. Please also use consistent case for hexadecimal values.
>
>> +
>> +     ret = __i2chid_command(client, HID_GET_REPORT_CMD, reportID & 0x0F,
>
> Useless mask.
>
>> +             reportType, args, args_len, buf_recv, data_len);
>> +     if (ret) {
>> +             dev_err(&client->dev, "HID_GET_REPORT_CMD Fail\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int i2chid_set_report(struct i2c_client *client, u8 reportType,
>> +             u32 reportID, unsigned char *buf, int data_len)
>> +{
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +     u8 *args;
>> +     int ret;
>> +     u16 dataRegister = ihid->hdesc.wDataRegister;
>
> Missing conversion again.
>
>> +     int args_len =  (reportID >= 15 ? 4 : 0) +
>> +                     2 /* dataRegister */ +
>> +                     2 /* size */ +
>
> /* data_len */ actually.
>
>> +                     data_len;
>> +     int index = 0;
>> +
>> +     if (debug)
>> +             dev_err(&client->dev, "%s\n", __func__);
>> +
>> +     args = kmalloc(args_len, GFP_KERNEL);
>
> This should be kzalloc() and you should check for failure.
>
>> +
>> +     if (reportID >= 15) {
>> +             args[index++] = (reportID >> 0) & 0xFF;
>> +             args[index++] = (reportID >> 8) & 0xFF;
>> +             args[index++] = (reportID >> 16) & 0xFF;
>> +             args[index++] = (reportID >> 24) & 0xFF;
>> +             reportID = 0x0F;
>> +     }
>> +
>> +     args[index++] = dataRegister & 0xff;
>> +     args[index++] = (dataRegister >> 8) & 0xff;
>> +
>> +     args[index++] = data_len & 0xff;
>> +     args[index++] = (data_len >> 8) & 0xff;
>
> data_len is an int, there's no guarantee it fits on 2 bytes.
>
>> +
>> +     memcpy(&args[index], buf, data_len);
>> +
>> +     ret = __i2chid_command(client, HID_SET_REPORT_CMD, reportID & 0x0F,
>> +             reportType, args, args_len, NULL, 0);
>> +     if (ret) {
>> +             dev_err(&client->dev, "HID_SET_REPORT_CMD Fail\n");
>
> Memory leak!

ouch

>
>> +             return -EINVAL;
>> +     }
>> +
>> +     kfree(args);
>> +     return data_len;
>> +}
>> +
>> +static int i2chid_set_power(struct i2c_client *client, int power_state)
>> +{
>> +     int ret;
>> +
>> +     if (debug)
>> +             dev_err(&client->dev, "%s\n", __func__);
>> +
>> +     ret = __i2chid_command(client, HID_SET_POWER_CMD, power_state & 0x01,
>
> Useless mask.
>
>> +             0, NULL, 0, NULL, 0);
>> +     if (ret) {
>> +             dev_err(&client->dev, "HID_SET_POWER_CMD Fail\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int i2chid_hwreset(struct i2c_client *client)
>> +{
>> +     uint8_t buf_recv[79];
>
> Why uint8_t here when you used unsigned char everywhere else? Why 79
> when you only need 2 bytes?

This may comes from the device I have which sends input reports of 78
or 79 length... Useless.

>
>> +     int ret;
>> +
>> +     if (debug)
>> +             dev_err(&client->dev, "%s\n", __func__);
>> +
>> +     ret = i2chid_set_power(client, I2C_HID_PWR_ON);
>> +     if (ret)
>> +             return -EINVAL;
>> +
>> +     if (debug)
>> +             dev_err(&client->dev, "resetting...\n");
>> +
>> +     ret = i2chid_command(client, HID_RESET_CMD, buf_recv, 0);
>
> I don't see the point of passing buf_recv here.
>
>> +     if (ret) {
>> +             dev_err(&client->dev, "HID_RESET_CMD Fail\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     ret = i2c_master_recv(client, buf_recv, 2);
>> +     if (ret != 2 || (buf_recv[0] != 0 && buf_recv[1] != 0)) {
>
> If I read the datasheet correctly, the device must reply with two 0
> bytes after reset, so the above test is wrong, it should be
> buf_recv[0] != 0 || buf_recv[1] != 0 (||, not &&.)
>
>> +             dev_err(&client->dev,
>> +                     "HID_RESET_CMD Failed: got %02x %02x, size=%d\n",
>> +                     buf_recv[0], buf_recv[1], ret);
>
> If size < 2, you are printing uninitialized bytes from the stack, which
> is bad.
>
>> +
>> +             i2chid_set_power(client, I2C_HID_PWR_SLEEP);
>> +             return -EINVAL;
>> +     }
>> +     return 0;
>> +}
>> +
>> +static bool i2chid_get_input(struct i2chid *ihid)
>
> Very confusing return convention, given that every other function in
> this driver returns 0 on success.
>
>> +{
>> +     int ret;
>> +     int size = ihid->hdesc.wMaxInputLength;
>
> Missing conversion.
>
>> +
>> +     ret = i2c_master_recv(ihid->client, ihid->inbuf, size);
>> +     if (ret != size) {
>> +             dev_err(&ihid->client->dev, "%s: got %d data instead of %d\n",
>> +                     __func__, ret, size);
>> +             return false;
>> +     }
>> +
>> +     if (debug)
>> +             i2chid_print_buffer(ihid, ihid->inbuf, size);
>> +
>> +     ret = hid_input_report(ihid->hid, HID_INPUT_REPORT, ihid->inbuf + 2,
>> +                     size - 2, 1);
>> +     if (ret)
>> +             return false;
>> +
>> +     return true;
>> +}
>> +
>> +static irqreturn_t i2chid_irq(int irq, void *dev_id)
>> +{
>> +     struct i2chid *ihid = dev_id;
>> +     int ready;
>> +
>> +     if (!ihid)
>> +             return IRQ_HANDLED;
>
> You'll have to explain that one to me. This just can't happen, can it?

Yep, this can't happen. Dmitry already spot it.

>
>> +
>> +     spin_lock_irq(&ihid->flock);
>> +     if (test_and_clear_bit(I2C_HID_RESET_PENDING, &ihid->flags)) {
>> +             spin_unlock_irq(&ihid->flock);
>> +
>> +             wake_up(&ihid->wait);
>> +             return IRQ_HANDLED;
>> +     }
>> +
>> +     ready = test_bit(I2C_HID_STARTED, &ihid->flags);
>> +     spin_unlock_irq(&ihid->flock);
>> +
>> +     if (ready)
>> +             i2chid_get_input(ihid);
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static int i2chid_get_report_length(struct hid_report *report)
>> +{
>> +     return ((report->size - 1) >> 3) + 1 +
>> +             report->device->report_enum[report->type].numbered + 2;
>> +}
>> +
>> +void i2chid_init_report(struct hid_report *report)
>
> Should be static.
>
>> +{
>> +     struct hid_device *hid = report->device;
>> +     struct i2c_client *client = hid->driver_data;
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +     unsigned int size, ret_size;
>> +
>> +     size = i2chid_get_report_length(report);
>> +     i2chid_get_report(client,
>> +                     report->type == HID_FEATURE_REPORT ? 0x03 : 0x01,
>> +                     report->id, ihid->inbuf, size);
>> +
>> +     if (debug)
>> +             i2chid_print_buffer(ihid, ihid->inbuf, size);
>> +
>> +     ret_size = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
>> +
>> +     if (ret_size != size) {
>> +             dev_err(&client->dev, "error in %s size:%d / ret_size:%d\n",
>> +                     __func__, size, ret_size);
>> +             return;
>> +     }
>> +
>> +     /* hid->driver_lock is held as we are in probe function,
>> +      * we just need to setup the input fields, so using
>> +      * hid_report_raw_event is safe. */
>> +     hid_report_raw_event(hid, report->type, ihid->inbuf + 2, size - 2, 1);
>> +}
>> +
>> +/*
>> + * Initialize all reports
>> + */
>> +void i2chid_init_reports(struct hid_device *hid)
>
> Should be static.
>
>> +{
>> +     struct hid_report *report;
>> +
>> +     list_for_each_entry(report,
>> +             &hid->report_enum[HID_INPUT_REPORT].report_list, list)
>> +             i2chid_init_report(report);
>> +
>> +     list_for_each_entry(report,
>> +             &hid->report_enum[HID_FEATURE_REPORT].report_list, list)
>> +             i2chid_init_report(report);
>> +}
>> +
>> +/*
>> + * Traverse the supplied list of reports and find the longest
>> + */
>> +static void i2chid_find_max_report(struct hid_device *hid, unsigned int type,
>> +             unsigned int *max)
>> +{
>> +     struct hid_report *report;
>> +     unsigned int size;
>> +
>> +     /* We should not rely on wMaxInputLength, as some devices may set it to
>> +      * a wrong length. */
>> +     list_for_each_entry(report, &hid->report_enum[type].report_list, list) {
>> +             size = i2chid_get_report_length(report);
>> +             if (*max < size)
>> +                     *max = size;
>> +     }
>> +}
>> +
>> +static int i2chid_alloc_buffers(struct i2chid *ihid)
>> +{
>> +     ihid->inbuf = kzalloc(ihid->bufsize, GFP_KERNEL);
>> +
>> +     if (!ihid->inbuf)
>> +             return -1;
>
> -ENOMEM would be much cleaner.
>
>> +
>> +     return 0;
>> +}
>> +
>> +static void i2chid_free_buffers(struct i2chid *ihid)
>> +{
>> +     kfree(ihid->inbuf);
>> +}
>> +
>> +static int i2chid_get_raw_report(struct hid_device *hid,
>> +             unsigned char report_number, __u8 *buf, size_t count,
>> +             unsigned char report_type)
>> +{
>> +     struct i2c_client *client = hid->driver_data;
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +     int ret;
>> +
>> +     if (count > ihid->bufsize)
>> +             count = ihid->bufsize;
>> +
>> +     ret = i2chid_get_report(client,
>> +                     report_type == HID_FEATURE_REPORT ? 0x03 : 0x01,
>> +                     report_number, ihid->inbuf, count);
>> +
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     count = ihid->inbuf[0] | (ihid->inbuf[1] << 8);
>> +
>> +     memcpy(buf, ihid->inbuf + 2, count);
>> +
>> +     return count;
>> +}
>> +
>> +static int i2chid_output_raw_report(struct hid_device *hid, __u8 *buf,
>> +             size_t count, unsigned char report_type)
>> +{
>> +     struct i2c_client *client = hid->driver_data;
>> +     int ret;
>> +     int report_id = buf[0];
>> +
>> +     ret = i2chid_set_report(client,
>> +                             report_type == HID_FEATURE_REPORT ? 0x03 : 0x01,
>> +                             report_id, buf, count);
>> +
>> +     return ret;
>> +
>> +}
>> +
>> +static int i2chid_fetch_hid_descriptor(struct i2chid *ihid)
>
> Only called in probe function, so can be __devinit. It would be better
> to place both functions close to each other BTW.
>
>> +{
>> +     struct i2c_client *client = ihid->client;
>> +     struct i2chid_desc *hdesc = &ihid->hdesc;
>> +     unsigned int dsize = 0;
>
> Useless initialization.
>
>> +     int ret;
>> +
>> +     /* Fetch the length of HID description, retrieve the 4 first bytes:
>> +      * bytes 0-1 -> length
>> +      * bytes 2-3 -> bcdVersion (has to be 1.00) */
>> +     ret = i2chid_command(client, HID_DESCR_CMD, ihid->hdesc_buffer, 4);
>> +
>> +     if (debug)
>> +             dev_err(&client->dev,
>> +                     "%s, ihid->hdesc_buffer: %02x %02x %02x %02x\n",
>> +                     __func__,
>> +                     ihid->hdesc_buffer[0],
>> +                     ihid->hdesc_buffer[1],
>> +                     ihid->hdesc_buffer[2],
>> +                     ihid->hdesc_buffer[3]);
>> +
>> +     if (ret) {
>> +             dev_err(&client->dev, "HID_DESCR_LENGTH_CMD Fail (ret=%d)\n",
>> +                     ret);
>> +             return -EINVAL;
>
> These should all be -ENODEV in this function: the device isn't what you
> expected. EINVAL is for invalid argument.
>
>> +     }
>> +
>> +     dsize = le16_to_cpu(hdesc->wHIDDescLength);
>> +     if (!dsize || dsize > HID_MAX_DESCRIPTOR_SIZE) {
>> +             dev_err(&client->dev, "weird size of HID descriptor (%u)\n",
>> +                     dsize);
>> +             return -EINVAL;
>> +     }
>> +
>> +     /* check bcdVersion == 1.0 */
>> +     if (le16_to_cpu(hdesc->bcdVersion) != 0x0100) {
>> +             dev_err(&client->dev,
>> +                     "unexpected HID descriptor bcdVersion (0x%04x)\n",
>> +                     le16_to_cpu(hdesc->bcdVersion));
>
> So, the day revision 1.1 comes out and a device implements it, it won't
> be supported, even if revision 1.1 only made minor changes we can live
> without. Is it smart?

Smart, maybe not. But if the 1.1 made minor changes in the HID
descriptor by moving fields, we may end with many surprises.
As we have no guarantees on what will be that norm, I'd rather wait
for it to come out and make a small patch that eventually allows it.

I agree that if we have much guarantees from Microsoft that they won't
break backward compatibility, we could just raise a  warning and
continue.
But as long as the standard is published by Microsoft, lead by
Microsoft and that the only 'valid' implementation is maintained by
Microsoft, I'd rather not bet on the future.

BTW, this is my only opinion, and ifpeople think we can continue if
the bcd version is not 1.00, I'm fine with it.

>
>> +             return -EINVAL;
>> +     }
>> +
>> +     if (debug)
>> +             dev_err(&client->dev, "Fetching the HID descriptor\n");
>> +
>> +     ret = i2chid_command(client, HID_DESCR_CMD, ihid->hdesc_buffer, dsize);
>> +     if (ret) {
>> +             dev_err(&client->dev, "HID_DESCR_CMD Fail\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     if (debug)
>> +             i2chid_print_buffer(ihid, ihid->hdesc_buffer, dsize);
>> +
>> +     return 0;
>> +}
>> +
>> +static int i2chid_parse(struct hid_device *hid)
>> +{
>> +     struct i2c_client *client = hid->driver_data;
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +     struct i2chid_desc *hdesc = &ihid->hdesc;
>> +     unsigned int rsize = 0;
>
> Useless initialization.
>
>> +     char *rdesc;
>> +     int ret;
>> +     int tries = 3;
>> +
>> +     if (debug)
>> +             dev_err(&client->dev, "entering %s\n", __func__);
>> +
>> +     rsize = le16_to_cpu(hdesc->wReportDescLength);
>> +     if (!rsize || rsize > HID_MAX_DESCRIPTOR_SIZE) {
>> +             dbg_hid("weird size of report descriptor (%u)\n", rsize);
>> +             return -EINVAL;
>> +     }
>> +
>> +     do {
>> +             ret = i2chid_hwreset(client);
>> +             if (ret)
>> +                     msleep(1000);
>> +     } while (tries-- > 0 && ret);
>> +
>> +     if (ret)
>> +             return ret;
>> +
>> +     rdesc = kmalloc(rsize, GFP_KERNEL);
>> +
>> +     if (!rdesc) {
>> +             dbg_hid("couldn't allocate rdesc memory\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     if (debug)
>> +             dev_err(&client->dev, "asking HID report descriptor\n");
>> +
>> +     ret = i2chid_command(client, HID_REPORT_DESCR_CMD, rdesc, rsize);
>> +     if (ret) {
>> +             hid_err(hid, "reading report descriptor failed\n");
>> +             kfree(rdesc);
>> +             ret = -ENOMEM;
>
> No.
>
>> +             goto err;
>> +     }
>> +
>> +     if (debug)
>> +             i2chid_print_buffer(ihid, rdesc, rsize);
>> +
>> +     ret = hid_parse_report(hid, rdesc, rsize);
>> +     kfree(rdesc);
>> +     if (ret) {
>> +             dbg_hid("parsing report descriptor failed\n");
>> +             goto err;
>> +     }
>> +
>> +     return 0;
>> +err:
>> +     return ret;
>
> This label makes no sense, just replace gotos by returns.
>
>> +}
>> +
>> +static int i2chid_start(struct hid_device *hid)
>> +{
>> +     struct i2c_client *client = hid->driver_data;
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +     int ret;
>> +
>> +     ihid->bufsize = HID_MIN_BUFFER_SIZE;
>> +     i2chid_find_max_report(hid, HID_INPUT_REPORT, &ihid->bufsize);
>> +     i2chid_find_max_report(hid, HID_OUTPUT_REPORT, &ihid->bufsize);
>> +     i2chid_find_max_report(hid, HID_FEATURE_REPORT, &ihid->bufsize);
>> +
>> +     if (ihid->bufsize > HID_MAX_BUFFER_SIZE)
>> +             ihid->bufsize = HID_MAX_BUFFER_SIZE;
>
> Won't this result in issues later?

By re-reading the code, yes. I will change it.

>
>> +
>> +     if (i2chid_alloc_buffers(ihid)) {
>> +             ret = -ENOMEM;
>> +             goto fail;
>> +     }
>> +
>> +     if (!(hid->quirks & HID_QUIRK_NO_INIT_REPORTS))
>> +             i2chid_init_reports(hid);
>> +
>> +     return 0;
>> +
>> +fail:
>> +     i2chid_free_buffers(ihid);
>
> This is wrong, you're freeing buffers you failed to allocate.

ouch

>
>> +     return ret;
>> +}
>> +
>> +static void i2chid_stop(struct hid_device *hid)
>> +{
>> +     struct i2c_client *client = hid->driver_data;
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +
>> +     if (WARN_ON(!ihid))
>> +             return;
>> +
>> +     hid->claimed = 0;
>> +
>> +     i2chid_free_buffers(ihid);
>> +}
>> +
>> +static int i2chid_open(struct hid_device *hid)
>> +{
>> +     struct i2c_client *client = hid->driver_data;
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +     int ret;
>> +
>> +     if (!hid->open++) {
>> +             ret = i2chid_set_power(client, I2C_HID_PWR_ON);
>> +             if (ret) {
>> +                     hid->open--;
>> +                     return -EIO;
>> +             }
>> +             spin_lock_irq(&ihid->flock);
>> +             set_bit(I2C_HID_STARTED, &ihid->flags);
>> +             spin_unlock_irq(&ihid->flock);
>> +     }
>> +     return 0;
>> +}
>> +
>> +static void i2chid_close(struct hid_device *hid)
>> +{
>> +     struct i2c_client *client = hid->driver_data;
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +
>> +     /* protecting hid->open to make sure we don't restart
>> +      * data acquistion due to a resumption we no longer
>> +      * care about
>> +      */
>> +     if (!--hid->open) {
>> +             spin_lock_irq(&ihid->flock);
>> +             clear_bit(I2C_HID_STARTED, &ihid->flags);
>> +             spin_unlock_irq(&ihid->flock);
>> +
>> +             /* Save some power */
>> +             i2chid_set_power(client, I2C_HID_PWR_SLEEP);
>> +     }
>> +}
>> +
>> +static int i2chid_power(struct hid_device *hid, int lvl)
>> +{
>> +     struct i2c_client *client = hid->driver_data;
>> +     int r = 0;
>
> Why not "ret" like everywhere else?
>
>> +
>> +     if (debug)
>> +             dev_err(&client->dev, "%s lvl:%d\n", __func__, lvl);
>> +
>> +     switch (lvl) {
>> +     case PM_HINT_FULLON:
>> +             r = i2chid_set_power(client, I2C_HID_PWR_ON);
>> +             break;
>> +     case PM_HINT_NORMAL:
>> +             r = i2chid_set_power(client, I2C_HID_PWR_SLEEP);
>> +             break;
>> +     }
>> +     return r;
>> +}
>> +
>> +static int i2chid_hidinput_input_event(struct input_dev *dev, unsigned int type,
>> +             unsigned int code, int value)
>> +{
>> +     struct hid_device *hid = input_get_drvdata(dev);
>> +     struct hid_field *field;
>> +     int offset;
>> +
>> +     if (type == EV_FF)
>> +             return input_ff_event(dev, type, code, value);
>> +
>> +     if (type != EV_LED)
>> +             return -1;
>> +
>> +     offset = hidinput_find_field(hid, type, code, &field);
>> +
>> +     if (offset == -1) {
>> +             hid_warn(dev, "event field not found\n");
>> +             return -1;
>> +     }
>> +
>> +     hid_set_field(field, offset, value);
>> +
>> +     return 0;
>> +}
>> +
>> +static struct hid_ll_driver i2c_hid_driver = {
>> +     .parse = i2chid_parse,
>> +     .start = i2chid_start,
>> +     .stop = i2chid_stop,
>> +     .open = i2chid_open,
>> +     .close = i2chid_close,
>> +     .power = i2chid_power,
>> +     .hidinput_input_event = i2chid_hidinput_input_event,
>> +};
>> +
>> +static int i2chid_init_irq(struct i2c_client *client)
>
> Can be __devinit.
>
>> +{
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +     int rc;
>
> Why not "ret" like everywhere else?
>
>> +
>> +     dev_dbg(&client->dev, "Requesting IRQ: %d\n",
>> +             client->irq);
>> +
>> +     rc = request_threaded_irq(client->irq, NULL, i2chid_irq,
>> +                     IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>> +                     DRIVER_NAME, ihid);
>> +     if (rc < 0) {
>> +             dev_dbg(&client->dev,
>> +                     "Could not register for %s interrupt, irq = %d,"
>> +                     " rc = %d\n",
>> +             DRIVER_NAME, client->irq, rc);
>> +
>> +             return rc;
>> +     }
>> +
>> +     return client->irq;
>> +}
>> +
>> +static int __devinit i2chid_probe(struct i2c_client *client,
>> +             const struct i2c_device_id *dev_id)
>> +{
>> +     int ret;
>> +     struct i2chid *ihid;
>> +     struct hid_device *hid;
>> +     __u16 hidRegister;
>
> You don't need this local variable.
>
>> +     unsigned char tmpstr[11];
>> +     struct i2chid_platform_data *platform_data = client->dev.platform_data;
>> +
>> +     dbg_hid("HID probe called for i2c %d\n", client->addr);
>
> I2C addresses are traditionally printed as hexadecimal values.
>
>> +
>> +     if (!platform_data) {
>> +             dev_err(&client->dev, "HID register address not provided\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     if (client->irq < 1) {
>> +             dev_err(&client->dev,
>> +                     "HID over i2c has not been provided an Int IRQ\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     ihid = kzalloc(sizeof(struct i2chid), GFP_KERNEL);
>> +     if (!ihid)
>> +             return -ENOMEM;
>> +
>> +     i2c_set_clientdata(client, ihid);
>> +
>> +     ihid->client = client;
>> +     ihid->flags = 0;
>
> flags are already 0 thanks to kzalloc.
>
>> +
>> +     hidRegister = platform_data->hid_descriptor_address;
>> +     ihid->wHIDDescRegister = cpu_to_le16(hidRegister);
>> +
>> +     init_waitqueue_head(&ihid->wait);
>> +     spin_lock_init(&ihid->flock);
>> +
>> +     ret = i2chid_fetch_hid_descriptor(ihid);
>> +     if (ret < 0)
>> +             goto err;
>> +
>> +     ihid->irq = i2chid_init_irq(client);
>> +     if (ihid->irq < 0)
>
> "ret" is set to 0 at this point, so you return 0 on error. Not good.

ouch

>
>> +             goto err;
>> +
>> +     hid = hid_allocate_device();
>> +     if (IS_ERR(hid)) {
>> +             ret = -ENOMEM;
>
> Use PTR_ERR().
>
>> +             goto err;
>> +     }
>> +
>> +     ihid->hid = hid;
>> +
>> +     hid->driver_data = client;
>> +     hid->ll_driver = &i2c_hid_driver;
>> +     hid->hid_get_raw_report = i2chid_get_raw_report;
>> +     hid->hid_output_raw_report = i2chid_output_raw_report;
>> +     hid->ff_init = hid_pidff_init;
>> +#ifdef CONFIG_USB_HIDDEV
>> +     hid->hiddev_connect = hiddev_connect;
>> +     hid->hiddev_disconnect = hiddev_disconnect;
>> +     hid->hiddev_hid_event = hiddev_hid_event;
>> +     hid->hiddev_report_event = hiddev_report_event;
>> +#endif
>> +     hid->dev.parent = &client->dev;
>> +     hid->bus = BUS_I2C;
>> +     hid->version = le16_to_cpu(ihid->hdesc.bcdVersion);
>> +     hid->vendor = le16_to_cpu(ihid->hdesc.wVendorID);
>> +     hid->product = le16_to_cpu(ihid->hdesc.wProductID);
>> +
>> +     snprintf(tmpstr, sizeof(tmpstr), " %04X:%04X",
>> +              hid->vendor, hid->product);
>> +     strlcpy(hid->name, client->name, sizeof(hid->name));
>> +     strlcat(hid->name, tmpstr, sizeof(hid->name));
>
> Please use snprintf on hid->name directly, it's more efficient.
>
>> +
>> +     ret = hid_add_device(hid);
>> +     if (ret) {
>> +             if (ret != -ENODEV)
>> +                     hid_err(client, "can't add hid device: %d\n", ret);
>> +             goto err_mem_free;
>> +     }
>> +
>> +     return 0;
>> +
>> +err_mem_free:
>> +     hid_destroy_device(hid);
>> +
>> +err:
>> +     if (ihid->irq >= 0)
>> +             free_irq(ihid->irq, ihid);
>> +
>> +     kfree(ihid);
>> +     return ret;
>> +}
>> +
>> +static int __devexit i2chid_remove(struct i2c_client *client)
>> +{
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +     struct hid_device *hid;
>> +
>> +     if (WARN_ON(!ihid))
>> +             return -1;
>> +
>> +     hid = ihid->hid;
>> +     hid_destroy_device(hid);
>> +
>> +     free_irq(client->irq, ihid);
>> +
>> +     kfree(ihid);
>> +
>> +     return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM_SLEEP
>> +static int i2chid_suspend(struct device *dev)
>> +{
>> +     struct i2c_client *client = to_i2c_client(dev);
>> +     struct i2chid *ihid = i2c_get_clientdata(client);
>> +
>> +     if (device_may_wakeup(&client->dev))
>> +             enable_irq_wake(ihid->irq);
>> +
>> +     /* Save some power */
>> +     i2chid_set_power(client, I2C_HID_PWR_SLEEP);
>> +
>> +     return 0;
>> +}
>> +
>> +static int i2chid_resume(struct device *dev)
>> +{
>> +     int ret;
>> +     struct i2c_client *client = to_i2c_client(dev);
>> +
>> +     ret = i2chid_hwreset(client);
>> +     if (ret)
>> +             return ret;
>> +
>> +     if (device_may_wakeup(&client->dev))
>> +             enable_irq_wake(client->irq);
>
> All other drivers I checked call disable_irq_wake() here.

Yep. Seems like a bad copy/paste. I call the very same function in
i2chid_suspend, so definitely a mistake.

>
>> +
>> +     return 0;
>> +}
>> +#endif
>> +
>> +static SIMPLE_DEV_PM_OPS(i2chid_pm, i2chid_suspend, i2chid_resume);
>> +
>> +static const struct i2c_device_id i2chid_id_table[] = {
>> +     { "i2chid", 0 },
>> +     { },
>> +};
>> +MODULE_DEVICE_TABLE(i2c, i2chid_id_table);
>> +
>> +
>> +static struct i2c_driver i2chid_driver = {
>> +     .driver = {
>> +             .name   = DRIVER_NAME,
>> +             .owner  = THIS_MODULE,
>> +             .pm     = &i2chid_pm,
>> +     },
>> +
>> +     .probe          = i2chid_probe,
>> +     .remove         = __devexit_p(i2chid_remove),
>> +
>> +     .id_table       = i2chid_id_table,
>> +};
>> +
>> +module_i2c_driver(i2chid_driver);
>> +
>> +MODULE_DESCRIPTION(DRIVER_DESC);
>> +MODULE_AUTHOR("Benjamin Tissoires <benjamin.tissoires@gmail.com>");
>> +MODULE_LICENSE("GPL");
>> diff --git a/include/linux/i2c/i2c-hid.h b/include/linux/i2c/i2c-hid.h
>> new file mode 100644
>> index 0000000..6685605
>> --- /dev/null
>> +++ b/include/linux/i2c/i2c-hid.h
>> @@ -0,0 +1,35 @@
>> +/*
>> + * HID over I2C protocol implementation
>> + *
>> + * Copyright (c) 2012 Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> + * Copyright (c) 2012 Ecole Nationale de l'Aviation Civile, France
>> + *
>> + * This file is subject to the terms and conditions of the GNU General Public
>> + * License.  See the file COPYING in the main directory of this archive for
>> + * more details.
>> + */
>> +
>> +#ifndef __LINUX_I2C_HID_H
>> +#define __LINUX_I2C_HID_H
>> +
>> +#include <linux/types.h>
>> +
>> +/**
>> + * struct i2chid_platform_data - used by hid over i2c implementation.
>> + * @hid_descriptor_address: i2c register where the HID descriptor is stored.
>> + *
>> + * Note that it is the responsibility for the platform driver (or the acpi 5.0
>
> responsibility of
>
>> + * driver) to setup the irq related to the gpio in the struct i2c_board_info.
>> + * The platform driver should also setup the gpio according to the device:
>> + *
>> + * A typical example is the following:
>> + *   irq = gpio_to_irq(intr_gpio);
>> + *   hkdk4412_i2c_devs5[0].irq = irq; // store the irq in i2c_board_info
>> + *   gpio_request(intr_gpio, "elan-irq");
>> + *   s3c_gpio_setpull(intr_gpio, S3C_GPIO_PULL_UP);
>> + */
>> +struct i2chid_platform_data {
>> +     u16 hid_descriptor_address;
>> +};
>> +
>> +#endif /* __LINUX_I2C_HID_H */
>
>
> --
> Jean Delvare

Again, thanks for the review.
I'll come back with the v2 soon (I hope).

Cheers,
Benjamin
