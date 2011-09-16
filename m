Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1IPNYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 09:24:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab1IPNYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 09:24:16 -0400
Date: Fri, 16 Sep 2011 09:24:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Maxim Patlasov <maxim.patlasov@gmail.com>
Subject: Re: [patch]cfq-iosched: delete deep seeky queue idle logic
Message-ID: <20110916132411.GB4377@redhat.com>
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

[..]
> >
> > 2. deep seeky queue idle. This makes raid performs poorly. I would think we
> > revert the logic. Deep queue is more popular with high end hardware. In such
> > hardware, we'd better not do idle.
> > Note, currently we set a queue's slice after the first request is finished.
> > This means the drive already idles a little time. If the queue is truely deep,
> > new requests should already come in, so idle isn't required.
> > Looks Vivek used to post a patch to rever it, but it gets ignored.
> > http://us.generation-nt.com/patch-cfq-iosched-revert-logic-deep-queues-help-198339681.html
> I get a 404 here. I think you are seeing only one half of the medal.
> That logic is there mainly to ensure fairness between deep seeky
> processes and normal seeky processes that want low latency.
> If you remove that logic, a single process making many parallel aio
> reads could completely swamp one machine, preventing other seeky
> processes from progressing.

I think to tackle that we can expire the queue early once it has
dispatched few requests. (Something along the lines of async queues
being expired once they dispatch cfq_prio_to_maxrq() requests).

That way one deep queue will not starve other random queues and
at the same time we will not introduce per queue idling for deep
queues.

Anyway deep queue here is seeky so idling is not helping getting
improved throughput.

> Instead of removing completely the logic, you should make the depth
> configurable, so multi-spindle storages could allow deeper queues
> before switching to fairness-enforcing policy.

I would think getting rid of deep queue logic is probably better than
introducing more tunables. We just need to expire queue after dispatching
few requests so that we do good rounding robin dispatch among all the
queues on sync-noidle service tree.

Thanks
Vivek
