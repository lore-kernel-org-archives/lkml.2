Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1GFRNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:13:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53410 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1GFRNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:13:00 -0400
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110706165357.GG4590@erda.amd.com>
References: <20110703150430.GV4590@erda.amd.com>
	 <1309716271.3282.6.camel@twins> <20110704175927.GZ4590@erda.amd.com>
	 <1309855905.3282.42.camel@twins> <20110705091252.GA5725@elte.hu>
	 <20110706165357.GG4590@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Jul 2011 19:12:48 +0200
Message-ID: <1309972368.3282.317.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 18:53 +0200, Robert Richter wrote:
> On 05.07.11 05:12:52, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > > Overall, my approach improves the perf design. It adds a better 
> > > > and more intuitve access to perf from user space with clear and 
> > > > common methods and interfaces. Please let me know the concerns 
> > > > you have.
> > > 
> > > Its redundant, this interface ship has sailed, its not going to 
> > > happen.
> > 
> > Even if we had the choice, i don't see how a /dev based enumeration 
> > of PMUs is in any way better than a topologically attached set of 
> > PMUs in /sys.
> > 
> > This kind of structure is nice in principle:
> > 
> >  # ls -l /dev/pmu/
> >  total 0
> >  crw-rw---- 1 root root 254, 5 Jul  8  2011 breakpoint
> >  crw-rw---- 1 root root 254, 4 Jul  8  2011 cpu
> >  crw-rw---- 1 root root 254, 6 Jul  8  2011 proto
> >  crw-rw---- 1 root root 254, 1 Jul  8  2011 software
> >  crw-rw---- 1 root root 254, 2 Jul  8  2011 tracepoint
> > 
> > But it should be done in /sys/.
> 
> I have to learn yet why /dev is bad and /sys is good...

Its not so much /dev is bad, as not quite suited for this.

> The system topology is always in /sys, also for device nodes. But we
> can't get a device file descriptor from /sys. I doubt /sys is capable
> to handle a device use count (need to be checked). We actually must
> grab the pmu while attaching events to it. And, user space
> implementation is must easier with /dev (see code in my previous
> mail).

Well you must not per-se, from a user's perspective there isn't much of
a difference between if the sys_perf_event_open() fails or if the
initial file open fails, in both cases he's not getting an event.

perf stat -e IBS:fetches will always have a fail against rmmod, rmmod
could complete before we try to open the file (assuming IBS is a
module).

> 
> My patch also includes code that creates a device class. It is also
> visible in /sys/class/pmu/*.

So not only are you providing a duplicate of existing interfaces, you're
actually duplicating information inside sysfs as well.


