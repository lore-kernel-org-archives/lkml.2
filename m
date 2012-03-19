Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2CSLMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:12:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38156 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678Ab2CSLMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:12:42 -0400
Message-ID: <1332155527.18960.292.camel@twins>
Subject: Re: [RFC][PATCH 00/26] sched/numa
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Mon, 19 Mar 2012 12:12:07 +0100
In-Reply-To: <4F670325.7080700@redhat.com>
References: <20120316144028.036474157@chello.nl>
	 <4F670325.7080700@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 11:57 +0200, Avi Kivity wrote:
> On 03/16/2012 04:40 PM, Peter Zijlstra wrote:
> > The home-node migration handles both cpu and memory (anonymous only for now) in
> > an integrated fashion. The memory migration uses migrate-on-fault to avoid
> > doing a lot of work from the actual numa balancer kernl thread and only
> > migrates the active memory.
> >
> 
> IMO, this needs to be augmented with eager migration, for the following
> reasons:
> 
> - lazy migration adds a bit of latency to page faults

That's intentional, it keeps the work accounted to the tasks that need
it.

> - doesn't work well with large pages

That's for someone who cares about large pages to sort, isn't it? Also,
I thought you virt people only used THP anyway, and those work just fine
(they get broken down, and presumably something will build them back up
on the other side).

[ note that I equally dislike the THP daemon, I would have much
preferred that to be fault driven as well. ]

> - doesn't work with dma engines

How does that work anyway? You'd have to reprogram your dma engine, so
either the ->migratepage() callback does that and we're good either way,
or it simply doesn't work at all.

> So I think that in addition to migrate on fault we need a background
> thread to do eager migration.  We might prioritize pages based on the
> active bit in the PDE (cheaper to clear and scan than the PTE, but gives
> less accurate information).

I absolutely loathe background threads and page table scanners and will
do pretty much everything to avoid them.

The problem I have with farming work out to other entities is that its
thereafter terribly hard to account it back to whoemever caused the
actual work. Suppose your kworker thread consumes a lot of cpu time --
this time is then obviously not available to your application -- but how
do you find out what/who is causing this and cure it?

As to page table scanners, I simply don't see the point. They tend to
require arch support (I see aa introduces yet another PTE bit -- this
instantly limits the usefulness of the approach as lots of archs don't
have spare bits).

Also, if you go scan memory, you need some storage -- see how aa grows
struct page, sure he wants to move that storage some place else, but the
memory overhead is still there -- this means less memory to actually do
useful stuff in (it also probably means more cache-misses since his
proposed shadow array in pgdat is someplace else).

Also, the only really 'hard' case for the whole auto-numa business is
single processes that are bigger than a single node -- and those I pose
are 'rare'.

Now if you want to be able to scan per-thread, you need per-thread
page-tables and I really don't want to ever see that. That will blow
memory overhead and context switch times.

I guess you can limit the impact by only running the scanners on
selected processes, but that requires you add interfaces and then either
rely on admins or userspace to second guess application developers.

So no, I don't like that at all.

I'm still reading aa's patch, I haven't actually found anything I like
or agree with in there, but who knows, there's still some way to go.
