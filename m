Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288Ab1CXWjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:39:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46472 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab1CXWjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:39:12 -0400
Date: Thu, 24 Mar 2011 23:39:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly
 Report Mechanism (HARM)
Message-ID: <20110324223907.GA10498@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Edac Mailing List <linux-edac@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1300996141.git.mchehab@redhat.com>
 <20110324173257.36680b90@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110324173257.36680b90@pedra>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 05:32:57PM -0300, Mauro Carvalho Chehab wrote:
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
>     3) drivers/edac/mce_amd.c  A recent addition - this driver hooks into
>     the mcelog path and decodes errors reported via machine check bank
>     registers in AMD processors to the console log using printk() [despite
>     being in the drivers/edac directory, this seems completely different
>     from classic EDAC to me].

Well, maybe it is time to rename drivers/edac/ to drivers/ras/ where all
RAS stuff should go.

[.. ]

> diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
> new file mode 100644
> index 0000000..a46ac61
> --- /dev/null
> +++ b/include/trace/events/hw_event.h
> @@ -0,0 +1,322 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM hw_event
> +
> +#if !defined(_TRACE_HW_EVENT_MC_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_HW_EVENT_MC_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/edac.h>
> +
> +/*
> + * Hardware Anomaly Report Mechanism (HARM) events
> + *
> + * Those events are generated when hardware detected a corrected or
> + * uncorrected event, and are meant to replace the current API to report
> + * errors defined on both EDAC and MCE subsystems.
> + */
> +
> +DECLARE_EVENT_CLASS(hw_event_class,
> +	TP_PROTO(const char *type, unsigned int instance),
> +	TP_ARGS(type, instance),
> +
> +	TP_STRUCT__entry(
> +		__field(	const char *,	type			)
> +		__field(	unsigned int,	instance		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->type	= type;
> +		__entry->instance = instance;
> +	),
> +
> +	TP_printk("Initialized %s#%d\n",
> +		__entry->type,
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
> + * Memory Controller specific events
> + */

I think this is too fine-grained. You see, all those error records are
of type MCE so there's no need to have a trace event for corrected,
uncorrected, out of range etc. error types. You basically add a
flags argument to the trace_mce_record() tracepoint so that you can
differentiate between the different error records in the tracebuffer.
Then, you add additional fields like above for the MCEs which report a
DRAM ECC error.

IOW, what we need are two basic error records (tracepoints, etc.): MCEs
and PCI(e) errors which are derived from the hw_event_class.

Btw, I've played with the MCE tracepoint extension a bit and it looks
doable: http://lkml.org/lkml/2010/5/15/40.

-- 
Regards/Gruss,
    Boris.
