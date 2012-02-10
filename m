Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab2BJAEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:04:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758709Ab2BJABj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:39 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 21/31] hw_event: Add x86 MCE events on it
Date: Thu,  9 Feb 2012 22:01:20 -0200
Message-Id: <1328832090-9166-22-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As x86 architecture defines a way for the CPU to report hardware
errors, via MCE, integrate it at the hw_event trace class.

As the EDAC parsers are capable of enriching the information for
memory errors, pointing to the defected DIMM's, while the MCE
log provides additional details of the error, helping the OEM
and hardware vendors to track what happened, two new trace events
that merges both MCE and memory errors were created. The EDAC
core will use those new tracepoint, on x86 arch, if the MCE trace
is available.

This patch is based on Tony Luck and Borislav Petkov feedback.

The mcelog events should now be used by sb_edac and i7core_edac,
as the extra parameter for edac_mc_handle_error() were introduced
on the last changeset.

I opted to convert amd64_edac to use it on a separate patch, as it
would likely make easier for Borislav to review.

Suggested-by: Borislav Petkov <bp@amd64.org>
Suggested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 drivers/edac/edac_core.h         |    2 +-
 drivers/edac/edac_mc.c           |   25 ++++-
 include/trace/events/hw_event.h  |  238 +++++++++++++++++++++++++++++++++++++-
 include/trace/events/mce.h       |   69 -----------
 5 files changed, 259 insertions(+), 77 deletions(-)
 delete mode 100644 include/trace/events/mce.h

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2af127d..c219f72 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -53,7 +53,7 @@ static DEFINE_MUTEX(mce_chrdev_read_mutex);
 			      lockdep_is_held(&mce_chrdev_read_mutex))
 
 #define CREATE_TRACE_POINTS
-#include <trace/events/mce.h>
+#include <trace/events/hw_event.h>
 
 int mce_disabled __read_mostly;
 
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 1d421d3..7caff6e 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -470,7 +470,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  const int layer2,
 			  const char *msg,
 			  const char *other_detail,
-			  const void *mcelog);
+			  const void *arch_log);
 
 /*
  * edac_device APIs
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 37d2c97..2dca0e3 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -899,7 +899,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  const int layer2,
 			  const char *msg,
 			  const char *other_detail,
-			  const void *mcelog)
+			  const void *arch_log)
 {
 	unsigned long remapped_page;
 	/* FIXME: too much for stack: move it to some pre-alocated area */
@@ -924,9 +924,23 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 				p = "UE";
 				mci->ue_mc++;
 			}
+#ifdef CONFIG_X86
+			if (arch_log)
+				trace_mc_out_of_range_mce(mci, p,
+							  edac_layer_name[mci->layers[i].type],
+							  pos[i], 0,
+							  mci->layers[i].size,
+							  arch_log);
+			else
+				trace_mc_out_of_range(mci, p,
+						      edac_layer_name[mci->layers[i].type],
+						      pos[i], 0,
+						      mci->layers[i].size);
+#else
 			trace_mc_out_of_range(mci, p,
 					edac_layer_name[mci->layers[i].type],
 					pos[i], 0, mci->layers[i].size);
+#endif
 			edac_mc_printk(mci, KERN_ERR,
 				       "INTERNAL ERROR: %s value is out of range (%d >= %d)\n",
 				       edac_layer_name[mci->layers[i].type],
@@ -1033,8 +1047,17 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			"page 0x%lx offset 0x%lx grain %d\n",
 			page_frame_number, offset_in_page, grain);
 
+#ifdef CONFIG_X86
+	if (arch_log)
+		trace_mc_error_mce(type, mci->mc_idx, msg, label, location,
+				   detail, other_detail, arch_log);
+	else
+		trace_mc_error(type, mci->mc_idx, msg, label, location,
+			       detail, other_detail);
+#else
 	trace_mc_error(type, mci->mc_idx, msg, label, location,
 		       detail, other_detail);
