Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab0ELQrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 12:47:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39093 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab0ELQrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 12:47:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XJYGcVAdcjeQBowfWraLCZvVtxPZvc1lCXlG0kw9FUZwRO16pV6UfjoAN+toTc/92R
         C7wXD9mjSP5K1wsHIT9zLsUEoomKaldktQpwzBPbYGWcIbfZ9P3TjiGMQBYFH8969kCh
         v7jbejrLMOd3T/U0Hmp2kicMCshMLvjQWMaHo=
Date: Wed, 12 May 2010 18:46:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
       arjan@infradead.org, ziga.mahkovec@gmail.com
Subject: Perf and ftrace [was Re: PyTimechart]
Message-ID: <20100512164650.GH5405@nowhere>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com> <20100511213625.GD5422@nowhere> <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com> <20100512144811.GA5405@nowhere> <1273678596.27703.30.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273678596.27703.30.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 11:36:36AM -0400, Steven Rostedt wrote:
> On Wed, 2010-05-12 at 16:48 +0200, Frederic Weisbecker wrote:
> > On Wed, May 12, 2010 at 03:37:27PM +0200, Pierre Tardy wrote:
> 
> > But we don't yet support trace_printk in perf. May be we could wrap
> > them in trace events.
> 
> Hmm, do we really want to do that?
> 
> We really need to get the perf and ftrace trace buffers combined. I
> understand why perf chose to do the mmap buffers for the counting


I don't think that's the reason. I mean that's the reason for
every perf tools that live record and analyse events as they come
(perf top, perf stat).

But there is no strong reason for perf record not to use splice,
a part the fact that perf doesn't support splice.


> but
> for live streaming, it is very inefficient compared to splice.


Yeah, totally agreed.

I'm looking forward the day we'll have a ring buffer that can be
either lockless per-cpu or support contention, and that can be
spliced, mmap'ed and read, and that supports overwriting mode.
So that we can unify all this mess between perf and ftrace.

But note splice is only part of the problem, eventually not
the biggest one for now (but it is one important):

perf starts to show its weaknesses now that we are playing with
lock events (by nature high freq events).
This is mostly due to the fact we are doing a round pass on all
per cpu mmap'ed buffers. The time you handle an event buffer, you've
already lost a lot of events from another one.

trace-cmd is certainly much more efficient in this regard (one thread
per cpu splicing one file per cpu), atlhough less convenient for
cross analysis as you need to handle several files.

perf record works well with every events but lock ones.

I plan to try something like a perf multiplex: one thread per
cpu that reads the mmap'ed buffers and write in its own file,
and in the end you gather the whole in a single one.

This will solve the first and problem: this scheme will probably catch up
with 80% of trace-cmd efficiency, until we get a true splice support.

In fact, I hope trace-cmd will come to be merged in tools/, I'm not
worried anymore about having two different tools that do the same
things wrt tracing, because I think they will eventually get
merged together step by step: the format parsing API, kernelshark,
sched/lock/timechart/kmem/etc... tools.

And sharing the same buffer will probably announce the final merge
between both, with a single and strong tracing tool set.

 
> I would hate to add more duplicate code to have perf support
> trace_printk().


No, having trace_printk() implemented on top on trace events is
a win on both sides: we can toggle their activation, filter, have
their format, etc...

The duplication would only reside in the tracing callback, and
as a temporary thing like the others until we finally have this
common buffer.

Thanks.

