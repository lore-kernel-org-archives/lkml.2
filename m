Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2AZXFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:05:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab2AZXFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:05:22 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] events/hw_event: Create a Hardware Events Report Mecanism (HERM)
Date: Thu, 26 Jan 2012 21:05:06 -0200
Message-Id: <1327619108-23316-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <20110324223907.GA10498@liondog.tnic>
References: <20110324223907.GA10498@liondog.tnic>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a trace class for handle hardware events

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

In order to provide a proper hardware event subsystem, let's
encapsulate hardware events into a common trace facility, and
make both edac and mce drivers to use it. After that, common
facilities can be moved into a new core for hardware events
reporting subsystem. This patch is the first of a series, and just
touches at mce.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c          |   32 ++++
 include/trace/events/hw_event.h |  322 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 354 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/hw_event.h

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index d69144a..2b8382e 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -34,6 +34,9 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/hw_event.h>
+
 /* lock to memory controller's control array */
 static DEFINE_MUTEX(mem_ctls_mutex);
 static LIST_HEAD(mc_devices);
@@ -224,6 +227,9 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
 	 * which will perform kobj unregistration and the actual free
 	 * will occur during the kobject callback operation
 	 */
+
+	trace_hw_event_init("mce", (unsigned)edac_index);
+
 	return mci;
 }
 EXPORT_SYMBOL_GPL(edac_mc_alloc);
