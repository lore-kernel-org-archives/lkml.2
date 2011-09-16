Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1IPNhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 09:37:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab1IPNhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 09:37:46 -0400
Date: Fri, 16 Sep 2011 09:37:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Maxim Patlasov <maxim.patlasov@gmail.com>
Subject: Re: [patch]cfq-iosched: delete deep seeky queue idle logic
Message-ID: <20110916133743.GC4377@redhat.com>
References: <1316142577.29510.130.camel@sli10-conroe>
 <CADX3swqrpz+=JSk8gQf6tDRZ25Z9FOnJbTyiCrZAM6LiJSmoGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADX3swqrpz+=JSk8gQf6tDRZ25Z9FOnJbTyiCrZAM6LiJSmoGA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 08:04:49AM +0200, Corrado Zoccolo wrote:
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

I think I agree that we probably can not optimize CFQ for cache behavior
without even knowing what a cache on a device might be doing. There
are no gurantees that by making this 4 stream process sequential you will
get better throughput in fact additional idling can kill the throughput
on faster storage. It probably should be left to the device cache to
optimize for such IO patterns.

Thanks
Vivek
