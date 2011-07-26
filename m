Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab1GZEoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 00:44:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1GZEoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 00:44:32 -0400
Date: Mon, 25 Jul 2011 21:42:57 -0700
From: Greg KH <gregkh@suse.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH v2 1/6] perf: Add interface to add general events to sysfs
Message-ID: <20110726044257.GB27720@suse.de>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
 <1310740503-15608-2-git-send-email-ming.m.lin@intel.com>
 <1310996068.13765.67.camel@twins>
 <1311581475.3938.1477.camel@minggr.sh.intel.com>
 <1311582723.2617.50.camel@laptop>
 <20110725152038.GA23356@suse.de>
 <1311642367.3938.1516.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311642367.3938.1516.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 09:06:07AM +0800, Lin Ming wrote:
> On Mon, 2011-07-25 at 23:20 +0800, Greg KH wrote:
> > On Mon, Jul 25, 2011 at 10:32:03AM +0200, Peter Zijlstra wrote:
> > > On Mon, 2011-07-25 at 16:11 +0800, Lin Ming wrote:
> > > > It's strange that I didn't find a way to check if a directory is present
> > > > in sysfs. Any hint?
> > > 
> > > sysfs is voodoo for me, best I can come up with is, ask the sysfs
> > > folks ;-)
> > > 
> > > Kay, Greg?
> > 
> > What are you trying to do here specifically?
> 
> Now there are perf event source devices in sysfs.

As of what kernel release?

> $ tree /sys/bus/event_source/devices/
> /sys/bus/event_source/devices/
> |-- breakpoint
> |-- cpu
> |-- software
> `-- tracepoint
> 
> I want to create a "events" directory to hold the most useful events
> under the event_source.

Then use the attribute group for that.

> $ tree /sys/bus/event_source/devices/cpu
> | -- events
> 
> Then add one event each time to the "events" dir.
> 
> Add "event1"
> $ tree /sys/bus/event_source/devices/cpu
> | -- events
>      | -- event1
> 
> Add "event2"
> $ tree /sys/bus/event_source/devices/cpu
> | -- events
>      | -- event1
>      | -- event2
> 
> So at the first time to add a event I need to check if the "events"
> directory is present. If not, create it.
> 
> Like below pseudo code,
> 
> int perf_pmu_add_event(struct pmu *pmu, const char *name, ....)
> {
> 	if there is no "events" dir under pmu->dev->kobj
> 		then create "events" dir
> 
> 	add event "name" to "events"
> 
> 	return ....
> }
> 
> So the problem is, for example, how to check if there is a "events" dir
> under /sys/bus/event_source/devices/cpu in kernel.

Just use the proper attribute group and you will be fine.  That will
create the directory automatically.

And I really don't think sysfs is good for this, as you don't have a
bus, and your devices aren't on that bus, and the subdirs you are
creating are not "normal" for sysfs.

Why not create your own filesystem?

greg k-h
