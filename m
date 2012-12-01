Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab2LAKzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 05:55:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57735 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab2LAKzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 05:55:14 -0500
Date: Sat, 1 Dec 2012 11:55:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, rostedt@goodmis.org, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] aerdrv: Trace Event for AER
Message-ID: <20121201105510.GB7835@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
	lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
	rostedt@goodmis.org, mchehab@redhat.com, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121130213330.7649.51101.stgit@grignak.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121130213330.7649.51101.stgit@grignak.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 02:33:30PM -0700, Lance Ortiz wrote:
> This header file will define a new trace event that will be triggered when
> a AER event occurs.  The following data will be provided to the trace
> event.
> 
> char * name -	String containing the device path

Can we explain that device path more, even with an example? Something like
"position of the device in the PCI hierarchy, i.e. 0000:05:00.0"

> u32 status - 	Either the correctable or uncorrectable register
> 		indicating what error or errors have been see.

							  seen

> u8 severity - 	error severity 0:NONFATAL 1:FATAL 2:CORRECTED
> 
> The trace event will also provide a trace string that may look like:
> 
> "0000:05:00.0 PCIe Bus Error:severity=Uncorrected (Non-Fatal), Poisoned
> TLP"
> 
> v1-v2 Move header from include/ras/aer_event.h to
> include/trace/events/ras.h
> 
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> ---
> 
>  include/trace/events/ras.h |   77 ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 77 insertions(+), 0 deletions(-)
>  create mode 100644 include/trace/events/ras.h
> 
> diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
> new file mode 100644
> index 0000000..f77d009
> --- /dev/null
> +++ b/include/trace/events/ras.h
> @@ -0,0 +1,77 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM aer_event
> +#define TRACE_INCLUDE_FILE ras 

Applying: aerdrv: Trace Event for AER
/home/boris/kernel/linux-2.6/.git/rebase-apply/patch:15: trailing whitespace.
#define TRACE_INCLUDE_FILE ras 
warning: 1 line adds whitespace errors.

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

      PCIE Advanced Error Reporting (AER) tracepoint


> + *
> + * These events are generated when hardware detects a corrected or
> + * uncorrected event on a pci express device and reports

			     PCIE device. (no need for "and reports errors")

> + * errors.  The event reports the following data.

	       The event record has the following structure:

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

I'm wondering whether something else PCIe could use those error types
but I guess they'll pick them up from here if needed.

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

Apart from the minor issues above:

Acked-by: Borislav Petkov <bp@alien8.de>

Thanks.

-- 
Regards/Gruss,
    Boris.
