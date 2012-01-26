Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab2AZXFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:05:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab2AZXFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:05:22 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] hw_event: Consolidate uncorrected/corrected error msgs into one
Date: Thu, 26 Jan 2012 21:05:08 -0200
Message-Id: <1327619108-23316-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327619108-23316-1-git-send-email-mchehab@redhat.com>
References: <20110324223907.GA10498@liondog.tnic>
 <1327619108-23316-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an RFC patch, consolidating two trace calls into one.
Not sure if this is the better thing to do, but it simplifies
the error tracepoint, while still keeping the technical details
that may be needed by someone debugging the driver or for
the vendors to double-check what's happening inside the system.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c          |   51 +++++++--
 include/linux/edac.h            |    6 +
 include/trace/events/hw_event.h |  231 ++++-----------------------------------
 3 files changed, 68 insertions(+), 220 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 2b8382e..5038239 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -685,6 +685,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 		int row, int channel, const char *msg)
 {
 	unsigned long remapped_page;
+	char detail[80];
 
 	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
@@ -711,8 +712,15 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 		return;
 	}
 
-	trace_mc_corrected_error(mci, page_frame_number, offset_in_page,
-				syndrome, row, channel, msg);
+	/* Memory type dependent details about the error */
+	snprintf(detail, sizeof(detail),
+		 " (page 0x%lx, offset 0x%lx, grain %d, "
+		 "syndrome 0x%lx, row %d, channel %d)\n",
+		 page_frame_number, offset_in_page,
+		 mci->csrows[row].grain, syndrome, row, channel);
+	trace_mc_error(HW_EVENT_ERR_CORRECTED, mci->mc_idx,
+		       mci->csrows[row].channels[channel].label,
+		       msg, detail);
 
 	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
