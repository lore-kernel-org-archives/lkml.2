Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2AaDBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:01:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:16817 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab2AaDB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:01:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="102099346"
Subject: Re: Bad SSD performance with recent kernels
From: Shaohua Li <shaohua.li@intel.com>
To: Wu Fengguang <wfg@linux.intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Poetzl <herbert@13thfloor.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <20120131010755.GA12776@localhost>
References: <CANejiEW86b7btiOcVFF3qVhqU1t6FRosvgfiydWwU5zgeDFOqw@mail.gmail.com>
	 <20120130071346.GM29272@MAIL.13thfloor.at>
	 <1327908158.21268.3.camel@sli10-conroe>
	 <20120130073621.GN29272@MAIL.13thfloor.at>
	 <1327911142.21268.7.camel@sli10-conroe>
	 <CANejiEXwt7zdWRD0gTg1JXNPZ52vU1Z4cQsb3xztqDLccyTPSQ@mail.gmail.com>
	 <20120130142837.GA21750@localhost>
	 <1327935109.2297.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20120130222643.GH30245@redhat.com>
	 <1327968859.21268.12.camel@sli10-conroe> <20120131010755.GA12776@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jan 2012 11:00:32 +0800
Message-ID: <1327978832.21268.33.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 09:07 +0800, Wu Fengguang wrote:
> On Tue, Jan 31, 2012 at 08:14:19AM +0800, Li, Shaohua wrote:
> > On Mon, 2012-01-30 at 17:26 -0500, Vivek Goyal wrote:
> > > On Mon, Jan 30, 2012 at 03:51:49PM +0100, Eric Dumazet wrote:
> > > > Le lundi 30 janvier 2012 à 22:28 +0800, Wu Fengguang a écrit :
> > > > > On Mon, Jan 30, 2012 at 06:31:34PM +0800, Li, Shaohua wrote:
> > > > > 
> > > > > > Looks the 2.6.39 block plug introduces some latency here. deleting
> > > > > > blk_start_plug/blk_finish_plug in generic_file_aio_read seems
> > > > > > workaround
> > > > > > the issue. The plug seems not good for sequential IO, because readahead
> > > > > > code already has plug and has fine grained control.
> > > > > 
> > > > > Why not remove the generic_file_aio_read() plug completely? It
> > > > > actually prevents unplugging immediately after the readahead IO is
> > > > > submitted and in turn stalls the IO pipeline as showed by Eric's
> > > > > blktrace data.
> > > > > 
> > > > > Eric, will you test this patch? Thank you.
> > > 
> > > Can you please run the blktrace again with this patch applied. I am curious
> > > to see how does traffic pattern look like now.
> > > 
> > > In your previous trace, there were so many small 8 sector requests which
> > > were merged into 512 sector requests before dispatching to disk. (I am
> > > not sure why those requests are not bigger. Shouldn't readahead logic
> > > submit a bigger request?) Now with plug/unplug logic removed, I am assuming
> > > we should be doing less merging and dispatching more smaller requests. May be
> > > that is helping and cutting down on disk idling time.
> > > 
> > > In previous logs, 512 sector request seems to be taking around 1ms to
> > > complete after dispatch. In between requests disk seems to be idle
> > > for around .5 to .6 ms. Out of this .3 ms seems to be gone in just
> > > coming up with new request after completion of previous one and another
> > > .3ms seems to be consumed in merging the smaller IOs. So if we don't wait
> > > for merging, it should keep disk busier for .3ms more which is 30% of time
> > > it takes to complete 512 sector request. So theoritically it can give
> > > 30% boost for this workload. (Assuming request size will not impact the
> > > disk throughput very severely).
> > > 
> > > Anyway, some blktrace data will shed some light..
> > yep, I suspect plug merges big request too (iostat shows it too), that's
> > why I only think delete the plug in generic_file_aio_read as a
> > workaround.
> 
> It's good to merge requests inside the same readahead window. However
> I don't think readahead window A should be merged with B at the cost
> of delaying A for some time, which will break the pipeline. If larger
> IO is desirable, we can do so by increasing the readahead size.
> 
> > I still thought readahead has something to do here. I
> > observed the async readahead does readahead (A, A + 2M), and follows (A
> > +128k, A+2M), (A+256k, A+2M) ..., the later readahead doesn't work
> > because we already have (A, A+2M) in memory at that time. Anyway, I can
> > reproduce the issue, will play with it more today.
> 
> How do you observe that? I don't think that readahead pattern is
> possible. However I do see such _read_ patterns.
Ok, after double checking the code and do some tracing, I'm now thinking
we should delete the plug code in generic_file_aio_read. I thought the
problem is:

T1: ra (A, A+128k), (A+128k, A+256k), submit the 256k because lock_page
T2: hit page A+128K, ra (A+256k, A+384). the range isn't submitted
because of plug and there isn't any lock_page till we hit page A+256k
because all pages from A to A+ 256k is in memory
T3: hit page A+256k, ra (A+384, A+ 512). because plug, the range isn't
submitted again.
T4: lock_page A+256, so (A+256, A+512) will be submitted. The task is
waitting for (A+256, A+512) finish

so the pipeline doesn't work.

