Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1GBV3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:29:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50471 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab1GBV3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:29:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@gmail.com
Subject: Re: [PATCH v3 1/3] PM: Introduce DEVFREQ: generic DVFS framework with device-specific OPPs
Date: Sat, 2 Jul 2011 23:30:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Nishanth Menon <nm@ti.com>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jiejing Zhang <kzjeef@gmail.com>, Colin Cross <ccross@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1306471995-4048-1-git-send-email-myungjoo.ham@samsung.com> <BANLkTi=bRWnRGGWUoLcnTmp_9ynOoig0Nw@mail.gmail.com> <201106162311.00593.rjw@sisk.pl>
In-Reply-To: <201106162311.00593.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107022330.30489.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 16, 2011, Rafael J. Wysocki wrote:
> Nishanth,
> 
> Have your comments been addressed by the message below?

>From the silence I gather they have.

Thanks,
Rafael


 
> On Monday, May 30, 2011, MyungJoo Ham wrote:
> > On Sat, May 28, 2011 at 5:57 PM, Nishanth Menon <nm@ti.com> wrote:
> > > On 13:53-20110527, MyungJoo Ham wrote:
> > > [..]
> > >> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> > >> index 56a6899..819c1b3 100644
> > >> --- a/drivers/base/power/opp.c
> > >> +++ b/drivers/base/power/opp.c
> > >> @@ -21,6 +21,7 @@
> > >>  #include <linux/rculist.h>
> > >>  #include <linux/rcupdate.h>
> > >>  #include <linux/opp.h>
> > >> +#include <linux/devfreq.h>
> > >>
> > >>  /*
> > >>   * Internal data structure organization with the OPP layer library is as
> > >> @@ -428,6 +429,11 @@ int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
> > >>       list_add_rcu(&new_opp->node, head);
> > >>       mutex_unlock(&dev_opp_list_lock);
> > >>
> > >> +     /*
> > >> +      * Notify generic dvfs for the change and ignore error
> > >> +      * because the device may not have a devfreq entry
> > >> +      */
> > >> +     devfreq_update(dev);
> > > I think I understand your thought about notifiers here - we had some
> > > initial thought that we may need notifiers, for e.g. clk change
> > > notifiers which could implement enable/disable on a dependent device,
> > > thermal management etc.. so far, we have'nt had a need to modify the
> > > lowest data store layer to handle this. In this case, I think you'd
> > > like a notifier mechanism in general for opp_add,enable or disable in
> > > the opp library.
> > 
> > Yes, I wanted a notifier machnaism called by OPP for any potential
> > changes in available frequencies. For that purpose, I've added
> > devfreq_update() because, for now, DEVFREQ is the only one that needs
> > such a notifier and a notifier has some overhead. If there are
> > multiple entities that require notifications from OPP for such
> > changes, we'd need notifiers maintained by OPP.
> > 
> > > However, with this change, an opp_add now means:
> > > a) opp_add now depends on devfreq_update() to be part of it's integral
> > > operation - I think the devfreq should maintain it's own notifier
> > > mechanisms and not make OPP library do the notification trigger job of
> > > devfreq.
> > 
> > To let the entities depending on the list of available frequencies be
> > notified, I think it would be appropriate for OPP to have a notifier
> > chain and call the notifier chain whenever there is a change in the
> > list. In that way, we can always add and remove the depending entities
> > (including DEVFREQ) to and from OPP's. Otherwise, we'd need OPP users
> > that call OPP functions to call the notifier chain when it appears
> > that the call will change the list.
> > 
> > As long as the updates in available frequencies affect other entities,
> > OPP library should be able to notify the others whenever such changes
> > occur. In this patch, I've used devfreq_update() directly because we
> > do not have other entities, yet. However, as you've  mentioned, there
> > will be others, so I'm willing to implement notifier in OPP if other
> > people also agree.
> > 
> > > b) By ignoring the error, how will the caller of opp_add now know if the
> > > failures were real - e.g. some device failed to act on the notification
> > > and the overall opp_add operation failed? And why should OPP library do
> > > recovery for on behalf of devfreq?
> > 
> > Um... OPP does not need to do any recovery for errors from DEVFREQ.
> > Other than errors from find_device_devfreq() in devfreq_update(), the
> > errors seem to be better returned somehow to the caller of opp_add().
> > However, would it be fine to let opp_add (and other
> > frequency-availability changing functions) return errors returned from
> > a notifier? (either devfreq_update() or srcu_notifier_call_chain())
> > 
> > > c) How will you ensure the lock accuracy - given that you need to keep
> > > to the constraints of opp_add/opp_set_availability here? For example:
> > > devfreq_do is called from devfreq_monitor(workqueue) and devfreq_update
> > > in addition to having to call a bunch of function pointers whose
> > > implementation you do not know, having a function that ensures security
> > > of it's data, handles all lock conditions that is imposed differently by
> > > add,enable and disable is not visible in this implementation.
> > 
> > devfreq_update() waits for devfreq_monitor() with devfreq_list_lock.
> > Both has devfreq_list_lock locked during their operations.
> > 
> > > c) How about considering the usage of OPP library with an SoC cpufreq
> > > implementation say for MPU AND using the same SoC using devfreq for
> > > controlling some devices like MALI in your example simultaneously? Lets
> > > say the thermal policy manager implementation for some reason did an
> > > opp_disable of a higher OPP of MPU - devfreq_update gets called with the
> > > device(mpu_dev).. devfreq_update needs to now invoke it's validation
> > > path and fails correctly - Vs devfreq_update being called by some module
> > > which actually uses devfreq and the update failed - How does one
> > > differentiate between the two?
> > 
> > When OPP is being used by CPUFREQ w/ CPU and by MALI, the OPP list
> > should be attached to the two devices independently.
> > In other words, the frequency of CPU should be controlled
> > independently from the frequency of OPP. If both CPU and MALI should
> > use the same frequency, there is no point to implement devfreq for
> > MALI. However, if the condition is not fully-dependent; e.g.,
> > Freq(MALI) <= Freq(CPU), we can implement two instances of OPP for
> > each of CPU and MALI and let the "target" function supplied to CPU to
> > run opp_enable/disable and devfreq_update() to MALI before adjusting
> > the frequency of itself.
> > 
> > When we are implementing another entity that controls OPP/DEVFREQ such
> > as the thermal policy manager, it should tackle both CPU and MALI w/
> > OPPs at the same time if they are fully independent (i.e., the
> > frequency of MALI is not affected by the frequency of CPU). If not,
> > the same things (discussed in the previous paragraph) are applied.
> > 
> > In the two examples you've mentioned, the first one is about the
> > implementation of the current patch (let thermal manager handle OPP
> > and OPP handle devfreq_update) and the another is when DEVFREQ calls
> > are implemented through thermal manager (let thermal manager handle
> > both OPP and devfreq_update), right?
> > 
> > For the two cases, I think that the first approach is more
> > appropriate. We will probably have more than just a thermal manager to
> > handle OPP (and devfreq that depends on OPP). The first approach
> > allows users to declare which frequencies are available and to let the
> > underlying structure do their work without intervention from users
> > (those who decide which frequencies are available). With the second
> > approach, we need to enforce every frequency affecting entity to
> > understand underlying frequency dependencies and the behavior of
> > devfreq, not jst to understand the behavior of the device according to
> > the frequency. DEVFREQ is going to be handled and implemented by the
> > device driver of the device controlled by the instance of DEVFREQ. By
> > using the first approach, we can prevent affecting entities other than
> > the device driver using DEVFREQ from thinking about DEVFREQ of that
> > device.
> > 
> > 
> > >
> > > just my 2 cents, I think these kind of notifiers should probably
> > > stay out of opp library OR notifiers be introduced in a generic and safe
> > > fashion.
> > 
> > So, you want either
> > 
> > to call devfreq_update from where opp_add/enable/disable/... are called.
> > 
> > or
> > 
> > to use notifier in OPP?
> > 
> > 
> > Well, the first one would become the source of messy problems as
> > mentioned earlier. The second one has some overhead, but it's a
> > general approach and does not incur the issues of the first approach.
> > 
> > Therefore, I prefer either to keep the initial approach regarding
> > devfreq_update() or to use a generic notifier at OPP (probably, SRCU
> > notifier chains?).
> > 
> > How about using a SRCU_NOTIFIER at OPP?
> > 
> > The notifier.h says that SRCU has low overhead generally and the most
> > overhead of SRCU comes from "remove srcu" (probably when "device" is
> > being removed), which won't happen a lot with OPP.
> > 
> > >
> > >>       return 0;
> > >>  }
> > >>
> > >> @@ -512,6 +518,9 @@ unlock:
> > >>       mutex_unlock(&dev_opp_list_lock);
> > >>  out:
> > >>       kfree(new_opp);
> > >> +
> > >> +     /* Notify generic dvfs for the change and ignore error */
> > >> +     devfreq_update(dev);
> > > Another place where I am confused - how does devfreq_update know in what
> > > context is it being called is the OPP getting enabled/disabled/added -
> > > devfreq_update has to do some additional work to make it's own decision
> > > - it is almost as if it uses devfreq_update as a trigger mechanism to reevalute
> > > the entire decision tree - without using information of the context
> > > opp_enable/disable/add has to maybe make better call. if this
> > > information is not needed, maybe some other mechanism implemented by
> > > devfreq layer might suffice..
> > 
> > No, DEVFREQ does not require the context (OPP being
> > enabled/disabled/...) with the devfreq_update() calls. It is
> > essentially a "notify devfreq to reevaluate" and DEVFREQ reevaluates
> > based on the available frequencies.
> > 
> > Thus, a plain srcu_notifier_call_chain() should work for
> > DEVFREQ/devfreq_update from OPP.
> > 
> > >
> > >>       return r;
> > >>  }
> > >
> > > [...]
> > > --
> > > Regards,
> > > Nishanth Menon
> > >
> > 
> > 
> > Thank you for your comments, Nishanth.
> > 
> > 
> > Cheers!
> > - MyungJoo
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

