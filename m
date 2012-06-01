Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419Ab2FAPHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:07:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab2FAPHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:07:49 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v29] RAS: Add a tracepoint for reporting memory controller events
Date: Fri,  1 Jun 2012 12:07:38 -0300
Message-Id: <1338563258-13322-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new tracepoint-based hardware events report method for
reporting Memory Controller events.

Part of the description bellow is shamelessly copied from Tony
Luck's notes about the Hardware Error BoF during LPC 2010 [1].
Tony, thanks for your notes and discussions to generate the
h/w error reporting requirements.

[1] http://lwn.net/Articles/416669/

    We have several subsystems & methods for reporting hardware errors:

    1) EDAC ("Error Detection and Correction").  In its original form
    this consisted of a platform specific driver that read topology
    information and error counts from chipset registers and reported
    the results via a sysfs interface.

    2) mcelog - x86 specific decoding of machine check bank registers
    reporting in binary form via /dev/mcelog. Recent additions make use
    of the APEI extensions that were documented in version 4.0a of the
    ACPI specification to acquire more information about errors without
    having to rely reading chipset registers directly. A user level
    programs decodes into somewhat human readable format.

    3) drivers/edac/mce_amd.c - this driver hooks into the mcelog path and
    decodes errors reported via machine check bank registers in AMD
    processors to the console log using printk();

    Each of these mechanisms has a band of followers ... and none
    of them appear to meet all the needs of all users.

As part of a RAS subsystem, let's encapsulate the memory error hardware
events into a trace facility.

The tracepoint printk will be displayed like:

mc_event: [quant] (Corrected|Uncorrected|Fatal) error:[error msg] on memory stick [label] ([location] [edac_mc detail] [driver_d$

Where:
       	[quant] is the quantity of errors
	[error msg] is the driver-specific error message
		    (e. g. "memory read", "bus error", ...);
	[location] is the location in terms of memory controller and
		   branch/channel/slot, channel/slot or csrow/channel;
	[label] is the memory stick label;
	[edac_mc detail] describes the address location of the error
			 and the syndrome;
	[driver detail] is driver-specifig error message details,
			when needed/provided (e. g. "area:DMA", ...)

For example:

mc_event: 1 Corrected error:memory read on memory stick DIMM_1A (mc:0 location:0:0:0 page:0x586b6e offset:0xa66 grain:32 syndrome:0x0 area:DMA)

Of course, any userspace tools meant to handle errors should not parse
the above data. They should, instead, use the binary fields provided by
the tracepoint, mapping them directly into their Management Information
Base.

NOTE: The original patch was providing an additional mechanism for
MCA-based trace events that also contained MCA error register data.
However, as no agreement was reached so far for the MCA-based trace
events, for now, let's add events only for memory errors.
A latter patch is planned to change the tracepoint, for those types
of event.

Cc: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

v29: Optimized to reduce struct size, changing integers to u8/s8 and
     adding an error count, in order to handle error bursts.

 drivers/edac/edac_core.h |    2 +-
 drivers/edac/edac_mc.c   |   58 ++++++++++++++++++++++----
 include/ras/ras_event.h  |  102 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+), 10 deletions(-)
 create mode 100644 include/ras/ras_event.h

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index f06ce9a..eee7360 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -468,7 +468,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  const int layer2,
 			  const char *msg,
 			  const char *other_detail,
-			  const void *mcelog);
+			  const void *arch_log);
 
 /*
  * edac_device APIs
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 10f3750..2d7e2d5 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -27,12 +27,17 @@
 #include <linux/list.h>
 #include <linux/ctype.h>
 #include <linux/edac.h>
+#include <linux/bitops.h>
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/edac.h>
 #include "edac_core.h"
 #include "edac_module.h"
 
+#define CREATE_TRACE_POINTS
+#define TRACE_INCLUDE_PATH ../../include/ras
+#include <ras/ras_event.h>
+
 /* lock to memory controller's control array */
 static DEFINE_MUTEX(mem_ctls_mutex);
 static LIST_HEAD(mc_devices);
@@ -384,6 +389,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	 * which will perform kobj unregistration and the actual free
 	 * will occur during the kobject callback operation
 	 */
