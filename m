Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1KQPjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:39:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab1KQPjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:39:00 -0500
Message-ID: <4EC52A7C.5010809@redhat.com>
Date: Thu, 17 Nov 2011 17:38:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>,
        rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] tracepoint/jump_label overhead
References: <1321502104.3274.22.camel@edumazet-laptop> <1321543520.27735.67.camel@twins>
In-Reply-To: <1321543520.27735.67.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 05:25 PM, Peter Zijlstra wrote:
> On Thu, 2011-11-17 at 04:55 +0100, Eric Dumazet wrote:
> > The general admitted claim of a tracepoint being on x86 a single
> > instruction :
> > 
> > jmp +0
> > 
> > Is not always true.
> > 
> > For example in mm/slub.c, kmem_cache_alloc()
> > 
> > void *ret = slab_alloc(s, gfpflags, NUMA_NO_NODE, _RET_IP_); 
> > trace_kmem_cache_alloc(_RET_IP_, ret, s->objsize, s->size, gfpflags);
> > return ret;
> > 
> > We can check compiler output and see that 4 extra instructions were
> > added because s->objsize & s->size are evaluated.
> > 
> > I noticed this in a perf session, because these 4 extra instructions
> > added some noticeable latency/cost.
> > 
> > c10e26a4:       8b 5d d8                mov    -0x28(%ebp),%ebx
> > c10e26a7:       85 db                   test   %ebx,%ebx
> > c10e26a9:       75 6d                   jne    c10e2718   (doing the memset())
> > c10e26ab:       8b 76 0c                mov    0xc(%esi),%esi   // extra 1
> > c10e26ae:       8b 5d 04                mov    0x4(%ebp),%ebx   // extra 2
> > c10e26b1:       89 75 f0                mov    %esi,-0x10(%ebp) // extra 3
> > c10e26b4:       89 5d ec                mov    %ebx,-0x14(%ebp) // extra 4
> > c10e26b7:       e9 00 00 00 00          jmp    c10e26bc 
> > c10e26bc:       8b 45 d8                mov    -0x28(%ebp),%eax
> > c10e26bf:       83 c4 28                add    $0x28,%esp
> > c10e26c2:       5b                      pop    %ebx
> > c10e26c3:       5e                      pop    %esi
> > c10e26c4:       5f                      pop    %edi
> > c10e26c5:       c9                      leave
> > 
> > 
> > A fix would be to not declare an inline function but a macro...
> > 
> > #define trace_kmem_cache_alloc(...) \
> > 	if (static_branch(&__tracepoint_kmem_cache_alloc.key)) \
> > 		__DO_TRACE(&__tracepoint_kmem_cache_alloc,	\
> > 			...
> > 
> > Anyone has some clever idea how to make this possible ?

You could do that with a code generator, which I'm sure everyone will like.

> Right so you're not really supposed to use arguments that require
> evaluation in tracepoints, although I bet its common these days :/
>
> The problem here is that its 'hard' to pass s in and have the
> TP_fast_assign() thing do the dereference because of the sl[auo]b thing.
>

You could have sl[auo]b define a function or macro which tp_fast_assign
then uses to dereference its parameter.

-- 
error compiling committee.c: too many arguments to function

