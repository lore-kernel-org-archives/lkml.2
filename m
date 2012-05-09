Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab2EIMNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:13:43 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49456 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155Ab2EIMNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:13:40 -0400
Date: Wed, 9 May 2012 14:13:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [EDAC ABI v13 04/25] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
Message-ID: <20120509121326.GA22737@aftab.osrc.amd.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
 <1334608729-30803-5-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334608729-30803-5-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inserting the latest version:

> From 4afb0250415e87b983f5937d456c83407fe96264 Mon Sep 17 00:00:00 2001
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date: Thu, 23 Feb 2012 08:10:34 -0300
> Subject: [PATCH] events/hw_event: Create a Hardware Events Report Mecanism
>  (HERM)

Ok, let's face it: this is just a single trace_mc_error tracepoint,
nothing else. Let's drop the HERM bullshit bingo and call the thing by
it's name: "Add yet another tracepoint to report DRAM ECC errors".

> Adds a trace class for handle hardware events
> 
> Part of the description bellow is shamelessly copied from Tony
> Luck's notes about the Hardware Error BoF during LPC 2010 [1].
> Tony, thanks for your notes and discussions to generate the
> h/w error reporting requirements.
> 
> [1] http://lwn.net/Articles/416669/
> 
>     We have several subsystems & methods for reporting hardware errors:
> 
>     1) EDAC ("Error Detection and Correction").  In its original form
>     this consisted of a platform specific driver that read topology
>     information and error counts from chipset registers and reported
>     the results via a sysfs interface.
> 
>     2) mcelog - x86 specific decoding of machine check bank registers
>     reporting in binary form via /dev/mcelog. Recent additions make use
>     of the APEI extensions that were documented in version 4.0a of the
>     ACPI specification to acquire more information about errors without
>     having to rely reading chipset registers directly. A user level
>     programs decodes into somewhat human readable format.
> 
>     3) drivers/edac/mce_amd.c - this driver hooks into the mcelog path and
>     decodes errors reported via machine check bank registers in AMD
>     processors to the console log using printk();
> 
>     Each of these mechanisms has a band of followers ... and none
>     of them appear to meet all the needs of all users.
> 
> In order to provide a proper hardware event subsystem, let's

err no, this is not a proper hw event subsystem.

> encapsulate the memory error hardware events into a trace facility.
> 
> As no agreement was reached so far for the MCA-based trace events, for
> now, let's add events only for memory errors. A latter patch can change
> the tracepoint, for events originated via MCA.

This last paragraph has nothing to do with the patch so it can go.

> Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
> Cc: Doug Thompson <norsk5@yahoo.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/edac/edac_core.h        |    2 +-
>  drivers/edac/edac_mc.c          |   26 +++++++---
>  include/trace/events/hw_event.h |  107 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 127 insertions(+), 8 deletions(-)
>  create mode 100644 include/trace/events/hw_event.h
> 
> diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> index f06ce9ab692c..eee73605c5a0 100644
> --- a/drivers/edac/edac_core.h
> +++ b/drivers/edac/edac_core.h
> @@ -468,7 +468,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
>  			  const int layer2,
>  			  const char *msg,
>  			  const char *other_detail,
> -			  const void *mcelog);
> +			  const void *arch_log);
>  
>  /*
>   * edac_device APIs
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index e5b55632359f..c75774dcf434 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -33,6 +33,9 @@
>  #include "edac_core.h"
>  #include "edac_module.h"
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/hw_event.h>
> +
>  /* lock to memory controller's control array */
>  static DEFINE_MUTEX(mem_ctls_mutex);
>  static LIST_HEAD(mc_devices);
> @@ -381,6 +384,9 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
>  	 * which will perform kobj unregistration and the actual free
>  	 * will occur during the kobject callback operation
>  	 */
> +

superfluous newline.

