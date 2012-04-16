Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2DPCGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 22:06:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:36517 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab2DPCGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 22:06:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153977708"
Message-ID: <1334542022.2387.325.camel@rui.sh.intel.com>
Subject: Re: [PATCH V2 0/6] thermal: exynos: Add kernel thermal support for
 exynos platform
From: Zhang Rui <rui.zhang@intel.com>
To: Amit Kachhap <amit.kachhap@linaro.org>
Cc: lenb@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, linux-acpi@vger.kernel.org,
        linaro-dev@lists.linaro.org, lm-sensors@lm-sensors.org,
        patches@linaro.org, eduardo.valentin@ti.com, durgadoss.r@intel.com
Date: Mon, 16 Apr 2012 10:07:02 +0800
In-Reply-To: <CAK44p20Bw9QACRqJc_s4Ri8E46OKOD9O_XpC2Gtd6avSy50dJQ@mail.gmail.com>
References: <1332137864-12943-1-git-send-email-amit.kachhap@linaro.org>
	 <CAK44p23jiXn6mn-VsdXr3h9J5FfKztXMiqu=XjaF6nqLnRQAmA@mail.gmail.com>
	 <1334019502.2387.211.camel@rui.sh.intel.com>
	 <CAK44p20Bw9QACRqJc_s4Ri8E46OKOD9O_XpC2Gtd6avSy50dJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 三, 2012-04-11 at 18:17 +0530, Amit Kachhap wrote:
> Hi Rui,
> 
> Thanks for looking into the patches.
> 
> On 10 April 2012 06:28, Zhang Rui <rui.zhang@intel.com> wrote:
> > Hi, Amit,
> >
> > On 三, 2012-04-04 at 10:02 +0530, Amit Kachhap wrote:
> >> Hi Len/Rui,
> >>
> >> Any comment or feedback from your side about the status of this patch?
> >> Is it merge-able or major re-work is needed? I have fixed most of the
> >> comments in this patchset and currently working on some of the minor
> >> comments received and will submit them shortly.
> >>
> > Sorry for the late response.
> >
> > First of all, it makes sense to me to introduce the generic cpufrq
> > cooling implementation.
> ok thanks
> > But I still have some questions.
> > I think the key reason why THERMAL_TRIP_STATE_INSTANCE is introduced is
> > that the MONIROR_ZONE and WARN_ZONE on exynos4 can not fit into the
> > current passive handling in the generic thermal layer well, right?
> > e.g. there is no tc1/tc2 on exynos4.
> >
> > If yes, is it possible that we can enhance the passive cooling to
> > support the generic processor cooling?
> > say, introduce another way to throttle the processor in
> > thermal_zone_device_passive when tc1 and tc2 are not available?
> 
> I agree that this new trip type code can be moved into passive trip
> type when tc1 and tc2 are 0. but this is special type of cooling
> devices behaviour where only instances of the same cooling device is
> binded to a trip point. The order of mapping is the only
> differentiating criteria and there are some checks used to implement
> this like
> 1) The trip points should be in ascending order.(This is missing in my
> original patch, so I added below)
> 2) The set_cur_state has to be called for the exact temp range so
> get_cur_state(&state) and set_cur_state(state ++/state--) logic is not
> possible.
> 3) set_cur_state is called as set_cur_state(cdev_instance).

Do you really need two THERMAL_TRIP_STATE_INSTANCE trip points?

I'm not sure if my understanding is right, but IMO, we can have one
THERMAL_TRIP_STATE_INSTANCE only, for both MONIROR_ZONE and WARN_ZONE,
and the trip temperature equals MONIROR_ZONE.
The cpufreq cooling device will work in the same way, no?

thanks,
rui

