Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2HYLsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 07:48:08 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:35079 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab2HYLr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 07:47:56 -0400
Date: Sat, 25 Aug 2012 13:47:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/4] perf: teach perf inject to merge sched_stat_* and
 sched_switch events (v2)
Message-ID: <20120825114746.GA28832@somewhere.redhat.com>
References: <1344344165-369636-1-git-send-email-avagin@openvz.org>
 <1344344165-369636-4-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344344165-369636-4-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 04:56:04PM +0400, Andrew Vagin wrote:
> +struct event_entry {
> +	struct list_head node;
> +	u32		 pid;
> +	union perf_event event[0];
> +};
> +
> +static LIST_HEAD(samples);
> +
> +static int perf_event__sched_stat(struct perf_tool *tool,
> +				      union perf_event *event,
> +				      struct perf_sample *sample,
> +				      struct perf_evsel *evsel,
> +				      struct machine *machine)
> +{
> +	const char *evname = NULL;
> +	uint32_t size;
> +	struct event_entry *ent;
> +	union perf_event *event_sw = NULL;
> +	struct perf_sample sample_sw;
> +	int sched_process_exit;
> +
> +	size = event->header.size;
> +
> +	evname = evsel->tp_format->name;
> +
> +	sched_process_exit = !strcmp(evname, "sched_process_exit");
> +
> +	if (!strcmp(evname, "sched_switch") ||  sched_process_exit) {
> +		list_for_each_entry(ent, &samples, node)
> +			if (sample->pid == ent->pid)

I suspect what you're rather interested in is the sample tid.

> +				break;
> +
> +		if (&ent->node != &samples) {
> +			list_del(&ent->node);
> +			free(ent);
> +		}
> +
> +		if (sched_process_exit)
> +			return 0;
> +
> +		ent = malloc(size + sizeof(struct event_entry));
> +		if (ent == NULL)
> +			die("malloc");
> +		ent->pid = sample->pid;

Ditto.

> +		memcpy(&ent->event, event, size);
> +		list_add(&ent->node, &samples);
> +		return 0;
> +
> +	} else if (!strncmp(evname, "sched_stat_", 11)) {
> +		u32 pid;
> +
> +		pid = raw_field_value(evsel->tp_format,
> +					"pid", sample->raw_data);

There you parse the pid from the trace content. That's fine because
it's actually the tid that is saved on the trace event. But this one
is not pid-namespace safe (it saves current->pid directly) while
sample->tid is pid-namespace safe (it uses task_pid_nr_ns).

So I suggest you to use sample->tid instead, plus that's going to be
consistant with what you did above.

Thanks.
