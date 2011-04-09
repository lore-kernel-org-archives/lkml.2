Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1DIOGD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 10:06:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:34791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab1DIOGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 10:06:01 -0400
Subject: Re: [tip:perf/core] perf evsel: Fix inverted test for fixing up
 attr.inherit flag
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-e603dc15072c7fec0ae263597e6dabc3bb4c5c5b@git.kernel.org>
References: <new-submission>
	 <tip-e603dc15072c7fec0ae263597e6dabc3bb4c5c5b@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 09 Apr 2011 16:05:42 +0200
Message-ID: <1302357942.9086.1281.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 09:10 +0000, tip-bot for Arnaldo Carvalho de Melo
wrote:
> Commit-ID:  e603dc15072c7fec0ae263597e6dabc3bb4c5c5b
> Gitweb:     http://git.kernel.org/tip/e603dc15072c7fec0ae263597e6dabc3bb4c5c5b
> Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> AuthorDate: Mon, 21 Feb 2011 16:05:50 -0300
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Mon, 21 Feb 2011 22:27:59 -0300
> 
> perf evsel: Fix inverted test for fixing up attr.inherit flag
> 
> The kernel refuses mmapping an event with the inherit flag set for
> something that is systemwide (cpu == -1), and the evsel layer got this
> reversed at some point, fix it.
> 
> The symtom was that the --pid and --tid parameters for 'perf record' and
> 'perf top' returned with -EINVAL, like:
> 
>  # /tmp/build-perf/perf record -v -fo/tmp/perf.data -p 1042
>    Warning:  ... trying to fall back to cpu-clock-ticks
> 
>    Fatal: failed to mmap with 22 (Invalid argument)
> 
> Reported-by: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/evsel.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 63cadaf..8083d51 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -179,8 +179,19 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
>  
>  	for (cpu = 0; cpu < cpus->nr; cpu++) {
>  		int group_fd = -1;
> -
> -		evsel->attr.inherit = (cpus->map[cpu] < 0) && inherit;
> +		/*
> +		 * Don't allow mmap() of inherited per-task counters. This
> +		 * would create a performance issue due to all children writing
> +		 * to the same buffer.
> +		 *
> +		 * FIXME:
> +		 * Proper fix is not to pass 'inherit' to perf_evsel__open*,
> +		 * but a 'flags' parameter, with 'group' folded there as well,
> +		 * then introduce a PERF_O_{MMAP,GROUP,INHERIT} enum, and if
> +		 * O_MMAP is set, emit a warning if cpu < 0 and O_INHERIT is
> +		 * set. Lets go for the minimal fix first tho.
> +		 */
> +		evsel->attr.inherit = (cpus->map[cpu] >= 0) && inherit;
>  

This wrecked perf-stat, perf-stat doesn't mmap and its perfectly fine
for it to use task-bound counters with inheritance.


