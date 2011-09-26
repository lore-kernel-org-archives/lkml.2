Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1IZAq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 20:46:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:11254 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab1IZAqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 20:46:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,441,1312182000"; 
   d="scan'208";a="67367539"
Subject: Re: [patch]cfq-iosched: delete deep seeky queue idle logic
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Maxim Patlasov <maxim.patlasov@gmail.com>
In-Reply-To: <20110923132441.GA10289@redhat.com>
References: <1316142577.29510.130.camel@sli10-conroe>
	 <CADX3swqrpz+=JSk8gQf6tDRZ25Z9FOnJbTyiCrZAM6LiJSmoGA@mail.gmail.com>
	 <1316155239.29510.148.camel@sli10-conroe>
	 <CADX3swqAq=zpFtWogbuRnARjjZK753esKihs3tzLQkbiRE2y0Q@mail.gmail.com>
	 <1316603780.2001.12.camel@shli-laptop>  <20110923132441.GA10289@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 08:51:39 +0800
Message-ID: <1316998299.29510.155.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 21:24 +0800, Vivek Goyal wrote:
> On Wed, Sep 21, 2011 at 07:16:20PM +0800, Shaohua Li wrote:
> 
> [..]
> > > Try a workload with one shallow seeky queue and one deep (16) one, on
> > > a single spindle NCQ disk.
> > > I think the behaviour when I submitted my patch was that both were
> > > getting 100ms slice (if this is not happening, probably some
> > > subsequent patch broke it).
> > > If you remove idling, they will get disk time roughly in proportion
> > > 16:1, i.e. pretty unfair.
> > I thought you are talking about a workload with one thread depth 4, and
> > the other thread depth 16. I did some tests here. In an old kernel,
> > without the deep seeky idle logic, the threads have disk time in
> > proportion 1:5. With it, they get almost equal disk time. SO this
> > reaches your goal. In a latest kernel, w/wo the logic, there is no big
> > difference (the 16 depth thread get about 5x more disk time). With the
> > logic, the depth 4 thread gets equal disk time in first several slices.
> > But after an idle expiration(mostly because current block plug hold
> > requests in task list and didn't add them to elevator), the queue never
> > gets detected as deep, because the queue dispatch request one by one.
> 
> When the plugged requests are flushed, then they will be added to elevator
> and at that point of time queue should be marked as deep?
The problem is there are just 2 or 3 requests are hold to the per-task
list and then get flushed into elevator later, so the queue isn't marked
as deep.

> Anyway, what's wrong with the idea I suggested in other mail of expiring
> a sync-noidle queue afer few reuqest dispatches so that it does not
> starve other sync-noidle queues.
The problem is how many requests a queue should dispatch.
cfq_prio_to_maxrq() == 16, which is too many. Maybe use 4, but it has
its risk. seeky requests from one task might be still much far way with
requests from other tasks.

Thanks,
Shaohua

