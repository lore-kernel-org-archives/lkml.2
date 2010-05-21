Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab0EUWrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:47:18 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51876 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab0EUWrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:47:14 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: [PATCH 1/8] PM: Opportunistic suspend support.
Date: Fri, 21 May 2010 15:46:48 -0700
Message-Id: <1274482015-30899-2-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1274482015-30899-1-git-send-email-arve@android.com>
References: <1274482015-30899-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Power management features present in the current mainline kernel are
insufficient to get maximum possible energy savings on some platforms,
such as Android.  The problem is that to save maximum amount of energy
all system hardware components need to be in the lowest-power states
available for as long as reasonably possible, but at the same time the
system must always respond to certain events, regardless of the
current state of the hardware.

The first goal can be achieved either by using device runtime PM and
cpuidle to put all hardware into low-power states, transparently from
the user space point of view, or by suspending the whole system.
However, system suspend, in its current form, does not guarantee that
the events of interest will always be responded to, since wakeup
events (events that wake the CPU from idle and the system from
suspend) that occur right after initiating suspend will not be
processed until another possibly unrelated event wakes the system up
again.

On hardware where idle can enter the same power state as suspend, idle
combined with runtime PM can be used, but periodic wakeups increase
the average power consumption. Suspending the system also reduces the
harm caused by apps that never go idle. There also are systems where
some devices cannot be put into low-power states without suspending
the entire system (or the low-power states available to them without
suspending the entire system are substantially shallower than the
low-power states they are put into when the entire system is
suspended), so the system has to be suspended as a whole to achieve
the maximum energy savings.

To allow Android and similar platforms to save more energy than they
currently can save using the mainline kernel, introduce a mechanism by
which the system is automatically suspended (i.e. put into a
system-wide sleep state) whenever it's not doing work that's
immediately useful to the user, called opportunistic suspend.

For this purpose introduce the suspend blockers framework allowing the
kernel's power management subsystem to decide when it is desirable to
suspend the system (i.e. when the system is not doing anything the
user really cares about at the moment and therefore it may be
suspended). Add an API that that drivers can use to block
opportunistic suspend. This is needed to avoid losing wakeup events
that occur right after suspend is initiated.

Add /sys/power/policy that selects the behavior of /sys/power/state.
After setting the policy to opportunistic, writes to /sys/power/state
become non-blocking requests that specify which suspend state to enter
when no suspend blockers are active. A special state, "on", stops the
process by activating the "main" suspend blocker.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 Documentation/power/opportunistic-suspend.txt |  129 +++++++++++
 include/linux/suspend.h                       |    1 +
 include/linux/suspend_blocker.h               |   74 ++++++
 kernel/power/Kconfig                          |   16 ++
 kernel/power/Makefile                         |    1 +
 kernel/power/main.c                           |  128 ++++++++++-
 kernel/power/opportunistic_suspend.c          |  298 +++++++++++++++++++++++++
 kernel/power/power.h                          |    9 +
 kernel/power/suspend.c                        |    3 +-
 9 files changed, 651 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/power/opportunistic-suspend.txt
 create mode 100755 include/linux/suspend_blocker.h
 create mode 100644 kernel/power/opportunistic_suspend.c

