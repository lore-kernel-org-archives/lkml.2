Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab2AECNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:13:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:45734 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891Ab2AECNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:13:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92519564"
Date: Thu, 5 Jan 2012 18:27:29 +0800
From: Feng Tang <feng.tang@intel.com>
To: Tim Gardner <tim.gardner@canonical.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <akpm@linux-foundation.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Phil Miller <mille121@illinois.edu>, <philipl@overt.org>,
        <mjt@tls.msk.ru>, <gurligebis@gmail.com>,
        Linux Kernel Mail List <linux-kernel@vger.kernel.org>
Subject: Re: [27/27] clockevents: Set noop handler in
 clockevents_exchange_device()
Message-ID: <20120105182729.5abf7f14@feng-i7>
In-Reply-To: <CA++bM2uqcWFM6=WdmrusmugQw2nH_KDyySKH+1qyr8GK0Cq14A@mail.gmail.com>
References: <20111207165611.GA19872@kroah.com>
	<20111207165602.672902223@clark.kroah.org>
	<20111229120956.GA31878@elie.Belkin>
	<CA+55aFxzM0DamY13ZP_xnOzvcTfyyZtHFc8gismerqDVvGiuWA@mail.gmail.com>
	<4EFDD39D.30802@canonical.com>
	<CA++bM2uqcWFM6=WdmrusmugQw2nH_KDyySKH+1qyr8GK0Cq14A@mail.gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim and all,

> From: Tim Gardner <tim.gardner@canonical.com>
> Date: 2011/12/30
> Subject: Re: [27/27] clockevents: Set noop handler in
> clockevents_exchange_device()
> To: Linus Torvalds <torvalds@linux-foundation.org>
> 抄送： Jonathan Nieder <jrnieder@gmail.com>, Thomas Gleixner
> <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
> linux-kernel@vger.kernel.org, stable@vger.kernel.org,
> akpm@linux-foundation.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Phil
> Miller <mille121@illinois.edu>
> 
> 
> On 12/29/2011 06:05 PM, Linus Torvalds wrote:
> >
> > On Thu, Dec 29, 2011 at 4:09 AM, Jonathan Nieder<jrnieder@gmail.com>  wrote:
> >>
> >>
> >> This is basically the reverse of 7c1e768974 (clockevents: prevent
> >> clockevent event_handler ending up handler_noop, 2008-09-03).  The
> >> rationale for the latter still applies.
> >
> >
> > Hmm. You seem to be right. Instead of applying this to stable, it
> > looks like we should revert it from mainline.
> >
> >>                   People have been reporting
> >> the analagous patch to this one causing hangs on resume in 3.1.y and
> >> 3.2 release candidates:
> >>
> >>  - http://thread.gmane.org/gmane.linux.kernel/1233033
> >>  - http://thread.gmane.org/gmane.linux.kernel/1233389
> >>  - http://thread.gmane.org/gmane.linux.kernel/1233159
> >>  - http://thread.gmane.org/gmane.linux.kernel/1227868/focus=1230877
> >>
> >> So please consider reverting it for now.
> >
> >
> > Thomas? It does seem to be broken and there do seem to be regression
> > reports about it.
> >
> > Should I revert it, or do you have alternative fixes?
> >
> >                  Linus
> > --
> 
> 
> We (Ubuntu) are seeing this issue as well in both 3.0.13 and 3.2-rc6:
> 
> https://lkml.org/lkml/2011/12/24/33
> 
> Reverting that single patch alleviates the resume regression.

I had a Dell Studio XPS machine which see the same hang issue. Per my
track, the root cause of the hang should be:

The machine has 8 CPUs and several Hpets, and it use one hpet as its
broadcast tick device, and 5 hpets as per-cpu tick device for CPU 0-4,
3 Lapics as per-cpu tick device for CPU 5-7.

During the resume cycle, for CPU0-4, the per-cpu tick device setup is
a little complex, a lapic will be assigned as the per-cpu tick first,
and then there will be a switch from lapic to hpet, and problem happens
here during the switch:
    tick_check_new_device()
        ->clockevents_exchange_device():  set the noop handler to lapic tick
	->tick_setup_device(): pass the lapic's handler(noop handler) to hpet

So after the resume, 5 per-cpu hpet device's handler will be all noop handler
instead of hrtimer_interrupt, which will hang the resuming.


Following is a patch which fix the problem on my side, could you please review
and try?

-------------------------------------------------------------------------
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index d6733e2..aa93eca 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -101,6 +101,10 @@ struct clock_event_device {
 	int			irq;
 	const struct cpumask	*cpumask;
 	struct list_head	list;
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	struct tick_device      *td;
+#endif
 } ____cacheline_aligned;
 
 /*
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b232ccc..7000b26 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -17,6 +17,7 @@ enum tick_device_mode {
 
 struct tick_device {
 	struct clock_event_device *evtdev;
+	void  (*last_event_handler)(struct clock_event_device *);
 	enum tick_device_mode mode;
 };
 
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 13dfaab..53db16f 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -286,6 +286,15 @@ void clockevents_exchange_device(struct clock_event_device *old,
 	 * released list and do a notify add later.
 	 */
 	if (old) {
+		/*
+		 * If the old device is the per-cpu tick device, then we
+		 * need to record its event handler, so that it could be
+		 * passed to the new tick device in tick_setup_device()
+		 */
+		if (old->td) {
+			old->td->last_event_handler = old->event_handler;
+			old->td = NULL;
+		}
 		old->event_handler = clockevents_handle_noop;
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 119528d..5ec54e9 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -173,12 +173,12 @@ static void tick_setup_device(struct tick_device *td,
 		 */
 		td->mode = TICKDEV_MODE_PERIODIC;
 	} else {
-		handler = td->evtdev->event_handler;
+		handler = td->last_event_handler;
 		next_event = td->evtdev->next_event;
-		td->evtdev->event_handler = clockevents_handle_noop;
 	}
 
 	td->evtdev = newdev;
+	newdev->td = td;
 
 	/*
 	 * When the device is not per cpu, pin the interrupt to the


	


> 
> rtg
> --
> Tim Gardner tim.gardner@canonical.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
