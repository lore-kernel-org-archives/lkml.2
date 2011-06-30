Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab1F3GOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 02:14:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60462 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1F3GOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 02:14:42 -0400
MIME-Version: 1.0
In-Reply-To: <201106252326.23837.rjw@sisk.pl>
References: <201106112223.04972.rjw@sisk.pl>
	<201106252324.13454.rjw@sisk.pl>
	<201106252326.23837.rjw@sisk.pl>
Date: Thu, 30 Jun 2011 14:14:40 +0800
Message-ID: <BANLkTi=tipUrzeKJeQirrNWyE0KMS1+DYw@mail.gmail.com>
Subject: Re: [PATCH 3/10 v6] PM / Domains: Support for generic I/O PM domains (v7)
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 26, 2011 at 5:26 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>

> +static void genpd_power_off_work_fn(struct work_struct *work)
> +{
> +       struct generic_pm_domain *genpd;
> +
> +       genpd = container_of(work, struct generic_pm_domain, power_off_work);
> +
> +       if (genpd->parent)
> +               mutex_lock(&genpd->parent->lock);
> +       mutex_lock(&genpd->lock);

lockdep warning may be triggered if LOCKDEP is enabled, so the
mutex_lock for subdomain should be replaced as mutex_lock_nest.

> +       pm_genpd_poweroff(genpd);
> +       mutex_unlock(&genpd->lock);
> +       if (genpd->parent)
> +               mutex_unlock(&genpd->parent->lock);
> +}
> +
> +/**
> + * pm_genpd_runtime_suspend - Suspend a device belonging to I/O PM domain.
> + * @dev: Device to suspend.
> + *
> + * Carry out a runtime suspend of a device under the assumption that its
> + * pm_domain field points to the domain member of an object of type
> + * struct generic_pm_domain representing a PM domain consisting of I/O devices.
> + */
> +static int pm_genpd_runtime_suspend(struct device *dev)
> +{
> +       struct generic_pm_domain *genpd;
> +
> +       dev_dbg(dev, "%s()\n", __func__);
> +
> +       if (IS_ERR_OR_NULL(dev->pm_domain))
> +               return -EINVAL;
> +
> +       genpd = container_of(dev->pm_domain, struct generic_pm_domain, domain);
> +
> +       if (genpd->parent)
> +               mutex_lock(&genpd->parent->lock);
> +       mutex_lock(&genpd->lock);

same with above.

> +       if (genpd->stop_device) {
> +               int ret = genpd->stop_device(dev);
> +               if (ret)
> +                       goto out;
> +       }
> +       genpd->in_progress++;
> +       pm_genpd_poweroff(genpd);
> +       genpd->in_progress--;
> +
> + out:
> +       mutex_unlock(&genpd->lock);
> +       if (genpd->parent)
> +               mutex_unlock(&genpd->parent->lock);
> +
> +       return 0;
> +}
> +
> +/**
> + * pm_genpd_poweron - Restore power to a given PM domain and its parents.
> + * @genpd: PM domain to power up.
> + *
> + * Restore power to @genpd and all of its parents so that it is possible to
> + * resume a device belonging to it.
> + */
> +static int pm_genpd_poweron(struct generic_pm_domain *genpd)
> +{
> +       int ret = 0;
> +
> + start:
> +       if (genpd->parent)
> +               mutex_lock(&genpd->parent->lock);
> +       mutex_lock(&genpd->lock);

same with above

> +       if (!genpd->power_is_off)
> +               goto out;
> +
> +       if (genpd->parent && genpd->parent->power_is_off) {
> +               mutex_unlock(&genpd->lock);
> +               mutex_unlock(&genpd->parent->lock);
> +
> +               ret = pm_genpd_poweron(genpd->parent);
> +               if (ret)
> +                       return ret;
> +
> +               goto start;
> +       }
> +
> +       if (genpd->power_on) {
> +               int ret = genpd->power_on(genpd);
> +               if (ret)
> +                       goto out;
> +       }
> +
> +       genpd->power_is_off = false;
> +       if (genpd->parent)
> +               genpd->parent->sd_count++;
> +
> + out:
> +       mutex_unlock(&genpd->lock);
> +       if (genpd->parent)
> +               mutex_unlock(&genpd->parent->lock);
> +
> +       return ret;
> +}
> +
> +/**
> + * pm_genpd_runtime_resume - Resume a device belonging to I/O PM domain.
> + * @dev: Device to resume.
> + *
> + * Carry out a runtime resume of a device under the assumption that its
> + * pm_domain field points to the domain member of an object of type
> + * struct generic_pm_domain representing a PM domain consisting of I/O devices.
> + */
> +static int pm_genpd_runtime_resume(struct device *dev)
> +{
> +       struct generic_pm_domain *genpd;
> +       struct dev_list_entry *dle;
> +       int ret;
> +
> +       dev_dbg(dev, "%s()\n", __func__);
> +
> +       if (IS_ERR_OR_NULL(dev->pm_domain))
> +               return -EINVAL;
> +
> +       genpd = container_of(dev->pm_domain, struct generic_pm_domain, domain);
> +
> +       ret = pm_genpd_poweron(genpd);
> +       if (ret)
> +               return ret;
> +
> +       mutex_lock(&genpd->lock);
> +
> +       list_for_each_entry(dle, &genpd->dev_list, node) {
> +               if (dle->dev == dev) {
> +                       __pm_genpd_restore_device(dle, genpd);
> +                       break;
> +               }
> +       }
> +
> +       if (genpd->start_device)
> +               genpd->start_device(dev);
> +
> +       mutex_unlock(&genpd->lock);
> +
> +       return 0;
> +}
> +
> +#else
> +
> +static inline void genpd_power_off_work_fn(struct work_struct *work) {}
> +
> +#define pm_genpd_runtime_suspend       NULL
> +#define pm_genpd_runtime_resume                NULL
> +
> +#endif /* CONFIG_PM_RUNTIME */
> +
> +/**
> + * pm_genpd_add_device - Add a device to an I/O PM domain.
> + * @genpd: PM domain to add the device to.
> + * @dev: Device to be added.
> + */
> +int pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev)
> +{
> +       struct dev_list_entry *dle;
> +       int ret = 0;
> +
> +       dev_dbg(dev, "%s()\n", __func__);
> +
> +       if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(dev))
> +               return -EINVAL;
> +
> +       mutex_lock(&genpd->lock);
> +
> +       if (genpd->power_is_off) {
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +       list_for_each_entry(dle, &genpd->dev_list, node)
> +               if (dle->dev == dev) {
> +                       ret = -EINVAL;
> +                       goto out;
> +               }
> +
> +       dle = kzalloc(sizeof(*dle), GFP_KERNEL);
> +       if (!dle) {
> +               ret = -ENOMEM;
> +               goto out;
> +       }
> +
> +       dle->dev = dev;
> +       dle->need_restore = false;
> +       list_add_tail(&dle->node, &genpd->dev_list);
> +
> +       spin_lock_irq(&dev->power.lock);
> +       dev->pm_domain = &genpd->domain;
> +       spin_unlock_irq(&dev->power.lock);
> +
> + out:
> +       mutex_unlock(&genpd->lock);
> +
> +       return ret;
> +}
> +
> +/**
> + * pm_genpd_remove_device - Remove a device from an I/O PM domain.
> + * @genpd: PM domain to remove the device from.
> + * @dev: Device to be removed.
> + */
> +int pm_genpd_remove_device(struct generic_pm_domain *genpd,
> +                          struct device *dev)
> +{
> +       struct dev_list_entry *dle;
> +       int ret = -EINVAL;
> +
> +       dev_dbg(dev, "%s()\n", __func__);
> +
> +       if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(dev))
> +               return -EINVAL;
> +
> +       mutex_lock(&genpd->lock);
> +
> +       list_for_each_entry(dle, &genpd->dev_list, node) {
> +               if (dle->dev != dev)
> +                       continue;
> +
> +               spin_lock_irq(&dev->power.lock);
> +               dev->pm_domain = NULL;
> +               spin_unlock_irq(&dev->power.lock);
> +
> +               list_del(&dle->node);
> +               kfree(dle);
> +
> +               ret = 0;
> +               break;
> +       }
> +
> +       mutex_unlock(&genpd->lock);
> +
> +       return ret;
> +}
> +
> +/**
> + * pm_genpd_add_subdomain - Add a subdomain to an I/O PM domain.
> + * @genpd: Master PM domain to add the subdomain to.
> + * @new_subdomain: Subdomain to be added.
> + */
> +int pm_genpd_add_subdomain(struct generic_pm_domain *genpd,
> +                          struct generic_pm_domain *new_subdomain)
> +{
> +       struct generic_pm_domain *subdomain;
> +       int ret = 0;
> +
> +       if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(new_subdomain))
> +               return -EINVAL;
> +
> +       mutex_lock(&genpd->lock);
> +
> +       if (genpd->power_is_off && !new_subdomain->power_is_off) {
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +       list_for_each_entry(subdomain, &genpd->sd_list, sd_node) {
> +               if (subdomain == new_subdomain) {
> +                       ret = -EINVAL;
> +                       goto out;
> +               }
> +       }
> +
> +       mutex_lock(&new_subdomain->lock);

same with above

> +
> +       list_add_tail(&new_subdomain->sd_node, &genpd->sd_list);
> +       new_subdomain->parent = genpd;
> +       if (!subdomain->power_is_off)
> +               genpd->sd_count++;
> +
> +       mutex_unlock(&new_subdomain->lock);
> +
> + out:
> +       mutex_unlock(&genpd->lock);
> +
> +       return ret;
> +}
> +
> +/**
> + * pm_genpd_remove_subdomain - Remove a subdomain from an I/O PM domain.
> + * @genpd: Master PM domain to remove the subdomain from.
> + * @target: Subdomain to be removed.
> + */
> +int pm_genpd_remove_subdomain(struct generic_pm_domain *genpd,
> +                             struct generic_pm_domain *target)
> +{
> +       struct generic_pm_domain *subdomain;
> +       int ret = -EINVAL;
> +
> +       if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(target))
> +               return -EINVAL;
> +
> +       mutex_lock(&genpd->lock);
> +
> +       list_for_each_entry(subdomain, &genpd->sd_list, sd_node) {
> +               if (subdomain != target)
> +                       continue;
> +
> +               mutex_lock(&subdomain->lock);

same with above

> +               list_del(&subdomain->sd_node);
> +               subdomain->parent = NULL;
> +               if (!subdomain->power_is_off)
> +                       genpd_sd_counter_dec(genpd);
> +
> +               mutex_unlock(&subdomain->lock);
> +
> +               ret = 0;
> +               break;
> +       }
> +
> +       mutex_unlock(&genpd->lock);
> +
> +       return ret;
> +}
> +
> +/**
> + * pm_genpd_init - Initialize a generic I/O PM domain object.
> + * @genpd: PM domain object to initialize.
> + * @gov: PM domain governor to associate with the domain (may be NULL).
> + * @is_off: Initial value of the domain's power_is_off field.
> + */
> +void pm_genpd_init(struct generic_pm_domain *genpd,
> +                  struct dev_power_governor *gov, bool is_off)
> +{
> +       if (IS_ERR_OR_NULL(genpd))
> +               return;
> +
> +       INIT_LIST_HEAD(&genpd->sd_node);
> +       genpd->parent = NULL;
> +       INIT_LIST_HEAD(&genpd->dev_list);
> +       INIT_LIST_HEAD(&genpd->sd_list);
> +       mutex_init(&genpd->lock);
> +       genpd->gov = gov;
> +       INIT_WORK(&genpd->power_off_work, genpd_power_off_work_fn);
> +       genpd->in_progress = 0;
> +       genpd->sd_count = 0;
> +       genpd->power_is_off = is_off;
> +       genpd->domain.ops.runtime_suspend = pm_genpd_runtime_suspend;
> +       genpd->domain.ops.runtime_resume = pm_genpd_runtime_resume;
> +       genpd->domain.ops.runtime_idle = pm_generic_runtime_idle;
> +}
> Index: linux-2.6/kernel/power/Kconfig
> ===================================================================
> --- linux-2.6.orig/kernel/power/Kconfig
> +++ linux-2.6/kernel/power/Kconfig
> @@ -227,3 +227,7 @@ config PM_OPP
>  config PM_RUNTIME_CLK
>        def_bool y
>        depends on PM_RUNTIME && HAVE_CLK
> +
> +config PM_GENERIC_DOMAINS
> +       bool
> +       depends on PM
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


thanks,
-- 
Ming Lei
