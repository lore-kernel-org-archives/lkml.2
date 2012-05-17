Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965196Ab2EQV2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:28:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760165Ab2EQV2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:28:16 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v24b] RAS: Add a tracepoint for reporting memory controller events
Date: Thu, 17 May 2012 17:41:17 -0300
Message-Id: <1337287277-523-1-git-send-email-mchehab@redhat.com>
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

mc_event: (Corrected|Uncorrected|Fatal) error:[error msg] on memory stick "[label]" ([location] [edac_mc detail] [driver_detail])

Where:
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

mc_event: Corrected error:memory read on memory stick "DIMM_1A" (mc:0 channel:0 slot:0 page:0x586b6e offset:0xa66 grain:32 syndrome:0x0 area:DMA)

Of course, any userspace tools meant to handle errors should not parse
the above data. They should, instead, use the binary fields provided by
the tracepoint, mapping them directly into their MIBs.

NOTE: The original patch was providing an additional mechanism for
MCA-based trace events that also contained MCA error register data.
Hoever, as no agreement was reached so far for the MCA-based trace
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

v24b: Remove extra whitespaces and improve messages on amd64_edac.

 drivers/edac/amd64_edac.c |   29 ++++++++--------
 drivers/edac/amd64_edac.h |    3 +-
 drivers/edac/edac_core.h  |    2 +-
 drivers/edac/edac_mc.c    |   56 +++++++++++++++++++++++++------
 include/ras/ras_event.h   |   80 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 143 insertions(+), 27 deletions(-)
 create mode 100644 include/ras/ras_event.h

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 60479f9..5be52e1 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1052,8 +1052,8 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     page, offset, syndrome,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
 				     "failed to map error addr to a node",
+				     EDAC_MOD_STR,
 				     NULL);
 		return;
 	}
@@ -1064,8 +1064,8 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     page, offset, syndrome,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
 				     "failed to map error addr to a csrow",
+				     EDAC_MOD_STR,
 				     NULL);
 		return;
 	}
@@ -1085,8 +1085,8 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 			edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 					     page, offset, syndrome,
 					     csrow, -1, -1,
-					     EDAC_MOD_STR,
 					     "unknown syndrome - possible error reporting race",
+					     EDAC_MOD_STR,
 					     NULL);
 			return;
 		}
@@ -1105,7 +1105,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, src_mci,
 			     page, offset, syndrome,
 			     csrow, channel, -1,
-			     EDAC_MOD_STR, "", NULL);
+			     "", EDAC_MOD_STR, NULL);
 }
 
 static int ddr2_cs_size(unsigned i, bool dct_width)
@@ -1595,8 +1595,8 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     page, offset, syndrome,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
 				     "failed to map error addr to a csrow",
+				     EDAC_MOD_STR,
 				     NULL);
 		return;
 	}
@@ -1612,7 +1612,7 @@ static void f1x_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
 	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 			     page, offset, syndrome,
 			     csrow, chan, -1,
-			     EDAC_MOD_STR, "", NULL);
+			     "", EDAC_MOD_STR, NULL);
 }
 
 /*
@@ -1896,8 +1896,8 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
 				     0, 0, 0,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
 				     "HW has no ERROR_ADDRESS available",
+				     EDAC_MOD_STR,
 				     NULL);
 		return;
 	}
@@ -1925,8 +1925,8 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     0, 0, 0,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
 				     "HW has no ERROR_ADDRESS available",
+				     EDAC_MOD_STR,
 				     NULL);
 		return;
 	}
@@ -1945,8 +1945,9 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offset, 0,
 				     -1, -1, -1,
+				     "ERROR ADDRESS NOT mapped to a MC",
 				     EDAC_MOD_STR,
-				     "ERROR ADDRESS NOT mapped to a MC", NULL);
+				     NULL);
 		return;
 	}
 
@@ -1959,14 +1960,14 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offset, 0,
 				     -1, -1, -1,
-				     EDAC_MOD_STR,
 				     "ERROR ADDRESS NOT mapped to CS",
+				     EDAC_MOD_STR,
 				     NULL);
 	} else {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offset, 0,
 				     csrow, -1, -1,
-				     EDAC_MOD_STR, "", NULL);
+				     "", EDAC_MOD_STR, NULL);
 	}
 }
 
@@ -2471,7 +2472,7 @@ static void setup_mci_misc_attrs(struct mem_ctl_info *mci,
 		mci->edac_ctl_cap |= EDAC_FLAG_S4ECD4ED;
 
 	mci->edac_cap		= amd64_determine_edac_cap(pvt);
-	mci->mod_name		= EDAC_MOD_STR;
+	mci->mod_name		= EDAC_DRIVER_STR;
 	mci->mod_ver		= EDAC_AMD64_VERSION;
 	mci->ctl_name		= fam->ctl_name;
 	mci->dev_name		= pci_name(pvt->F2);
@@ -2731,7 +2732,7 @@ static const struct pci_device_id amd64_pci_table[] __devinitdata = {
 MODULE_DEVICE_TABLE(pci, amd64_pci_table);
 
 static struct pci_driver amd64_pci_driver = {
-	.name		= EDAC_MOD_STR,
+	.name		= EDAC_DRIVER_STR,
 	.probe		= amd64_probe_one_instance,
 	.remove		= __devexit_p(amd64_remove_one_instance),
 	.id_table	= amd64_pci_table,
@@ -2750,7 +2751,7 @@ static void setup_pci_device(void)
 
 		pvt = mci->pvt_info;
 		amd64_ctl_pci =
-			edac_pci_create_generic_ctl(&pvt->F2->dev, EDAC_MOD_STR);
+			edac_pci_create_generic_ctl(&pvt->F2->dev, EDAC_DRIVER_STR);
 
 		if (!amd64_ctl_pci) {
 			pr_warning("%s(): Unable to create PCI control\n",
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 9a666cb..acea42c 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -145,7 +145,8 @@
  */
 
 #define EDAC_AMD64_VERSION		"3.4.0"
