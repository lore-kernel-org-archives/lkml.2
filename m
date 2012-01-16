Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2APHLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:11:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab2APHLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:11:44 -0500
Date: Mon, 16 Jan 2012 02:11:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, jmoyer@redhat.com
Subject: Re: [RFC 0/3]block: An IOPS based ioscheduler
Message-ID: <20120116071132.GE3174@redhat.com>
References: <20120104065337.230911609@sli10-conroe.sh.intel.com>
 <20120104071931.GB17026@dastard>
 <1325746241.22361.503.camel@sli10-conroe>
 <1325826750.22361.533.camel@sli10-conroe>
 <20120108221615.GA4198@dastard>
 <1326071375.22361.543.camel@sli10-conroe>
 <20120115224532.GD3174@redhat.com>
 <1326688590.22361.578.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326688590.22361.578.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 12:36:30PM +0800, Shaohua Li wrote:
> On Sun, 2012-01-15 at 17:45 -0500, Vivek Goyal wrote:
> > On Mon, Jan 09, 2012 at 09:09:35AM +0800, Shaohua Li wrote:
> > 
> > [..]
> > > > You need to present raw numbers and give us some idea of how close
> > > > those numbers are to raw hardware capability for us to have any idea
> > > > what improvements these numbers actually demonstrate.
> > > Yes, your guess is right. The hardware has limitation. 12 SSD exceeds
> > > the jbod capability, for both throughput and IOPS, that's why only
> > > read/write mixed workload impacts. I'll use less SSD in later tests,
> > > which will demonstrate the performance better. I'll report both raw
> > > numbers and fiops/cfq numbers later.
> > 
> > If fiops number are better please explain why those numbers are better.
> > If you cut down on idling, it is obivious that you will get higher
> > throughput on these flash devices. CFQ does disable queue idling for
> > non rotational NCQ devices. If higher throughput is due to driving
> > deeper queue depths, then CFQ can do that too just by changing quantum
> > and disabling idling. 
> it's because of quantum. Surely you can change the quantum, and CFQ
> performance will increase, but you will find CFQ is very unfair then.

Why increasing quantum leads to CFQ being unfair? In terms of time it
still tries to be fair. That's a different thing that with NCQ, right
time measurement is not possible with requests from multiple queues
being in the driver/disk at the same time. So accouting in terms of
iops per queue might make sense.

> 
> > So I really don't understand that what are you doing fundamentally
> > different in FIOPS ioscheduler. 
> > 
> > The only thing I can think of more accurate accounting per queue in
> > terms of number of IOs instead of time. Which can just serve to improve
> > fairness a bit for certain workloads. In practice, I think it might
> > not matter much.
> If quantum is big, CFQ will have better performance, but it actually
> fallbacks to Noop, no any fairness. fairness is important and is why we
> introduce CFQ.

It is not exactly noop. It still preempts writes and prioritizes reads
and direct writes. 

Also, what's the real life workload where you face issues with using
say deadline with these flash based storage.

> 
> In summary, CFQ isn't both fair and good performance. FIOPS is trying to
> be fair and have good performance. I didn't think any time based
> accounting can make the goal happen for NCQ and SSD (even cfq cgroup
> code has iops mode, so suppose you should already know this well).
> 
> Surely you can change CFQ to make it IOPS based, but this will mess the
> code a lot, and FIOPS shares a lot of code with CFQ. So I'd like to have
> a separate ioscheduler which is IOPS based.

I think writing a separate IO scheduler just to do accouting in IOPS while
retaining rest of the CFQ code is not a very good idea. Modifying CFQ code
to be able to deal with both time based as well as IOPS accounting might
turn out to be simpler.

Thanks
Vivek
