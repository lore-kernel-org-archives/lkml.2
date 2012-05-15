Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab2EOQGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:06:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933069Ab2EOQGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:06:12 -0400
Message-ID: <4FB27EDC.8040001@redhat.com>
Date: Tue, 15 May 2012 13:05:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
References: <3908561D78D1C84285E8C5FCA982C28F192EC1A2@ORSMSX104.amr.corp.intel.com> <4FAC3C35.70101@redhat.com> <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com> <4FAC6FF8.3050608@redhat.com> <20120511102527.GI8913@aftab.osrc.amd.com> <4FAD081C.5000704@redhat.com> <20120511172430.GB17299@aftab.osrc.amd.com> <4FAD5CAD.90508@redhat.com> <20120514133404.GE4231@aftab.osrc.amd.com> <4FB1163D.3010302@redhat.com> <20120515150957.GC27806@aftab.osrc.amd.com>
In-Reply-To: <20120515150957.GC27806@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 15-05-2012 12:09, Borislav Petkov escreveu:
> On Mon, May 14, 2012 at 11:27:09AM -0300, Mauro Carvalho Chehab wrote:
>> Hmm... I've already released 2 versions after this one, addressing all the pointed
>> issues pointed by you and Tony at:
>>
>> 	http://permalink.gmane.org/gmane.linux.kernel/1296116
>>
>> It would be good if you could comment against the latest patch version.
> 
> Ok, here it is:
> 
> ---
>> commit 771823672b7c244b9a57523c955ead9fd87f2412
>> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Date:   Thu Feb 23 08:10:34 2012 -0300
>>
>>     RAS: Add a tracepoint for reporting memory controller events
>>     
>>     Add a new tracepoint-based hardware events report method for
>>     reporting Memory Controller events.
>>     
>>     Part of the description bellow is shamelessly copied from Tony
>>     Luck's notes about the Hardware Error BoF during LPC 2010 [1].
>>     Tony, thanks for your notes and discussions to generate the
>>     h/w error reporting requirements.
>>     
>>     [1] http://lwn.net/Articles/416669/
>>     
>>         We have several subsystems & methods for reporting hardware errors:
>>     
>>         1) EDAC ("Error Detection and Correction").  In its original form
>>         this consisted of a platform specific driver that read topology
>>         information and error counts from chipset registers and reported
>>         the results via a sysfs interface.
>>     
>>         2) mcelog - x86 specific decoding of machine check bank registers
>>         reporting in binary form via /dev/mcelog. Recent additions make use
>>         of the APEI extensions that were documented in version 4.0a of the
>>         ACPI specification to acquire more information about errors without
>>         having to rely reading chipset registers directly. A user level
>>         programs decodes into somewhat human readable format.
>>     
>>         3) drivers/edac/mce_amd.c - this driver hooks into the mcelog path and
>>         decodes errors reported via machine check bank registers in AMD
>>         processors to the console log using printk();
>>     
>>         Each of these mechanisms has a band of followers ... and none
>>         of them appear to meet all the needs of all users.
>>     
>>     As part of a RAS subsystem, let's encapsulate the memory error hardware
>>     events into a trace facility.
>>     
>>     The tracepoint printk will be displayed like:
>>     
>>     mc_event: (Corrected|Uncorrected|Fatal) error:[error msg] on memory stick "[label]" ([location] [edac_mc detail] [driver_detail])
>>     
>>     Where:
>>     	[error msg] is the driver-specific error message
>>     		    (e. g. "memory read", "bus error", ...);
>>     	[location] is the location in terms of memory controller and
>>     		   branch/channel/slot, channel/slot or csrow/channel;
>>     	[label] is the memory stick label;
>>     	[edac_mc detail] describes the address location of the error
>>     			 and the syndrome;
>>     	[driver detail] is driver-specifig error message details,
>>     			when needed/provided (e. g. "area:DMA", ...)
> 
> Ah ok, so count, area and rank are driver-specific stuff and they're not part of
> the mandatory string output, I guess that's fine.

Yep.

> 
> Here's what an error looks like on my system here:
> 
>        mcegen.py-2868  [007] .N..   178.261607: mc_event: Corrected error:amd64_edac on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed )
> 
> There's still this trailing " " at the end of the error line which
> shouldn't be there and also two spaces between "channel" and "page".

If you take a look at the trace printk:

+ TP_printk("%s error:%s on memory stick \"%s\" (mc:%d %s %s %s)",
+           (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
+                 ((__entry->err_type == HW_EVENT_ERR_FATAL) ?
+                 "Fatal" : "Uncorrected"),
+           __get_str(msg),
+           __get_str(label),
+           __entry->mc_index,
+           __get_str(location),
+           __get_str(detail),
+           __get_str(driver_detail))

There are not extra spaces there. The first extra space is probably because
there is an extra space at the label string. This should be easy to fix.

The other extra space at the end is because amd64 currently doesn't provide
driver_detail information.

> Also, according to the output above "amd64_edac" is supposed to be
> [error msg] which is strange.
> 
> I believe this comes from this call in f1x_map_sysaddr_to_csrow():
> 
> 	        edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
>                              page, offset, syndrome,
>                              csrow, chan, -1,
>                              EDAC_MOD_STR, "", NULL);
> 
> I guess you want to do the following instead:
> 
>        mcegen.py-2868  [007] .N..   178.261607: mc_event: amd64_edac: corrected error on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed)
> 
> maybe concatenate EDAC_MOD_STR with the proper string it reports, i.e.
> corrected/uncorrected error?

