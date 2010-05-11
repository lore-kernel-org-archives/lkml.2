Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab0EKOsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:48:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab0EKOsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:48:05 -0400
Subject: Re: [RFC] perf: perf record sets inherit by default
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
In-Reply-To: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
References: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 16:48:02 +0200
Message-ID: <1273589282.1810.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 16:04 +0200, Stephane Eranian wrote:
> Hi,
> 
> 
> I am confused by the inheritance cmd line option of perf record:
> 
> $ perf record -h
>  usage: perf record [<options>] [<command>]
>     or: perf record [<options>] -- <command> [<options>]
> 
>     -e, --event <event>   event selector. use 'perf list' to list
> available events
>         --filter <filter>
>                           event filter
>     -p, --pid <n>         record events on existing process id
>     -t, --tid <n>         record events on existing thread id
>     -r, --realtime <n>    collect data with this RT SCHED_FIFO priority
>     -R, --raw-samples     collect raw sample records from all opened counters
>     -a, --all-cpus        system-wide collection from all CPUs
>     -A, --append          append to the output file to do incremental profiling
>     -C, --profile_cpu <n>
>                           CPU to profile on
>     -f, --force           overwrite existing data file (deprecated)
>     -c, --count           event period to sample
>     -o, --output <file>   output file name
>     -i, --inherit         child tasks inherit counters
> 
> This leads to believe that by default inheritance in children is off.
> 
> However, builtin-record.c says:
> 
> static bool                     inherit                         =   true;
> 
> If that's the case, what's the point of the -i option?

Right, I think we should invert that, does --no-inherit work?

> Another side effect of inheritance is that in per-thread mode,
> perf creates as many "sessions" as you have CPUs. So
> on a 16-way processor, sampling on cycles, perf creates
> 16 events and 16 x 2-page sampling buffers. That's a lot of
> resources consumed if I am just interested in monitoring
> a single-threaded workload.

Right, but I think the default of inherit is right, and once you do that
you basically have to do the per-task-per-cpu thing, otherwise your
fancy 16-way will start spending most of its time in cacheline bounces.

That said, !inherit wouldn't need that, so a patch doing that would be
nice.