+#endif
 
 	if (type == HW_EVENT_ERR_CORRECTED) {
 		if (edac_mc_get_log_ce())
diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
index 4c455c1..ade0185 100644
--- a/include/trace/events/hw_event.h
+++ b/include/trace/events/hw_event.h
@@ -6,6 +6,7 @@
 
 #include <linux/tracepoint.h>
 #include <linux/edac.h>
+#include <linux/ktime.h>
 
 /*
  * Hardware Anomaly Report Mecanism (HARM) events
@@ -13,6 +14,9 @@
  * Those events are generated when hardware detected a corrected or
  * uncorrected event, and are meant to replace the current API to report
  * errors defined on both EDAC and MCE subsystems.
+ *
+ * There are two types of events defined here: arch-independent ones, and
+ * x86 arch events. The x86 arch events are based on x86 MCE architecture.
  */
 
 DECLARE_EVENT_CLASS(hw_event_class,
@@ -46,7 +50,7 @@ DEFINE_EVENT(hw_event_class, hw_event_init,
 
 
 /*
- * Memory Controller specific events
+ * Hardware-independent Memory Controller specific events
  */
 
 /*
@@ -85,7 +89,7 @@ TRACE_EVENT(mc_error,
 		__assign_str(driver_detail, driver_detail);
 	),
 
-	TP_printk(HW_ERR "mce#%d: %s error %s on label \"%s\" (%s %s %s)\n",
+	TP_printk(HW_ERR "mce#%d: %s error %s on label \"%s\" (%s %s %s)",
 		  __entry->mc_index,
 		  (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
 			((__entry->err_type == HW_EVENT_ERR_FATAL) ?
@@ -121,7 +125,7 @@ TRACE_EVENT(mc_out_of_range,
 		__entry->max			= max;
 	),
 
-	TP_printk(HW_ERR "mce#%d %s: %s=%d is not between %d and %d\n",
+	TP_printk(HW_ERR "mce#%d %s: %s=%d is not between %d and %d",
 		__entry->mc_index,
 		__get_str(type),
 		__get_str(field),
@@ -131,9 +135,233 @@ TRACE_EVENT(mc_out_of_range,
 );
 
 /*
- * MCE Events placeholder. Please add non-memory events that come from the
- * MCE driver here
+ * X86 arch-specific events
+ */
+
+#ifdef CONFIG_X86
+#include <asm/mce.h>
+
+/*
+ * Generic MCE event
+ */
+TRACE_EVENT(mce_record,
+
+	TP_PROTO(const struct mce *m),
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
+/*
+ * MCE event for memory-controller errors
  */
+TRACE_EVENT(mc_error_mce,
+
+	TP_PROTO(const unsigned int err_type,
+		 const unsigned int mc_index,
+		 const char *msg,
+		 const char *label,
+		 const char *location,
+		 const char *detail,
+		 const char *driver_detail,
+		 const struct mce *m),
+
+	TP_ARGS(err_type, mc_index, msg, label, location,
+		detail, driver_detail, m),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	err_type	)
+		__field(	unsigned int,	mc_index	)
+		__string(	msg,		msg		)
+		__string(	label,		label		)
+		__string(	detail,		detail		)
+		__string(	location,	location	)
+		__string(	driver_detail,	driver_detail	)
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
+		__entry->err_type	= err_type;
+		__entry->mc_index	= mc_index;
+		__assign_str(msg, msg);
+		__assign_str(label, label);
+		__assign_str(location, location);
+		__assign_str(detail, detail);
+		__assign_str(driver_detail, driver_detail);
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
+	TP_printk("mce#%d: %s error %s on label \"%s\" (%s %s CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x %s)",
+		  __entry->mc_index,
+		  (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
+			((__entry->err_type == HW_EVENT_ERR_FATAL) ?
+			"Fatal" : "Uncorrected"),
+		  __get_str(msg),
+		  __get_str(label),
+		  __get_str(location),
+		  __get_str(detail),
+		  __entry->cpu,
+		  __entry->mcgcap, __entry->mcgstatus,
+		  __entry->bank, __entry->status,
+		  __entry->addr, __entry->misc,
+		  __entry->cs, __entry->ip,
+		  __entry->tsc,
+		  __entry->cpuvendor, __entry->cpuid,
+		  __entry->walltime,
+		  __entry->socketid,
+		  __entry->apicid,
+		  __get_str(driver_detail))
+);
+
+TRACE_EVENT(mc_out_of_range_mce,
+	TP_PROTO(struct mem_ctl_info *mci, const char *type, const char *field,
+		int invalid_val, int min, int max, const struct mce *m),
+
+	TP_ARGS(mci, type, field, invalid_val, min, max, m),
+
+	TP_STRUCT__entry(
+		__string(	type,		type		)
+		__string(	field,		field		)
+		__field(	unsigned int,	mc_index	)
+		__field(	int,		invalid_val	)
+		__field(	int,		min		)
+		__field(	int,		max		)
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
+		__assign_str(type, type);
+		__assign_str(field, field);
+		__entry->mc_index	= mci->mc_idx;
+		__entry->invalid_val	= invalid_val;
+		__entry->min		= min;
+		__entry->max		= max;
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
+	TP_printk(HW_ERR "mce#%d %s: %s=%d is not between %d and %d (CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x)",
+		  __entry->mc_index,
+		  __get_str(type),
+		  __get_str(field),
+		  __entry->invalid_val,
+		  __entry->min,
+		  __entry->max,
+		  __entry->cpu,
+		  __entry->mcgcap, __entry->mcgstatus,
+		  __entry->bank, __entry->status,
+		  __entry->addr, __entry->misc,
+		  __entry->cs, __entry->ip,
+		  __entry->tsc,
+		  __entry->cpuvendor, __entry->cpuid,
+		  __entry->walltime,
+		  __entry->socketid,
+		  __entry->apicid)
+);
+
+#endif
 
 
 #endif /* _TRACE_HW_EVENT_MC_H */
diff --git a/include/trace/events/mce.h b/include/trace/events/mce.h
deleted file mode 100644
index 4cbbcef..0000000
--- a/include/trace/events/mce.h
+++ /dev/null
@@ -1,69 +0,0 @@
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM mce
-
-#if !defined(_TRACE_MCE_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_MCE_H
-
-#include <linux/ktime.h>
-#include <linux/tracepoint.h>
-#include <asm/mce.h>
-
-TRACE_EVENT(mce_record,
-
-	TP_PROTO(struct mce *m),
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
-
-#endif /* _TRACE_MCE_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
-- 
1.7.8

