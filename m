Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2L0HBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 02:01:51 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53570 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2L0HBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 02:01:48 -0500
MIME-Version: 1.0
In-Reply-To: <1355822977-4804-5-git-send-email-durgadoss.r@intel.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
	<1355822977-4804-5-git-send-email-durgadoss.r@intel.com>
Date: Thu, 27 Dec 2012 15:01:47 +0800
Message-ID: <CAJLyvQwBvPx4Kp8coEuuACwRMwHG+b3rX=kuxqz4gu6rt-Ex3g@mail.gmail.com>
Subject: Re: [PATCH 4/8] Thermal: Add Thermal_trip sysfs node
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wni@nvidia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 December 2012 17:29, Durgadoss R <durgadoss.r@intel.com> wrote:
> This patch adds a thermal_trip directory under
> /sys/class/thermal/zoneX. This directory contains
> the trip point values for sensors bound to this
> zone.
>
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> ---
>  drivers/thermal/thermal_sys.c |  237 ++++++++++++++++++++++++++++++++++++++++-
>  include/linux/thermal.h       |   37 +++++++
>  2 files changed, 272 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index b39bf97..29ec073 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -448,6 +448,22 @@ static void thermal_zone_device_check(struct work_struct *work)
>         thermal_zone_device_update(tz);
>  }
>
> +static int get_sensor_indx_by_kobj(struct thermal_zone *tz, const char *name)
> +{
> +       int i, indx = -EINVAL;
> +
> +       mutex_lock(&sensor_list_lock);
> +       for (i = 0; i < tz->sensor_indx; i++) {
> +               if (!strnicmp(name, kobject_name(tz->kobj_trip[i]),
> +                       THERMAL_NAME_LENGTH)) {
> +                       indx = i;
> +                       break;
> +               }
> +       }
> +       mutex_unlock(&sensor_list_lock);
> +       return indx;
> +}
> +
>  static void remove_sensor_from_zone(struct thermal_zone *tz,
>                                 struct thermal_sensor *ts)
>  {
> @@ -459,9 +475,15 @@ static void remove_sensor_from_zone(struct thermal_zone *tz,
>
>         sysfs_remove_link(&tz->device.kobj, kobject_name(&ts->device.kobj));
>
> +       /* Delete this sensor's trip Kobject */
> +       kobject_del(tz->kobj_trip[indx]);
> +
>         /* Shift the entries in the tz->sensors array */
> -       for (j = indx; j < MAX_SENSORS_PER_ZONE - 1; j++)
> +       for (j = indx; j < MAX_SENSORS_PER_ZONE - 1; j++) {
>                 tz->sensors[j] = tz->sensors[j + 1];
> +               tz->sensor_trip[j] = tz->sensor_trip[j + 1];
> +               tz->kobj_trip[j] = tz->kobj_trip[j + 1];
> +       }
>
>         tz->sensor_indx--;
>  }
> @@ -875,6 +897,120 @@ policy_show(struct device *dev, struct device_attribute *devattr, char *buf)
>         return sprintf(buf, "%s\n", tz->governor->name);
>  }
>
> +static ssize_t
> +active_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
> +{
> +       int i, indx, ret = 0;
> +       struct thermal_zone *tz;
> +       struct device *dev;
> +
> +       /* In this function, for
> +        * /sys/class/thermal/zoneX/thermal_trip/sensorY:
> +        * attr                 points to sysfs node 'active'
> +        * kobj                 points to sensorY
> +        * kobj->parent         points to thermal_trip
> +        * kobj->parent->parent points to zoneX
> +        */
> +
> +       /* Get the zone pointer */
> +       dev = container_of(kobj->parent->parent, struct device, kobj);
> +       tz = to_zone(dev);
> +       if (!tz)
> +               return -EINVAL;
> +
> +       /*
> +        * We need this because in the sysfs tree, 'sensorY' is
> +        * not really the sensor pointer. It just has the name
> +        * 'sensorY'; whereas 'zoneX' is actually the zone pointer.
> +        * This means container_of(kobj, struct device, kobj) will not
> +        * provide the actual sensor pointer.
> +        */
> +       indx = get_sensor_indx_by_kobj(tz, kobject_name(kobj));
> +       if (indx < 0)
> +               return indx;
> +
> +       if (tz->sensor_trip[indx]->num_active_trips <= 0)
> +               return sprintf(buf, "<Not available>\n");
> +
> +       ret += sprintf(buf, "0x%x", tz->sensor_trip[indx]->active_trip_mask);
> +       for (i = 0; i < tz->sensor_trip[indx]->num_active_trips; i++) {
> +               ret += sprintf(buf + ret, " %d",
> +                       tz->sensor_trip[indx]->active_trips[i]);
> +       }
> +
> +       ret += sprintf(buf + ret, "\n");
> +       return ret;
> +}
> +
> +static ssize_t
> +ptrip_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
> +{
> +       int i, indx, ret = 0;
> +       struct thermal_zone *tz;
> +       struct device *dev;
> +
> +       /* Get the zone pointer */
> +       dev = container_of(kobj->parent->parent, struct device, kobj);
> +       tz = to_zone(dev);
> +       if (!tz)
> +               return -EINVAL;
> +
> +       indx = get_sensor_indx_by_kobj(tz, kobject_name(kobj));
> +       if (indx < 0)
> +               return indx;
> +
> +       if (tz->sensor_trip[indx]->num_passive_trips <= 0)
> +               return sprintf(buf, "<Not available>\n");
> +
> +       for (i = 0; i < tz->sensor_trip[indx]->num_passive_trips; i++) {
> +               ret += sprintf(buf + ret, "%d ",
> +                       tz->sensor_trip[indx]->passive_trips[i]);
> +       }
> +
> +       ret += sprintf(buf + ret, "\n");
> +       return ret;
> +}
> +
> +static ssize_t
> +hot_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
> +{
> +       int indx;
> +       struct thermal_zone *tz;
> +       struct device *dev;
> +
> +       /* Get the zone pointer */
> +       dev = container_of(kobj->parent->parent, struct device, kobj);
> +       tz = to_zone(dev);
> +       if (!tz)
> +               return -EINVAL;
> +
> +       indx = get_sensor_indx_by_kobj(tz, kobject_name(kobj));
> +       if (indx < 0)
> +               return indx;
> +
> +       return sprintf(buf, "%d\n", tz->sensor_trip[indx]->hot);
> +}
> +
> +static ssize_t
> +critical_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
> +{
> +       int indx;
> +       struct thermal_zone *tz;
> +       struct device *dev;
> +
> +       /* Get the zone pointer */
> +       dev = container_of(kobj->parent->parent, struct device, kobj);
> +       tz = to_zone(dev);
> +       if (!tz)
> +               return -EINVAL;
> +
> +       indx = get_sensor_indx_by_kobj(tz, kobject_name(kobj));
> +       if (indx < 0)
> +               return indx;
> +
> +       return sprintf(buf, "%d\n", tz->sensor_trip[indx]->crit);
> +}
> +
>  static DEVICE_ATTR(type, 0444, type_show, NULL);
>  static DEVICE_ATTR(temp, 0444, temp_show, NULL);
>  static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
> @@ -885,7 +1021,27 @@ static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show, policy_store);
>  static DEVICE_ATTR(sensor_name, 0444, sensor_name_show, NULL);
>  static DEVICE_ATTR(temp_input, 0444, sensor_temp_show, NULL);
>
> -static DEVICE_ATTR(zone_name, 0444, zone_name_show, NULL);
> +/* Thermal zone attributes */
> +static DEVICE_ATTR(zone_name, S_IRUGO, zone_name_show, NULL);
> +
> +/* Thermal trip attributes */
> +static struct kobj_attribute active_attr = __ATTR_RO(active);
> +/* TODO: rename this to passive while removing old code */
> +static struct kobj_attribute passive_attr = __ATTR_RO(ptrip);
> +static struct kobj_attribute hot_attr = __ATTR_RO(hot);
> +static struct kobj_attribute crit_attr = __ATTR_RO(critical);
> +
> +static struct attribute *trip_attrs[] = {
> +                       &active_attr.attr,
> +                       &passive_attr.attr,
> +                       &hot_attr.attr,
> +                       &crit_attr.attr,
> +                       NULL,
> +                       };
> +
> +static struct attribute_group trip_attr_group = {
> +                       .attrs = trip_attrs,
> +                       };
>
>  /* sys I/F for cooling device */
>  #define to_cooling_device(_dev)        \
> @@ -1770,12 +1926,19 @@ struct thermal_zone *create_thermal_zone(const char *name, void *devdata)
>         if (ret)
>                 goto exit_unregister;
>
> +       tz->kobj_thermal_trip = kobject_create_and_add("thermal_trip",
> +                                       &tz->device.kobj);
> +       if (!tz->kobj_thermal_trip)
> +               goto exit_name;
> +
>         /* Add this zone to the global list of thermal zones */
>         mutex_lock(&zone_list_lock);
>         list_add_tail(&tz->node, &thermal_zone_list);
>         mutex_unlock(&zone_list_lock);
>         return tz;
>
> +exit_name:
> +       device_remove_file(&tz->device, &dev_attr_zone_name);
>  exit_unregister:
>         device_unregister(&tz->device);
>  exit_idr:
> @@ -1789,6 +1952,7 @@ EXPORT_SYMBOL(create_thermal_zone);
>  void remove_thermal_zone(struct thermal_zone *tz)
>  {
>         struct thermal_zone *pos, *next;
> +       int i;
>         bool found = false;
>
>         if (!tz)
> @@ -1809,6 +1973,33 @@ void remove_thermal_zone(struct thermal_zone *tz)
>
>         device_remove_file(&tz->device, &dev_attr_zone_name);
>
> +       /* Just for ease of usage */
> +       i = tz->sensor_indx;
> +
> +       while (--i >= 0) {
> +               /* Remove /sys/class/thermal/zoneX/sensorY */
> +               sysfs_remove_link(&tz->device.kobj,
> +                               kobject_name(&tz->sensors[i]->device.kobj));
> +
> +               /* Remove /sys/class/thermal/zoneX/thermal_trip/sensorY */
> +               if (tz->kobj_trip[i]) {
> +                       sysfs_remove_group(tz->kobj_trip[i], &trip_attr_group);
> +                       kobject_del(tz->kobj_trip[i]);
> +               }
> +       }
> +
> +       /* Remove /sys/class/thermal/zoneX/thermal_trip */
> +       kobject_del(tz->kobj_thermal_trip);
> +
> +       /* Release the cdevs attached to this zone */
> +       i = tz->cdev_indx;
> +
> +       while (--i >= 0) {
> +               /* Remove /sys/class/thermal/zoneX/cooling_deviceY */
> +               sysfs_remove_link(&tz->device.kobj,
> +                               kobject_name(&tz->cdevs[i]->device.kobj));
> +       }
> +
>         release_idr(&thermal_zone_idr, &thermal_idr_lock, tz->id);
>         idr_destroy(&tz->idr);
>
> @@ -1920,6 +2111,48 @@ exit_zone:
>  }
>  EXPORT_SYMBOL(add_cdev_to_zone);
>
> +int add_sensor_trip_info(struct thermal_zone *tz, struct thermal_sensor *ts,
> +                       struct thermal_trip_point *trip)
> +{
> +       int indx, ret = -EINVAL;
> +
> +       if (!tz || !ts || !trip)
> +               return ret;
> +
> +       mutex_lock(&zone_list_lock);
> +
> +       GET_INDEX(tz, ts, indx, sensor);
> +       if (indx < 0)
> +               goto exit_indx;
> +
> +       /* Create kobj for /sys/class/thermal/zoneX/thermal_trip/sensorY */
> +       tz->kobj_trip[indx] = kobject_create_and_add(
> +                                       kobject_name(&ts->device.kobj),
> +                                       tz->kobj_thermal_trip);
> +       if (!tz->kobj_trip[indx]) {
> +               ret = -ENOMEM;
> +               goto exit_indx;
> +       }
> +
> +       ret = sysfs_create_group(tz->kobj_trip[indx], &trip_attr_group);
> +       if (ret) {
> +               dev_err(&tz->device, "sysfs_create_group failed:%d\n", ret);
> +               goto exit_kobj;
> +       }
> +
> +       tz->sensor_trip[indx] = trip;
> +       mutex_unlock(&zone_list_lock);
> +       return 0;
> +
> +exit_kobj:
> +       kobject_del(tz->kobj_trip[indx]);
> +       tz->kobj_trip[indx] = NULL;
> +exit_indx:
> +       mutex_unlock(&zone_list_lock);
> +       return ret;
> +}
> +EXPORT_SYMBOL(add_sensor_trip_info);
> +
>  /**
>   * thermal_sensor_register - register a new thermal sensor
>   * @name:      name of the thermal sensor
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index c4e45c7..8372f05 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -158,6 +158,30 @@ struct thermal_attr {
>         char name[THERMAL_NAME_LENGTH];
>  };
>
> +/*
> + * This structure defines the trip points for a sensor.
> + * The actual values for these trip points come from
> + * platform characterization. The thermal governors
> + * (either kernel or user space) may take appropriate
> + * actions when the sensors reach these trip points.
> + * See Documentation/thermal/sysfs-api2.txt for more details.
> + *
> + * As of now, For a particular sensor, we support:
> + * a) 1 hot trip point
> + * b) 1 critical trip point
> + * c) 'n' passive trip points
> + * d) 'm' active trip points
> + */
Durgadoss,
Currently the newly introduced governors don't treat passive/active
differently, what is the idea about this when you rebase governors to
new thermal zone/sensors? handle the passive/active differently or
eliminate the difference?