+
 	return mci;
 }
 EXPORT_SYMBOL_GPL(edac_mc_alloc);
@@ -902,19 +908,19 @@ static void edac_ce_error(struct mem_ctl_info *mci,
 			  const bool enable_per_layer_report,
 			  const unsigned long page_frame_number,
 			  const unsigned long offset_in_page,
-			  u32 grain)
+			  long grain)
 {
 	unsigned long remapped_page;
 
 	if (edac_mc_get_log_ce()) {
 		if (other_detail && *other_detail)
 			edac_mc_printk(mci, KERN_WARNING,
-				       "CE %s on %s (%s%s - %s)\n",
+				       "CE %s on %s (%s %s - %s)\n",
 				       msg, label, location,
 				       detail, other_detail);
 		else
 			edac_mc_printk(mci, KERN_WARNING,
-				       "CE %s on %s (%s%s)\n",
+				       "CE %s on %s (%s %s)\n",
 				       msg, label, location,
 				       detail);
 	}
@@ -953,12 +959,12 @@ static void edac_ue_error(struct mem_ctl_info *mci,
 	if (edac_mc_get_log_ue()) {
 		if (other_detail && *other_detail)
 			edac_mc_printk(mci, KERN_WARNING,
-				       "UE %s on %s (%s%s - %s)\n",
+				       "UE %s on %s (%s %s - %s)\n",
 			               msg, label, location, detail,
 				       other_detail);
 		else
 			edac_mc_printk(mci, KERN_WARNING,
-				       "UE %s on %s (%s%s)\n",
+				       "UE %s on %s (%s %s)\n",
 			               msg, label, location, detail);
 	}
 
@@ -975,6 +981,27 @@ static void edac_ue_error(struct mem_ctl_info *mci,
 }
 
 #define OTHER_LABEL " or "
+
+/**
+ * edac_mc_handle_error - reports a memory event to userspace
+ *
+ * @type:		severity of the error (CE/UE/Fatal)
+ * @mci:		a struct mem_ctl_info pointer
+ * @page_frame_number:	mem page where the error occurred
+ * @offset_in_page:	offset of the error inside the page
+ * @syndrome:		ECC syndrome
+ * @layer0:		Memory layer0 position
+ * @layer1:		Memory layer2 position
+ * @layer2:		Memory layer3 position
+ * @msg:		Message meaningful to the end users that
+ *			explains the event
+ * @other_detail:	Technical details about the event that
+ *			may help hardware manufacturers and
+ *			EDAC developers to analyse the event
+ * @arch_log:		Architecture-specific struct that can
+ *			be used to add extended information to the
+ *			tracepoint, like dumping MCE registers.
+ */
 void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  struct mem_ctl_info *mci,
 			  const unsigned long page_frame_number,
@@ -985,7 +1012,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  const int layer2,
 			  const char *msg,
 			  const char *other_detail,
-			  const void *mcelog)
+			  const void *arch_log)
 {
 	/* FIXME: too much for stack: move it to some pre-alocated area */
 	char detail[80], location[80];
@@ -994,8 +1021,10 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	int row = -1, chan = -1;
 	int pos[EDAC_MAX_LAYERS] = { layer0, layer1, layer2 };
 	int i;
-	u32 grain;
+	long grain;
 	bool enable_per_layer_report = false;
+	u16 error_count;	/* FIXME: make it a parameter */
+	int grain_bits;
 
 	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
@@ -1120,11 +1149,22 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			     edac_layer_name[mci->layers[i].type],
 			     pos[i]);
 	}
