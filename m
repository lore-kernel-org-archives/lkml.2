Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665Ab0JHVxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 17:53:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8351 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab0JHVxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 17:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jCrJDXVrmV548wEDbIj3KflgJZavKdD6SYo/b5f1LA9w91JOwx1qgR8neBq+vh45pr
         roW6nhayXw1VXsZiPAHQ==
MIME-Version: 1.0
In-Reply-To: <20101007190322.GA27054@Krystal>
References: <20101007190322.GA27054@Krystal>
Date: Fri, 8 Oct 2010 14:53:14 -0700
Message-ID: <AANLkTimKV_wvYPAERm2mdK49YB44T9bZ2uTSQuVYFSv6@mail.gmail.com>
Subject: Re: [PATCH] Prio_heap: heap_remove(), heap_maximum(), heap_replace()
 and heap_cherrypick()
From: Paul Menage <menage@google.com>
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
        David Rientjes <rientjes@google.com>,
        Nick Piggin <nickpiggin@yahoo.com.au>,
        Balbir Singh <balbir@in.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 12:03 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
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

Looks fine, other than a couple of suggestions to make the code
slightly clearer.

Acked-by: Paul Menage <menage@google.com>

> Acked-by: Balbir Singh <balbir@in.ibm.com>
> Cc: Paul Menage <menage@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Cedric Le Goater <clg@fr.ibm.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  include/linux/prio_heap.h |   44 ++++++++++++++++++++++
>  lib/prio_heap.c           |   91 ++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 116 insertions(+), 19 deletions(-)
>
> Index: linux.trees.git/include/linux/prio_heap.h
> ===================================================================
> --- linux.trees.git.orig/include/linux/prio_heap.h      2010-07-06 14:25:29.000000000 -0400
> +++ linux.trees.git/include/linux/prio_heap.h   2010-07-07 10:04:33.000000000 -0400
> @@ -23,6 +23,18 @@ struct ptr_heap {
>  };
>
>  /**
> + * heap_maximum - return the largest element in the heap
> + * @heap: the heap to be operated on
> + *
> + * Returns the largest element in the heap, without performing any modification
> + * to the heap structure. Returns NULL if the heap is empty.
> + */
> +static inline void *heap_maximum(const struct ptr_heap *heap)
> +{
> +       return heap->size ? heap->ptrs[0] : NULL;
> +}
> +
> +/**
>  * heap_init - initialize an empty heap with a given memory size
>  * @heap: the heap structure to be initialized
>  * @size: amount of memory to use in bytes
> @@ -53,6 +65,38 @@ void heap_free(struct ptr_heap *heap);
>  */
>  extern void *heap_insert(struct ptr_heap *heap, void *p);
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
> +
> +/**
> + * heap_replace_max - replace the the largest element from the heap
> + * @heap: the heap to be operated on
> + * @p: the pointer to be inserted as topmost element replacement
> + *
> + * Returns the largest element in the heap. It removes this element from the
> + * heap. The heap is rebalanced only once after the insertion. Returns NULL if
> + * the heap is empty.
> + *
> + * This is the equivalent of calling heap_remove() and then heap_insert(), but
> + * it only rebalances the heap once.
> + */
> +extern void *heap_replace_max(struct ptr_heap *heap, void *p);
>
>  #endif /* _LINUX_PRIO_HEAP_H */
> Index: linux.trees.git/lib/prio_heap.c
> ===================================================================
> --- linux.trees.git.orig/lib/prio_heap.c        2010-07-06 14:25:29.000000000 -0400
> +++ linux.trees.git/lib/prio_heap.c     2010-07-07 10:18:32.000000000 -0400
> @@ -23,12 +23,49 @@ void heap_free(struct ptr_heap *heap)
>        kfree(heap->ptrs);
>  }
>
> -void *heap_insert(struct ptr_heap *heap, void *p)
> +static void heapify(struct ptr_heap *heap, void **ptrs, void *p, int pos)

I'd be inclined to not pass "ptrs" or "p" as an argument, and instead
get ptrs from heap->ptrs and p from ptrs[pos]. It makes it clearer
what heapify() is doing.

> +void *heap_replace_max(struct ptr_heap *heap, void *p)
>  {
>        void *res;
>        void **ptrs = heap->ptrs;
>        int pos;

No need for "pos" - just pass a constant 0 to heapify()
>
> +       if (!heap->size) {
> +               ptrs[heap->size++] = p;

Maybe make this clearer?

  ptrs[0] = p;
  heap->size = 1;

> +void *heap_remove(struct ptr_heap *heap)
> +{
> +       void **ptrs = heap->ptrs;
> +
> +       switch (heap->size) {
> +       case 0:
> +               return NULL;
> +       case 1:
> +               return ptrs[--heap->size];

Maybe clearer:

heap->size = 0;
return ptrs[0];
