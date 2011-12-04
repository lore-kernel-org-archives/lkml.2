Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1LDLic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 06:38:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab1LDLi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 06:38:28 -0500
Date: Sun, 4 Dec 2011 13:06:39 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect
 descriptors
Message-ID: <20111204110637.GN15464@redhat.com>
References: <1322576464.7003.6.camel@lappy>
 <20111129145451.GD30966@redhat.com>
 <4ED4F30F.8000603@redhat.com>
 <1322669511.3985.8.camel@lappy>
 <87wrahrp0u.fsf@rustcorp.com.au>
 <20111201075847.GA5479@redhat.com>
 <1322726977.3259.3.camel@lappy>
 <20111201102640.GB8822@redhat.com>
 <87zkfbre9x.fsf@rustcorp.com.au>
 <1322913028.3782.4.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322913028.3782.4.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 03, 2011 at 01:50:28PM +0200, Sasha Levin wrote:
> On Fri, 2011-12-02 at 11:16 +1030, Rusty Russell wrote:
> > On Thu, 1 Dec 2011 12:26:42 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Thu, Dec 01, 2011 at 10:09:37AM +0200, Sasha Levin wrote:
> > > > On Thu, 2011-12-01 at 09:58 +0200, Michael S. Tsirkin wrote:
> > > > > We'll presumably need some logic to increment is back,
> > > > > to account for random workload changes.
> > > > > Something like slow start?
> > > > 
> > > > We can increment it each time the queue was less than 10% full, it
> > > > should act like slow start, no?
> > > 
> > > No, we really shouldn't get an empty ring as long as things behave
> > > well. What I meant is something like:
> > 
> > I was thinking of the network output case, but you're right.  We need to
> > distinguish between usually full (eg. virtio-net input) and usually
> > empty (eg. virtio-net output).
> > 
> > The signal for "we to pack more into the ring" is different.  We could
> > use some hacky heuristic like "out == 0" but I'd rather make it explicit
> > when we set up the virtqueue.
> > 
> > Our other alternative, moving the logic to the driver, is worse.
> > 
> > As to fading the effect over time, that's harder.  We have to deplete
> > the ring quite a few times before it turns into always-indirect.  We
> > could back off every time the ring is totally idle, but that may hurt
> > bursty traffic.  Let's try simple first?
> 
> I tried to take a different approach, and tried putting the indirect
> descriptors in a kmem_cache as Michael suggested. The benchmarks showed
> that this way virtio-net actually worked faster with indirect on even in
> a single stream.
> 
> Maybe we can do that instead of playing with threshold for now.
> 
> The question here, how much wasted space we can afford? since indirect
> descriptors would have to be the same size we'd have a bunch of them
> wasted in the cache. Ofcourse we can make that configurable, but how
> much is ok by default?

I think it's a good idea to make that per-device.
For network at least, each skb already has overhead of
around 1/2 K, so using up to 1/2K more seems acceptable.
But even if we went up to MAX_SKB_FRAGS+2, it would be
only 1K per ring entry, so for a ring of 256 entries, we end up with
256K max waste. That's not that terrible.

But I'd say let's do some benchmarking to figure out
the point where the gains are becoming very small.



> -- 
> 
> Sasha.
