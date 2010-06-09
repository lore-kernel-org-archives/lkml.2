Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab0FIWlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:41:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757605Ab0FIWlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:41:09 -0400
Date: Wed, 9 Jun 2010 15:41:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
Message-Id: <20100609154102.9795ff07.akpm@linux-foundation.org>
In-Reply-To: <1275499969.2385.16.camel@mudge.jf.intel.com>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
	<20100601145126.f46572d1.akpm@linux-foundation.org>
	<1275499969.2385.16.camel@mudge.jf.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jun 2010 10:32:49 -0700
Tim Chen <tim.c.chen@linux.intel.com> wrote:

> On Tue, 2010-06-01 at 14:51 -0700, Andrew Morton wrote:
> 
> > >
> > > +static void qtoken_reap_cache(struct qtoken *token_jar)
> > > +{
> > > +	long cnt;
> > > +	int i;
> > > +
> > > +	for_each_possible_cpu(i) {
> > > +		atomic_long_t	*cache;
> > > +
> > > +		cache = per_cpu_ptr(token_jar->cache, i);
> > > +		cnt = atomic_long_xchg(cache, -1);
> > > +		if (cnt > 0)
> > > +			token_jar->pool += cnt;
> > > +	}
> > > +}
> > 
> > Not cpu-hotplug aware.  Also, inefficient if num_online_cpus is much
> > less than num_possible_cpus.
> > 
> > It's really not hard to do!  lib/percpu_counter.c is per-cpu aware and
> > it does this by sneakily connecting all counters together system-wide.
> > 
> 
> I've thought about using "for_each_online_cpu" in the above loop.
> However, it someone takes a cpu offline, then we will lose the tokens
> in that cpu's cache when we do reap cache.

No, that's what cpu hotplug notifiers are for.  pecpu_counters does all
this.

> > > +	/* We should have acquired lock of token pool before coming here */
> > > +	if (token_jar->pool < (reserve + tokens))
> > > +		qtoken_reap_cache(token_jar);
> > > +	if (token_jar->pool >= (reserve + tokens)) {
> > > +		token_jar->pool -= tokens;
> > > +		allocated = 0;
> > > +	}
> > > +	return allocated;
> > > +}
> > 
> > ENOSPC means "your disk is full".  But my disk isn't full.  If this
> > inappropriate (indeed, incorrect) error code is ever propagated back to
> > userspace then users will be justifiably confused.
> > 
> 
> Originally, I was using -ENOSPC to mean tmpfs being full and out of
> space.  Will -EBUSY to denote all resources are used be more
> appropriate?  
> 

Return the number of tokens which were allocated?