> There is a chance that people might confuse that these checks are
> applicable for passive trip types also which is not the case here.
> 
> @@ -1187,6 +1228,21 @@ struct thermal_zone_device
> *thermal_zone_device_register(char *type,
>                 tz->ops->get_trip_type(tz, count, &trip_type);
>                 if (trip_type == THERMAL_TRIP_PASSIVE)
>                         passive = 1;
> +               /*
> +                * For THERMAL_TRIP_STATE_INSTANCE trips, thermal zone should
> +                * be in ascending order.
> +               */
> +               if (trip_type == THERMAL_TRIP_STATE_INSTANCE) {
> +                       tz->ops->get_trip_temp(tz, count, &trip_temp);
> +                       if (first_trip_temp == 0)
> +                               first_trip_temp = trip_temp;
> +                       else if (first_trip_temp < trip_temp)
> +                               first_trip_temp = trip_temp;
> +                       else if (first_trip_temp > trip_temp) {
> +                               pr_warn("Zone trip points should be in
> ascending order\n");
> +                               goto unregister;
> +                       }
> +               }
>         }
> 
>         if (!passive)
> 
> Anyway there is other alternative where this new trip type is not
> needed and I can just use the existing trip type THERMAL_TRIP_ACTIVE
> and create 2 separate cooling devices for MONITOR_ZONE and WARN_ZONE.
> I had thought to make this generic and just to manage with 1 cooling
> device.
> What is your view?
> 
> Thanks,
> Amit Daniel
> 
> 
> >
> > thanks,
> > rui
> >
> >> Regards,
> >> Amit Daniel
> >>
> >> On 19 March 2012 11:47, Amit Daniel Kachhap <amit.kachhap@linaro.org> wrote:
> >> > Changes since V1:
> >> > *Moved the sensor driver to driver/thermal folder from driver/hwmon folder
> >> >  as suggested by Mark Brown and Guenter Roeck
> >> > *Added notifier support to notify the registered drivers of any cpu cooling
> >> >  action. The driver can modify the default cooling behaviour(eg set different
> >> >  max clip frequency).
> >> > *The percentage based frequency replaced with absolute clipped frequency.
> >> > *Some more conditional checks when setting max frequency.
> >> > *Renamed the new trip type THERMAL_TRIP_STATE_ACTIVE to
> >> >  THERMAL_TRIP_STATE_INSTANCE
> >> > *Many review comments from R, Durgadoss <durgadoss.r@intel.com> and
> >> >  eduardo.valentin@ti.com implemented.
> >> > *Removed cooling stats through debugfs patch
> >> > *The V1 based can be found here,
> >> >  https://lkml.org/lkml/2012/2/22/123
> >> >  http://lkml.org/lkml/2012/3/3/32
> >> >
> >> > Changes since RFC:
> >> > *Changed the cpu cooling registration/unregistration API's to instance based
> >> > *Changed the STATE_ACTIVE trip type to pass correct instance id
> >> > *Adding support to restore back the policy->max_freq after doing frequency
> >> >  clipping.
> >> > *Moved the trip cooling stats from sysfs node to debugfs node as suggested
> >> >  by Greg KH greg@kroah.com
> >> > *Incorporated several review comments from eduardo.valentin@ti.com
> >> > *Moved the Temperature sensor driver from driver/hwmon/ to driver/mfd
> >> >  as discussed with Guenter Roeck <guenter.roeck@ericsson.com> and
> >> >  Donggeun Kim <dg77.kim@samsung.com> (https://lkml.org/lkml/2012/1/5/7)
> >> > *Some changes according to the changes in common cpu cooling APIs
> >> > *The RFC based patches can be found here,
> >> >  https://lkml.org/lkml/2011/12/13/186
> >> >  https://lkml.org/lkml/2011/12/21/169
> >> >
> >> >
> >> > Brief Description:
> >> >
> >> > 1) The generic cooling devices code is placed inside driver/thermal/* as
> >> > placing inside acpi folder will need un-necessary enabling of acpi code. This
> >> > codes is architecture independent.
> >> >
> >> > 2) This patchset adds a new trip type THERMAL_TRIP_STATE_INSTANCE which passes
> >> > cooling device instance number and may be helpful for cpufreq cooling devices
> >> > to take the correct cooling action. This trip type avoids the temperature
> >> > comparision check again inside the cooling handler.
> >> >
> >> > 3) This patchset adds generic cpu cooling low level implementation through
> >> > frequency clipping and cpu hotplug. In future, other cpu related cooling
> >> > devices may be added here. An ACPI version of this already exists
> >> > (drivers/acpi/processor_thermal.c). But this will be useful for platforms
> >> > like ARM using the generic thermal interface along with the generic cpu
> >> > cooling devices. The cooling device registration API's return cooling device
> >> > pointers which can be easily binded with the thermal zone trip points.
> >> > The important APIs exposed are,
> >> >   a)struct thermal_cooling_device *cpufreq_cooling_register(
> >> >        struct freq_clip_table *tab_ptr, unsigned int tab_size,
> >> >        const struct cpumask *mask_val)
> >> >   b)void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
> >> >
> >> > 4) Samsung exynos platform thermal implementation is done using the generic
> >> > cpu cooling APIs and the new trip type. The temperature sensor driver present
> >> > in the hwmon folder(registered as hwmon driver) is moved to thermal folder
> >> > and registered as a thermal driver.
> >> >
> >> > All this patchset is based on Kernel version 3.3-rc7
> >> >
> >> > A simple data/control flow diagrams is shown below,
> >> >
> >> > Core Linux thermal <----->  Exynos thermal interface <----- Temperature Sensor
> >> >          |                             |
> >> >         \|/                            |
> >> >  Cpufreq cooling device <---------------
> >> >
> >> >
> >> > Amit Daniel Kachhap (6):
> >> >  thermal: Add a new trip type to use cooling device instance number
> >> >  thermal: Add generic cpufreq cooling implementation
> >> >  thermal: Add generic cpuhotplug cooling implementation
> >> >  hwmon: exynos4: Move thermal sensor driver to driver/thermal
> >> >    directory
> >> >  thermal: exynos4: Register the tmu sensor with the kernel thermal
> >> >    layer
> >> >  ARM: exynos4: Add thermal sensor driver platform device support
> >> >
> >> >  Documentation/hwmon/exynos4_tmu           |   81 ---
> >> >  Documentation/thermal/cpu-cooling-api.txt |   76 +++
> >> >  Documentation/thermal/exynos4_tmu         |   52 ++
> >> >  Documentation/thermal/sysfs-api.txt       |    4 +-
> >> >  arch/arm/mach-exynos/Kconfig              |   11 +
> >> >  arch/arm/mach-exynos/Makefile             |    1 +
> >> >  arch/arm/mach-exynos/clock.c              |    4 +
> >> >  arch/arm/mach-exynos/dev-tmu.c            |   39 ++
> >> >  arch/arm/mach-exynos/include/mach/irqs.h  |    2 +
> >> >  arch/arm/mach-exynos/include/mach/map.h   |    1 +
> >> >  arch/arm/mach-exynos/mach-origen.c        |    1 +
> >> >  arch/arm/plat-samsung/include/plat/devs.h |    1 +
> >> >  drivers/hwmon/Kconfig                     |   10 -
> >> >  drivers/hwmon/Makefile                    |    1 -
> >> >  drivers/hwmon/exynos4_tmu.c               |  514 -------------------
> >> >  drivers/thermal/Kconfig                   |   21 +
> >> >  drivers/thermal/Makefile                  |    2 +
> >> >  drivers/thermal/cpu_cooling.c             |  529 +++++++++++++++++++
> >> >  drivers/thermal/exynos4_thermal.c         |  790 +++++++++++++++++++++++++++++
> >> >  drivers/thermal/thermal_sys.c             |   45 ++-
> >> >  include/linux/cpu_cooling.h               |   78 +++
> >> >  include/linux/platform_data/exynos4_tmu.h |    7 +
> >> >  include/linux/thermal.h                   |    1 +
> >> >  23 files changed, 1660 insertions(+), 611 deletions(-)
> >> >  delete mode 100644 Documentation/hwmon/exynos4_tmu
> >> >  create mode 100644 Documentation/thermal/cpu-cooling-api.txt
> >> >  create mode 100644 Documentation/thermal/exynos4_tmu
> >> >  create mode 100644 arch/arm/mach-exynos/dev-tmu.c
> >> >  delete mode 100644 drivers/hwmon/exynos4_tmu.c
> >> >  create mode 100644 drivers/thermal/cpu_cooling.c
> >> >  create mode 100644 drivers/thermal/exynos4_thermal.c
> >> >  create mode 100644 include/linux/cpu_cooling.h
> >> >
> >
> >


