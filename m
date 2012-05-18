Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2EROcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab2EROcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:32:08 -0400
Message-ID: <4FB65D52.9060108@redhat.com>
Date: Fri, 18 May 2012 11:31:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory controller
 events
References: <1337287277-523-1-git-send-email-mchehab@redhat.com> <20120517214859.GA16777@aftab.osrc.amd.com> <20120518071244.GE429@gmail.com> <20120518095638.GA20215@aftab.osrc.amd.com> <4FB62BAB.90808@redhat.com> <20120518124338.GJ20215@aftab.osrc.amd.com> <4FB64D5B.1030301@redhat.com> <20120518140521.GM20215@aftab.osrc.amd.com>
In-Reply-To: <20120518140521.GM20215@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 18-05-2012 11:05, Borislav Petkov escreveu:
> On Fri, May 18, 2012 at 10:23:39AM -0300, Mauro Carvalho Chehab wrote:
>> Em 18-05-2012 09:43, Borislav Petkov escreveu:
>>
>> (offensive/ironic comments skipped)
>>
>>> you fail to see that I'm trying to make this as generic as possible and
>>> not fit it into anything so that EVERYONE can use it.
>>
>> Tracepoints are generic enough. Everyone can use it. If need new fields are
>> needed, just add a new tracepoint.
> 
> This is exactly what I'm talking about - this is wrong on so many levels
> that it ain't even funny! You can add as many tracepoints if you want
> to to your pet project but in the kernel we add one tracepoint for one
> thing which fits all users.
> 
> I want to see you be successful at adding a new tracepoint
> to, say, prepare_task_switch() in kernel/sched/core.c because
> trace_sched_switch() does not fit your needs.

Ok, but you won't use trace_sched_switch() as a memory tracepoint, as
they represent different things.

Memory errors are different than CPU errors. So, their tracepoints
will be different.

<skip>

> Right, and this is why I'm asking you to have the following tracepoint proto:
> 
> +       TP_PROTO(const unsigned int err_type,
> +                const unsigned int mc_index,
> +                const char *error_msg,
> +                const char *label,
> +                const char *location,
> +                const char *detail)
> 
> where detail contains all the crap one driver adds for technical people
> to pinpoint where the error is.
> 
> And not have _TWO_ detail arguments!

And what I'm saying is that this should be, instead:

+ TP_PROTO(const unsigned int err_type,
+          const unsigned int mc_index,
+          const char *error_msg,
+          const char *label,
+          int layer0,
+          int layer1,
+          int layer2,
+          unsigned long pfn,
+          unsigned long offset,
+          unsigned long grain,
+          unsigned long syndrome,
+          const char *driver_detail),

So, having just one detail argument, filled by the driver, and not
folding "location" and core "details" into strings, but keeping as they
are.

> 
> Btw, the output looks like this here:
> 
>            <...>-2723  [001] .N..    89.107045: mc_event: Corrected error: on memory stick "unknown memory" (mc:0 csrow:3 channel:1 page:0x5bac7 offset:0x388 grain:0 syndrome:0xfc5b driver:amd64_edac)
> 
> Come to think of it, the "driver:amd64_edac" is not really needed
> because on every single system there's only one EDAC driver running and
> I don't think the fact that we're telling in the tracepoint who detected
> the error is meaningfull information.
> 
> Which means, you can remove the EDAC_MOD_STR argument you're passing to
> edac_mc_handle_error() and have one less argument.

That's what I said you, but you didn't seem to agree, as I understood that
you've required to keep "amd64_edac"  at the trace, due to:
	http://markmail.org/message/nr3ooep7gc7mhgdl.

If you're ok, I'll remove EDAC_MOD_STR argument from the amd64_edac calls
on a separate patch (with can be merged latter with the patch that converted
amd64_edac to the new function calls).

