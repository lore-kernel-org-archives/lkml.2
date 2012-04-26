Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab2DZVsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:48:08 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158Ab2DZVsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:48:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: [RFC][PATCH 6/8] PM / Sleep: Implement opportunistic sleep
Date: Thu, 26 Apr 2012 23:52:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201202070200.55505.rjw@sisk.pl> <201204222323.23685.rjw@sisk.pl> <20120426130503.7f55415d@notabene.brown>
In-Reply-To: <20120426130503.7f55415d@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204262352.43254.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 26, 2012, NeilBrown wrote:
> On Sun, 22 Apr 2012 23:23:23 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > From: "Rafael J. Wysocki" <rjw@sisk.pl>
> > To: Linux PM list <linux-pm@vger.kernel.org>
> > Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, Arve Hjønnevåg <arve@android.com>, John Stultz <john.stultz@linaro.org>, Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> > Subject: [RFC][PATCH 6/8] PM / Sleep: Implement opportunistic sleep
> > Date: Sun, 22 Apr 2012 23:23:23 +0200
> > Sender: linux-kernel-owner@vger.kernel.org
> > User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
> > 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Introduce a mechanism by which the kernel can trigger global
> > transitions to a sleep state chosen by user space if there are no
> > active wakeup sources.
> 
> Hi Rafael,

Hi,

>  just a few little issues below.  Over all I think that if we have to have
>  auto-sleep in the kernel, then this is a good way to do it.

Good, we seem to agree in principle, then. :-)

> > +static void try_to_suspend(struct work_struct *work)
> > +{
> > +	unsigned int initial_count, final_count;
> > +
> > +	if (!pm_get_wakeup_count(&initial_count, true))
> > +		goto out;
> > +
> > +	mutex_lock(&autosleep_lock);
> > +
> > +	if (!pm_save_wakeup_count(initial_count)) {
> > +		mutex_unlock(&autosleep_lock);
> > +		goto out;
> > +	}
> > +
> > +	if (autosleep_state == PM_SUSPEND_ON) {
> > +		mutex_unlock(&autosleep_lock);
> > +		return;
> > +	}
> > +	if (autosleep_state >= PM_SUSPEND_MAX)
> > +		hibernate();
> > +	else
> > +		pm_suspend(autosleep_state);
> > +
> > +	mutex_unlock(&autosleep_lock);
> > +
> > +	if (!pm_get_wakeup_count(&final_count, false))
> > +		goto out;
> > +
> > +	if (final_count == initial_count)
> > +		schedule_timeout(HZ / 2);
> 
> This doesn't do what you seem to expect it to do.
> You need to set current->state to something like TASK_UNINTERRUPTIBLE
> before calling schedule_timeout, otherwise it is effectily a no-op.
> schedule_timeout_uninterruptible(), for example, will do this for you.

Right.  I obviously overlooked the missing state change.

> However the value of this isn't clear to me, so a comment would probably be a
> good thing.
> This continue presumably fires if we wake up without any wakeup sources
> being activated.  In that case you want to delay for 500ms - presumably to
> avoid a tight suspend/resume loop if something goes wrong?

Yes.

> I have occasionally seen a stray/uninteresting interrupt wake from suspend
> immediately after entering suspend and the next attempt succeeds.  Maybe this
> is a bug in some driver somewhere, but not a big one.  I think I would rather
> in that case that we attempt to re-enter suspend immediately.  Maybe after a
> few failed attempts it makes sense to back off.

Perhaps.  We can adjust this particular thing later, I think.

> The other question is: if we want to back-off, is 500ms really enough?  What
> will be gained by, or could be achieved in, that time?  An exponential
> back-off might be defensible, but I can't see the value of a 500ms fixed
> back-off.
> However if you can, I'd love to see a comment in there explaining it.

Sure.

> > +
> > + out:
> > +	queue_up_suspend_work();
> > +}
> > +
> 
> 
> > +
> > +int pm_autosleep_set_state(suspend_state_t state)
> > +{
> > +
> > +#ifndef CONFIG_HIBERNATION
> > +	if (state >= PM_SUSPEND_MAX)
> > +		return -EINVAL;
> > +#endif
> > +
> > +	__pm_stay_awake(autosleep_ws);
> > +
> > +	mutex_lock(&autosleep_lock);
> > +
> > +	autosleep_state = state;
> > +
> > +	__pm_relax(autosleep_ws);
> 
> I'm struggling to see the point of the autosleep_ws.
> 
> A suspend cannot actually happen while this code is running (can it?) because
> it will wait for the process to enter the freezer.
> So the only effect of this is:
>   1/ cause the current auto-sleep cycle to abort and
>   2/ maybe add some accounting number is the autosleep_ws.
> Is that right?
> Which of these is needed?

This is to solve a problem when user space attempts to echo "off" to
/sys/power/autosleep exactly when pm_suspend() is initiated as a part
of autosleep under the autosleep lock.  In that case, if autosleep_ws is not
there, the process wanting to disable autosleep will have to wait for the
pm_suspend() to complete (unless it holds a wakelock), which is suboptimal.

> I would imagine that any process writing to /sys/power/autosleep would be
> holding a wakelock, and if it didn't it should expect things to be racy...
> 
> Am I missing something?

The assumption above is kind of optimistic in my opinion.  That process
very well may be a system administrator's bash, for example. :-)

> > +
> > +	if (state > PM_SUSPEND_ON)
> > +		queue_up_suspend_work();
> 
> The test here is superfluous as queue_up_suspend_work() itself tests that
> 'state' is > PM_SUSPEND_ON.  However maybe it is more readable this way, so I
> won't object it you like it.

Well, patch [7/8] adds the second statement under this conditional,
so I'd prefer to keep it the current way.

> > +
> > +	mutex_unlock(&autosleep_lock);
> > +	return 0;
> > +}
> 
> 
> > @@ -339,7 +359,8 @@ static ssize_t wakeup_count_show(struct
> >  {
> >  	unsigned int val;
> >  
> > -	return pm_get_wakeup_count(&val) ? sprintf(buf, "%u\n", val) : -EINTR;
> > +	return pm_get_wakeup_count(&val, true) ?
> > +		sprintf(buf, "%u\n", val) : -EINTR;
> >  }
> 
> I think it would be really nice for user-space auto-suspend if the 'block'
> flag to be settable from the O_NONBLOCK setting.  And for poll() to work
> on /sys/power/wakeup-count.  However this would require a bit of surgery on
> sysfs.  So that is a "maybe later", but having the 'block' flag in there is
> a step in the right direction.

Yes, "maybe later" is what I think about that too. :-)

