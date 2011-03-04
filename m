Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086Ab1CDTPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:15:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759886Ab1CDTPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:15:06 -0500
Date: Fri, 4 Mar 2011 14:14:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Justin TerAvest <teravest@google.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Chad Talbott <ctalbott@google.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6 v5.1] cfq-iosched: Introduce CFQ group hierarchical
 scheduling and "use_hierarchy" interface
Message-ID: <20110304191458.GE5466@redhat.com>
References: <4D61FE91.60705@cn.fujitsu.com>
 <4D6201A3.70301@cn.fujitsu.com>
 <4D64788F.6040408@cn.fujitsu.com>
 <20110224181140.GE18494@redhat.com>
 <4D670C14.9040504@cn.fujitsu.com>
 <20110227231618.GA1014@redhat.com>
 <20110228001544.GA2762@redhat.com>
 <4D6E1556.5060905@cn.fujitsu.com>
 <4D706BC3.9090900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D706BC3.9090900@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 12:34:11PM +0800, Gui Jianfeng wrote:
> Gui Jianfeng wrote:
> > Vivek Goyal wrote:
> >> On Sun, Feb 27, 2011 at 06:16:18PM -0500, Vivek Goyal wrote:
> >>> On Fri, Feb 25, 2011 at 09:55:32AM +0800, Gui Jianfeng wrote:
> >>>> Vivek Goyal wrote:
> >>>>> On Wed, Feb 23, 2011 at 11:01:35AM +0800, Gui Jianfeng wrote:
> >>>>>> Hi
> >>>>>>
> >>>>>> I rebase this series on top of *for-next* branch, it will make merging life easier.
> >>>>>>
> >>>>>> Previously, I posted a patchset to add support of CFQ group hierarchical scheduling
> >>>>>> in the way that it puts all CFQ queues in a hidden group and schedules with other 
> >>>>>> CFQ group under their parent. The patchset is available here,
> >>>>>> http://lkml.org/lkml/2010/8/30/30
> >>>>> Gui,
> >>>>>
> >>>>> I was running some tests (iostest) with these patches and my system crashed
> >>>>> after a while.
> >>>>>
> >>>>> To be precise I was running "brrmmap" test of iostest.
> >>>> Vivek,
> >>>>
> >>>> I simply run iostest with brrmmap mode, I can't reproduce this bug.
> >>>> Would you give more details.
> >>>> Can you tell me the iostest command line options?
> >>> iostest /dev/dm-1 -G --nrgrp 4 -m 8 --cgtime --io_serviced --dequeue --total
> >>>
> >>> I was actually trying to run all the workloads defined but after running
> >>> 2 workloads it crashed on 3rd workload.
> >>>
> >>> Now I tried to re-run brrmmap and it did not crash. So I am trying to run
> >>> all the inbuilt workloads again.
> >>>
> >>>> Did you enable use_hierarchy in root group?
> >>> No I did not. Trying to test the flat setup first.
> >> Again was running above job and after 3 workloads it ran into a different
> >> BUG_ON().
> > 
> > Vivek,
> > 
> > It seems there's a race.
> > Would you try the following patch. This patch seems working for me.
> > 
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index 380d667..abbbb0e 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -4126,11 +4126,12 @@ new_queue:
> >  	cfqq->allocated[rw]++;
> >  	cfqq->ref++;
> >  
> > -	spin_unlock_irqrestore(q->queue_lock, flags);
> > -
> >  	rq->elevator_private[0] = cic;
> >  	rq->elevator_private[1] = cfqq;
> >  	rq->elevator_private[2] = cfq_ref_get_cfqg(cfqq->cfqg);
> > +
> > +	spin_unlock_irqrestore(q->queue_lock, flags);
> > +
> >  	return 0;
> >  
> >  queue_fail:
> > 
> > Thanks
> > Gui
> > 
> 
> Jens,
> 
> This bug seems being introduced in commmit 763414b in for-next branch when
> merging for-2.6.39/core branch.
> Would you apply the above patch?
> 
> Vivek, can you try the patchset again with this fix? It works fine for me now.

Gui,

Ok, I ran iostest with this fix and it seems to have worked. I need to run
it for some more time. And I also need to spend more time reviewing your
patchset. There are so many details to it. Soon I will spare some time
to review it more and also test it bit more.

Of the top of my head I have one concern.

- How to map iopriority to weights. I am thinking that currently weight
  range is 100-1000. If we decide to extend the range in current scheme,
  it will change the ioprio entity weight also and effectively the
  service differentiation between ioprio level will change. I am
  wondering if this is a concern and how cpu scheduler has managed it

Thanks
Vivek
