Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab1IEHwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 03:52:02 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63479 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1IEHvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 03:51:55 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.117.118]
In-Reply-To: <201109031002.51487.rjw@sisk.pl>
References: <201108310017.03103.rjw@sisk.pl>
	<CAORVsuVAzc8Q2tG0-WW+96Ad9GhR5OCq2bAuweggs1rimFMcqg@mail.gmail.com>
	<201109030155.28031.rjw@sisk.pl>
	<201109031002.51487.rjw@sisk.pl>
Date: Mon, 5 Sep 2011 09:51:54 +0200
Message-ID: <CAORVsuXtgd6hTvpkoHobSGKrXgMB1L8dSVbkkt071useNRdngg@mail.gmail.com>
Subject: Re: [PATCH 3/5] PM / QoS: Add function dev_pm_qos_read_value()
From: Jean Pihet <jean.pihet@newoldbits.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Sep 3, 2011 at 10:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> On Saturday, September 03, 2011, Rafael J. Wysocki wrote:
>> On Friday, September 02, 2011, Jean Pihet wrote:
>> > On Fri, Sep 2, 2011 at 12:07 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> ...
>> > >> >
>> > >> > -       mutex_lock(&dev_pm_qos_mtx);
>> > >> >        req->dev = dev;
>> > >> >
>> > >> > -       /* Return if the device has been removed */
>> > >> > -       if (req->dev->power.constraints_state == DEV_PM_QOS_NO_DEVICE) {
>> > >> > -               ret = -ENODEV;
>> > >> > -               goto out;
>> > >> > -       }
>> > >> > +       device_pm_lock();
>> > >> > +       mutex_lock(&dev_pm_qos_mtx);
>> > >> >
>> > >> > -       /*
>> > >> > -        * Allocate the constraints data on the first call to add_request,
>> > >> > -        * i.e. only if the data is not already allocated and if the device has
>> > >> > -        * not been removed
>> > >> > -        */
>> > >> > -       if (dev->power.constraints_state == DEV_PM_QOS_DEVICE_PRESENT)
>> > >> > -               ret = dev_pm_qos_constraints_allocate(dev);
>> > >> > +       if (dev->power.constraints) {
>> > >> > +               device_pm_unlock();
>> > >> > +       } else {
>> > >> > +               if (list_empty(&dev->power.entry)) {
>> > >> > +                       /* The device has been removed from the system. */
>> > >> > +                       device_pm_unlock();
>> > >> > +                       goto out;
>> > >> 0 is silently returned in case the device has been removed. Is that
>> > >> the intention?
>> > >
>> > > Pretty much it is.  Is that a problem?
>> > I think the caller needs to know if the constraint has been applied
>> > correctly or not.
>>
>> However, the removal of the device is a special case.  What would the caller
>> be supposed to do when it learned that the device had been removed while it had
>> been trying to add a QoS constraing for it?  Not much I guess.
>
> Anyway, since returning an error code in that case won't hurt either,
> below is a v2 of the patch doing that and resetting the dev field in the
> req structure.
Ok thanks for the update. The comments are inlined below.

>
> Thanks,
> Rafael
>
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / QoS: Add function dev_pm_qos_read_value() (v2)
>
> To read the current PM QoS value for a given device we need to
> make sure that the device's power.constraints object won't be
> removed while we're doing that.  For this reason, put the
> operation under dev->power.lock and acquire the lock
> around the initialization and removal of power.constraints.
>
> Moreover, since we're using the value of power.constraints to
> determine whether or not the object is present, the
> power.constraints_state field isn't necessary any more and may be
> removed.  However, dev_pm_qos_add_request() needs to check if the
> device is being removed from the system before allocating a new
> PM QoS constraints object for it, so it has to use device_pm_lock()
> and the device PM QoS initialization and destruction should be done
> under device_pm_lock() as well.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/main.c |    4 -
>  drivers/base/power/qos.c  |  170 ++++++++++++++++++++++++++--------------------
>  include/linux/pm.h        |    8 --
>  include/linux/pm_qos.h    |    3
>  4 files changed, 104 insertions(+), 81 deletions(-)
>
> Index: linux/drivers/base/power/qos.c
> ===================================================================
> --- linux.orig/drivers/base/power/qos.c
> +++ linux/drivers/base/power/qos.c
> @@ -30,15 +30,6 @@
>  * . To minimize the data usage by the per-device constraints, the data struct
>  *   is only allocated at the first call to dev_pm_qos_add_request.
>  * . The data is later free'd when the device is removed from the system.
> - * . The constraints_state variable from dev_pm_info tracks the data struct
> - *    allocation state:
> - *    DEV_PM_QOS_NO_DEVICE: No device present or device removed, no data
> - *     allocated,
> - *    DEV_PM_QOS_DEVICE_PRESENT: Device present, data not allocated and will be
> - *     allocated at the first call to dev_pm_qos_add_request,
> - *    DEV_PM_QOS_ALLOCATED: Device present, data allocated. The per-device
> - *     PM QoS constraints framework is operational and constraints can be
> - *     added, updated or removed using the dev_pm_qos_* API.
>  *  . A global mutex protects the constraints users from the data being
>  *     allocated and free'd.
>  */
> @@ -51,8 +42,30 @@
>
>
>  static DEFINE_MUTEX(dev_pm_qos_mtx);
> +
>  static BLOCKING_NOTIFIER_HEAD(dev_pm_notifiers);
>
> +/**
> + * dev_pm_qos_read_value - Get PM QoS constraint for a given device.
> + * @dev: Device to get the PM QoS constraint value for.
> + */
> +s32 dev_pm_qos_read_value(struct device *dev)
> +{
> +       struct pm_qos_constraints *c;
> +       unsigned long flags;
> +       s32 ret = 0;
> +
> +       spin_lock_irqsave(&dev->power.lock, flags);
> +
> +       c = dev->power.constraints;
> +       if (c)
> +               ret = pm_qos_read_value(c);
> +
> +       spin_unlock_irqrestore(&dev->power.lock, flags);
> +
> +       return ret;
> +}
> +
>  /*
>  * apply_constraint
>  * @req: constraint request to apply
> @@ -105,27 +118,37 @@ static int dev_pm_qos_constraints_alloca
>        }
>        BLOCKING_INIT_NOTIFIER_HEAD(n);
>
> +       plist_head_init(&c->list);
> +       c->target_value = PM_QOS_DEV_LAT_DEFAULT_VALUE;
> +       c->default_value = PM_QOS_DEV_LAT_DEFAULT_VALUE;
> +       c->type = PM_QOS_MIN;
> +       c->notifiers = n;
> +
> +       spin_lock_irq(&dev->power.lock);
>        dev->power.constraints = c;
> -       plist_head_init(&dev->power.constraints->list);
> -       dev->power.constraints->target_value = PM_QOS_DEV_LAT_DEFAULT_VALUE;
> -       dev->power.constraints->default_value = PM_QOS_DEV_LAT_DEFAULT_VALUE;
> -       dev->power.constraints->type = PM_QOS_MIN;
> -       dev->power.constraints->notifiers = n;
> -       dev->power.constraints_state = DEV_PM_QOS_ALLOCATED;
> +       spin_unlock_irq(&dev->power.lock);
>
>        return 0;
>  }
>
> +static void __dev_pm_qos_constraints_init(struct device *dev)
> +{
> +       spin_lock_irq(&dev->power.lock);
> +       dev->power.constraints = NULL;
> +       spin_unlock_irq(&dev->power.lock);
> +}
> +
>  /**
> - * dev_pm_qos_constraints_init
> + * dev_pm_qos_constraints_init - Initalize device's PM QoS constraints pointer.
>  * @dev: target device
>  *
> - * Called from the device PM subsystem at device insertion
> + * Called from the device PM subsystem at device insertion under
> + * device_pm_lock().
>  */
>  void dev_pm_qos_constraints_init(struct device *dev)
>  {
>        mutex_lock(&dev_pm_qos_mtx);
> -       dev->power.constraints_state = DEV_PM_QOS_DEVICE_PRESENT;
> +       dev->power.constraints = NULL;
>        mutex_unlock(&dev_pm_qos_mtx);
>  }
>
> @@ -133,34 +156,35 @@ void dev_pm_qos_constraints_init(struct
>  * dev_pm_qos_constraints_destroy
>  * @dev: target device
>  *
> - * Called from the device PM subsystem at device removal
> + * Called from the device PM subsystem at device removal under device_pm_lock().
>  */
>  void dev_pm_qos_constraints_destroy(struct device *dev)
>  {
>        struct dev_pm_qos_request *req, *tmp;
> +       struct pm_qos_constraints *c;
>
>        mutex_lock(&dev_pm_qos_mtx);
>
> -       if (dev->power.constraints_state == DEV_PM_QOS_ALLOCATED) {
> -               /* Flush the constraints list for the device */
> -               plist_for_each_entry_safe(req, tmp,
> -                                         &dev->power.constraints->list,
> -                                         node) {
> -                       /*
> -                        * Update constraints list and call the notification
> -                        * callbacks if needed
> -                        */
> -                       apply_constraint(req, PM_QOS_REMOVE_REQ,
> -                                        PM_QOS_DEFAULT_VALUE);
> -                       memset(req, 0, sizeof(*req));
> -               }
> +       c = dev->power.constraints;
> +       if (!c)
> +               goto out;
>
> -               kfree(dev->power.constraints->notifiers);
> -               kfree(dev->power.constraints);
> -               dev->power.constraints = NULL;
> +       /* Flush the constraints list for the device */
> +       plist_for_each_entry_safe(req, tmp, &c->list, node) {
> +               /*
> +                * Update constraints list and call the notification
> +                * callbacks if needed
> +                */
> +               apply_constraint(req, PM_QOS_REMOVE_REQ, PM_QOS_DEFAULT_VALUE);
> +               memset(req, 0, sizeof(*req));
>        }
> -       dev->power.constraints_state = DEV_PM_QOS_NO_DEVICE;
>
> +       __dev_pm_qos_constraints_init(dev);
> +
> +       kfree(c->notifiers);
> +       kfree(c);
> +
> + out:
>        mutex_unlock(&dev_pm_qos_mtx);
>  }
>
> @@ -178,8 +202,9 @@ void dev_pm_qos_constraints_destroy(stru
>  *
>  * Returns 1 if the aggregated constraint value has changed,
>  * 0 if the aggregated constraint value has not changed,
> - * -EINVAL in case of wrong parameters, -ENODEV if the device has been
> - * removed from the system
> + * -EINVAL in case of wrong parameters, -ENOMEM if there's not enough memory
> + * to allocate for data structures, -ENODEV if the device has just been removed
> + * from the system.
>  */
>  int dev_pm_qos_add_request(struct device *dev, struct dev_pm_qos_request *req,
>                           s32 value)
> @@ -195,28 +220,37 @@ int dev_pm_qos_add_request(struct device
>                return -EINVAL;
>        }
>
> -       mutex_lock(&dev_pm_qos_mtx);
>        req->dev = dev;
>
> -       /* Return if the device has been removed */
> -       if (req->dev->power.constraints_state == DEV_PM_QOS_NO_DEVICE) {
> -               ret = -ENODEV;
> -               goto out;
> -       }
> +       device_pm_lock();
> +       mutex_lock(&dev_pm_qos_mtx);
>
> -       /*
> -        * Allocate the constraints data on the first call to add_request,
> -        * i.e. only if the data is not already allocated and if the device has
> -        * not been removed
> -        */
> -       if (dev->power.constraints_state == DEV_PM_QOS_DEVICE_PRESENT)
> -               ret = dev_pm_qos_constraints_allocate(dev);
> +       if (dev->power.constraints) {
> +               device_pm_unlock();
> +       } else {
> +               if (list_empty(&dev->power.entry)) {
> +                       /* The device has been removed from the system. */
> +                       device_pm_unlock();
> +                       req->dev = NULL;
> +                       ret = -ENODEV;
> +                       goto out;
> +               } else {
> +                       device_pm_unlock();
> +                       /*
> +                        * Allocate the constraints data on the first call to
> +                        * add_request, i.e. only if the data is not already
> +                        * allocated and if the device has not been removed.
> +                        */
> +                       ret = dev_pm_qos_constraints_allocate(dev);
> +               }
> +       }
>
>        if (!ret)
>                ret = apply_constraint(req, PM_QOS_ADD_REQ, value);
>
> -out:
> + out:
>        mutex_unlock(&dev_pm_qos_mtx);
> +
>        return ret;
>  }
>  EXPORT_SYMBOL_GPL(dev_pm_qos_add_request);
> @@ -252,13 +286,13 @@ int dev_pm_qos_update_request(struct dev
>
>        mutex_lock(&dev_pm_qos_mtx);
>
> -       if (req->dev->power.constraints_state == DEV_PM_QOS_ALLOCATED) {
> +       if (req->dev->power.constraints) {
>                if (new_value != req->node.prio)
>                        ret = apply_constraint(req, PM_QOS_UPDATE_REQ,
>                                               new_value);
>        } else {
>                /* Return if the device has been removed */
> -               ret = -ENODEV;
> +               ret = -EINVAL;
The retcode should be -ENODEV. Is the kerneldoc still OK?

>        }
>
>        mutex_unlock(&dev_pm_qos_mtx);
> @@ -293,7 +327,7 @@ int dev_pm_qos_remove_request(struct dev
>
>        mutex_lock(&dev_pm_qos_mtx);
>
> -       if (req->dev->power.constraints_state == DEV_PM_QOS_ALLOCATED) {
> +       if (req->dev->power.constraints) {
>                ret = apply_constraint(req, PM_QOS_REMOVE_REQ,
>                                       PM_QOS_DEFAULT_VALUE);
>                memset(req, 0, sizeof(*req));
> @@ -323,15 +357,12 @@ int dev_pm_qos_add_notifier(struct devic
>
>        mutex_lock(&dev_pm_qos_mtx);
>
> -       /* Silently return if the device has been removed */
> -       if (dev->power.constraints_state != DEV_PM_QOS_ALLOCATED)
> -               goto out;
> -
> -       retval = blocking_notifier_chain_register(
> -                       dev->power.constraints->notifiers,
> -                       notifier);
> +       /* Silently return if the constraints object is not present. */
> +       if (dev->power.constraints)
> +               retval = blocking_notifier_chain_register(
> +                               dev->power.constraints->notifiers,
> +                               notifier);
>
> -out:
>        mutex_unlock(&dev_pm_qos_mtx);
>        return retval;
>  }
> @@ -354,15 +385,12 @@ int dev_pm_qos_remove_notifier(struct de
>
>        mutex_lock(&dev_pm_qos_mtx);
>
> -       /* Silently return if the device has been removed */
> -       if (dev->power.constraints_state != DEV_PM_QOS_ALLOCATED)
> -               goto out;
> -
> -       retval = blocking_notifier_chain_unregister(
> -                       dev->power.constraints->notifiers,
> -                       notifier);
> +       /* Silently return if the constraints object is not present. */
> +       if (dev->power.constraints)
> +               retval = blocking_notifier_chain_unregister(
> +                               dev->power.constraints->notifiers,
> +                               notifier);
>
> -out:
>        mutex_unlock(&dev_pm_qos_mtx);
>        return retval;
>  }
> Index: linux/include/linux/pm_qos.h
> ===================================================================
> --- linux.orig/include/linux/pm_qos.h
> +++ linux/include/linux/pm_qos.h
> @@ -77,6 +77,7 @@ int pm_qos_remove_notifier(int pm_qos_cl
>  int pm_qos_request_active(struct pm_qos_request *req);
>  s32 pm_qos_read_value(struct pm_qos_constraints *c);
>
> +s32 dev_pm_qos_read_value(struct device *dev);
>  int dev_pm_qos_add_request(struct device *dev, struct dev_pm_qos_request *req,
>                           s32 value);
>  int dev_pm_qos_update_request(struct dev_pm_qos_request *req, s32 new_value);
> @@ -117,6 +118,8 @@ static inline int pm_qos_request_active(
>  static inline s32 pm_qos_read_value(struct pm_qos_constraints *c)
>                        { return 0; }
>
> +static inline s32 dev_pm_qos_read_value(struct device *dev)
> +                       { return 0; }
>  static inline int dev_pm_qos_add_request(struct device *dev,
>                                         struct dev_pm_qos_request *req,
>                                         s32 value)
> Index: linux/drivers/base/power/main.c
> ===================================================================
> --- linux.orig/drivers/base/power/main.c
> +++ linux/drivers/base/power/main.c
> @@ -98,8 +98,8 @@ void device_pm_add(struct device *dev)
>                dev_warn(dev, "parent %s should not be sleeping\n",
>                        dev_name(dev->parent));
>        list_add_tail(&dev->power.entry, &dpm_list);
> -       mutex_unlock(&dpm_list_mtx);
>        dev_pm_qos_constraints_init(dev);
> +       mutex_unlock(&dpm_list_mtx);
>  }
>
>  /**
> @@ -110,9 +110,9 @@ void device_pm_remove(struct device *dev
>  {
>        pr_debug("PM: Removing info for %s:%s\n",
>                 dev->bus ? dev->bus->name : "No Bus", dev_name(dev));
> -       dev_pm_qos_constraints_destroy(dev);
>        complete_all(&dev->power.completion);
>        mutex_lock(&dpm_list_mtx);
> +       dev_pm_qos_constraints_destroy(dev);
>        list_del_init(&dev->power.entry);
>        mutex_unlock(&dpm_list_mtx);
>        device_wakeup_disable(dev);
> Index: linux/include/linux/pm.h
> ===================================================================
> --- linux.orig/include/linux/pm.h
> +++ linux/include/linux/pm.h
> @@ -421,13 +421,6 @@ enum rpm_request {
>        RPM_REQ_RESUME,
>  };
>
> -/* Per-device PM QoS constraints data struct state */
> -enum dev_pm_qos_state {
> -       DEV_PM_QOS_NO_DEVICE,           /* No device present */
> -       DEV_PM_QOS_DEVICE_PRESENT,      /* Device present, data not allocated */
> -       DEV_PM_QOS_ALLOCATED,           /* Device present, data allocated */
> -};
> -
>  struct wakeup_source;
>
>  struct pm_domain_data {
> @@ -489,7 +482,6 @@ struct dev_pm_info {
>  #endif
>        struct pm_subsys_data   *subsys_data;  /* Owned by the subsystem. */
>        struct pm_qos_constraints *constraints;
> -       enum dev_pm_qos_state   constraints_state;
>  };
>
>  extern void update_pm_runtime_accounting(struct device *dev);
>

Thanks,
Jean
