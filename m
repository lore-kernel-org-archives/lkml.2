Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab2LSWEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:04:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2LSWEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:04:00 -0500
Date: Wed, 19 Dec 2012 14:03:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtc-pcf8523: Add low battery voltage support
Message-Id: <20121219140358.8658ee86.akpm@linux-foundation.org>
In-Reply-To: <20121219160033.GF14217@axis.com>
References: <20121219140456.GA14217@axis.com>
	<20121219144225.GB7837@avionic-0098.adnet.avionic-design.de>
	<20121219151054.GB14217@axis.com>
	<20121219151937.GA21212@avionic-0098.adnet.avionic-design.de>
	<20121219153432.GC14217@axis.com>
	<20121219154828.GA32019@avionic-0098.adnet.avionic-design.de>
	<20121219160033.GF14217@axis.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 17:00:33 +0100
Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> This patch implements reading of the battery voltage low signal for
> rtc-pcf8523.
> 
> The bit is read-only and cannot be cleared by software, so no
> clear-function is implemented.
> 
> ...
>
> --- a/drivers/rtc/rtc-pcf8523.c
> +++ b/drivers/rtc/rtc-pcf8523.c
> @@ -23,6 +23,7 @@
>  #define REG_CONTROL3_PM_VDD (1 << 6) /* switch-over disabled */
>  #define REG_CONTROL3_PM_DSM (1 << 5) /* direct switching mode */
>  #define REG_CONTROL3_PM_MASK 0xe0
> +#define REG_CONTROL3_BLF (1 << 2) /* battery low bit, read-only */
>  
>  #define REG_SECONDS  0x03
>  #define REG_SECONDS_OS (1 << 7)
> @@ -250,9 +252,35 @@ static int pcf8523_rtc_set_time(struct device *dev, struct rtc_time *tm)
>  	return pcf8523_start_rtc(client);
>  }
>  
> +static int pcf8523_rtc_ioctl(struct device *dev, unsigned int cmd,
> +			     unsigned long arg)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	u8 value;
> +	int ret = 0, err;
> +
> +	switch (cmd) {
> +	case RTC_VL_READ:
> +		err = pcf8523_read(client, REG_CONTROL3, &value);
> +		if (err < 0)
> +			return err;
> +
> +		if (value & REG_CONTROL3_BLF)
> +			ret = 1;
> +
> +		if (copy_to_user((void __user *)arg, &ret, sizeof(int)))
> +			return -EFAULT;
> +
> +		return 0;
> +	default:
> +		return -ENOIOCTLCMD;
> +	}
> +}
> +
>  static const struct rtc_class_ops pcf8523_rtc_ops = {
>  	.read_time = pcf8523_rtc_read_time,
>  	.set_time = pcf8523_rtc_set_time,
> +	.ioctl = pcf8523_rtc_ioctl,
>  };

Other drivers make the ioctl conditional on CONFIG_RTC_INTF_DEV,
presumably to avoid bloat.

--- a/drivers/rtc/rtc-pcf8523.c~rtc-pcf8523-add-low-battery-voltage-support-fix
+++ a/drivers/rtc/rtc-pcf8523.c
@@ -251,6 +251,7 @@ static int pcf8523_rtc_set_time(struct d
 	return pcf8523_start_rtc(client);
 }
 
+#ifdef CONFIG_RTC_INTF_DEV
 static int pcf8523_rtc_ioctl(struct device *dev, unsigned int cmd,
 			     unsigned long arg)
 {
@@ -275,6 +276,9 @@ static int pcf8523_rtc_ioctl(struct devi
 		return -ENOIOCTLCMD;
 	}
 }
+#else
+#define pcf8523_rtc_ioctl NULL
+#endif
 
 static const struct rtc_class_ops pcf8523_rtc_ops = {
 	.read_time = pcf8523_rtc_read_time,
_


