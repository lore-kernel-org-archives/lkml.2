Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2EaOvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:51:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2EaOvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:51:03 -0400
Date: Thu, 31 May 2012 11:50:42 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] perf script: Replace "struct thread" with "struct
 addr_location" as a parameter for "process_event()"
Message-ID: <20120531145042.GA28571@infradead.org>
References: <1338446072-24655-1-git-send-email-feng.tang@intel.com>
 <1338446072-24655-2-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338446072-24655-2-git-send-email-feng.tang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 31, 2012 at 02:34:31PM +0800, Feng Tang escreveu:
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 8e395a5..282e206 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -405,9 +405,10 @@ static void process_event(union perf_event *event __unused,
>  			  struct perf_sample *sample,
>  			  struct perf_evsel *evsel,
>  			  struct machine *machine,
> -			  struct thread *thread)
> +			  struct addr_location *al __unused)

Why the __unused modifier, since you...

>  {
>  	struct perf_event_attr *attr = &evsel->attr;
> +	struct thread *thread = al->thread;

... are using al?
  
>  	if (output[attr->type].fields == 0)
>  		return;
> @@ -520,7 +521,7 @@ static int process_sample_event(struct perf_tool *tool __used,
>  	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
>  		return 0;
>  
> -	scripting_ops->process_event(event, sample, evsel, machine, thread);
> +	scripting_ops->process_event(event, sample, evsel, machine, &al);
>  
>  	evsel->hists.stats.total_period += sample->period;
>  	return 0;
> diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
> index 4c1b3d7..af9a6a4 100644
> --- a/tools/perf/util/scripting-engines/trace-event-perl.c
> +++ b/tools/perf/util/scripting-engines/trace-event-perl.c
> @@ -256,7 +256,7 @@ static void perl_process_tracepoint(union perf_event *pevent __unused,
>  				    struct perf_sample *sample,
>  				    struct perf_evsel *evsel,
>  				    struct machine *machine __unused,
> -				    struct thread *thread)
> +				    struct addr_location *al __unused)

Ditto

>  {
>  	struct format_field *field;
>  	static char handler[256];
> @@ -268,6 +268,7 @@ static void perl_process_tracepoint(union perf_event *pevent __unused,
>  	int cpu = sample->cpu;
>  	void *data = sample->raw_data;
>  	unsigned long long nsecs = sample->time;
> +	struct thread *thread = al->thread;
>  	char *comm = thread->comm;
>  
>  	dSP;
> @@ -346,7 +347,7 @@ static void perl_process_event_generic(union perf_event *pevent __unused,
>  				       struct perf_sample *sample,
>  				       struct perf_evsel *evsel __unused,
>  				       struct machine *machine __unused,
> -				       struct thread *thread __unused)
> +				       struct addr_location *al __unused)

Here it seems ok

>  {
>  	dSP;
>  
> @@ -372,10 +373,10 @@ static void perl_process_event(union perf_event *pevent,
>  			       struct perf_sample *sample,
>  			       struct perf_evsel *evsel,
>  			       struct machine *machine,
> -			       struct thread *thread)
> +			       struct addr_location *al)

And here it is correctly without the __unused marker

Check the others please
