Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1I0G2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:28:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:29482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1I0G2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:28:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="56899512"
Subject: Re: [patch]cfq-iosched: delete deep seeky queue idle logic
From: Shaohua Li <shaohua.li@intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Maxim Patlasov <maxim.patlasov@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <CADX3swpBtAnRtUuVy8Qc9gpa2DdXXsyspnp87wbZEhVqi=VetA@mail.gmail.com>
References: <1316142577.29510.130.camel@sli10-conroe>
	 <CADX3swqrpz+=JSk8gQf6tDRZ25Z9FOnJbTyiCrZAM6LiJSmoGA@mail.gmail.com>
	 <1316155239.29510.148.camel@sli10-conroe>
	 <CADX3swqAq=zpFtWogbuRnARjjZK753esKihs3tzLQkbiRE2y0Q@mail.gmail.com>
	 <1316603780.2001.12.camel@shli-laptop>
	 <CADX3swq0qURdi7VYLAVbsAmX5psPrzq-uvbqANsnLkHO0xcOMQ@mail.gmail.com>
	 <1316998527.29510.158.camel@sli10-conroe>
	 <CADX3swpBtAnRtUuVy8Qc9gpa2DdXXsyspnp87wbZEhVqi=VetA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 14:33:40 +0800
Message-ID: <1317105220.29510.185.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 14:07 +0800, Corrado Zoccolo wrote:
> On Mon, Sep 26, 2011 at 2:55 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > On Fri, 2011-09-23 at 13:50 +0800, Corrado Zoccolo wrote:
> >> Il giorno 21/set/2011 13:16, "Shaohua Li" <shaohua.li@intel.com> ha
> >> scritto:
> >> >
> >> > On Sat, 2011-09-17 at 03:25 +0800, Corrado Zoccolo wrote:
> >> > > On Fri, Sep 16, 2011 at 8:40 AM, Shaohua Li <shaohua.li@intel.com>
> >> wrote:
> >> > > > On Fri, 2011-09-16 at 14:04 +0800, Corrado Zoccolo wrote:
> >> > > >> On Fri, Sep 16, 2011 at 5:09 AM, Shaohua Li
> >> <shaohua.li@intel.com> wrote:
> >> > > >> > Recently Maxim and I discussed why his aiostress workload
> >> performs poorly. If
> >> > > >> > you didn't follow the discussion, here are the issues we
> >> found:
> >> > > >> > 1. cfq seeky dection isn't good. Assume a task accesses
> >> sector A, B, C, D, A+1,
> >> > > >> > B+1, C+1, D+1, A+2...Accessing A, B, C, D is random. cfq will
> >> detect the queue
> >> > > >> > as seeky, but since when accessing A+1, A+1 is already in
> >> disk cache, this
> >> > > >> > should be detected as sequential really. Not sure if any real
> >> workload has such
> >> > > >> > access patern, and seems not easy to have a clean fix too.
> >> Any idea for this?
> >> > > >>
> >> > > >> Not all disks will cache 4 independent streams, we can't make
> >> that
> >> > > >> assumption in cfq.
> >> > > > sure thing. we can't make such assumption. I'm thinking if we
> >> should
> >> > > > move the seeky detection in request finish. If time between two
> >> requests
> >> > > > finish is short, we thought the queue is sequential. This will
> >> make the
> >> > > > detection adaptive. but seems time measurement isn't easy.
> >> > > >
> >> > > >> The current behaviour of assuming it as seeky should work well
> >> enough,
> >> > > >> in fact it will be put in the seeky tree, and it can enjoy the
> >> seeky
> >> > > >> tree quantum of time. If the second round takes a short time,
> >> it will
> >> > > >> be able to schedule a third round again after the idle time.
> >> > > >> If there are other seeky processes competing for the tree, the
> >> cache
> >> > > >> can be cleared by the time it gets back to your 4 streams
> >> process, so
> >> > > >> it will behave exactly as a seeky process from cfq point of
> >> view.
> >> > > >> If the various accesses were submitted in parallel, the deep
> >> seeky
> >> > > >> queue logic should kick in and make sure the process gets a
> >> sequential
> >> > > >> quantum, rather than sharing it with other seeky processes, so
> >> > > >> depending on your disk, it could perform better.
> >> > > > yes, the idle logic makes it ok, but sounds like "make things
> >> wrong
> >> > > > first (in seeky detection) and then fix it later (the idle
> >> logic)".
> >> > > >
> >> > > >> > 2. deep seeky queue idle. This makes raid performs poorly. I
> >> would think we
> >> > > >> > revert the logic. Deep queue is more popular with high end
> >> hardware. In such
> >> > > >> > hardware, we'd better not do idle.
> >> > > >> > Note, currently we set a queue's slice after the first
> >> request is finished.
> >> > > >> > This means the drive already idles a little time. If the
> >> queue is truely deep,
> >> > > >> > new requests should already come in, so idle isn't required.
> >> > > > What did you think about this? Assume seeky request takes long
> >> time, so
> >> > > > the queue is already idling for a little time.
> >> > > I don't think I understand. If cfq doesn't idle, it will dispatch
> >> an
> >> > > other request from the same or an other queue (if present)
> >> > > immediately, until all possible in-flight requests are sent. Now,
> >> you
> >> > > depend on NCQ for the order requests are handled, so you cannot
> >> > > guarantee fairness any more.
> >> > >
> >> > > >
> >> > > >> > Looks Vivek used to post a patch to rever it, but it gets
> >> ignored.
> >> > > >> >
> >> http://us.generation-nt.com/patch-cfq-iosched-revert-logic-deep-queues-help-198339681.html
> >> > > >> I get a 404 here. I think you are seeing only one half of the
> >> medal.
> >> > > >> That logic is there mainly to ensure fairness between deep
> >> seeky
> >> > > >> processes and normal seeky processes that want low latency.
> >> > > > didn't understand it. The logic doesn't protect non-deep
> >> process. how
> >> > > > could it make the normal seeky process have low latency? or did
> >> you have
> >> > > > a test case for this, so I can analyze?
> >> > > > I tried a workload with one task drives depth 4 and one task
> >> drives
> >> > > > depth 16. Appears the behavior isn't changed w/wo the logic.
> >> > sorry for the delay.
> >> >
> >> > > Try a workload with one shallow seeky queue and one deep (16) one,
> >> on
> >> > > a single spindle NCQ disk.
> >> > > I think the behaviour when I submitted my patch was that both were
> >> > > getting 100ms slice (if this is not happening, probably some
> >> > > subsequent patch broke it).
> >> > > If you remove idling, they will get disk time roughly in
> >> proportion
> >> > > 16:1, i.e. pretty unfair.
> >> > I thought you are talking about a workload with one thread depth 4,
> >> and
> >> > the other thread depth 16. I did some tests here. In an old kernel,
> >> > without the deep seeky idle logic, the threads have disk time in
> >> > proportion 1:5. With it, they get almost equal disk time. SO this
> >> > reaches your goal. In a latest kernel, w/wo the logic, there is no
> >> big
> >> > difference (the 16 depth thread get about 5x more disk time). With
> >> the
> >> > logic, the depth 4 thread gets equal disk time in first several
> >> slices.
> >> > But after an idle expiration(mostly because current block plug hold
> >> > requests in task list and didn't add them to elevator), the queue
> >> never
> >> > gets detected as deep, because the queue dispatch request one by
> >> one. So
> >> > the logic is already broken for some time (maybe since block plug is
> >> > added).
> >> Could be that dispatching requests one by one is harming the
> >> performance, then?
> > Not really. Say 4 requests are running, the task dispatches a request
> > after one previous request is completed. requests are dispatching one by
> > one but there are still 4 requests running at any time. Checking the
> > in_flight requests are more precise for the deep detection.
> >
> What happens if there are 4 tasks, all that could dispatch 4 requests
> in parallel? Will we reach and sustain 16 in flight requests, or it
> will bounce around 4 in flight? I think here we could get a big
> difference.
ah, yes, we really should change
if (cfqq->queued[0] + cfqq->queued[1] >= 4)
                cfq_mark_cfqq_deep(cfqq);
to
if (cfqq->queued[0] + cfqq->queued[1] + cfqq->cfqq->dispatched >= 4)
                cfq_mark_cfqq_deep(cfqq);
this is a bug, though this isn't related to the original raid issue.

> Probably it is better to move the deep queue detection logic in the
> per-task queue?
it's per-task queue currently.

> Then cfq will decide if it should dispatch few requests from every
> task (shallow case) or all requests from a single task (deep), and
> then idle.
don't get your point. detect the deep logic considering all tasks?

Thanks,
Shaohua