diff --git a/Documentation/power/opportunistic-suspend.txt b/Documentation/power/opportunistic-suspend.txt
new file mode 100644
index 0000000..4bee7bc
--- /dev/null
+++ b/Documentation/power/opportunistic-suspend.txt
@@ -0,0 +1,129 @@
+Opportunistic Suspend
+=====================
+
+Opportunistic suspend is a feature allowing the system to be suspended (ie. put
+into one of the available sleep states) automatically whenever it is regarded
+as idle.  The suspend blockers framework described below is used to determine
+when that happens.
+
+The /sys/power/policy sysfs attribute is used to switch the system between the
+opportunistic and "forced" suspend behavior, where in the latter case the
+system is only suspended if a specific value, corresponding to one of the
+available system sleep states, is written into /sys/power/state.  However, in
+the former, opportunistic, case the system is put into the sleep state
+corresponding to the value written to /sys/power/state whenever there are no
+active suspend blockers. The default policy is "forced". Also, suspend blockers
+do not affect sleep states entered from idle.
+
+When the policy is "opportunisic", there is a special value, "on", that can be
+written to /sys/power/state. This will block the automatic sleep request, as if
+a suspend blocker was used by a device driver. This way the opportunistic
+suspend may be blocked by user space whithout switching back to the "forced"
+mode.
+
+A suspend blocker is an object used to inform the PM subsystem when the system
+can or cannot be suspended in the "opportunistic" mode (the "forced" mode
+ignores suspend blockers).  To use it, a device driver creates a struct
+suspend_blocker that must be initialized with suspend_blocker_init(). Before
+freeing the suspend_blocker structure or its name, suspend_blocker_unregister()
+must be called on it.
+
+A suspend blocker is activated using suspend_block(), which prevents the PM
+subsystem from putting the system into the requested sleep state in the
+"opportunistic" mode until the suspend blocker is deactivated with
+suspend_unblock(). Multiple suspend blockers may be active simultaneously, and
+the system will not suspend as long as at least one of them is active.
+
+If opportunistic suspend is already in progress when suspend_block() is called,
+it will abort the suspend, unless suspend_ops->enter has already been
+executed. If suspend is aborted this way, the system is usually not fully
+operational at that point. The suspend callbacks of some drivers may still be
+running and it usually takes time to restore the system to the fully operational
+state.
+
+Here's an example showing how a cell phone or other embedded system can handle
+keystrokes (or other input events) in the presence of suspend blockers. Use
+set_irq_wake or a platform specific API to make sure the keypad interrupt wakes
+up the cpu. Once the keypad driver has resumed, the sequence of events can look
+like this:
+
+- The Keypad driver gets an interrupt. It then calls suspend_block on the
+  keypad-scan suspend_blocker and starts scanning the keypad matrix.
+- The keypad-scan code detects a key change and reports it to the input-event
+  driver.
+- The input-event driver sees the key change, enqueues an event, and calls
+  suspend_block on the input-event-queue suspend_blocker.
+- The keypad-scan code detects that no keys are held and calls suspend_unblock
+  on the keypad-scan suspend_blocker.
+- The user-space input-event thread returns from select/poll, calls
+  suspend_block on the process-input-events suspend_blocker and then calls read
+  on the input-event device.
+- The input-event driver dequeues the key-event and, since the queue is now
+  empty, it calls suspend_unblock on the input-event-queue suspend_blocker.
+- The user-space input-event thread returns from read. If it determines that
+  the key should be ignored, it calls suspend_unblock on the
+  process_input_events suspend_blocker and then calls select or poll. The
+  system will automatically suspend again, since now no suspend blockers are
+  active.
+
+If the key that was pressed instead should preform a simple action (for example,
+adjusting the volume), this action can be performed right before calling
+suspend_unblock on the process_input_events suspend_blocker. However, if the key
+triggers a longer-running action, that action needs its own suspend_blocker and
+suspend_block must be called on that suspend blocker before calling
+suspend_unblock on the process_input_events suspend_blocker.
+
+                 Key pressed   Key released
+                     |             |
+keypad-scan          ++++++++++++++++++
+input-event-queue        +++          +++
+process-input-events       +++          +++
+
+
+Driver API
+==========
+
+A driver can use the suspend block API by adding a suspend_blocker variable to
+its state and calling suspend_blocker_init(). For instance:
+
+struct state {
+	struct suspend_blocker suspend_blocker;
+}
+
+init() {
+	suspend_blocker_init(&state->suspend_blocker, name);
+}
+
+If the suspend_blocker variable is allocated statically,
+DEFINE_SUSPEND_BLOCKER() should be used to initialize it, for example:
+
+static DEFINE_SUSPEND_BLOCKER(blocker, name);
+
+and suspend_blocker_register(&blocker) has to be called to make the suspend
+blocker usable.
+
+Before freeing the memory in which a suspend_blocker variable is located,
+suspend_blocker_unregister() must be called, for instance:
+
+uninit() {
+	suspend_blocker_unregister(&state->suspend_blocker);
+}
+
+When the driver determines that it needs to run (usually in an interrupt
+handler) it calls suspend_block():
+
+	suspend_block(&state->suspend_blocker);
+
+When it no longer needs to run it calls suspend_unblock():
+
+	suspend_unblock(&state->suspend_blocker);
+
+Calling suspend_block() when the suspend blocker is active or suspend_unblock()
+when it is not active has no effect (i.e., these functions don't nest). This
+allows drivers to update their state and call suspend suspend_block() or
+suspend_unblock() based on the result. For instance:
+
+if (list_empty(&state->pending_work))
+	suspend_unblock(&state->suspend_blocker);
+else
+	suspend_block(&state->suspend_blocker);
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 5e781d8..07023d3 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/pm.h>
 #include <linux/mm.h>
+#include <linux/suspend_blocker.h>
 #include <asm/errno.h>
 
 #if defined(CONFIG_PM_SLEEP) && defined(CONFIG_VT) && defined(CONFIG_VT_CONSOLE)
diff --git a/include/linux/suspend_blocker.h b/include/linux/suspend_blocker.h
new file mode 100755
index 0000000..8788302
--- /dev/null
+++ b/include/linux/suspend_blocker.h
@@ -0,0 +1,74 @@
+/* include/linux/suspend_blocker.h
+ *
+ * Copyright (C) 2007-2010 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_SUSPEND_BLOCKER_H
+#define _LINUX_SUSPEND_BLOCKER_H
+
+#include <linux/list.h>
+
+/**
+ * struct suspend_blocker - the basic suspend_blocker structure
+ * @link: List entry for active or inactive list.
+ * @flags: Tracks initialized and active state.
+ * @name: Suspend blocker name used for debugging.
+ *
+ * When a suspend_blocker is active it prevents the system from entering
+ * opportunistic suspend.
+ *
+ * The suspend_blocker structure must be initialized by suspend_blocker_init()
+ */
+struct suspend_blocker {
+#ifdef CONFIG_OPPORTUNISTIC_SUSPEND
+	struct list_head link;
+	int flags;
+	const char *name;
+#endif
+};
+
+#ifdef CONFIG_OPPORTUNISTIC_SUSPEND
+#define __SUSPEND_BLOCKER_INITIALIZER(blocker_name) \
+	{ .name = #blocker_name, }
+
+#define DEFINE_SUSPEND_BLOCKER(blocker, name) \
+	struct suspend_blocker blocker = __SUSPEND_BLOCKER_INITIALIZER(name)
+
+extern void suspend_blocker_register(struct suspend_blocker *blocker);
+extern void suspend_blocker_init(struct suspend_blocker *blocker,
+				 const char *name);
+extern void suspend_blocker_unregister(struct suspend_blocker *blocker);
+extern void suspend_block(struct suspend_blocker *blocker);
+extern void suspend_unblock(struct suspend_blocker *blocker);
+extern bool suspend_blocker_is_active(struct suspend_blocker *blocker);
+extern bool suspend_is_blocked(void);
+
+#else
+
+#define DEFINE_SUSPEND_BLOCKER(blocker, name) \
+	struct suspend_blocker blocker
+
+static inline void suspend_blocker_register(struct suspend_blocker *bl) {}
+static inline void suspend_blocker_init(struct suspend_blocker *bl,
+					const char *n) {}
+static inline void suspend_blocker_unregister(struct suspend_blocker *bl) {}
+static inline void suspend_block(struct suspend_blocker *bl) {}
+static inline void suspend_unblock(struct suspend_blocker *bl) {}
+static inline bool suspend_blocker_is_active(struct suspend_blocker *bl)
+{
+	return false;
+}
+static inline bool suspend_is_blocked(void) { return false; }
+#endif
+
+#endif
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 5c36ea9..6d11a45 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -130,6 +130,22 @@ config SUSPEND_FREEZER
 
 	  Turning OFF this setting is NOT recommended! If in doubt, say Y.
 
+config OPPORTUNISTIC_SUSPEND
+	bool "Opportunistic suspend"
+	depends on SUSPEND
+	select RTC_LIB
+	default n
+	---help---
+	  Opportunistic sleep support.  Allows the system to be put into a sleep
+	  state opportunistically, if it doesn't do any useful work at the
+	  moment. The PM subsystem is switched into this mode of operation by
+	  writing "opportunistic" into /sys/power/policy, while writing
+	  "forced" to this file turns the opportunistic suspend feature off.
+	  In the "opportunistic" mode suspend blockers are used to determine
+	  when to suspend the system and the value written to /sys/power/state
+	  determines the sleep state the system will be put into when there are
+	  no active suspend blockers.
+
 config HIBERNATION_NVS
 	bool
 
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 4319181..95d8e6d 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_PM_SLEEP)		+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
+obj-$(CONFIG_OPPORTUNISTIC_SUSPEND)	+= opportunistic_suspend.o
 obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o
 obj-$(CONFIG_HIBERNATION_NVS)	+= hibernate_nvs.o
diff --git a/kernel/power/main.c b/kernel/power/main.c
index b58800b..afbb4dd 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -20,6 +20,58 @@ DEFINE_MUTEX(pm_mutex);
 unsigned int pm_flags;
 EXPORT_SYMBOL(pm_flags);
 
+#ifdef CONFIG_OPPORTUNISTIC_SUSPEND
+struct pm_policy {
+	const char *name;
+	bool (*valid_state)(suspend_state_t state);
+	int (*set_state)(suspend_state_t state);
+};
+
+static struct pm_policy policies[] = {
+	{
+		.name		= "forced",
+		.valid_state	= valid_state,
+		.set_state	= enter_state,
+	},
+	{
+		.name		= "opportunistic",
+		.valid_state	= opportunistic_suspend_valid_state,
+		.set_state	= opportunistic_suspend_state,
+	},
+};
+
+static int policy;
+
+static inline bool hibernation_supported(void)
+{
+	return !strncmp(policies[policy].name, "forced", 6);
+}
+
+static inline bool pm_state_valid(int state_idx)
+{
+	return pm_states[state_idx] && policies[policy].valid_state(state_idx);
+}
+
+static inline int pm_enter_state(int state_idx)
+{
+	return policies[policy].set_state(state_idx);
+}
+
+#else
+
+static inline bool hibernation_supported(void) { return true; }
+
+static inline bool pm_state_valid(int state_idx)
+{
+	return pm_states[state_idx] && valid_state(state_idx);
+}
+
+static inline int pm_enter_state(int state_idx)
+{
+	return enter_state(state_idx);
+}
+#endif /* CONFIG_OPPORTUNISTIC_SUSPEND */
+
 #ifdef CONFIG_PM_SLEEP
 
 /* Routines for PM-transition notifications */
@@ -146,6 +198,12 @@ struct kobject *power_kobj;
  *
  *	store() accepts one of those strings, translates it into the 
  *	proper enumerated value, and initiates a suspend transition.
+ *
+ *	If policy is set to opportunistic, store() does not block until the
+ *	system resumes, and it will try to re-enter the state until another
+ *	state is requested. Suspend blockers are respected and the requested
+ *	state will only be entered when no suspend blockers are active.
+ *	Write "on" to disable.
  */
 static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 			  char *buf)
