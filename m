Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab2AROEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:04:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53416 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab2AROEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:04:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Subject: Re: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Date: Wed, 18 Jan 2012 14:03:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: "greg@kroah.com" <greg@kroah.com>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, lm-sensors@lm-sensors.org,
        linux-input@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com> <331ABD5ECB02734CA317220B2BBEABC13177CDA4@DBDE01.ent.ti.com>
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13177CDA4@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201181403.47806.arnd@arndb.de>
X-Provags-ID: V02:K0:01pztwpn/rrNN9Fh94434kP8wllta3GaZor6t/ML+wz
 AA0lYGbjtnorptdJlL6v2UbgZSQusrUOF25ca5BnDzV936o4S2
 3XYZCUlmcjM9FvwiAu5bKsNdefKs+ItC9wCIROr3bEoZ/ZQ2m+
 q+vgiiR1QHDApamj1vTeYgKgkXeChT8vD1lPu0e7l/Phk0RjTn
 UxrCL+/8ibmMgBhuMvGdb7zwiecyXS/GRgFdI5bCEY6T3IhAkJ
 4w26hrB5oA5Ew0mJ8mgRpymtpwiDo8kfwolnrvDF13gNl2oU7s
 l7RD55egh8CfSus7g2uKq2Jw6vv14WgQcOOAezkIpJaU02PcgB
 A/bkBjG8fEytceIQPBXk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 January 2012, AnilKumar, Chimata wrote:
> Hi All,
> 
> Recalling the patch, provide the comments if there are any if not please include
> this patch to v3.3 kernel.

As Mark and Greg said, 3.4 would be appropriate.

> +static ssize_t lis3lv02d_range_set(struct device *dev,
> +				struct device_attribute *attr, const char *buf,
> +				size_t count)
> +{
> +	unsigned long range;
> +
> +	if (strict_strtoul(buf, 0, &range))
> +		return -EINVAL;
> +
> +	lis3_dev.g_range = range;
> +	lis3lv02d_update_g_range(&lis3_dev);
> +
> +	return count;
> +}
> +
>  static DEVICE_ATTR(selftest, S_IRUSR, lis3lv02d_selftest_show, NULL);
>  static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
>  static DEVICE_ATTR(rate, S_IRUGO | S_IWUSR, lis3lv02d_rate_show,
>  					    lis3lv02d_rate_set);
> +static DEVICE_ATTR(range, S_IRUGO | S_IWUSR, lis3lv02d_range_show,
> +					    lis3lv02d_range_set);

I think you need to document this new attribute in the Documentation
directory, unless I missed the other patch doing this.

On a more general topic, do we have a kernel-wide policy for accelerometer
drivers? AFAICT, we currently have three subsystems that contain 
accelerometer drivers, plus a few ad-hoc ones like this, which is a
rather unpleasant situation. What I found are these:

$ git grep -l accelerometer drivers/ | manual_grep
drivers/hwmon/applesmc.c
   (one hwmon sysfs attribute for x/y/z)
drivers/input/misc/adxl34x.c
   (lots of sysfs attributes, input_report_key)
drivers/input/misc/cma3000_d0x.c
   (input_report_abs)
drivers/input/misc/kxtj9.c
   (input_report_abs, plus one aux sysfs attribute)
drivers/macintosh/ams/ams-core.c
   (one sysfs attribute for x/y/z)
drivers/misc/lis3lv02d/
   (multiple sysfs attributes)
drivers/platform/x86/hdaps.c
   (multiple sysfs attributes, only x/y)
drivers/platform/x86/hp_accel.c
   (hooks into drivers/misc/lis3lv02d/)
drivers/staging/iio/accel/kxsd9.c
   (iio)
drivers/staging/iio/accel/sca3000_core.c
   (iio plus extra attributes)

While I'm not blaming you for the current situation, but I think the
situation is no longer sustainable and we need to decide on one place
and interface for these to go in the long run so we don't grow even
more nonstandard interfaces.

Any opinions where they should live? input, iio or a new subsystem?

	Arnd
