Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1CIXuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:50:19 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34073 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1CIXuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:50:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DwQzr6aI/t2G+cFaSLyVPUUyTylc5+qYbBtrfDPhIb9wX4lsmd4EKCoYd4R1X9XQvM
         /F547L/b//yiKIHQgh+/h0sjkl5MJZAR1yahz3PrwElfhjeqOIAnZlUn3uW+mgsbigFZ
         NzXhv1XUTnlmd8xahb1QUH4vpFRikH+dxMe+A=
Date: Thu, 10 Mar 2011 00:50:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        David Ahern <daahern@cisco.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 07/10] perf script: Move printing of 'common' data from
 print_event and rename
Message-ID: <20110309235007.GB2533@nowhere>
References: <1299695491-15786-1-git-send-email-acme@infradead.org>
 <1299695491-15786-8-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299695491-15786-8-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 03:31:28PM -0300, Arnaldo Carvalho de Melo wrote:
> From: David Ahern <daahern@cisco.com>
> 
> This change does impact output: latency data is trace specific and is now
> printed after the common data - comm, tid, cpu, time and event name.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> LPU-Reference: <1299606342-26745-3-git-send-email-daahern@cisco.com>
> Signed-off-by: David Ahern <daahern@cisco.com>
> [ committer note: Added space after print_lat_fmt() ]
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-script.c         |   38 ++++++++++--
>  tools/perf/util/trace-event-parse.c |  106 +++--------------------------------
>  tools/perf/util/trace-event.h       |    3 +-
>  3 files changed, 41 insertions(+), 106 deletions(-)
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index b2bdd55..0a79da2 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -20,18 +20,42 @@ static u64			last_timestamp;
>  static u64			nr_unordered;
>  extern const struct option	record_options[];
>  
> +static void print_sample_start(struct perf_sample *sample,
> +			       struct thread *thread)
> +{
> +	int type;
> +	struct event *event;
> +	const char *evname = NULL;
> +	unsigned long secs;
> +	unsigned long usecs;
> +	unsigned long long nsecs = sample->time;
> +
> +	if (latency_format)

I believe we don't yet make use of the latency format with perf.
Like the function graph output, it was included in that code coming
from trace-cmd.

We might use it in the future though, so it looks fine to keep it
and handle it like you did.

> +		printf("%8.8s-%-5d %3d", thread->comm, sample->tid, sample->cpu);
> +	else
> +		printf("%16s-%-5d [%03d]", thread->comm, sample->tid, sample->cpu);
> +
> +	secs = nsecs / NSECS_PER_SEC;
> +	nsecs -= secs * NSECS_PER_SEC;
> +	usecs = nsecs / NSECS_PER_USEC;
> +	printf(" %5lu.%06lu: ", secs, usecs);
> +
> +	type = trace_parse_common_type(sample->raw_data);
> +	event = trace_find_event(type);
> +	if (event)
> +		evname = event->name;
> +
> +	printf("%s: ", evname ? evname : "(unknown)");
> +}
> +
[...]
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -2648,63 +2648,8 @@ static void print_lat_fmt(void *data, int size __unused)
>  		printf("%d", lock_depth);
>  }
>  
> -/* taken from Linux, written by Frederic Weisbecker */
> -static void print_graph_cpu(int cpu)
> -{
> -	int i;
> -	int log10_this = log10_cpu(cpu);
> -	int log10_all = log10_cpu(cpus);
> -
> -
> -	/*
> -	 * Start with a space character - to make it stand out
> -	 * to the right a bit when trace output is pasted into
> -	 * email:
> -	 */
> -	printf(" ");
> -
> -	/*
> -	 * Tricky - we space the CPU field according to the max
> -	 * number of online CPUs. On a 2-cpu system it would take
> -	 * a maximum of 1 digit - on a 128 cpu system it would
> -	 * take up to 3 digits:
> -	 */
> -	for (i = 0; i < log10_all - log10_this; i++)
> -		printf(" ");
> -
> -	printf("%d) ", cpu);
> -}

So, we indeed don't use the function graph tracer with perf yet.
But there are fair chances we will in the future.

So if we remove such code, I would prefer this to be made as
a seperate commit. Something we can easily retrieve and revert
in the future.

Other than that and the callchain bug, the whole series looks
pretty good now.

Thanks a lot!
