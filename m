Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab0FLP2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 11:28:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851Ab0FLP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 11:28:37 -0400
Date: Sat, 12 Jun 2010 08:27:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
Message-Id: <20100612082757.7238224f.akpm@linux-foundation.org>
In-Reply-To: <20100612073639.GA15974@basil.fritz.box>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
	<20100601145126.f46572d1.akpm@linux-foundation.org>
	<87ocftyfnh.fsf@basil.nowhere.org>
	<20100609153654.0061e9c8.akpm@linux-foundation.org>
	<1276189574.2385.32.camel@mudge.jf.intel.com>
	<20100611145219.017a87c0.akpm@linux-foundation.org>
	<1276294003.2385.48.camel@mudge.jf.intel.com>
	<20100611152620.97bc3e59.akpm@linux-foundation.org>
	<1276298999.2385.71.camel@mudge.jf.intel.com>
	<20100611165425.e21697c2.akpm@linux-foundation.org>
	<20100612073639.GA15974@basil.fritz.box>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jun 2010 09:36:39 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> On Fri, Jun 11, 2010 at 04:54:25PM -0700, Andrew Morton wrote:
> > > >  			spin_lock(&sbinfo->stat_lock);
> > > > -			if (sbinfo->free_blocks <= 1) {
> > > > +			if (percpu_counter_read(&sbinfo->free_blocks) <= 1) {
> > > >  				spin_unlock(&sbinfo->stat_lock);
> > > 
> > > Thanks for pointing me to look at this alternative implementation.
> > > 
> > > However, looking at the percpu counter code, it appears that the
> > > percpu_counter_read is imprecise.
> > 
> > Sure, that's inevitable if we want to avoid one-atomic-op-per-operation.
> 
> Only if you use the wrong primitive.
> It's not inevitable as qtoken has proven.

No it has not.  qtoken is inaccurate.

> > percpu_counters have a precise limit too!  It's
> > percpu_counter_batch*num_online_cpus.  You can implement your own
> > tolerance by not using percpu_counter_batch: pass your own batch into
> > __percpu_counter_add().
> 
> Such a batch could be rather large on a large system.
> 
> e.g. on a 32 CPU system with batch 16 it's already 2MB.

That's not much.

> > There's a trick that can be done to improve accuracy.  When checking to
> > see if the fs is full, use percpu_counter_read().  If the number that
> > percpu_counter_read() returns is "close" to max_blocks, then start
> > using the more expensive percpu_counter_sum().  So the kernel will be
> > fast, until the disk gets to within (batch*num_online_cpus) blocks of
> > being full.
> 
> Ok it would work, but you would get a big dip in performance
> once you're near the limit.
> 
> And the more CPUs you have the larger this window of slowness becomes.
> 
> > 
> > This is not the first time I've seen that requirement, and it would be
> > a good idea to implement the concept within an addition to the
> > percpu_counter library.  Say, percpu_counter_compare().
> 
> But why not just use qtoken which solves this without any hacks?

a) because qtoken needs "hacks" to solve it

b) because the qtoken code is fairly revolting

c) because the facilities which qtoken provides are so darn close to
   those which percpu_counters provide that it's quite unlikely that
   there will be another user of qtoken which couldn't have used
   percpu-counters

d) because the down-counter-like behaviour of qtoken is weird.

> I still think qtoken is a better proposal.

why?

> Even if it's a bit more
> code, but at least it solves this all cleanly without hacks and
> arbitary limits.

Well maybe there are still undiscovered secrets in there.  For its size
this is one of the worst-explained pieces of code I've seen to date.  I
still haven't really worked out the significance of setting the per-cpu
cache to -1.

