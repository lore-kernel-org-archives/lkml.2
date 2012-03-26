Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab2CZSk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:40:28 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:58331 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139Ab2CZSje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:39:34 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: David Sharp <dhsharp@google.com>, Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 5/6] trace: raw_syscalls: Mark compat syscalls in the MSB of the syscall number
Date: Mon, 26 Mar 2012 11:39:27 -0700
Message-Id: <1332787168-20457-6-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sharp <dhsharp@google.com>

The compat syscalls are undifferentiable from standard syscalls, making
correct interpretation of 'id' impossible on systems where compat tasks
are running. Set the MSB of 'id' if the traced syscall is compat, and
output this bit in the print format.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 include/trace/events/syscalls.h |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
index aeaa536..4f42fdc 100644
--- a/include/trace/events/syscalls.h
+++ b/include/trace/events/syscalls.h
@@ -6,10 +6,13 @@
 #define _TRACE_EVENTS_SYSCALLS_H
 
 #include <linux/tracepoint.h>
+#include <linux/compat.h>
 
 #include <asm/ptrace.h>
 #include <asm/syscall.h>
 
+#define COMPAT_MASK (~0UL>>1)
+#define COMPAT_BIT ~(~0UL>>1)
 
 TRACE_EVENT(sys_enter,
 
@@ -23,14 +26,19 @@ TRACE_EVENT(sys_enter,
 	),
 
 	TP_fast_assign(
+#ifdef CONFIG_COMPAT
+		if (is_compat_task())
+			id |= COMPAT_BIT;
+#endif
 		__entry->id	= id;
 		syscall_get_arguments(current, regs, 0, 6, __entry->args);
 	),
 
-	TP_printk("NR %ld (%lx, %lx, %lx, %lx, %lx, %lx)",
-		  __entry->id,
+	TP_printk("NR %ld (%lx, %lx, %lx, %lx, %lx, %lx) isCompat: %d",
+		  __entry->id & COMPAT_MASK,
 		  __entry->args[0], __entry->args[1], __entry->args[2],
-		  __entry->args[3], __entry->args[4], __entry->args[5])
+		  __entry->args[3], __entry->args[4], __entry->args[5],
+		  !!(__entry->id & COMPAT_BIT))
 );
 
 TRACE_EVENT_FLAGS(sys_enter, TRACE_EVENT_FL_CAP_ANY)
@@ -48,11 +56,16 @@ TRACE_EVENT(sys_exit,
 
 	TP_fast_assign(
 		__entry->id	= syscall_get_nr(current, regs);
+#ifdef CONFIG_COMPAT
+		if (is_compat_task())
+			__entry->id |= COMPAT_BIT;
+#endif
 		__entry->ret	= ret;
 	),
 
-	TP_printk("NR %ld = %ld",
-		  __entry->id, __entry->ret)
+	TP_printk("NR %ld = %ld isCompat: %d",
+		  __entry->id & COMPAT_MASK, __entry->ret,
+		  !!(__entry->id & COMPAT_BIT))
 );
 
 TRACE_EVENT_FLAGS(sys_exit, TRACE_EVENT_FL_CAP_ANY)
-- 
1.7.7.3

