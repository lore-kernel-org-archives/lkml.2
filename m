Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab1CJPU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:20:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53337 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab1CJPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:20:56 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=s7jom2g7sBwA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=AUd_NHdVAAAA:8 a=J8BR8G8HAtYwdHw_A0QA:9 a=3nI3a4TdSf0n-Jfw_q4A:7 a=rl-ze-4IBHBGimRrgf6lvH045OoA:4 a=CjuIK1q_8ugA:10 a=JfD0Fch1gWkA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 10 Mar 2011 10:20:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf script: move printing of 'common' data from
 print_event and rename
Message-ID: <20110310152053.GB12521@home.goodmis.org>
References: <1299734608-5223-1-git-send-email-daahern@cisco.com>
 <1299734608-5223-4-git-send-email-daahern@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299734608-5223-4-git-send-email-daahern@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 10:23:25PM -0700, David Ahern wrote:
> This change does impact output: latency data is trace specific and is now
> printed after the common data - comm, tid, cpu, time and event name.
> 
> Signed-off-by: David Ahern <daahern@cisco.com>
> ---
>  tools/perf/builtin-script.c         |   38 ++++++++++++++++++++++-----
>  tools/perf/util/trace-event-parse.c |   49 +++++++---------------------------

I was hoping after the next merge window to start making a common library
for parsing events. This way things like powertop and timechart or
anything that uses the perf interface does not need to write its own
parsing of events, or expect the event formats to be hardcoded.

The trace-event-parse.c was taking from trace-cmd's parse-events.c code
and hopefully the two can merge again. The parse-events.c code in
trace-cmd has gone through several iterations that has made it much more
robust and flexible. I purposely kept it as a separate libarary not
dependent on trace-cmd so that it could be used by other utilities like
perf.

>  tools/perf/util/trace-event.h       |    3 +-
>  3 files changed, 42 insertions(+), 48 deletions(-)
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
>  static void process_event(union perf_event *event __unused,
>  			  struct perf_sample *sample,
>  			  struct perf_session *session __unused,
>  			  struct thread *thread)
>  {
> -	/*
> -	 * FIXME: better resolve from pid from the struct trace_entry
> -	 * field, although it should be the same than this perf
> -	 * event pid
> -	 */
> -	print_event(sample->cpu, sample->raw_data, sample->raw_size,
> -		    sample->time, thread->comm);
> +	print_sample_start(sample, thread);
> +	print_trace_event(sample->cpu, sample->raw_data, sample->raw_size);
> +	printf("\n");
>  }
>  
>  static int default_start_script(const char *script __unused,
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index dd5f058..0a7ed5b 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -2643,9 +2643,9 @@ static void print_lat_fmt(void *data, int size __unused)
>  		printf(".");
>  
>  	if (lock_depth < 0)
> -		printf(".");
> +		printf(". ");
>  	else
> -		printf("%d", lock_depth);
> +		printf("%d ", lock_depth);

For example, I'm removing the field lock_depth, as that was added by
Frederic as a temporary field to help with the removal of the BKL.
Currently this code is unused by perf, but if it is in the future, it
must be able to handle not having this field. In fact, I'm thinking of
modifying other "common" fields to help improve tracing performance.

If we could have a common library for all tools that need to parse
events, then this code can be updated in a single place. Which also
brings another point. Do we want to move the events out of debugfs. And
if we do, I would love to change the way the event format is. I consider
the format in debugfs as it stands a true ABI, but the content that the
format shows is not.

-- Steve
