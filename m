Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab0ETJWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:22:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:28157 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab0ETJWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:22:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,270,1272870000"; 
   d="scan'208";a="519670526"
Subject: Re: [RFC][PATCH v2 11/11] perf top: demo of how to use the sysfs
 interface
From: Lin Ming <ming.m.lin@intel.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4BF4F278.4000303@linux.vnet.ibm.com>
References: <1274233792.3036.90.camel@localhost>
	 <4BF42B6F.6000009@linux.vnet.ibm.com>
	 <1274318249.3603.135.camel@minggr.sh.intel.com>
	 <4BF4915B.10104@linux.vnet.ibm.com>
	 <1274321316.3603.143.camel@minggr.sh.intel.com>
	 <4BF4F278.4000303@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 20 May 2010 17:21:29 +0800
Message-Id: <1274347289.3603.162.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 16:27 +0800, Corey Ashford wrote:
> On 05/19/2010 07:08 PM, Lin Ming wrote:
> > On Thu, 2010-05-20 at 09:33 +0800, Corey Ashford wrote:
> >> On 5/19/2010 6:17 PM, Lin Ming wrote:
> >>> On Thu, 2010-05-20 at 02:18 +0800, Corey Ashford wrote:
> >>>>
> >>>> On 5/18/2010 6:49 PM, Lin Ming wrote:
> >>>>> Just a temporary patch to show how to use the pmu sysfs interface...
> >>>>>
> >>>>> Signed-off-by: Lin Ming<ming.m.lin@intel.com>
> >>>>> ---
> >>>>>   tools/perf/builtin-top.c |   13 +++++++++++++
> >>>>>   1 files changed, 13 insertions(+), 0 deletions(-)
> >>>>>
> >>>>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> >>>>> index adc179d..eaa9405 100644
> >>>>> --- a/tools/perf/builtin-top.c
> >>>>> +++ b/tools/perf/builtin-top.c
> >>>>> @@ -1206,6 +1206,7 @@ static void start_counter(int i, int counter)
> >>>>>   	struct perf_event_attr *attr;
> >>>>>   	int cpu;
> >>>>>   	int thread_index;
> >>>>> +	int sys_fd;
> >>>>>
> >>>>>   	cpu = profile_cpu;
> >>>>>   	if (target_tid == -1&&  profile_cpu == -1)
> >>>>> @@ -1226,9 +1227,21 @@ static void start_counter(int i, int counter)
> >>>>>
> >>>>>   	for (thread_index = 0; thread_index<  thread_num; thread_index++) {
> >>>>>   try_again:
> >>>>> +		/*
> >>>>> +		 * This is just an ugly demo of how to use the sysfs interface.
> >>>>> +		 * You can also parse the<event-name>  and open sys file as,
> >>>>> +		 * sys_fd = open("/sys/devices/system/cpu/events/<event-name>/event_source/id", O_RDONLY);
> >>>>> +		 */
> >>>>
> >>>> In this above case, does this sys_fd also specify the event I am going to open, in addition to its event source?  I'd assume not since event_source is a symlink to /sys/devices/system/cpu/event_source (right?)
> >>>
> >>> Right, this sys_fd only specifies the event source.
> >>>
> >>>> How do I specify the exact event id via the sysfs interface?
> >>>
> >>> /sys/devices/system/cpu/events/<event-name>/id
> >>>
> >>> But in this patch series, the event id sysfs interface is not used yet.
> >>
> >> So, I would open that id and then read the id code and place it in attr->config or maybe place
> >> the fd into attr (somewhere) ?
> >
> > Place the id code in attr->config.
> >
> >>
> >> We also need to take into account event "attributes" - other data that is needed to configure a specific event.  For example, think about a memory controller which has a PMU can count events in a particular memory range; we need to be able to supply the memory range somehow, and I don't think that can be accomplished by passing in the fd of a sysfs file that we've opened.
> >>
> >
> > Each event is a directory in the sysfs, so we can put all the event
> > "attributes" under it.
> >
> > For your example,
> > /sys/devices/system/node/events/<event-name>/id
> > /sys/devices/system/node/events/<event-name>/memory_range
> > ....
> >
> > Then we can read these attributes and pass the value into the syscall.
> >
> 
> I'm not sure I made the example clear.
> 
> Let's say I have a memory controller event called memory_write and it 
> has two attributes: low_addr and high_addr... writes to addresses 
> between the low_addr and high_addr will increment the counter.
> 
> As a user, I want to be able to specify a particular memory range, let's 
> say 0x1000000..0x2000000
> 
> A sysfs structure like this might be constructed:
> /sys/devices/system/node/events/memory_write
> /sys/devices/system/node/events/memory_write/attr
> /sys/devices/system/node/events/memory_write/attr/low_addr
> /sys/devices/system/node/events/memory_write/attr/low_addr/min
> /sys/devices/system/node/events/memory_write/attr/low_addr/max
> 
> In another posting I had also added a bit shift value, but there are so 
> few bits left in the attr->config, that I'm not sure this is a very 
> extensible mechanism, but just for the sake of illustration of the basic 
> idea, I'll add it here:
> /sys/devices/system/node/events/memory_write/attr/low_addr/shift
> 
> Then the same thing is repeated for the other attribute:
> /sys/devices/system/node/events/memory_write/attr/high_addr
> /sys/devices/system/node/events/memory_write/attr/high_addr/min
> /sys/devices/system/node/events/memory_write/attr/high_addr/max
> /sys/devices/system/node/events/memory_write/attr/high_addr/shift
> 
> In this scenario, a user tool (like perf) would be able to see that 
> there are attributes associated with the memory_write event, and it 
> knows the names and range of allowed values for these attributes.  The 
> shift value tells the tool how much to shift the attribute value before 
> OR'ing it into the attr->config value.

So different events may have different shift value for its attributes.
If an event has 4 attributes, each attribute will have a "shift" in
sysfs, right?

> 
> If we find that more than 64 bits are needed for the event code plus the 
> attribute values, perhaps shift values greater than 64 would denote to 
> place the attribute bits into a new attr field, like 
> attr->config_extra[shift / 64]
> 
> On the perf command line, then, a user could specify something like:
> 
> perf stat -e node::memory_write:low_addr=0x1000000:high_addr=0x2000000
> 
> What do you think?

I like your idea.

Thanks,
Lin Ming

> 
> - Corey

