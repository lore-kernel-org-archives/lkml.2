Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab0GTVSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 17:18:51 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33167 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab0GTVSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 17:18:48 -0400
Message-ID: <4C4612B2.6050401@linux.vnet.ibm.com>
Date: Tue, 20 Jul 2010 14:18:42 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [rfc] Describe events in a structured way via sysfs
References: <20100624173315.GA30403@elte.hu> <1277792114.5400.5.camel@minggr.sh.intel.com> <20100629085532.GE22344@elte.hu> <1277803248.5400.16.camel@minggr.sh.intel.com> <20100629102656.GA25512@elte.hu> <1278057996.3841.26.camel@minggr.sh.intel.com> <4C40F750.4000607@linux.vnet.ibm.com> <1279604908.23815.21.camel@minggr.sh.intel.com> <20100720151920.GC21909@erda.amd.com> <4C45E1C9.6010402@linux.vnet.ibm.com> <20100720183018.GN26154@erda.amd.com>
In-Reply-To: <20100720183018.GN26154@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 11:30 AM, Robert Richter wrote:
> On 20.07.10 13:50:01, Corey Ashford wrote:
>
>>> ... and then extend the syscall to enable an event by its sysfs id:
>>>
>>>               memset(&attr, 0, sizeof(attr));
>>>               attr.type        = PERF_TYPE_SYSFS;
>>>               attr.sysfs_id    = sysfs_id;
>>>               attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
>>>               attr.config      = config;
>>> 	    ...
>
>> Your example above still shows the .config member being set.  Was that
>> intentional?
>>
>> Maybe another way to accomplish this would be to reuse the .config field
>> for the sysfs_id.
>
> This was intended as this could be used to configure the event,
> otherwise there is no way to setup the event with certain
> parameters. The config value will be event specific then and we can be
> sure the parameter belongs to _this_ kind of event.
>
>> We still need a way to deal with event attributes though, so something
>> more than a single sysfs_id would be needed to specify the event completely.
>
> It is true that you still need knowledge of what the event is
> measuring and how it is set up or configured. Maybe the configuration
> may left blank if the event can be setup without it. But with this
> approach you can get file descriptors for every event a user may be
> interested in simply by looking into sysfs.
>

Yes, that would be a nice feature.

> For example, I was thinking of perfctr events vs. ibs events. The cpu
> could setup something like:
>
> /sys/devices/system/cpu/cpu0...cpuN/events/perfctr/id
> /sys/devices/system/cpu/cpu0...cpuN/events/ibs_op/id
>
> Both events are setup with one 64 bit config value that is basically
> the event's configuration msr (x86 perfctr or AMD IBS). These are
> definded in the hardware specifications. Its formats differ. You could
> then open the event file descriptor using the sysfs id and use the
> config value to customize the event. You don't have a complicated
> setup or implementation to detect which kind of event you want to use
> as the id indicates the type of event.
>
> Actually, we could setup e.g. also trace events with this mechanism.

In perf_events, as I recall, they started out with a combined type and 
config field, but it quickly became obvious that config was going to get 
too crowded even with 64 bits available, so they were split up into 
separate type and config fields.  I fear that's what would happen to the 
sysfs_id value as well... it would be too crowded.

Retaining the type and config nodes in sysfs makes it very clear for a 
programmer as to how to use them.... just read and copy them into the 
attr struct's corresponding members, and requires no changes to the 
existing attr struct (at least for the moment).

- Corey