The issue here is because amd64_edac (just like a few other drivers) use
its driver name (EDAC_MOD_STR) as the error message, instead of using 
something meaningful, like "read error" or "ECC error".
 
> Also, make sure the calls in the other drivers don't generate such
> strange output.

The same kind of strange output is also at the printk's, and it is there
even with the current calls: the output syntax is broken on several drivers,
and fixing for some will break for the others.

So, this needs to be reviewed driver-per-driver. I'll handle that with the
machines I have for test. For the other drivers, maybe we can just fill 
the error_msg information with "error".

Anyway, I intend to work on that after merging this huge patch series.
As Tony said, a change on that is not trivial.

>>     For example:
>>     
>>     mc_event: Corrected error:memory read on memory stick "DIMM_1A" (mc:0 channel:0 slot:0 page:0x586b6e offset:0xa66 grain:32 syndrome:0x0 area:DMA)
> 				you need a space after "error:"?
> 
>>     Of course, any userspace tools meant to handle errors should not parse
>>     the above data. They should, instead, use the binary fields provided by
>>     the tracepoint, mapping them directly into their MIBs.
> 
> What is a MIB?

Management Information Base. This is how anyone that works with Element
Management calls the model of information that represents each management
property. It is generally written using ITU-T ASN.1 syntax. Almost all
management software use that.

[1] http://en.wikipedia.org/wiki/Management_information_base

