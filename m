Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab1K1W4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:56:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1K1W4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:56:16 -0500
Date: Mon, 28 Nov 2011 14:56:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yauhen Kharuzhy <jekhor@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH 2/2] RTC MXC: Make alarm working
Message-Id: <20111128145615.98789cfc.akpm@linux-foundation.org>
In-Reply-To: <1320598006-17678-3-git-send-email-jekhor@gmail.com>
References: <1320598006-17678-1-git-send-email-jekhor@gmail.com>
	<1320598006-17678-3-git-send-email-jekhor@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  6 Nov 2011 19:46:46 +0300
Yauhen Kharuzhy <jekhor@gmail.com> wrote:

> Fix alarm IRQ handling, make the alarm one-shot. Cleanup black magick with
> a validation of already validated time data.
> 
> Add ability to wake the system with alarm.
> 
> ...
>
> +#ifdef CONFIG_PM
> +static int mxc_rtc_suspend(struct device *dev)
> +{
> +	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
> +
> +	if (device_may_wakeup(dev))
> +		enable_irq_wake(pdata->irq);
> +
> +	return 0;
> +}
> +
> +static int mxc_rtc_resume(struct device *dev)
> +{
> +	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
> +
> +	if (device_may_wakeup(dev))
> +		disable_irq_wake(pdata->irq);
> +
> +	return 0;
> +}
> +#endif
> +
> +static struct dev_pm_ops mxc_rtc_pm_ops = {
> +	.suspend	= mxc_rtc_suspend,
> +	.resume		= mxc_rtc_resume,
> +};
> +
>  static struct platform_driver mxc_rtc_driver = {
>  	.driver = {
>  		   .name	= "mxc_rtc",
> +#ifdef CONFIG_PM
> +		   .pm		= &mxc_rtc_pm_ops,
> +#endif
>  		   .owner	= THIS_MODULE,
>  	},
>  	.remove		= __exit_p(mxc_rtc_remove),

This won't compile with CONFIG_PM=n.  Fix:

--- a/drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-make-alarm-work-fix
+++ a/drivers/rtc/rtc-mxc.c
@@ -466,12 +466,12 @@ static int mxc_rtc_resume(struct device 
 
 	return 0;
 }
-#endif
 
 static struct dev_pm_ops mxc_rtc_pm_ops = {
 	.suspend	= mxc_rtc_suspend,
 	.resume		= mxc_rtc_resume,
 };
+#endif
 
 static struct platform_driver mxc_rtc_driver = {
 	.driver = {
_

