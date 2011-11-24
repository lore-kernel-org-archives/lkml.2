Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab1KXTT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 14:19:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63906 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab1KXTTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 14:19:55 -0500
Message-ID: <4ECE98CD.7060902@gmail.com>
Date: Thu, 24 Nov 2011 12:19:41 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Robert Richter <robert.richter@amd.com>, mingo@redhat.com,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        efault@gmx.de, peterz@infradead.org, Arun Sharma <asharma@fb.com>
Subject: strace based on perf [Re: libperf interface stability]
References: <new-submission> <tip-06daaaba7c211ca6a8227b9a54dbc86dd837f034@git.kernel.org> <20111124162845.GB7795@erda.amd.com> <20111124181052.GA4058@infradead.org>
In-Reply-To: <20111124181052.GA4058@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 11:10 AM, Arnaldo Carvalho de Melo wrote:
> I'm working right now on another effort that hopefully will end up
> easing the development of new tools, in-perf and outside, current goal
> is to have a strace like tool using using code carved out from tools.

Interesting. I was thinking about this as well -- and Arun too I believe.

> 
> I have a branch that I explicitely mark as unstable where I'm putting
> what I have at:
> 
> https://github.com/acmel/linux/commits/tmp.perf/trace4
> 
> I hope to have it in a form that is reasonable to move it to 'perf/core'
> and then ask Ingo to merge it in the next merge window.
> 
> This is how the 'strace' is looking like, removing the error handling to
> simplify:
> 
> static const char *strace__tracepoints[] = {
> 	"raw_syscalls:sys_enter",
> 	"raw_syscalls:sys_exit",
> };

That answers the quandry about having a zillion event fd's for all the
syscalls.

> 
> static int strace(struct perf_record_opts *opts, const char *argv[])
> {
> 	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
> 
> 	err = perf_evlist__create_maps(evlist, opts->target_pid,
> 				       opts->target_tid, opts->cpu_list);
> 
> 	err = perf_evlist__add_tracepoints_array(evlist, strace__tracepoints);
> 
> 	err = perf_evlist__prepare_workload(evlist, opts, argv);
> 
> 	perf_evlist__config_attrs(evlist, opts);
> 
> 	err = perf_evlist__open(evlist, opts->group);
> 
> 	err = perf_evlist__mmap(evlist, opts->mmap_pages, false);
> 
> 	perf_evlist__start_workload(evlist);
> 
> 	/*
> 	 * WIP: use perf_evlist__read, etc and then feed a
> 	 * perf_event_ops operations sorted events like is done in
> 	 * perf_session__process_events. Top is like that but currently
> 	 * doesn't use perf_session__process_events, we need to make it
> 	 * use something refactored out from perf_session that does the
> 	 * ordering of samples perf_session does, etc.
> 	 */
> 
> 	perf_evlist__munmap(evlist);
> 
> 	perf_evlist__delete(evlist);
> }

Have you given thought to how you will compute the time spent in the
syscalls?

I've been playing around with ideas on my end -- like storing 'last seen
times' in struct thread {} and struct perf_evsel{}. For evsel it is CPU
based, so something like:

struct perf_evsel {
...
    u64 *last_time; /* time this event was last seen */
    u32 max_cpu;    /* highest cpu slot allocated */
};

And then methods to save/retrieve the time:

void perf_evsel__save_time(struct perf_evsel *evsel,
                                  u64 timestamp, u32 cpu)
{
	if ((cpu > evsel->max_cpu) || (evsel->last_time == NULL)) {
		unsigned int i;

		if (evsel->last_time)
			evsel->last_time = realloc(evsel->last_time,
				(cpu+1) * sizeof(u64));
		else
			evsel->last_time = malloc((cpu+1) * sizeof(u64));

		if (!evsel->last_time)
		    return;

		i = evsel->max_cpu ? evsel->max_cpu + 1 : 0;
		for (; i <= cpu; ++i)
			evsel->last_time[i] = (u64) 0;

		evsel->max_cpu = cpu;
	}

	evsel->last_time[cpu] = timestamp;
}

u64 perf_evsel__get_time(struct perf_evsel *evsel, u32 cpu)
{
	if (!evsel->last_time)
	    return 0;

	if ((cpu > evsel->max_cpu) || (evsel->last_time == NULL))
	    return 0;

	return evsel->last_time[cpu];
}

Saving the times allows to you compute delta-times -- between events and
per tasks.

For raw syscalls that gets harder -- now you need to save times per cpu
per syscall number. Or maybe save event histories within the thread struct.

I'll find some time to try out your trace branch over the long holiday
weekend here.

David

