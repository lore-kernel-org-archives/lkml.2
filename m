Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab2AYGV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 01:21:57 -0500
Received: from mail2.nsc.com ([12.238.8.132]:35571 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750755Ab2AYGV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 01:21:56 -0500
X-WSS-ID: 0LYCCCF-0A-5TV-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richard Purdie" <rpurdie@rpsys.net>
Date: Tue, 24 Jan 2012 22:21:39 -0800
Subject: RE: [PATCH] backlight: add new lp855x backlight driver
Thread-Topic: [PATCH] backlight: add new lp855x backlight driver
Thread-Index: AczX0uyS6SXkMwtDQ7eY7flSsN77EQDTzZuA
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD3EE4@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812710288@EXMAIL03.scwf.nsc.com>
 <B567DBAB974C0544994013492B949F8E381271028A@EXMAIL03.scwf.nsc.com>
 <B567DBAB974C0544994013492B949F8E3812A8DECA@EXMAIL03.scwf.nsc.com>
 <20120120162336.7210b5e3.akpm@linux-foundation.org>
In-Reply-To: <20120120162336.7210b5e3.akpm@linux-foundation.org>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 630140F21LS9911885-03-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Saturday, January 21, 2012 9:24 AM
To: Kim, Milo
Cc: linux-kernel@vger.kernel.org; Kim, Milo; Richard Purdie
Subject: Re: [PATCH] backlight: add new lp855x backlight driver

On Thu, 5 Jan 2012 23:00:24 -0800
"Kim, Milo" <Milo.Kim@ti.com> wrote:


>> +       len = snprintf(buf, sizeof(buf), "%s\n", help);

> `len' should have type size_t.

>> +       if (len > sizeof(buf))
>> +               len = sizeof(buf);

> Here you could use max().  But a better approach is to form the output
> using scnprintf().

This code can be replaced with scnprintf().
But in the updated driver, debugfs nodes will be removed.
The 'chip_id' and 'bl_ctl_mode' will be moved to the lp855x device attributes.
And register access is not necessary in lp855x driver.

>> +static char *lp855x_parse_register_cmd(const char *cmd, u8 *byte)
>> +{
>> +       char tmp[10];
>> +       char *blank;
>> +       unsigned long arg;
>> +
>> +       blank = strchr(cmd, ' ');
>> +       memset(tmp, 0x0, sizeof(tmp));
>> +       memcpy(tmp, cmd, blank - cmd);
>> +
>> +       if (strict_strtol(tmp, 16, &arg) < 0)
>> +               return NULL;

> Gee, what's all this code doing?  Please add a nice comment explaining
> what the input format is, and what this function is trying to do with
> it.

> I worry about what it does when strchr() returns NULL!

Will be removed in the updated driver.

>> +static ssize_t lp855x_ctrl_register(struct file *file,
>> +                                   const char __user *userbuf, size_t count,
>> +                                   loff_t *ppos)
>> +{
>> +       char mode, buf[20];
>> +       char *pos, *pos2;
>> +       u8 i, arg1, arg2, val;
>> +       struct lp855x *lp = file->private_data;
>> +
>> +       if (copy_from_user(buf, userbuf, min(count, sizeof(buf))))
>> +               return -EFAULT;

> Looks risky.  If count>sizeof(buf), this will quietly truncate the
> user's input.  It would be much better to reject the input in this
> case.

Will be removed in the updated driver.

>> +static ssize_t lp855x_get_chipid(struct file *file, char __user *userbuf,
>> +                                size_t count, loff_t *ppos)
>> +{
>> +       struct lp855x *lp = file->private_data;
>> +       char buf[10];
>> +       unsigned int len;
>> +
>> +       len = snprintf(buf, sizeof(buf), "%s\n", lp->chipid);
>> +
>> +       if (len > sizeof(buf))
>> +               len = sizeof(buf);

> See above.

This function will be moved to the lp855x device attribute.
And snprintf() and sizeof(buf) will be replaced with scnprintf().

>> +       return simple_read_from_buffer(userbuf, count, ppos, buf, len);
>> +}
>> +
>> +static ssize_t lp855x_get_bl_mode(struct file *file, char __user *userbuf,
>> +                                 size_t count, loff_t *ppos)
>> +{
>> +       char buf[20];
>> +       unsigned int len;
>> +       char *strmode = NULL;
>> +       struct lp855x *lp = file->private_data;
>> +       enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
>> +
>> +       if (mode == PWM_BASED)
>> +               strmode = "pwm based";
>> +       else if (mode == REGISTER_BASED)
>> +               strmode = "register based";
>> +
>> +       len = snprintf(buf, sizeof(buf), "%s\n", strmode);
>> +
>> +       if (len > sizeof(buf))
>> +               len = sizeof(buf);

> More...

This function also will be moved to the device attribute.
And snprintf() and sizeof(buf) will be replaced with scnprintf().

>> +static void lp855x_create_debugfs(struct lp855x *lp)
>> +{
>> +       struct debug_dentry *dd = &lp->dd;
>> +
>> +       dd->dir = debugfs_create_dir("lp855x", NULL);
>> +
>> +       dd->reg = debugfs_create_file("registers", S_IWUSR | S_IRUGO,
>> +                                     dd->dir, lp, &dbg_registers_fops);
>> +
>> +       dd->chip = debugfs_create_file("chip_id", S_IRUGO,
>> +                                      dd->dir, lp, &dbg_chip_fops);
>> +
>> +       dd->blmode = debugfs_create_file("bl_ctl_mode", S_IRUGO,
>> +                                        dd->dir, lp, &dbg_blmode_fops);

> Error checking?

Return code should be checked.
But the 'register' node will be removed in new lp855x driver patch.
The 'chip_id' and 'bl_ctl_mode' will be moved to lp855x device attribute.

>> +static void lp855x_init_device(struct lp855x *lp)
>> +{
>> +       u8 val, addr;
>> +       int i, ret;
>> +       struct lp855x_platform_data *pd = lp->pdata;
>> +
>> +       val = pd->initial_brightness;
>> +       ret = lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
>> +
>> +       val = pd->device_control;
>> +       ret |= lp855x_write_byte(lp, DEVICE_CTRL, val);
>> +
>> +       if (pd->load_new_rom_data && pd->size_program) {
>> +               for (i = 0; i < pd->size_program; i++) {
>> +                       addr = pd->rom_data[i].addr;
>> +                       val = pd->rom_data[i].val;
>> +                       if (!lp855x_is_valid_rom_area(lp, addr))
>> +                               continue;
>> +
>> +                       ret |= lp855x_write_byte(lp, addr, val);
>> +               }
>> +       }
>> +
>> +       if (ret)
>> +               dev_err(lp->dev, "i2c write err\n");
>> +}

> This isn't very good.  lp855x_write_byte() can return various -Efoo
> values: -EINVAL, -ENOMEM, etc.  But this function can end up
> bitwise-ORing those errnos together, thus producing a completely new
> (and wrong) errno.

> That's not a big problem in this case, because that errno is simply
> dropped on the floor.  However it would be more useful if the errno
> were reported to the operator in that dev_err() call.

I totally agree with your opinion.
These return code should not be manipulated and returned on xxx_probe().
It will be fixed in new driver patch.

>> +static int lp855x_backlight_register(struct lp855x *lp)
>> +{
>> +       struct backlight_device *bl;
>> +       struct backlight_properties props;
>> +       const char *name = lp->pdata->name;
>> +
>> +       if (!name)
>> +               return -ENODEV;
>> +
>> +       props.brightness = lp->pdata->initial_brightness;
>> +       props.max_brightness =
>> +               (lp->pdata->max_brightness < lp->pdata->initial_brightness) ?
>> +               255 : lp->pdata->max_brightness;
>> +
>> +       bl = backlight_device_register(name, lp->dev, lp,
>> +                                      &lp855x_bl_ops, &props);
>> +       if (IS_ERR(bl))
>> +               return -EIO;

> If `lb' contains an errno, we should return that errno to the caller
> rather than unconditionally overwriting it with -EIO?

That code will be changed below.

If (IS_ERR(bl))
	return PTR_ERR(bl);

I appreciate your help and detailed advice.
Updated lp855x driver will be patched as [PATCH v2].

Thanks & BR
Milo -