-#define EDAC_MOD_STR			"amd64_edac"
+#define EDAC_DRIVER_STR			"amd64_edac"
+#define EDAC_MOD_STR			"driver:" EDAC_DRIVER_STR
 
 /* Extended Model from CPUID, for CPU Revision numbers */
 #define K8_REV_D			1
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
index 7246a3c..461f6f8 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -33,6 +33,10 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
+#define CREATE_TRACE_POINTS
+#define TRACE_INCLUDE_PATH ../../include/ras
+#include <ras/ras_event.h>
+
 /* lock to memory controller's control array */
 static DEFINE_MUTEX(mem_ctls_mutex);
 static LIST_HEAD(mc_devices);
@@ -384,6 +388,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	 * which will perform kobj unregistration and the actual free
 	 * will occur during the kobject callback operation
 	 */
+
 	return mci;
 }
 EXPORT_SYMBOL_GPL(edac_mc_alloc);
@@ -909,12 +914,12 @@ static void edac_ce_error(struct mem_ctl_info *mci,
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
@@ -953,12 +958,12 @@ static void edac_ue_error(struct mem_ctl_info *mci,
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
 
@@ -975,6 +980,27 @@ static void edac_ue_error(struct mem_ctl_info *mci,
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
@@ -985,7 +1011,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  const int layer2,
 			  const char *msg,
 			  const char *other_detail,
-			  const void *mcelog)
+			  const void *arch_log)
 {
 	/* FIXME: too much for stack: move it to some pre-alocated area */
 	char detail[80], location[80];
@@ -1120,23 +1146,31 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			     edac_layer_name[mci->layers[i].type],
 			     pos[i]);
 	}
+	if (p > location)
+		*(p - 1) = '\0';
 
 	/* Memory type dependent details about the error */
-	if (type == HW_EVENT_ERR_CORRECTED) {
+	if (type == HW_EVENT_ERR_CORRECTED)
 		snprintf(detail, sizeof(detail),
 			"page:0x%lx offset:0x%lx grain:%d syndrome:0x%lx",
 			page_frame_number, offset_in_page,
 			grain, syndrome);
-		edac_ce_error(mci, pos, msg, location, label, detail,
-			      other_detail, enable_per_layer_report,
-			      page_frame_number, offset_in_page, grain);
-	} else {
+	else
 		snprintf(detail, sizeof(detail),
 			"page:0x%lx offset:0x%lx grain:%d",
 			page_frame_number, offset_in_page, grain);
 
+	/* Report the error via the trace interface */
+	trace_mc_event(type, mci->mc_idx, msg, label, location,
+		       detail, other_detail);
+
+	/* Report the error via the edac_mc_printk() interface */
+	if (type == HW_EVENT_ERR_CORRECTED)
+		edac_ce_error(mci, pos, msg, location, label, detail,
+			      other_detail, enable_per_layer_report,
+			      page_frame_number, offset_in_page, grain);
+	else
 		edac_ue_error(mci, pos, msg, location, label, detail,
 			      other_detail, enable_per_layer_report);
-	}
 }
 EXPORT_SYMBOL_GPL(edac_mc_handle_error);
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
new file mode 100644
index 0000000..2f9069d
--- /dev/null
+++ b/include/ras/ras_event.h
@@ -0,0 +1,80 @@
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
+		 const unsigned int mc_index,
+		 const char *error_msg,
+		 const char *label,
+		 const char *location,
+		 const char *core_detail,
+		 const char *driver_detail),
+
+	TP_ARGS(err_type, mc_index, error_msg, label, location,
+		core_detail, driver_detail),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	err_type		)
+		__field(	unsigned int,	mc_index		)
+		__string(	msg,		error_msg		)
+		__string(	label,		label			)
+		__string(	detail,		core_detail		)
+		__string(	location,	location		)
+		__string(	driver_detail,	driver_detail		)
+	),
+
+	TP_fast_assign(
+		__entry->err_type		= err_type;
+		__entry->mc_index		= mc_index;
+		__assign_str(msg, error_msg);
+		__assign_str(label, label);
+		__assign_str(location, location);
+		__assign_str(detail, core_detail);
+		__assign_str(driver_detail, driver_detail);
+	),
+
+	TP_printk("%s error:%s%s on memory stick \"%s\" (mc:%d %s %s%s%s)",
+		  (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
+			((__entry->err_type == HW_EVENT_ERR_FATAL) ?
+			"Fatal" : "Uncorrected"),
+		  ((char *)__get_str(msg))[0] ? " " : "",
+		  __get_str(msg),
+		  __get_str(label),
+		  __entry->mc_index,
+		  __get_str(location),
+		  __get_str(detail),
+		  ((char *)__get_str(driver_detail))[0] ? " " : "",
+		  __get_str(driver_detail))
+);
+
+#endif /* _TRACE_HW_EVENT_MC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.8

