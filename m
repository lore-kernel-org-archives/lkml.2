Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab0GKV2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 17:28:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38222 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab0GKV2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 17:28:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH v2] pm: Add runtime PM statistics
Date: Sun, 11 Jul 2010 23:26:07 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <tom.leiming@gmail.com>
References: <20100710095254.5ab7291c@infradead.org>
In-Reply-To: <20100710095254.5ab7291c@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007112326.07541.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 10, 2010, Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH v2] pm: Add runtime PM statistics
> 
> In order for PowerTOP to be able to report how well the new runtime PM is working
> for the various drivers, the kernel needs to export some basic statistics in sysfs.
> 
> This patch adds two sysfs files in the runtime PM domain that expose the
> total time a device has been active, and the time a device has been suspended.
> 
> With this PowerTOP can compute the activity percentage
> 
> Active %age = 100 * (delta active) / (delta active + delta suspended)
> 
> and present the information to the user.
> 
> I've written the PowerTOP code (slated for version 1.12) already, and the output looks
> like this:
> 
> Runtime Device Power Management statistics
> Active  Device name
>  10.0%	06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller 
> 
> 
> 
> [version 2: fix stat update bugs noticed by Alan Stern]
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index b0ec0e9..b78c401 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
...
>  
> +static ssize_t rtpm_active_time_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	int ret;
> +	spin_lock_irq(&dev->power.lock);
> +	update_pm_runtime_accounting(dev);
> +	ret = sprintf(buf, "%i\n", jiffies_to_msecs(dev->power.active_jiffies));
> +	spin_unlock_irq(&dev->power.lock);
> +	return ret;
> +}
> +
> +static ssize_t rtpm_suspended_time_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	int ret;
> +	spin_lock_irq(&dev->power.lock);
> +	update_pm_runtime_accounting(dev);
> +	ret = sprintf(buf, "%i\n",
> +		jiffies_to_msecs(dev->power.suspended_jiffies));
> +	spin_unlock_irq(&dev->power.lock);
> +	return ret;
> +}
> +
>  static DEVICE_ATTR(runtime_usage, 0444, rtpm_usagecount_show, NULL);
>  static DEVICE_ATTR(runtime_active_kids, 0444, rtpm_children_show, NULL);
>  static DEVICE_ATTR(runtime_status, 0444, rtpm_status_show, NULL);
> +static DEVICE_ATTR(runtime_active_time, 0444, rtpm_active_time_show, NULL);
> +static DEVICE_ATTR(runtime_suspended_time, 0444, rtpm_suspended_time_show, NULL);
>  static DEVICE_ATTR(runtime_enabled, 0444, rtpm_enabled_show, NULL);

On a second thought, "active_time" and "suspended_time" should be sufficient
(ie. the "runtime_" prefix is not really necessary).

Rafael