@@ -155,12 +213,13 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 	int i;
 
 	for (i = 0; i < PM_SUSPEND_MAX; i++) {
-		if (pm_states[i] && valid_state(i))
+		if (pm_state_valid(i))
 			s += sprintf(s,"%s ", pm_states[i]);
 	}
 #endif
 #ifdef CONFIG_HIBERNATION
-	s += sprintf(s, "%s\n", "disk");
+	if (hibernation_supported())
+		s += sprintf(s, "%s\n", "disk");
 #else
 	if (s != buf)
 		/* convert the last space to a newline */
@@ -173,7 +232,7 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 			   const char *buf, size_t n)
 {
 #ifdef CONFIG_SUSPEND
-	suspend_state_t state = PM_SUSPEND_STANDBY;
+	suspend_state_t state = PM_SUSPEND_ON;
 	const char * const *s;
 #endif
 	char *p;
@@ -185,8 +244,9 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 
 	/* First, check if we are requested to hibernate */
 	if (len == 4 && !strncmp(buf, "disk", len)) {
-		error = hibernate();
-  goto Exit;
+		if (hibernation_supported())
+			error = hibernate();
+		goto Exit;
 	}
 
 #ifdef CONFIG_SUSPEND
@@ -195,7 +255,7 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 			break;
 	}
 	if (state < PM_SUSPEND_MAX && *s)
