Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab2EIMoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:44:55 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60241 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687Ab2EIMox convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:44:53 -0400
MIME-Version: 1.0
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926310025F@SHSMSX101.ccr.corp.intel.com>
References: <1336493898-7039-1-git-send-email-amit.kachhap@linaro.org>
	<744357E9AAD1214791ACBA4B0B90926310025F@SHSMSX101.ccr.corp.intel.com>
Date: Wed, 9 May 2012 18:14:51 +0530
Message-ID: <CAK44p23=Xo2NC_XyCDxEDicQc0SuMm9DHCrpUXfU4pi_1i68Pg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] thermal: exynos: Add kernel thermal support for
 exynos platform
From: Amit Kachhap <amit.kachhap@linaro.org>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2012 01:36, Zhang, Rui <rui.zhang@intel.com> wrote:
> Hi, Amit,
>
> Sorry for the late response as I'm in a travel recently.
>
> I think the generic cpufreq cooling patches are good.
>
> But about the THERMAL_TRIP_STATE_INSTANCE patch, what I'd like to see is that
> 1. from thermal zone point of view, when the temperature is higher than a trip point, either ACTIVE or PASSIVE, what we should do is to set device cooling state to cur_state+1, right?
>  The only difference is that if we should take passive cooling actions or active cooling actions based on the policy.
>  So my question would be if it is possible to combine these two kind of trip points together. Maybe something like this:
>
>  In thermal_zone_device_update(),
>
>  ...
>  case THERMAL_TRIP_PASSIVE:
>      if (passive cooling not allowed)
>           continue;
>      if (tc1)
>           thermal_zone_device_passive();
>      else
>           thermal_set_cooling_state();
>      break;
>  case THERMAL_TRIP_ACTIVE:
>     if (active cooling not allowed)
>          continue;
>     thermal_set_cooling_state();
>     break;
>  ...
>
> and thermal_set_cooling_state() {
>   list_for_each_entry(instance, &tz->cooling_devices, node) {
>      if (instance->trip != count)
>         continue;
>
>      cdev = instance->cdev;
>
>      if (temp >= trip_temp)
>          cdev->ops->set_cur_state(cdev, 1);
>      else
>          cdev->ops->set_cur_state(cdev, 0);
>   }
> }
>
> 2. use only one cooling_device instance for a thermal_zone, and introduce cdev->trips which shows the trip points this cooling device is bind to.
>  And we may use multiple cooling devices states for one active trip point.
>
> Then, thermal_set_cooling_state() would be look like
>
> list_for_each_entry(instance, &tz->cooling_devices, node) {
>   cdev = instance->cdev;
>   /* check whether this cooling device is bind to the trip point */
>   if (!(cdev->trips & 1<<count))
>      continue;
>   cdev->ops->get_max_state(cdev, &max_state);
>   cdev->ops->get_cur_state(cdev, &cur_state);
>
>   if (temp >= trip_temp) {
>      if (cur_state++ <= max_state))
>        cdev->ops->set_cur_state(cdev, cur_state);
>   } else if ((temp < trip_temp) && (cur_state-- >= 0))
>      cdev->ops->set_cur_state(cdev, cur_state);
>                        }
> }

Hi Rui,

The above implementation  also cools instance based cooling devices
like passive trip type. I need some changes on top of your
implementation such as,
thermal_set_cooling_state() {
    list_for_each_entry(instance, &tz->cooling_devices,
                                     node) {
        cdev = instance->cdev;
        if (!cdev->trips & 1<<count)
                  continue;

        inst_id = 0;
        for_each_bit_set(i, cdev->trips, count)
                   inst_id++;
         cdev->ops->get_max_state(cdev, &max_state);
         if ((temp >= trip_temp) && (inst_id <= max_state))
              cdev->ops->set_cur_state(cdev, inst_id);
         else if ((temp < trip_temp) && (--inst_id >= 0))
               cdev->ops->set_cur_state(cdev, inst_id);
     }
}