@@ -685,6 +691,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 	/* FIXME - maybe make panic on INTERNAL ERROR an option */
 	if (row >= mci->nr_csrows || row < 0) {
 		/* something is wrong */
+		trace_mc_out_of_range(mci, "CE", "row", row, 0, mci->nr_csrows);
 		edac_mc_printk(mci, KERN_ERR,
 			"INTERNAL ERROR: row out of range "
 			"(%d >= %d)\n", row, mci->nr_csrows);
@@ -694,6 +701,8 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 
 	if (channel >= mci->csrows[row].nr_channels || channel < 0) {
 		/* something is wrong */
+		trace_mc_out_of_range(mci, "CE", "channel", channel,
+				      0, mci->csrows[row].nr_channels);
 		edac_mc_printk(mci, KERN_ERR,
 			"INTERNAL ERROR: channel out of range "
 			"(%d >= %d)\n", channel,
@@ -702,6 +711,9 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 		return;
 	}
 
+	trace_mc_corrected_error(mci, page_frame_number, offset_in_page,
+				syndrome, row, channel, msg);
+
 	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
@@ -737,6 +749,7 @@ EXPORT_SYMBOL_GPL(edac_mc_handle_ce);
 
 void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci, const char *msg)
 {
+	trace_mc_corrected_error_no_info(mci, msg);
 	if (edac_mc_get_log_ce())
 		edac_mc_printk(mci, KERN_WARNING,
 			"CE - no information available: %s\n", msg);
@@ -761,6 +774,8 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
 	/* FIXME - maybe make panic on INTERNAL ERROR an option */
 	if (row >= mci->nr_csrows || row < 0) {
 		/* something is wrong */
+		trace_mc_out_of_range(mci, "UE", "row", row,
+				      0, mci->nr_csrows);
 		edac_mc_printk(mci, KERN_ERR,
 			"INTERNAL ERROR: row out of range "
 			"(%d >= %d)\n", row, mci->nr_csrows);
@@ -781,6 +796,8 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
 		pos += chars;
 	}
 
+	trace_mc_uncorrected_error(mci, page_frame_number, offset_in_page,
+				row, msg, labels);
 	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
 			"UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
@@ -801,6 +818,7 @@ EXPORT_SYMBOL_GPL(edac_mc_handle_ue);
 
 void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci, const char *msg)
 {
+	trace_mc_uncorrected_error_no_info(mci, msg);
 	if (edac_mc_get_panic_on_ue())
 		panic("EDAC MC%d: Uncorrected Error", mci->mc_idx);
 
@@ -828,6 +846,9 @@ void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
 
 	if (csrow >= mci->nr_csrows) {
 		/* something is wrong */
+
+		trace_mc_out_of_range(mci, "UE FBDIMM", "row", csrow,
+				      0, mci->nr_csrows);
 		edac_mc_printk(mci, KERN_ERR,
 			"INTERNAL ERROR: row out of range (%d >= %d)\n",
 			csrow, mci->nr_csrows);
@@ -837,6 +858,8 @@ void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
 
 	if (channela >= mci->csrows[csrow].nr_channels) {
 		/* something is wrong */
+		trace_mc_out_of_range(mci, "UE FBDIMM", "channel-a", channela,
+				      0, mci->csrows[csrow].nr_channels);
 		edac_mc_printk(mci, KERN_ERR,
 			"INTERNAL ERROR: channel-a out of range "
 			"(%d >= %d)\n",
@@ -847,6 +870,8 @@ void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
 
 	if (channelb >= mci->csrows[csrow].nr_channels) {
 		/* something is wrong */
+		trace_mc_out_of_range(mci, "UE FBDIMM", "channel-b", channelb,
+				      0, mci->csrows[csrow].nr_channels);
 		edac_mc_printk(mci, KERN_ERR,
 			"INTERNAL ERROR: channel-b out of range "
 			"(%d >= %d)\n",
@@ -866,6 +891,8 @@ void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
 	chars = snprintf(pos, len + 1, "-%s",
 			 mci->csrows[csrow].channels[channelb].label);
 
+	trace_mc_uncorrected_error_fbd(mci, csrow, channela, channelb,
+				       msg, labels);
 	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
 			"UE row %d, channel-a= %d channel-b= %d "
@@ -890,6 +917,8 @@ void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
 	/* Ensure boundary values */
 	if (csrow >= mci->nr_csrows) {
 		/* something is wrong */
+		trace_mc_out_of_range(mci, "CE FBDIMM", "row", csrow,
+				      0, mci->nr_csrows);
 		edac_mc_printk(mci, KERN_ERR,
 			"INTERNAL ERROR: row out of range (%d >= %d)\n",
 			csrow, mci->nr_csrows);
@@ -898,6 +927,8 @@ void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
 	}
 	if (channel >= mci->csrows[csrow].nr_channels) {
 		/* something is wrong */
+		trace_mc_out_of_range(mci, "UE FBDIMM", "channel", channel,
+				      0, mci->csrows[csrow].nr_channels);
 		edac_mc_printk(mci, KERN_ERR,
 			"INTERNAL ERROR: channel out of range (%d >= %d)\n",
 			channel, mci->csrows[csrow].nr_channels);
@@ -905,6 +936,7 @@ void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
 		return;
 	}
 
+	trace_mc_corrected_error_fbd(mci, csrow, channel, msg);
 	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
new file mode 100644
index 0000000..a46ac61
--- /dev/null
+++ b/include/trace/events/hw_event.h
@@ -0,0 +1,322 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM hw_event
+
+#if !defined(_TRACE_HW_EVENT_MC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_HW_EVENT_MC_H
+
+#include <linux/tracepoint.h>
+#include <linux/edac.h>
+
+/*
+ * Hardware Anomaly Report Mecanism (HARM) events
+ *
+ * Those events are generated when hardware detected a corrected or
+ * uncorrected event, and are meant to replace the current API to report
+ * errors defined on both EDAC and MCE subsystems.
+ */
+
+DECLARE_EVENT_CLASS(hw_event_class,
+	TP_PROTO(const char *type, unsigned int instance),
+	TP_ARGS(type, instance),
+
+	TP_STRUCT__entry(
+		__field(	const char *,	type			)
+		__field(	unsigned int,	instance		)
+	),
+
+	TP_fast_assign(
+		__entry->type	= type;
+		__entry->instance = instance;
+	),
+
+	TP_printk("Initialized %s#%d\n",
+		__entry->type,
+		__entry->instance)
+);
+
+/*
+ * This event indicates that a hardware collection mechanism is started
+ */
+DEFINE_EVENT(hw_event_class, hw_event_init,
+
+	TP_PROTO(const char *type, unsigned int instance),
+
+	TP_ARGS(type, instance)
+);
+
+
+/*
+ * Memory Controller specific events
+ */
+
+/*
+ * Default error mechanisms for Memory Controller errors (CE and UE)
+ */
+TRACE_EVENT(mc_corrected_error,
+
+	TP_PROTO(struct mem_ctl_info *mci,
+		unsigned long page_frame_number,
+		unsigned long offset_in_page, unsigned long syndrome,
+		int row, int channel, const char *msg),
+
+	TP_ARGS(mci, page_frame_number, offset_in_page, syndrome, row,
+		channel, msg),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	mc_index		)
+		__field(	unsigned long,	page_frame_number	)
+		__field(	unsigned long,	offset_in_page		)
+		__field(	u32,		grain			)
+		__field(	unsigned long,	syndrome		)
+		__field(	int,		row			)
+		__field(	int,		channel			)
+		__field(	const char *,	label			)
+		__field(	const char *,	msg			)
+	),
+
+	TP_fast_assign(
+		__entry->mc_index		= mci->mc_idx;
+		__entry->page_frame_number	= page_frame_number;
+		__entry->offset_in_page		= offset_in_page;
+		__entry->grain			= mci->csrows[row].grain;
+		__entry->syndrome		= syndrome;
+		__entry->row			= row;
+		__entry->channel		= channel;
+		__entry->label			= mci->csrows[row].channels[channel].label;
+		__entry->msg			= msg;
+	),
+
+	TP_printk(HW_ERR "mce#%d: Corrected error %s on label \"%s\" "
+			 "(page 0x%lux, offset 0x%lux, grain %ud, "
+			 "syndrome 0x%lux, row %d, channel %d)\n",
+		__entry->mc_index,
+		__entry->msg,
+		__entry->label,
+		__entry->page_frame_number,
+		__entry->offset_in_page,
+		__entry->grain,
+		__entry->syndrome,
+		__entry->row,
+		__entry->channel)
+);
+
+TRACE_EVENT(mc_uncorrected_error,
+
+	TP_PROTO(struct mem_ctl_info *mci,
+		unsigned long page_frame_number,
+		unsigned long offset_in_page,
+		int row, const char *msg, const char *label),
+
+	TP_ARGS(mci, page_frame_number, offset_in_page,
+		row, msg, label),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	mc_index		)
+		__field(	unsigned long,	page_frame_number	)
+		__field(	unsigned long,	offset_in_page		)
+		__field(	u32,		grain			)
+		__field(	int,		row			)
+		__field(	const char *,	msg			)
+		__field(	const char *,	label			)
+	),
+
+	TP_fast_assign(
+		__entry->mc_index		= mci->mc_idx;
+		__entry->page_frame_number	= page_frame_number;
+		__entry->offset_in_page		= offset_in_page;
+		__entry->grain			= mci->csrows[row].grain;
+		__entry->row			= row;
+		__entry->msg			= msg;
+		__entry->label			= label;
+	),
+
+	TP_printk(HW_ERR "mce#%d: Uncorrected error %s on label \"%s\""
+			 "(page 0x%lux, offset 0x%lux, grain %ud, row %d)\n",
+		__entry->mc_index,
+		__entry->msg,
+		__entry->label,
+		__entry->page_frame_number,
+		__entry->offset_in_page,
+		__entry->grain,
+		__entry->row)
+);
+
+
+/*
+ * Fully-Buffered memory hardware in general don't provide syndrome/grain/row
+ * information for all types of errors. So, we need to either have another
+ * trace event or add a bitmapped field to indicate that some info are not
+ * provided and use the previously-declared event. It seemed easier and less
+ * confusing to create a different event for such cases
+ */
+TRACE_EVENT(mc_corrected_error_fbd,
+
+	TP_PROTO(struct mem_ctl_info *mci,
+		int row, int channel, const char *msg),
+
+	TP_ARGS(mci, row, channel, msg),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	mc_index		)
+		__field(	int,		row			)
+		__field(	int,		channel	        	)
+		__field(	const char *,	label			)
+		__field(	const char *,	msg			)
+	),
+
+	TP_fast_assign(
+		__entry->mc_index		= mci->mc_idx;
+		__entry->row			= row;
+		__entry->channel		= channel;
+		__entry->label			= mci->csrows[row].channels[channel].label;
+		__entry->msg			= msg;
+	),
+
+	TP_printk(HW_ERR "mce#%d: Corrected Error %s on label \"%s\" "
+			 "(row %d, channel %d)\n",
+		__entry->mc_index,
+		__entry->msg,
+		__entry->label,
+		__entry->row,
+		__entry->channel)
+);
+
+TRACE_EVENT(mc_uncorrected_error_fbd,
+
+	TP_PROTO(struct mem_ctl_info *mci,
+		int row, int channela, int channelb,
+		const char *msg, const char *label),
+
+	TP_ARGS(mci, row, channela, channelb, msg, label),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	mc_index		)
+		__field(	int,		row			)
+		__field(	int,		channela		)
+		__field(	int,		channelb		)
+		__field(	const char *,	msg			)
+		__field(	const char *,	label			)
+	),
+
+	TP_fast_assign(
+		__entry->mc_index		= mci->mc_idx;
+		__entry->row			= row;
+		__entry->channela		= channela;
+		__entry->channelb		= channelb;
+		__entry->msg			= msg;
+		__entry->label			= label;
+	),
+
+	TP_printk(HW_ERR "mce#%d: Uncorrected Error %s on label \"%s\" "
+			 "(row %d, channels: %d, %d)\n",
+		__entry->mc_index,
+		__entry->msg,
+		__entry->label,
+		__entry->row,
+		__entry->channela,
+		__entry->channelb)
+);
+
+/*
+ * The Memory controller driver needs to discover the memory topology, in
+ * order to associate a hardware error with the memory label. If, for any
+ * reason, it receives an error for a channel or row that are not supposed
+ * to be there, an error event needs to be generated to indicate:
+ *	- that a Corrected or Uncorrected error was received;
+ *	- that the driver has a bug and, for that particular hardware, was
+ *	  not capable of detecting the hardware architecture
+ * If one of such errors is ever received, a bug to the kernel driver must
+ * be filled.
+ */
+
+TRACE_EVENT(mc_out_of_range,
+	TP_PROTO(struct mem_ctl_info *mci, const char *type, const char *field,
+		int invalid_val, int min, int max),
+
+	TP_ARGS(mci, type, field, invalid_val, min, max),
+
+	TP_STRUCT__entry(
+		__field(	const char *,	type			)
+		__field(	const char *,	field			)
+		__field(	unsigned int,	mc_index		)
+		__field(	int,		invalid_val		)
+		__field(	int,		min			)
+		__field(	int,		max			)
+	),
+
+	TP_fast_assign(
+		__entry->type			= type;
+		__entry->field			= field;
+		__entry->mc_index		= mci->mc_idx;
+		__entry->invalid_val		= invalid_val;
+		__entry->min			= min;
+		__entry->max			= max;
+	),
+
+	TP_printk(HW_ERR "mce#%d %s: %s=%d is not between %d and %d\n",
+		__entry->mc_index,
+		__entry->type,
+		__entry->field,
+		__entry->invalid_val,
+		__entry->min,
+		__entry->max)
+);
+
+/*
+ * On some cases, a corrected or uncorrected error was detected, but it
+ * couldn't be properly handled, or because another error overrided the
+ * error registers that details the error or because of some internal problem
+ * on the driver. Those events bellow are meant for those error types.
+ */
+TRACE_EVENT(mc_corrected_error_no_info,
+	TP_PROTO(struct mem_ctl_info *mci, const char *msg),
+
+	TP_ARGS(mci, msg),
+
+	TP_STRUCT__entry(
+		__field(	const char *,	msg			)
+		__field(	unsigned int,	mc_index		)
+	),
+
+	TP_fast_assign(
+		__entry->msg			= msg;
+		__entry->mc_index		= mci->mc_idx;
+	),
+
+	TP_printk(HW_ERR "mce#%d: Corrected Error: %s\n",
+		__entry->mc_index,
+		__entry->msg)
+);
+
+TRACE_EVENT(mc_uncorrected_error_no_info,
+	TP_PROTO(struct mem_ctl_info *mci, const char *msg),
+
+	TP_ARGS(mci, msg),
+
+	TP_STRUCT__entry(
+		__field(	const char *,	msg			)
+		__field(	unsigned int,	mc_index		)
+	),
+
+	TP_fast_assign(
+		__entry->msg			= msg;
+		__entry->mc_index		= mci->mc_idx;
+	),
+
+	TP_printk(HW_ERR "mce#%d: Uncorrected Error: %s\n",
+		__entry->mc_index,
+		__entry->msg)
+);
+
+
+
+/*
+ * MCE Events placeholder. Please add non-memory events that come from the
+ * MCE driver here
+ */
+
+
+#endif /* _TRACE_HW_EVENT_MC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.8

