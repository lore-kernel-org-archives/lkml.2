Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab1GGTnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:43:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52076 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1GGTnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:43:49 -0400
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110707092102.GI4590@erda.amd.com>
References: <20110703150430.GV4590@erda.amd.com>
	 <1309716271.3282.6.camel@twins> <20110704175927.GZ4590@erda.amd.com>
	 <1309855905.3282.42.camel@twins> <20110705091252.GA5725@elte.hu>
	 <20110706165357.GG4590@erda.amd.com> <1309972368.3282.317.camel@twins>
	 <20110707092102.GI4590@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Jul 2011 21:38:45 +0200
Message-ID: <1310067525.3282.636.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 11:21 +0200, Robert Richter wrote:
> On 06.07.11 13:12:48, Peter Zijlstra wrote:
> > On Wed, 2011-07-06 at 18:53 +0200, Robert Richter wrote:
> 
> > > The system topology is always in /sys, also for device nodes. But we
> > > can't get a device file descriptor from /sys. I doubt /sys is capable
> > > to handle a device use count (need to be checked). We actually must
> > > grab the pmu while attaching events to it. And, user space
> > > implementation is must easier with /dev (see code in my previous
> > > mail).
> > 
> > Well you must not per-se, from a user's perspective there isn't much of
> > a difference between if the sys_perf_event_open() fails or if the
> > initial file open fails, in both cases he's not getting an event.
> 
> It is not that I want to create event handles with open. 

Never said you wanted to do that.

> For this
> there is the syscall. I use open() to create a unique reference to a
> pmu in userspace. 

Yeah, and its pointless.

Which ever way around you turn this problem it always ends up looking
like:

  fd = open("/sys/foo");
  event = sys_perf_event_open();
  close(fd);
    /* do stuff */
  close(event);

The pmu not going away between the open() and sys_perf_event_open() is
irrelevant. What is required is the success of both calls, up until that
happens its a fail.

> > perf stat -e IBS:fetches will always have a fail against rmmod, rmmod
> > could complete before we try to open the file (assuming IBS is a
> > module).
> > 
> > > 
> > > My patch also includes code that creates a device class. It is also
> > > visible in /sys/class/pmu/*.
> > 
> > So not only are you providing a duplicate of existing interfaces, you're
> > actually duplicating information inside sysfs as well.
> 
> This is not duplication. /sys provides information about system
> hierarchy, /dev is for controlling devices. Thus, every device node is
> visible in /sys as it is part of the system.

It is duplication, we already have a /sys representation of every pmu,
by adding /sys/class/pmu/ you add another, that's pure duplication.
