Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0FBFcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:32:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46106 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab0FBFcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:32:52 -0400
Date: Wed, 2 Jun 2010 15:32:35 +1000
From: Neil Brown <neilb@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH] - race-free suspend.  Was: Re: [linux-pm] [PATCH 0/8]
 Suspend block api (version 8)
Message-ID: <20100602153235.340a7852@notabene.brown>
In-Reply-To: <alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
	<201006010005.19554.rjw@sisk.pl>
	<20100601090023.788cabf4@notabene.brown>
	<201006010232.20263.rjw@sisk.pl>
	<20100601113309.609349fd@notabene.brown>
	<alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
	<20100601122012.1edeaf48@notabene.brown>
	<alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 12:50:01 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 1 Jun 2010, Neil Brown wrote:
> > 
> > I think you have acknowledged that there is a race with suspend - thanks.
> > Next step was "can it be closed".
> > You seem to suggest that it can, but you describe it as a "work around"
> > rather than a "bug fix"...
> > 
> > Do you agree that the race is a "bug", and therefore it is appropriate to
> > "fix" it assuming an acceptable fix can be found (which I think it can)?
> 
> If we can fix it, yes we definitely should do and not work around it.
>  
> Thanks,
> 
> 	tglx

OK.
Here is my suggestion.

While I think this patch would actually work, and hope the ugly aspects are
reasonably balanced by the simplicity, I present it primarily as a base for
improvement.
The important part is to present how drivers and user-space can co-operate 
to avoid losing wake-events.  The details of what happens in the kernel are
certainly up for discussion (as is everything else really of course).

The user-space suspend daemon avoids losing wake-events by using
fcntl(F_OWNER) to ensure it gets a signal whenever any important wake-event
is ready to be read by user-space.  This may involve:
  - the one daemon processing all wake events
  - Both the suspend daemon and the main event handling daemon opening any
    given device that delivers wake events (this should work with input
    events ... unless grabbing is needed)
  - The event handling daemon giving the suspend-daemon's pid as F_OWNER, and
    using poll/select to get the events itself.

When 'mem' is written to /sys/power/state, suspend_prepare waits in an
interruptible wait until any wake-event that might have been initiated before
the suspend was request, has had a chance to be queued for user-space and
trigger kill_fasync.
Currently this wait is a configurable time after the last wake-event was
initiated.  This is hackish, but simple and probably adequate.
If more precise timing is needed and achievable, that can be added later.  It
would be an entirely internal change and would not affect the API further.
Some of the code developed for suspend-blockers might be a starting point for
this.

Drivers should call pm_suspend_delay() whenever a wake-event occurs.  This
simply records the time so that the suspend process knows if there is in fact
any need to wait at all.

The delay to wait after the last pm_suspend_delay() is limited to 10 seconds
and can be set by kernel parameter suspend_block_delay=number-of-milliseconds
It defaults to 2 jiffies (which is possibly too short).

- Would this fix the "bug"??
- and address the issues that suspend-blockers was created to address?
- or are the requirements on user-space too onerous?


Thanks,
NeilBrown

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 5e781d8..ccbadd0 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -142,11 +142,13 @@ extern void arch_suspend_disable_irqs(void);
 extern void arch_suspend_enable_irqs(void);
 
 extern int pm_suspend(suspend_state_t state);
+extern void pm_suspend_delay(void);
 #else /* !CONFIG_SUSPEND */
 #define suspend_valid_only_mem	NULL
 
 static inline void suspend_set_ops(struct platform_suspend_ops *ops) {}
 static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
+static inlint void pm_suspend_delay(void) {}
 #endif /* !CONFIG_SUSPEND */
 
 /* struct pbe is used for creating lists of pages that should be restored
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 56e7dbb..07897b9 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -46,6 +46,69 @@ bool valid_state(suspend_state_t state)
 	return suspend_ops && suspend_ops->valid && suspend_ops->valid(state);
 }
 
+/*
+ * Devices that process potential wake-up events report each
+ * wake-up events by pm_suspend_delay();
+ * This ensures that suspend won't happen for a "little while"
+ * so the event has a chance to get to user-space.
+ * pm_suspend calls wait_for_blockers to wait the required
+ * "little while" and to check for signals.
+ * A process that requests a suspend should arrange (via
+ * fcntl(F_GETOWN)) to get signalled whenever a wake-up event
+ * is queued for user-space.  This will ensure that if a suspend
+ * is requested at much the same time as a wakeup event arrives, either
+ * the suspend will be interrupted, or it will complete quickly.
+ *
+ * The "little while" is a heuristic to avoid having to explicitly
+ * track every event through the kernel with associated locking and unlocking.
+ * It should be more than the longest time it can take between an interrupt
+ * occurring and the corresponding event being queued to userspace
+ * (and the accompanying kill_fasync call).
+ * This duration is configurable at boot time, has a lower limit of 2
+ * jiffies and an upper limit of 10 seconds.  It defaults to the minimum.
+ */
+static unsigned long little_while_jiffies = 2;
+static int __init setup_suspend_block_delay(char *str)
+{
+	unsigned long msec;
+	if (sscanf(str, "%lu", &msec) != 1)
+		return 1;
+	if (msec > 10000)
+		msec = 10000;
+	little_while_jiffies = msecs_to_jiffies(msec);
+	if (little_while_jiffies < 2)
+		little_while_jiffies = 2;
+	return 1;
+}
+__setup("suspend_block_delay=", setup_suspend_block_delay);
+
+static unsigned long next_little_while;
+void pm_suspend_delay()
+{
+	unsigned long then = jiffies + little_while_jiffies;
+
+	if (then != next_little_while)
+		next_little_while = then;
+}
+EXPORT_SYMBOL_GPL(pm_suspend_delay);
+
+static int wait_for_blockers(void)
+{
+	unsigned long timeout;
+
+	if (time_after(jiffies, next_little_while))
+		return 0;
+	timeout = next_little_while - jiffies;
+	if (timeout > msecs_to_jiffies(10000))
+		/* jiffy wrap */
+		return 0;
+
+	while (timeout && !signal_pending(current))
+		timeout = schedule_timeout_interruptible(timeout);
+	if (signal_pending(current))
+		return -EINTR;
+	return 0;
+}
 /**
  * suspend_valid_only_mem - generic memory-only valid callback
  *
@@ -89,6 +152,10 @@ static int suspend_prepare(void)
 	if (error)
 		goto Finish;
 
+	error = wait_for_blockers();
+	if (error)
+		goto Finish;
+
 	error = usermodehelper_disable();
 	if (error)
 		goto Finish;