> +struct thermal_trip_point {
> +       int hot;
> +       int crit;
> +       int num_passive_trips;
> +       int *passive_trips;
> +       int num_active_trips;
> +       int *active_trips;
> +       int active_trip_mask;
> +};
> +
>  struct thermal_sensor {
>         char name[THERMAL_NAME_LENGTH];
>         int id;
> @@ -215,6 +239,16 @@ struct thermal_zone {
>         /* cdev level information */
>         int cdev_indx; /* index into 'cdevs' array */
>         struct thermal_cooling_device *cdevs[MAX_CDEVS_PER_ZONE];
> +
> +       /*
> +        * Thermal sensors trip information:
> +        * kobj_thermal_trip: /sys/class/thermal/zoneX/thermal_trip
> +        * kobj_trip: /sys/class/thermal/zoneX/thermal_trip/sensorY
> +        * sensor_trip: trip point information for each sensor
> +        */
> +       struct kobject *kobj_thermal_trip;
> +       struct kobject *kobj_trip[MAX_SENSORS_PER_ZONE];
> +       struct thermal_trip_point *sensor_trip[MAX_SENSORS_PER_ZONE];
>  };
>
>  /* Structure that holds thermal governor information */
> @@ -295,6 +329,9 @@ int add_sensor_to_zone(struct thermal_zone *, struct thermal_sensor *);
>
>  int add_cdev_to_zone(struct thermal_zone *, struct thermal_cooling_device *);
>
> +int add_sensor_trip_info(struct thermal_zone *, struct thermal_sensor *,
> +                       struct thermal_trip_point *);
> +
>  #ifdef CONFIG_NET
>  extern int thermal_generate_netlink_event(u32 orig, enum events event);
>  #else
> --
> 1.7.9.5
>
