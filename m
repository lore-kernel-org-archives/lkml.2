Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab0G2D3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 23:29:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:60931 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab0G2D3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 23:29:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,277,1278313200"; 
   d="scan'208";a="642743462"
Subject: Re: [RFC][PATCH v1 02/15] perf: export generic hardware events via
 sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
In-Reply-To: <20100723104412.GA26154@erda.amd.com>
References: <1279797142.20942.83.camel@minggr.sh.intel.com>
	 <20100723104412.GA26154@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 11:29:48 +0800
Message-ID: <1280374188.20797.108.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 18:44 +0800, Robert Richter wrote:
> On 22.07.10 07:12:22, Lin Ming wrote:
> > Generic hardware events are exported under
> > /sys/devices/system/cpu/cpu0...N/events, for example
> > 
> > /sys/devices/system/cpu/cpu0/events
> > |-- L1-dcache-load-misses
> > |   |-- config
> > |   `-- type
> 
> The sysfs approach came up as a solution to connect to dynamically
> added pmus of various kind of hardware. The current mechanism using
> config/type style did not fit anymore because we would have to
> continuously extend the syscall i/f by new flags and attributes for
> every new event. So, the problem is not which config and type
> parameters to use for creating an event, we need a _different_ way for
> this.
> 
> The config and type value you expose to sysfs are only used for
> setting up the syscall. So, I want to bring up my idea again here that
> I posted some days ago to lkml, using a unique sysfs id to specify
> event classes.
> 
> Simply export an id (an u64), like:
> 
>  |-- L1-dcache-load-misses  ===> event name
>  |   `-- id                 ===> event id
> 
> ... and then extend the syscall to enable an event by its sysfs id:
> 
>             memset(&attr, 0, sizeof(attr));
>             attr.type        = PERF_TYPE_SYSFS;
>             attr.sysfs_id    = sysfs_id;
>             attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
>             attr.config      = config;
>             ...
> 

With your proposal, seems that all the attributes needed to set up an
event is still specified by user, instead of reading them from sysfs.

For example, how to trace sda block_bio_backmerge event? Did you still
need  "--filter" option?
perf record -e /sys/.../sda/events/block_bio_backmerge --filter "dev==0"

Why not show the "filter" in sysfs? like below

/sys/devices/pci0000:00/0000:00:1f.1/host0/target0:0:0/0:0:0:0/block/sda/events
|-- block_bio_backmerge
|   |-- config
|   |-- type
|   |-- filter

Then userspace tool can read the attributes and set up the event
automatically.

But the difficulty is different type of events have different set of
attributes, that we need a unify way to let userspace tool know what
attributes are available.

So my original idea was to export as many attributes as possible for
each event.

Thanks,
Lin Ming

> The config value can then be (re-)used to setup this _specific_ event
> individually.
> 
> The kernel knows the id and is able to route the event request
> directly to that particular pmu, something like:
> 
> struct event_kobject {
>        struct kobject *kobj;
>        u64 id;
>        struct pmu *pmu;
>        struct event_kobject *next;
> };
> 
> struct event_kobject *eclass;
> 
> eclass = find_event_kobject(id);
> eclass->pmu->event_init(event);
> ...
> 
> This is very simple and flexible and solves the original problem too.
> 
> (reposting my previous mail:)
> 
> You still need knowledge of what the event is measuring and how it is
> set up or configured. Maybe the configuration may left blank if the
> event can be setup without it. But with this approach you can get file
> descriptors for every event a user may be interested in simply by
> looking into sysfs.
> 
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
> 
> -Robert
> 


