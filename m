Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265Ab1CYKVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:21:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933837Ab1CYKVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:21:06 -0400
Message-ID: <4D8C6C80.8010600@redhat.com>
Date: Fri, 25 Mar 2011 07:20:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly Report
 Mechanism (HARM)
References: <cover.1300996141.git.mchehab@redhat.com> <20110324173257.36680b90@pedra> <20110324223907.GA10498@liondog.tnic>
In-Reply-To: <20110324223907.GA10498@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-03-2011 19:39, Borislav Petkov escreveu:
> On Thu, Mar 24, 2011 at 05:32:57PM -0300, Mauro Carvalho Chehab wrote:
>> Adds a trace class for handle hardware events
>>
>> Part of the description bellow is shamelessly copied from Tony
>> Luck's notes about the Hardware Error BoF during LPC 2010 [1].
>> Tony, thanks for your notes and discussions to generate the
>> h/w error reporting requirements.
>>
>> [1] http://lwn.net/Articles/416669/
>>
>>     We have several subsystems & methods for reporting hardware errors:
>>
>>     1) EDAC ("Error Detection and Correction").  In its original form
>>     this consisted of a platform specific driver that read topology
>>     information and error counts from chipset registers and reported
>>     the results via a sysfs interface.
>>
>>     2) mcelog - x86 specific decoding of machine check bank registers
>>     reporting in binary form via /dev/mcelog. Recent additions make use
>>     of the APEI extensions that were documented in version 4.0a of the
>>     ACPI specification to acquire more information about errors without
>>     having to rely reading chipset registers directly. A user level
>>     programs decodes into somewhat human readable format.
>>
>>     3) drivers/edac/mce_amd.c  A recent addition - this driver hooks into
>>     the mcelog path and decodes errors reported via machine check bank
>>     registers in AMD processors to the console log using printk() [despite
>>     being in the drivers/edac directory, this seems completely different
>>     from classic EDAC to me].
> 
> Well, maybe it is time to rename drivers/edac/ to drivers/ras/ where all
> RAS stuff should go.

Maybe, but I think that there are still some steps to go before that.
> 
> [.. ]
> 
>> diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
>> new file mode 100644
>> index 0000000..a46ac61
>> --- /dev/null
>> +++ b/include/trace/events/hw_event.h
>> @@ -0,0 +1,322 @@
>> +#undef TRACE_SYSTEM
>> +#define TRACE_SYSTEM hw_event
>> +
>> +#if !defined(_TRACE_HW_EVENT_MC_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _TRACE_HW_EVENT_MC_H
>> +
>> +#include <linux/tracepoint.h>
>> +#include <linux/edac.h>
>> +
>> +/*
>> + * Hardware Anomaly Report Mechanism (HARM) events
>> + *
>> + * Those events are generated when hardware detected a corrected or
>> + * uncorrected event, and are meant to replace the current API to report
>> + * errors defined on both EDAC and MCE subsystems.
>> + */
>> +
>> +DECLARE_EVENT_CLASS(hw_event_class,
>> +	TP_PROTO(const char *type, unsigned int instance),
>> +	TP_ARGS(type, instance),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	const char *,	type			)
>> +		__field(	unsigned int,	instance		)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->type	= type;
>> +		__entry->instance = instance;
>> +	),
>> +
>> +	TP_printk("Initialized %s#%d\n",
>> +		__entry->type,
>> +		__entry->instance)
>> +);
>> +
>> +/*
>> + * This event indicates that a hardware collection mechanism is started
>> + */
>> +DEFINE_EVENT(hw_event_class, hw_event_init,
>> +
>> +	TP_PROTO(const char *type, unsigned int instance),
>> +
>> +	TP_ARGS(type, instance)
>> +);
>> +
>> +
>> +/*
>> + * Memory Controller specific events
>> + */
> 
> I think this is too fine-grained. You see, all those error records are
> of type MCE so there's no need to have a trace event for corrected,
> uncorrected, out of range etc. error types. You basically add a
> flags argument to the trace_mce_record() tracepoint so that you can
> differentiate between the different error records in the tracebuffer.
> Then, you add additional fields like above for the MCEs which report a
> DRAM ECC error.
> 
> IOW, what we need are two basic error records (tracepoints, etc.): MCEs
> and PCI(e) errors which are derived from the hw_event_class.
>
> Btw, I've played with the MCE tracepoint extension a bit and it looks
> doable: http://lkml.org/lkml/2010/5/15/40.
> 

As discussed on LPC, those are some requirements for the subsystem:

*) Architecture independent (both power and arm are potentially interested)

*) Report errors against human readable labels (e.g. using motherboard
   labels to identify DIMM or PCI slots).  This is hard (will often need
   some platform-specific mapping table to provide, or override, detailed
   information).

*) General interface available for any kind of h/w error report (e.g.
   device driver might use it for board level problems, or IPMI might
   report fan speed problems or over-temperature events).

*) Useful to make it easy to adapt existing EDAC drivers, machine-check
   bank decoders and other existing error reporters to use this new
   mechanism.

*) Robust - should not lose error information.  If the platform provides
   some sort of persistent storage, should make use of it to preserve
   details for fatal errors across reboot.  But may need some threshold
   mechanism that copes with floods of errors from a failed object.

*) Flexible: Errors may be discovered by polling, or reported by some
   interrupt/exception

People at the audience also commented that there are some other parts of the
Kernel that produce hardware errors and may also be interesting to map them
via perf, so grouping them together into just two types may not fit.

Also, as we want to have errors generated even for uncorrected errors that
can be fatal, and the report system should provide user-friendly error
reports, just printing a MCE code (and the MCE-specific data) is not enough:
the error should be parsed on kernel to avoid loosing fatal errors.

Maybe the way I mapped is too fine-grained, and we may want to group some
events together, but, on the other hand, having more events allow users
to filter some events that may not be relevant to them. For example, some
systems with i7300 memory controller, under certain circumstances (it seems
to be related to a bug at BIOS quick boot implementation), don't properly 
initialize the memory controller registers. The net result is that, on every 
one second (the poll interval of the edac driver), a false error report is 
produced. Having events fine-grained, users can just change the perf filter 
to discard the false alarms, but keeping the other hardware errors enabled.
 
In the specific case of MCE errors, I think we should create a new
hw_event pair that will provide the decoded info and the raw MCE info, on
a format like:

	Corrected Error %s at label "%s" (CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: % x)
	Uncorrected Error %s at label "%s" (CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: % x)

This way, the info that it is relevant to the system admin is clearly pointed
(error type and label), while hardware vendors may use the MCE data to better
analyse the issue.

Cheers,
Mauro.
