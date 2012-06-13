Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab2FME5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 00:57:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20805 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2FME5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 00:57:38 -0400
X-AuditID: cbfee610-b7fcc6d00000671d-f6-4fd81dc05a5b
Date: Wed, 13 Jun 2012 04:57:36 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 2/2] PM: Devfreq: Add frequency get function in profile
To: Xiaoguang Chen <chenxg@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120613045449328@myungjoo.ham
Msgkey: 20120613045449328@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120613045449328@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1290271.915811339563455292.JavaMail.weblogic@epml04>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t/tmboHZG/4G2yJtri8aw6bA6PH501y
	AYxRXDYpqTmZZalF+nYJXBk3l/AWHJKteLfwC3MD4x2ZLkZODiEBdYlFS06ydTFycEgImEgs
	aqoGCUsIiElcuLceKMwFVDKfUeLJyguMIAkWAVWJI5v3s4PUswnoScz8nAwSFhbwlpjyfSE7
	iC0ikCXRv+gHO0gvs8AERoljr3ayQ+xSkliz7xULiM0rIChxcuYTFohlqhInT55khoirSfxo
	2csIEZeQmDX9AiuEzSsxo/0pVL2cxLSva5ghbGmJ87M2MMIcvfj7Y6g4v8Sx2zuYIP7ilXhy
	PxhmzO7NX9ggbAGJqWcOQrVqSbTPfAgV55NYs/At2CpmAUWJKd0P2SFsLYkvP/axoTufV8BR
	4ljbSsYJjDKzkKRmIWmfhaQdWc0CRpZVjKKpBckFxUnpqWZ6xYm5xaV56XrJ+bmbGMER+0xg
	B+OSBotDjAIcjEo8vAskb/gLsSaWFVfmHmKU4GBWEuEt3nrdX4g3JbGyKrUoP76oNCe1+BCj
	NAeLkjhvr/UFfyGB9MSS1OzU1ILUIpgsEwenVANjH4/emfgIkWvnjX6u/lMTqD331KmCwuNi
	3gsv52hPnBpbIrChiuHJ5ualwbeUpPu8VIqYvQ9b3DSYkaVS3Pxsf9nyq8YFK6YLNh0yuHxX
	fAnjVVNNvp3tLSs7GItSb6c/c/6yU+TXu1aeH1mhvNvdRc/N2jpdrsFQW/nxip3JsypFVpZ3
	qdUrsRRnJBpqMRcVJwIAwirwz9QCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5D4vjQr022385

> when devfreq set one frequency, the final frequency may not
> the same as the requested frequency. Add get function in profile
> to let devfreq driver return the final frequency.
> 
> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>

That is why in update_freq() function that you've modified uses:

err = devfreq->profile->target(devfreq->dev.parent, &freq, flags);

not

err = devfreq->profile->target(devfreq->dev.parent, freq, flags);

The target function will return the configured frequency right there.
Calling "__devfreq_get()" at the same location wouldn't help as long as
the "target()" callback is implemented correctly.



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
> +static unsigned long __devfreq_get(struct device *dev)
> +{
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
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index e5e4036..f789314 100644
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
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
