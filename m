Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab2KLFmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 00:42:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:37578 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab2KLFmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 00:42:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,759,1344236400"; 
   d="scan'208";a="216332895"
Message-ID: <1352698922.1834.1.camel@rzhang1-mobl4>
Subject: Re: [PATCH 1/4] thermal: Add new thermal trend type to support
 quick cooling
From: Zhang Rui <rui.zhang@intel.com>
To: Amit Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, durgadoss.r@intel.com, lenb@kernel.org,
        linux-acpi@vger.kernel.org, jonghwa3.lee@samsung.com
Date: Mon, 12 Nov 2012 13:42:02 +0800
In-Reply-To: <CAK44p22hHVcL21B1iy1OnECMd5RCRF8DVh-cNj=6Bmvr5n0yyQ@mail.gmail.com>
References: <1352348786-24255-1-git-send-email-amit.kachhap@linaro.org>
	 <1352348786-24255-2-git-send-email-amit.kachhap@linaro.org>
	 <1352354503.2190.7.camel@rzhang1-mobl4>
	 <CAK44p22REJpaJiahX7sTofShNB-+OHVsULqHeuxFNu5msLk6vA@mail.gmail.com>
	 <1352433060.2166.3.camel@rzhang1-mobl4>
	 <CAK44p22hHVcL21B1iy1OnECMd5RCRF8DVh-cNj=6Bmvr5n0yyQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-09 at 11:51 +0530, Amit Kachhap wrote:
> On 9 November 2012 09:21, Zhang Rui <rui.zhang@intel.com> wrote:
> > On Thu, 2012-11-08 at 11:56 +0530, Amit Kachhap wrote:
> >> On 8 November 2012 11:31, Zhang Rui <rui.zhang@intel.com> wrote:
> >> > On Thu, 2012-11-08 at 09:56 +0530, Amit Daniel Kachhap wrote:
> >> >> This modification adds 2 new thermal trend type THERMAL_TREND_RAISE_FULL
> >> >> and THERMAL_TREND_DROP_FULL. This thermal trend can be used to quickly
> >> >> jump to the upper or lower cooling level instead of incremental increase
> >> >> or decrease.
> >> >
> >> > IMO, what we need is a new more aggressive cooling governor which always
> >> > uses upper limit when the temperature is raising and lower limit when
> >> > the temperature is dropping.
> >> Yes I agree that a new aggressive governor is the best approach but
> >> then i thought adding a new trend type is a simple solution to achieve
> >> this and since most of the governor logic might be same as the
> >> step-wise governor. I have no objection in doing it through governor.
> >> >
> > hmmm,
> > I think a more proper way is to set the cooling state to upper limit
> > when it overheats and reduce the cooling state step by step when the
> > temperature drops.
> 
> No actually I was thinking of having a  simple governor with a feature
> like it only sets to upper level and lower level. Also since the
> temperature sensor is capable of interrupting for both increase in
> threshold(say 100C)  and fall in threshold (say 90C), so polling or
> step increments is not needed at all.
> Currently stepwise governor governor does that so we might change the
> macro name as,
> THERMAL_TREND_RAISE_STEP,
> THERMAL_TREND_DROP_STEP,
> THERMAL_TREND_RAISE_MAX,
> THERMAL_TREND_DROP_MAX,
> 
> and file step_wise.c can be named as state_wise.c or trend_wise.c.
> 
> I am not sure if it is the best way . How do you feel ?
> 
this sounds good to me.
I'd like to see Durga' comments on this as well.

