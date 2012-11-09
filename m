Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab2KIFyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 00:54:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:20494 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab2KIFyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 00:54:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,743,1344236400"; 
   d="scan'208";a="215356277"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>, Amit Kachhap <amit.kachhap@linaro.org>
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
Thread-Index: AQHNvWlKuI/lwtvFeEqAROZO0ibuK5ffFgeAgAAG54CAAWboAIAAdBYQ
Date: Fri, 9 Nov 2012 05:54:15 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5920406D@BGSMSX101.gar.corp.intel.com>
References: <1352348786-24255-1-git-send-email-amit.kachhap@linaro.org>
	 <1352348786-24255-2-git-send-email-amit.kachhap@linaro.org>
	 <1352354503.2190.7.camel@rzhang1-mobl4>
	 <CAK44p22REJpaJiahX7sTofShNB-+OHVsULqHeuxFNu5msLk6vA@mail.gmail.com>
 <1352433060.2166.3.camel@rzhang1-mobl4>
In-Reply-To: <1352433060.2166.3.camel@rzhang1-mobl4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA95sjwW029693

Hi Amit/Rui,

> -----Original Message-----
> From: Zhang, Rui
> Sent: Friday, November 09, 2012 9:21 AM
> To: Amit Kachhap
> Cc: linux-pm@lists.linux-foundation.org; linux-samsung-
> soc@vger.kernel.org; linux-kernel@vger.kernel.org; R, Durgadoss;
> lenb@kernel.org; linux-acpi@vger.kernel.org; jonghwa3.lee@samsung.com
> Subject: Re: [PATCH 1/4] thermal: Add new thermal trend type to support
> quick cooling
> 
> On Thu, 2012-11-08 at 11:56 +0530, Amit Kachhap wrote:
> > On 8 November 2012 11:31, Zhang Rui <rui.zhang@intel.com> wrote:
> > > On Thu, 2012-11-08 at 09:56 +0530, Amit Daniel Kachhap wrote:
> > >> This modification adds 2 new thermal trend type
> THERMAL_TREND_RAISE_FULL
> > >> and THERMAL_TREND_DROP_FULL. This thermal trend can be used to
> quickly
> > >> jump to the upper or lower cooling level instead of incremental increase
> > >> or decrease.
> > >
> > > IMO, what we need is a new more aggressive cooling governor which
> always
> > > uses upper limit when the temperature is raising and lower limit when
> > > the temperature is dropping.
> > Yes I agree that a new aggressive governor is the best approach but
> > then i thought adding a new trend type is a simple solution to achieve
> > this and since most of the governor logic might be same as the
> > step-wise governor. I have no objection in doing it through governor.
> > >
> hmmm,
> I think a more proper way is to set the cooling state to upper limit
> when it overheats and reduce the cooling state step by step when the
> temperature drops.
> what do you think?

I have only one concern here: (mostly on Passive cooling cases)
Setting the cooling state to upper limit will surely help in rapid cooling,
but it will also disrupt the thermal steady state, and the performance might
be jittery.

Let me explain a bit:
On small form factors (like smartphones, tablets, netbooks), when we run
CPU intensive benchmarks, we can easily observe this jittery performance.

The CPU will run in a very high freq for few seconds(which means temperature is
well below trip point), and then switch back to very low frequency in the next
few seconds(which means temperature hit the trip point). This switch will keep
happening for every few seconds. So, the temperature never settles (say for example,
somewhere in the middle of [low CPU temp, CPU Trip temp]. 

I could see two reasons for this:
1. The poll delay: Between two successive polls, however small the poll delay(~20s) may be,
the CPU temperature can raise up to 15C (Just my observation)
2. Sudden passive cooling. The freq switches between HFM and LFM and never
something in between.

Thatâ€™s why for passive cooling cases, this behavior might not be welcomed always.

So, I would prefer not to set the cooling state to upper limit always. Instead, we will
keep the existing behavior but introduce new trend types (something like what Amit
has done). In this case, the user/tester is explicitly is setting the cooling trend to
'SUDDEN cooling' which means he/she is 'Ok' with Jitter in performance. Things are
explicitly said here, which makes it easy to identify performance issues, if any arise.

In fact, this is one of the reasons, why we have the 'weight' and the 'cur_trip_level'
variables in the fair share governor. Together, both these variables, ensure that
we do not throttle a cooling device, to more than what is necessary.

I do not think any of this matters for active cooling, where we do not impact
performance :-)

Sorry again for the late response. Thanks both of you for bringing this up..

Thanks,
Durga

