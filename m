Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab2BGULB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:11:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47318 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab2BGULA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:11:00 -0500
Date: Tue, 7 Feb 2012 18:10:52 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf: allow command to attach local data to thread/evsel structs
Message-ID: <20120207201052.GE2172@infradead.org>
References: <4F316964.2050900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F316964.2050900@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 07, 2012 at 11:11:48AM -0700, David Ahern escreveu:
> This is an API I have been using for some 'local' commands that process
> perf events. It allows the commands to attach data to events and threads
> and avoid local caching and lookups.

In the kernel proper we try to get away with this pattern using
container_of where possible.

Here tho the structures are created in library functions.

The symbol library has this symbol_conf.priv_size + symbol__priv() to do
what you want while avoiding two allocs + one pointer in a core
structure.

I think we either use {thread_conf,evsel_conf} for global configuration
options for these two core data structures or we just provide some
optional, per perf_tool allocator.

Yeah, that sounds extreme, but hey, this is a profiler, we ought to eat
our own dog food, right?

- Arnaldo

P.S.: Are your tools too specific or are they upstreamable?
 
> 
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index 326b8e4..866de40 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -66,6 +66,12 @@ struct perf_evsel {
>         void        *data;
>     } handler;
>     bool            supported;
> +
> +   /*
> +    * can be used by commands that process samples
> +    * for storing local, event-based data
> +    */
> +   void *private;
>  };
> 
>  struct cpu_map;
> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
> index 70c2c13..9f62859 100644
> --- a/tools/perf/util/thread.h
> +++ b/tools/perf/util/thread.h
> @@ -16,6 +16,12 @@ struct thread {
>     bool            comm_set;
>     char            *comm;
>     int         comm_len;
> +
> +    /*
> +    * can be used by commands that process samples
> +    * for storing local, thread-based data
> +    */
> +   void *private;
>  };
> 
>  struct machine;
> 
> One wrinkle is that for the thread-based one the thread__delete(),
> thread__fork() and thread__set_comm() functions would free the
> allocations if set -- or a handler is needed to free private structs to
> handle layered mallocs.
> 
> Any objections to pushing this kind of open-ended API into perf?
> 
> David
