Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab2K1W0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:26:24 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:55692 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab2K1W0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:26:21 -0500
MIME-Version: 1.0
In-Reply-To: <1353398902-21253-1-git-send-email-ying.huang@intel.com>
References: <1353398902-21253-1-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 28 Nov 2012 15:25:59 -0700
Message-ID: <CAErSpo6CPSMXjq1eSTX41vtwOcd5rQOdC0-9ye5NZhds9U1B8A@mail.gmail.com>
Subject: Re: [PATCH] PCI/PM: Keep runtime PM enabled for unbound PCI devices
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 1:08 AM, Huang Ying <ying.huang@intel.com> wrote:
> For unbound PCI devices, what we need is:
>
>  - Always in D0 state, because some devices does not work again after
>    being put into D3 by the PCI bus.
>
>  - In SUSPENDED state if allowed, so that the parent devices can still
>    be put into low power state.
>
> To satisfy these requirement, the runtime PM for the unbound PCI
> devices are disabled and set to SUSPENDED state.  One issue of this
> solution is that the PCI devices will be put into SUSPENDED state even
> if the SUSPENDED state is forbidden via the sysfs interface
> (.../power/control) of the device.  This is not an issue for most
> devices, because most PCI devices are not used at all if unbounded.
> But there are exceptions.  For example, unbound VGA card can be used
> for display, but suspend its parents make it stop working.
>
> To fix the issue, we keep the runtime PM enabled when the PCI devices
> are unbound.  But the runtime PM callbacks will do nothing if the PCI
> devices are unbound.  This way, we can put the PCI devices into
> SUSPENDED state without put the PCI devices into D3 state.

Does this fix a reported problem?  Is there a bug report URL?  What
problem would a user notice?

This doesn't look critical enough to try to put in v3.7 (correct me if
I'm wrong).  It's getting pretty late for the v3.8 merge window, but
it looks like it qualifies as a bug fix that we would merge even after
the merge window, so I'll put it in my -next branch headed for v3.8.
Then it can be backported to v3.6 and v3.7.

> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> CC: stable@vger.kernel.org          # v3.6+
> ---
>  drivers/pci/pci-driver.c |   69 +++++++++++++++++++++++++++--------------------
>  drivers/pci/pci.c        |    2 +
>  2 files changed, 43 insertions(+), 28 deletions(-)
>
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1900,6 +1900,8 @@ void pci_pm_init(struct pci_dev *dev)
>         u16 pmc;
>
>         pm_runtime_forbid(&dev->dev);
> +       pm_runtime_set_active(&dev->dev);
> +       pm_runtime_enable(&dev->dev);
>         device_enable_async_suspend(&dev->dev);
>         dev->wakeup_prepared = false;
>
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -256,31 +256,26 @@ struct drv_dev_and_id {
>  static long local_pci_probe(void *_ddi)
>  {
>         struct drv_dev_and_id *ddi = _ddi;
> -       struct device *dev = &ddi->dev->dev;
> -       struct device *parent = dev->parent;
> +       struct pci_dev *pci_dev = ddi->dev;
> +       struct pci_driver *pci_drv = ddi->drv;
> +       struct device *dev = &pci_dev->dev;
>         int rc;
>
> -       /* The parent bridge must be in active state when probing */
> -       if (parent)
> -               pm_runtime_get_sync(parent);
> -       /* Unbound PCI devices are always set to disabled and suspended.
> -        * During probe, the device is set to enabled and active and the
> -        * usage count is incremented.  If the driver supports runtime PM,
> -        * it should call pm_runtime_put_noidle() in its probe routine and
> -        * pm_runtime_get_noresume() in its remove routine.
> -        */
> -       pm_runtime_get_noresume(dev);
> -       pm_runtime_set_active(dev);
> -       pm_runtime_enable(dev);
> -
> -       rc = ddi->drv->probe(ddi->dev, ddi->id);
> +       /*
> +        * Unbound PCI devices are always put in D0, regardless of
> +        * runtime PM status.  During probe, the device is set to
> +        * active and the usage count is incremented.  If the driver
> +        * supports runtime PM, it should call pm_runtime_put_noidle()
> +        * in its probe routine and pm_runtime_get_noresume() in its
> +        * remove routine.
> +        */
> +       pm_runtime_get_sync(dev);
> +       pci_dev->driver = pci_drv;
> +       rc = pci_drv->probe(pci_dev, ddi->id);
>         if (rc) {
> -               pm_runtime_disable(dev);
> -               pm_runtime_set_suspended(dev);
> -               pm_runtime_put_noidle(dev);
> +               pci_dev->driver = NULL;
> +               pm_runtime_put_sync(dev);
>         }
> -       if (parent)
> -               pm_runtime_put(parent);
>         return rc;
>  }
>
> @@ -330,10 +325,8 @@ __pci_device_probe(struct pci_driver *dr
>                 id = pci_match_device(drv, pci_dev);
>                 if (id)
>                         error = pci_call_probe(drv, pci_dev, id);
> -               if (error >= 0) {
> -                       pci_dev->driver = drv;
> +               if (error >= 0)
>                         error = 0;
> -               }
>         }
>         return error;
>  }
> @@ -369,9 +362,7 @@ static int pci_device_remove(struct devi
>         }
>
>         /* Undo the runtime PM settings in local_pci_probe() */
> -       pm_runtime_disable(dev);
> -       pm_runtime_set_suspended(dev);
> -       pm_runtime_put_noidle(dev);
> +       pm_runtime_put_sync(dev);
>
>         /*
>          * If the device is still on, set the power state as "unknown",
> @@ -994,6 +985,13 @@ static int pci_pm_runtime_suspend(struct
>         pci_power_t prev = pci_dev->current_state;
>         int error;
>
> +       /*
> +        * If pci_dev->driver is not set (unbound), the device should
> +        * always remain in D0 regardless of the runtime PM status
> +        */
> +       if (!pci_dev->driver)
> +               return 0;
> +
>         if (!pm || !pm->runtime_suspend)
>                 return -ENOSYS;
>
> @@ -1029,6 +1027,13 @@ static int pci_pm_runtime_resume(struct
>         struct pci_dev *pci_dev = to_pci_dev(dev);
>         const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>
> +       /*
> +        * If pci_dev->driver is not set (unbound), the device should
> +        * always remain in D0 regardless of the runtime PM status
> +        */
> +       if (!pci_dev->driver)
> +               return 0;
> +
>         if (!pm || !pm->runtime_resume)
>                 return -ENOSYS;
>
> @@ -1046,8 +1051,16 @@ static int pci_pm_runtime_resume(struct
>
>  static int pci_pm_runtime_idle(struct device *dev)
>  {
> +       struct pci_dev *pci_dev = to_pci_dev(dev);
>         const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>
> +       /*
> +        * If pci_dev->driver is not set (unbound), the device should
> +        * always remain in D0 regardless of the runtime PM status
> +        */
> +       if (!pci_dev->driver)
> +               goto out;
> +
>         if (!pm)
>                 return -ENOSYS;
>
> @@ -1057,8 +1070,8 @@ static int pci_pm_runtime_idle(struct de
>                         return ret;
>         }
>
> +out:
>         pm_runtime_suspend(dev);
> -
>         return 0;
>  }
>
