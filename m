Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1CAOKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:10:01 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61479 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab1CAOJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:09:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tknzE/CQ/wqvbNCkkv8yMawBHtVXZnL63X+bgmkY96HFqc1D//mG8jyq8cXfnTLx12
         fjwifSxGKa/6tkdEzqJts6XXi137Z2oABTlq9f2yan2f+hxwoPWeg6q1elVwie9xxjOL
         5agnwEOdLlgqlYBr7HpdZ7p2/m5QEQIe5AbEU=
MIME-Version: 1.0
In-Reply-To: <1298865151-23656-5-git-send-email-daahern@cisco.com>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
	<1298865151-23656-5-git-send-email-daahern@cisco.com>
Date: Tue, 1 Mar 2011 15:09:58 +0100
Message-ID: <AANLkTikwsuBGVfB6uu7=H0jbL+2YbbvX=ea6rLwNP8w-@mail.gmail.com>
Subject: Re: [PATCH 4/6] perf script: dump software events too
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 08:52:29PM -0700, David Ahern wrote:
> Call chain options mirror perf-report.  Line format follows
> tracepoints precedent:
>
>  comm-pid [cpu] secs.usecs: event: IP symbol dso
>
> Example:
>     perf record -v -ga -e cs -c 1 -- sleep 5
>     perf script
>
> (Line lengths wrapped):
>
> sshd-794 [000] 2572.863440: context-switches: ffffffff810355de \
>     perf_event_task_sched_out ([kernel.kallsyms])
> sshd-794 [000] 2572.863440: context-switches: ffffffff81382b01 \
>     schedule ([kernel.kallsyms])
> sshd-794 [000] 2572.863440: context-switches: ffffffff8138380a \
>     schedule_hrtimeout_range_clock ([kernel.kallsyms])
> sshd-794 [000] 2572.863440: context-switches: ffffffff813838e6 \
>     schedule_hrtimeout_range ([kernel.kallsyms])
> sshd-794 [000] 2572.863440: context-switches: ffffffff8110c55d \
>     poll_schedule_timeout ([kernel.kallsyms])
> sshd-794 [000] 2572.863440: context-switches: ffffffff8110cd84 \
>     do_select ([kernel.kallsyms])
>
> or 'perf script -G'
>
> swapper-0 [001] 2572.863188: context-switches: ffffffff810355de ...
> sshd-794  [000] 2572.863440: context-switches: ffffffff810355de ...
> kworker/0:1-10 [000] 2572.863451: context-switches: ffffffff810355de ...
>
> Signed-off-by: David Ahern <daahern@cisco.com>
> ---
>  tools/perf/builtin-script.c |   65 +++++++++++++++++++++++++++--
>  tools/perf/util/session.c   |   94 +++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/session.h   |    3 +
>  3 files changed, 157 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 5f40df6..4f4c63b 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -19,6 +19,8 @@ static bool			debug_mode;
>  static u64			last_timestamp;
>  static u64			nr_unordered;
>  extern const struct option	record_options[];
> +static bool			hide_unresolved;
> +static bool			no_callchain;
>
>  static int default_start_script(const char *script __unused,
>  				int argc __unused,
> @@ -67,7 +69,11 @@ static int process_sample_event(union perf_event *event,
>  				struct perf_sample *sample,
>  				struct perf_session *session)
>  {
> +	struct perf_event_attr *attr;
> +	struct addr_location al;
>  	struct thread *thread = perf_session__findnew(session, event->ip.pid);
> +	const char *evname = NULL;
> +	static bool check_raw = true;
>
>  	if (thread == NULL) {
>  		pr_debug("problem processing %d event, skipping it.\n",
> @@ -75,7 +81,31 @@ static int process_sample_event(union perf_event *event,
>  		return -1;
>  	}
>
> -	if (session->sample_type & PERF_SAMPLE_RAW) {
> +	attr = perf_header__find_attr(sample->id, &session->header);
> +	if (!attr) {
> +		pr_debug("No attributes found for sample id %" PRId64 ". "
> +		         "skipping it.\n", sample->id);
> +		return -1;
> +	}
> +
> +	switch (attr->type) {
> +	case PERF_TYPE_SOFTWARE:
> +		if (perf_event__preprocess_sample(event, session, &al, sample,
> +					  NULL) < 0) {
> +			fprintf(stderr, "problem processing %d event, skipping it.\n",
> +				event->header.type);
> +			return -1;
> +		}
> +		perf_session__print_sample(session, &al, sample, hide_unresolved);
> +		break;

That's not on the right place. This is going to print the events even
when we launch scripts. We only want to print them when we launch
perf script without a script, which falls back to printing events
(look at default_scripting_ops).

Like I suggested you, it's better to extend struct
scripting_ops::process_event()
to take the whole event and let the handler decide what to do.
Python and Perl scripting engines can just extract the raw sample and
do like they did before.
But print_event(), which is the process_event() handler for the
default_scripting_ops,
can handle the new printing features.

That's also more flexible, this lets Python and Perl scripting engines
be extendable
to handle the rest of the event later.
