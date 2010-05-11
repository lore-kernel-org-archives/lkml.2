Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab0EKQX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:23:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab0EKQXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:23:53 -0400
Date: Tue, 11 May 2010 12:23:39 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, Alasdair G Kergon <agk@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH-v2 2/2] Initialize mempool and elevator only for
 request-based dm devices
Message-ID: <20100511162338.GB446@redhat.com>
References: <200908081026.01097.knikanth@suse.de>
 <200908111435.12020.knikanth@suse.de>
 <4A8225DC.1060200@ct.jp.nec.com>
 <200908121417.28760.knikanth@suse.de>
 <4A850BB3.3070703@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A850BB3.3070703@ct.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14 2009 at  3:01am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Nikanth,
> 
> On 08/12/2009 05:47 PM +0900, Nikanth Karthikesan wrote:
> > Hi Kiyoshi Ueda,
> > 
> > On Wednesday 12 August 2009 07:45:56 Kiyoshi Ueda wrote:
> >> Hi Nikanth,
...
> >> Humm, it might work for now, but I disagree with that.
> >>
> >> Since elevator is block internal and dm doesn't really care
> >> (its initialization is actually hidden in blk_init_allocated_queue()),
> >> directly calling elv_register_queue() from dm seems not right.
> >> It will likely introduce a bug by future changes in block layer.
> >>
> >> I think the right approach is to define a proper block layer interface
> >> to reflect the queue configuration change.
> >> That's why I said "Updating the queue registration may not be easy".
> > 
> > I do not see too much of overhead in the future with this approach,
> > atleast no more than "proper block layer interface".
> 
> I don't think so.
> Just exporting elv_register_queue() will cause some maintenance costs
> to request-based dm developers as below.
> 
> Although currently only elevator is the queue's feature which is
> needed for only request-based dm, such other features may be added
> to queue in the future.
> Then, the developer who added the feature may not notice that
> request-based dm needs to register the feature here, if there
> is no critical problem (e.g. compile error or panic) without it.
> That causes the lack of such features only in request-based dm.
> Therefore, request-based dm developers always have to watch
> the change of the block-layer and make the registration related code.
> I think it's a sort of big maintenance cost.
> 
> So we should make the code as the change of the block-layer becomes
> effective automatically in request-based dm, too, as mush as possible.
> In this case, you should make/call an interface for the whole queue,
> not only for the elevator, since dm can't/shouldn't know how
> blk_init_allocated_queue() initializes the queue.
> (And the interface should be used in other generic paths (e.g. add_disk()))
> That's a proper block-layer interface which I mentioned, and this
> approach should have less overhead than your approach from view point
> of longer period.

Any future changes must be done with the understanding of how the
current code works (block layer included).  We cannot ignore known
problems because of some future change that has theoretical oversights
on how the existing code works.


> > IMHO, unregistering the queue and registering the queue again with
> > the elevator, is basically wasting CPU cycles and possibly would
> > confuse the user-space, which may be watching the sysfs... 
> 
> Right, so I said "Updating may not be easy."
> (By the way, wasting CPU cycles doesn't matter here, since it happens
>  only when we initialize the device and it shouldn't too much.)

Having DM intelligently build on what the block layer already registered
(with sysfs) seemed less controversial to me.

However, my first private version of dm_init_request_based_queue()
re-registered the entire queue, blk_unregister_queue then
blk_register_queue, but I decided against it -- as I thought it would be
less controversial -- how foolish of me ;)
(I also hadn't read this review you already gave Nikanth...)

My reasoning was that completely unregistering the queue from sysfs and
then re-registering was simply excessive.  We know better so why work
harder?
(and yes I get your point that being wasteful at table load is tolerable
-- but I'm not really seeing the DM design purity gains of
   re-registering the queue).


> > Or asking block layer to recheck and find what we have changed
> > in the request_queue. It does not sound like the best solution.
> 
> I think this is a better solution than exposing a part of queue
> internals as I described above.
> 
> > It is better to tell the block-layer that we have added a q->request_fn 
> > function, so initialize the elevator.
> 
> I don't think it's better as I described above.
> (dm can't/shouldn't know how blk_init_allocated_queue() initializes
>  the queue.)

Taking a step back...

The block layer always deals with exposing the queue's sysfs attributes
as a separate step that is performed _after_ initializing the queue.

With my proposed patch, request-based DM would now build on the
minimalist bio-based request_queue by fully initializing it.  I don't
think it is too big a stretch to say:

If a request_queue is fully initialized either the block layer core or a
subsystem making precise use of block layer interfaces (e.g. DM) should
take care to register the elevator -- especially if said subsystem
already partially registered the minimalist queue.


All this being said, I can easily switch back to my initial version of
dm_init_request_based_queue(), that used blk_unregister_queue() then
blk_register_queue(), if Alasdair and/or Jens would prefer that as a
"better" block interface for DM to use.  But Jens has already accepted
my proposed block change:
http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=01effb0dc1451fad55925873ffbfb88fa4eadce0

We could certainly export blk_unregister_queue and blk_register_queue
too...

Regards,
Mike
