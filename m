Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965905Ab2EORH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:07:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56563 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302Ab2EORHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:07:24 -0400
Message-ID: <1337101633.27694.92.camel@twins>
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 15 May 2012 19:07:13 +0200
In-Reply-To: <1337093080.1493.22.camel@leonhard>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
	 <CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
	 <1336994000.2443.24.camel@twins>  <20120514115551.GA6479@gmail.com>
	 <1337007985.1552.5.camel@leonhard>  <1337077973.27694.24.camel@twins>
	 <1337093080.1493.22.camel@leonhard>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 23:44 +0900, Namhyung Kim wrote:

> Got it. So it means that we do need to create an event for each cpu
> in order to profile a task (and its children), right? (Originally, I
> thought it's a bug :-p)

Almost, to profile a task you can get away with a per-task event, but to
add the 'and its children', you need per-task-per-cpu.

This is because while one task will only ever run on one cpu at the time
(spare scheduler bugs :-), multiple tasks can run on multiple cpus. So
if you have one event all output will need to go to the one buffer
associated with it, causing multiple cpus to write to the one buffer.

This creates resource contention to the point that a 64-cpu machine
would appear deadlocked (the original perf had it this way and made some
people very unhappy).

> If so, yes, the commit 55261f46702c ("perf evlist: Fix creation of
> cpu map") should be reverted like below (note that target->cpu_list
> check no longer needed since perf_target__validate() will handle
> those cases). If it looks ok to you guys, I'll send a formal patch
> with name changes (to avoid the double negation suggested by Ingo):
> 
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 1201daf71719..f6979ba391d1 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -609,10 +609,10 @@ int perf_evlist__create_maps(struct perf_evlist 
>  	if (evlist->threads == NULL)
>  		return -1;
>  
> -	if (!perf_target__no_cpu(target))
> -		evlist->cpus = cpu_map__new(target->cpu_list);
> -	else
> +	if (!perf_target__no_task(target))
>  		evlist->cpus = cpu_map__dummy_new();
> +	else
> +		evlist->cpus = cpu_map__new(target->cpu_list);
>  
>  	if (evlist->cpus == NULL)
>  		goto out_delete_threads;


This does indeed make it work again:

pre patch:

[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.005 MB perf.data (~212 samples) ]

post patch:

[ perf record: Woken up 209 times to write data ]
[ perf record: Captured and wrote 54.931 MB perf.data (~2399974 samples) ]

So please do send as a proper patch, and you can add:

Acked-and-tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