-		error = enter_state(state);
+		error = pm_enter_state(state);
 #endif
 
  Exit:
@@ -204,6 +264,56 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 
 power_attr(state);
 
+#ifdef CONFIG_OPPORTUNISTIC_SUSPEND
+/**
+ *	policy - set policy for state
+ */
+static ssize_t policy_show(struct kobject *kobj,
+			   struct kobj_attribute *attr, char *buf)
+{
+	char *s = buf;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(policies); i++) {
+		if (i == policy)
+			s += sprintf(s, "[%s] ", policies[i].name);
+		else
+			s += sprintf(s, "%s ", policies[i].name);
+	}
+	if (s != buf)
+		/* convert the last space to a newline */
+		*(s-1) = '\n';
+	return (s - buf);
+}
+
+static ssize_t policy_store(struct kobject *kobj,
+			    struct kobj_attribute *attr,
+			    const char *buf, size_t n)
+{
+	const char *s;
+	char *p;
+	int len;
+	int i;
+
+	p = memchr(buf, '\n', n);
+	len = p ? p - buf : n;
+
+	for (i = 0; i < ARRAY_SIZE(policies); i++) {
+		s = policies[i].name;
+		if (s && len == strlen(s) && !strncmp(buf, s, len)) {
+			mutex_lock(&pm_mutex);
+			policies[policy].set_state(PM_SUSPEND_ON);
+			policy = i;
+			mutex_unlock(&pm_mutex);
+			return n;
+		}
+	}
+	return -EINVAL;
+}
+
+power_attr(policy);
+#endif /* CONFIG_OPPORTUNISTIC_SUSPEND */
+
 #ifdef CONFIG_PM_TRACE
 int pm_trace_enabled;
 
