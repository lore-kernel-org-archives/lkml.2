Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab2LZDau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 22:30:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:15733 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab2LZDar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 22:30:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,355,1355126400"; 
   d="scan'208";a="266944918"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Wei Ni <wni@nvidia.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>
Subject: RE: [PATCH 3/8] Thermal: Add APIs to bind cdev to new zone structure
Thread-Topic: [PATCH 3/8] Thermal: Add APIs to bind cdev to new zone
 structure
Thread-Index: AQHN3QLnvu5BgFgx2EWGK4GJh2wp0Zgo3g4AgAGae6A=
Date: Wed, 26 Dec 2012 03:30:42 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5924ED5F@BGSMSX101.gar.corp.intel.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
 <1355822977-4804-4-git-send-email-durgadoss.r@intel.com>
 <50D96438.3090105@nvidia.com>
In-Reply-To: <50D96438.3090105@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> owner@vger.kernel.org] On Behalf Of Wei Ni
> Sent: Tuesday, December 25, 2012 2:01 PM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> hongbo.zhang@linaro.org
> Subject: Re: [PATCH 3/8] Thermal: Add APIs to bind cdev to new zone
> structure
> 
> On 12/18/2012 05:29 PM, Durgadoss R wrote:
> > This patch creates new APIs to add/remove a
> > cdev to/from a zone. This patch does not change
> > the old cooling device implementation.
> >
> > Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> > ---
> >  drivers/thermal/thermal_sys.c |   80
> +++++++++++++++++++++++++++++++++++++++++
> >  include/linux/thermal.h       |    8 +++++
> >  2 files changed, 88 insertions(+)
> >
> > diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> > index 06d5a12..b39bf97 100644
> > --- a/drivers/thermal/thermal_sys.c
> > +++ b/drivers/thermal/thermal_sys.c
> > @@ -58,6 +58,7 @@ static LIST_HEAD(thermal_governor_list);
> >  static DEFINE_MUTEX(thermal_list_lock);
> >  static DEFINE_MUTEX(sensor_list_lock);
> >  static DEFINE_MUTEX(zone_list_lock);
> > +static DEFINE_MUTEX(cdev_list_lock);
> >  static DEFINE_MUTEX(thermal_governor_lock);
> >
> >  #define for_each_thermal_sensor(pos) \
> > @@ -82,6 +83,9 @@ static DEFINE_MUTEX(thermal_governor_lock);
> >  		mutex_unlock(&type##_list_lock);	\
> >  	} while (0)
> >
> > +#define for_each_cdev(pos) \
> > +	list_for_each_entry(pos, &thermal_cdev_list, node)
> > +
> >  static struct thermal_governor *__find_governor(const char *name)
> >  {
> >  	struct thermal_governor *pos;
> > @@ -462,6 +466,24 @@ static void remove_sensor_from_zone(struct
> thermal_zone *tz,
> >  	tz->sensor_indx--;
> >  }
> >
> > +static void remove_cdev_from_zone(struct thermal_zone *tz,
> > +				struct thermal_cooling_device *cdev)
> > +{
> > +	int j, indx;
> > +
> > +	GET_INDEX(tz, cdev, indx, cdev);
> > +	if (indx < 0)
> > +		return;
> > +
> > +	sysfs_remove_link(&tz->device.kobj, kobject_name(&cdev-
> >device.kobj));
> > +
> > +	/* Shift the entries in the tz->cdevs array */
> > +	for (j = indx; j < MAX_CDEVS_PER_ZONE - 1; j++)
> > +		tz->cdevs[j] = tz->cdevs[j + 1];
> > +
> > +	tz->cdev_indx--;
> > +}
> > +
> >  /* sys I/F for thermal zone */
> >
> >  #define to_thermal_zone(_dev) \
> > @@ -1458,6 +1480,7 @@ void thermal_cooling_device_unregister(struct
> thermal_cooling_device *cdev)
> >  	int i;
> >  	const struct thermal_zone_params *tzp;
> >  	struct thermal_zone_device *tz;
> > +	struct thermal_zone *tmp_tz;
> >  	struct thermal_cooling_device *pos = NULL;
> >
> >  	if (!cdev)
> > @@ -1495,6 +1518,13 @@ void thermal_cooling_device_unregister(struct
> thermal_cooling_device *cdev)
> >
> >  	mutex_unlock(&thermal_list_lock);
> >
> > +	mutex_lock(&zone_list_lock);
> > +
> > +	for_each_thermal_zone(tmp_tz)
> > +		remove_cdev_from_zone(tmp_tz, cdev);
> > +
> > +	mutex_unlock(&zone_list_lock);
> > +
> >  	if (cdev->type[0])
> >  		device_remove_file(&cdev->device, &dev_attr_cdev_type);
> >  	device_remove_file(&cdev->device, &dev_attr_max_state);
> > @@ -1790,6 +1820,23 @@ exit:
> >  }
> >  EXPORT_SYMBOL(remove_thermal_zone);
> >
> > +struct thermal_cooling_device *get_cdev_by_name(const char *name)
> > +{
> > +	struct thermal_cooling_device *pos;
> > +	struct thermal_cooling_device *cdev = NULL;
> > +
> > +	mutex_lock(&cdev_list_lock);
> > +	for_each_cdev(pos) {
> > +		if (!strnicmp(pos->type, name, THERMAL_NAME_LENGTH)) {
> > +			cdev = pos;
> > +			break;
> > +		}
> > +	}
> > +	mutex_unlock(&cdev_list_lock);
> > +	return cdev;
> > +}
> > +EXPORT_SYMBOL(get_cdev_by_name);
> 
> It seems you forgot to add get_cdev_by_name() and
> get_sensor_by_name()
> to the include file.

Thanks.. Will take care of this in v2.

Regards,
Durga
