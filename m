Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1IPGgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:36:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:41739 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1IPGgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:36:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="49012488"
Subject: Re: [patch]cfq-iosched: delete deep seeky queue idle logic
From: Shaohua Li <shaohua.li@intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        Maxim Patlasov <maxim.patlasov@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <CADX3swqrpz+=JSk8gQf6tDRZ25Z9FOnJbTyiCrZAM6LiJSmoGA@mail.gmail.com>
References: <1316142577.29510.130.camel@sli10-conroe>
	 <CADX3swqrpz+=JSk8gQf6tDRZ25Z9FOnJbTyiCrZAM6LiJSmoGA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 14:40:39 +0800
Message-ID: <1316155239.29510.148.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 14:04 +0800, Corrado Zoccolo wrote:
> On Fri, Sep 16, 2011 at 5:09 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > Recently Maxim and I discussed why his aiostress workload performs poorly. If
> > you didn't follow the discussion, here are the issues we found:
> > 1. cfq seeky dection isn't good. Assume a task accesses sector A, B, C, D, A+1,
> > B+1, C+1, D+1, A+2...Accessing A, B, C, D is random. cfq will detect the queue
> > as seeky, but since when accessing A+1, A+1 is already in disk cache, this
> > should be detected as sequential really. Not sure if any real workload has such
> > access patern, and seems not easy to have a clean fix too. Any idea for this?
> 
> Not all disks will cache 4 independent streams, we can't make that
> assumption in cfq.
sure thing. we can't make such assumption. I'm thinking if we should
move the seeky detection in request finish. If time between two requests
finish is short, we thought the queue is sequential. This will make the
detection adaptive. but seems time measurement isn't easy.

> The current behaviour of assuming it as seeky should work well enough,
> in fact it will be put in the seeky tree, and it can enjoy the seeky
> tree quantum of time. If the second round takes a short time, it will
> be able to schedule a third round again after the idle time.
> If there are other seeky processes competing for the tree, the cache
> can be cleared by the time it gets back to your 4 streams process, so
> it will behave exactly as a seeky process from cfq point of view.
> If the various accesses were submitted in parallel, the deep seeky
> queue logic should kick in and make sure the process gets a sequential
> quantum, rather than sharing it with other seeky processes, so
> depending on your disk, it could perform better.
yes, the idle logic makes it ok, but sounds like "make things wrong
first (in seeky detection) and then fix it later (the idle logic)".

> > 2. deep seeky queue idle. This makes raid performs poorly. I would think we
> > revert the logic. Deep queue is more popular with high end hardware. In such
> > hardware, we'd better not do idle.
> > Note, currently we set a queue's slice after the first request is finished.
> > This means the drive already idles a little time. If the queue is truely deep,
> > new requests should already come in, so idle isn't required.
What did you think about this? Assume seeky request takes long time, so
the queue is already idling for a little time.

> > Looks Vivek used to post a patch to rever it, but it gets ignored.
> > http://us.generation-nt.com/patch-cfq-iosched-revert-logic-deep-queues-help-198339681.html
> I get a 404 here. I think you are seeing only one half of the medal.
> That logic is there mainly to ensure fairness between deep seeky
> processes and normal seeky processes that want low latency.
didn't understand it. The logic doesn't protect non-deep process. how
could it make the normal seeky process have low latency? or did you have
a test case for this, so I can analyze?
I tried a workload with one task drives depth 4 and one task drives
depth 16. Appears the behavior isn't changed w/wo the logic.

> If you remove that logic, a single process making many parallel aio
> reads could completely swamp one machine, preventing other seeky
> processes from progressing.
> Instead of removing completely the logic, you should make the depth
> configurable, so multi-spindle storages could allow deeper queues
> before switching to fairness-enforcing policy.
we already had too many tunable ;( And we don't have a way to get the
maximum depth a storage can provide.
Could the driver detect it's a multi-spindle storage and report it to
iosched, just like SSD detection?

Thanks,
Shaohua

