Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab3AGIlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 03:41:31 -0500
Received: from [216.228.121.140] ([216.228.121.140]:17704 "EHLO
	hqemgate03.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3AGIl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 03:41:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 Jan 2013 00:35:53 -0800
Message-ID: <50EA89FA.6010703@nvidia.com>
Date: Mon, 7 Jan 2013 16:40:26 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Durgadoss R <durgadoss.r@intel.com>
CC: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>
Subject: Re: [PATCH 6/9] Thermal: Add Documentation to new APIs
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com> <1357542806-20449-7-git-send-email-durgadoss.r@intel.com>
In-Reply-To: <1357542806-20449-7-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 03:13 PM, Durgadoss R wrote:
> This patch adds Documentation for the new APIs
> introduced in this patch set. The documentation
> also has a model sysfs structure for reference.
> 
> Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> ---
>  Documentation/thermal/sysfs-api2.txt |  248 ++++++++++++++++++++++++++++++++++
>  1 file changed, 248 insertions(+)
>  create mode 100644 Documentation/thermal/sysfs-api2.txt
> 
> diff --git a/Documentation/thermal/sysfs-api2.txt b/Documentation/thermal/sysfs-api2.txt
> new file mode 100644
> index 0000000..ffd0402
> --- /dev/null
> +++ b/Documentation/thermal/sysfs-api2.txt
> @@ -0,0 +1,248 @@
> +Thermal Framework
> +-----------------
> +
> +Written by Durgadoss R <durgadoss.r@intel.com>
> +Copyright (c) 2012 Intel Corporation
> +
> +Created on: 4 November 2012
> +Updated on: 18 December 2012
> +
> +0. Introduction
> +---------------
> +The Linux thermal framework provides a set of interfaces for thermal
> +sensors and thermal cooling devices (fan, processor...) to register
> +with the thermal management solution and to be a part of it.
> +
> +This document focuses on how to enable new thermal sensors and cooling
> +devices to participate in thermal management. This solution is intended
> +to be 'light-weight' and platform/architecture independent. Any thermal
> +sensor/cooling device should be able to use the infrastructure easily.
> +
> +The goal of thermal framework is to expose the thermal sensor/zone and
> +cooling device attributes in a consistent way. This will help the
> +thermal governors to make use of the information to manage platform
> +thermals efficiently.
> +
> +The thermal sensor source file can be generic (can be any sensor driver,
> +in any subsystem). This driver will use the sensor APIs and register with
> +thermal framework to participate in platform Thermal management. This
> +does not (and should not) know about which zone it belongs to, or any
> +other information about platform thermals. A sensor driver is a standalone
> +piece of code, which can optionally register with thermal framework.
> +
> +However, for any platform, there should be a platformX_thermal.c file,
> +which will know about the platform thermal characteristics (like how many
> +sensors, zones, cooling devices, etc.. And how they are related to each other
> +i.e the mapping information). Only in this file, the zone level APIs should
> +be used, in which case the file will have all information required to attach
> +various sensors to a particular zone.
> +
> +This way, we can have one platform level thermal file, which can support
> +multiple platforms (may be)using the same set of sensors (but)binded in
> +a different way. This file can get the platform thermal information
> +through Firmware, ACPI tables, device tree etc.
> +
> +Unfortunately, today we don't have many drivers that can be clearly
> +differentiated as 'sensor_file.c' and 'platform_thermal_file.c'.
> +But very soon we will need/have. The reason I am saying this is because
> +we are seeing a lot of chip drivers, starting to use thermal framework,
> +and we should keep it really light-weight for them to do so.
> +
> +An Example: drivers/hwmon/emc1403.c - a generic thermal chip driver
> +In one platform this sensor can belong to 'ZoneA' and in another the
> +same can belong to 'ZoneB'. But, emc1403.c does not really care about
> +where does it belong. It just reports temperature.
> +
> +1. Terminology
> +--------------
> +This section describes the terminology used in the rest of this
> +document as well as the thermal framework code.
> +
> +thermal_sensor: Hardware that can report temperature of a particular
> +               spot in the platform, where it is placed. The temperature
> +               reported by the sensor is the 'real' temperature reported
> +               by the hardware.
> +thermal_zone:  A virtual area on the device, that gets heated up. It may
> +               have one or more thermal sensors attached to it.
> +cooling_device:        Any component that can help in reducing the temperature of
> +               a 'hot spot' either by reducing its performance (passive
> +               cooling) or by other means(Active cooling E.g. Fan)
> +
> +trip_points:   Various temperature levels for each sensor. As of now, we
> +               have four levels namely active, passive, hot and critical.
> +               Hot and critical trip point support only one value whereas
> +               active and passive can have any number of values. These
> +               temperature values can come from platform data, and are
> +               exposed through sysfs in a consistent manner. Stand-alone
> +               thermal sensor drivers are not expected to know these values.
> +               These values are RO.
> +thresholds:    These are programmable temperature limits, on reaching which
> +               the thermal sensor generates an interrupt. The framework is
> +               notified about this interrupt to take appropriate action.
> +               There can be as many number of thresholds as that of the
> +               hardware supports. These values are RW.

Hi,
When generate interrupt, we could call something like
notify_thermal_framework(), is it right? but it just notify the
framework, how to notify the platform driver? I think the platform
driver will wish to update the limited values when interrupt occur.
Will we have a thermal zone fops like ops.notify()?
I noticed there have "struct thermal_zone *ops" in the thermal_zone
structure, will it be used for callback?

Thanks.
Wei.

> +
> +thermal_map:   This provides the mapping (aka binding) information between
> +               various sensors and cooling devices in a particular zone.
> +               Typically, this also comes from platform data; Stand-alone
> +               sensor drivers or cooling device drivers are not expected
> +               to know these mapping information.
> +
> +2. Thermal framework APIs
> +-------------------------
> +2.1: For Thermal Sensors
> +2.1.1 thermal_sensor_register:
> +       This function creates a new sensor directory under /sys/class/thermal/
> +       as sensor[0-*]. This API is expected to be called by thermal sensor
> +       drivers. These drivers may or may not be in thermal subsystem. This
> +       function returns a thermal_sensor structure on success and appropriate
> +       error on failure.
> +
> +       name: Name of the sensor
> +       count: Number of programmable thresholds associated with this sensor
> +       devdata: Device private data
> +       ops: Thermal sensor callbacks
> +               .get_temp: obtain the current temperature of the sensor
> +               .get_trend: obtain the trend of the sensor
> +               .get_threshold: get a particular threshold temperature
> +               .set_threshold: set a particular threshold temperature
> +               .get_hyst: get hysteresis value associated with a threshold
> +               .set_hyst: set hysteresis value associated with a threshold
> +
> +2.1.2 thermal_sensor_unregister:
> +       This function deletes the sensor directory under /sys/class/thermal/
> +       for the given sensor. Thermal sensor drivers may call this API
> +       during the driver's 'exit' routine.
> +
> +       ts: Thermal sensor that has to be unregistered
> +
> +2.1.3 enable_sensor_thresholds:
> +       This function creates 'threshold[0-*]' attributes under a particular
> +       sensorX directory. These values are RW. This function is called by
> +       the sensr driver only if the sensor supports interrupt mechanism.
> +
> +       ts: Thermal sensor for which thresholds have to be enabled
> +       num_thresholds: Number of thresholds supported by the sensor
> +
> +2.2: For Cooling Devices
> +2.2.1 thermal_cooling_device_register:
> +       This function adds a new thermal cooling device (fan/processor/...)
> +       to /sys/class/thermal/ folder as cooling_device[0-*]. This function
> +       is expected to be called by cooling device drivers that may be
> +       present in other subsystems also.
> +
> +       name: the cooling device name
> +       devdata: device private data
> +       ops: thermal cooling devices callbacks
> +       .get_max_state: get the Maximum throttle state of the cooling device
> +       .get_cur_state: get the Current throttle state of the cooling device
> +       .set_cur_state: set the Current throttle state of the cooling device
> +
> +2.2.2 thermal_cooling_device_unregister:
> +       This function deletes the given cdev entry form /sys/class/thermal;
> +       and also cleans all the symlinks referred from various zones.
> +
> +       cdev: Cooling device to be unregistered
> +
> +2.3: For Thermal Zones
> +2.3.1 create_thermal_zone:
> +       This function adds a new 'zone' under /sys/class/thermal/
> +       directory as zone[0-*]. This zone has at least one thermal
> +       sensor and at most MAX_SENSORS_PER_ZONE number of sensors
> +       attached to it. Similarly, this zone has at least one cdev
> +       and at most MAX_CDEVS_PER_ZONE number of cdevs attached to it.
> +       Both the MAX_*_PER_ZONE values are configurable, through
> +       Kconfig option(during 'menuconfig').
> +
> +       name: Name of the thermal zone
> +       devdata: Device private data
> +
> +2.3.2 add_sensor_to_zone
> +       This function adds a 'sensorX' entry under /sys/class/thermal/
> +       zoneY/ directory. This 'sensorX' is a symlink to the actual
> +       sensor entry under /sys/class/thermal/. Correspondingly, the
> +       method remove_sensor_from_zone deletes the symlink.
> +
> +       tz: thermal zone structure
> +       ts: thermal sensor structure
> +
> +2.3.3 add_cdev_to_zone
> +       This function adds a 'cdevX' entry under /sys/class/thermal/
> +       zoneY/ directory. This 'cdevX' is a symlink to the actual
> +       cdev entry under /sys/class/thermal/. Correspondingly, the
> +       method remove_cdev_from_zone deletes the symlink.
> +
> +       tz: thermal zone structure
> +       cdev: thermal cooling device structure
> +
> +2.4 For Thermal Trip
> +2.4.1 add_sensor_trip_info
> +       This function adds trip point information for the given sensor,
> +       (under a given zone) under /sys/class/thermal/zoneX/thermal_trip/
> +       This API creates 4 sysfs attributes namely active, passive, hot,
> +       and critical. Each of these hold one or more trip point temperature
> +       values, as provided from platform data.
> +
> +       tz: thermal zone structure
> +       ts: thermal sensor to which the trip points are attached
> +       trip: trip point structure. Usually obtained from platform data
> +
> +2.5 For Thermal Map
> +2.5.1 add_map_entry
> +       This function adds a 'map[0-*]' sysfs attribute under
> +       /sys/class/thermal/zoneX/thermal_map/. Each map holds a space
> +       separated list of values, that specify the binding relationship
> +       between a sensor and a cdev in the given zone. The map structure
> +       is typically obtained as platform data. For example, through
> +       ACPI tables, SFI tables, Device tree etc.
> +
> +       tz: thermal zone to which a 'map' is being added
> +       map: thermal_map structure
> +
> +3. Sysfs attributes structure
> +-----------------------------
> +Thermal sysfs attributes will be represented under /sys/class/thermal.
> +
> +3.1: For Thermal Sensors
> +       /sys/class/thermal/sensor[0-*]:
> +               |---type:               Name of the thermal sensor
> +               |---temp_input:         Current temperature in mC
> +               |---threshold[0-*]:     Threshold temperature in mC
> +               |---threshold[0-*]_hyst:Optional hysteresis value in mC
> +
> +3.2: For Thermal Cooling Devices
> +       /sys/class/thermal/cooling_device[0-*]:
> +               |---type:               Type of the cooling device
> +               |---max_state:          Maximum throttle state of the cdev
> +               |---cur_state:          Current throttle state of the cdev
> +
> +3.3: For Thermal Zones
> +       /sys/class/thermal/zone[0-*]:
> +               |---name:               Name of the thermal
> +               |---sensorX:            Symlink to ../sensorX
> +               |---cdevY:              Symlink to ../cdevY
> +               |---thermal_trip:       trip point values for sensors
> +               |---thermal_map:        mapping info between sensors and cdevs
> +
> +3.4: For Thermal Trip
> +       This attribute represents the trip point values for all sensors
> +       present in the thermal zone. All values are in mC.
> +       /sys/class/thermal/zoneX/thermal_trip/sensorY:
> +               |---hot:                hot trip point value
> +               |---critical:           critical trip point value
> +               |---passive:            list of passive trip point values
> +               |---active:             list of active trip point values
> +
> +3.5: For Thermal Map
> +       Each attribute represents the mapping/binding information between
> +       a sensor and a cdev, together with a trip type.
> +       /sys/class/thermal/zoneX/thermal_map/:
> +               |---mapX:               mapping information
> +       A typical map entry is like below:
> +
> +       trip_type  sensor  cdev  trip_mask  weight(s)
> +       passive    cpu     proc  0x03       50 30
> +       active     cpu     fan0  0x03       50 70
> +
> +       The trip mask is a bit string; if 'n' th bit is set, then for
> +       trip point 'n' this cdev is throttled with the given weight[n].
> --
> 1.7.9.5
> 

