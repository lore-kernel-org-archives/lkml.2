Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2AMJeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 04:34:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56740 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab2AMJeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 04:34:20 -0500
Message-ID: <4F0FFA58.7010702@cn.fujitsu.com>
Date: Fri, 13 Jan 2012 17:33:12 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Barry Song <Barry.Song@csr.com>
CC: Richard Purdie <rpurdie@rpsys.net>, Eric Miao <eric.y.miao@gmail.com>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        linux-arm-kernel@lists.infradead.org,
        Xiangzhen Ye <Xiangzhen.Ye@csr.com>, Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH] backlight: pwm_bl: move suspend/resume entries from platform_driver
 to driver.pm
References: <1322704427-11876-1-git-send-email-Barry.Song@csr.com>
In-Reply-To: <1322704427-11876-1-git-send-email-Barry.Song@csr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-13 17:33:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-13 17:33:10,
	Serialize complete at 2012-01-13 17:33:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 09:53 AM, Barry Song wrote:

> From: Xiangzhen Ye <Xiangzhen.Ye@csr.com>
> 
> At first, people are moving suspend/resume entries from platform_driver
> to driver.pm for many drivers.
> On the other hand, if we use swsusp to do hibernation for an embedded
> system using pwm_bl, in the process of preparing snapshot, backlight
> will be off and make lcd black screen. This gives bad user experiences.
> This patch will fix this issue as swsusp will go to call pm.freeze()
> but not platform_driver.suspend. we have no pm.freeze() for pwm_bl, so
> the lcd black screen will disappear.
> 
> Signed-off-by: Xiangzhen Ye <Xiangzhen.Ye@csr.com>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>
> ---
>  drivers/video/backlight/pwm_bl.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
> index 8b5b2a4..50f3134 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -169,9 +169,9 @@ static int pwm_backlight_remove(struct platform_device *pdev)
>  }
>  
>  #ifdef CONFIG_PM
> -static int pwm_backlight_suspend(struct platform_device *pdev,
> -				 pm_message_t state)
> +static int pwm_backlight_suspend(struct device *dev)
>  {
> +	struct platform_device *pdev = to_platform_device(dev);
>  	struct backlight_device *bl = platform_get_drvdata(pdev);
>  	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
>  
> @@ -184,8 +184,9 @@ static int pwm_backlight_suspend(struct platform_device *pdev,
>  	return 0;
>  }
>  
> -static int pwm_backlight_resume(struct platform_device *pdev)
> +static int pwm_backlight_resume(struct device *dev)
>  {
> +	struct platform_device *pdev = to_platform_device(dev);
>  	struct backlight_device *bl = platform_get_drvdata(pdev);
>  
>  	backlight_update_status(bl);
> @@ -196,15 +197,19 @@ static int pwm_backlight_resume(struct platform_device *pdev)
>  #define pwm_backlight_resume	NULL
>  #endif
>  
> +static const struct dev_pm_ops pwm_backlight_pm_ops = {
> +	.suspend = pwm_backlight_suspend,
> +	.resume = pwm_backlight_resume,
> +};


Why not use SIMPLE_DEV_PM_OPS instead?

Thanks
-Wanlong Gao

> +
>  static struct platform_driver pwm_backlight_driver = {
>  	.driver		= {
>  		.name	= "pwm-backlight",
>  		.owner	= THIS_MODULE,
> +		.pm	= &pwm_backlight_pm_ops,
>  	},
>  	.probe		= pwm_backlight_probe,
>  	.remove		= pwm_backlight_remove,
> -	.suspend	= pwm_backlight_suspend,
> -	.resume		= pwm_backlight_resume,
>  };
>  
>  static int __init pwm_backlight_init(void)


