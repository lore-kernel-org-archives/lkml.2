Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab1I0NLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:11:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab1I0NLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:11:39 -0400
Date: Tue, 27 Sep 2011 09:11:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Maxim Patlasov <maxim.patlasov@gmail.com>
Subject: Re: [patch]cfq-iosched: delete deep seeky queue idle logic
Message-ID: <20110927131135.GB24673@redhat.com>
References: <1316142577.29510.130.camel@sli10-conroe>
 <CADX3swqrpz+=JSk8gQf6tDRZ25Z9FOnJbTyiCrZAM6LiJSmoGA@mail.gmail.com>
 <1316155239.29510.148.camel@sli10-conroe>
 <CADX3swqAq=zpFtWogbuRnARjjZK753esKihs3tzLQkbiRE2y0Q@mail.gmail.com>
 <1316603780.2001.12.camel@shli-laptop>
 <20110923132441.GA10289@redhat.com>
 <1316998299.29510.155.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316998299.29510.155.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 08:51:39AM +0800, Shaohua Li wrote:
> On Fri, 2011-09-23 at 21:24 +0800, Vivek Goyal wrote:
> > On Wed, Sep 21, 2011 at 07:16:20PM +0800, Shaohua Li wrote:
> > 
> > [..]
> > > > Try a workload with one shallow seeky queue and one deep (16) one, on
> > > > a single spindle NCQ disk.
> > > > I think the behaviour when I submitted my patch was that both were
> > > > getting 100ms slice (if this is not happening, probably some
> > > > subsequent patch broke it).
> > > > If you remove idling, they will get disk time roughly in proportion
> > > > 16:1, i.e. pretty unfair.
> > > I thought you are talking about a workload with one thread depth 4, and
> > > the other thread depth 16. I did some tests here. In an old kernel,
> > > without the deep seeky idle logic, the threads have disk time in
> > > proportion 1:5. With it, they get almost equal disk time. SO this
> > > reaches your goal. In a latest kernel, w/wo the logic, there is no big
> > > difference (the 16 depth thread get about 5x more disk time). With the
> > > logic, the depth 4 thread gets equal disk time in first several slices.
> > > But after an idle expiration(mostly because current block plug hold
> > > requests in task list and didn't add them to elevator), the queue never
> > > gets detected as deep, because the queue dispatch request one by one.
> > 
> > When the plugged requests are flushed, then they will be added to elevator
> > and at that point of time queue should be marked as deep?
> The problem is there are just 2 or 3 requests are hold to the per-task
> list and then get flushed into elevator later, so the queue isn't marked
> as deep.

That would be workload dependent. Isn't it?

> 
> > Anyway, what's wrong with the idea I suggested in other mail of expiring
> > a sync-noidle queue afer few reuqest dispatches so that it does not
> > starve other sync-noidle queues.
> The problem is how many requests a queue should dispatch.
> cfq_prio_to_maxrq() == 16, which is too many. Maybe use 4, but it has
> its risk. seeky requests from one task might be still much far way with
> requests from other tasks.

4-6 might be a reasonable number to begin with. I am not sure about the
throughput impact thing because seek distance might be more by moving
to a different task. And also fairness might have some cost. Lets run some
tests and see if something shows up.

Thanks
Vivek 
