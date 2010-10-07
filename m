Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0JGGYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 02:24:19 -0400
Received: from mail.openrapids.net ([64.15.138.104]:54541 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751574Ab0JGGYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 02:24:18 -0400
Date: Thu, 7 Oct 2010 02:24:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <nickpiggin@yahoo.com.au>,
        Cedric Le Goater <clg@vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH] Prio_heap: heap_remove(), heap_maximum(),
	heap_replace() and heap_cherrypick()
Message-ID: <20101007062414.GA28631@Krystal>
References: <20101006180323.GB21652@Krystal> <20101007034234.GM4195@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007034234.GM4195@balbir.in.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 02:18:20 up 14 days, 10:20,  2 users,  load average: 0.23, 0.18,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh (balbir@linux.vnet.ibm.com) wrote:
> * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> [2010-10-06 14:03:23]:
> 
> > These added interfaces lets prio_heap users lookup the top of heap item without
> > performing any insertion, perform removal of the topmost heap entry, and also
> > replacement of topmost heap entry. This is useful if one need to use the result
> > of the lookup to determine if the current maximum should simply be removed or if
> > it should be replaced.
> > 
> > This is used by the Generic Ring Buffer to perform timestamp-based fusion-merge
> > of per-cpu buffer records into a single stream.
> >
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Paul Menage <menage@google.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> > Cc: Balbir Singh <balbir@in.ibm.com>
> > Cc: Cedric Le Goater <clg@fr.ibm.com>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > ---
> 
> The patchset looks good to me, one comment on cherry picking below
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Thanks!

[...]
> > +/**
> > + * heap_cherrypick - remove a given element from the heap
> > + * @heap: the heap to be operated on
> > + * @p: the element
> > + *
> > + * Remove the given element from the heap. Return the element if present, else
> > + * return NULL. This algorithm has a complexity of O(n), which is higher than
> > + * O(log(n)) provided by the rest of this API.
> > + */
> > +extern void *heap_cherrypick(struct ptr_heap *heap, void *p);
> 
> One way to reduce cherrypick'ing in O(n) if n is large, is to sort the
> entire heap using heapify() and then doing a binary search. The cost
> of sorting is high, so it depends on how often and in what phases we
> cherry pick.

I need this to implement the ring buffer iterator "reset" primitive, which is
very infrequently called. So for my use-case, I really prefer to keep very fast
add/remove/get max (as implemented currently) without sorting the rest of the
heap. What you propose looks more like a balanced binary tree, which we already
have in the kernel, but clearly adds some overhead by requiring to keep the
whole tree sorted.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
