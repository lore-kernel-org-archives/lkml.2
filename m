Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab2LDShB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 13:37:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2LDSg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 13:36:59 -0500
Date: Tue, 4 Dec 2012 16:36:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/3] aerdrv: Trace Event for AER
Message-ID: <20121204163618.2b7f6290@redhat.com>
In-Reply-To: <20121204170429.31397.50068.stgit@grignak.americas.hpqcorp.net>
References: <20121204170429.31397.50068.stgit@grignak.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 04 Dec 2012 10:04:30 -0700
Lance Ortiz <lance.ortiz@hp.com> escreveu:

> This header file will define a new trace event that will be triggered when
> a AER event occurs.  The following data will be provided to the trace
> event.
> 
> char * dev_name - The name of the slot where the device resides
>                   ([domain:]bus:device.function).
> 
> u32 status - Either the correctable or uncorrectable register
>              indicating what error or errors have been see.
> 
> u8 severity - error severity 0:NONFATAL 1:FATAL 2:CORRECTED
> 
> The trace event will also provide a trace string that may look like:
> 
> "0000:05:00.0 PCIe Bus Error:severity=Uncorrected (Non-Fatal), Poisoned
> TLP"
> 
> v1-v2 Move header from include/ras/aer_event.h to
> include/trace/events/ras.h
> v3-v4 Cleaned up comments and commit header
> v4-v5 More cleanup remove () from if statement in print.
>       Renamed string define to be more specific.
> v5-v6 change TRACE_SYSTEM define to be ras and not aer.
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> ---
> 
>  0 files changed, 0 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
> new file mode 100644
> index 0000000..88b8783
> --- /dev/null
> +++ b/include/trace/events/ras.h
> @@ -0,0 +1,77 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM ras
> +
> +#if !defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_AER_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/edac.h>
> +
> +
> +/*
> + * PCIe AER Trace event
> + *
> + * These events are generated when hardware detects a corrected or
> + * uncorrected event on a PCIe device. The event report has
> + * the following structure:
> + *
> + * char * dev_name -	The name of the slot where the device resides
> + *			([domain:]bus:device.function).
> + * u32 status -		Either the correctable or uncorrectable register
> + *			indicating what error or errors have been seen
> + * u8 severity -	error severity 0:NONFATAL 1:FATAL 2:CORRECTED
> + */
> +
> +#define aer_correctable_errors		\
> +	{BIT(0),	"Receiver Error"},		\
> +	{BIT(6),	"Bad TLP"},			\
> +	{BIT(7),	"Bad DLLP"},			\
> +	{BIT(8),	"RELAY_NUM Rollover"},		\
> +	{BIT(12),	"Replay Timer Timeout"},	\
> +	{BIT(13),	"Advisory Non-Fatal"}
> +
> +#define aer_uncorrectable_errors		\
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
> +		__entry->severity == HW_EVENT_ERR_CORRECTED ? "Corrected" :
> +			__entry->severity == HW_EVENT_ERR_FATAL ?
> +			"Fatal" : "Uncorrected",
> +		__entry->severity == HW_EVENT_ERR_CORRECTED ?
> +		__print_flags(__entry->status, "|", aer_correctable_errors) :
> +		__print_flags(__entry->status, "|", aer_uncorrectable_errors))
> +);
> +
> +#endif /* _TRACE_AER_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> 

Provided that a latter patch adds the missing bits and joins the strings used
both here and at aer, as proposed by Boris:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

-- 

Cheers,
Mauro