+	if (p > location)
+		*(p - 1) = '\0';
+
+	/* Report the error via the trace interface */
+
+	error_count = 1;	/* FIXME: allow change it */
+	grain_bits = fls_long(grain) + 1;
+	trace_mc_event(type, msg, label, error_count,
+		       mci->mc_idx, layer0, layer1, layer2,
+		       PAGES_TO_MiB(page_frame_number) | offset_in_page,
+		       grain_bits, syndrome, other_detail);
 
 	/* Memory type dependent details about the error */
 	if (type == HW_EVENT_ERR_CORRECTED) {
 		snprintf(detail, sizeof(detail),
-			"page:0x%lx offset:0x%lx grain:%d syndrome:0x%lx",
+			"page:0x%lx offset:0x%lx grain:%ld syndrome:0x%lx",
 			page_frame_number, offset_in_page,
 			grain, syndrome);
 		edac_ce_error(mci, pos, msg, location, label, detail,
@@ -1132,7 +1172,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			      page_frame_number, offset_in_page, grain);
 	} else {
 		snprintf(detail, sizeof(detail),
-			"page:0x%lx offset:0x%lx grain:%d",
+			"page:0x%lx offset:0x%lx grain:%ld",
 			page_frame_number, offset_in_page, grain);
 
 		edac_ue_error(mci, pos, msg, location, label, detail,
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
new file mode 100644
index 0000000..4f538ae
--- /dev/null
+++ b/include/ras/ras_event.h
@@ -0,0 +1,102 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ras
+#define TRACE_INCLUDE_FILE ras_event
+
+#if !defined(_TRACE_HW_EVENT_MC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_HW_EVENT_MC_H
+
+#include <linux/tracepoint.h>
+#include <linux/edac.h>
+#include <linux/ktime.h>
+
+/*
+ * Hardware Events Report
+ *
+ * Those events are generated when hardware detected a corrected or
+ * uncorrected event, and are meant to replace the current API to report
+ * errors defined on both EDAC and MCE subsystems.
+ *
+ * FIXME: Add events for handling memory errors originated from the
+ *        MCE subsystem.
+ */
+
+/*
+ * Hardware-independent Memory Controller specific events
+ */
+
+/*
+ * Default error mechanisms for Memory Controller errors (CE and UE)
+ */
+TRACE_EVENT(mc_event,
+
+	TP_PROTO(const unsigned int err_type,
+		 const char *error_msg,
+		 const char *label,
+		 const int error_count,
+		 const u8 mc_index,
+		 const s8 layer0,
+		 const s8 layer1,
+		 const s8 layer2,
+		 unsigned long address,
+		 const int grain_bits,
+		 unsigned long syndrome,
+		 const char *driver_detail),
+
+	TP_ARGS(err_type, error_msg, label, error_count, mc_index,
+		layer0, layer1, layer2, address, grain_bits, syndrome,
+		driver_detail),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	error_type		)
+		__string(	msg,		error_msg		)
+		__string(	label,		label			)
+		__field(	u16,		error_count		)
+		__field(	u8,		mc_index		)
+		__field(	s8,		top_layer		)
+		__field(	s8,		middle_layer		)
+		__field(	s8,		lower_layer		)
+		__field(	long,		address			)
+		__field(	u8,		grain_bits		)
+		__field(	long,		syndrome		)
+		__string(	driver_detail,	driver_detail		)
+	),
+
+	TP_fast_assign(
+		__entry->error_type		= err_type;
+		__assign_str(msg, error_msg);
+		__assign_str(label, label);
+		__entry->error_count		= error_count;
+		__entry->mc_index		= mc_index;
+		__entry->top_layer		= layer0;
+		__entry->middle_layer		= layer1;
+		__entry->lower_layer		= layer2;
+		__entry->address		= address;
+		__entry->grain_bits		= grain_bits;
+		__entry->syndrome		= syndrome;
+		__assign_str(driver_detail, driver_detail);
+	),
+
+	TP_printk("%d %s error%s:%s%s on memory stick %s (mc:%d location:%d:%d:%d address:0x%08lx grain:%d syndrome:0x%08lx%s%s)",
+		  __entry->error_count,
+		  (__entry->error_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
+			((__entry->error_type == HW_EVENT_ERR_FATAL) ?
+			"Fatal" : "Uncorrected"),
+		  __entry->error_count > 1 ? "s" : "",
+		  ((char *)__get_str(msg))[0] ? " " : "",
+		  __get_str(msg),
+		  __get_str(label),
+		  __entry->mc_index,
+		  __entry->top_layer,
+		  __entry->middle_layer,
+		  __entry->lower_layer,
+		  __entry->address,
+		  1 << __entry->grain_bits,
+		  __entry->syndrome,
+		  ((char *)__get_str(driver_detail))[0] ? " " : "",
+		  __get_str(driver_detail))
+);
+
+#endif /* _TRACE_HW_EVENT_MC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.10.2

