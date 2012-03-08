Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab2CHXkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 18:40:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab2CHXkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 18:40:22 -0500
Date: Thu, 8 Mar 2012 18:40:16 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120308234016.GA925@redhat.com>
References: <CAKA=qzaHqwZ8eqpLNFjxnO2fX-tgAOjmpvxgBFjv6dJeQaOW1w@mail.gmail.com>
 <CAKA=qzZQ0YkWXpi4gKYe5yFrR9EF3+G1Wq=kWybreLXx7D30oQ@mail.gmail.com>
 <20120307162851.GC13430@redhat.com>
 <4F57AF4A.6080703@kernel.dk>
 <CAKA=qzak6N-6oHVjDozJ6KLMSWXEgzZf1xaC_1cgnoaUCyw8Ag@mail.gmail.com>
 <CAKA=qzaHJ0OcbvtT-mwKBUBvzPkxE4r-bW6gDvicKhoQeyFWEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzaHJ0OcbvtT-mwKBUBvzPkxE4r-bW6gDvicKhoQeyFWEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 04:22:31PM -0600, Josh Hunt wrote:

[..]
> A crude bisection seems to show that if I revert "blkio: Set
> must_dispatch only if we decided to not dispatch the request"
> (bf7919371025412978268efca4b09dd847acb395) I no longer see the stalls
> in 2.6.35. However this does not seem to solve the problem if I revert
> it in 2.6.38.

Strange. If this was the problem it should have fixed it in 2.6.38 also.
BTW, the blktrace you sent was from 2.6.38 or 2.6.35 kernels.

> 
> By setting slice_idle to 0, does this basically disable plugging?

It disables idling and not plugging.

> Based on the blktrace info it seems that something is going wrong with
> plugging with my testcase. I'm just wondering why setting slice_idle
> to 0 seems to resolve my issue? Also, since we see unplugs in the
> blktrace how could the requests still not be getting sent to the disk?

Unplug will just try to kick the queue. That does not mean that request
will be dispatched. And that's the question that why are we not
dispatching requests.

I had another look at traces and I think it is not just async write, but
there is was sync write request queued and we have not dispatched that
too for a long time.

Added request here.

  8,0    1    36921  5028.492019664   162  A  WS 63 + 8 <- (8,1) 0
  8,0    1    36922  5028.492021620   162  Q  WS 63 + 8 [sync_supers]
  8,0    1    36923  5028.492029721   162  G  WS 63 + 8 [sync_supers]
  8,0    1    36924  5028.492040617   162  I   W 63 + 8 (   10896)
[sync_supers]
  8,0    1        0  5028.492044807     0  m   N cfq162 insert_request
  8,0    1        0  5028.492046763     0  m   N cfq162 add_to_rr

And after a long time we dispatched the request.

  8,0    0        0  5050.116841906     0  m   N cfq162 set_active wl_prio:0 wl_type:1
  8,0    0        0  5050.116844979     0  m   N cfq162 fifo=ffff8800e8787aa0
  8,0    0        0  5050.116846655     0  m   N cfq162 dispatch_insert
  8,0    0        0  5050.116849728     0  m   N cfq162 dispatched a
request
  8,0    0        0  5050.116851683     0  m   N cfq162 activate rq, drv=1
  8,0    0    36518  5050.116853360   166  D   W 63 + 8 (21624812743)
[kblockd/0]
  8,0    0    36519  5050.117236650  9671  C   W 63 + 8 (  383290) [0]

So it is not async requestss being starved by sync request issue, most
likely.

Are you using any of the blk cgroup stuff?

Can you put some more trace messages to figure out what's happening.
I think you can try putting some trace messages in following functions.

__blk_run_queue()
cfq_select_queue()

and try to narrow down why CFQ refuses to dispatch the request when
this happens.

Thanks
Vivek
