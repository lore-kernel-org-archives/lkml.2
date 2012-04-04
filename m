Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab2DDG1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 02:27:51 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:48415 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab2DDG1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 02:27:50 -0400
Date: Wed, 4 Apr 2012 09:27:19 +0300
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Amit Kachhap <amit.kachhap@linaro.org>
Cc: eduardo.valentin@ti.com, "R, Durgadoss" <durgadoss.r@intel.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "rob.lee@linaro.org" <rob.lee@linaro.org>
Subject: Re: [linux-pm] [PATCH 1/4] thermal: Add a new trip type to use
 cooling device instance number
Message-ID: <20120404062719.GA6785@besouro>
Reply-To: eduardo.valentin@ti.com
References: <1329905650-30161-1-git-send-email-amit.kachhap@linaro.org>
 <1329905650-30161-2-git-send-email-amit.kachhap@linaro.org>
 <4D68720C2E767A4AA6A8796D42C8EB59043B20@BGSMSX101.gar.corp.intel.com>
 <CAK44p233Gsh3WavAEJPRcyAHERYttnJFDXsOAmAGK7tv6jhNGQ@mail.gmail.com>
 <20120403141545.GA27497@besouro>
 <CAK44p20MOu+6qFpwwta+ttbKXgHxsDKyG06EFZBSNFO0aLMDag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK44p20MOu+6qFpwwta+ttbKXgHxsDKyG06EFZBSNFO0aLMDag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 04, 2012 at 09:53:15AM +0530, Amit Kachhap wrote:
> Hi Eduardo,
> 
> On 3 April 2012 19:45, Eduardo Valentin <eduardo.valentin@ti.com> wrote:
> > Hello,
> >
> > On Thu, Feb 23, 2012 at 04:50:14PM +0530, Amit Kachhap wrote:
> >> On 23 February 2012 12:16, R, Durgadoss <durgadoss.r@intel.com> wrote:
> >> > Hi Amit,
> >> >
> >> >> -----Original Message-----
> >> >> From: amit kachhap [mailto:amitdanielk@gmail.com] On Behalf Of Amit Daniel
> >> >> Kachhap
> >> >> Sent: Wednesday, February 22, 2012 3:44 PM
> >> >> To: linux-pm@lists.linux-foundation.org
> >> >> Cc: linux-kernel@vger.kernel.org; mjg59@srcf.ucam.org; linux-
> >> >> acpi@vger.kernel.org; lenb@kernel.org; linaro-dev@lists.linaro.org;
> >> >> amit.kachhap@linaro.org; R, Durgadoss; rob.lee@linaro.org; patches@linaro.org
> >> >> Subject: [PATCH 1/4] thermal: Add a new trip type to use cooling device
> >> >> instance number
> >> >>
> >> >> This patch adds a new trip type THERMAL_TRIP_STATE_ACTIVE. This
> >> >> trip behaves same as THERMAL_TRIP_ACTIVE but also passes the cooling
> >> >> device instance number. This helps the cooling device registered as
> >> >> different instances to perform appropriate cooling action decision in
> >> >> the set_cur_state call back function.
> >> >>
> >> >> Also since the trip temperature's are in ascending order so some logic
> >> >> is put in place to skip the un-necessary checks.
> >> >>
> >> >> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
> >> >> ---
> >> >>  Documentation/thermal/sysfs-api.txt |    4 +-
> >> >>  drivers/thermal/thermal_sys.c       |   45 ++++++++++++++++++++++++++++++++--
> >> >>  include/linux/thermal.h             |    1 +
> >> >>  3 files changed, 45 insertions(+), 5 deletions(-)
> >> >>
> >> >> diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-
> >> >> api.txt
> >> >> index 1733ab9..7a0c080 100644
> >> >> --- a/Documentation/thermal/sysfs-api.txt
> >> >> +++ b/Documentation/thermal/sysfs-api.txt
> >> >> @@ -184,8 +184,8 @@ trip_point_[0-*]_temp
> >> >>
> >> >>  trip_point_[0-*]_type
> >> >>       Strings which indicate the type of the trip point.
> >> >> -     E.g. it can be one of critical, hot, passive, active[0-*] for ACPI
> >> >> -     thermal zone.
> >> >> +     E.g. it can be one of critical, hot, passive, active[0-1],
> >> >> +     state-active[0-*] for ACPI thermal zone.
> >> >>       RO, Optional
> >> >>
> >> >>  cdev[0-*]
> >> >> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> >> >> index 220ce7e..d4c9b20 100644
> >> >> --- a/drivers/thermal/thermal_sys.c
> >> >> +++ b/drivers/thermal/thermal_sys.c
> >> >> @@ -192,6 +192,8 @@ trip_point_type_show(struct device *dev, struct
> >> >> device_attribute *attr,
> >> >>               return sprintf(buf, "passive\n");
> >> >>       case THERMAL_TRIP_ACTIVE:
> >> >>               return sprintf(buf, "active\n");
> >> >> +     case THERMAL_TRIP_STATE_ACTIVE:
> >> >> +             return sprintf(buf, "state-active\n");
> >> >>       default:
> >> >>               return sprintf(buf, "unknown\n");
> >> >>       }
> >> >> @@ -1034,10 +1036,10 @@ EXPORT_SYMBOL(thermal_cooling_device_unregister);
> >> >>
> >> >>  void thermal_zone_device_update(struct thermal_zone_device *tz)
> >> >>  {
> >> >> -     int count, ret = 0;
> >> >> -     long temp, trip_temp;
> >> >> +     int count, ret = 0, inst_id;
> >> >> +     long temp, trip_temp, max_state, last_trip_change = 0;
> >> >>       enum thermal_trip_type trip_type;
> >> >> -     struct thermal_cooling_device_instance *instance;
> >> >> +     struct thermal_cooling_device_instance *instance, *state_instance;
> >> >>       struct thermal_cooling_device *cdev;
> >> >>
> >> >>       mutex_lock(&tz->lock);
> >> >> @@ -1086,6 +1088,43 @@ void thermal_zone_device_update(struct
> >> >> thermal_zone_device *tz)
> >> >>                                       cdev->ops->set_cur_state(cdev, 0);
> >> >>                       }
> >> >>                       break;
> >> >> +             case THERMAL_TRIP_STATE_ACTIVE:
> >> >> +                     list_for_each_entry(instance, &tz->cooling_devices,
> >> >> +                                         node) {
> >> >> +                             if (instance->trip != count)
> >> >> +                                     continue;
> >> >> +
> >> >> +                             if (temp <= last_trip_change)
> >> >> +                                     continue;
> >> >> +
> >> >> +                             inst_id = 0;
> >> >> +                             /*
> >> >> +                             *For this instance how many instance of same
> >> >> +                             *cooling device occured before
> >> >> +                             */
> >> >> +
> >> >> +                             list_for_each_entry(state_instance,
> >> >> +                                             &tz->cooling_devices, node) {
> >> >> +                                     if (instance->cdev ==
> >> >> +                                                     state_instance->cdev)
> >> >> +                                             inst_id++;
> >> >> +                                     if (state_instance->trip == count)
> >> >> +                                             break;
> >> >> +                             }
> >> >
> >> > Can you explain a bit more on this loop and the set_cur_state below ?
> >> > Sorry, I don't get the logic behind this..
> >>
> >> This loop is basically finding the instance id of the same cooling device.
> >> Say we have done like this,
> >> thermal_zone_bind_cooling_device(thermal, 2, cdev);
> >> thermal_zone_bind_cooling_device(thermal, 3, cdev);
> >> thermal_zone_bind_cooling_device(thermal, 4, cdev);
> >>
> >> In above same cooling device cdev is binded to trip no 2,3 and 4 with
> >> inst_id generated as 1,2,3 respectively. so set_cur_state for those
> >> trip reached will be called as,
> >> set_cur_state(cdev, 1);
> >> set_cur_state(cdev, 2);
> >> set_cur_state(cdev, 3);
> >
> > In this case, why a simple state = get_cur_state() followed by a
> > set_cur_state(++state) / set_cur_state(--state) is not enough?
> 
> Thanks for looking into the patch. Well actually what you are
> suggesting is exactly happening in PASSIVE trip types where the states
> are incremented or decremented based on thermal trend. On the contrary
> what this part of code is doing is to jump to a fixed state as and
> when a trip point is reached.  The cooling effect of a frequency level
> is known beforehand and hence jumping into that is safe and also this
> does not cause performance degradation by going into a much lower
> frequency state just for temperature stablization.

Yeah, I see that you want to match an instance of the cooling device with
a cooling state for that cooling device.

> 
> >
> > Another thing is if we want to do jumps in the sequence?
> >
> >  set_cur_state(cdev, 1);
> >  set_cur_state(cdev, 3);
> >  set_cur_state(cdev, 6);
> >
> > But for that we need a table mapping, trip vs. state.
> >
> >
> > What do you think?
> In the current thermal_zone_device_update implementation all the
> checks are currently based on increase in temperature. So even though
> we want to go to  set_cur_state(cdev, 6) we have to follow
> set_cur_state(cdev, 1), set_cur_state(cdev, 2) ,..... and finally
> set_cur_state(cdev, 6). So mapping table may not be needed as state
> transition is one by one. This a type of limitation but I think there
> can be some kind of modification in the way the
> thermal_zone_device_update calls all the lower temperature cooling
> devices instead of jumping directly to the final trip point cooling
> devices.


But, because you also force the thing to be increasing / decreasing 1 by 1,
I don't understand why you don't have a similar implementation of the
PASSIVE type. Just get its cur state and set the next state based on the curr.
How that would be different than what you are currently doing?

If you want to have a 1 to 1 relation between cooling device instance and cooling
device state, then you could do the jumps I mentioned, but only if you would
have the cooling state reference stored somewhere.

What bugs me is the fact that you have to be iterating in the cooling device list to determine
the next cooling state.

> >
> >>
> >> Thanks,
> >> Amit D
> >>
> >> >
> >> > Thanks,
> >> > Durga
> >> >
> >> >> +
> >> >> +                             cdev = instance->cdev;
> >> >> +                             cdev->ops->get_max_state(cdev, &max_state);
> >> >> +
> >> >> +                             if ((temp >= trip_temp) &&
> >> >> +                                             (inst_id <= max_state))
> >> >> +                                     cdev->ops->set_cur_state(cdev, inst_id);
> >> >> +                             else if ((temp < trip_temp) &&
> >> >> +                                             (--inst_id <= max_state))
> >> >> +                                     cdev->ops->set_cur_state(cdev, inst_id);
> >> >> +
> >> >> +                             last_trip_change = trip_temp;
> >> >> +                     }
> >> >> +                     break;
> >> >>               case THERMAL_TRIP_PASSIVE:
> >> >>                       if (temp >= trip_temp || tz->passive)
> >> >>                               thermal_zone_device_passive(tz, temp,
> >> >> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> >> >> index 796f1ff..8df901f 100644
> >> >> --- a/include/linux/thermal.h
> >> >> +++ b/include/linux/thermal.h
> >> >> @@ -42,6 +42,7 @@ enum thermal_trip_type {
> >> >>       THERMAL_TRIP_PASSIVE,
> >> >>       THERMAL_TRIP_HOT,
> >> >>       THERMAL_TRIP_CRITICAL,
> >> >> +     THERMAL_TRIP_STATE_ACTIVE,
> >> >>  };
> >> >>
> >> >>  struct thermal_zone_device_ops {
> >> >> --
> >> >> 1.7.1
> >> >
> >> _______________________________________________
> >> linux-pm mailing list
> >> linux-pm@lists.linux-foundation.org
> >> https://lists.linuxfoundation.org/mailman/listinfo/linux-pm