I agree with you that the instance based trip types violates the
concept like reading the cur_state and do cur_state++/cur_state--
depending upon threshold increase or decrease because it needs the
state_id/inst_id.
I am actually thinking of dropping this new trip type and use the
existing THERMAL_TRIP_ACTIVE because there is so much logic in
calculating the state_id. The only flip side of using TRIP_ACTIVE is
that I need to create so many cooling devices.

Thanks,
Amit D
>
> With these two things, I think the WARN_ZONE AND MONITOR_ZONE can be registered as two PASSIVE trip points in the generic thermal layer, right?
> Actually, this is one thing in my TODO list. And I'd glad to make it high priority if this solves the problem you have.
>
> Thanks,
> rui
>
> -----Original Message-----
> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Amit Daniel Kachhap
> Sent: Tuesday, May 08, 2012 9:18 AM
> To: akpm@linux-foundation.org; linux-pm@lists.linux-foundation.org
> Cc: R, Durgadoss; linux-acpi@vger.kernel.org; lenb@kernel.org; Zhang, Rui; amit.kachhap@linaro.org; linaro-dev@lists.linaro.org; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-samsung-soc@vger.kernel.org; patches@linaro.org
> Subject: [PATCH v3 0/6] thermal: exynos: Add kernel thermal support for exynos platform
> Importance: High
>
> Hi Andrew,
>
> This patchset introduces a new generic cooling device based on cpufreq that can be used on non-ACPI platforms. As a proof of concept, we have drivers for the following platforms using this mechanism now:
>
>  * TI OMAP (git://git.linaro.org/people/amitdanielk/linux.git omap4460_thermal)
>  * Samsung Exynos (Exynos4 and Exynos5) in the current patchset.
>  * Freescale i.MX (git://git.linaro.org/people/amitdanielk/linux.git imx6q_thermal)
>
> These patches have been reviewed by Rui Zhang (https://lkml.org/lkml/2012/4/9/448)
> who seems to agree with them in principle, but I haven't had any luck getting them merged, perhaps a lack of maintainer bandwidth.
>
> ACPI platforms currently have such a mechanism but it is wrapped in ACPI'isms that we don't have on ARM platforms. If this is accepted, I'm proposing to convert over the ACPI thermal driver to use this common code too.
>
> Can you please merge these patches for 3.5?
>
> Thanks,
> Amit Daniel
>
>
> Changes since V2:
> *Added Exynos5 TMU sensor support by enhancing the exynos4 tmu driver. Exynos5 TMU  driver was internally developed by SangWook Ju <sw.ju@samsung.com>.
> *Removed cpuhotplug cooling code in this patchset.
> *Rebased the patches against 3.4-rc6 kernel.
>
> Changes since V1:
> *Moved the sensor driver to driver/thermal folder from driver/hwmon folder  as suggested by Mark Brown and Guenter Roeck *Added notifier support to notify the registered drivers of any cpu cooling  action. The driver can modify the default cooling behaviour(eg set different  max clip frequency).
> *The percentage based frequency replaced with absolute clipped frequency.
> *Some more conditional checks when setting max frequency.
> *Renamed the new trip type THERMAL_TRIP_STATE_ACTIVE to  THERMAL_TRIP_STATE_INSTANCE *Many review comments from R, Durgadoss <durgadoss.r@intel.com> and  eduardo.valentin@ti.com implemented.
> *Removed cooling stats through debugfs patch *The V1 based can be found here,
>  https://lkml.org/lkml/2012/2/22/123
>  http://lkml.org/lkml/2012/3/3/32
>
> Changes since RFC:
> *Changed the cpu cooling registration/unregistration API's to instance based *Changed the STATE_ACTIVE trip type to pass correct instance id *Adding support to restore back the policy->max_freq after doing frequency
>  clipping.
> *Moved the trip cooling stats from sysfs node to debugfs node as suggested
>  by Greg KH greg@kroah.com
> *Incorporated several review comments from eduardo.valentin@ti.com *Moved the Temperature sensor driver from driver/hwmon/ to driver/mfd  as discussed with Guenter Roeck <guenter.roeck@ericsson.com> and  Donggeun Kim <dg77.kim@samsung.com> (https://lkml.org/lkml/2012/1/5/7)
> *Some changes according to the changes in common cpu cooling APIs *The RFC based patches can be found here,
>  https://lkml.org/lkml/2011/12/13/186
>  https://lkml.org/lkml/2011/12/21/169
>
>
> Brief Description:
>
> 1) The generic cooling devices code is placed inside driver/thermal/* as placing inside acpi folder will need un-necessary enabling of acpi code. This codes is architecture independent.
>
> 2) This patchset adds a new trip type THERMAL_TRIP_STATE_INSTANCE which passes cooling device instance number and may be helpful for cpufreq cooling devices to take the correct cooling action. This trip type avoids the temperature comparision check again inside the cooling handler.
>
> 3) This patchset adds generic cpu cooling low level implementation through frequency clipping and cpu hotplug. In future, other cpu related cooling devices may be added here. An ACPI version of this already exists (drivers/acpi/processor_thermal.c). But this will be useful for platforms like ARM using the generic thermal interface along with the generic cpu cooling devices. The cooling device registration API's return cooling device pointers which can be easily binded with the thermal zone trip points.
> The important APIs exposed are,
>   a)struct thermal_cooling_device *cpufreq_cooling_register(
>        struct freq_clip_table *tab_ptr, unsigned int tab_size,
>        const struct cpumask *mask_val)
>   b)void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
>
> 4) Samsung exynos platform thermal implementation is done using the generic cpu cooling APIs and the new trip type. The temperature sensor driver present in the hwmon folder(registered as hwmon driver) is moved to thermal folder and registered as a thermal driver.
>
> All this patchset is based on Kernel version 3.4-rc6
>
> A simple data/control flow diagrams is shown below,
>
> Core Linux thermal <----->  Exynos thermal interface <----- Temperature Sensor
>          |                             |
>         \|/                            |
>  Cpufreq cooling device <---------------
>
> TODO:
> *Will send the DT enablement patches later after the driver is merged.
>
>
> Amit Daniel Kachhap (6):
>  thermal: Add a new trip type to use cooling device instance number
>  thermal: Add generic cpufreq cooling implementation
>  hwmon: exynos4: Move thermal sensor driver to driver/thermal
>    directory
>  thermal: exynos5: Add exynos5 thermal sensor driver support
>  thermal: exynos: Register the tmu sensor with the kernel thermal
>    layer
>  ARM: exynos: Add thermal sensor driver platform data support
>
>  Documentation/hwmon/exynos4_tmu              |   81 ---
>  Documentation/thermal/cpu-cooling-api.txt    |   60 ++
>  Documentation/thermal/exynos_thermal         |   52 ++
>  Documentation/thermal/sysfs-api.txt          |    4 +-
>  drivers/hwmon/Kconfig                        |   10 -
>  drivers/hwmon/Makefile                       |    1 -
>  drivers/hwmon/exynos4_tmu.c                  |  514 --------------
>  drivers/thermal/Kconfig                      |   20 +
>  drivers/thermal/Makefile                     |    4 +-
>  drivers/thermal/cpu_cooling.c                |  359 ++++++++++
>  drivers/thermal/exynos_thermal.c             |  933 ++++++++++++++++++++++++++
>  drivers/thermal/thermal_sys.c                |   62 ++-
>  include/linux/cpu_cooling.h                  |   62 ++
>  include/linux/platform_data/exynos4_tmu.h    |   83 ---
>  include/linux/platform_data/exynos_thermal.h |  100 +++
>  include/linux/thermal.h                      |    1 +
>  16 files changed, 1651 insertions(+), 695 deletions(-)  delete mode 100644 Documentation/hwmon/exynos4_tmu  create mode 100644 Documentation/thermal/cpu-cooling-api.txt
>  create mode 100644 Documentation/thermal/exynos_thermal
>  delete mode 100644 drivers/hwmon/exynos4_tmu.c  create mode 100644 drivers/thermal/cpu_cooling.c  create mode 100644 drivers/thermal/exynos_thermal.c  create mode 100644 include/linux/cpu_cooling.h  delete mode 100644 include/linux/platform_data/exynos4_tmu.h
>  create mode 100644 include/linux/platform_data/exynos_thermal.h
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