@@ -236,6 +346,9 @@ static struct attribute * g[] = {
 #endif
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
+#ifdef CONFIG_OPPORTUNISTIC_SUSPEND
+	&policy_attr.attr,
+#endif
 #ifdef CONFIG_PM_DEBUG
 	&pm_test_attr.attr,
 #endif
@@ -247,7 +360,7 @@ static struct attribute_group attr_group = {
 	.attrs = g,
 };
 
-#ifdef CONFIG_PM_RUNTIME
+#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_OPPORTUNISTIC_SUSPEND)
 struct workqueue_struct *pm_wq;
 EXPORT_SYMBOL_GPL(pm_wq);
 
@@ -266,6 +379,7 @@ static int __init pm_init(void)
 	int error = pm_start_workqueue();
 	if (error)
 		return error;
+	opportunistic_suspend_init();
 	power_kobj = kobject_create_and_add("power", NULL);
 	if (!power_kobj)
 		return -ENOMEM;
diff --git a/kernel/power/opportunistic_suspend.c b/kernel/power/opportunistic_suspend.c
new file mode 100644
index 0000000..cc90b60
--- /dev/null
+++ b/kernel/power/opportunistic_suspend.c
@@ -0,0 +1,298 @@
+/*
+ * kernel/power/opportunistic_suspend.c
+ *
+ * Copyright (C) 2005-2010 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/rtc.h>
+#include <linux/suspend.h>
+
+#include "power.h"
+
+extern struct workqueue_struct *pm_wq;
+
+enum {
+	DEBUG_EXIT_SUSPEND = 1U << 0,
+	DEBUG_WAKEUP = 1U << 1,
+	DEBUG_USER_STATE = 1U << 2,
+	DEBUG_SUSPEND = 1U << 3,
+	DEBUG_SUSPEND_BLOCKER = 1U << 4,
+};
+static int debug_mask = DEBUG_EXIT_SUSPEND | DEBUG_WAKEUP | DEBUG_USER_STATE;
+module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
+
+static int unknown_wakeup_delay_msecs = 500;
+module_param_named(unknown_wakeup_delay_msecs, unknown_wakeup_delay_msecs, int,
+		   S_IRUGO | S_IWUSR | S_IWGRP);
+
+#define SB_INITIALIZED            (1U << 8)
+#define SB_ACTIVE                 (1U << 9)
+
+DEFINE_SUSPEND_BLOCKER(main_suspend_blocker, main);
+
+static DEFINE_SPINLOCK(list_lock);
+static DEFINE_SPINLOCK(state_lock);
+static LIST_HEAD(inactive_blockers);
+static LIST_HEAD(active_blockers);
+static int current_event_num;
+static suspend_state_t requested_suspend_state = PM_SUSPEND_MEM;
+static bool enable_suspend_blockers;
+static DEFINE_SUSPEND_BLOCKER(unknown_wakeup, unknown_wakeups);
+
+#define pr_info_time(fmt, args...) \
+	do { \
+		struct timespec ts; \
+		struct rtc_time tm; \
+		getnstimeofday(&ts); \
+		rtc_time_to_tm(ts.tv_sec, &tm); \
+		pr_info(fmt "(%d-%02d-%02d %02d:%02d:%02d.%09lu UTC)\n" , \
+			args, \
+			tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, \
+			tm.tm_hour, tm.tm_min, tm.tm_sec, ts.tv_nsec); \
+	} while (0);
+
+static void print_active_suspend_blockers(void)
+{
+	struct suspend_blocker *blocker;
+
+	list_for_each_entry(blocker, &active_blockers, link)
+		pr_info("PM: Active suspend blocker %s\n", blocker->name);
+}
+
+/**
+ * suspend_is_blocked - Check if there are active suspend blockers.
+ *
+ * Return true if suspend blockers are enabled and there are active suspend
+ * blockers, in which case the system cannot be put to sleep opportunistically.
+ */
+bool suspend_is_blocked(void)
+{
+	return enable_suspend_blockers && !list_empty(&active_blockers);
+}
+
+static void expire_unknown_wakeup(unsigned long data)
+{
+	suspend_unblock(&unknown_wakeup);
+}
+static DEFINE_TIMER(expire_unknown_wakeup_timer, expire_unknown_wakeup, 0, 0);
+
+static void suspend_worker(struct work_struct *work)
+{
+	int ret;
+	int entry_event_num;
+
+	enable_suspend_blockers = true;
+
+	if (suspend_is_blocked()) {
+		if (debug_mask & DEBUG_SUSPEND)
+			pr_info("PM: Automatic suspend aborted\n");
+		goto abort;
+	}
+
+	entry_event_num = current_event_num;
+
+	if (debug_mask & DEBUG_SUSPEND)
+		pr_info("PM: Automatic suspend\n");
+
+	ret = pm_suspend(requested_suspend_state);
+
+	if (debug_mask & DEBUG_EXIT_SUSPEND)
+		pr_info_time("PM: Automatic suspend exit, ret = %d ", ret);
+
+	if (current_event_num == entry_event_num) {
+		if (debug_mask & DEBUG_SUSPEND)
+			pr_info("PM: pm_suspend() returned with no event\n");
+		suspend_block(&unknown_wakeup);
+		mod_timer(&expire_unknown_wakeup_timer,
+			  msecs_to_jiffies(unknown_wakeup_delay_msecs));
+	}
+
+abort:
+	enable_suspend_blockers = false;
+}
+static DECLARE_WORK(suspend_work, suspend_worker);
+
+/**
+ * suspend_blocker_register - Prepare a suspend blocker for being used.
+ * @blocker: Suspend blocker to handle.
+ *
+ * The suspend blocker struct and name must not be freed before calling
+ * suspend_blocker_unregister().
+ */
+void suspend_blocker_register(struct suspend_blocker *blocker)
+{
+	unsigned long irqflags = 0;
+
+	WARN_ON(!blocker->name);
+
+	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
+		pr_info("%s: Registering %s\n", __func__, blocker->name);
+
+	blocker->flags = SB_INITIALIZED;
+	INIT_LIST_HEAD(&blocker->link);
+
+	spin_lock_irqsave(&list_lock, irqflags);
+	list_add(&blocker->link, &inactive_blockers);
+	spin_unlock_irqrestore(&list_lock, irqflags);
+}
+EXPORT_SYMBOL(suspend_blocker_register);
+
+/**
+ * suspend_blocker_init - Initialize a suspend blocker's name and register it.
+ * @blocker: Suspend blocker to initialize.
+ * @name:    The name of the suspend blocker to show in debug messages.
+ *
+ * The suspend blocker struct and name must not be freed before calling
+ * suspend_blocker_unregister().
+ */
+void suspend_blocker_init(struct suspend_blocker *blocker, const char *name)
+{
+	blocker->name = name;
+	suspend_blocker_register(blocker);
+}
+EXPORT_SYMBOL(suspend_blocker_init);
+
+/**
+ * suspend_blocker_unregister - Unregister a suspend blocker.
+ * @blocker: Suspend blocker to handle.
+ */
+void suspend_blocker_unregister(struct suspend_blocker *blocker)
+{
+	unsigned long irqflags;
+
+	if (WARN_ON(!(blocker->flags & SB_INITIALIZED)))
+		return;
+
+	spin_lock_irqsave(&list_lock, irqflags);
+	blocker->flags &= ~SB_INITIALIZED;
+	list_del(&blocker->link);
+	if ((blocker->flags & SB_ACTIVE) && list_empty(&active_blockers))
+		queue_work(pm_wq, &suspend_work);
+	spin_unlock_irqrestore(&list_lock, irqflags);
+
+	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
+		pr_info("%s: Unregistered %s\n", __func__, blocker->name);
+}
+EXPORT_SYMBOL(suspend_blocker_unregister);
+
+/**
+ * suspend_block - Block system suspend.
+ * @blocker: Suspend blocker to use.
+ *
+ * It is safe to call this function from interrupt context.
+ */
+void suspend_block(struct suspend_blocker *blocker)
+{
+	unsigned long irqflags;
+
+	if (WARN_ON(!(blocker->flags & SB_INITIALIZED)))
+		return;
+
+	spin_lock_irqsave(&list_lock, irqflags);
+
+	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
+		pr_info("%s: %s\n", __func__, blocker->name);
+
+	blocker->flags |= SB_ACTIVE;
+	list_move(&blocker->link, &active_blockers);
+
+	current_event_num++;
+
+	spin_unlock_irqrestore(&list_lock, irqflags);
+}
+EXPORT_SYMBOL(suspend_block);
+
+/**
+ * suspend_unblock - Allow system suspend to happen.
+ * @blocker: Suspend blocker to unblock.
+ *
+ * If no other suspend blockers are active, schedule suspend of the system.
+ *
+ * It is safe to call this function from interrupt context.
+ */
+void suspend_unblock(struct suspend_blocker *blocker)
+{
+	unsigned long irqflags;
+
+	if (WARN_ON(!(blocker->flags & SB_INITIALIZED)))
+		return;
+
+	spin_lock_irqsave(&list_lock, irqflags);
+
+	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
+		pr_info("%s: %s\n", __func__, blocker->name);
+
+	list_move(&blocker->link, &inactive_blockers);
+	if ((blocker->flags & SB_ACTIVE) && list_empty(&active_blockers))
+		queue_work(pm_wq, &suspend_work);
+	blocker->flags &= ~(SB_ACTIVE);
+
+	if ((debug_mask & DEBUG_SUSPEND) && blocker == &main_suspend_blocker)
+		print_active_suspend_blockers();
+
+	spin_unlock_irqrestore(&list_lock, irqflags);
+}
+EXPORT_SYMBOL(suspend_unblock);
+
+/**
+ * suspend_blocker_is_active - Test if a suspend blocker is blocking suspend
+ * @blocker: Suspend blocker to check.
+ *
+ * Returns true if the suspend_blocker is currently active.
+ */
+bool suspend_blocker_is_active(struct suspend_blocker *blocker)
+{
+	WARN_ON(!(blocker->flags & SB_INITIALIZED));
+
+	return !!(blocker->flags & SB_ACTIVE);
+}
+EXPORT_SYMBOL(suspend_blocker_is_active);
+
+bool opportunistic_suspend_valid_state(suspend_state_t state)
+{
+	return (state == PM_SUSPEND_ON) || valid_state(state);
+}
+
+int opportunistic_suspend_state(suspend_state_t state)
+{
+	unsigned long irqflags;
+
+	if (!opportunistic_suspend_valid_state(state))
+		return -ENODEV;
+
+	spin_lock_irqsave(&state_lock, irqflags);
+
+	if (debug_mask & DEBUG_USER_STATE)
+		pr_info_time("%s: %s (%d->%d) at %lld ", __func__,
+			     state != PM_SUSPEND_ON ? "sleep" : "wakeup",
+			     requested_suspend_state, state,
+			     ktime_to_ns(ktime_get()));
+
+	requested_suspend_state = state;
+	if (state == PM_SUSPEND_ON)
+		suspend_block(&main_suspend_blocker);
+	else
+		suspend_unblock(&main_suspend_blocker);
+
+	spin_unlock_irqrestore(&state_lock, irqflags);
+
+	return 0;
+}
+
+void __init opportunistic_suspend_init(void)
+{
+	suspend_blocker_register(&main_suspend_blocker);
+	suspend_block(&main_suspend_blocker);
+	suspend_blocker_register(&unknown_wakeup);
+}
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 46c5a26..2e9cfd5 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -236,3 +236,12 @@ static inline void suspend_thaw_processes(void)
 {
 }
 #endif
+
+#ifdef CONFIG_OPPORTUNISTIC_SUSPEND
+/* kernel/power/opportunistic_suspend.c */
+extern int opportunistic_suspend_state(suspend_state_t state);
+extern bool opportunistic_suspend_valid_state(suspend_state_t state);
+extern void __init opportunistic_suspend_init(void);
+#else
+static inline void opportunistic_suspend_init(void) {}
+#endif
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 56e7dbb..9eb3876 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -20,6 +20,7 @@
 #include "power.h"
 
 const char *const pm_states[PM_SUSPEND_MAX] = {
+	[PM_SUSPEND_ON]		= "on",
 	[PM_SUSPEND_STANDBY]	= "standby",
 	[PM_SUSPEND_MEM]	= "mem",
 };
@@ -157,7 +158,7 @@ static int suspend_enter(suspend_state_t state)
 
 	error = sysdev_suspend(PMSG_SUSPEND);
 	if (!error) {
-		if (!suspend_test(TEST_CORE))
+		if (!suspend_is_blocked() && !suspend_test(TEST_CORE))
 			error = suspend_ops->enter(state);
 		sysdev_resume();
 	}
-- 
1.6.5.1

