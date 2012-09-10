Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab2IJJ2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:28:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63214 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab2IJJ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:27:59 -0400
X-AuditID: cbfee612-b7f5c6d0000048e4-71-504db29c2b4a
Date: Mon, 10 Sep 2012 09:27:56 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 2/3] devfreq: Add suspend and resume apis
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>
Cc: "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120910091659373@myungjoo.ham
Msgkey: 20120910091659373@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120910091659373@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <23261060.329611347269273674.JavaMail.weblogic@epml28>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/tmbpzNvkGGDTtNbK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZR6f+YCr4YlRx7NNi1gbGE4ZdjJwcQgLqEouWnGQDsSUETCT2
	3VzMCGGLSVy4tx4ozgVUM59R4lXDV9YuRg4OFgFViZ5eTRCTTUBPYubnZJByYQFbiWsrboKV
	iwgcZ5T4ufkDE0iCWeAZo8S57R4Qu5Qk1ux7xQJi8woISpyc+YQFYpeqxIEv3VBxNYkPG+ZB
	3SAhMWv6BVYIm1diRvtTqHo5iWlf1zBD2NIS52dtgLt58ffHUHF+iWO3dzCB3AnS++R+MMyY
	3Zu/QL0rIDH1zEGoVi2JGUueQtl8EmsWvmWBGbPr1HJmmN77W+ZCvaUoMaX7ITuErSXx5cc+
	NnRv8Qo4SVy93806gVFuFpLULCTts5C0I6tZwMiyilE0tSC5oDgpPdVCrzgxt7g0L10vOT93
	EyM4yp8J7WBc1mBxiFGAg1GJh7fTxDdAiDWxrLgy9xCjBAezkgivSB9QiDclsbIqtSg/vqg0
	J7X4EKM0B4uSOO+cF1/8hQTSE0tSs1NTC1KLYLJMHJxSDYyHzq1SunKts0N+Utm2RWvf91QJ
	r7zH7bhL4YpP20uFn/VLkv69SM71L9uhs3r9042BLEujalbO5Y85Z+sTpO/p6MIs/l3PVjyA
	taVUtd2+Iz3iaMlMib3ZzP8jRMLryh08tc7dn33WdebFtcnpW5VcOu69jLlyoME9dvL1mmV1
	bw6s/No0i0eJpTgj0VCLuag4EQDBtb+q7gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8A9S9GW017015

> Add devfreq suspend/resume apis for devfreq users. This patch
> supports suspend and resume of devfreq load monitoring, required
> for devices which can idle.
> 
> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>

Rather than letting device driver be responsible to call devfreq_suspend_device() or devfreq_dev_suspend(),would there be any problems in using pm notifier here? (calling the event handler with DEVFREQ_GOV_SUSPEND/RESUME at pm notifier, stopping them earlier and resuming tham later)

What devfreq-core and devfreq-governors do with suspend/resume is handling the delayed workqueue and it does not have anything to do with device-specific tasks. Thus, having each device driver handle device-specifics with its own pm_ops and having devfreq-core stop sampling seem appropriate.

Putting another burden to each device driver (to call devfreq_suspend/resume_device() at its pm_ops) for an obvious task that could be done at core doesn't seem fair.

Thank you.



Cheers!
MyungJoo

> ---
>  drivers/devfreq/devfreq.c                 | 26 ++++++++++++++++++++++++++
>  drivers/devfreq/governor.h                |  2 ++
>  drivers/devfreq/governor_simpleondemand.c |  9 +++++++++
>  include/linux/devfreq.h                   | 12 ++++++++++++
>  4 files changed, 49 insertions(+)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index be524c7..3a5f126 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -365,6 +365,32 @@ int devfreq_remove_device(struct devfreq *devfreq)
>  }
>  EXPORT_SYMBOL(devfreq_remove_device);
>  
> +/**
> + * devfreq_suspend_device() - Suspend devfreq of a device.
> + * @devfreq	the devfreq instance to be suspended
> + */
> +int devfreq_suspend_device(struct devfreq *devfreq)
> +{
> +	if (!devfreq)
> +		return -EINVAL;
> +
> +	return devfreq->governor->event_handler(devfreq, DEVFREQ_GOV_SUSPEND);
> +}
> +EXPORT_SYMBOL(devfreq_suspend_device);
> +
> +/**
> + * devfreq_resume_device() - Resume devfreq of a device.
> + * @devfreq	the devfreq instance to be resumed
> + */
> +int devfreq_resume_device(struct devfreq *devfreq)
> +{
> +	if (!devfreq)
> +		return -EINVAL;
> +
> +	return devfreq->governor->event_handler(devfreq, DEVFREQ_GOV_RESUME);
> +}
> +EXPORT_SYMBOL(devfreq_resume_device);
> +
>  static ssize_t show_governor(struct device *dev,
>  			     struct device_attribute *attr, char *buf)
>  {
> diff --git a/drivers/devfreq/governor.h b/drivers/devfreq/governor.h
> index 4a86af7..7dbbdfc 100644
> --- a/drivers/devfreq/governor.h
> +++ b/drivers/devfreq/governor.h
> @@ -22,6 +22,8 @@
>  #define DEVFREQ_GOV_START			0x1
>  #define DEVFREQ_GOV_STOP			0x2
>  #define DEVFREQ_GOV_INTERVAL			0x3
> +#define DEVFREQ_GOV_SUSPEND			0x4
> +#define DEVFREQ_GOV_RESUME			0x5
>  
>  /* Caution: devfreq->lock must be locked before calling update_devfreq */
>  extern int update_devfreq(struct devfreq *devfreq);
> diff --git a/drivers/devfreq/governor_simpleondemand.c b/drivers/devfreq/governor_simpleondemand.c
> index 9802bf9..35b8e8e 100644
> --- a/drivers/devfreq/governor_simpleondemand.c
> +++ b/drivers/devfreq/governor_simpleondemand.c
> @@ -113,6 +113,15 @@ int devfreq_simple_ondemand_handler(struct devfreq *devfreq,
>  		else
>  			ret = devfreq_monitor_resume(devfreq);
>  		break;
> +
> +	case DEVFREQ_GOV_SUSPEND:
> +		ret = devfreq_monitor_suspend(devfreq);
> +		break;
> +
> +	case DEVFREQ_GOV_RESUME:
> +		ret = devfreq_monitor_resume(devfreq);
> +		break;
> +
>  	default:
>  		break;
>  	}
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index 7a11c3e..7c7e179 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -155,6 +155,8 @@ extern struct devfreq *devfreq_add_device(struct device *dev,
>  				  const struct devfreq_governor *governor,
>  				  void *data);
>  extern int devfreq_remove_device(struct devfreq *devfreq);
> +extern int devfreq_suspend_device(struct devfreq *devfreq);
> +extern int devfreq_resume_device(struct devfreq *devfreq);
>  
>  /* Helper functions for devfreq user device driver with OPP. */
>  extern struct opp *devfreq_recommended_opp(struct device *dev,
> @@ -208,6 +210,16 @@ static int devfreq_remove_device(struct devfreq *devfreq)
>  	return 0;
>  }
>  
> +static int devfreq_suspend_device(struct devfreq *devfreq)
> +{
> +	return 0;
> +}
> +
> +static int devfreq_resume_device(struct devfreq *devfreq)
> +{
> +	return 0;
> +}
> +
>  static struct opp *devfreq_recommended_opp(struct device *dev,
>  					   unsigned long *freq, u32 flags)
>  {
> -- 
> 1.7.11.3
> 
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
