Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2AUAXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 19:23:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2AUAXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 19:23:37 -0500
Date: Fri, 20 Jan 2012 16:23:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kim, Milo" <Milo.Kim@nsc.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] backlight: add new lp855x backlight driver
Message-Id: <20120120162336.7210b5e3.akpm@linux-foundation.org>
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812A8DECA@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812710288@EXMAIL03.scwf.nsc.com>
	<B567DBAB974C0544994013492B949F8E381271028A@EXMAIL03.scwf.nsc.com>
	<B567DBAB974C0544994013492B949F8E3812A8DECA@EXMAIL03.scwf.nsc.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jan 2012 23:00:24 -0800
"Kim, Milo" <Milo.Kim@ti.com> wrote:

> This patch supports TI LP8550/LP8551/LP8852/LP8553/LP8556 backlight driver.
> 
> The brightness can be controlled by the I2C or PWM input.
> The lp855x driver provides both modes.
> For the PWM control, pwm-specific functions can be defined in the platform data.
> And some information can be read via the debugfs.
> 
> For the details, please refer to 'Documentation/backlight/lp855x-driver.txt'.
> 
>
> ...
>
> +static ssize_t lp855x_help_register(struct file *file, char __user *userbuf,
> +                                   size_t count, loff_t *ppos)
> +{
> +       char buf[320];
> +       unsigned int len;
> +       const char *help = "\n How to read/write LP855x registers\n\n \
> +       (example) To read 0x00 register,\n \
> +       echo 0x00 r > /sys/kernel/debug/lp855x/registers\n \
> +       To write 0xff into 0x1 address,\n \
> +       echo 0x00 0xff w > /sys/kernel/debug/lp855x/registers \n \
> +       To dump values from 0x00 to 0x06 address,\n \
> +       echo 0x00 0x06 d > /sys/kernel/debug/lp855x/registers\n";

lol.  Oh well, it's only debugfs.

> +       len = snprintf(buf, sizeof(buf), "%s\n", help);

`len' should have type size_t.

> +       if (len > sizeof(buf))
> +               len = sizeof(buf);

Here you could use max().  But a better approach is to form the output
using scnprintf().

> +       return simple_read_from_buffer(userbuf, count, ppos, buf, len);
> +}
> +
> +static char *lp855x_parse_register_cmd(const char *cmd, u8 *byte)
> +{
> +       char tmp[10];
> +       char *blank;
> +       unsigned long arg;
> +
> +       blank = strchr(cmd, ' ');
> +       memset(tmp, 0x0, sizeof(tmp));
> +       memcpy(tmp, cmd, blank - cmd);
> +
> +       if (strict_strtol(tmp, 16, &arg) < 0)
> +               return NULL;

Gee, what's all this code doing?  Please add a nice comment explaining
what the input format is, and what this function is trying to do with
it.

I worry about what it does when strchr() returns NULL!

> +       *byte = arg;
> +       return blank;
> +}
> +
> +static ssize_t lp855x_ctrl_register(struct file *file,
> +                                   const char __user *userbuf, size_t count,
> +                                   loff_t *ppos)
> +{
> +       char mode, buf[20];
> +       char *pos, *pos2;
> +       u8 i, arg1, arg2, val;
> +       struct lp855x *lp = file->private_data;
> +
> +       if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
> +               return -EFAULT;

Looks risky.  If count>sizeof(buf), this will quietly truncate the
user's input.  It would be much better to reject the input in this
case.

> +       mode = buf[count - 2];
> +       switch (mode) {
> +       case 'r':
> +               if (!lp855x_parse_register_cmd(buf, &arg1))
> +                       return -EINVAL;
> +
> +               lp855x_read_byte(lp, arg1, &val);
> +               dev_info(lp->dev, "Read [0x%.2x] = 0x%.2x\n", arg1, val);
> +               break;
> +       case 'w':
> +               pos = lp855x_parse_register_cmd(buf, &arg1);
> +               if (!pos)
> +                       return -EINVAL;
> +               pos2 = lp855x_parse_register_cmd(pos + 1, &arg2);
> +               if (!pos2)
> +                       return -EINVAL;
> +
> +               lp855x_write_byte(lp, arg1, arg2);
> +               dev_info(lp->dev, "Written [0x%.2x] = 0x%.2x\n", arg1, arg2);
> +               break;
> +       case 'd':
> +               pos = lp855x_parse_register_cmd(buf, &arg1);
> +               if (!pos)
> +                       return -EINVAL;
> +               pos2 = lp855x_parse_register_cmd(pos + 1, &arg2);
> +               if (!pos2)
> +                       return -EINVAL;
> +
> +               for (i = arg1; i <= arg2; i++) {
> +                       lp855x_read_byte(lp, i, &val);
> +                       dev_info(lp->dev, "Read [0x%.2x] = 0x%.2x\n", i, val);
> +               }
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return count;
> +}
> +
> +static ssize_t lp855x_get_chipid(struct file *file, char __user *userbuf,
> +                                size_t count, loff_t *ppos)
> +{
> +       struct lp855x *lp = file->private_data;
> +       char buf[10];
> +       unsigned int len;
> +
> +       len = snprintf(buf, sizeof(buf), "%s\n", lp->chipid);
> +
> +       if (len > sizeof(buf))
> +               len = sizeof(buf);

See above.

> +       return simple_read_from_buffer(userbuf, count, ppos, buf, len);
> +}
> +
> +static ssize_t lp855x_get_bl_mode(struct file *file, char __user *userbuf,
> +                                 size_t count, loff_t *ppos)
> +{
> +       char buf[20];
> +       unsigned int len;
> +       char *strmode = NULL;
> +       struct lp855x *lp = file->private_data;
> +       enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
> +
> +       if (mode == PWM_BASED)
> +               strmode = "pwm based";
> +       else if (mode == REGISTER_BASED)
> +               strmode = "register based";
> +
> +       len = snprintf(buf, sizeof(buf), "%s\n", strmode);
> +
> +       if (len > sizeof(buf))
> +               len = sizeof(buf);

More...

> +       return simple_read_from_buffer(userbuf, count, ppos, buf, len);
> +}
> +
> +#define LP855X_DBG_ENTRY(name, pread, pwrite) \
> +static const struct file_operations dbg_##name##_fops = { \
> +       .open = lp855x_dbg_open, \
> +       .read = pread, \
> +       .write = pwrite, \
> +       .owner = THIS_MODULE, \
> +       .llseek = default_llseek, \
> +}
> +
> +LP855X_DBG_ENTRY(registers, lp855x_help_register, lp855x_ctrl_register);
> +LP855X_DBG_ENTRY(chip, lp855x_get_chipid, NULL);
> +LP855X_DBG_ENTRY(blmode, lp855x_get_bl_mode, NULL);
> +
> +static void lp855x_create_debugfs(struct lp855x *lp)
> +{
> +       struct debug_dentry *dd = &lp->dd;
> +
> +       dd->dir = debugfs_create_dir("lp855x", NULL);
> +
> +       dd->reg = debugfs_create_file("registers", S_IWUSR | S_IRUGO,
> +                                     dd->dir, lp, &dbg_registers_fops);
> +
> +       dd->chip = debugfs_create_file("chip_id", S_IRUGO,
> +                                      dd->dir, lp, &dbg_chip_fops);
> +
> +       dd->blmode = debugfs_create_file("bl_ctl_mode", S_IRUGO,
> +                                        dd->dir, lp, &dbg_blmode_fops);

Error checking?

> +}
> +
>
> ...
>
> +static void lp855x_init_device(struct lp855x *lp)
> +{
> +       u8 val, addr;
> +       int i, ret;
> +       struct lp855x_platform_data *pd = lp->pdata;
> +
> +       val = pd->initial_brightness;
> +       ret = lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
> +
> +       val = pd->device_control;
> +       ret |= lp855x_write_byte(lp, DEVICE_CTRL, val);
> +
> +       if (pd->load_new_rom_data && pd->size_program) {
> +               for (i = 0; i < pd->size_program; i++) {
> +                       addr = pd->rom_data[i].addr;
> +                       val = pd->rom_data[i].val;
> +                       if (!lp855x_is_valid_rom_area(lp, addr))
> +                               continue;
> +
> +                       ret |= lp855x_write_byte(lp, addr, val);
> +               }
> +       }
> +
> +       if (ret)
> +               dev_err(lp->dev, "i2c write err\n");
> +}

This isn't very good.  lp855x_write_byte() can return various -Efoo
values: -EINVAL, -ENOMEM, etc.  But this function can end up
bitwise-ORing those errnos together, thus producing a completely new
(and wrong) errno.

That's not a big problem in this case, because that errno is simply
dropped on the floor.  However it would be more useful if the errno
were reported to the operator in that dev_err() call.

>
> ...
>
> +static int lp855x_backlight_register(struct lp855x *lp)
> +{
> +       struct backlight_device *bl;
> +       struct backlight_properties props;
> +       const char *name = lp->pdata->name;
> +
> +       if (!name)
> +               return -ENODEV;
> +
> +       props.brightness = lp->pdata->initial_brightness;
> +       props.max_brightness =
> +               (lp->pdata->max_brightness < lp->pdata->initial_brightness) ?
> +               255 : lp->pdata->max_brightness;
> +
> +       bl = backlight_device_register(name, lp->dev, lp,
> +                                      &lp855x_bl_ops, &props);
> +       if (IS_ERR(bl))
> +               return -EIO;

If `lb' contains an errno, we should return that errno to the caller
rather than unconditionally overwriting it with -EIO?

> +       lp->bl = bl;
> +
> +       return 0;
> +}
> +
>
> ...
>

