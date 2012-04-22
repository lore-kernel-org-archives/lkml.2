Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab2DVVVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 17:21:34 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:58177 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab2DVVUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 17:20:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 4/8] PM / Sleep: Add wakeup_source_activate and wakeup_source_deactivate tracepoints
Date: Sun, 22 Apr 2012 23:21:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201202070200.55505.rjw@sisk.pl> <201202220031.46219.rjw@sisk.pl> <201204222319.02228.rjw@sisk.pl>
In-Reply-To: <201204222319.02228.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204222321.58248.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Add tracepoints to wakeup_source_activate and wakeup_source_deactivate.
Useful for checking that specific wakeup sources overlap as expected.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/wakeup.c  |   12 +++++++++---
 include/trace/events/power.h |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 3 deletions(-)

Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -14,6 +14,7 @@
 #include <linux/suspend.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <trace/events/power.h>
 
 #include "power.h"
 
@@ -374,12 +375,16 @@ EXPORT_SYMBOL_GPL(device_set_wakeup_enab
  */
 static void wakeup_source_activate(struct wakeup_source *ws)
 {
+	unsigned int cec;
+
 	ws->active = true;
 	ws->active_count++;
 	ws->last_time = ktime_get();
 
 	/* Increment the counter of events in progress. */
-	atomic_inc(&combined_event_count);
+	cec = atomic_inc_return(&combined_event_count);
+
+	trace_wakeup_source_activate(ws->name, cec);
 }
 
 /**
@@ -454,7 +459,7 @@ EXPORT_SYMBOL_GPL(pm_stay_awake);
  */
 static void wakeup_source_deactivate(struct wakeup_source *ws)
 {
-	unsigned int cnt, inpr;
+	unsigned int cnt, inpr, cec;
 	ktime_t duration;
 	ktime_t now;
 
@@ -489,7 +494,8 @@ static void wakeup_source_deactivate(str
 	 * Increment the counter of registered wakeup events and decrement the
 	 * couter of wakeup events in progress simultaneously.
 	 */
-	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
+	cec = atomic_add_return(MAX_IN_PROGRESS, &combined_event_count);
+	trace_wakeup_source_deactivate(ws->name, cec);
 
 	split_counters(&cnt, &inpr);
 	if (!inpr && waitqueue_active(&wakeup_count_wait_queue))
Index: linux/include/trace/events/power.h
===================================================================
--- linux.orig/include/trace/events/power.h
+++ linux/include/trace/events/power.h
@@ -65,6 +65,40 @@ TRACE_EVENT(machine_suspend,
 	TP_printk("state=%lu", (unsigned long)__entry->state)
 );
 
+DECLARE_EVENT_CLASS(wakeup_source,
+
+	TP_PROTO(const char *name, unsigned int state),
+
+	TP_ARGS(name, state),
+
+	TP_STRUCT__entry(
+		__string(       name,           name            )
+		__field(        u64,            state           )
+	),
+
+	TP_fast_assign(
+		__assign_str(name, name);
+		__entry->state = state;
+	),
+
+	TP_printk("%s state=0x%lx", __get_str(name),
+		(unsigned long)__entry->state)
+);
+
+DEFINE_EVENT(wakeup_source, wakeup_source_activate,
+
+	TP_PROTO(const char *name, unsigned int state),
+
+	TP_ARGS(name, state)
+);
+
+DEFINE_EVENT(wakeup_source, wakeup_source_deactivate,
+
+	TP_PROTO(const char *name, unsigned int state),
+
+	TP_ARGS(name, state)
+);
+
 #ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
 
 /*

