Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935408Ab2JaRrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:47:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759516Ab2JaRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:45:33 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC EDAC/GHES 2/3] edac: add support for raw error reports
Date: Wed, 31 Oct 2012 15:44:54 -0200
Message-Id: <55d0c9167fc30dcb6458467d01f657d74499b00c.1351705248.git.mchehab@redhat.com>
In-Reply-To: <cover.1351705248.git.mchehab@redhat.com>
References: <cover.1351705248.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That allows APEI GHES driver to report errors directly, using
the EDAC error report API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_core.h |  17 ++++++++
 drivers/edac/edac_mc.c   | 109 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 99 insertions(+), 27 deletions(-)

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index db30694..d936958 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -453,6 +453,23 @@ extern struct mem_ctl_info *find_mci_by_dev(struct device *dev);
 extern struct mem_ctl_info *edac_mc_del_mc(struct device *dev);
 extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
 				      unsigned long page);
+
+void edac_raw_mc_handle_error(const enum hw_event_mc_err_type type,
+			  struct mem_ctl_info *mci,
+			  long grain,
+			  const u16 error_count,
+			  const int top_layer,
+			  const int mid_layer,
+			  const int low_layer,
+			  const unsigned long page_frame_number,
+			  const unsigned long offset_in_page,
+			  const unsigned long syndrome,
+			  const char *msg,
+			  const char *location,
+			  const char *label,
+			  const char *other_detail,
+			  const bool enable_per_layer_report);
+
 void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  struct mem_ctl_info *mci,
 			  const u16 error_count,
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index d4d891a..d3e9341 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1079,6 +1079,81 @@ static void edac_ue_error(struct mem_ctl_info *mci,
 #define OTHER_LABEL " or "
 
 /**
+ * edac_raw_mc_handle_error - reports a memory event to userspace without doing
+ *			      anything to discover the error location
+ *
+ * @type:		severity of the error (CE/UE/Fatal)
+ * @mci:		a struct mem_ctl_info pointer
+ * @grain:		error granularity
+ * @error_count:	Number of errors of the same type
+ * @top_layer:		Memory layer[0] position
+ * @mid_layer:		Memory layer[1] position
+ * @low_layer:		Memory layer[2] position
+ * @page_frame_number:	mem page where the error occurred
+ * @offset_in_page:	offset of the error inside the page
+ * @syndrome:		ECC syndrome
+ * @msg:		Message meaningful to the end users that
+ *			explains the event\
+ * @location:		location of the error, like "csrow:0 channel:1"
+ * @label:		DIMM labels for the affected memory(ies)
+ * @other_detail:	Technical details about the event that
+ *			may help hardware manufacturers and
+ *			EDAC developers to analyse the event
+ * @enable_per_layer_report: should it increment per-layer error counts?
+ *
+ * This raw function is used internally by edac_mc_handle_error(). It should
+ * only be called directly when the hardware error come directly from BIOS,
+ * like in the case of APEI GHES driver.
+ */
+void edac_raw_mc_handle_error(const enum hw_event_mc_err_type type,
+			  struct mem_ctl_info *mci,
+			  long grain,
+			  const u16 error_count,
+			  const int top_layer,
+			  const int mid_layer,
+			  const int low_layer,
+			  const unsigned long page_frame_number,
+			  const unsigned long offset_in_page,
+			  const unsigned long syndrome,
+			  const char *msg,
+			  const char *location,
+			  const char *label,
+			  const char *other_detail,
+			  const bool enable_per_layer_report)
+{
+	char detail[80];
+	u8 grain_bits;
+	int pos[EDAC_MAX_LAYERS] = { top_layer, mid_layer, low_layer };
+
+	/* Report the error via the trace interface */
+
+	grain_bits = fls_long(grain) + 1;
+	trace_mc_event(type, msg, label, error_count,
+		       mci->mc_idx, top_layer, mid_layer, low_layer,
+		       PAGES_TO_MiB(page_frame_number) | offset_in_page,
+		       grain_bits, syndrome, other_detail);
+
+	/* Memory type dependent details about the error */
+	if (type == HW_EVENT_ERR_CORRECTED) {
+		snprintf(detail, sizeof(detail),
+			 "page:0x%lx offset:0x%lx grain:%ld syndrome:0x%lx",
+			 page_frame_number, offset_in_page,
+			 grain, syndrome);
+		edac_ce_error(mci, error_count, pos, msg, location, label,
+			      detail, other_detail, enable_per_layer_report,
+			      page_frame_number, offset_in_page, grain);
+	} else {
+		snprintf(detail, sizeof(detail),
+			"page:0x%lx offset:0x%lx grain:%ld",
+			page_frame_number, offset_in_page, grain);
+
+		edac_ue_error(mci, error_count, pos, msg, location, label,
+			      detail, other_detail, enable_per_layer_report);
+	}
+}
+EXPORT_SYMBOL_GPL(edac_raw_mc_handle_error);
+
+/**
  * edac_mc_handle_error - reports a memory event to userspace
  *
  * @type:		severity of the error (CE/UE/Fatal)
@@ -1109,7 +1184,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  const char *other_detail)
 {
 	/* FIXME: too much for stack: move it to some pre-alocated area */
-	char detail[80], location[80];
+	char location[80];
 	char label[(EDAC_MC_LABEL_LEN + 1 + sizeof(OTHER_LABEL)) * mci->tot_dimms];
 	char *p;
 	int row = -1, chan = -1;
@@ -1117,7 +1192,6 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	int i;
 	long grain;
 	bool enable_per_layer_report = false;
-	u8 grain_bits;
 
 	edac_dbg(3, "MC%d\n", mci->mc_idx);
 
@@ -1242,30 +1316,11 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	if (p > location)
 		*(p - 1) = '\0';
 
-	/* Report the error via the trace interface */
-
-	grain_bits = fls_long(grain) + 1;
-	trace_mc_event(type, msg, label, error_count,
-		       mci->mc_idx, top_layer, mid_layer, low_layer,
-		       PAGES_TO_MiB(page_frame_number) | offset_in_page,
-		       grain_bits, syndrome, other_detail);
-
-	/* Memory type dependent details about the error */
-	if (type == HW_EVENT_ERR_CORRECTED) {
-		snprintf(detail, sizeof(detail),
-			"page:0x%lx offset:0x%lx grain:%ld syndrome:0x%lx",
-			page_frame_number, offset_in_page,
-			grain, syndrome);
-		edac_ce_error(mci, error_count, pos, msg, location, label,
-			      detail, other_detail, enable_per_layer_report,
-			      page_frame_number, offset_in_page, grain);
-	} else {
-		snprintf(detail, sizeof(detail),
-			"page:0x%lx offset:0x%lx grain:%ld",
-			page_frame_number, offset_in_page, grain);
-
-		edac_ue_error(mci, error_count, pos, msg, location, label,
-			      detail, other_detail, enable_per_layer_report);
-	}
+	edac_raw_mc_handle_error(type, mci, grain, error_count,
+				 top_layer, mid_layer, low_layer,
+				 page_frame_number, offset_in_page,
+				 syndrome,
+				 msg, location, label, other_detail,
+				 enable_per_layer_report);
 }
 EXPORT_SYMBOL_GPL(edac_mc_handle_error);
-- 
1.7.11.7

