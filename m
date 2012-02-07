Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab2BGVdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 16:33:31 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57134 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab2BGVda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 16:33:30 -0500
Date: Tue, 7 Feb 2012 19:33:22 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf: allow command to attach local data to thread/evsel structs
Message-ID: <20120207213322.GF2172@infradead.org>
References: <4F316964.2050900@gmail.com>
 <20120207201052.GE2172@infradead.org>
 <4F319514.7030604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F319514.7030604@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 07, 2012 at 02:18:12PM -0700, David Ahern escreveu:
> 
> 
> On 02/07/2012 01:10 PM, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Feb 07, 2012 at 11:11:48AM -0700, David Ahern escreveu:
> >> This is an API I have been using for some 'local' commands that process
> >> perf events. It allows the commands to attach data to events and threads
> >> and avoid local caching and lookups.
> > 
> > In the kernel proper we try to get away with this pattern using
> > container_of where possible.
> > 
> > Here tho the structures are created in library functions.
> 
> exactly.
> 
> > 
> > The symbol library has this symbol_conf.priv_size + symbol__priv() to do
> > what you want while avoiding two allocs + one pointer in a core
> > structure.
> 
> Ok. Interesting. Somewhat of a hidden allocation. Symbols can't come and
> go like threads.

Yes, standardizing a way to attach extra info to these structs seems the
way to go.

The experience with symbol_conf is a data point, check if it fits your
needs.
 
> > I think we either use {thread_conf,evsel_conf} for global configuration
> > options for these two core data structures or we just provide some
> > optional, per perf_tool allocator.
> 
> Meaning conf's that parallel symbol_conf -- allocated and 'owned' by the
> perf library but exported for the user to set values. In this case
> handlers are needed for allocation and free as instances come and go?
> e.g., thread__new invokes thread_conf.allocator if defined and
> thread__priv returns a pointer to private data.

Well, the symbol way of doing things is to just allocate as many bytes
as the tool being used asks for and then at free time nothing special
has to be done.

Problem is when multiple things needs extra space. In the kernel we have
the skb->cb way of doing things, where we have a scratch pad that is per
layer, but limited in size, difficult to find the right way to do it.
 
> > Yeah, that sounds extreme, but hey, this is a profiler, we ought to eat
> > our own dog food, right?
> 
> um, as a library to be used by other commands libperf.so is an event
> collector and processor; profiler is just one use.

Right, but in any case the faster and less memory intensive the better,
even if not strictly needed to use lots of memory or cpu.
 
> > 
> > - Arnaldo
> > 
> > P.S.: Are your tools too specific or are they upstreamable?
> 
> Too specific.
> 
> One uses context-switch SW events to dump a time history of what task is
> running on what processor, how long it ran and how long between
> schedulings. The other uses a custom SW event to track futex's. In both
> cases the solutions are constrained by an older kernel with limited
> trace support - and too much effort to backport it.
> 
> Key points are that in processing events I want to track data that is
> task specific (e.g., last scheduled out) and event specific (e.g., time
> last seen by cpu).

Please take a look at the suggestions and propose a way to address your
needs, if a void private pointer ends up the way to go... well, we'll
have it :-)
 
> David
