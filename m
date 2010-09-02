Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0IBRWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:22:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab0IBRWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:22:23 -0400
Date: Thu, 2 Sep 2010 13:22:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Nauman Rafique <nauman@google.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Divyesh Shah <dpshah@google.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, arighi@develer.com,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC PATCH] Bio Throttling support for block IO controller
Message-ID: <20100902172204.GC2702@redhat.com>
References: <20100901175830.GC22149@redhat.com>
 <20100901200756.GE22149@redhat.com>
 <20100902151824.GA2702@redhat.com>
 <AANLkTikTskke8UnDNj7LFX7EopX8t-0jqb-_Ogt359ik@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikTskke8UnDNj7LFX7EopX8t-0jqb-_Ogt359ik@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 09:22:50AM -0700, Nauman Rafique wrote:

[..]
> >> > - How to handle the current blkio cgroup stats file and two policies
> >> >   in the background. If for some reason both throttling and proportional
> >> >   BW policies are operating on request queue, then stats will be very
> >> >   confusing.
> >> >
> >> >   May be we can allow activating either throttling or proportional BW
> >> >   policy per request queue and we can create a /sys tunable to list and
> >> >   chose between policies (something like choosing IO scheduler). The
> >> >   only downside of this apporach is that user also need to be aware of
> >> >   the storage hierachy and activate right policy at each node/request
> >> >   queue.
> >>
> >> Thinking more about it. The issue of stats from proportional bandwidth
> >> controller and max bandwidth controller clobbering each other can
> >> probably be solved by also specifying policy name with the stat. For
> >> example, currently blkio.io_serviced, looks as follows.
> >>
> >> # cat blkio.io_serviced
> >> 253:2 Read 61
> >> 253:2 Write 0
> >> 253:2 Sync 61
> >> 253:2 Async 0
> >> 253:2 Total 61
> >>
> >> We can introduce one more field to specify policy for which this stats are as
> >> follows.
> >>
> >> # cat blkio.io_serviced
> >> 253:2 Read 61 throttle
> >> 253:2 Write 0 throttle
> >> 253:2 Sync 61 throttle
> >> 253:2 Async 0 throttle
> >> 253:2 Total 61        throttle
> >>
> >> 253:2 Read 61 proportional
> >> 253:2 Write 0 proportional
> >> 253:2 Sync 61   proportional
> >> 253:2 Async 0   proportional
> >> 253:2 Total 61  proportional
> >>
> >
> > Option 1
> > ========
> > I was looking at the blkio stat code more. It seems to be key value pair
> > thing. So looks like I shall have to change the format of the file and
> > use second field for policy name and that will break any existing tools
> > parsing these blkio cgroup files.
> >
> > # cat blkio.io_serviced
> > 253:2 throttle Read 61
> > 253:2 throttle Write 0
> > 253:2 throttle Sync 61
> > 253:2 throttle Async 0
> > 253:2 throttle Total 61
> >
> > 253:2 proportional Read 61
> > 253:2 proportional Write 0
> > 253:2 proportional Sync 61
> > 253:2 proportional Async 0
> > 253:2 proportional Total 61
> >
> > Option 2
> > ========
> > Introduce policy column only for new policy.
> >
> > 253:2 Read 61
> > 253:2 Write 0
> > 253:2 Sync 61
> > 253:2 Async 0
> > 253:2 Total 61
> >
> > 253:2 throttle Read 61
> > 253:2 throttle Write 0
> > 253:2 throttle Sync 61
> > 253:2 throttle Async 0
> > 253:2 throttle Total 61
> >
> > Here old lines continue to represent proportional weight policy stats and
> > new lines with "throttle" key word represent throttling stats.
> >
> > This is just like adding new fields to "stat" file. I guess it might still
> > might break some script which might get stumped by new lines. But if scripts
> > are not parsing all the lines and just selectively picking data then these
> > should be fine.
> >
> > Option 3
> > ========
> > The other option is that I introduce new cgroup files for the new
> > policy. Something like what memory cgroup has done for swap accounting
> > files.
> >
> > blkio.throttle.io_serviced
> > blkio.throttle.io_service_bytes
> 
> Vivek,
> I have not looked at the rest of the patch yet. But I do not get why
> stats like io_serviced and io_servived_bytes would be policy specific.
> They should represent the total IO from a group serviced by the disk.
> If we want to count IOs which are in a new state, we should add new
> stats for that. What am I missing?

Nauman, 

Most of the stats are policy specific (CFQ) and not necessarily request
queue specific. If CFQ is not operating on request queue, none of the stats
are available.

Previously there used to be only one piece of code which was creating
groups and updating stats. Now there can be two policies operating
on same request queue, throttling and proportional weight (CFQ). They
both will manage their groups independently. Throttling needs to manage
groups independently so that it can be used with higher level logical
devices as well can be used with IO scheduler other than CFQ.

Now two policies can be operating on same request queue. First bio's
will be subjected to throttling rules and they can go through CFQ
again and be subjected to proportional weight rules.

Now the problem is who owns io_serviced field? If CFQ is responsible
for updating it, then what happens when deadline is running or when
we are operating on a dm device? No stats are available.

Hence I thought that one of the way to handle this situation is that
make stats per cgroup, per device and per policy. So far they are
per cgroup and per device. Now a user can figure out what he needs to
look at.

Other thing is that io_serviced can be different for throttling and
CFQ. The reason being that throttling deals with bio (before merging)
and CFQ deals with requests (after merging). So after merging number
of io_serviced can be much smaller than as seen by throttling policy
and it will have an impact on max IOPS rules.

So to me one of the good ways to handle it is make stats per policy and
let user decide what information he wants to extract out of those stats.

Thanks
Vivek
