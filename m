Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750874Ab2LCSvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:51:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59322 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab2LCSvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:51:05 -0500
Date: Mon, 3 Dec 2012 19:50:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, rostedt@goodmis.org, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] aerdrv: Trace Event for AER
Message-ID: <20121203185059.GA14798@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
	lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
	rostedt@goodmis.org, mchehab@redhat.com, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121203183305.26636.22979.stgit@grignak.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121203183305.26636.22979.stgit@grignak.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 11:33:05AM -0700, Lance Ortiz wrote:
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
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> ---
> 
>  include/trace/events/ras.h |   78 ++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 78 insertions(+), 0 deletions(-)
>  create mode 100644 include/trace/events/ras.h
> 
> diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
> new file mode 100644
> index 0000000..774303d
> --- /dev/null
> +++ b/include/trace/events/ras.h
> @@ -0,0 +1,78 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM aer_event
> +#define TRACE_INCLUDE_FILE ras
> +
> +#if !defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_AER_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/edac.h>
> +
> +
> +/*
> + * PCIe Advanced Error Reporting (AER) PCIE Report Error

Why do you insist on keeping this convoluted compound name? What does
"PCIe AER PCIe Report Error" even mean?

This is not unreadable technical documentation but something people
should actually understand. And it is simply a PCIe AER tracepoint. So
why the h*ll not call it by its real name?

> + *
> + * These events are generated when hardware detects a corrected or
> + * uncorrected event on a pci express device. The event report has

And you should stick to the same spelling for PCIe throughout the text,
so choose one and use it everywhere.

> + * the following structure:
> + *
> + * char * dev_name -	The name of the slot where the device resides
> + *			([domain:]bus:device.function).
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

Also, you haven't addressed Mauro's comment about other bits in the spec
which are not here. Why are you skipping them?

Thanks.

-- 
Regards/Gruss,
    Boris.
