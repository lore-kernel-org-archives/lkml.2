Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030229Ab2CFBE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 20:04:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44809 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab2CFBEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 20:04:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arve@android.com designates 10.68.211.168 as permitted sender) smtp.mail=arve@android.com
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, jeffbrown@android.com,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 2/2] PM / Sleep: Add wakeup_source_activate and wakeup_source_deactivate tracepoints
Date: Mon,  5 Mar 2012 17:04:32 -0800
Message-Id: <1330995872-4491-2-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330995872-4491-1-git-send-email-arve@android.com>
References: <201203042356.17846.rjw@sisk.pl>
 <1330995872-4491-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracepoints to wakeup_source_activate and wakeup_source_deactivate.
Useful for checking that specific wakeup sources overlap as expected.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/base/power/wakeup.c  |   12 +++++++++---
 include/trace/events/power.h |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index a896cc8..94b843d 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -14,6 +14,7 @@
 #include <linux/suspend.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <trace/events/power.h>
 
 #include "power.h"
 
@@ -375,6 +376,8 @@ EXPORT_SYMBOL_GPL(device_set_wakeup_enable);
  */
 static void wakeup_source_activate(struct wakeup_source *ws)
 {
+	unsigned int cec;
+
 	ws->active = true;
 	ws->active_count++;
 	ws->last_time = ktime_get();
@@ -382,7 +385,9 @@ static void wakeup_source_activate(struct wakeup_source *ws)
 		ws->start_prevent_time = ws->last_time;
 
 	/* Increment the counter of events in progress. */
-	atomic_inc(&combined_event_count);
+	cec = atomic_inc_return(&combined_event_count);
+
+	trace_wakeup_source_activate(ws->name, cec);
 }
 
 /**
@@ -468,7 +473,7 @@ static inline void update_prevent_sleep_time(struct wakeup_source *ws,
  */
 static void wakeup_source_deactivate(struct wakeup_source *ws)
 {
-	unsigned int cnt, inpr;
+	unsigned int cnt, inpr, cec;
 	ktime_t duration;
 	ktime_t now;
 
@@ -506,7 +511,8 @@ static void wakeup_source_deactivate(struct wakeup_source *ws)
 	 * Increment the counter of registered wakeup events and decrement the
 	 * couter of wakeup events in progress simultaneously.
 	 */
-	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
+	cec = atomic_add_return(MAX_IN_PROGRESS, &combined_event_count);
+	trace_wakeup_source_deactivate(ws->name, cec);
 
 	split_counters(&cnt, &inpr);
 	if (!inpr && waitqueue_active(&wakeup_count_wait_queue)) {
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 1bcc2a8..5c7b721 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
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
 /* This code will be removed after deprecation time exceeded (2.6.41) */
 #ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
 
-- 
1.7.7.3

