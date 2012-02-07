Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab2BGVST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 16:18:19 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42099 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab2BGVSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 16:18:17 -0500
Message-ID: <4F319514.7030604@gmail.com>
Date: Tue, 07 Feb 2012 14:18:12 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf: allow command to attach local data to thread/evsel structs
References: <4F316964.2050900@gmail.com> <20120207201052.GE2172@infradead.org>
In-Reply-To: <20120207201052.GE2172@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/07/2012 01:10 PM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Feb 07, 2012 at 11:11:48AM -0700, David Ahern escreveu:
>> This is an API I have been using for some 'local' commands that process
>> perf events. It allows the commands to attach data to events and threads
>> and avoid local caching and lookups.
> 
> In the kernel proper we try to get away with this pattern using
> container_of where possible.
> 
> Here tho the structures are created in library functions.

exactly.

> 
> The symbol library has this symbol_conf.priv_size + symbol__priv() to do
> what you want while avoiding two allocs + one pointer in a core
> structure.

Ok. Interesting. Somewhat of a hidden allocation. Symbols can't come and
go like threads.

> 
> I think we either use {thread_conf,evsel_conf} for global configuration
> options for these two core data structures or we just provide some
> optional, per perf_tool allocator.

Meaning conf's that parallel symbol_conf -- allocated and 'owned' by the
perf library but exported for the user to set values. In this case
handlers are needed for allocation and free as instances come and go?
e.g., thread__new invokes thread_conf.allocator if defined and
thread__priv returns a pointer to private data.

> 
> Yeah, that sounds extreme, but hey, this is a profiler, we ought to eat
> our own dog food, right?

um, as a library to be used by other commands libperf.so is an event
collector and processor; profiler is just one use.

> 
> - Arnaldo
> 
> P.S.: Are your tools too specific or are they upstreamable?

Too specific.

One uses context-switch SW events to dump a time history of what task is
running on what processor, how long it ran and how long between
schedulings. The other uses a custom SW event to track futex's. In both
cases the solutions are constrained by an older kernel with limited
trace support - and too much effort to backport it.

Key points are that in processing events I want to track data that is
task specific (e.g., last scheduled out) and event specific (e.g., time
last seen by cpu).

David
