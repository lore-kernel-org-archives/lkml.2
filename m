Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238Ab2EDT3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:29:05 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab2EDT3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:29:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC v2 2/5] PM, Add sysfs file power_off to control device power off policy
Date: Fri, 4 May 2012 21:33:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>, Lan Tianyu <tianyu.lan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <1336119221-21146-3-git-send-email-ying.huang@intel.com>
In-Reply-To: <1336119221-21146-3-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201205042133.51339.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 04, 2012, Huang Ying wrote:
> From: Lan Tianyu <tianyu.lan@intel.com>
> 
> Some devices can be powered off to save more power via some platform
> mechanism, e.g., ACPI.  But that may not work as expected for some
> device or platform.  So, this patch adds a sysfs file named power_off
> under <device>/power directory to provide a mechanism for user to control
> whether to allow the device to be power off.
> 
> power_off => "enabled" means allowing the device to be powered off if
> possible.
> 
> power_off => "disabled" means the device must be power on anytime.
> 
> Also add flag power_off_user to struct dev_pm_info to record users'
> choice. The bus layer can use this field to determine whether to
> power off the device.

It looks like the new attribute is added for all devices regardless of whether
or not they actually can be powered off?  If so, then please don't do that,
it's _extremely_ confusing.

If you need user space to be able to control that functionality (and I can
think of a couple of cases in which you do), there need to be 2 flags,
can_power_off and may_power_off, where the first one is set by the kernel
if it is known that power can be removed from the device - the attribute
should be created when this flag is set and removed when it is unset.

Then, the setting of the second flag will be controlled by the new attribute.

And you'll need to patch quite a few places where devices actually have that
capability, like where power domains are in use, so that's quire a lot of
work.

Thanks,
Rafael


> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/base/power/sysfs.c |   33 +++++++++++++++++++++++++++++++++
>  include/linux/pm.h         |    1 +
>  2 files changed, 34 insertions(+)
> 
> --- a/drivers/base/power/sysfs.c
> +++ b/drivers/base/power/sysfs.c
> @@ -243,6 +243,38 @@ static ssize_t pm_qos_latency_store(stru
>  
>  static DEVICE_ATTR(pm_qos_resume_latency_us, 0644,
>  		   pm_qos_latency_show, pm_qos_latency_store);
> +
> +static ssize_t power_off_show(struct device *dev,
> +			      struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%s\n",
> +		       dev->power.power_off_user ? enabled : disabled);
> +}
> +
> +static ssize_t power_off_store(struct device * dev,
> +			       struct device_attribute *attr,
> +			       const char * buf, size_t n)
> +{
> +	char *cp;
> +	int len = n;
> +	unsigned int power_off_user;
> +
> +	cp = memchr(buf, '\n', n);
> +	if (cp)
> +		len = cp - buf;
> +
> +	if (len == sizeof enabled - 1 && strncmp(buf, enabled, len) == 0)
> +		dev->power.power_off_user = true;
> +	else if (len == sizeof disabled - 1 && strncmp(buf, disabled, len) == 0)
> +		dev->power.power_off_user = false;
> +	else
> +		return -EINVAL;
> +
> +	pm_runtime_resume(dev);
> +	return n;
> +
> +}
> +static DEVICE_ATTR(power_off, 0644, power_off_show, power_off_store);
>  #endif /* CONFIG_PM_RUNTIME */
>  
>  #ifdef CONFIG_PM_SLEEP
> @@ -508,6 +540,7 @@ static struct attribute *runtime_attrs[]
>  	&dev_attr_runtime_suspended_time.attr,
>  	&dev_attr_runtime_active_time.attr,
>  	&dev_attr_autosuspend_delay_ms.attr,
> +	&dev_attr_power_off.attr,
>  #endif /* CONFIG_PM_RUNTIME */
>  	NULL,
>  };
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -537,6 +537,7 @@ struct dev_pm_info {
>  	unsigned int		use_autosuspend:1;
>  	unsigned int		timer_autosuspends:1;
>  	unsigned int		power_must_be_on:1;
> +	unsigned int		power_off_user:1;
>  	enum rpm_request	request;
>  	enum rpm_status		runtime_status;
>  	int			runtime_error;
> 
> 

