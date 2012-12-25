Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2LYIav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 03:30:51 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9936 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2LYIau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 03:30:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 25 Dec 2012 00:27:48 -0800
Message-ID: <50D96438.3090105@nvidia.com>
Date: Tue, 25 Dec 2012 16:30:48 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Durgadoss R <durgadoss.r@intel.com>
CC: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>
Subject: Re: [PATCH 3/8] Thermal: Add APIs to bind cdev to new zone structure
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com> <1355822977-4804-4-git-send-email-durgadoss.r@intel.com>
In-Reply-To: <1355822977-4804-4-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 05:29 PM, Durgadoss R wrote:
> This patch creates new APIs to add/remove a
> cdev to/from a zone. This patch does not change
> the old cooling device implementation.
> 
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> ---
>  drivers/thermal/thermal_sys.c |   80 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/thermal.h       |    8 +++++
>  2 files changed, 88 insertions(+)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 06d5a12..b39bf97 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -58,6 +58,7 @@ static LIST_HEAD(thermal_governor_list);
>  static DEFINE_MUTEX(thermal_list_lock);
>  static DEFINE_MUTEX(sensor_list_lock);
>  static DEFINE_MUTEX(zone_list_lock);
> +static DEFINE_MUTEX(cdev_list_lock);
>  static DEFINE_MUTEX(thermal_governor_lock);
>  
>  #define for_each_thermal_sensor(pos) \
> @@ -82,6 +83,9 @@ static DEFINE_MUTEX(thermal_governor_lock);
>  		mutex_unlock(&type##_list_lock);	\
>  	} while (0)
>  
> +#define for_each_cdev(pos) \
> +	list_for_each_entry(pos, &thermal_cdev_list, node)
> +
>  static struct thermal_governor *__find_governor(const char *name)
>  {
>  	struct thermal_governor *pos;
> @@ -462,6 +466,24 @@ static void remove_sensor_from_zone(struct thermal_zone *tz,
>  	tz->sensor_indx--;
>  }
>  
> +static void remove_cdev_from_zone(struct thermal_zone *tz,
> +				struct thermal_cooling_device *cdev)
> +{
> +	int j, indx;
> +
> +	GET_INDEX(tz, cdev, indx, cdev);
> +	if (indx < 0)
> +		return;
> +
> +	sysfs_remove_link(&tz->device.kobj, kobject_name(&cdev->device.kobj));
> +
> +	/* Shift the entries in the tz->cdevs array */
> +	for (j = indx; j < MAX_CDEVS_PER_ZONE - 1; j++)
> +		tz->cdevs[j] = tz->cdevs[j + 1];
> +
> +	tz->cdev_indx--;
> +}
> +
>  /* sys I/F for thermal zone */
>  
>  #define to_thermal_zone(_dev) \
> @@ -1458,6 +1480,7 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
>  	int i;
>  	const struct thermal_zone_params *tzp;
>  	struct thermal_zone_device *tz;
> +	struct thermal_zone *tmp_tz;
>  	struct thermal_cooling_device *pos = NULL;
>  
>  	if (!cdev)
> @@ -1495,6 +1518,13 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
>  
>  	mutex_unlock(&thermal_list_lock);
>  
> +	mutex_lock(&zone_list_lock);
> +
> +	for_each_thermal_zone(tmp_tz)
> +		remove_cdev_from_zone(tmp_tz, cdev);
> +
> +	mutex_unlock(&zone_list_lock);
> +
>  	if (cdev->type[0])
>  		device_remove_file(&cdev->device, &dev_attr_cdev_type);
>  	device_remove_file(&cdev->device, &dev_attr_max_state);
> @@ -1790,6 +1820,23 @@ exit:
>  }
>  EXPORT_SYMBOL(remove_thermal_zone);
>  
> +struct thermal_cooling_device *get_cdev_by_name(const char *name)
> +{
> +	struct thermal_cooling_device *pos;
> +	struct thermal_cooling_device *cdev = NULL;
> +
> +	mutex_lock(&cdev_list_lock);
> +	for_each_cdev(pos) {
> +		if (!strnicmp(pos->type, name, THERMAL_NAME_LENGTH)) {
> +			cdev = pos;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&cdev_list_lock);
> +	return cdev;
> +}
> +EXPORT_SYMBOL(get_cdev_by_name);

It seems you forgot to add get_cdev_by_name() and get_sensor_by_name()
to the include file.

> +
>  struct thermal_sensor *get_sensor_by_name(const char *name)
>  {
>  	struct thermal_sensor *pos;
> @@ -1840,6 +1887,39 @@ exit_zone:
>  }
>  EXPORT_SYMBOL(add_sensor_to_zone);
>  
> +int add_cdev_to_zone(struct thermal_zone *tz,
> +			struct thermal_cooling_device *cdev)
> +{
> +	int ret;
> +
> +	if (!tz || !cdev)
> +		return -EINVAL;
> +
> +	mutex_lock(&zone_list_lock);
> +
> +	/* Ensure we are not adding the same cdev again!! */
> +	GET_INDEX(tz, cdev, ret, cdev);
> +	if (ret >= 0) {
> +		ret = -EEXIST;
> +		goto exit_zone;
> +	}
> +
> +	mutex_lock(&cdev_list_lock);
> +	ret = sysfs_create_link(&tz->device.kobj, &cdev->device.kobj,
> +				kobject_name(&cdev->device.kobj));
> +	if (ret)
> +		goto exit_cdev;
> +
> +	tz->cdevs[tz->cdev_indx++] = cdev;
> +
> +exit_cdev:
> +	mutex_unlock(&cdev_list_lock);
> +exit_zone:
> +	mutex_unlock(&zone_list_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(add_cdev_to_zone);
> +
>  /**
>   * thermal_sensor_register - register a new thermal sensor
>   * @name:	name of the thermal sensor
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index f08f774..c4e45c7 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -51,6 +51,8 @@
>  
>  #define MAX_SENSORS_PER_ZONE		5
>  
> +#define MAX_CDEVS_PER_ZONE		5
> +
>  struct thermal_sensor;
>  struct thermal_zone_device;
>  struct thermal_cooling_device;
> @@ -209,6 +211,10 @@ struct thermal_zone {
>  	/* Sensor level information */
>  	int sensor_indx; /* index into 'sensors' array */
>  	struct thermal_sensor *sensors[MAX_SENSORS_PER_ZONE];
> +
> +	/* cdev level information */
> +	int cdev_indx; /* index into 'cdevs' array */
> +	struct thermal_cooling_device *cdevs[MAX_CDEVS_PER_ZONE];
>  };
>  
>  /* Structure that holds thermal governor information */
> @@ -287,6 +293,8 @@ struct thermal_zone *create_thermal_zone(const char *, void *);
>  void remove_thermal_zone(struct thermal_zone *);
>  int add_sensor_to_zone(struct thermal_zone *, struct thermal_sensor *);
>  
> +int add_cdev_to_zone(struct thermal_zone *, struct thermal_cooling_device *);
> +
>  #ifdef CONFIG_NET
>  extern int thermal_generate_netlink_event(u32 orig, enum events event);
>  #else
> 