thanks,
rui
> > what do you think?
> >
> > thanks,
> > rui
> >
> >> > I can write such a governor if you do not have time to.
> >> ok. thanks
> >> >
> >> > thanks,
> >> > rui
> >> >>  This is needed for temperature sensors which support rising/falling
> >> >> threshold interrupts and polling can be totally avoided.
> >> >>
> >> >
> >> >
> >> >> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> >> >> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
> >> >> ---
> >> >>  drivers/thermal/step_wise.c |   19 +++++++++++++++----
> >> >>  include/linux/thermal.h     |    2 ++
> >> >>  2 files changed, 17 insertions(+), 4 deletions(-)
> >> >>
> >> >> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
> >> >> index 1242cff..0d2d8d6 100644
> >> >> --- a/drivers/thermal/step_wise.c
> >> >> +++ b/drivers/thermal/step_wise.c
> >> >> @@ -35,6 +35,10 @@
> >> >>   *       state for this trip point
> >> >>   *    b. if the trend is THERMAL_TREND_DROPPING, use lower cooling
> >> >>   *       state for this trip point
> >> >> + *    c. if the trend is THERMAL_TREND_RAISE_FULL, use highest cooling
> >> >> + *       state for this trip point
> >> >> + *    d. if the trend is THERMAL_TREND_DROP_FULL, use lowest cooling
> >> >> + *       state for this trip point
> >> >>   */
> >> >>  static unsigned long get_target_state(struct thermal_instance *instance,
> >> >>                                       enum thermal_trend trend)
> >> >> @@ -50,7 +54,10 @@ static unsigned long get_target_state(struct thermal_instance *instance,
> >> >>       } else if (trend == THERMAL_TREND_DROPPING) {
> >> >>               cur_state = cur_state > instance->lower ?
> >> >>                           (cur_state - 1) : instance->lower;
> >> >> -     }
> >> >> +     } else if (trend == THERMAL_TREND_RAISE_FULL)
> >> >> +             cur_state = instance->upper;
> >> >> +     else if (trend == THERMAL_TREND_DROP_FULL)
> >> >> +             cur_state = instance->lower;
> >> >>
> >> >>       return cur_state;
> >> >>  }
> >> >> @@ -87,7 +94,8 @@ static void update_instance_for_throttle(struct thermal_zone_device *tz,
> >> >>  }
> >> >>
> >> >>  static void update_instance_for_dethrottle(struct thermal_zone_device *tz,
> >> >> -                             int trip, enum thermal_trip_type trip_type)
> >> >> +                             int trip, enum thermal_trip_type trip_type,
> >> >> +                             enum thermal_trend trend)
> >> >>  {
> >> >>       struct thermal_instance *instance;
> >> >>       struct thermal_cooling_device *cdev;
> >> >> @@ -101,7 +109,10 @@ static void update_instance_for_dethrottle(struct thermal_zone_device *tz,
> >> >>               cdev = instance->cdev;
> >> >>               cdev->ops->get_cur_state(cdev, &cur_state);
> >> >>
> >> >> -             instance->target = cur_state > instance->lower ?
> >> >> +             if (trend == THERMAL_TREND_DROP_FULL)
> >> >> +                     instance->target = instance->lower;
> >> >> +             else
> >> >> +                     instance->target = cur_state > instance->lower ?
> >> >>                           (cur_state - 1) : THERMAL_NO_TARGET;
> >> >>
> >> >>               /* Deactivate a passive thermal instance */
> >> >> @@ -133,7 +144,7 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz, int trip)
> >> >>       if (tz->temperature >= trip_temp)
> >> >>               update_instance_for_throttle(tz, trip, trip_type, trend);
> >> >>       else
> >> >> -             update_instance_for_dethrottle(tz, trip, trip_type);
> >> >> +             update_instance_for_dethrottle(tz, trip, trip_type, trend);
> >> >>
> >> >>       mutex_unlock(&tz->lock);
> >> >>  }
> >> >> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> >> >> index 807f214..8bce3ec 100644
> >> >> --- a/include/linux/thermal.h
> >> >> +++ b/include/linux/thermal.h
> >> >> @@ -68,6 +68,8 @@ enum thermal_trend {
> >> >>       THERMAL_TREND_STABLE, /* temperature is stable */
> >> >>       THERMAL_TREND_RAISING, /* temperature is raising */
> >> >>       THERMAL_TREND_DROPPING, /* temperature is dropping */
> >> >> +     THERMAL_TREND_RAISE_FULL, /* Apply highest cooling action*/
> >> >> +     THERMAL_TREND_DROP_FULL, /* Apply lowest cooling action*/
> >> >>  };
> >> >>
> >> >>  /* Events supported by Thermal Netlink */
> >> >
> >> >
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



