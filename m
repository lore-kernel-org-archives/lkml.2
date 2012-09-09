Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2IIVo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 17:44:59 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44441 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab2IIVo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 17:44:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: Re: [PATCH 2/3] devfreq: Add suspend and resume apis
Date: Sun, 9 Sep 2012 23:51:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: mturquette@linaro.org, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1346682578-24312-1-git-send-email-rajagopal.venkat@linaro.org> <1346682578-24312-3-git-send-email-rajagopal.venkat@linaro.org>
In-Reply-To: <1346682578-24312-3-git-send-email-rajagopal.venkat@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201209092351.18297.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 03, 2012, Rajagopal Venkat wrote:
> Add devfreq suspend/resume apis for devfreq users. This patch
> supports suspend and resume of devfreq load monitoring, required
> for devices which can idle.
> 
> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>

I'd call the new functions devfreq_dev_suspend() and devfreq_dev_resume(),
respectively, because the names you're using currently suggest that the
device itself is suspended/resumed, which isn't the case.

Thanks,
Rafael


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
> 

