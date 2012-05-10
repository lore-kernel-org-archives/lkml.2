Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab2EJUk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:40:58 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:58311 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab2EJUk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:40:56 -0400
Date: Thu, 10 May 2012 22:40:42 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
Message-ID: <20120510204042.GA4598@aftab.osrc.amd.com>
References: <1336679788-4982-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336679788-4982-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be:

Subject: RAS: Add a tracepoint for reporting memory controller errors

and not

Subject: edac, ras/hw_event.h: use events to handle hw issues

because events don't handle hw issues.

On Thu, May 10, 2012 at 04:56:28PM -0300, Mauro Carvalho Chehab wrote:
> Add a new tracepoint-based hardware events report method for
> outputing Memory Controller events.

reporting

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
> ---
>  drivers/edac/edac_core.h |    2 +-
>  drivers/edac/edac_mc.c   |   25 +++++++++++----
>  include/ras/hw_event.h   |   77 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 96 insertions(+), 8 deletions(-)
>  create mode 100644 include/ras/hw_event.h
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
> index e5b5563..11f0178 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -33,6 +33,10 @@
>  #include "edac_core.h"
>  #include "edac_module.h"
>  
> +#define CREATE_TRACE_POINTS
> +#define TRACE_INCLUDE_PATH ../../include/ras
> +#include <ras/hw_event.h>
> +
>  /* lock to memory controller's control array */
>  static DEFINE_MUTEX(mem_ctls_mutex);
>  static LIST_HEAD(mc_devices);
> @@ -381,6 +385,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
>  	 * which will perform kobj unregistration and the actual free
>  	 * will occur during the kobject callback operation
>  	 */
> +
>  	return mci;
>  }
>  EXPORT_SYMBOL_GPL(edac_mc_alloc);
> @@ -982,7 +987,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
>  			  const int layer2,
>  			  const char *msg,
>  			  const char *other_detail,
> -			  const void *mcelog)
> +			  const void *arch_log)
>  {
>  	/* FIXME: too much for stack: move it to some pre-alocated area */
>  	char detail[80], location[80];
> @@ -1119,21 +1124,27 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
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
> diff --git a/include/ras/hw_event.h b/include/ras/hw_event.h
> new file mode 100644
> index 0000000..66981ef
> --- /dev/null
> +++ b/include/ras/hw_event.h
> @@ -0,0 +1,77 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM hw_event

			ras

> +
> +#if !defined(_TRACE_HW_EVENT_MC_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_HW_EVENT_MC_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/edac.h>
> +#include <linux/ktime.h>
> +
> +/*
> + * Hardware Events Report
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

This still says "mce" and it should say "MC" or "mem_ctl" or similar.

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

I'm assuming you have all those changes on the experimental branch so
that I can continue reviewing from there?

@Tony: this is adding a RAS tracepoint for memory controller errors
coming from EDAC (for now), any objections/issues?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
