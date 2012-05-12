Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2ELJlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 05:41:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41501 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2ELJlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 05:41:06 -0400
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, akpm@linux-foundation.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        durgadoss.r@intel.com, lenb@kernel.org, rui.zhang@intel.com,
        linux-acpi@vger.kernel.org, linaro-dev@lists.linaro.org,
        lm-sensors@lm-sensors.org, amit.kachhap@linaro.org, khali@linux-fr.org,
        guenter.roeck@ericsson.com, patches@linaro.org
Subject: [PATCH v4 0/5] thermal: exynos: Add kernel thermal support for exynos platform
Date: Sat, 12 May 2012 15:10:40 +0530
Message-Id: <1336815645-29625-1-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew/Rui,

As discussed with Rui Zhang, I dropped the patch for new trip type 
THERMAL_TRIP_STATE_INSTANCE and made the necessary state magnagement changes
in cpufreq cooling functions. Also I fixed all the review comments suggested
by Andrew. If any other changes please let me know.
 
This patchset introduces a new generic cooling device based on cpufreq that
can be used on non-ACPI platforms. As a proof of concept, we have drivers for
the following platforms using this mechanism now:

 * Samsung Exynos (Exynos4 and Exynos5) in the current patchset.
 * TI OMAP (git://git.linaro.org/people/amitdanielk/linux.git omap4460_thermal)
 * Freescale i.MX (git://git.linaro.org/people/amitdanielk/linux.git imx6q_thermal)

The is a small change in cpufreq cooling registration APIs, so a minor change is
needed for OMAP and Freescale platforms.

Thanks,
Amit Daniel

Changes since V3:
* Dropped the concept of using new trip type THERMAL_TRIP_STATE_INSTANCE as
 discussed with Rui Zhang. This requires adding some state management logic
 in cpufreq cooling implementation.
* Many review comments suggested by Andrew Morton
* More documentation added in cpufreq cooling codes.

Changes since V2:
*Added Exynos5 TMU sensor support by enhancing the exynos4 tmu driver. Exynos5 TMU
 driver was internally developed by SangWook Ju <sw.ju@samsung.com>.
*Removed cpuhotplug cooling code in this patchset.
*Rebased the patches against 3.4-rc6 kernel.

Changes since V1:
*Moved the sensor driver to driver/thermal folder from driver/hwmon folder
 as suggested by Mark Brown and Guenter Roeck 
*Added notifier support to notify the registered drivers of any cpu cooling
 action. The driver can modify the default cooling behaviour(eg set different
 max clip frequency).
*The percentage based frequency replaced with absolute clipped frequency.
*Some more conditional checks when setting max frequency.
*Renamed the new trip type THERMAL_TRIP_STATE_ACTIVE to
 THERMAL_TRIP_STATE_INSTANCE
*Many review comments from R, Durgadoss <durgadoss.r@intel.com> and 
 eduardo.valentin@ti.com implemented.
*Removed cooling stats through debugfs patch
*The V1 based can be found here,
 https://lkml.org/lkml/2012/2/22/123
 http://lkml.org/lkml/2012/3/3/32

Changes since RFC:
*Changed the cpu cooling registration/unregistration API's to instance based
*Changed the STATE_ACTIVE trip type to pass correct instance id
*Adding support to restore back the policy->max_freq after doing frequency 
  clipping.
*Moved the trip cooling stats from sysfs node to debugfs node as suggested
  by Greg KH greg@kroah.com 
*Incorporated several review comments from eduardo.valentin@ti.com
*Moved the Temperature sensor driver from driver/hwmon/ to driver/mfd
 as discussed with Guenter Roeck <guenter.roeck@ericsson.com> and 
 Donggeun Kim <dg77.kim@samsung.com> (https://lkml.org/lkml/2012/1/5/7)
*Some changes according to the changes in common cpu cooling APIs
*The RFC based patches can be found here,
 https://lkml.org/lkml/2011/12/13/186
 https://lkml.org/lkml/2011/12/21/169


Brief Description:

1) The generic cooling devices code is placed inside driver/thermal/* as 
placing inside acpi folder will need un-necessary enabling of acpi code. This
codes is architecture independent.

2) This patchset adds generic cpu cooling low level implementation through
frequency clipping. In future, other cpu related cooling devices may be added
here. An ACPI version of this already exists (drivers/acpi/processor_thermal.c)
. But this will be useful for platforms like ARM using the generic
thermal interface along with the generic cpu cooling devices. The cooling
device registration API's return cooling device pointers which can be easily
binded with the thermal zone trip points. The important APIs exposed are,
   a)struct thermal_cooling_device *cpufreq_cooling_register(
	struct freq_clip_table *tab_ptr, unsigned int tab_size)
   b)void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)

3) Samsung exynos platform thermal implementation is done using the generic
cpu cooling APIs and the new trip type. The temperature sensor driver present
in the hwmon folder(registered as hwmon driver) is moved to thermal folder
and registered as a thermal driver.

All this patchset is based on Kernel version 3.4-rc6 

A simple data/control flow diagrams is shown below,

Core Linux thermal <----->  Exynos thermal interface <----- Temperature Sensor
	  |                             |
	 \|/                            |
  Cpufreq cooling device <---------------

TODO:
*Will send the DT enablement patches later after the driver is merged.


Amit Daniel Kachhap (5):
  thermal: Add generic cpufreq cooling implementation
  hwmon: exynos4: Move thermal sensor driver to driver/thermal
    directory
  thermal: exynos5: Add exynos5 thermal sensor driver support
  thermal: exynos: Register the tmu sensor with the kernel thermal
    layer
  ARM: exynos: Add thermal sensor driver platform data support

 Documentation/hwmon/exynos4_tmu              |   81 ---
 Documentation/thermal/cpu-cooling-api.txt    |   60 ++
 Documentation/thermal/exynos_thermal         |   52 ++
 drivers/hwmon/Kconfig                        |   10 -
 drivers/hwmon/Makefile                       |    1 -
 drivers/hwmon/exynos4_tmu.c                  |  514 --------------
 drivers/thermal/Kconfig                      |   20 +
 drivers/thermal/Makefile                     |    4 +-
 drivers/thermal/cpu_cooling.c                |  483 +++++++++++++
 drivers/thermal/exynos_thermal.c             |  956 ++++++++++++++++++++++++++
 include/linux/cpu_cooling.h                  |   99 +++
 include/linux/platform_data/exynos4_tmu.h    |   83 ---
 include/linux/platform_data/exynos_thermal.h |  100 +++
 13 files changed, 1773 insertions(+), 690 deletions(-)
 delete mode 100644 Documentation/hwmon/exynos4_tmu
 create mode 100644 Documentation/thermal/cpu-cooling-api.txt
 create mode 100644 Documentation/thermal/exynos_thermal
 delete mode 100644 drivers/hwmon/exynos4_tmu.c
 create mode 100644 drivers/thermal/cpu_cooling.c
 create mode 100644 drivers/thermal/exynos_thermal.c
 create mode 100644 include/linux/cpu_cooling.h
 delete mode 100644 include/linux/platform_data/exynos4_tmu.h
 create mode 100644 include/linux/platform_data/exynos_thermal.h

