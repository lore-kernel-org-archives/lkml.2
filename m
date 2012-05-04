Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab2EDTvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:51:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35651 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab2EDTvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:51:16 -0400
MIME-Version: 1.0
In-Reply-To: <1336119221-21146-3-git-send-email-ying.huang@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <1336119221-21146-3-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 4 May 2012 13:50:55 -0600
Message-ID: <CAErSpo7yRWCWKrd93AJ3b1VZW-_gWeJgru4cfHN7cp3wFmW96w@mail.gmail.com>
Subject: Re: [RFC v2 2/5] PM, Add sysfs file power_off to control device power
 off policy
To: Huang Ying <ying.huang@intel.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zheng Yan <zheng.z.yan@intel.com>, Lan Tianyu <tianyu.lan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 2:13 AM, Huang Ying <ying.huang@intel.com> wrote:
> From: Lan Tianyu <tianyu.lan@intel.com>
>
> Some devices can be powered off to save more power via some platform
> mechanism, e.g., ACPI.  But that may not work as expected for some
> device or platform.  So, this patch adds a sysfs file named power_off
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

My first thought was that writing to "power_off" would actually turn
the power off, which isn't true.  Maybe something like
"poweroff_allowed" would work.

I think there's only one use of this new field, in
pci_pm_runtime_suspend().  Maybe you could pull out that hunk from
patch 5, combine it with this one, and move it to after patch 5?

> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/base/power/sysfs.c |   33 +++++++++++++++++++++++++++++++++
>  include/linux/pm.h         |    1 +
>  2 files changed, 34 insertions(+)
>
> --- a/drivers/base/power/sysfs.c
> +++ b/drivers/base/power/sysfs.c
> @@ -243,6 +243,38 @@ static ssize_t pm_qos_latency_store(stru
>
>  static DEVICE_ATTR(pm_qos_resume_latency_us, 0644,
>                   pm_qos_latency_show, pm_qos_latency_store);
> +
> +static ssize_t power_off_show(struct device *dev,
> +                             struct device_attribute *attr, char *buf)
> +{
> +       return sprintf(buf, "%s\n",
> +                      dev->power.power_off_user ? enabled : disabled);
> +}
> +
> +static ssize_t power_off_store(struct device * dev,
> +                              struct device_attribute *attr,
> +                              const char * buf, size_t n)
> +{
> +       char *cp;
> +       int len = n;
> +       unsigned int power_off_user;
> +
> +       cp = memchr(buf, '\n', n);
> +       if (cp)
> +               len = cp - buf;
> +
> +       if (len == sizeof enabled - 1 && strncmp(buf, enabled, len) == 0)
> +               dev->power.power_off_user = true;
> +       else if (len == sizeof disabled - 1 && strncmp(buf, disabled, len) == 0)
> +               dev->power.power_off_user = false;
> +       else
> +               return -EINVAL;
> +
> +       pm_runtime_resume(dev);
> +       return n;
> +
> +}
> +static DEVICE_ATTR(power_off, 0644, power_off_show, power_off_store);
>  #endif /* CONFIG_PM_RUNTIME */
>
>  #ifdef CONFIG_PM_SLEEP
> @@ -508,6 +540,7 @@ static struct attribute *runtime_attrs[]
>        &dev_attr_runtime_suspended_time.attr,
>        &dev_attr_runtime_active_time.attr,
>        &dev_attr_autosuspend_delay_ms.attr,
> +       &dev_attr_power_off.attr,
>  #endif /* CONFIG_PM_RUNTIME */
>        NULL,
>  };
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -537,6 +537,7 @@ struct dev_pm_info {
>        unsigned int            use_autosuspend:1;
>        unsigned int            timer_autosuspends:1;
>        unsigned int            power_must_be_on:1;
> +       unsigned int            power_off_user:1;

This name definitely doesn't suggest anything useful  I think
"poweroff_allowed" or similar would make a lot more sense when reading
the code.

>        enum rpm_request        request;
>        enum rpm_status         runtime_status;
>        int                     runtime_error;
