Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab2EIOZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:25:12 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:50383 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863Ab2EIOZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:25:10 -0400
Date: Wed, 9 May 2012 16:24:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [EDAC ABI v13 04/25] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
Message-ID: <20120509142456.GH22737@aftab.osrc.amd.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
 <1334608729-30803-5-git-send-email-mchehab@redhat.com>
 <20120509121326.GA22737@aftab.osrc.amd.com>
 <4FAA6802.9070506@redhat.com>
 <20120509132237.GD22737@aftab.osrc.amd.com>
 <4FAA7649.5080606@redhat.com>
 <20120509140632.GG22737@aftab.osrc.amd.com>
 <4FAA7C1A.3020406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FAA7C1A.3020406@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:15:54AM -0300, Mauro Carvalho Chehab wrote:
> Em 09-05-2012 11:06, Borislav Petkov escreveu:
> > On Wed, May 09, 2012 at 10:51:05AM -0300, Mauro Carvalho Chehab wrote:
> >>> Now, if you really want to have a generic mechanism for RAS, used
> >>> by all the kernel, then I don't have a problem with you adding it
> >>> to include/ras/hw_event.h or somewhere in that vicinity along with
> >>> making it generic enough for other users and then taking care of it and
> >>> developing it to address users' needs.
> >>
> >> I'm ok to move it to include/ras, but, if I remember well from my initial
> >> tests when I wrote this, several kernel versions ago, there is/was
> >> a limitation that required that all trace events should be under
> >> include/trace/events/.
> >>
> >> One other option would be to call it as "include/trace/events/ras.h".
> >>
> >> Steven,
> >>
> >> Would it be possible/recommendable to move this trace header
> >> to include/linux/ras/hw_event.h?
> > 
> > Oh, yeah, I remember vaguely something like that. Lets wait what Steven
> > has to say.

btw, http://lwn.net/Articles/383362/ explains how to define tracepoints outside
of include/trace/events.

[ … ]

> > and above says "Hardware Events Report Method (HERM)" The fact that you
> > yourself are not exactly sure about what this abbreviation is supposed
> > to be/mean/etc, simply should tell you that it is causing only confusion
> > with no benefit what-so-ever, even to you!
> 
> Fixed.

No, you haven't. It still says HERM below. Please drop the marketing speak!

> events/hw_event: use a tracepoint-based Hardware Events Report Method (HERM)
> 
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Adds a trace event for handle hardware issues
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
> As part of a hardware event subsystem, let's encapsulate the memory
> error hardware events into a trace facility.
> 
> NOTE: The original patch was providing an additional mechanism for
> MCA-based trace events that also contained MCA error register data.
> Hoever, as no agreement was reached so far for the MCA-based trace
> events, for now, let's add events only for memory errors.
> A latter patch is planned to change the tracepoint, for those types
> of event.
> 
> Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
> Cc: Doug Thompson <norsk5@yahoo.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> index f06ce9a..eee7360 100644
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
> index e5b5563..eff8266 100644
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
> @@ -381,6 +384,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
>  	 * which will perform kobj unregistration and the actual free
>  	 * will occur during the kobject callback operation
>  	 */
> +
>  	return mci;
>  }
>  EXPORT_SYMBOL_GPL(edac_mc_alloc);
> @@ -982,7 +986,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
>  			  const int layer2,
>  			  const char *msg,
>  			  const char *other_detail,
> -			  const void *mcelog)
> +			  const void *arch_log)
>  {
>  	/* FIXME: too much for stack: move it to some pre-alocated area */
>  	char detail[80], location[80];
> @@ -1119,21 +1123,27 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
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
> index 0000000..fe2ec3b
> --- /dev/null
> +++ b/include/trace/events/hw_event.h
> @@ -0,0 +1,77 @@
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
> + * Hardware Events Report Method (HERM)
> + *
> + * Those events are generated when hardware detected a corrected or
> + * uncorrected event, and are meant to replace the current API to report
> + * errors defined on both EDAC and MCE subsystems.
> + *
> + * FIXME: Add events for handling memory errors originated from the
> + *        MCE subsystem.
> + */
> +
> +/*
> + * Hardware-independent Memory Controller specific events
> + */
> +
> +/*
> + * Default error mechanisms for Memory Controller errors (CE and UE)
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
> +	TP_printk(HW_ERR "mce#%d: %s error %s on memory stick \"%s\" (%s %s %s)",
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
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
