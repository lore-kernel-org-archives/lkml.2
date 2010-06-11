Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651Ab0FKXyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 19:54:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760564Ab0FKXyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 19:54:39 -0400
Date: Fri, 11 Jun 2010 16:54:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
Message-Id: <20100611165425.e21697c2.akpm@linux-foundation.org>
In-Reply-To: <1276298999.2385.71.camel@mudge.jf.intel.com>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
	<20100601145126.f46572d1.akpm@linux-foundation.org>
	<87ocftyfnh.fsf@basil.nowhere.org>
	<20100609153654.0061e9c8.akpm@linux-foundation.org>
	<1276189574.2385.32.camel@mudge.jf.intel.com>
	<20100611145219.017a87c0.akpm@linux-foundation.org>
	<1276294003.2385.48.camel@mudge.jf.intel.com>
	<20100611152620.97bc3e59.akpm@linux-foundation.org>
	<1276298999.2385.71.camel@mudge.jf.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 16:29:59 -0700
Tim Chen <tim.c.chen@linux.intel.com> wrote:

> On Fri, 2010-06-11 at 15:26 -0700, Andrew Morton wrote:
> 
> >  	}
> > @@ -422,11 +423,11 @@ static swp_entry_t *shmem_swp_alloc(stru
> >  		 */
> >  		if (sbinfo->max_blocks) {
> >  			spin_lock(&sbinfo->stat_lock);
> > -			if (sbinfo->free_blocks <= 1) {
> > +			if (percpu_counter_read(&sbinfo->free_blocks) <= 1) {
> >  				spin_unlock(&sbinfo->stat_lock);
> 
> Thanks for pointing me to look at this alternative implementation.
> 
> However, looking at the percpu counter code, it appears that the
> percpu_counter_read is imprecise.

Sure, that's inevitable if we want to avoid one-atomic-op-per-operation.

>  The counters in the per cpu counters
> are not accounted and the value read may be much less than the true
> amount of free blocks left when used in the patch above.

The comparisons with 0 and 1 are ugly (although not necessarily wrong).
 The code would be nicer if we replace free_blocks with used_blocks and
perform comparisons agains max_blocks.

>  We could fail
> the above test and not allocate pages when we actually have additional
> pages available.

Yup.  We're assuming here that we can tolerate overshooting max_blocks a bit.

> Using percpu_counter_sum will give the precise count
> but will cause the acquisition of the spin lock in the percpu_counter
> and slowed things down in this performance critical path.  If we feel
> that we could tolerate fuzziness on the size we configured for tmpfs,
> then this could be the way to go.
> 
> However, qtoken library implementation will impose a precise limit and
> has the per cpu counter's speed advantage.

percpu_counters have a precise limit too!  It's
percpu_counter_batch*num_online_cpus.  You can implement your own
tolerance by not using percpu_counter_batch: pass your own batch into
__percpu_counter_add().



There's a trick that can be done to improve accuracy.  When checking to
see if the fs is full, use percpu_counter_read().  If the number that
percpu_counter_read() returns is "close" to max_blocks, then start
using the more expensive percpu_counter_sum().  So the kernel will be
fast, until the disk gets to within (batch*num_online_cpus) blocks of
being full.

This is not the first time I've seen that requirement, and it would be
a good idea to implement the concept within an addition to the
percpu_counter library.  Say, percpu_counter_compare().

percpu_counter_compare(struct percpu_counter *fbc, s64 rhs) would
compare percpu_counter_read() with `rhs' and if they're within
num_online_cpus*percpu_counter_batch, call percpu_counter_sum().

__percpu_counter_compare() would take the additional `batch' argument.

I think.  Needs a bit of head-scratching, because callers don't really
care about num_online_cpus.  The caller only really cares about the
absolute error.

(Where the heck did the "fbc" name come from?  I forget...)
