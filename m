Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2K1AwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:52:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:22019 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab2K1Av4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:51:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,174,1355126400"; 
   d="scan'208";a="225432596"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Don Zickus <dzickus@redhat.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] watchdog: optimizing the hrtimer interval for power
 saving
Thread-Topic: [PATCH] watchdog: optimizing the hrtimer interval for power
 saving
Thread-Index: AQHNzBH66RGbtu29W0CUcPMUnOFXKpf+aEog
Date: Wed, 28 Nov 2012 00:51:53 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1DBCD9@SHSMSX101.ccr.corp.intel.com>
References: <1353602906.15558.1695.camel@cliu38-desktop-build>
 <20121126200917.GW1871@redhat.com>
In-Reply-To: <20121126200917.GW1871@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Don Zickus [mailto:dzickus@redhat.com]
> Sent: Tuesday, November 27, 2012 4:09 AM
> To: Liu, Chuansheng
> Cc: akpm@linux-foundation.org; mingo@kernel.org; rjw@sisk.pl;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] watchdog: optimizing the hrtimer interval for power
> saving
> 
> On Fri, Nov 23, 2012 at 12:48:26AM +0800, Chuansheng Liu wrote:
> >
> > By default, the watchdog threshold is 10, it means every 4s
> > every CPU will receive one hrtimer interrupt, for low power
> > device, it will cause 4-5mV power impact when device is deep
> > sleep.
> >
> > So here want to optimize it as below:
> > 4s + 4s + 4s + 4s + 4s
> > == >
> > 12s + 2s + 2s + 2s + 2s
> > 3/5   1/10 1/10 1/10 1/10
> >
> > In 5 chances, once one chance is hit, then we can start the
> > hrtimer with a longer period sample(12s). Until the current
> > chance is not hit, will start the hrtimer with a shorted
> > period sample(2s).
> 
> Hmm.  Have you tried this patch with cpuspeed (or cpupower) disabled?
> The reason I ask is the watchdog threshold is set to 10 which means the
> hardlockup watchdog will go off in 10 seconds if it isn't kicked by
> hrtimers.
> 
> So 12 seconds will miss the window repeatedly.
Thanks your pointing out. 
So I will submit V2 patch with the below checking about starting 2s or 12s hrtimer:
void watchdog_timer_fn()
{
  If(watchdog_nmi_touch is false)
     start 2s timer;
  else
     start 12s timer;
}
It can cover the case of 12s > 10s although in most cases it will not happen,
as you said, the 10s window is usually 60s.

> 
> However, the hardlockup works by calculating the max cpu frequency and
> converting it to 10 seconds.  Thanks to cpuspeed, most machines don't run
> at max frequency.  Therefore a 10 second window is usually 60 seconds or
> more.   So your initial testing might have missed the fact that 12 seconds
> is greater than the 10 second hardlockup period.
I have tried the case of set the CPU frequency to MAX, the nmi interrupt interval
is still about 20s.
> 
> Cheers,
> Don
> 
> >
> > With this patch, in most case the hrtimer will be 12s instead
> > of 4s averagely. It can save the device power indeed.
> >
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  kernel/watchdog.c |   30 ++++++++++++++++++++++++++++--
> >  1 files changed, 28 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> > index dd4b80a..6457e62 100644
> > --- a/kernel/watchdog.c
> > +++ b/kernel/watchdog.c
> > @@ -125,7 +125,24 @@ static u64 get_sample_period(void)
> >  	 * and hard thresholds) to increment before the
> >  	 * hardlockup detector generates a warning
> >  	 */
> > -	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
> > +	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 10);
> > +}
> > +
> > +static u64 get_long_sample_period(void)
> > +{
> > +	/*
> > +	 * convert watchdog_thresh from seconds to ns
> > +	 * We want to give 5 chances to detect softlockup,
> > +	 * for power saving, once one chance is succeeding,
> > +	 * we can set long period to avoid power consumption.
> > +	 * Currently, set the long sample period is:
> > +	 * 20s * 3/5 = 12s, once this 12s chance is not hit,
> > +	 * we will divide the left 8s into 4 pieces, give every
> > +	 * chance every 2s, so it will be likely:
> > +	 * 12s + 2s + 2s + 2s + 2s,
> > +	 * Anyway, we just use 12s is enough in normal case.
> > +	 */
> > +	return get_softlockup_thresh() * ((u64)NSEC_PER_SEC * 3 / 5);
> >  }
> >
> >  /* Commands for resetting the watchdog */
> > @@ -267,6 +284,10 @@ static enum hrtimer_restart
> watchdog_timer_fn(struct hrtimer *hrtimer)
> >  	unsigned long touch_ts = __this_cpu_read(watchdog_touch_ts);
> >  	struct pt_regs *regs = get_irq_regs();
> >  	int duration;
> > +	bool is_touched;
> > +
> > +	is_touched = (__this_cpu_read(hrtimer_interrupts) ==
> > +		__this_cpu_read(soft_lockup_hrtimer_cnt));
> >
> >  	/* kick the hardlockup detector */
> >  	watchdog_interrupt_count();
> > @@ -275,7 +296,12 @@ static enum hrtimer_restart
> watchdog_timer_fn(struct hrtimer *hrtimer)
> >  	wake_up_process(__this_cpu_read(softlockup_watchdog));
> >
> >  	/* .. and repeat */
> > -	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
> > +	if (is_touched) {
> > +		hrtimer_forward_now(hrtimer,
> > +			ns_to_ktime(get_long_sample_period()));
> > +	} else {
> > +		hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
> > +	}
> >
> >  	if (touch_ts == 0) {
> >  		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
> > --
> > 1.7.0.4
> >
> >
> >
