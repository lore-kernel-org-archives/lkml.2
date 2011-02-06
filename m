Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1BFPuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 10:50:11 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62139 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1BFPuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 10:50:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nZR+5fF87kgPdQVONZpjr77Vc15i4VyjPFHyayjovZh+72fv5lxaqbaz6Ea8O2AeGW
         IpEpITLDwjBkXELqZyvOIPk8PAIC2zuvX3SF962rRLnoENba7y6U+gQsCp5tw2Rn7uiG
         AZnTEH/xurfIahTNYii/DUzp7Rgm8BUZRc+8o=
MIME-Version: 1.0
In-Reply-To: <201102061519.11360.rjw@sisk.pl>
References: <201102061519.11360.rjw@sisk.pl>
Date: Mon, 7 Feb 2011 00:50:08 +0900
Message-ID: <AANLkTikDn_SN4Xi_u8Z6W7tBX+f9pgYEKLRibiC1QQWD@mail.gmail.com>
Subject: Re: [PATCH] PM: Do not create wakeup sysfs files for devices that
 cannot wake up (v2)
From: Minchan Kim <minchan.kim@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 6, 2011 at 11:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> Below is the next version of the patch changing the PM core to only create
> wakeup sysfs files for devices that are wakeup-capable.  It contains a change
> in drivers/usb/core/hub.c that should avoid the problem described in the thread
> at https://lkml.org/lkml/2011/2/5/108 , but I'm not 100% it's the right
> approach.  Please have a look.
>
> Thanks,
> Rafael
>
>
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Don't create wakeup sysfs files for devices that can't wake up (v2)
>
> Currently, wakeup sysfs attributes are created for all devices,
> regardless of whether or not they are wakeup-capable.  This is
> excessive and complicates wakeup device identification from user
> space (i.e. to identify wakeup-capable devices user space has to read
> /sys/devices/.../power/wakeup for all devices and see if they are not
> empty).
>
> Fix this issue by avoiding to create wakeup sysfs files for devices
> that cannot wake up the system from sleep states (i.e. whose
> power.can_wakeup flags are unset during registration) and modify
> device_set_wakeup_capable() so that it adds (or removes) the relevant
> sysfs attributes if a device's wakeup capability status is changed.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  Documentation/ABI/testing/sysfs-devices-power |   20 +++---
>  Documentation/power/devices.txt               |   20 +++---
>  drivers/base/power/power.h                    |   21 +++----
>  drivers/base/power/sysfs.c                    |   78 +++++++++++++++++---------
>  drivers/base/power/wakeup.c                   |   26 ++++++++
>  drivers/usb/core/hub.c                        |   10 ++-
>  include/linux/pm_runtime.h                    |    6 ++
>  include/linux/pm_wakeup.h                     |   10 ---
>  8 files changed, 121 insertions(+), 70 deletions(-)
>
> Index: linux-2.6/drivers/base/power/sysfs.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/sysfs.c
> +++ linux-2.6/drivers/base/power/sysfs.c
> @@ -431,26 +431,18 @@ static ssize_t async_store(struct device
>  static DEVICE_ATTR(async, 0644, async_show, async_store);
>  #endif /* CONFIG_PM_ADVANCED_DEBUG */
>
> -static struct attribute * power_attrs[] = {
> -       &dev_attr_wakeup.attr,
> -#ifdef CONFIG_PM_SLEEP
> -       &dev_attr_wakeup_count.attr,
> -       &dev_attr_wakeup_active_count.attr,
> -       &dev_attr_wakeup_hit_count.attr,
> -       &dev_attr_wakeup_active.attr,
> -       &dev_attr_wakeup_total_time_ms.attr,
> -       &dev_attr_wakeup_max_time_ms.attr,
> -       &dev_attr_wakeup_last_time_ms.attr,
> -#endif
> +static struct attribute *power_attrs[] = {
>  #ifdef CONFIG_PM_ADVANCED_DEBUG
> +#ifdef CONFIG_PM_SLEEP
>        &dev_attr_async.attr,
> +#endif
>  #ifdef CONFIG_PM_RUNTIME
>        &dev_attr_runtime_status.attr,
>        &dev_attr_runtime_usage.attr,
>        &dev_attr_runtime_active_kids.attr,
>        &dev_attr_runtime_enabled.attr,
>  #endif
> -#endif
> +#endif /* CONFIG_PM_ADVANCED_DEBUG */
>        NULL,
>  };
>  static struct attribute_group pm_attr_group = {
> @@ -458,9 +450,26 @@ static struct attribute_group pm_attr_gr
>        .attrs  = power_attrs,
>  };
>
> -#ifdef CONFIG_PM_RUNTIME
> +static struct attribute *wakeup_attrs[] = {
> +#ifdef CONFIG_PM_SLEEP
> +       &dev_attr_wakeup.attr,
> +       &dev_attr_wakeup_count.attr,
> +       &dev_attr_wakeup_active_count.attr,
> +       &dev_attr_wakeup_hit_count.attr,
> +       &dev_attr_wakeup_active.attr,
> +       &dev_attr_wakeup_total_time_ms.attr,
> +       &dev_attr_wakeup_max_time_ms.attr,
> +       &dev_attr_wakeup_last_time_ms.attr,
> +#endif
> +       NULL,
> +};
> +static struct attribute_group pm_wakeup_attr_group = {
> +       .name   = power_group_name,
> +       .attrs  = wakeup_attrs,
> +};
>
>  static struct attribute *runtime_attrs[] = {
> +#ifdef CONFIG_PM_RUNTIME
>  #ifndef CONFIG_PM_ADVANCED_DEBUG
>        &dev_attr_runtime_status.attr,
>  #endif
> @@ -468,6 +477,7 @@ static struct attribute *runtime_attrs[]
>        &dev_attr_runtime_suspended_time.attr,
>        &dev_attr_runtime_active_time.attr,
>        &dev_attr_autosuspend_delay_ms.attr,
> +#endif /* CONFIG_PM_RUNTIME */
>        NULL,
>  };
>  static struct attribute_group pm_runtime_attr_group = {
> @@ -480,35 +490,49 @@ int dpm_sysfs_add(struct device *dev)
>        int rc;
>
>        rc = sysfs_create_group(&dev->kobj, &pm_attr_group);
> -       if (rc == 0 && !dev->power.no_callbacks) {
> +       if (rc)
> +               return rc;
> +
> +       if (pm_runtime_callbacks_present(dev)) {
>                rc = sysfs_merge_group(&dev->kobj, &pm_runtime_attr_group);
>                if (rc)
> -                       sysfs_remove_group(&dev->kobj, &pm_attr_group);
> +                       goto err_out;
> +       }
> +
> +       if (device_can_wakeup(dev)) {
> +               rc = sysfs_merge_group(&dev->kobj, &pm_wakeup_attr_group);
> +               if (rc) {
> +                       if (pm_runtime_callbacks_present(dev))
> +                               sysfs_unmerge_group(&dev->kobj,
> +                                                   &pm_runtime_attr_group);
> +                       goto err_out;
> +               }
>        }
> +       return 0;
> +
> + err_out:
> +       sysfs_remove_group(&dev->kobj, &pm_attr_group);
>        return rc;
>  }
>
> -void rpm_sysfs_remove(struct device *dev)
> +int wakeup_sysfs_add(struct device *dev)
>  {
> -       sysfs_unmerge_group(&dev->kobj, &pm_runtime_attr_group);
> +       return sysfs_merge_group(&dev->kobj, &pm_wakeup_attr_group);
>  }
>
> -void dpm_sysfs_remove(struct device *dev)
> +void wakeup_sysfs_remove(struct device *dev)
>  {
> -       rpm_sysfs_remove(dev);
> -       sysfs_remove_group(&dev->kobj, &pm_attr_group);
> +       sysfs_unmerge_group(&dev->kobj, &pm_wakeup_attr_group);
>  }
>
> -#else /* CONFIG_PM_RUNTIME */
> -
> -int dpm_sysfs_add(struct device * dev)
> +void rpm_sysfs_remove(struct device *dev)
>  {
> -       return sysfs_create_group(&dev->kobj, &pm_attr_group);
> +       sysfs_unmerge_group(&dev->kobj, &pm_runtime_attr_group);
>  }
>
> -void dpm_sysfs_remove(struct device * dev)
> +void dpm_sysfs_remove(struct device *dev)
>  {
> +       rpm_sysfs_remove(dev);
> +       sysfs_unmerge_group(&dev->kobj, &pm_wakeup_attr_group);
>        sysfs_remove_group(&dev->kobj, &pm_attr_group);
>  }
> -
> -#endif
> Index: linux-2.6/include/linux/pm_runtime.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pm_runtime.h
> +++ linux-2.6/include/linux/pm_runtime.h
> @@ -87,6 +87,11 @@ static inline bool pm_runtime_enabled(st
>        return !dev->power.disable_depth;
>  }
>
> +static inline bool pm_runtime_callbacks_present(struct device *dev)
> +{
> +       return !dev->power.no_callbacks;
> +}
> +
>  static inline void pm_runtime_mark_last_busy(struct device *dev)
>  {
>        ACCESS_ONCE(dev->power.last_busy) = jiffies;
> @@ -133,6 +138,7 @@ static inline int pm_generic_runtime_res
>  static inline void pm_runtime_no_callbacks(struct device *dev) {}
>  static inline void pm_runtime_irq_safe(struct device *dev) {}
>
> +static inline bool pm_runtime_callbacks_present(struct device *dev) { return false; }
>  static inline void pm_runtime_mark_last_busy(struct device *dev) {}
>  static inline void __pm_runtime_use_autosuspend(struct device *dev,
>                                                bool use) {}
> Index: linux-2.6/drivers/base/power/power.h
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/power.h
> +++ linux-2.6/drivers/base/power/power.h
> @@ -58,19 +58,18 @@ static inline void device_pm_move_last(s
>  * sysfs.c
>  */
>
> -extern int dpm_sysfs_add(struct device *);
> -extern void dpm_sysfs_remove(struct device *);
> -extern void rpm_sysfs_remove(struct device *);
> +extern int dpm_sysfs_add(struct device *dev);
> +extern void dpm_sysfs_remove(struct device *dev);
> +extern void rpm_sysfs_remove(struct device *dev);
> +extern int wakeup_sysfs_add(struct device *dev);
> +extern void wakeup_sysfs_remove(struct device *dev);
>
>  #else /* CONFIG_PM */
>
> -static inline int dpm_sysfs_add(struct device *dev)
> -{
> -       return 0;
> -}
> -
> -static inline void dpm_sysfs_remove(struct device *dev)
> -{
> -}
> +static inline int dpm_sysfs_add(struct device *dev) { return 0; }
> +static inline void dpm_sysfs_remove(struct device *dev) {}
> +static inline void rpm_sysfs_remove(struct device *dev) {}
> +static inline int wakeup_sysfs_add(struct device *dev) { return 0; }
> +static inline void wakeup_sysfs_remove(struct device *dev) {}
>
>  #endif
> Index: linux-2.6/include/linux/pm_wakeup.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pm_wakeup.h
> +++ linux-2.6/include/linux/pm_wakeup.h
> @@ -62,18 +62,11 @@ struct wakeup_source {
>  * Changes to device_may_wakeup take effect on the next pm state change.
>  */
>
> -static inline void device_set_wakeup_capable(struct device *dev, bool capable)
> -{
> -       dev->power.can_wakeup = capable;
> -}
> -
>  static inline bool device_can_wakeup(struct device *dev)
>  {
>        return dev->power.can_wakeup;
>  }
>
> -
> -
>  static inline bool device_may_wakeup(struct device *dev)
>  {
>        return dev->power.can_wakeup && !!dev->power.wakeup;
> @@ -88,6 +81,7 @@ extern struct wakeup_source *wakeup_sour
>  extern void wakeup_source_unregister(struct wakeup_source *ws);
>  extern int device_wakeup_enable(struct device *dev);
>  extern int device_wakeup_disable(struct device *dev);
> +extern void device_set_wakeup_capable(struct device *dev, bool capable);
>  extern int device_init_wakeup(struct device *dev, bool val);
>  extern int device_set_wakeup_enable(struct device *dev, bool enable);
>  extern void __pm_stay_awake(struct wakeup_source *ws);
> @@ -144,7 +138,7 @@ static inline int device_wakeup_disable(
>
>  static inline int device_init_wakeup(struct device *dev, bool val)
>  {
> -       dev->power.can_wakeup = val;
> +       device_set_wakeup_capable(dev, val);
>        return val ? -EINVAL : 0;
>  }
>
> Index: linux-2.6/drivers/base/power/wakeup.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/wakeup.c
> +++ linux-2.6/drivers/base/power/wakeup.c
> @@ -242,6 +242,32 @@ int device_wakeup_disable(struct device
>  EXPORT_SYMBOL_GPL(device_wakeup_disable);
>
>  /**
> + * device_set_wakeup_capable - Set/reset device wakeup capability flag.
> + * @dev: Device to handle.
> + * @capable: Whether or not @dev is capable of waking up the system from sleep.
> + *
> + * If @capable is set, set the @dev's power.can_wakeup flag and add its
> + * wakeup-related attributes to sysfs.  Otherwise, unset the @dev's
> + * power.can_wakeup flag and remove its wakeup-related attributes from sysfs.
> + */
> +void device_set_wakeup_capable(struct device *dev, bool capable)
> +{
> +       if (!!dev->power.can_wakeup == !!capable)
> +               return;
> +
> +       if (device_is_registered(dev)) {
> +               if (capable) {
> +                       if (wakeup_sysfs_add(dev))
> +                               return;
> +               } else {
> +                       wakeup_sysfs_remove(dev);
> +               }
> +       }
> +       dev->power.can_wakeup = capable;
> +}
> +EXPORT_SYMBOL_GPL(device_set_wakeup_capable);
> +
> +/**
>  * device_init_wakeup - Device wakeup initialization.
>  * @dev: Device to handle.
>  * @enable: Whether or not to enable @dev as a wakeup device.
> Index: linux-2.6/Documentation/power/devices.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/power/devices.txt
> +++ linux-2.6/Documentation/power/devices.txt
> @@ -159,18 +159,18 @@ matter, and the kernel is responsible fo
>  whether or not a wakeup-capable device should issue wakeup events is a policy
>  decision, and it is managed by user space through a sysfs attribute: the
>  power/wakeup file.  User space can write the strings "enabled" or "disabled" to
> -set or clear the should_wakeup flag, respectively.  Reads from the file will
> -return the corresponding string if can_wakeup is true, but if can_wakeup is
> -false then reads will return an empty string, to indicate that the device
> -doesn't support wakeup events.  (But even though the file appears empty, writes
> -will still affect the should_wakeup flag.)
> +set or clear the "should_wakeup" flag, respectively.  This file is only present
> +for wakeup-capable devices (i.e. devices whose "can_wakeup" flags are set)
> +and is created (or removed) by device_set_wakeup_capable().  Reads from the
> +file will return the corresponding string.
>
>  The device_may_wakeup() routine returns true only if both flags are set.
> -Drivers should check this routine when putting devices in a low-power state
> -during a system sleep transition, to see whether or not to enable the devices'
> -wakeup mechanisms.  However for runtime power management, wakeup events should
> -be enabled whenever the device and driver both support them, regardless of the
> -should_wakeup flag.
> +This information is used by subsystems, like the PCI bus type code, to see
> +whether or not to enable the devices' wakeup mechanisms.  If device wakeup
> +mechanisms are enabled or disabled directly by drivers, they also should use
> +device_may_wakeup() to decide what to do during a system sleep transition.
> +However for runtime power management, wakeup events should be enabled whenever
> +the device and driver both support them, regardless of the should_wakeup flag.
>
>
>  /sys/devices/.../power/control files
> Index: linux-2.6/Documentation/ABI/testing/sysfs-devices-power
> ===================================================================
> --- linux-2.6.orig/Documentation/ABI/testing/sysfs-devices-power
> +++ linux-2.6/Documentation/ABI/testing/sysfs-devices-power
> @@ -29,9 +29,8 @@ Description:
>                "disabled" to it.
>
>                For the devices that are not capable of generating system wakeup
> -               events this file contains "\n".  In that cases the user space
> -               cannot modify the contents of this file and the device cannot be
> -               enabled to wake up the system.
> +               events this file is not present.  In that case the device cannot
> +               be enabled to wake up the system from sleep states.
>
>  What:          /sys/devices/.../power/control
>  Date:          January 2009
> @@ -85,7 +84,7 @@ Description:
>                The /sys/devices/.../wakeup_count attribute contains the number
>                of signaled wakeup events associated with the device.  This
>                attribute is read-only.  If the device is not enabled to wake up
> -               the system from sleep states, this attribute is empty.
> +               the system from sleep states, this attribute is not present.
>
>  What:          /sys/devices/.../power/wakeup_active_count
>  Date:          September 2010
> @@ -95,7 +94,7 @@ Description:
>                number of times the processing of wakeup events associated with
>                the device was completed (at the kernel level).  This attribute
>                is read-only.  If the device is not enabled to wake up the
> -               system from sleep states, this attribute is empty.
> +               system from sleep states, this attribute is not present.
>
>  What:          /sys/devices/.../power/wakeup_hit_count
>  Date:          September 2010
> @@ -105,7 +104,8 @@ Description:
>                number of times the processing of a wakeup event associated with
>                the device might prevent the system from entering a sleep state.
>                This attribute is read-only.  If the device is not enabled to
> -               wake up the system from sleep states, this attribute is empty.
> +               wake up the system from sleep states, this attribute is not
> +               present.
>
>  What:          /sys/devices/.../power/wakeup_active
>  Date:          September 2010
> @@ -115,7 +115,7 @@ Description:
>                or 0, depending on whether or not a wakeup event associated with
>                the device is being processed (1).  This attribute is read-only.
>                If the device is not enabled to wake up the system from sleep
> -               states, this attribute is empty.
> +               states, this attribute is not present.
>
>  What:          /sys/devices/.../power/wakeup_total_time_ms
>  Date:          September 2010
> @@ -125,7 +125,7 @@ Description:
>                the total time of processing wakeup events associated with the
>                device, in milliseconds.  This attribute is read-only.  If the
>                device is not enabled to wake up the system from sleep states,
> -               this attribute is empty.
> +               this attribute is not present.
>
>  What:          /sys/devices/.../power/wakeup_max_time_ms
>  Date:          September 2010
> @@ -135,7 +135,7 @@ Description:
>                the maximum time of processing a single wakeup event associated
>                with the device, in milliseconds.  This attribute is read-only.
>                If the device is not enabled to wake up the system from sleep
> -               states, this attribute is empty.
> +               states, this attribute is not present.
>
>  What:          /sys/devices/.../power/wakeup_last_time_ms
>  Date:          September 2010
> @@ -146,7 +146,7 @@ Description:
>                signaling the last wakeup event associated with the device, in
>                milliseconds.  This attribute is read-only.  If the device is
>                not enabled to wake up the system from sleep states, this
> -               attribute is empty.
> +               attribute is not present.
>
>  What:          /sys/devices/.../power/autosuspend_delay_ms
>  Date:          September 2010
> Index: linux-2.6/drivers/usb/core/hub.c
> ===================================================================
> --- linux-2.6.orig/drivers/usb/core/hub.c
> +++ linux-2.6/drivers/usb/core/hub.c
> @@ -1465,6 +1465,7 @@ void usb_set_device_state(struct usb_dev
>                enum usb_device_state new_state)
>  {
>        unsigned long flags;
> +       int wakeup = -1;
>
>        spin_lock_irqsave(&device_state_lock, flags);
>        if (udev->state == USB_STATE_NOTATTACHED)
> @@ -1479,11 +1480,10 @@ void usb_set_device_state(struct usb_dev
>                                        || new_state == USB_STATE_SUSPENDED)
>                                ;       /* No change to wakeup settings */
>                        else if (new_state == USB_STATE_CONFIGURED)
> -                               device_set_wakeup_capable(&udev->dev,
> -                                       (udev->actconfig->desc.bmAttributes
> -                                        & USB_CONFIG_ATT_WAKEUP));
> +                               wakeup = udev->actconfig->desc.bmAttributes
> +                                        & USB_CONFIG_ATT_WAKEUP;
>                        else
> -                               device_set_wakeup_capable(&udev->dev, 0);
> +                               wakeup = 0;
>                }
>                if (udev->state == USB_STATE_SUSPENDED &&
>                        new_state != USB_STATE_SUSPENDED)
> @@ -1495,6 +1495,8 @@ void usb_set_device_state(struct usb_dev
>        } else
>                recursively_mark_NOTATTACHED(udev);
>        spin_unlock_irqrestore(&device_state_lock, flags);
> +       if (wakeup >= 0)
> +               device_set_wakeup_capable(&udev->dev, wakeup);
>  }
>  EXPORT_SYMBOL_GPL(usb_set_device_state);
>
>

I can't say the work of usb since I am not a expert about that.
Anyway, the patch works well in my machine.
Just a nitpick.

Please, add a kind comment for new exported device_set_wakeup_capable
to show the function should be called by process context.

Feel free to use below signs.

Reported-by: Minchan Kim <minchan.kim@gmail.com>
Tested-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
