Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab2AMJtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 04:49:23 -0500
Received: from relay.medianet-world.de ([213.157.0.172]:22611 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757537Ab2AMJtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 04:49:19 -0500
From: Tim Sander <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [ANNOUNCE] 3.0.14-rt31
Date: Fri, 13 Jan 2012 10:42:08 +0100
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        "RT" <linux-rt-users@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Clark Williams" <williams@redhat.com>,
        "John Kacur" <jkacur@redhat.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com> <1326376484.7642.65.camel@gandalf.stny.rr.com> <201201121757.25467.tim.sander@hbm.com>
In-Reply-To: <201201121757.25467.tim.sander@hbm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201131042.08323.tim.sander@hbm.com>
X-OriginalArrivalTime: 13 Jan 2012 09:42:53.0817 (UTC) FILETIME=[B8F57690:01CCD1D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

I was thinking about this ksoftirq0 running on max cpu. The context:
> > > and the running wild ksoftirqd0 most probably after the kernel message:
> > > "sched: RT throttling activated"
> > 
> > Hmm, that's not good. It means that an RT task is spinning too much.
> 
> Mh, sorry i was to terse on that. This only happens after first boot on
> UBIFS update, but it shows that somehow there seems to be a corner case
> when throtteling is activated. Since this seems to be the reason for
> ksoftirq0 running as much cpu as it gets. I just patched out switch to rt
> throtteling and i will ask the mtd guys about the work they presumably do
> in interrupt context which causes this throtteling in the first place.
I just patched out the toggle of the rt-throttle. When this throttle is disabled then
the system hangs on boot but can be rebooted with a sysrq-b. So it might be
cought with rt overload? This hang which does not occur after every update now triggers
the throttle (when not patched out). Then the system runs along with the realtime
throttle activated and now we are going to switch the clocksource with our driver to a
cyclic clock (to fight irq latency). So there might be an error sleeping there in this 
codepath which seems unlikely enought that nearly no one else sees this error?

Best regards
Tim

The patch to remove toggle to realtime (only for reference)
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 53525cb..e5f4290 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -642,8 +642,8 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
                 * but accrue some time due to boosting.
                 */
                if (likely(rt_b->rt_runtime)) {
-                       rt_rq->rt_throttled = 1;
-                       printk_once(KERN_WARNING "sched: RT throttling activated\n");
+                       //rt_rq->rt_throttled = 1;
+                       printk_once(KERN_WARNING "sched: RT throttling would have been activated, but has been disabled.");
                } else {
                        /*
                         * In case we did anyway, make it go away,



Please ignore:

