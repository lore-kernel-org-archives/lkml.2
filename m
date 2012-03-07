Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab2CGMMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:12:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757963Ab2CGMMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:12:22 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] events/hw_event: Create a Hardware Events Report Mecanism (HERM)
Date: Wed,  7 Mar 2012 09:12:15 -0300
Message-Id: <1331122335-28600-1-git-send-email-mchehab@redhat.com>
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
encapsulate the memory error hardware events into a trace facility.

As no agreement was reached so far for the MCA-based trace events, for
now, let's add events only for memory errors. A latter patch can change
the tracepoint, for events originated via MCA.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_core.h        |    2 +-
 drivers/edac/edac_mc.c          |   11 ++++-
 include/trace/events/hw_event.h |  107 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 118 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/hw_event.h

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
index 1651e7e..e1589b6 100644
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
@@ -394,6 +397,9 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
 	 * which will perform kobj unregistration and the actual free
 	 * will occur during the kobject callback operation
 	 */
+
+	trace_hw_event_init("edac", (unsigned)edac_index);
+
 	return mci;
 }
 EXPORT_SYMBOL_GPL(edac_mc_alloc);
@@ -911,7 +917,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  const int layer2,
 			  const char *msg,
 			  const char *other_detail,
-			  const void *mcelog)
+			  const void *arch_log)
 {
 	unsigned long remapped_page;
 	/* FIXME: too much for stack: move it to some pre-alocated area */
@@ -1049,6 +1055,9 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			"page 0x%lx offset 0x%lx grain %d",
 			page_frame_number, offset_in_page, grain);
 
+	trace_mc_error(type, mci->mc_idx, msg, label, location,
+		       detail, other_detail);
+
 	if (type == HW_EVENT_ERR_CORRECTED) {
 		if (edac_mc_get_log_ce())
 			edac_mc_printk(mci, KERN_WARNING,
diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
new file mode 100644
index 0000000..9209c6b
--- /dev/null
+++ b/include/trace/events/hw_event.h
@@ -0,0 +1,107 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM hw_event
+
+#if !defined(_TRACE_HW_EVENT_MC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_HW_EVENT_MC_H
+
+#include <linux/tracepoint.h>
+#include <linux/edac.h>
+#include <linux/ktime.h>
+
+/*
+ * Hardware Anomaly Report Mecanism (HARM) events
+ *
+ * Those events are generated when hardware detected a corrected or
+ * uncorrected event, and are meant to replace the current API to report
+ * errors defined on both EDAC and MCE subsystems.
+ *
+ * There are two types of events defined here: arch-independent ones, and
+ * x86 arch events. The x86 arch events are based on x86 MCE architecture.
+ */
+
+DECLARE_EVENT_CLASS(hw_event_class,
+	TP_PROTO(const char *type, unsigned int instance),
+	TP_ARGS(type, instance),
+
+	TP_STRUCT__entry(
+		__string(	type,		type			)
+		__field(	unsigned int,	instance		)
+	),
+
+	TP_fast_assign(
+		__assign_str(type, type);
+		__entry->instance = instance;
+	),
+
+	TP_printk("Initialized %s#%d\n",
+		__get_str(type),
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
+ * Hardware-independent Memory Controller specific events
+ */
+
+/*
+ * Default error mechanisms for Memory Controller errors (CE and UE)
+ */
+TRACE_EVENT(mc_error,
+
+	TP_PROTO(const unsigned int err_type,
+		 const unsigned int mc_index,
+		 const char *msg,
+		 const char *label,
+		 const char *location,
+		 const char *detail,
+		 const char *driver_detail),
+
+	TP_ARGS(err_type, mc_index, msg, label, location,
+		detail, driver_detail),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	err_type		)
+		__field(	unsigned int,	mc_index		)
+		__string(	msg,		msg			)
+		__string(	label,		label			)
+		__string(	detail,		detail			)
+		__string(	location,	location		)
+		__string(	driver_detail,	driver_detail		)
+	),
+
+	TP_fast_assign(
+		__entry->err_type		= err_type;
+		__entry->mc_index		= mc_index;
+		__assign_str(msg, msg);
+		__assign_str(label, label);
+		__assign_str(location, location);
+		__assign_str(detail, detail);
+		__assign_str(driver_detail, driver_detail);
+	),
+
+	TP_printk(HW_ERR "mce#%d: %s error %s on label \"%s\" (%s %s %s)",
+		  __entry->mc_index,
+		  (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
+			((__entry->err_type == HW_EVENT_ERR_FATAL) ?
+			"Fatal" : "Uncorrected"),
+		  __get_str(msg),
+		  __get_str(label),
+		  __get_str(location),
+		  __get_str(detail),
+		  __get_str(driver_detail))
+);
+
+#endif /* _TRACE_HW_EVENT_MC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.8

