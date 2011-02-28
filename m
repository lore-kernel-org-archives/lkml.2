Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1B1W0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 17:26:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562Ab1B1W0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 17:26:17 -0500
Date: Mon, 28 Feb 2011 14:25:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, ben@simtec.co.uk,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: rtc-s3c: fix prototype for s3c_rtc_setaie()
Message-Id: <20110228142528.bb69cd73.akpm@linux-foundation.org>
In-Reply-To: <1297416172.14816.2.camel@mola>
References: <1297416172.14816.2.camel@mola>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011 17:22:52 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> Fix s3c_rtc_setaie() prototype to eliminate below compile warning.
> drivers/rtc/rtc-s3c.c:383: warning: initialization from incompatible pointer type
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/rtc/rtc-s3c.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
> index cf953ec..b80fa28 100644
> --- a/drivers/rtc/rtc-s3c.c
> +++ b/drivers/rtc/rtc-s3c.c
> @@ -77,18 +77,20 @@ static irqreturn_t s3c_rtc_tickirq(int irq, void *id)
>  }
>  
>  /* Update control registers */
> -static void s3c_rtc_setaie(int to)
> +static int s3c_rtc_setaie(struct device *dev, unsigned int enabled)
>  {
>  	unsigned int tmp;
>  
> -	pr_debug("%s: aie=%d\n", __func__, to);
> +	pr_debug("%s: aie=%d\n", __func__, enabled);
>  
>  	tmp = readb(s3c_rtc_base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
>  
> -	if (to)
> +	if (enabled)
>  		tmp |= S3C2410_RTCALM_ALMEN;
>  
>  	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
> +
> +	return 0;
>  }
>  
>  static int s3c_rtc_setpie(struct device *dev, int enabled)
> @@ -308,7 +310,7 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
>  
>  	writeb(alrm_en, base + S3C2410_RTCALM);
>  
> -	s3c_rtc_setaie(alrm->enabled);
> +	s3c_rtc_setaie(dev, alrm->enabled);
>  
>  	return 0;
>  }
> @@ -440,7 +442,7 @@ static int __devexit s3c_rtc_remove(struct platform_device *dev)
>  	rtc_device_unregister(rtc);
>  
>  	s3c_rtc_setpie(&dev->dev, 0);
> -	s3c_rtc_setaie(0);
> +	s3c_rtc_setaie(&dev->dev, 0);
>  
>  	clk_disable(rtc_clk);
>  	clk_put(rtc_clk);

This does more than fix a warning!  The rtc_class_ops.alarm_irq_enable()
handler was being passed two arguments where it expected one and it
wouldn't have functioned correctly.
