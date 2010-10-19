Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab0JSMdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 08:33:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758252Ab0JSMdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 08:33:38 -0400
Date: Tue, 19 Oct 2010 08:33:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Fix array overflow in CFQ
Message-ID: <20101019123320.GB857@redhat.com>
References: <1287479450-11447-1-git-send-email-andi@firstfloor.org>
 <4CBD6C84.3020309@kernel.dk>
 <20101019114933.GA857@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101019114933.GA857@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 07:49:33AM -0400, Vivek Goyal wrote:
> On Tue, Oct 19, 2010 at 12:01:40PM +0200, Jens Axboe wrote:
> > On 2010-10-19 11:10, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > gcc 4.5 complains when compiling a recent rc with
> > > 
> > > linux/block/cfq-iosched.c: In function ‘cfq_dispatch_requests’:
> > > linux/block/cfq-iosched.c:2156:3: warning: array subscript is above array bounds
> > > 
> > > and it is right:
> > > 
> > >  slice = group_slice * count /
> > >                 max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
> > >                       cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
> > > 
> > > busy_queues_avg can be indexed by this enum
> > > 
> > > enum wl_prio_t {
> > >         BE_WORKLOAD = 0,
> > >         RT_WORKLOAD = 1,
> > >         IDLE_WORKLOAD = 2,
> > > };
> > > 
> > > in cfqd->serving_prio, but is only declared as
> > > 
> > > unsigned int busy_queues_avg[2];
> > > 
> > > which is clearly off by one. Fix this here.
> > 
> > Indeed, that is definitely buggy. ->service_trees[][] looks buggy, too.
> > WTF?!
> 
> Hi Jens,
> 
> busy_queues_avg[] definitely looks buggy. Looks like I introduced this bug
> while converting corrado's logic to group logic. I will fix it in a while.
> Sorry for the goof up here.

Jens,

Staring at the code for some more time, it looks like that busy_queues_avg[]
is also not buggy (at least at run time).

We maintain busy_queues_avg() only for RT and BE class. For IDLE class, we
expire the workload immediately after a jiffy.


        /* Choose next priority. RT > BE > IDLE */
        if (cfq_group_busy_queues_wl(RT_WORKLOAD, cfqd, cfqg))
                cfqd->serving_prio = RT_WORKLOAD;
        else if (cfq_group_busy_queues_wl(BE_WORKLOAD, cfqd, cfqg))
                cfqd->serving_prio = BE_WORKLOAD;
        else {
                cfqd->serving_prio = IDLE_WORKLOAD;
                cfqd->workload_expires = jiffies + 1;
                return;
        }

...
...
...

        slice = group_slice * count /
                max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
                      cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd,
cfqg));

So for IDLE class, we return immediately from the function and never
execute cfqg->busy_queues_avg[IDLE].

Now to remove the gcc warning we can increase the size of busy_queues_avg[]
array but third field should always remain unused.

Thanks
Vivek
