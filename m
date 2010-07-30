Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab0G3TTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:19:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:55242 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760671Ab0G3TTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:19:31 -0400
Date: Fri, 30 Jul 2010 16:19:03 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv10 2.6.35-rc6-tip 11/14]  perf: perf interface for uprobes
Message-ID: <20100730191903.GD12166@ghostprotocols.net>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111105.24690.48335.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727111105.24690.48335.sendpatchset@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 27, 2010 at 04:41:05PM +0530, Srikar Dronamraju escreveu:
> 
> Enhances perf probe to accept pid and user vaddr.
> Provides very basic support for uprobes.
> @@ -188,6 +190,8 @@ static const struct option options[] = {
>  	OPT__DRY_RUN(&probe_event_dry_run),
>  	OPT_INTEGER('\0', "max-probes", &params.max_probe_points,
>  		 "Set how many probe points can be found for a probe."),
> +	OPT_INTEGER('p', "pid", &params.upid,
> +			"specify a pid for a uprobes based probe"),

"ubrobes based probe" could be made clear as:

"Specify pid of process where the probe will be added"

?

The following three hunks could be moved to a separate patch that I'd
apply on my perf/core branch, so to reduce this patchset size, like I
did with the s/kprobe/probe/g one that is already there:

http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=commitdiff;h=0e60836bbd392300198c5c2d918c18845428a1fe

> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 1e8e92e..b513e40 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -1082,26 +1082,6 @@ static void event__process_sample(const event_t *self,
>  	}
>  }
>  
> -static int event__process(event_t *event, struct perf_session *session)
> -{
> -	switch (event->header.type) {
> -	case PERF_RECORD_COMM:
> -		event__process_comm(event, session);
> -		break;
> -	case PERF_RECORD_MMAP:
> -		event__process_mmap(event, session);
> -		break;
> -	case PERF_RECORD_FORK:
> -	case PERF_RECORD_EXIT:
> -		event__process_task(event, session);
> -		break;
> -	default:
> -		break;
> -	}
> -
> -	return 0;
> -}
> -
>  struct mmap_data {
>  	int			counter;
>  	void			*base;
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index d7f21d7..d93e0bb 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -552,6 +552,26 @@ int event__process_task(event_t *self, struct perf_session *session)
>  	return 0;
>  }
>  
> +int event__process(event_t *event, struct perf_session *session)
> +{
> +	switch (event->header.type) {
> +	case PERF_RECORD_COMM:
> +		event__process_comm(event, session);
> +		break;
> +	case PERF_RECORD_MMAP:
> +		event__process_mmap(event, session);
> +		break;
> +	case PERF_RECORD_FORK:
> +	case PERF_RECORD_EXIT:
> +		event__process_task(event, session);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
>  void thread__find_addr_map(struct thread *self,
>  			   struct perf_session *session, u8 cpumode,
>  			   enum map_type type, pid_t pid, u64 addr,
> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> index 887ee63..8e790da 100644
> --- a/tools/perf/util/event.h
> +++ b/tools/perf/util/event.h
> @@ -154,6 +154,7 @@ int event__process_comm(event_t *self, struct perf_session *session);
>  int event__process_lost(event_t *self, struct perf_session *session);
>  int event__process_mmap(event_t *self, struct perf_session *session);
>  int event__process_task(event_t *self, struct perf_session *session);
> +int event__process(event_t *event, struct perf_session *session);
>  
>  struct addr_location;
>  int event__preprocess_sample(const event_t *self, struct perf_session *session,

[...]

>  			group = pev->group;
> -		else
> +		else if (!pev->upid)
>  			group = PERFPROBE_GROUP;
> +		else {
> +			/*
> +			 * For uprobes based probes create a group
> +			 * probe_<pid>.
> +			 */
> +			snprintf(buf, 64, "%s_%d", PERFPROBE_GROUP, pev->upid);
> +			group = buf;
> +		}
> +
> +		tev->group = strdup(group);

Here you don't check as you do on the next strdups 

> +		if (pev->event)
> +			event = pev->event;
> +		else if (pev->point.function)
> +			event = pev->point.function;
> +		else
> +			event = tev->point.symbol;
>  
>  		/* Get an unused new event name */
>  		ret = get_new_event_name(buf, 64, event,
> @@ -1471,9 +1681,8 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
>  		if (ret < 0)
>  			break;
>  		event = buf;
> -
>  		tev->event = strdup(event);
> -		tev->group = strdup(group);
> +

here

>  		if (tev->event == NULL || tev->group == NULL) {
>  			ret = -ENOMEM;
>  			break;
> @@ -1571,6 +1780,11 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
>  		}
>  	}
>  
> +	if (pev->upid) {
> +		tev->upid = pev->upid;
> +		return 1;
> +	}
> +
>  	/* Currently just checking function name from symbol map */
>  	sym = map__find_symbol_by_name(machine.vmlinux_maps[MAP__FUNCTION],
>  				       tev->point.symbol, NULL);
> @@ -1598,15 +1812,19 @@ struct __event_package {
>  int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
>  			  bool force_add, int max_tevs)
>  {
> -	int i, j, ret;
> +	int i, j, ret = 0;
>  	struct __event_package *pkgs;
>  
>  	pkgs = zalloc(sizeof(struct __event_package) * npevs);
>  	if (pkgs == NULL)
>  		return -ENOMEM;
>  
> -	/* Init vmlinux path */
> -	ret = init_vmlinux();
> +	if (!pevs->upid)
> +		/* Init vmlinux path */
> +		ret = init_vmlinux();
> +	else
> +		ret = init_perf_uprobes();
> +
>  	if (ret < 0)

pkgs leaks here.

>  		return ret;
>  
> @@ -1666,23 +1884,15 @@ error:
>  	return ret;
>  }
