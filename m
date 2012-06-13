Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab2FMFQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 01:16:46 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:52007 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab2FMFQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 01:16:45 -0400
X-Greylist: delayed 2068 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2012 01:16:43 EDT
From: Xiaoguang Chen <chenxg@marvell.com>
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: =?ks_c_5601-1987?B?udqw5rnO?= <kyungmin.park@samsung.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Date: Tue, 12 Jun 2012 22:16:29 -0700
Subject: RE: [PATCH 2/2] PM: Devfreq: Add frequency get function in profile
Thread-Topic: [PATCH 2/2] PM: Devfreq: Add frequency get function in profile
Thread-Index: Ac1JIQ7iNVZAOjXDRp6x23iyJ9epZwAAmHTg
Message-ID: <4737A960563B524DA805CA602BE04B3064CBDF6710@SC-VEXCH2.marvell.com>
References: <1290271.915811339563455292.JavaMail.weblogic@epml04>
In-Reply-To: <1290271.915811339563455292.JavaMail.weblogic@epml04>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="ks_c_5601-1987"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5D5H3Lq022426

Ok, I got it. So this patch has no too much use.

Thanks
Xiaoguang


-----Original Message-----
From: MyungJoo Ham [mailto:myungjoo.ham@samsung.com] 
Sent: 2012Ò´6êÅ13ìí 12:58
To: Xiaoguang Chen; linux-kernel@vger.kernel.org
Cc: ¹Ú°æ¹Î; linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 2/2] PM: Devfreq: Add frequency get function in profile

> when devfreq set one frequency, the final frequency may not the same 
> as the requested frequency. Add get function in profile to let devfreq 
> driver return the final frequency.
> 
> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>

That is why in update_freq() function that you've modified uses:

err = devfreq->profile->target(devfreq->dev.parent, &freq, flags);

not

err = devfreq->profile->target(devfreq->dev.parent, freq, flags);

The target function will return the configured frequency right there.
Calling "__devfreq_get()" at the same location wouldn't help as long as the "target()" callback is implemented correctly.



Cheers!
MyungJoo

> ---
>  drivers/devfreq/devfreq.c |   12 +++++++++++-
>  include/linux/devfreq.h   |    2 ++
>  2 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c 
> index 2144200..50a4fc0 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -72,6 +72,16 @@ static struct devfreq *find_device_devfreq(struct device *dev)
>  	return ERR_PTR(-ENODEV);
>  }
>  
> +static unsigned long __devfreq_get(struct device *dev) {
> +	struct devfreq *devfreq = to_devfreq(dev);
> +	unsigned long ret_freq = devfreq->previous_freq;
> +	if (!devfreq->profile->get)
> +		return ret_freq;
> +	ret_freq = devfreq->profile->get(devfreq->dev.parent);
> +	return ret_freq;
> +}
> +
>  /**
>   * update_devfreq() - Reevaluate the device and configure frequency.
>   * @devfreq:	the devfreq instance.
> @@ -116,7 +126,7 @@ int update_devfreq(struct devfreq *devfreq)
>  	if (err)
>  		return err;
>  
> -	devfreq->previous_freq = freq;
> +	devfreq->previous_freq = __devfreq_get(&devfreq->dev);
>  	return err;
>  }
>  
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h index 
> e5e4036..f789314 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -65,6 +65,7 @@ struct devfreq_frequency_table {
>   * @initial_freq	The operating frequency when devfreq_add_device() is
>   *			called.
>   * @polling_ms		The polling interval in ms. 0 disables polling.
> + * @get			Get the devices's actual frequency
>   * @target		The device should set its operating frequency at
>   *			freq or lowest-upper-than-freq value. If freq is
>   *			higher than any operable frequency, set maximum.
> @@ -84,6 +85,7 @@ struct devfreq_dev_profile {
>  	unsigned long initial_freq;
>  	unsigned int polling_ms;
>  
> +	unsigned long	(*get)(struct device *dev);
>  	int (*target)(struct device *dev, unsigned long *freq, u32 flags);
>  	int (*get_dev_status)(struct device *dev,
>  			      struct devfreq_dev_status *stat);
> --
> 1.7.0.4
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