> 
>>>> Also, doing that will avoid the extra effort of joining everything into
>>>> a single string, and then breaking them back into their individual fields
>>>> on userspace.
>>>
>>> I'm being told this is very easy to do in userspace in your garden
>>> variety language.
>>
>> Well, ask the one that told you that to write a parser that will get all 
>> EDAC error reports on all drivers, on several kernel versions using dmesg.
> 
> Nobody is talking about dmesg - I'm talking about the "const char
> *detail" string in the tracepoint above and how I want it to be a single
> char * so that userspace can read it out and fumble with it the way it
> sees fit.
> 
> Having "detail" and "other_detail" is simply misleading and unneeded and
> a clear sign that this ABI is not designed properly yet.
> 
> That's it.

I agree with that.

It follows a version removing the "core_detail" parameter from the trace.

I removed the changes at amd64_edac from it. I'll address them on a latter
patch, removing the EDAC_MOD_STR argument from the calls, after we've
done with this patch.

Regards,
Mauro

-

RAS: Add a tracepoint for reporting memory controller events

From: Mauro Carvalho Chehab <mchehab@redhat.com>

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
index 10f3750..5006461 100644
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
@@ -1120,6 +1146,13 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			     edac_layer_name[mci->layers[i].type],
 			     pos[i]);
 	}
+	if (p > location)
+		*(p - 1) = '\0';
+
+	/* Report the error via the trace interface */
+	trace_mc_event(type, mci->mc_idx, msg, label, layer0, layer1, layer2,
+		       page_frame_number, offset_in_page, grain, syndrome,
+		       other_detail);
 
 	/* Memory type dependent details about the error */
 	if (type == HW_EVENT_ERR_CORRECTED) {
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
new file mode 100644
index 0000000..65835df
--- /dev/null
+++ b/include/ras/ras_event.h
@@ -0,0 +1,100 @@
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
+		 int layer0,
+		 int layer1,
+		 int layer2,
+		 unsigned long pfn,
+		 unsigned long offset,
+		 unsigned long grain,
+		 unsigned long syndrome,
+		 const char *driver_detail),
+
+	TP_ARGS(err_type, mc_index, error_msg, label, layer0, layer1, layer2,
+		pfn, offset, grain, syndrome, driver_detail),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	err_type		)
+		__field(	unsigned int,	mc_index		)
+		__string(	msg,		error_msg		)
+		__string(	label,		label			)
+		__field(	int,		layer0			)
+		__field(	int,		layer1			)
+		__field(	int,		layer2			)
+		__field(	int,		pfn			)
+		__field(	int,		offset			)
+		__field(	int,		grain			)
+		__field(	int,		syndrome		)
+		__string(	driver_detail,	driver_detail		)
+	),
+
+	TP_fast_assign(
+		__entry->err_type		= err_type;
+		__entry->mc_index		= mc_index;
+		__assign_str(msg, error_msg);
+		__assign_str(label, label);
+		__entry->layer0			= layer0;
+		__entry->layer1			= layer1;
+		__entry->layer2			= layer2;
+		__entry->pfn			= pfn;
+		__entry->offset			= offset;
+		__entry->grain			= grain;
+		__entry->syndrome		= syndrome;
+		__assign_str(driver_detail, driver_detail);
+	),
+
+	TP_printk("%s error:%s%s on memory stick \"%s\" (mc:%d location:%d:%d:%d page:0x%08x offset:0x%08x grain:%d syndrome:0x%08x%s%s)",
+		  (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
+			((__entry->err_type == HW_EVENT_ERR_FATAL) ?
+			"Fatal" : "Uncorrected"),
+		  ((char *)__get_str(msg))[0] ? " " : "",
+		  __get_str(msg),
+		  __get_str(label),
+		  __entry->mc_index,
+		  __entry->layer0,
+		  __entry->layer1,
+		  __entry->layer2,
+		  __entry->pfn,
+		  __entry->offset,
+		  __entry->grain,
+		  __entry->syndrome,
+		  ((char *)__get_str(driver_detail))[0] ? " " : "",
+		  __get_str(driver_detail))
+);
+
+#endif /* _TRACE_HW_EVENT_MC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
