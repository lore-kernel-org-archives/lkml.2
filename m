Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438Ab0GTSaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 14:30:35 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:48482
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761424Ab0GTSac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 14:30:32 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz1432N98dN936eM10d1Izz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5VCQK-02-1IB-02
X-M-MSG: 
Date: Tue, 20 Jul 2010 20:30:18 +0200
From: Robert Richter <robert.richter@amd.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
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
Message-ID: <20100720183018.GN26154@erda.amd.com>
References: <20100624173315.GA30403@elte.hu>
 <1277792114.5400.5.camel@minggr.sh.intel.com>
 <20100629085532.GE22344@elte.hu>
 <1277803248.5400.16.camel@minggr.sh.intel.com>
 <20100629102656.GA25512@elte.hu>
 <1278057996.3841.26.camel@minggr.sh.intel.com>
 <4C40F750.4000607@linux.vnet.ibm.com>
 <1279604908.23815.21.camel@minggr.sh.intel.com>
 <20100720151920.GC21909@erda.amd.com>
 <4C45E1C9.6010402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C45E1C9.6010402@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.07.10 13:50:01, Corey Ashford wrote:

> > ... and then extend the syscall to enable an event by its sysfs id:
> >
> >              memset(&attr, 0, sizeof(attr));
> >              attr.type        = PERF_TYPE_SYSFS;
> >              attr.sysfs_id    = sysfs_id;
> >              attr.sample_type = PERF_SAMPLE_CPU | PERF_SAMPLE_RAW;
> >              attr.config      = config;
> > 	    ...

> Your example above still shows the .config member being set.  Was that 
> intentional?
> 
> Maybe another way to accomplish this would be to reuse the .config field 
> for the sysfs_id.

This was intended as this could be used to configure the event,
otherwise there is no way to setup the event with certain
parameters. The config value will be event specific then and we can be
sure the parameter belongs to _this_ kind of event.

> We still need a way to deal with event attributes though, so something 
> more than a single sysfs_id would be needed to specify the event completely.

It is true that you still need knowledge of what the event is
measuring and how it is set up or configured. Maybe the configuration
may left blank if the event can be setup without it. But with this
approach you can get file descriptors for every event a user may be
interested in simply by looking into sysfs.

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

