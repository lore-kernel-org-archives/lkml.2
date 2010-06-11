Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab0FKWJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:09:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:14019 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760476Ab0FKWJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:09:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,405,1272870000"; 
   d="scan'208";a="526119572"
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>
In-Reply-To: <20100611145219.017a87c0.akpm@linux-foundation.org>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
	 <20100601145126.f46572d1.akpm@linux-foundation.org>
	 <87ocftyfnh.fsf@basil.nowhere.org>
	 <20100609153654.0061e9c8.akpm@linux-foundation.org>
	 <1276189574.2385.32.camel@mudge.jf.intel.com>
	 <20100611145219.017a87c0.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 15:06:43 -0700
Message-ID: <1276294003.2385.48.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 14:52 -0700, Andrew Morton wrote:
> On Thu, 10 Jun 2010 10:06:14 -0700
> Tim Chen <tim.c.chen@linux.intel.com> wrote:
> 
> > On Wed, 2010-06-09 at 15:36 -0700, Andrew Morton wrote:
> > 
> > > > 
> > > > You need some synchronization, otherwise the accounting
> > > > would not be exact and you could overflow. Yes you could
> > > > open code it, but having it in a library is nicer.
> > > 
> > > The code doesn't have synchronisation!  qtoken_return() can modify the
> > > per-cpu "cache" in parallel with qtoken_avail()'s walk across the
> > > per-cpu "caches", yielding an inaccurate result.
> > > 
> > > This is all the same as percpu_add() executing in parallel with
> > > percpu_counter_sum() or percpu_counter_sum_positive().
> > > 
> > > If we cannot tolerate that inaccuracy then these patches are no good
> > > and we need a rethink.
> > > 
> > > If we _can_ tolerate that inaccuracy then percpu_counters can be used
> > > here.  And doing that is preferable to reinventing percpu_counters
> > > badly.
> > > 
> > > I'm just not seeing it.
> > 
> > 
> > The first version of the patch does a qtoken_reap_cache to reap the
> > tokens into pool before doing an accounting of the tokens and the token
> > count will be precise.  It was not done in the second version of the
> > patch due to objection that it may be  costly, and also the tokens count
> > will be fluctuating anyway.  However, qtoken_avail is not called very
> > often (usually caller will use qtoken_get to access the tokens and it
> > will not need a total accounting of the tokens). We can do it the
> > previous way and there will be no inaccuracies. 
> > 
> 
> afacit, your proposed implementation could have used percpu_counters. 
> If so, that would be by far the best way of doing it, because that
> doesn't require the addition of new infrastructure.

Just having percpu counters is not enough.
There is additional logic required to manage the per cpu counters: 
(1) set limit on the total number of tokens (2) distribute tokens into
per cpu counter (3) logic to coordinate where to get additional tokens
when we run out of tokens in the per cpu counter. (4) rebalance the
tokens when we have too many of the tokens returned to a per cpu
counter.  I'm trying to encapsulate these logic into the library.
Otherwise, these logic will still need to be duplicated in the code
using the per cpu counters.  

Tim