> >  
> >  static ssize_t wakeup_count_store(struct kobject *kobj,
> > @@ -347,15 +368,69 @@ static ssize_t wakeup_count_store(struct
> >  				const char *buf, size_t n)
> >  {
> >  	unsigned int val;
> > +	int error;
> > +
> > +	error = pm_autosleep_lock();
> > +	if (error)
> > +		return error;
> > +
> > +	if (pm_autosleep_state() > PM_SUSPEND_ON) {
> > +		error = -EBUSY;
> > +		goto out;
> > +	}
> >  
> >  	if (sscanf(buf, "%u", &val) == 1) {
> >  		if (pm_save_wakeup_count(val))
> >  			return n;
> 
> You need a 'pm_autosleep_unlock() in there - or possibly
>   error = n; goto out;

Right, thanks for spotting this!

> >  	}
> > -	return -EINVAL;
> > +	error = -EINVAL;
> > +
> > + out:
> > +	pm_autosleep_unlock();
> > +	return error;
> >  }
> 
> >  core_initcall(pm_init);
> > Index: linux/drivers/base/power/wakeup.c
> > ===================================================================
> > --- linux.orig/drivers/base/power/wakeup.c
> > +++ linux/drivers/base/power/wakeup.c
> > @@ -498,8 +498,10 @@ static void wakeup_source_deactivate(str
> >  	trace_wakeup_source_deactivate(ws->name, cec);
> >  
> >  	split_counters(&cnt, &inpr);
> > -	if (!inpr && waitqueue_active(&wakeup_count_wait_queue))
> > +	if (!inpr && waitqueue_active(&wakeup_count_wait_queue)) {
> >  		wake_up(&wakeup_count_wait_queue);
> > +		queue_up_suspend_work();
> > +	}
> 
> This doesn't look right.  suspend_work always requeues itself unless
> autosleep_state == PM_SUSPEND_ON, and whenver autosleep_state is set we
> already call queue_up_suspend_work().  So there is no need to call it here.

OK, I agree.  Good, I don't have to add more code to wakeup_source_deactivate(). :-)

> > Index: linux/Documentation/ABI/testing/sysfs-power
> > ===================================================================
> > --- linux.orig/Documentation/ABI/testing/sysfs-power
> > +++ linux/Documentation/ABI/testing/sysfs-power
> > @@ -172,3 +172,20 @@ Description:
> >  
> >  		Reading from this file will display the current value, which is
> >  		set to 1 MB by default.
> > +
> > +What:		/sys/power/autosleep
> > +Date:		February 2012
> > +Contact:	Rafael J. Wysocki <rjw@sisk.pl>
> > +Description:
> > +		The /sys/power/autosleep file can be written one of the strings
> 
> "To the .. file can be written..." or
> "The .. file can have written ..." or
> "One of the strings returned by (reads from) /sys/power/state can be written
> to the file ..."
> ??
> > +		returned by reads from /sys/power/state.  If that happens, a
> > +		work item attempting to trigger a transition of the system to
> > +		the sleep state represented by that string is queued up.  This
> > +		attempt will only succeed if there are no active wakeup sources
> > +		in the system at that time.  After evey execution, regardless
>                                                    ^^^^
>   "every"
> 
> > +		of whether or not the attempt to put the system to sleep has
> > +		succeeded, the work item requeues itself until user space
> > +		writes "off" to /sys/power/autosleep.
> > +
> > +		Reading from this file causes the last string successfully
> > +		written to it to be displayed.
>                                     ^^^^^^^^^  "returned".

Well spotted, thanks!

Below is an updated patch hopefully addressing your comments.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Sleep: Implement opportunistic sleep, v2

Introduce a mechanism by which the kernel can trigger global
transitions to a sleep state chosen by user space if there are no
active wakeup sources.

It consists of a new sysfs attribute, /sys/power/autosleep, that
can be written one of the strings returned by reads from
/sys/power/state, an ordered workqueue and a work item carrying out
the "suspend" operations.  If a string representing the system's
sleep state is written to /sys/power/autosleep, the work item
triggering transitions to that state is queued up and it requeues
itself after every execution until user space writes "off" to
/sys/power/autosleep.

That work item enables the detection of wakeup events using the
functions already defined in drivers/base/power/wakeup.c (with one
small modification) and calls either pm_suspend(), or hibernate() to
put the system into a sleep state.  If a wakeup event is reported
while the transition is in progress, it will abort the transition and
the "system suspend" work item will be queued up again.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-power |   17 ++++
 drivers/base/power/wakeup.c           |   34 +++++----
 include/linux/suspend.h               |   13 +++
 kernel/power/Kconfig                  |    8 ++
 kernel/power/Makefile                 |    1 
 kernel/power/autosleep.c              |  117 +++++++++++++++++++++++++++++++++
 kernel/power/main.c                   |  119 ++++++++++++++++++++++++++++------
 kernel/power/power.h                  |   18 +++++
 8 files changed, 292 insertions(+), 35 deletions(-)

Index: linux/kernel/power/Makefile
===================================================================
--- linux.orig/kernel/power/Makefile
+++ linux/kernel/power/Makefile
@@ -9,5 +9,6 @@ obj-$(CONFIG_SUSPEND)		+= suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
 				   block_io.o
+obj-$(CONFIG_PM_AUTOSLEEP)	+= autosleep.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
Index: linux/kernel/power/Kconfig
===================================================================
--- linux.orig/kernel/power/Kconfig
+++ linux/kernel/power/Kconfig
@@ -103,6 +103,14 @@ config PM_SLEEP_SMP
 	select HOTPLUG
 	select HOTPLUG_CPU
 
+config PM_AUTOSLEEP
+	bool "Opportunistic sleep"
+	depends on PM_SLEEP
+	default n
+	---help---
+	Allow the kernel to trigger a system transition into a global sleep
+	state automatically whenever there are no active wakeup sources.
+
 config PM_RUNTIME
 	bool "Run-time PM core functionality"
 	depends on !IA64_HP_SIM
Index: linux/kernel/power/power.h
===================================================================
--- linux.orig/kernel/power/power.h
+++ linux/kernel/power/power.h
@@ -264,3 +264,21 @@ static inline void suspend_thaw_processe
 {
 }
 #endif
+
+#ifdef CONFIG_PM_AUTOSLEEP
+
+/* kernel/power/autosleep.c */
+extern int pm_autosleep_init(void);
+extern int pm_autosleep_lock(void);
+extern void pm_autosleep_unlock(void);
+extern suspend_state_t pm_autosleep_state(void);
+extern int pm_autosleep_set_state(suspend_state_t state);
+
+#else /* !CONFIG_PM_AUTOSLEEP */
+
+static inline int pm_autosleep_init(void) { return 0; }
+static inline int pm_autosleep_lock(void) { return 0; }
+static inline void pm_autosleep_unlock(void) {}
+static inline suspend_state_t pm_autosleep_state(void) { return PM_SUSPEND_ON; }
+
+#endif /* !CONFIG_PM_AUTOSLEEP */
Index: linux/include/linux/suspend.h
===================================================================
--- linux.orig/include/linux/suspend.h
+++ linux/include/linux/suspend.h
@@ -356,7 +356,7 @@ extern int unregister_pm_notifier(struct
 extern bool events_check_enabled;
 
 extern bool pm_wakeup_pending(void);
-extern bool pm_get_wakeup_count(unsigned int *count);
+extern bool pm_get_wakeup_count(unsigned int *count, bool block);
 extern bool pm_save_wakeup_count(unsigned int count);
 
 static inline void lock_system_sleep(void)
@@ -407,6 +407,17 @@ static inline void unlock_system_sleep(v
 
 #endif /* !CONFIG_PM_SLEEP */
 
+#ifdef CONFIG_PM_AUTOSLEEP
+
+/* kernel/power/autosleep.c */
+void queue_up_suspend_work(void);
+
+#else /* !CONFIG_PM_AUTOSLEEP */
+
+static inline void queue_up_suspend_work(void) {}
+
+#endif /* !CONFIG_PM_AUTOSLEEP */
+
 #ifdef CONFIG_ARCH_SAVE_PAGE_KEYS
 /*
  * The ARCH_SAVE_PAGE_KEYS functions can be used by an architecture
Index: linux/kernel/power/autosleep.c
===================================================================
--- /dev/null
+++ linux/kernel/power/autosleep.c
@@ -0,0 +1,117 @@
+/*
+ * kernel/power/autosleep.c
+ *
+ * Opportunistic sleep support.
+ *
+ * Copyright (C) 2012 Rafael J. Wysocki <rjw@sisk.pl>
+ */
+
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/pm_wakeup.h>
+
+#include "power.h"
+
+static suspend_state_t autosleep_state;
+static struct workqueue_struct *autosleep_wq;
+static DEFINE_MUTEX(autosleep_lock);
+static struct wakeup_source *autosleep_ws;
+
+static void try_to_suspend(struct work_struct *work)
+{
+	unsigned int initial_count, final_count;
+
+	if (!pm_get_wakeup_count(&initial_count, true))
+		goto out;
+
+	mutex_lock(&autosleep_lock);
+
+	if (!pm_save_wakeup_count(initial_count)) {
+		mutex_unlock(&autosleep_lock);
+		goto out;
+	}
+
+	if (autosleep_state == PM_SUSPEND_ON) {
+		mutex_unlock(&autosleep_lock);
+		return;
+	}
+	if (autosleep_state >= PM_SUSPEND_MAX)
+		hibernate();
+	else
+		pm_suspend(autosleep_state);
+
+	mutex_unlock(&autosleep_lock);
+
+	if (!pm_get_wakeup_count(&final_count, false))
+		goto out;
+
+	/*
+	 * If the wakeup occured for an unknown reason, wait to prevent the
+	 * system from trying to suspend and waking up in a tight loop.
+	 */
+	if (final_count == initial_count)
+		schedule_timeout_uninterruptible(HZ / 2);
+
+ out:
+	queue_up_suspend_work();
+}
+
+static DECLARE_WORK(suspend_work, try_to_suspend);
+
+void queue_up_suspend_work(void)
+{
+	if (!work_pending(&suspend_work) && autosleep_state > PM_SUSPEND_ON)
+		queue_work(autosleep_wq, &suspend_work);
+}
+
+suspend_state_t pm_autosleep_state(void)
+{
+	return autosleep_state;
+}
+
+int pm_autosleep_lock(void)
+{
+	return mutex_lock_interruptible(&autosleep_lock);
+}
+
+void pm_autosleep_unlock(void)
+{
+	mutex_unlock(&autosleep_lock);
+}
+
+int pm_autosleep_set_state(suspend_state_t state)
+{
+
+#ifndef CONFIG_HIBERNATION
+	if (state >= PM_SUSPEND_MAX)
+		return -EINVAL;
+#endif
+
+	__pm_stay_awake(autosleep_ws);
+
+	mutex_lock(&autosleep_lock);
+
+	autosleep_state = state;
+
+	__pm_relax(autosleep_ws);
+
+	if (state > PM_SUSPEND_ON)
+		queue_up_suspend_work();
+
+	mutex_unlock(&autosleep_lock);
+	return 0;
+}
+
+int __init pm_autosleep_init(void)
+{
+	autosleep_ws = wakeup_source_register("autosleep");
+	if (!autosleep_ws)
+		return -ENOMEM;
+
+	autosleep_wq = alloc_ordered_workqueue("autosleep", 0);
+	if (autosleep_wq)
+		return 0;
+
+	wakeup_source_unregister(autosleep_ws);
+	return -ENOMEM;
+}
Index: linux/kernel/power/main.c
===================================================================
--- linux.orig/kernel/power/main.c
+++ linux/kernel/power/main.c
@@ -269,8 +269,7 @@ static ssize_t state_show(struct kobject
 	return (s - buf);
 }
 
-static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
-			   const char *buf, size_t n)
+static suspend_state_t decode_state(const char *buf, size_t n)
 {
 #ifdef CONFIG_SUSPEND
 	suspend_state_t state = PM_SUSPEND_STANDBY;
@@ -278,27 +277,48 @@ static ssize_t state_store(struct kobjec
 #endif
 	char *p;
 	int len;
-	int error = -EINVAL;
 
 	p = memchr(buf, '\n', n);
 	len = p ? p - buf : n;
 
-	/* First, check if we are requested to hibernate */
-	if (len == 4 && !strncmp(buf, "disk", len)) {
-		error = hibernate();
-		goto Exit;
-	}
+	/* Check hibernation first. */
+	if (len == 4 && !strncmp(buf, "disk", len))
+		return PM_SUSPEND_MAX;
 
 #ifdef CONFIG_SUSPEND
-	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
-		if (*s && len == strlen(*s) && !strncmp(buf, *s, len)) {
-			error = pm_suspend(state);
-			break;
-		}
-	}
+	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++)
+		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
+			return state;
 #endif
 
- Exit:
+	return PM_SUSPEND_ON;
+}
+
+static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
+			   const char *buf, size_t n)
+{
+	suspend_state_t state;
+	int error;
+
+	error = pm_autosleep_lock();
+	if (error)
+		return error;
+
+	if (pm_autosleep_state() > PM_SUSPEND_ON) {
+		error = -EBUSY;
+		goto out;
+	}
+
+	state = decode_state(buf, n);
+	if (state < PM_SUSPEND_MAX)
+		error = pm_suspend(state);
+	else if (state == PM_SUSPEND_MAX)
+		error = hibernate();
+	else
+		error = -EINVAL;
+
+ out:
+	pm_autosleep_unlock();
 	return error ? error : n;
 }
 
@@ -339,7 +359,8 @@ static ssize_t wakeup_count_show(struct
 {
 	unsigned int val;
 
-	return pm_get_wakeup_count(&val) ? sprintf(buf, "%u\n", val) : -EINTR;
+	return pm_get_wakeup_count(&val, true) ?
+		sprintf(buf, "%u\n", val) : -EINTR;
 }
 
 static ssize_t wakeup_count_store(struct kobject *kobj,
@@ -347,15 +368,69 @@ static ssize_t wakeup_count_store(struct
 				const char *buf, size_t n)
 {
 	unsigned int val;
+	int error;
+
+	error = pm_autosleep_lock();
+	if (error)
+		return error;
+
+	if (pm_autosleep_state() > PM_SUSPEND_ON) {
+		error = -EBUSY;
+		goto out;
+	}
 
+	error = -EINVAL;
 	if (sscanf(buf, "%u", &val) == 1) {
 		if (pm_save_wakeup_count(val))
-			return n;
+			error = n;
 	}
-	return -EINVAL;
+
+ out:
+	pm_autosleep_unlock();
+	return error;
 }
 
 power_attr(wakeup_count);
+
+#ifdef CONFIG_PM_AUTOSLEEP
+static ssize_t autosleep_show(struct kobject *kobj,
+			      struct kobj_attribute *attr,
+			      char *buf)
+{
+	suspend_state_t state = pm_autosleep_state();
+
+	if (state == PM_SUSPEND_ON)
+		return sprintf(buf, "off\n");
+
+#ifdef CONFIG_SUSPEND
+	if (state < PM_SUSPEND_MAX)
+		return sprintf(buf, "%s\n", valid_state(state) ?
+						pm_states[state] : "error");
+#endif
+#ifdef CONFIG_HIBERNATION
+	return sprintf(buf, "disk\n");
+#else
+	return sprintf(buf, "error");
+#endif
+}
+
+static ssize_t autosleep_store(struct kobject *kobj,
+			       struct kobj_attribute *attr,
+			       const char *buf, size_t n)
+{
+	suspend_state_t state = decode_state(buf, n);
+	int error;
+
+	if (state == PM_SUSPEND_ON
+	    && !(strncmp(buf, "off", 3) && strncmp(buf, "off\n", 4)))
+		return -EINVAL;
+
+	error = pm_autosleep_set_state(state);
+	return error ? error : n;
+}
+
+power_attr(autosleep);
+#endif /* CONFIG_PM_AUTOSLEEP */
 #endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PM_TRACE
@@ -409,6 +484,9 @@ static struct attribute * g[] = {
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
 	&wakeup_count_attr.attr,
+#ifdef CONFIG_PM_AUTOSLEEP
+	&autosleep_attr.attr,
+#endif
 #ifdef CONFIG_PM_DEBUG
 	&pm_test_attr.attr,
 #endif
@@ -444,7 +522,10 @@ static int __init pm_init(void)
 	power_kobj = kobject_create_and_add("power", NULL);
 	if (!power_kobj)
 		return -ENOMEM;
-	return sysfs_create_group(power_kobj, &attr_group);
+	error = sysfs_create_group(power_kobj, &attr_group);
+	if (error)
+		return error;
+	return pm_autosleep_init();
 }
 
 core_initcall(pm_init);
Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -660,29 +660,33 @@ bool pm_wakeup_pending(void)
 /**
  * pm_get_wakeup_count - Read the number of registered wakeup events.
  * @count: Address to store the value at.
+ * @block: Whether or not to block.
  *
- * Store the number of registered wakeup events at the address in @count.  Block
- * if the current number of wakeup events being processed is nonzero.
+ * Store the number of registered wakeup events at the address in @count.  If
+ * @block is set, block until the current number of wakeup events being
+ * processed is zero.
  *
- * Return 'false' if the wait for the number of wakeup events being processed to
- * drop down to zero has been interrupted by a signal (and the current number
- * of wakeup events being processed is still nonzero).  Otherwise return 'true'.
+ * Return 'false' if the current number of wakeup events being processed is
+ * nonzero.  Otherwise return 'true'.
  */
-bool pm_get_wakeup_count(unsigned int *count)
+bool pm_get_wakeup_count(unsigned int *count, bool block)
 {
 	unsigned int cnt, inpr;
-	DEFINE_WAIT(wait);
 
-	for (;;) {
-		prepare_to_wait(&wakeup_count_wait_queue, &wait,
-				TASK_INTERRUPTIBLE);
-		split_counters(&cnt, &inpr);
-		if (inpr == 0 || signal_pending(current))
-			break;
+	if (block) {
+		DEFINE_WAIT(wait);
 
-		schedule();
+		for (;;) {
+			prepare_to_wait(&wakeup_count_wait_queue, &wait,
+					TASK_INTERRUPTIBLE);
+			split_counters(&cnt, &inpr);
+			if (inpr == 0 || signal_pending(current))
+				break;
+
+			schedule();
+		}
+		finish_wait(&wakeup_count_wait_queue, &wait);
 	}
-	finish_wait(&wakeup_count_wait_queue, &wait);
 
 	split_counters(&cnt, &inpr);
 	*count = cnt;
Index: linux/Documentation/ABI/testing/sysfs-power
===================================================================
--- linux.orig/Documentation/ABI/testing/sysfs-power
+++ linux/Documentation/ABI/testing/sysfs-power
@@ -172,3 +172,20 @@ Description:
 
 		Reading from this file will display the current value, which is
 		set to 1 MB by default.
+
+What:		/sys/power/autosleep
+Date:		April 2012
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/power/autosleep file can be written one of the strings
+		returned by reads from /sys/power/state.  If that happens, a
+		work item attempting to trigger a transition of the system to
+		the sleep state represented by that string is queued up.  This
+		attempt will only succeed if there are no active wakeup sources
+		in the system at that time.  After every execution, regardless
+		of whether or not the attempt to put the system to sleep has
+		succeeded, the work item requeues itself until user space
+		writes "off" to /sys/power/autosleep.
+
+		Reading from this file causes the last string successfully
+		written to it to be returned.