> 
> thanks,
> rui
> 
> > > I can write such a governor if you do not have time to.
> > ok. thanks
> > >
> > > thanks,
> > > rui
> > >>  This is needed for temperature sensors which support rising/falling
> > >> threshold interrupts and polling can be totally avoided.
> > >>
> > >
> > >
> > >> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > >> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
> > >> ---
> > >>  drivers/thermal/step_wise.c |   19 +++++++++++++++----
> > >>  include/linux/thermal.h     |    2 ++
> > >>  2 files changed, 17 insertions(+), 4 deletions(-)
> > >>
> > >> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
> > >> index 1242cff..0d2d8d6 100644
> > >> --- a/drivers/thermal/step_wise.c
> > >> +++ b/drivers/thermal/step_wise.c
> > >> @@ -35,6 +35,10 @@
> > >>   *       state for this trip point
> > >>   *    b. if the trend is THERMAL_TREND_DROPPING, use lower cooling
> > >>   *       state for this trip point
> > >> + *    c. if the trend is THERMAL_TREND_RAISE_FULL, use highest cooling
> > >> + *       state for this trip point
> > >> + *    d. if the trend is THERMAL_TREND_DROP_FULL, use lowest cooling
> > >> + *       state for this trip point
> > >>   */
> > >>  static unsigned long get_target_state(struct thermal_instance
> *instance,
> > >>                                       enum thermal_trend trend)
> > >> @@ -50,7 +54,10 @@ static unsigned long get_target_state(struct
> thermal_instance *instance,
> > >>       } else if (trend == THERMAL_TREND_DROPPING) {
> > >>               cur_state = cur_state > instance->lower ?
> > >>                           (cur_state - 1) : instance->lower;
> > >> -     }
> > >> +     } else if (trend == THERMAL_TREND_RAISE_FULL)
> > >> +             cur_state = instance->upper;
> > >> +     else if (trend == THERMAL_TREND_DROP_FULL)
> > >> +             cur_state = instance->lower;
> > >>
> > >>       return cur_state;
> > >>  }
> > >> @@ -87,7 +94,8 @@ static void update_instance_for_throttle(struct
> thermal_zone_device *tz,
> > >>  }
> > >>
> > >>  static void update_instance_for_dethrottle(struct
> thermal_zone_device *tz,
> > >> -                             int trip, enum thermal_trip_type trip_type)
> > >> +                             int trip, enum thermal_trip_type trip_type,
> > >> +                             enum thermal_trend trend)
> > >>  {
> > >>       struct thermal_instance *instance;
> > >>       struct thermal_cooling_device *cdev;
> > >> @@ -101,7 +109,10 @@ static void
> update_instance_for_dethrottle(struct thermal_zone_device *tz,
> > >>               cdev = instance->cdev;
> > >>               cdev->ops->get_cur_state(cdev, &cur_state);
> > >>
> > >> -             instance->target = cur_state > instance->lower ?
> > >> +             if (trend == THERMAL_TREND_DROP_FULL)
> > >> +                     instance->target = instance->lower;
> > >> +             else
> > >> +                     instance->target = cur_state > instance->lower ?
> > >>                           (cur_state - 1) : THERMAL_NO_TARGET;
> > >>
> > >>               /* Deactivate a passive thermal instance */
> > >> @@ -133,7 +144,7 @@ static void thermal_zone_trip_update(struct
> thermal_zone_device *tz, int trip)
> > >>       if (tz->temperature >= trip_temp)
> > >>               update_instance_for_throttle(tz, trip, trip_type, trend);
> > >>       else
> > >> -             update_instance_for_dethrottle(tz, trip, trip_type);
> > >> +             update_instance_for_dethrottle(tz, trip, trip_type, trend);
> > >>
> > >>       mutex_unlock(&tz->lock);
> > >>  }
> > >> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > >> index 807f214..8bce3ec 100644
> > >> --- a/include/linux/thermal.h
> > >> +++ b/include/linux/thermal.h
> > >> @@ -68,6 +68,8 @@ enum thermal_trend {
> > >>       THERMAL_TREND_STABLE, /* temperature is stable */
> > >>       THERMAL_TREND_RAISING, /* temperature is raising */
> > >>       THERMAL_TREND_DROPPING, /* temperature is dropping */
> > >> +     THERMAL_TREND_RAISE_FULL, /* Apply highest cooling action*/
> > >> +     THERMAL_TREND_DROP_FULL, /* Apply lowest cooling action*/
> > >>  };
> > >>
> > >>  /* Events supported by Thermal Netlink */
> > >
> > >
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
