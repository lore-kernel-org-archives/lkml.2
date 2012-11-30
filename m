Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab2K3BvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:51:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26033 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab2K3BvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:51:22 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=bHYkjrJBMqQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Prf3J34inRMA:10 a=cH6R9-kdAAAA:8 a=iag1E9FuI4TUD2Hp_4cA:9 a=PUjeQqilurYA:10 a=bt0zGP92IBIA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354240279.6276.131.camel@gandalf.local.home>
Subject: Re: [PATCH 1/3] aerdrv: Trace Event for AER
From: Steven Rostedt <rostedt@goodmis.org>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2012 20:51:19 -0500
In-Reply-To: <20121129215443.5483.43364.stgit@grignak.americas.hpqcorp.net>
References: <20121129215443.5483.43364.stgit@grignak.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-29 at 14:54 -0700, Lance Ortiz wrote:
> This header file will define a new trace event that will be triggered when
> a AER event occurs.  The following data will be provided to the trace 
> event.
> 
> char * name -	String containing the device path
> 
> u32 status - 	Either the correctable or uncorrectable register 
> 		indicating what error or errors have been see.
> 
> u8 severity - 	error severity 0:NONFATAL 1:FATAL 2:CORRECTED
> 
> The trace event will also provide a trace string that may look like:
> 
> "0000:05:00.0 PCIe Bus Error:severity=Uncorrected (Non-Fatal), Poisoned
> TLP"
> 
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> ---
> 
>  include/ras/aer_event.h |   77 +++++++++++++++++++++++++++++++++++++++++++++++

Is there a reason this header is here? Egad, I never noticed the
ras_event.h that is there. This include/ras directory was created for
the sole purpose of trace events! This is not the way to do this.

Please look at the sample in samples/trace_events/

The proper way is to keep the header by the driver. Then you can simply
include the header with "aer_event.h".

But to have the macro magic work, you need to modify the Makefile to
have something like:

CFLAGS_aerdrv_errprint.o = -I$(src)

and it will be able to find your headers without a problem.
The ras_event.h needs to be fixed too. I may just send a patch myself.

-- Steve


>  1 files changed, 77 insertions(+), 0 deletions(-)
>  create mode 100644 include/ras/aer_event.h
> 
> diff --git a/include/ras/aer_event.h b/include/ras/aer_event.h
> new file mode 100644
> index 0000000..735c973
> --- /dev/null
> +++ b/include/ras/aer_event.h
> @@ -0,0 +1,77 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM aer
> +#define TRACE_INCLUDE_FILE aer_event
> +
> +#if !defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_AER_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/edac.h>
> +
> +
> +/*
> + * Anhance Error Reporting (AER) PCIE Report Error
> + *
> + * These events are generated when hardware detects a corrected or
> + * uncorrected event on a pci express device and reports
> + * errors.  The event reports the following data.
> + *
> + * char * dev_name -	String containing the device identification
> + * u32 status -		Either the correctable or uncorrectable register
> + *			indicating what error or errors have been seen
> + * u8 severity -	error severity 0:NONFATAL 1:FATAL 2:CORRECTED
> + */
> +
> +#define correctable_error_string			\
> +	{BIT(0),	"Receiver Error"},		\
> +	{BIT(6),	"Bad TLP"},			\
> +	{BIT(7),	"Bad DLLP"},			\
> +	{BIT(8),	"RELAY_NUM Rollover"},		\
> +	{BIT(12),	"Replay Timer Timeout"},	\
> +	{BIT(13),	"Advisory Non-Fatal"}
> +
> +#define uncorrectable_error_string			\
> +	{BIT(4),	"Data Link Protocol"},		\
> +	{BIT(12),	"Poisoned TLP"},		\
> +	{BIT(13),	"Flow Control Protocol"},	\
> +	{BIT(14),	"Completion Timeout"},		\
> +	{BIT(15),	"Completer Abort"},		\
> +	{BIT(16),	"Unexpected Completion"},	\
> +	{BIT(17),	"Receiver Overflow"},		\
> +	{BIT(18),	"Malformed TLP"},		\
> +	{BIT(19),	"ECRC"},			\
> +	{BIT(20),	"Unsupported Request"}
> +
> +TRACE_EVENT(aer_event,
> +	TP_PROTO(const char *dev_name,
> +		 const u32 status,
> +		 const u8 severity),
> +
> +	TP_ARGS(dev_name, status, severity),
> +
> +	TP_STRUCT__entry(
> +		__string(	dev_name,	dev_name	)
> +		__field(	u32,		status		)
> +		__field(	u8,		severity	)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(dev_name, dev_name);
> +		__entry->status		= status;
> +		__entry->severity	= severity;
> +	),
> +
> +	TP_printk("%s PCIe Bus Error: severity=%s, %s\n",
> +		__get_str(dev_name),
> +		(__entry->severity == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
> +			((__entry->severity == HW_EVENT_ERR_FATAL) ?
> +			"Fatal" : "Uncorrected"),
> +		__entry->severity == HW_EVENT_ERR_CORRECTED ?
> +		__print_flags(__entry->status, "|", correctable_error_string) :
> +		__print_flags(__entry->status, "|", uncorrectable_error_string))
> +);
> +
> +#endif /* _TRACE_AER_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>


