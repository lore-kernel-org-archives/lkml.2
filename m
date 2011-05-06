Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab1EFUIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:08:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:20915 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab1EFUIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:08:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,327,1301900400"; 
   d="scan'208,223";a="639142582"
Message-ID: <4DC45537.6070609@linux.intel.com>
Date: Fri, 06 May 2011 13:08:23 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Fix powerTOP regression with 2.6.39-rc5
Content-Type: multipart/mixed;
 boundary="------------010505050104000802010308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010505050104000802010308
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From c2db3ab8cff0d1cfb9582fc149df2794978a332e Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Thu, 5 May 2011 23:55:18 -0400
Subject: [PATCH] Regression: partial revert "tracing: Remove lock_depth 
from event entry"

This patch partially reverts commit 
e6e1e2593592a8f6f6380496655d8c6f67431266.
That commit changed the structure layout of the trace structure, which in
turn broke PowerTOP (1.9x generation) quite badly.

I appreciate not wanting to expose the variable in question, and 
PowerTOP was
not using it, so I've replaced the variable with just a padding field....
... that way if in the future a new field is needed it can just use this 
padding
variable.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
  include/linux/ftrace_event.h |    1 +
  kernel/trace/trace.c         |    1 +
  kernel/trace/trace_events.c  |    1 +
  3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 22b32af1..b5a550a 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -37,6 +37,7 @@ struct trace_entry {
      unsigned char        flags;
      unsigned char        preempt_count;
      int            pid;
+    int            padding;
  };

  #define FTRACE_MAX_EVENT                        \
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d38c16a..1cb49be 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1110,6 +1110,7 @@ tracing_generic_entry_update(struct trace_entry 
*entry, unsigned long flags,

      entry->preempt_count        = pc & 0xff;
      entry->pid            = (tsk) ? tsk->pid : 0;
+    entry->padding            = 0;
      entry->flags =
  #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
          (irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e88f74f..2fe1103 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -116,6 +116,7 @@ static int trace_define_common_fields(void)
      __common_field(unsigned char, flags);
      __common_field(unsigned char, preempt_count);
      __common_field(int, pid);
+    __common_field(int, padding);

      return ret;
  }
-- 
1.7.2.2


--------------010505050104000802010308
Content-Type: text/plain;
 name="0001-Regression-partial-revert-tracing-Remove-lock_depth.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Regression-partial-revert-tracing-Remove-lock_depth.pat";
 filename*1="ch"

>From c2db3ab8cff0d1cfb9582fc149df2794978a332e Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Thu, 5 May 2011 23:55:18 -0400
Subject: [PATCH] Regression: partial revert "tracing: Remove lock_depth from event entry"

This patch partially reverts commit e6e1e2593592a8f6f6380496655d8c6f67431266.
That commit changed the structure layout of the trace structure, which in
turn broke PowerTOP (1.9x generation) quite badly.

I appreciate not wanting to expose the variable in question, and PowerTOP was
not using it, so I've replaced the variable with just a padding byte....
... that way if in the future a new field is needed it can just use this padding
byte.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/ftrace_event.h |    1 +
 kernel/trace/trace.c         |    1 +
 kernel/trace/trace_events.c  |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 22b32af1..b5a550a 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -37,6 +37,7 @@ struct trace_entry {
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
+	int			padding;
 };
 
 #define FTRACE_MAX_EVENT						\
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d38c16a..1cb49be 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1110,6 +1110,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
+	entry->padding			= 0;
 	entry->flags =
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e88f74f..2fe1103 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -116,6 +116,7 @@ static int trace_define_common_fields(void)
 	__common_field(unsigned char, flags);
 	__common_field(unsigned char, preempt_count);
 	__common_field(int, pid);
+	__common_field(int, padding);
 
 	return ret;
 }
-- 
1.7.2.2


--------------010505050104000802010308--