@@ -749,7 +757,8 @@ EXPORT_SYMBOL_GPL(edac_mc_handle_ce);
 
 void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci, const char *msg)
 {
-	trace_mc_corrected_error_no_info(mci, msg);
+	trace_mc_error(HW_EVENT_ERR_CORRECTED, mci->mc_idx,
+		       "unknown", msg, "");
 	if (edac_mc_get_log_ce())
 		edac_mc_printk(mci, KERN_WARNING,
 			"CE - no information available: %s\n", msg);
@@ -768,6 +777,7 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
 	char *pos = labels;
 	int chan;
 	int chars;
+	char detail[80];
 
 	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
 
@@ -796,8 +806,15 @@ void edac_mc_handle_ue(struct mem_ctl_info *mci,
 		pos += chars;
 	}
 
-	trace_mc_uncorrected_error(mci, page_frame_number, offset_in_page,
-				row, msg, labels);
+	/* Memory type dependent details about the error */
+	snprintf(detail, sizeof(detail),
+		 "page 0x%lx, offset 0x%lx, grain %d, row %d ",
+		 page_frame_number, offset_in_page,
+	         mci->csrows[row].grain, row);
+	trace_mc_error(HW_EVENT_ERR_UNCORRECTED, mci->mc_idx,
+		       labels,
+		       msg, detail);
+
 	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
 			"UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
@@ -818,7 +835,8 @@ EXPORT_SYMBOL_GPL(edac_mc_handle_ue);
 
 void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci, const char *msg)
 {
-	trace_mc_uncorrected_error_no_info(mci, msg);
+	trace_mc_error(HW_EVENT_ERR_UNCORRECTED, mci->mc_idx,
+		       "unknown", msg, "");
 	if (edac_mc_get_panic_on_ue())
 		panic("EDAC MC%d: Uncorrected Error", mci->mc_idx);
 
@@ -843,6 +861,7 @@ void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
 	char labels[len + 1];
 	char *pos = labels;
 	int chars;
+	char detail[80];
 
 	if (csrow >= mci->nr_csrows) {
 		/* something is wrong */
@@ -891,8 +910,13 @@ void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
 	chars = snprintf(pos, len + 1, "-%s",
 			 mci->csrows[csrow].channels[channelb].label);
 
-	trace_mc_uncorrected_error_fbd(mci, csrow, channela, channelb,
-				       msg, labels);
+	/* Memory type dependent details about the error */
+	snprintf(detail, sizeof(detail),
+		 "row %d, channel-a= %d channel-b= %d ",
+		 csrow, channela, channelb);
+	trace_mc_error(HW_EVENT_ERR_UNCORRECTED, mci->mc_idx,
+		       labels,
+		       msg, detail);
 	if (edac_mc_get_log_ue())
 		edac_mc_printk(mci, KERN_EMERG,
 			"UE row %d, channel-a= %d channel-b= %d "
@@ -913,7 +937,7 @@ EXPORT_SYMBOL(edac_mc_handle_fbd_ue);
 void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
 			unsigned int csrow, unsigned int channel, char *msg)
 {
-
+	char detail[80];
 	/* Ensure boundary values */
 	if (csrow >= mci->nr_csrows) {
 		/* something is wrong */
@@ -936,7 +960,14 @@ void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
 		return;
 	}
 
-	trace_mc_corrected_error_fbd(mci, csrow, channel, msg);
+	/* Memory type dependent details about the error */
+	snprintf(detail, sizeof(detail),
+		 "(row %d, channel %d)\n",
+		 csrow, channel);
+	trace_mc_error(HW_EVENT_ERR_CORRECTED, mci->mc_idx,
+		       mci->csrows[csrow].channels[channel].label,
+		       msg, detail);
+
 	if (edac_mc_get_log_ce())
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 055b248..3ba99d7 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -66,6 +66,12 @@ enum dev_type {
 #define DEV_FLAG_X32		BIT(DEV_X32)
 #define DEV_FLAG_X64		BIT(DEV_X64)
 
+enum hw_event_mc_err_type {
+	HW_EVENT_ERR_CORRECTED,
+	HW_EVENT_ERR_UNCORRECTED,
+	HW_EVENT_ERR_FATAL,
+};
+
 /* memory types */
 enum mem_type {
 	MEM_EMPTY = 0,		/* Empty csrow */
diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
index 85fca0d..fee7ed2 100644
--- a/include/trace/events/hw_event.h
+++ b/include/trace/events/hw_event.h
@@ -52,183 +52,42 @@ DEFINE_EVENT(hw_event_class, hw_event_init,
 /*
  * Default error mechanisms for Memory Controller errors (CE and UE)
  */
-TRACE_EVENT(mc_corrected_error,
+TRACE_EVENT(mc_error,
 
-	TP_PROTO(struct mem_ctl_info *mci,
-		unsigned long page_frame_number,
-		unsigned long offset_in_page, unsigned long syndrome,
-		int row, int channel, const char *msg),
+	TP_PROTO(unsigned int err_type,
+		 unsigned int mc_index,
+		 const char *label,
+		 const char *msg,
+		 const char *detail),
 
-	TP_ARGS(mci, page_frame_number, offset_in_page, syndrome, row,
-		channel, msg),
+	TP_ARGS(err_type, mc_index, label, msg, detail),
 
 	TP_STRUCT__entry(
+		__field(	unsigned int,	err_type		)
 		__field(	unsigned int,	mc_index		)
-		__field(	unsigned long,	page_frame_number	)
-		__field(	unsigned long,	offset_in_page		)
-		__field(	u32,		grain			)
-		__field(	unsigned long,	syndrome		)
-		__field(	int,		row			)
-		__field(	int,		channel			)
-		__string(	label,		mci->csrows[row].channels[channel].label)
-		__string(	msg,		msg			)
-	),
-
-	TP_fast_assign(
-		__entry->mc_index		= mci->mc_idx;
-		__entry->page_frame_number	= page_frame_number;
-		__entry->offset_in_page		= offset_in_page;
-		__entry->grain			= mci->csrows[row].grain;
-		__entry->syndrome		= syndrome;
-		__entry->row			= row;
-		__entry->channel		= channel;
-		__assign_str(label, mci->csrows[row].channels[channel].label);
-		__assign_str(msg, msg);
-	),
-
-	TP_printk(HW_ERR "mce#%d: Corrected error %s on label \"%s\" "
-			 "(page 0x%lux, offset 0x%lux, grain %ud, "
-			 "syndrome 0x%lux, row %d, channel %d)\n",
-		__entry->mc_index,
-		__get_str(msg),
-		__get_str(label),
-		__entry->page_frame_number,
-		__entry->offset_in_page,
-		__entry->grain,
-		__entry->syndrome,
-		__entry->row,
-		__entry->channel)
-);
-
-TRACE_EVENT(mc_uncorrected_error,
-
-	TP_PROTO(struct mem_ctl_info *mci,
-		unsigned long page_frame_number,
-		unsigned long offset_in_page,
-		int row, const char *msg, const char *label),
-
-	TP_ARGS(mci, page_frame_number, offset_in_page,
-		row, msg, label),
-
-	TP_STRUCT__entry(
-		__field(	unsigned int,	mc_index		)
-		__field(	unsigned long,	page_frame_number	)
-		__field(	unsigned long,	offset_in_page		)
-		__field(	u32,		grain			)
-		__field(	int,		row			)
-		__string(	msg,		msg			)
 		__string(	label,		label			)
-	),
-
-	TP_fast_assign(
-		__entry->mc_index		= mci->mc_idx;
-		__entry->page_frame_number	= page_frame_number;
-		__entry->offset_in_page		= offset_in_page;
-		__entry->grain			= mci->csrows[row].grain;
-		__entry->row			= row;
-		__assign_str(msg, msg);
-		__assign_str(label, label);
-	),
-
-	TP_printk(HW_ERR "mce#%d: Uncorrected error %s on label \"%s\""
-			 "(page 0x%lux, offset 0x%lux, grain %ud, row %d)\n",
-		__entry->mc_index,
-		__get_str(msg),
-		__get_str(label),
-		__entry->page_frame_number,
-		__entry->offset_in_page,
-		__entry->grain,
-		__entry->row)
-);
-
-
-/*
- * Fully-Buffered memory hardware in general don't provide syndrome/grain/row
- * information for all types of errors. So, we need to either have another
- * trace event or add a bitmapped field to indicate that some info are not
- * provided and use the previously-declared event. It seemed easier and less
- * confusing to create a different event for such cases
- */
-TRACE_EVENT(mc_corrected_error_fbd,
-
-	TP_PROTO(struct mem_ctl_info *mci,
-		int row, int channel, const char *msg),
-
-	TP_ARGS(mci, row, channel, msg),
-
-	TP_STRUCT__entry(
-		__field(	unsigned int,	mc_index		)
-		__field(	int,		row			)
-		__field(	int,		channel	        	)
-		__string(	label,		mci->csrows[row].channels[channel].label)
 		__string(	msg,		msg			)
+		__string(	detail,		detail			)
 	),
 
 	TP_fast_assign(
-		__entry->mc_index		= mci->mc_idx;
-		__entry->row			= row;
-		__entry->channel		= channel;
-		__assign_str(label, mci->csrows[row].channels[channel].label);
-		__assign_str(msg, msg);
-	),
-
-	TP_printk(HW_ERR "mce#%d: Corrected Error %s on label \"%s\" "
-			 "(row %d, channel %d)\n",
-		__entry->mc_index,
-		__get_str(msg),
-		__get_str(label),
-		__entry->row,
-		__entry->channel)
-);
-
-TRACE_EVENT(mc_uncorrected_error_fbd,
-
-	TP_PROTO(struct mem_ctl_info *mci,
-		int row, int channela, int channelb,
-		const char *msg, const char *label),
-
-	TP_ARGS(mci, row, channela, channelb, msg, label),
-
-	TP_STRUCT__entry(
-		__field(	unsigned int,	mc_index		)
-		__field(	int,		row			)
-		__field(	int,		channela		)
-		__field(	int,		channelb		)
-		__string(	msg,		msg			)
-		__string(	label,		label			)
-	),
-
-	TP_fast_assign(
-		__entry->mc_index		= mci->mc_idx;
-		__entry->row			= row;
-		__entry->channela		= channela;
-		__entry->channelb		= channelb;
-		__assign_str(msg, msg);
+		__entry->err_type		= err_type;
+		__entry->mc_index		= mc_index;
 		__assign_str(label, label);
+		__assign_str(msg, msg);
+		__assign_str(detail, detail);
 	),
 
-	TP_printk(HW_ERR "mce#%d: Uncorrected Error %s on label \"%s\" "
-			 "(row %d, channels: %d, %d)\n",
-		__entry->mc_index,
-		__get_str(msg),
-		__get_str(label),
-		__entry->row,
-		__entry->channela,
-		__entry->channelb)
+	TP_printk(HW_ERR "mce#%d: %s error %s on label \"%s\" %s\n",
+		  __entry->mc_index,
+		  (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
+			((__entry->err_type == HW_EVENT_ERR_FATAL) ?
+			"Fatal" : "Uncorrected"),
+		  __get_str(msg),
+		  __get_str(label),
+		  __get_str(detail))
 );
 
-/*
- * The Memory controller driver needs to discover the memory topology, in
- * order to associate a hardware error with the memory label. If, for any
- * reason, it receives an error for a channel or row that are not supposed
- * to be there, an error event needs to be generated to indicate:
- *	- that a Corrected or Uncorrected error was received;
- *	- that the driver has a bug and, for that particular hardware, was
- *	  not capable of detecting the hardware architecture
- * If one of such errors is ever received, a bug to the kernel driver must
- * be filled.
- */
-
 TRACE_EVENT(mc_out_of_range,
 	TP_PROTO(struct mem_ctl_info *mci, const char *type, const char *field,
 		int invalid_val, int min, int max),
@@ -263,54 +122,6 @@ TRACE_EVENT(mc_out_of_range,
 );
 
 /*
- * On some cases, a corrected or uncorrected error was detected, but it
- * couldn't be properly handled, or because another error overrided the
- * error registers that details the error or because of some internal problem
- * on the driver. Those events bellow are meant for those error types.
- */
-TRACE_EVENT(mc_corrected_error_no_info,
-	TP_PROTO(struct mem_ctl_info *mci, const char *msg),
-
-	TP_ARGS(mci, msg),
-
-	TP_STRUCT__entry(
-	__string(	msg,			msg			)
-		__field(	unsigned int,	mc_index		)
-	),
-
-	TP_fast_assign(
-		__assign_str(msg, msg);
-		__entry->mc_index		= mci->mc_idx;
-	),
-
-	TP_printk(HW_ERR "mce#%d: Corrected Error: %s\n",
-		__entry->mc_index,
-		__get_str(msg))
-);
-
-TRACE_EVENT(mc_uncorrected_error_no_info,
-	TP_PROTO(struct mem_ctl_info *mci, const char *msg),
-
-	TP_ARGS(mci, msg),
-
-	TP_STRUCT__entry(
-		__string(	msg,		msg			)
-		__field(	unsigned int,	mc_index		)
-	),
-
-	TP_fast_assign(
-		__assign_str(msg, msg);
-		__entry->mc_index		= mci->mc_idx;
-	),
-
-	TP_printk(HW_ERR "mce#%d: Uncorrected Error: %s\n",
-		__entry->mc_index,
-		__get_str(msg))
-);
-
-
-
-/*
  * MCE Events placeholder. Please add non-memory events that come from the
  * MCE driver here
  */
-- 
1.7.8

