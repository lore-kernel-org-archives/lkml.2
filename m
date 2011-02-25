Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab1BYVrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:47:32 -0500
Received: from www.tglx.de ([62.245.132.106]:59737 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab1BYVrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:47:31 -0500
Date: Fri, 25 Feb 2011 22:47:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Seth Forshee <seth.forshee@canonical.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: Performance/resume issues on Toshiba NB305
In-Reply-To: <20110225212142.GC24686@thinkpad-t410>
Message-ID: <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6>
References: <20110225164239.GA24686@thinkpad-t410> <alpine.LFD.2.00.1102252108190.2701@localhost6.localdomain6> <20110225212142.GC24686@thinkpad-t410>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Seth Forshee wrote:
> On Fri, Feb 25, 2011 at 09:37:39PM +0100, Thomas Gleixner wrote:
> > On Fri, 25 Feb 2011, Seth Forshee wrote:
> > That seems to be related to low power states. When the machine goes
> > idle we switch into lower power states and that requires to use the
> > hpet instead of the local apic timer as that one stops.
> > 
> > You could verify that theory by booting with processor.max_cstate=1
> 
> This fixes the performance in combination with intel_idle.max_cstate=0.
> Alternately, intel_idle.max_cstate=1 works. But the resume still hangs.

That was expected :)

> Is the answer to quirk the machine to avoid deep C-states, or is there
> some better way I can fix this?

Let's wait for the intel and acpi folks. It would be interesting what
the new intel toy says to your BIOS.

    http://biosbits.org/

> > > +unlock:
> > >  	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
> > >  }
> > 
> > Why would you need that? We should not call that when the broadcast
> > device does not have TICKDEV_MODE_ONESHOT. If we do the bug is
> > somewhere else.
> 
> Then there must be a bug. When I cleared CLOCK_EVT_FEAT_ONESHOT for the
> HPET without this change the HPET got put into oneshot mode. The local
> tick device is checked before switching to nohz, but not the broadcast
> device. This change was just a quick hack to get around that and test my
> theory.

Indeed. The patch below should cure that.

Thanks,

	tglx

----------->
Subject: clockevents-fix-broadcast.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 25 Feb 2011 22:34:23 +0100

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c |   10 ++++++++++
 kernel/time/tick-common.c    |    6 +++++-
 kernel/time/tick-internal.h  |    3 +++
 3 files changed, 18 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -600,4 +600,14 @@ int tick_broadcast_oneshot_active(void)
 	return tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT;
 }
 
+/*
+ * Check whether the broadcast device supports oneshot.
+ */
+bool tick_broadcast_oneshot_available(void)
+{
+	struct clock_event_device *bc = tick_broadcast_device.evtdev;
+
+	return bc ? bc->features & CLOCK_EVT_FEAT_ONESHOT : false;
+}
+
 #endif
Index: linux-2.6/kernel/time/tick-common.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-common.c
+++ linux-2.6/kernel/time/tick-common.c
@@ -51,7 +51,11 @@ int tick_is_oneshot_available(void)
 {
 	struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);
 
-	return dev && (dev->features & CLOCK_EVT_FEAT_ONESHOT);
+	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT))
+		return 0;
+	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
+		return 1;
+	return tick_broadcast_oneshot_available();
 }
 
 /*
Index: linux-2.6/kernel/time/tick-internal.h
===================================================================
--- linux-2.6.orig/kernel/time/tick-internal.h
+++ linux-2.6/kernel/time/tick-internal.h
@@ -36,6 +36,7 @@ extern void tick_shutdown_broadcast_ones
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_active(void);
 extern void tick_check_oneshot_broadcast(int cpu);
+bool tick_broadcast_oneshot_available(void);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
@@ -46,6 +47,7 @@ static inline void tick_broadcast_switch
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
 static inline void tick_check_oneshot_broadcast(int cpu) { }
+static inline bool tick_broadcast_oneshot_available(void) { return true; }
 # endif /* !BROADCAST */
 
 #else /* !ONESHOT */
@@ -76,6 +78,7 @@ static inline int tick_resume_broadcast_
 	return 0;
 }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
+static inline bool tick_broadcast_oneshot_available(void) { return true; }
 #endif /* !TICK_ONESHOT */
 
 /*

