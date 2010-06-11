Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604Ab0FKVwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:52:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759Ab0FKVwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:52:39 -0400
Date: Fri, 11 Jun 2010 14:52:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
Message-Id: <20100611145219.017a87c0.akpm@linux-foundation.org>
In-Reply-To: <1276189574.2385.32.camel@mudge.jf.intel.com>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
	<20100601145126.f46572d1.akpm@linux-foundation.org>
	<87ocftyfnh.fsf@basil.nowhere.org>
	<20100609153654.0061e9c8.akpm@linux-foundation.org>
	<1276189574.2385.32.camel@mudge.jf.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 10:06:14 -0700
Tim Chen <tim.c.chen@linux.intel.com> wrote:

> On Wed, 2010-06-09 at 15:36 -0700, Andrew Morton wrote:
> 
> > > 
> > > You need some synchronization, otherwise the accounting
> > > would not be exact and you could overflow. Yes you could
> > > open code it, but having it in a library is nicer.
> > 
> > The code doesn't have synchronisation!  qtoken_return() can modify the
> > per-cpu "cache" in parallel with qtoken_avail()'s walk across the
> > per-cpu "caches", yielding an inaccurate result.
> > 
> > This is all the same as percpu_add() executing in parallel with
> > percpu_counter_sum() or percpu_counter_sum_positive().
> > 
> > If we cannot tolerate that inaccuracy then these patches are no good
> > and we need a rethink.
> > 
> > If we _can_ tolerate that inaccuracy then percpu_counters can be used
> > here.  And doing that is preferable to reinventing percpu_counters
> > badly.
> > 
> > I'm just not seeing it.
> 
> 
> The first version of the patch does a qtoken_reap_cache to reap the
> tokens into pool before doing an accounting of the tokens and the token
> count will be precise.  It was not done in the second version of the
> patch due to objection that it may be  costly, and also the tokens count
> will be fluctuating anyway.  However, qtoken_avail is not called very
> often (usually caller will use qtoken_get to access the tokens and it
> will not need a total accounting of the tokens). We can do it the
> previous way and there will be no inaccuracies. 
> 

afacit, your proposed implementation could have used percpu_counters. 
If so, that would be by far the best way of doing it, because that
doesn't require the addition of new infrastructure.
