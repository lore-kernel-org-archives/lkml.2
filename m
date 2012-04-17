Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207Ab2DQTJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:09:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:5212 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2DQTJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:09:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="142861332"
Subject: Re: [PATCH] clockevents: Leave broadcast device shtudown only if
 the current device is always running.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Date: Tue, 17 Apr 2012 12:11:28 -0700
In-Reply-To: <4F8D266D.4030207@ti.com>
References: <1333951423-27621-1-git-send-email-santosh.shilimkar@ti.com>
	  <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
	  <4F8AC59D.6070909@ti.com>
	 <1334613816.28674.108.camel@sbsiddha-desk.sc.intel.com>
	 <4F8D266D.4030207@ti.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1334689888.28674.140.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 13:44 +0530, Santosh Shilimkar wrote:
> On Tuesday 17 April 2012 03:33 AM, Suresh Siddha wrote:
> > On Sun, 2012-04-15 at 18:27 +0530, Santosh Shilimkar wrote:
> >> The main issue is, you are not letting the one time setup
> >> needed for the broadcast device. Even with above change,
> >> the 'tick_broadcast_device.evtdev' is still in SHUTDOWN
> >> mode and the event handler is pointing to clockevents_handle_noop()

If you see this, handler was not even set to the periodic mode handler.
So the periodic mode for the broadcast device also was not working
before (even with out the recent change). 

In tick_check_broadcast_device(), we do this:

        if (!cpumask_empty(tick_get_broadcast_mask()))
                tick_broadcast_start_periodic(dev);

So with out the CLOCK_EVT_NOTIFY_BROADCAST_ON notification, we won't be
even setting up the periodic mode correctly.

I just extended this to the oneshot mode too, exposing the issue in your
cpuidle code.

> > 
> > On x86, idle driver (like drivers/idle/intel_idle.c:
> > __setup_broadcast_timer()) calls clockevents_notify() with
> > CLOCK_EVT_NOTIFY_BROADCAST_ON, during which we do
> > tick_broadcast_setup_oneshot(). See tick_do_broadcast_on_off() which
> > does this. That should setup the evtdev handler, mode etc.
> > 
> > And during the next CLOCK_EVT_NOTIFY_BROADCAST_ENTER we program the next
> > broadcast event.
> >
> I see.
> 
> > 
> > Anyways, can you add CLOCK_EVT_NOTIFY_BROADCAST_ON/OFF notifications in
> > your idle driver to see if it addresses the problem. That is the correct
> > thing to do here.
> > 
> Before your commit 77b0d60c{clockevents: Leave the broadcast device..},
> my idle driver was working without CLOCK_EVT_NOTIFY_BROADCAST_ON
> notifier. Now it's clear that it was relying on the default
> 'tick_broadcast_setup_oneshot()' which was happening during boot.
> 
> And ofcource notifying explicitly with BROADCAST_ON does the
> tick setup. Will update my idle driver accordingly but can
> you please explain me why the proposed patch [1] is not correct
> approach ? It should be also do what you intended to do
> with minimal change, right ?

Please see the above. Essentially irrespective of the recent change,
periodic mode was also broken. Probably no one cared about that mode and
we didn't notice that issue so far. Anyhow, the correct thing to do here
is to add those notifications to the cpuidle driver. Can you please
check if the appended/untested patch fixes your issue? If so, please
push this to your driver. thanks.
---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: arm: omap4: cpuidle: add CLOCK_EVT_NOTIFY_BROADCAST_ON/OFF notifications

Add the missing CLOCK_EVT_NOTIFY_BROADCAST_ON/OFF clockevent notifications.
This will setup the broadcast timer in either periodic/oneshot modes
correctly. Recent clockevent infrastructure change "leave the broadcast
device in shutdown mode when not needed" exposed this bug leading to boot
hangs in oneshot mode. Prior to this, periodic broadcast mode was also
broken. This change fixes both the periodic/oneshot broadcast modes.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/arm/mach-omap2/cpuidle44xx.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/cpuidle44xx.c b/arch/arm/mach-omap2/cpuidle44xx.c
index f386cbe..cd89f58 100644
--- a/arch/arm/mach-omap2/cpuidle44xx.c
+++ b/arch/arm/mach-omap2/cpuidle44xx.c
@@ -161,7 +161,16 @@ static inline struct omap4_idle_statedata *_fill_cstate_usage(
 	return cx;
 }
 
+static void __setup_broadcast_timer(void *arg)
+{
+	unsigned long reason = (unsigned long)arg;
+	int cpu = smp_processor_id();
+
+	reason = reason ?
+		CLOCK_EVT_NOTIFY_BROADCAST_ON : CLOCK_EVT_NOTIFY_BROADCAST_OFF;
 
+	clockevents_notify(reason, &cpu);
+}
 
 /**
  * omap4_idle_init - Init routine for OMAP4 idle
@@ -214,6 +223,8 @@ int __init omap4_idle_init(void)
 	cpuidle_register_driver(&omap4_idle_driver);
 
 	dev->state_count = OMAP4_NUM_STATES;
+
+	on_each_cpu(__setup_broadcast_timer, (void *) true, 1);
 	if (cpuidle_register_device(dev)) {
 		pr_err("%s: CPUidle register device failed\n", __func__);
 			return -EIO;


