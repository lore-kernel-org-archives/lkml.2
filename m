Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2KIFQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 00:16:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:14396 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2KIFQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 00:16:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,743,1344236400"; 
   d="scan'208";a="217119746"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Amit Kachhap <amit.kachhap@linaro.org>, "Zhang, Rui" <rui.zhang@intel.com>
CC: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "jonghwa3.lee@samsung.com" <jonghwa3.lee@samsung.com>
Subject: RE: [PATCH 1/4] thermal: Add new thermal trend type to support
 quick cooling
Thread-Topic: [PATCH 1/4] thermal: Add new thermal trend type to support
 quick cooling
Thread-Index: AQHNvWlKuI/lwtvFeEqAROZO0ibuK5ffFgeAgAAG54CAAdq3oA==
Date: Fri, 9 Nov 2012 05:16:14 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59203FE6@BGSMSX101.gar.corp.intel.com>
References: <1352348786-24255-1-git-send-email-amit.kachhap@linaro.org>
	<1352348786-24255-2-git-send-email-amit.kachhap@linaro.org>
	<1352354503.2190.7.camel@rzhang1-mobl4>
 <CAK44p22REJpaJiahX7sTofShNB-+OHVsULqHeuxFNu5msLk6vA@mail.gmail.com>
In-Reply-To: <CAK44p22REJpaJiahX7sTofShNB-+OHVsULqHeuxFNu5msLk6vA@mail.gmail.com>
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

Hi Rui/Amit,

Sorry for the late response..

> -----Original Message-----
> From: Amit Kachhap [mailto:amit.kachhap@linaro.org]
> Sent: Thursday, November 08, 2012 11:56 AM
> To: Zhang, Rui
> Cc: linux-pm@lists.linux-foundation.org; linux-samsung-
> soc@vger.kernel.org; linux-kernel@vger.kernel.org; R, Durgadoss;
> lenb@kernel.org; linux-acpi@vger.kernel.org; jonghwa3.lee@samsung.com
> Subject: Re: [PATCH 1/4] thermal: Add new thermal trend type to support
> quick cooling
> 
> On 8 November 2012 11:31, Zhang Rui <rui.zhang@intel.com> wrote:
> > On Thu, 2012-11-08 at 09:56 +0530, Amit Daniel Kachhap wrote:
> >> This modification adds 2 new thermal trend type
> THERMAL_TREND_RAISE_FULL
> >> and THERMAL_TREND_DROP_FULL. This thermal trend can be used to
> quickly
> >> jump to the upper or lower cooling level instead of incremental increase
> >> or decrease.
> >
> > IMO, what we need is a new more aggressive cooling governor which
> always
> > uses upper limit when the temperature is raising and lower limit when
> > the temperature is dropping.
> Yes I agree that a new aggressive governor is the best approach but
> then i thought adding a new trend type is a simple solution to achieve
> this and since most of the governor logic might be same as the
> step-wise governor. I have no objection in doing it through governor.

Yes, this sounds like a feasible and not-so-complicated implementation for now.
In future, if we see a lot of drivers requiring this sudden raise/drop functionality,
at that time we can introduce an 'aggressive' governor.

Thanks,
Durga

> >
> > I can write such a governor if you do not have time to.
> ok. thanks
> >
> > thanks,
> > rui
> >>  This is needed for temperature sensors which support rising/falling
> >> threshold interrupts and polling can be totally avoided.
> >>
> >
> >
> >> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> >> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
> >> ---
> >>  drivers/thermal/step_wise.c |   19 +++++++++++++++----
> >>  include/linux/thermal.h     |    2 ++
> >>  2 files changed, 17 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
> >> index 1242cff..0d2d8d6 100644
> >> --- a/drivers/thermal/step_wise.c
> >> +++ b/drivers/thermal/step_wise.c
> >> @@ -35,6 +35,10 @@
> >>   *       state for this trip point
> >>   *    b. if the trend is THERMAL_TREND_DROPPING, use lower cooling
> >>   *       state for this trip point
> >> + *    c. if the trend is THERMAL_TREND_RAISE_FULL, use highest cooling
> >> + *       state for this trip point
> >> + *    d. if the trend is THERMAL_TREND_DROP_FULL, use lowest cooling
> >> + *       state for this trip point
> >>   */
> >>  static unsigned long get_target_state(struct thermal_instance *instance,
> >>                                       enum thermal_trend trend)
> >> @@ -50,7 +54,10 @@ static unsigned long get_target_state(struct
> thermal_instance *instance,
> >>       } else if (trend == THERMAL_TREND_DROPPING) {
> >>               cur_state = cur_state > instance->lower ?
> >>                           (cur_state - 1) : instance->lower;
> >> -     }
> >> +     } else if (trend == THERMAL_TREND_RAISE_FULL)
> >> +             cur_state = instance->upper;
> >> +     else if (trend == THERMAL_TREND_DROP_FULL)
> >> +             cur_state = instance->lower;
> >>
> >>       return cur_state;
> >>  }
> >> @@ -87,7 +94,8 @@ static void update_instance_for_throttle(struct
> thermal_zone_device *tz,
> >>  }
> >>
> >>  static void update_instance_for_dethrottle(struct thermal_zone_device
> *tz,
> >> -                             int trip, enum thermal_trip_type trip_type)
> >> +                             int trip, enum thermal_trip_type trip_type,
> >> +                             enum thermal_trend trend)
> >>  {
> >>       struct thermal_instance *instance;
> >>       struct thermal_cooling_device *cdev;
> >> @@ -101,7 +109,10 @@ static void
> update_instance_for_dethrottle(struct thermal_zone_device *tz,
> >>               cdev = instance->cdev;
> >>               cdev->ops->get_cur_state(cdev, &cur_state);
> >>
> >> -             instance->target = cur_state > instance->lower ?
> >> +             if (trend == THERMAL_TREND_DROP_FULL)
> >> +                     instance->target = instance->lower;
> >> +             else
> >> +                     instance->target = cur_state > instance->lower ?
> >>                           (cur_state - 1) : THERMAL_NO_TARGET;
> >>
> >>               /* Deactivate a passive thermal instance */
> >> @@ -133,7 +144,7 @@ static void thermal_zone_trip_update(struct
> thermal_zone_device *tz, int trip)
> >>       if (tz->temperature >= trip_temp)
> >>               update_instance_for_throttle(tz, trip, trip_type, trend);
> >>       else
> >> -             update_instance_for_dethrottle(tz, trip, trip_type);
> >> +             update_instance_for_dethrottle(tz, trip, trip_type, trend);
> >>
> >>       mutex_unlock(&tz->lock);
> >>  }
> >> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> >> index 807f214..8bce3ec 100644
> >> --- a/include/linux/thermal.h
> >> +++ b/include/linux/thermal.h
> >> @@ -68,6 +68,8 @@ enum thermal_trend {
> >>       THERMAL_TREND_STABLE, /* temperature is stable */
> >>       THERMAL_TREND_RAISING, /* temperature is raising */
> >>       THERMAL_TREND_DROPPING, /* temperature is dropping */
> >> +     THERMAL_TREND_RAISE_FULL, /* Apply highest cooling action*/
> >> +     THERMAL_TREND_DROP_FULL, /* Apply lowest cooling action*/
> >>  };
> >>
> >>  /* Events supported by Thermal Netlink */
> >
> >
