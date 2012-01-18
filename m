Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2ARVhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:37:16 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58543 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2ARVhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:37:14 -0500
Date: Wed, 18 Jan 2012 22:36:37 +0100
From: Andi <andi.shyti@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>, "greg@kroah.com" <greg@kroah.com>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, lm-sensors@lm-sensors.org,
        linux-input@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Message-ID: <20120118213635.GB3401@gmail.com>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com>
 <331ABD5ECB02734CA317220B2BBEABC13177CDA4@DBDE01.ent.ti.com>
 <201201181403.47806.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201181403.47806.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

 
What do you mean with "kernel-wide policy for accelerometer drivers"?
As far as I know, accelerometer drivers are written between the i2c driver and the
input driver.
The input driver provides already some accelerometer specific event types, ABS_X, ABS_Y, ABS_Z,
in your opinion isn't it enough?
If you mean something like collecting common properties like g range or frequency or whatever in a
standard interface, then I think that accelerometers are quite different as devices and sometimes
it could be difficult to arrange a common interface.

Andi


On Wed, Jan 18, 2012 at 02:03:47PM +0000, Arnd Bergmann wrote:
> On Tuesday 17 January 2012, AnilKumar, Chimata wrote:
> > Hi All,
> > 
> > Recalling the patch, provide the comments if there are any if not please include
> > this patch to v3.3 kernel.
> 
> As Mark and Greg said, 3.4 would be appropriate.
> 
> > +static ssize_t lis3lv02d_range_set(struct device *dev,
> > +				struct device_attribute *attr, const char *buf,
> > +				size_t count)
> > +{
> > +	unsigned long range;
> > +
> > +	if (strict_strtoul(buf, 0, &range))
> > +		return -EINVAL;
> > +
> > +	lis3_dev.g_range = range;
> > +	lis3lv02d_update_g_range(&lis3_dev);
> > +
> > +	return count;
> > +}
> > +
> >  static DEVICE_ATTR(selftest, S_IRUSR, lis3lv02d_selftest_show, NULL);
> >  static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
> >  static DEVICE_ATTR(rate, S_IRUGO | S_IWUSR, lis3lv02d_rate_show,
> >  					    lis3lv02d_rate_set);
> > +static DEVICE_ATTR(range, S_IRUGO | S_IWUSR, lis3lv02d_range_show,
> > +					    lis3lv02d_range_set);
> 
> I think you need to document this new attribute in the Documentation
> directory, unless I missed the other patch doing this.
> 
> On a more general topic, do we have a kernel-wide policy for accelerometer
> drivers? AFAICT, we currently have three subsystems that contain 
> accelerometer drivers, plus a few ad-hoc ones like this, which is a
> rather unpleasant situation. What I found are these:
> 
> $ git grep -l accelerometer drivers/ | manual_grep
> drivers/hwmon/applesmc.c
>    (one hwmon sysfs attribute for x/y/z)
> drivers/input/misc/adxl34x.c
>    (lots of sysfs attributes, input_report_key)
> drivers/input/misc/cma3000_d0x.c
>    (input_report_abs)
> drivers/input/misc/kxtj9.c
>    (input_report_abs, plus one aux sysfs attribute)
> drivers/macintosh/ams/ams-core.c
>    (one sysfs attribute for x/y/z)
> drivers/misc/lis3lv02d/
>    (multiple sysfs attributes)
> drivers/platform/x86/hdaps.c
>    (multiple sysfs attributes, only x/y)
> drivers/platform/x86/hp_accel.c
>    (hooks into drivers/misc/lis3lv02d/)
> drivers/staging/iio/accel/kxsd9.c
>    (iio)
> drivers/staging/iio/accel/sca3000_core.c
>    (iio plus extra attributes)
> 
> While I'm not blaming you for the current situation, but I think the
> situation is no longer sustainable and we need to decide on one place
> and interface for these to go in the long run so we don't grow even
> more nonstandard interfaces.
> 
> Any opinions where they should live? input, iio or a new subsystem?
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