> 
>>     NOTE: The original patch was providing an additional mechanism for
>>     MCA-based trace events that also contained MCA error register data.
>>     Hoever, as no agreement was reached so far for the MCA-based trace
>>     events, for now, let's add events only for memory errors.
>>     A latter patch is planned to change the tracepoint, for those types
>>     of event.
>>     
>>     Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
>>     Cc: Doug Thompson <norsk5@yahoo.com>
>>     Cc: Steven Rostedt <rostedt@goodmis.org>
>>     Cc: Frederic Weisbecker <fweisbec@gmail.com>
>>     Cc: Ingo Molnar <mingo@redhat.com>
>>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
>> index f06ce9ab692c..eee73605c5a0 100644
>> --- a/drivers/edac/edac_core.h
>> +++ b/drivers/edac/edac_core.h
>> @@ -468,7 +468,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
>>  			  const int layer2,
>>  			  const char *msg,
>>  			  const char *other_detail,
>> -			  const void *mcelog);
>> +			  const void *arch_log);
>>  
>>  /*
>>   * edac_device APIs
>> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
>> index e5b55632359f..eb078ec62044 100644
>> --- a/drivers/edac/edac_mc.c
>> +++ b/drivers/edac/edac_mc.c
>> @@ -33,6 +33,10 @@
>>  #include "edac_core.h"
>>  #include "edac_module.h"
>>  
>> +#define CREATE_TRACE_POINTS
>> +#define TRACE_INCLUDE_PATH ../../include/ras
>> +#include <ras/ras_event.h>
>> +
>>  /* lock to memory controller's control array */
>>  static DEFINE_MUTEX(mem_ctls_mutex);
>>  static LIST_HEAD(mc_devices);
>> @@ -381,6 +385,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
>>  	 * which will perform kobj unregistration and the actual free
>>  	 * will occur during the kobject callback operation
>>  	 */
>> +
>>  	return mci;
>>  }
>>  EXPORT_SYMBOL_GPL(edac_mc_alloc);
>> @@ -972,6 +977,27 @@ static void edac_ue_error(struct mem_ctl_info *mci,
>>  }
>>  
>>  #define OTHER_LABEL " or "
>> +
>> +/**
>> + * edac_mc_handle_error - reports a memory event to userspace
>> + *
>> + * @type:		severity of the error (CE/UE/Fatal)
>> + * @mci:		a struct mem_ctl_info pointer
>> + * @page_frame_number:	mem page where the error occurred
>> + * @offset_in_page:	offset of the error inside the page
>> + * @syndrome:		ECC syndrome
>> + * @layer0:		Memory layer0 position
>> + * @layer1:		Memory layer2 position
>> + * @layer2:		Memory layer3 position
>> + * @msg:		Message meaningful to the end users that
>> + *			explains the event
>> + * @other_detail:	Technical details about the event that
>> + *			may help hardware manufacturers and
>> + *			EDAC developers to analyse the event
> 
> 					analyze it.

Analyse is the same as analyze [2].

[2] http://dictionary.reference.com/browse/analyse

> 
>> + * @arch_log:		Architecture-specific struct that can
>> + *			be used to add extended information to the
>> + *			tracepoint, like dumping MCE registers.
>> + */
>>  void edac_mc_handle_error(const enum hw_event_mc_err_type type,
>>  			  struct mem_ctl_info *mci,
>>  			  const unsigned long page_frame_number,
>> @@ -982,7 +1008,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
>>  			  const int layer2,
>>  			  const char *msg,
>>  			  const char *other_detail,
>> -			  const void *mcelog)
>> +			  const void *arch_log)
>>  {
>>  	/* FIXME: too much for stack: move it to some pre-alocated area */
>>  	char detail[80], location[80];
>> @@ -1119,21 +1145,27 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
>>  	}
>>  
>>  	/* Memory type dependent details about the error */
>> -	if (type == HW_EVENT_ERR_CORRECTED) {
>> +	if (type == HW_EVENT_ERR_CORRECTED)
>>  		snprintf(detail, sizeof(detail),
>>  			"page:0x%lx offset:0x%lx grain:%d syndrome:0x%lx",
>>  			page_frame_number, offset_in_page,
>>  			grain, syndrome);
>> -		edac_ce_error(mci, pos, msg, location, label, detail,
>> -			      other_detail, enable_per_layer_report,
>> -			      page_frame_number, offset_in_page, grain);
>> -	} else {
>> +	else
>>  		snprintf(detail, sizeof(detail),
>>  			"page:0x%lx offset:0x%lx grain:%d",
>>  			page_frame_number, offset_in_page, grain);
>>  
>> +	/* Report the error via the trace interface */
>> +	trace_mc_event(type, mci->mc_idx, msg, label, location,
>> +		       detail, other_detail);
>> +
>> +	/* Report the error via the edac_mc_printk() interface */
>> +	if (type == HW_EVENT_ERR_CORRECTED)
>> +		edac_ce_error(mci, pos, msg, location, label, detail,
>> +			      other_detail, enable_per_layer_report,
>> +			      page_frame_number, offset_in_page, grain);
>> +	else
>>  		edac_ue_error(mci, pos, msg, location, label, detail,
>>  			      other_detail, enable_per_layer_report);
>> -	}
>>  }
>>  EXPORT_SYMBOL_GPL(edac_mc_handle_error);
>> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
>> new file mode 100644
>> index 000000000000..66f6a43151dc
>> --- /dev/null
>> +++ b/include/ras/ras_event.h
>> @@ -0,0 +1,78 @@
>> +#undef TRACE_SYSTEM
>> +#define TRACE_SYSTEM ras
>> +#define TRACE_INCLUDE_FILE ras_event
>> +
>> +#if !defined(_TRACE_HW_EVENT_MC_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _TRACE_HW_EVENT_MC_H
>> +
>> +#include <linux/tracepoint.h>
>> +#include <linux/edac.h>
>> +#include <linux/ktime.h>
>> +
>> +/*
>> + * Hardware Events Report
>> + *
>> + * Those events are generated when hardware detected a corrected or
>> + * uncorrected event, and are meant to replace the current API to report
>> + * errors defined on both EDAC and MCE subsystems.
>> + *
>> + * FIXME: Add events for handling memory errors originated from the
>> + *        MCE subsystem.
>> + */
>> +
>> +/*
>> + * Hardware-independent Memory Controller specific events
>> + */
>> +
>> +/*
>> + * Default error mechanisms for Memory Controller errors (CE and UE)
>> + */
>> +TRACE_EVENT(mc_event,
>> +
>> +	TP_PROTO(const unsigned int err_type,
>> +		 const unsigned int mc_index,
>> +		 const char *error_msg,
>> +		 const char *label,
>> +		 const char *location,
>> +		 const char *core_detail,
>> +		 const char *driver_detail),
>> +
>> +	TP_ARGS(err_type, mc_index, error_msg, label, location,
>> +		core_detail, driver_detail),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	unsigned int,	err_type		)
>> +		__field(	unsigned int,	mc_index		)
>> +		__string(	msg,		error_msg		)
>> +		__string(	label,		label			)
>> +		__string(	detail,		core_detail		)
>> +		__string(	location,	location		)
>> +		__string(	driver_detail,	driver_detail		)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->err_type		= err_type;
>> +		__entry->mc_index		= mc_index;
>> +		__assign_str(msg, error_msg);
>> +		__assign_str(label, label);
>> +		__assign_str(location, location);
>> +		__assign_str(detail, core_detail);
>> +		__assign_str(driver_detail, driver_detail);
>> +	),
>> +
>> +	TP_printk("%s error:%s on memory stick \"%s\" (mc:%d %s %s %s)",
>> +		  (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
>> +			((__entry->err_type == HW_EVENT_ERR_FATAL) ?
>> +			"Fatal" : "Uncorrected"),
>> +		  __get_str(msg),
>> +		  __get_str(label),
>> +		  __entry->mc_index,
>> +		  __get_str(location),
>> +		  __get_str(detail),
>> +		  __get_str(driver_detail))
>> +);
>> +
>> +#endif /* _TRACE_HW_EVENT_MC_H */
>> +
>> +/* This part must be outside protection */
>> +#include <trace/define_trace.h>
> 