> +	trace_hw_event_init("edac", (unsigned)mc_num);
> +
>  	return mci;
>  }
>  EXPORT_SYMBOL_GPL(edac_mc_alloc);
> @@ -982,7 +988,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
>  			  const int layer2,
>  			  const char *msg,
>  			  const char *other_detail,
> -			  const void *mcelog)
> +			  const void *arch_log)
>  {
>  	/* FIXME: too much for stack: move it to some pre-alocated area */
>  	char detail[80], location[80];
> @@ -1119,21 +1125,27 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
>  	}
>  
>  	/* Memory type dependent details about the error */
> -	if (type == HW_EVENT_ERR_CORRECTED) {
> +	if (type == HW_EVENT_ERR_CORRECTED)
>  		snprintf(detail, sizeof(detail),
>  			"page:0x%lx offset:0x%lx grain:%d syndrome:0x%lx",
>  			page_frame_number, offset_in_page,
>  			grain, syndrome);
> -		edac_ce_error(mci, pos, msg, location, label, detail,
> -			      other_detail, enable_per_layer_report,
> -			      page_frame_number, offset_in_page, grain);
> -	} else {
> +	else
>  		snprintf(detail, sizeof(detail),
>  			"page:0x%lx offset:0x%lx grain:%d",
>  			page_frame_number, offset_in_page, grain);
>  
> +	/* Report the error via the trace interface */
> +	trace_mc_error(type, mci->mc_idx, msg, label, location,
> +		       detail, other_detail);
> +
> +	/* Report the error via the edac_mc_printk() interface */
> +	if (type == HW_EVENT_ERR_CORRECTED)
> +		edac_ce_error(mci, pos, msg, location, label, detail,
> +			      other_detail, enable_per_layer_report,
> +			      page_frame_number, offset_in_page, grain);
> +	else
>  		edac_ue_error(mci, pos, msg, location, label, detail,
>  			      other_detail, enable_per_layer_report);
> -	}
>  }
>  EXPORT_SYMBOL_GPL(edac_mc_handle_error);
> diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
> new file mode 100644
> index 000000000000..1fabfe21e29a
> --- /dev/null
> +++ b/include/trace/events/hw_event.h
> @@ -0,0 +1,107 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM hw_event
> +
> +#if !defined(_TRACE_HW_EVENT_MC_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_HW_EVENT_MC_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/edac.h>
> +#include <linux/ktime.h>
> +
> +/*
> + * Hardware Anomaly Report Mecanism (HARM) events
> + *
> + * Those events are generated when hardware detected a corrected or
> + * uncorrected event, and are meant to replace the current API to report
> + * errors defined on both EDAC and MCE subsystems.
> + *
> + * FIXME: Add events for handling memory errors originated from the
> + *        MCE subsystem.
> + */
> +
> +DECLARE_EVENT_CLASS(hw_event_class,

Ok, event classes are for sharing tracepoints which have the same
TP_PROTO, TP_ARGS.. etc arguments as Steven's (CCed) article on lwn
points out.

I don't see this here and besides, why in the hell would you need a
trace event which only announces that the mechanism starts?? A common,
run-of-the-mill printk is more than enough here.

> +	TP_PROTO(const char *type, unsigned int instance),
> +	TP_ARGS(type, instance),
> +
> +	TP_STRUCT__entry(
> +		__string(	type,		type			)
> +		__field(	unsigned int,	instance		)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(type, type);
> +		__entry->instance = instance;
> +	),
> +
> +	TP_printk("Initialized %s#%d\n",
> +		__get_str(type),
> +		__entry->instance)
> +);
> +
> +/*
> + * This event indicates that a hardware collection mechanism is started
> + */
> +DEFINE_EVENT(hw_event_class, hw_event_init,
> +
> +	TP_PROTO(const char *type, unsigned int instance),
> +
> +	TP_ARGS(type, instance)
> +);
> +
> +
> +/*
> + * Hardware-independent Memory Controller specific events
> + */
> +
> +/*
> + * Default error mechanisms for Memory Controller errors (CE and UE)

				   DRAM ECC errors.

> + */
> +TRACE_EVENT(mc_error,
> +
> +	TP_PROTO(const unsigned int err_type,
> +		 const unsigned int mc_index,
> +		 const char *msg,
> +		 const char *label,
> +		 const char *location,
> +		 const char *detail,
> +		 const char *driver_detail),
> +
> +	TP_ARGS(err_type, mc_index, msg, label, location,
> +		detail, driver_detail),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned int,	err_type		)
> +		__field(	unsigned int,	mc_index		)
> +		__string(	msg,		msg			)
> +		__string(	label,		label			)
> +		__string(	detail,		detail			)
> +		__string(	location,	location		)
> +		__string(	driver_detail,	driver_detail		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->err_type		= err_type;
> +		__entry->mc_index		= mc_index;
> +		__assign_str(msg, msg);
> +		__assign_str(label, label);
> +		__assign_str(location, location);
> +		__assign_str(detail, detail);
> +		__assign_str(driver_detail, driver_detail);
> +	),
> +
> +	TP_printk(HW_ERR "mce#%d: %s error %s on label \"%s\" (%s %s %s)",

						 memory stick/DIMM

> +		  __entry->mc_index,
> +		  (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
> +			((__entry->err_type == HW_EVENT_ERR_FATAL) ?
> +			"Fatal" : "Uncorrected"),
> +		  __get_str(msg),
> +		  __get_str(label),
> +		  __get_str(location),
> +		  __get_str(detail),
> +		  __get_str(driver_detail))
> +);
> +
> +#endif /* _TRACE_HW_EVENT_MC_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> -- 
> 1.7.9.3.362.g71319


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
