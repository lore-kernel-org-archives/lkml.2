Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab0ESDe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 23:34:56 -0400
Received: from kroah.org ([198.145.64.141]:34521 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab0ESDez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 23:34:55 -0400
Date: Tue, 18 May 2010 20:35:41 -0700
From: Greg KH <greg@kroah.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v2 08/11] sysfs: introduce new interface
	sysfs_get_kobject
Message-ID: <20100519033541.GA25967@kroah.com>
References: <1274233723.3036.87.camel@localhost> <20100518200823.GC20223@kroah.com> <1274237717.3603.37.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274237717.3603.37.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 10:55:17AM +0800, Lin Ming wrote:
> On Wed, 2010-05-19 at 04:08 +0800, Greg KH wrote:
> > On Wed, May 19, 2010 at 01:48:43AM +0000, Lin Ming wrote:
> > > Need this interface in the later sysfs pmu lookup.
> > > 
> > > struct kobject *sysfs_get_kobject(struct file *file);
> > > Return the relative kobject of the sysfs file.
> > 
> > Ick, no.  Why would you ever have the file, yet not have the kobject
> > already?  Something is really wrong if this is needed.  Or strange.  Or
> > maybe both :)
> 
> Let me show you the scenario.
> 
> /sys/devices/system/cpu/event_source/
> `-- id
> 
> /sys/devices/system/cpu/events/
> |-- L1-dcache-load-misses
> |   |-- event_source -> ../../event_source
> 
> $perf top -e L1-dcache-load-misses
> 
> Lookup the pmu used to handle L1-dcache-load-misses as below,
> 
> 1. pmu_sys_fd =
> open("/sys/devices/system/cpu/events/L1-dcache-load-misses/event_source/id", ...)

You do that within the kernel?  or from userspace?

Either way, your id show callback will get called when you read or write
to that file, right?  Then you have your kobject.

> 2. pmu_sys_file = fget_light(pmu_sys_fd, ....)
> 
> 3. pmu_kobject = sysfs_get_kobject(pmu_sys_file)
> 
> 4. pmu_kobject is embedded in struct pmu, pmu = container_of(kobj,
> struct pmu, kobj);

Oh no.

You are just using the kobject sysfs tree to store your kobjects so you
can look them up again some time in the future from within the kernel?
Seriously?

What's wrong with a simple list of kobjects?  Or what the rest of the
kernel does (busses and devices and iterating over the devices for a
bus)?

Don't act like userspace here and try to use the sysfs filesystem layout
as a lookup into the kobject you are trying to find.  That's a
horrible abuse of sysfs.  One of the worse I have ever seen.  And I've
seen a lot of sysfs abuse over the years...

ick.

greg k-h
