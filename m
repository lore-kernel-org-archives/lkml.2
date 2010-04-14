Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0DNQU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:20:27 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58291 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304Ab0DNQUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:20:21 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 1/3 v4] Add tracing_off_event() to stop tracing when a bug or warning occur
Date: Wed, 14 Apr 2010 12:20:14 -0400
Message-Id: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracing_off_event() function calls tracing_off() to stop tracing
when an event occurs. By default, only BUG-type events stop tracing,
while WARNING type events do not. This is controlled through the
tracing_off={none,warn,bug} commandline parameter.

Call this function from bug and warning event handlers to enable a user
to debug their kernel by starting a trace, hitting an event, and then
retrieving trace info knowing that the trace was stopped right after the
event was hit.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 include/linux/kernel.h     |    7 +++++++
 kernel/trace/ring_buffer.c |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 9365227..80c67ad 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -478,16 +478,23 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
  *
  * Most likely, you want to use tracing_on/tracing_off.
  */
+enum trace_off_event {
+	TRACE_EVENT_BUG = 0,
+	TRACE_EVENT_WARN,
+};
+
 #ifdef CONFIG_RING_BUFFER
 void tracing_on(void);
 void tracing_off(void);
 /* trace_off_permanent stops recording with no way to bring it back */
 void tracing_off_permanent(void);
+void tracing_off_event(enum trace_off_event event);
 int tracing_is_on(void);
 #else
 static inline void tracing_on(void) { }
 static inline void tracing_off(void) { }
 static inline void tracing_off_permanent(void) { }
+static inline void tracing_off_event(enum trace_off_event event) { }
 static inline int tracing_is_on(void) { return 0; }
 #endif
 #ifdef CONFIG_TRACING
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 41ca394..f6be195 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -194,6 +194,40 @@ void tracing_off_permanent(void)
 	set_bit(RB_BUFFERS_DISABLED_BIT, &ring_buffer_flags);
 }
 
+static enum trace_off_event tracing_off_event_ctrl = TRACE_EVENT_BUG;
+
+/**
+ * tracing_off_event - turn off tracing depending on event type
+ * @event: type of event that occurred
+ *
+ * This function checks the event type to determine whether tracing should be
+ * disabled. Useful for disabling tracing on bugs or warnings.
+ */
+void tracing_off_event(enum trace_off_event event)
+{
+	if (event <= tracing_off_event_ctrl)
+		tracing_off();
+}
+EXPORT_SYMBOL_GPL(tracing_off_event);
+
+static int __init tracing_off_event_setup(char *str)
+{
+	if (!strcmp("none", str))
+		tracing_off_event_ctrl = -1;
+	else if (!strcmp("bug", str))
+		tracing_off_event_ctrl = TRACE_EVENT_BUG;
+	else if (!strcmp("warn", str))
+		tracing_off_event_ctrl = TRACE_EVENT_WARN;
+	else {
+		printk(KERN_NOTICE "Invalid value passed for tracing_off parameter\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+__setup("tracing_off=", tracing_off_event_setup);
+
 /**
  * tracing_is_on - show state of ring buffers enabled
  */
-- 
1.7.0

