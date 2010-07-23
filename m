Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0GWKob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:44:31 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:6577 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756089Ab0GWKo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:44:29 -0400
X-SpamScore: -10
X-BigFish: VPS-10(z1039oz1432N98dN936eM10d1Izz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L60B5N-02-43Q-02
X-M-MSG: 
Date: Fri, 23 Jul 2010 12:44:12 +0200
From: Robert Richter <robert.richter@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
Subject: Re: [RFC][PATCH v1 02/15] perf: export generic hardware events via
 sysfs
Message-ID: <20100723104412.GA26154@erda.amd.com>
References: <1279797142.20942.83.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1279797142.20942.83.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.07.10 07:12:22, Lin Ming wrote:
> Generic hardware events are exported under
> /sys/devices/system/cpu/cpu0...N/events, for example
> 
> /sys/devices/system/cpu/cpu0/events
> |-- L1-dcache-load-misses
> |   |-- config
> |   `-- type

The sysfs approach came up as a solution to connect to dynamically
added pmus of various kind of hardware. The current mechanism using
config/type style did not fit anymore because we would have to
continuously extend the syscall i/f by new flags and attributes for
every new event. So, the problem is not which config and type
parameters to use for creating an event, we need a _different_ way for
this.

The config and type value you expose to sysfs are only used for
setting up the syscall. So, I want to bring up my idea again here that
I posted some days ago to lkml, using a unique sysfs id to specify
event classes.

Simply export an id (an u64), like:

 |-- L1-dcache-load-misses  ===> event name
 |   `-- id                 ===> event id

... and then extend the syscall to enable an event by its sysfs id:

            memset(&attr, 0, sizeof(attr));
            attr.type        = PERF_TYPE_SYSFS;
            attr.sysfs_id    = sysfs_id;
            attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
            attr.config      = config;
            ...

The config value can then be (re-)used to setup this _specific_ event
individually.

The kernel knows the id and is able to route the event request
directly to that particular pmu, something like:

struct event_kobject {
       struct kobject *kobj;
       u64 id;
       struct pmu *pmu;
       struct event_kobject *next;
};

struct event_kobject *eclass;

eclass = find_event_kobject(id);
eclass->pmu->event_init(event);
...

This is very simple and flexible and solves the original problem too.

(reposting my previous mail:)

You still need knowledge of what the event is measuring and how it is
set up or configured. Maybe the configuration may left blank if the
event can be setup without it. But with this approach you can get file
descriptors for every event a user may be interested in simply by
looking into sysfs.

For example, I was thinking of perfctr events vs. ibs events. The cpu
could setup something like:

/sys/devices/system/cpu/cpu0...cpuN/events/perfctr/id
/sys/devices/system/cpu/cpu0...cpuN/events/ibs_op/id

Both events are setup with one 64 bit config value that is basically
the event's configuration msr (x86 perfctr or AMD IBS). These are
definded in the hardware specifications. Its formats differ. You could
then open the event file descriptor using the sysfs id and use the
config value to customize the event. You don't have a complicated
setup or implementation to detect which kind of event you want to use
as the id indicates the type of event.

Actually, we could setup e.g. also trace events with this mechanism.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

