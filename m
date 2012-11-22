Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2KVSiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:38:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:5693 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab2KVSis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,299,1352102400"; 
   d="scan'208";a="252761618"
Message-ID: <1353571951.2297.7.camel@rzhang1-mobl4>
Subject: Re: [PATCH 1/4] thermal: Add new thermal trend type to support
 quick cooling
From: Zhang Rui <rui.zhang@intel.com>
To: Amit Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, durgadoss.r@intel.com, lenb@kernel.org,
        linux-acpi@vger.kernel.org, jonghwa3.lee@samsung.com
Date: Thu, 22 Nov 2012 16:12:31 +0800
In-Reply-To: <CAK44p21mnUpWpHWui6yFqaE5mrjTHhx48j3Mgm0K-KL3EskaGA@mail.gmail.com>
References: <1352348786-24255-1-git-send-email-amit.kachhap@linaro.org>
	 <1352348786-24255-2-git-send-email-amit.kachhap@linaro.org>
	 <1353547324.2172.1.camel@rzhang1-mobl4>
	 <CAK44p21mnUpWpHWui6yFqaE5mrjTHhx48j3Mgm0K-KL3EskaGA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-22 at 10:11 +0530, Amit Kachhap wrote:
> On 22 November 2012 06:52, Zhang Rui <rui.zhang@intel.com> wrote:
> > On Thu, 2012-11-08 at 09:56 +0530, Amit Daniel Kachhap wrote:
> >> This modification adds 2 new thermal trend type THERMAL_TREND_RAISE_FULL
> >> and THERMAL_TREND_DROP_FULL. This thermal trend can be used to quickly
> >> jump to the upper or lower cooling level instead of incremental increase
> >> or decrease. This is needed for temperature sensors which support rising/falling
> >> threshold interrupts and polling can be totally avoided.
> >>
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
> >> @@ -50,7 +54,10 @@ static unsigned long get_target_state(struct thermal_instance *instance,
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
> >> @@ -87,7 +94,8 @@ static void update_instance_for_throttle(struct thermal_zone_device *tz,
> >>  }
> >>
> >>  static void update_instance_for_dethrottle(struct thermal_zone_device *tz,
> >> -                             int trip, enum thermal_trip_type trip_type)
> >> +                             int trip, enum thermal_trip_type trip_type,
> >> +                             enum thermal_trend trend)
> >>  {
> >>       struct thermal_instance *instance;
> >>       struct thermal_cooling_device *cdev;
> >> @@ -101,7 +109,10 @@ static void update_instance_for_dethrottle(struct thermal_zone_device *tz,
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
> > what do you expect to happen if the trend is THERMAL_TREND_RAISE_FULL at
> > this time?
> >
> Hi Rui,
> 
> I suppose this is dethrotle routine and hence this will be called when
> only drop in temperature happens. Also I did not used get_target_state
> here because I thought it might cause regression in the other existing
> thermal drivers(I am not sure) But I guess calling get_target_state is
> the good way to know next target state and is fine if you agree.
> Also one suggestion, 2 functions for throttle/dethrottle can be merged
> as both look same and just get_target_state can be used in that
> function
> 
agree.
patches have been refreshed, please review.

thanks,
rui

