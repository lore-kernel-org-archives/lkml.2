Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab0LNB2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:28:46 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:37226 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab0LNB2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:28:45 -0500
Message-ID: <4D06C846.4030804@linux.vnet.ibm.com>
Date: Mon, 13 Dec 2010 17:28:38 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Carl Love <cel@linux.ibm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH 3/3 v3] perf: Update perf tool to monitor uncore events
References: <1291267238.2405.315.camel@minggr.sh.intel.com>
In-Reply-To: <1291267238.2405.315.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2010 09:20 PM, Lin Ming wrote:
> Uncore events are monitored with raw events with "ru" prefix("u" for uncore).
> Note that, per-task uncore event is not allowed.
>
> $ ./perf stat -e ru0101 -- ls
> No permission to collect stats.
> Consider tweaking /proc/sys/kernel/perf_event_paranoid.
>
> ./perf stat -a -C 0 -e ru0101 -- ls

Sorry for replying to this thread so late, but I have some concerns 
about this modification.

First of all, "uncore" is an x86-specific term and so it's not clear to 
me if you meant for all arches to utilize this encoding for all "not 
core but on the same die" events (IBM Power arch refers to this as 
"nest" logic).

In the case of the IBM PowerEN chip (aka WireSpeed Processor) we have a 
large number of "uncore" PMUs.  It's not clear to me how we should break 
them up using the syntax you've suggested here.  Until now, we (IBM) 
have stuck with encoding all PowerEN nest events as PERF_TYPE_RAW and 
utilizing the 64-bit config value to encode which PMU, which event, and 
other necessary event attribute bits.

In one scenario, we could utilize the "u" encoding as suggested in this 
patch, but then we'd be stuck with encoding the specific PMU into the 
config value, really not buying us any convenience.

Another way might be to introduce a bunch of new prefixes for each of 
the PMU's and add corresponding PERF_TYPE_* values.  Do we want a bunch 
of arch-specific PERF_TYPE_* values in include/linux/perf_event.h? 
Having that many PMUs, we might want a more sophisticated prefix scheme, 
perhaps something like what Stephane Eranian uses in libpfm4: 
<pmu>::nnnn, e.g:

perf stat -C 0 -e runc::0101
or more verbosely,
perf stat -C 0 -e runcore::0101

For the PowerEN chip, we have PMUs for these nest functional units:
XML accelerator
Regular expression accelerator
Crypto accelerator
PowerBus interface chiplet (0..3)
Network accelerator
Memory controller Synchronous (0..1)
Memory controller Asynchronous (0..1)
etc.

I can see value in adding something like:

perf stat -C 0 -e rmcs0::1d

On the other hand, I don't want to get carried away with this, when we 
have the sysfs solution coming down the road, which I think will reduce 
or eliminate the need for these prefixes.

Is PERF_TYPE_UNCORE and the "u" encoding intended to be a temporary 
solution?  How do you envision someone using sysfs to specify an uncore 
event (especially one with a raw encoding)?

- Corey
