Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2JPSpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:45:41 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60809 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773Ab2JPSpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:45:40 -0400
Date: Tue, 16 Oct 2012 11:31:48 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: acme@redhat.com, mingo@kernel.org, peterz@infradead.org,
        eranian@google.com, asharma@fb.com,
        Anton Blanchard <anton@au1.ibm.com>, paulus@samba.org,
        mpjohn@us.ibm.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] perf: Add a few generic stalled-cycles events
Message-ID: <20121016183148.GA25482@us.ibm.com>
References: <20121012012839.GA15348@us.ibm.com>
 <20121015155534.GR8285@erda.amd.com>
 <20121016100809.GS8285@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016100809.GS8285@erda.amd.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101618-7182-0000-0000-000002D971D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter [robert.richter@amd.com] wrote:
| Sukadev,
| 
| On 15.10.12 17:55:34, Robert Richter wrote:
| > On 11.10.12 18:28:39, Sukadev Bhattiprolu wrote:
| > > +  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_FIXED_POINT },
| > > +  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_LOAD_STORE },
| > > +  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_INSTRUCTION_FETCH },
| > > +  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES_BRANCH },
| > 
| > Instead of adding new hardware event types I would prefer to use raw
| > events in conjunction with sysfs, see e.g. the intel-uncore
| > implementation. Something like:
| > 
| >  $ find /sys/bus/event_source/devices/cpu/events/
| >  ...
| >  /sys/bus/event_source/devices/cpu/events/stalled-cycles-fixed-point
| >  /sys/bus/event_source/devices/cpu/events/stalled-cycles-load-store
| >  /sys/bus/event_source/devices/cpu/events/stalled-cycles-instruction-fetch
| >  /sys/bus/event_source/devices/cpu/events/stalled-cycles-branch
| >  ...
| >  $ cat /sys/bus/event_source/devices/cpu/events/stalled-cycles-fixed-point
| >  event=0xff,umask=0x00
| > 
| > Perf tool works then out-of-the-box with:
| > 
| >  $ perf record -e cpu/stalled-cycles-fixed-point/ ...
| 
| I refer here to arch/x86/kernel/cpu/perf_event_intel_uncore.c (should
| be in v3.7-rc1 or tip:perf/core). See the INTEL_UNCORE_EVENT_DESC()
| macro and 'if (type->event_descs) ...' in uncore_type_init(). The code
| should be reworked to be non-architectural.


Ok. I will look through that code. Does that mean we are trying to avoid
any more new hardware generic events ?

Also a broader question - is the sysfs approach intended for all raw events
or just for the generic events supported in the kernel ?

If it is intended for all events a CPU supports, isn't there a chance of
bloating kernel code ? Power7 has 530 events and Intel Nehalem (in libpfm)
seems to have 370 events. Would that mean we would need to represent all these
events in the kernel so they are available in sysfs ?

On a side note, how does the kernel on x86 use the 'config' information in 
say /sys/bus/event_source/devices/cpu/format/cccr ? On Power7, the raw
code encodes the information such as the PMC to use for the event. Is that
how the 'config' info in Intel is used ?

Does the 'config' info change from system to system or is it static for
a given event on a given CPU ?

I guess I am trying to understand if this mapping between event-name (event
code) and the config info is something the kernel needs/uses or is it something
the kernel simply passes through from userspace to CPU ?

AFAICT, on the Power we use the raw codes to determine which PMC to select
and which bits to set in some registers. That selection is static for a given 
CPU type such as Power7. If it is static, is it worth adding all this static 
mapping (for 530 events) into the kernel ?

If we don't add to the kernel, we don't seem to have a way to specify the 
events symbolically.

Thanks for you detailed comments.
| 
| PMU registration is implemented for a longer time already for all
| architectures and pmu types:
| 
|  /sys/bus/event_source/devices/*

Yes I see this.

| 
| But
| 
|  /sys/bus/event_source/devices/*/events/

Thanks for clarifying. I was looking to see if this was implemented too :-)

Sukadev

| 
| exists only for a small number of pmus. Perf tool support of this was
| implemented with:
| 
|  a6146d5 perf/tool: Add PMU event alias support
| 
| -Robert
| 
| -- 
| Advanced Micro Devices, Inc.
| Operating System Research Center

