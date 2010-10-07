Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090Ab0JGDmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 23:42:44 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37135 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760005Ab0JGDmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 23:42:43 -0400
Date: Thu, 7 Oct 2010 09:12:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
Message-ID: <20101007034234.GM4195@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101006180323.GB21652@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101006180323.GB21652@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> [2010-10-06 14:03:23]:

> These added interfaces lets prio_heap users lookup the top of heap item without
> performing any insertion, perform removal of the topmost heap entry, and also
> replacement of topmost heap entry. This is useful if one need to use the result
> of the lookup to determine if the current maximum should simply be removed or if
> it should be replaced.
> 
> This is used by the Generic Ring Buffer to perform timestamp-based fusion-merge
> of per-cpu buffer records into a single stream.
>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Paul Menage <menage@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: Balbir Singh <balbir@in.ibm.com>
> Cc: Cedric Le Goater <clg@fr.ibm.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> ---

The patchset looks good to me, one comment on cherry picking below

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

>  include/linux/prio_heap.h |   44 ++++++++++++++++++++++
>  lib/prio_heap.c           |   91 ++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 116 insertions(+), 19 deletions(-)
> 
> Index: linux.trees.git/include/linux/prio_heap.h
> ===================================================================
> --- linux.trees.git.orig/include/linux/prio_heap.h	2010-07-06 14:25:29.000000000 -0400
> +++ linux.trees.git/include/linux/prio_heap.h	2010-07-07 10:04:33.000000000 -0400
> @@ -23,6 +23,18 @@ struct ptr_heap {
>  };
> 
>  /**
> + * heap_maximum - return the largest element in the heap
> + * @heap: the heap to be operated on
> + *
> + * Returns the largest element in the heap, without performing any modification
> + * to the heap structure. Returns NULL if the heap is empty.
> + */
> +static inline void *heap_maximum(const struct ptr_heap *heap)
> +{
> +	return heap->size ? heap->ptrs[0] : NULL;
> +}
> +
> +/**
>   * heap_init - initialize an empty heap with a given memory size
>   * @heap: the heap structure to be initialized
>   * @size: amount of memory to use in bytes
> @@ -53,6 +65,38 @@ void heap_free(struct ptr_heap *heap);
>   */
>  extern void *heap_insert(struct ptr_heap *heap, void *p);
> 
> +/**
> + * heap_remove - remove the largest element from the heap
> + * @heap: the heap to be operated on
> + *
> + * Returns the largest element in the heap. It removes this element from the
> + * heap. Returns NULL if the heap is empty.
> + */
> +extern void *heap_remove(struct ptr_heap *heap);
> 
> +/**
> + * heap_cherrypick - remove a given element from the heap
> + * @heap: the heap to be operated on
> + * @p: the element
> + *
> + * Remove the given element from the heap. Return the element if present, else
> + * return NULL. This algorithm has a complexity of O(n), which is higher than
> + * O(log(n)) provided by the rest of this API.
> + */
> +extern void *heap_cherrypick(struct ptr_heap *heap, void *p);

One way to reduce cherrypick'ing in O(n) if n is large, is to sort the
entire heap using heapify() and then doing a binary search. The cost
of sorting is high, so it depends on how often and in what phases we
cherry pick.

-- 
	Three Cheers,
	Balbir
