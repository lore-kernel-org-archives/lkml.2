Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab1FQOOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:14:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36193 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab1FQOOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:14:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YJw498NnicuxDfobNNdhS6LFLeIb7qIjrPqQsQ3Tx4hyaMJJxb4B1cqBKtvN4NCy0e
         lffNIMNATl3y1MmrVDnlaiavAKxyZEqs8HHE70ocSI4V7sg2opnn3QJjrR/uyxsPvSsN
         yjahynbiREEQ/k6y4iO42U+832NCG7+IQTys0=
Date: Fri, 17 Jun 2011 16:14:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 4/6] perf record: add time-of-day option
Message-ID: <20110617141425.GD25197@somewhere.redhat.com>
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
 <1307490964-24714-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307490964-24714-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 05:56:04PM -0600, David Ahern wrote:
> Use reftime event for initial correlation of perf_clock to
> time-of-day. Add timekeeping trace events to event list to
> capture jumps in time-of-day.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/Documentation/perf-record.txt |    3 +
>  tools/perf/builtin-record.c              |  102 +++++++++++++++++++++++++++++-
>  2 files changed, 104 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index 5a520f8..e4c87ba 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -148,6 +148,9 @@ an empty cgroup (monitor all the time) using, e.g., -G foo,,bar. Cgroups must ha
>  corresponding events, i.e., they always refer to events defined earlier on the command
>  line.
>  
> +--tod::
> +Collect data for displaying time-of-day strings when printing events.
> +
>  SEE ALSO
>  --------
>  linkperf:perf-stat[1], linkperf:perf-list[1]
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 8e2c857..4f8d5f2 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -32,6 +32,9 @@
>  
>  #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
>  
> +#define TRACE_TOD_SUBSYSTEM      "timekeeping"
> +#define TRACE_TOD_SUBSYSTEM_LEN  11
> +
>  enum write_mode_t {
>  	WRITE_FORCE,
>  	WRITE_APPEND
> @@ -65,6 +68,8 @@ static bool			sample_address			=  false;
>  static bool			sample_time			=  false;
>  static bool			no_buildid			=  false;
>  static bool			no_buildid_cache		=  false;
> +static bool			want_tod			=  false;
> +static u64 			tod_sample_type;
>  static struct perf_evlist	*evsel_list;
>  
>  static long			samples				=      0;
> @@ -215,6 +220,9 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
>  		attr->sample_type	|= PERF_SAMPLE_CPU;
>  	}
>  
> +	if (want_tod)
> +		attr->sample_type	|= tod_sample_type;
> +
>  	if (nodelay) {
>  		attr->watermark = 0;
>  		attr->wakeup_events = 1;
> @@ -248,6 +256,86 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
>  	return true;
>  }
>  
> +static int perf_event__synthesize_reftime(perf_event__handler_t process)
> +{
> +	union perf_event ev;
> +	struct timespec tp;
> +
> +	memset(&ev, 0, sizeof(ev));
> +
> +	if (gettimeofday(&ev.reftime.tv, NULL) != 0) {
> +		error("gettimeofday failed.\n");
> +		return -1;
> +	}
> +	if (clock_gettime(CLOCK_MONOTONIC, &tp) != 0) {
> +		error("clock_gettime(CLOCK_MONOTONIC) failed.\n");
> +		return -1;
> +	}
> +	ev.reftime.nsec = (u64) tp.tv_sec * NSEC_PER_SEC + (u64) tp.tv_nsec;
> +
> +	ev.header.type = PERF_RECORD_REFTIME;
> +	ev.header.size = sizeof(ev.reftime);
> +
> +	return process(&ev, NULL, session);
> +}
> +
> +static int add_timeofday_events(void)
> +{
> +	int rc, i, len;
> +	struct perf_event_attr attr;
> +	struct perf_evsel *evsel;
> +
> +	/* events that modify xtime */
> +	const char *tod_events[] = {"settimeofday",
> +				    "timekeeping_inject_offset",
> +				    "timekeeping_inject_sleeptime",
> +				    NULL};
> +
> +	i = 0;
> +	rc = -1;
> +	while (tod_events[i]) {
> +		memset(&attr, 0, sizeof(attr));
> +		len = strlen(tod_events[i]);
> +
> +		if (parse_single_tracepoint_event(TRACE_TOD_SUBSYSTEM,
> +			tod_events[i], len, &attr, NULL) == EVT_FAILED) {
> +			error("Failed to parse event %s\n", tod_events[i]);
> +			goto out;
> +		}
> +
> +		evsel = perf_evsel__new(&attr, evsel_list->nr_entries);
> +		if (evsel == NULL)
> +			return -1;
> +
> +		perf_evlist__add(evsel_list, evsel);
> +
> +		/* +2 for ':' delimiter and string terminator */
> +		evsel->name = calloc(TRACE_TOD_SUBSYSTEM_LEN + len + 2, 1);
> +		if (!evsel->name)
> +			return -1;
> +
> +		sprintf(evsel->name, "timekeeping:%s", tod_events[i]);
> +
> +		tod_sample_type |= attr.sample_type;
> +
> +		++i;
> +	}
> +
> +	/*
> +	 * right now sample_type for all samples needs to be the same.
> +	 * tracepoints are collected at sample period 1 and hence do not
> +	 * request the period with the sample. However, default for record
> +	 * is cycles at a frequency. So, until this sample_type mess is
> +	 * fixed....
> +	 */
> +	if (freq)
> +		tod_sample_type |= PERF_SAMPLE_PERIOD;
> +
> +	rc = 0;
> +out:
> +	return rc;
> +}

So I feel uncomfortable with this tod_sample_type hack. I think we can't really continue
with this fixed sample_type per session given the kind of hacks that involves.

One thing we could do is to split session->sample_type into an array with one sample
type per event type (hardware, breakpoint, software, tracepoint).

And then each builtin tool can provide their constraints on top of these values:

- builtin-report wants sample_type[HARDWARE] == sample_type[SOFTWARE] == sample_type[TRACEPOINT] == sample_type[BREAKPOINT]
  although that may be tunable by the time but we can start with that.
- builtin-script has no specific constraints, except that sample_type[i] meets what the user passed as a parameter
- etc..

Constraints can probably default to sample_type[i] == sample_type[i+1] to mimic the current behaviour. Then tools
can override that.

What do you think?
