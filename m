Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2LSAaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:30:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2LSAaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:30:11 -0500
Date: Tue, 18 Dec 2012 16:30:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myugnjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [rtc-linux] [RESEND PATCH] RTC: MAX77686: Add Maxim 77686
 driver
Message-Id: <20121218163009.fb21fec8.akpm@linux-foundation.org>
In-Reply-To: <1354085457-18460-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1354085457-18460-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 15:50:57 +0900
Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:

> Add driver for support max77686 rtc.
> MAX77686 rtc support smpl and wtsr mode. It has two alarm register
> which can be used for alarming to wake system up. This drvier uses regmap
> to access its register.
> 
> ...
>
> +static inline int max77686_rtc_calculate_wday(u8 shifted)
> +{
> +	int counter = -1;
> +	while (shifted) {
> +		shifted >>= 1;
> +		counter++;
> +	}
> +	return counter;
> +}

We should be able to use log2() in here?

>
> ...
>
> +static inline int max77686_rtc_update(struct max77686_rtc_info *info,
> +	enum MAX77686_RTC_OP op)
> +{
> +	int ret;
> +	unsigned int data;
> +
> +	switch (op) {
> +	case MAX77686_RTC_WRITE:
> +		data = 1 << RTC_UDR_SHIFT;
> +		break;
> +	case MAX77686_RTC_READ:
> +		data = 1 << RTC_RBUDR_SHIFT;
> +		break;
> +	}
> +
> +	ret = regmap_update_bits(info->max77686->rtc_regmap,
> +				 MAX77686_RTC_UPDATE0, data, data);
> +	if (ret < 0)
> +		dev_err(info->dev, "%s: fail to write update reg(ret=%d, data=0x%x)\n",
> +				__func__, ret, data);
> +	else {
> +		/* Minimum 16ms delay required before RTC update. */
> +		msleep(MAX77686_RTC_UPDATE_DELAY);
> +	}
> +
> +	return ret;
> +}

This function has about ten callers.  No way in the world do we want it
to be inlined!  Probably the compiler will just ignore your `inline',
but we should remove it to be sure.

>
> ...
>
> +static const struct rtc_class_ops max77686_rtc_ops = {
> +	.read_time = max77686_rtc_read_time,
> +	.set_time = max77686_rtc_set_time,
> +	.read_alarm = max77686_rtc_read_alarm,
> +	.set_alarm = max77686_rtc_set_alarm,
> +	.alarm_irq_enable = max77686_rtc_alarm_irq_enable,
> +};
> +
> +#ifdef MAX77686_RTC_WTSR_SMPL

hm, this is always undefined.  Why is this code here?

> +static void max77686_rtc_enable_wtsr(struct max77686_rtc_info *info, bool enable)
> +{
> +	int ret;
> +	unsigned int val, mask;
> +
> +	if (enable)
> +		val = (1 << WTSR_EN_SHIFT) | (3 << WTSRT_SHIFT);
> +	else
> +		val = 0;
> +
> +	mask = WTSR_EN_MASK | WTSRT_MASK;
> +
> +	dev_info(info->dev, "%s: %s WTSR\n", __func__,
> +			enable ? "enable" : "disable");
> +
> +	ret = regmap_update_bits(info->max77686->rtc_regmap,
> +				 MAX77686_WTSR_SMPL_CNTL, mask, val);
> +	if (ret < 0) {
> +		dev_err(info->dev, "%s: fail to update WTSR reg(%d)\n",
> +				__func__, ret);
> +		return;
> +	}
> +
> +	max77686_rtc_update(info, MAX77686_RTC_WRITE);
> +}
> +
> +static void max77686_rtc_enable_smpl(struct max77686_rtc_info *info, bool enable)
> +{
> +	int ret;
> +	unsigned int val, mask;
> +
> +	if (enable)
> +		val = (1 << SMPL_EN_SHIFT) | (0 << SMPLT_SHIFT);
> +	else
> +		val = 0;
> +
> +	mask = SMPL_EN_MASK | SMPLT_MASK;
> +
> +	dev_info(info->dev, "%s: %s SMPL\n", __func__,
> +			enable ? "enable" : "disable");
> +
> +	ret = regmap_update_bits(info->max77686->rtc_regmap,
> +				 MAX77686_WTSR_SMPL_CNTL, mask, val);
> +	if (ret < 0) {
> +		dev_err(info->dev, "%s: fail to update SMPL reg(%d)\n",
> +				__func__, ret);
> +		return;
> +	}
> +
> +	max77686_rtc_update(info, MAX77686_RTC_WRITE);
> +
> +	val = 0;
> +	regmap_read(info->max77686->rtc_regmap, MAX77686_WTSR_SMPL_CNTL, &val);
> +	pr_info("%s: WTSR_SMPL(0x%02x)\n", __func__, val);
> +}
> +#endif /* MAX77686_RTC_WTSR_SMPL */
>
> ...
>
> +static int __devinit max77686_rtc_probe(struct platform_device *pdev)

CONFIG_HOTPLUG is removed, so we should stop using devinit, devexit,
devinit_p, etc.

>
> ...
>

--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-add-maxim-77686-driver-fix
+++ a/drivers/rtc/rtc-max77686.c
@@ -129,7 +129,7 @@ static int max77686_rtc_tm_to_data(struc
 	return 0;
 }
 
-static inline int max77686_rtc_update(struct max77686_rtc_info *info,
+static int max77686_rtc_update(struct max77686_rtc_info *info,
 	enum MAX77686_RTC_OP op)
 {
 	int ret;
@@ -501,7 +501,7 @@ static struct regmap_config max77686_rtc
 	.val_bits = 8,
 };
 
-static int __devinit max77686_rtc_probe(struct platform_device *pdev)
+static int max77686_rtc_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *max77686 = dev_get_drvdata(pdev->dev.parent);
 	struct max77686_rtc_info *info;
@@ -575,7 +575,7 @@ out:
 	return ret;
 }
 
-static int __devexit max77686_rtc_remove(struct platform_device *pdev)
+static int max77686_rtc_remove(struct platform_device *pdev)
 {
 	struct max77686_rtc_info *info = platform_get_drvdata(pdev);
 
@@ -623,7 +623,7 @@ static struct platform_driver max77686_r
 		.owner	= THIS_MODULE,
 	},
 	.probe		= max77686_rtc_probe,
-	.remove		= __devexit_p(max77686_rtc_remove),
+	.remove		= max77686_rtc_remove,
 	.shutdown	= max77686_rtc_shutdown,
 	.id_table	= rtc_id,
 };
_

