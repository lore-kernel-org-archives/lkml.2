Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab2BJQs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:48:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab2BJQsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:48:25 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 32/31] edac: restore mce.h file
Date: Fri, 10 Feb 2012 14:48:12 -0200
Message-Id: <1328892492-8347-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace doesn't like to have the same trace file included into
two different places. I only noticed it when compiling the
entire tree again on a different machine.

Partially reverts commit 4eb2a29419c1fefd76c8dbcd308b84a4b52faf4d

I'll likely work on another approach, as keeping the mce_record
on a different place than the other *mce traces don't seem right,
but, for now, let's just take the shortest way.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 include/trace/events/hw_event.h  |   62 +++------------------------------
 include/trace/events/mce.h       |   69 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 57 deletions(-)
 create mode 100644 include/trace/events/mce.h

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index c219f72..2af127d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -53,7 +53,7 @@ static DEFINE_MUTEX(mce_chrdev_read_mutex);
 			      lockdep_is_held(&mce_chrdev_read_mutex))
 
 #define CREATE_TRACE_POINTS
-#include <trace/events/hw_event.h>
+#include <trace/events/mce.h>
 
 int mce_disabled __read_mostly;
 
diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
index ade0185..91522b3 100644
--- a/include/trace/events/hw_event.h
+++ b/include/trace/events/hw_event.h
@@ -142,66 +142,16 @@ TRACE_EVENT(mc_out_of_range,
 #include <asm/mce.h>
 
 /*
- * Generic MCE event
+ * MCE event for memory-controller errors
  */
-TRACE_EVENT(mce_record,
-
-	TP_PROTO(const struct mce *m),
-
-	TP_ARGS(m),
-
-	TP_STRUCT__entry(
-		__field(	u64,		mcgcap		)
-		__field(	u64,		mcgstatus	)
-		__field(	u64,		status		)
-		__field(	u64,		addr		)
-		__field(	u64,		misc		)
-		__field(	u64,		ip		)
-		__field(	u64,		tsc		)
-		__field(	u64,		walltime	)
-		__field(	u32,		cpu		)
-		__field(	u32,		cpuid		)
-		__field(	u32,		apicid		)
-		__field(	u32,		socketid	)
-		__field(	u8,		cs		)
-		__field(	u8,		bank		)
-		__field(	u8,		cpuvendor	)
-	),
-
-	TP_fast_assign(
-		__entry->mcgcap		= m->mcgcap;
-		__entry->mcgstatus	= m->mcgstatus;
-		__entry->status		= m->status;
-		__entry->addr		= m->addr;
-		__entry->misc		= m->misc;
-		__entry->ip		= m->ip;
-		__entry->tsc		= m->tsc;
-		__entry->walltime	= m->time;
-		__entry->cpu		= m->extcpu;
-		__entry->cpuid		= m->cpuid;
-		__entry->apicid		= m->apicid;
-		__entry->socketid	= m->socketid;
-		__entry->cs		= m->cs;
-		__entry->bank		= m->bank;
-		__entry->cpuvendor	= m->cpuvendor;
-	),
-
-	TP_printk("CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x",
-		__entry->cpu,
-		__entry->mcgcap, __entry->mcgstatus,
-		__entry->bank, __entry->status,
-		__entry->addr, __entry->misc,
-		__entry->cs, __entry->ip,
-		__entry->tsc,
-		__entry->cpuvendor, __entry->cpuid,
-		__entry->walltime,
-		__entry->socketid,
-		__entry->apicid)
-);
 
 /*
- * MCE event for memory-controller errors
+ * NOTE: due to trace contraints, we can't have the mce_record at the
+ * same file as mce_record, as they're used by different files. Including
+ * trace headers twice cause duplicated symbols. So, care is needed to
+ * sync changes here with changes at include/trace/events/mce.h.
  */
+
 TRACE_EVENT(mc_error_mce,
 
 	TP_PROTO(const unsigned int err_type,
diff --git a/include/trace/events/mce.h b/include/trace/events/mce.h
new file mode 100644
index 0000000..4cbbcef
--- /dev/null
+++ b/include/trace/events/mce.h
@@ -0,0 +1,69 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mce
+
+#if !defined(_TRACE_MCE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MCE_H
+
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+#include <asm/mce.h>
+
+TRACE_EVENT(mce_record,
+
+	TP_PROTO(struct mce *m),
+
+	TP_ARGS(m),
+
+	TP_STRUCT__entry(
+		__field(	u64,		mcgcap		)
+		__field(	u64,		mcgstatus	)
+		__field(	u64,		status		)
+		__field(	u64,		addr		)
+		__field(	u64,		misc		)
+		__field(	u64,		ip		)
+		__field(	u64,		tsc		)
+		__field(	u64,		walltime	)
+		__field(	u32,		cpu		)
+		__field(	u32,		cpuid		)
+		__field(	u32,		apicid		)
+		__field(	u32,		socketid	)
+		__field(	u8,		cs		)
+		__field(	u8,		bank		)
+		__field(	u8,		cpuvendor	)
+	),
+
+	TP_fast_assign(
+		__entry->mcgcap		= m->mcgcap;
+		__entry->mcgstatus	= m->mcgstatus;
+		__entry->status		= m->status;
+		__entry->addr		= m->addr;
+		__entry->misc		= m->misc;
+		__entry->ip		= m->ip;
+		__entry->tsc		= m->tsc;
+		__entry->walltime	= m->time;
+		__entry->cpu		= m->extcpu;
+		__entry->cpuid		= m->cpuid;
+		__entry->apicid		= m->apicid;
+		__entry->socketid	= m->socketid;
+		__entry->cs		= m->cs;
+		__entry->bank		= m->bank;
+		__entry->cpuvendor	= m->cpuvendor;
+	),
+
+	TP_printk("CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x",
+		__entry->cpu,
+		__entry->mcgcap, __entry->mcgstatus,
+		__entry->bank, __entry->status,
+		__entry->addr, __entry->misc,
+		__entry->cs, __entry->ip,
+		__entry->tsc,
+		__entry->cpuvendor, __entry->cpuid,
+		__entry->walltime,
+		__entry->socketid,
+		__entry->apicid)
+);
+
+#endif /* _TRACE_MCE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.8

