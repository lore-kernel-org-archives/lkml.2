Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1DUPUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:20:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40884 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab1DUPUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:20:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eJdFmJBLRuamVmf6Ed8ViYB3wCyNEbefZYKpwESrSPGtYnlbWWsiQA5fp45hil4C8D
         uAORjEL/TeAqnP//BrGMun637dQQeg52j3UXPoJxzmTxWkYP+oiV1oY1LCe3VbOkUgT2
         eV6hl/efiEUE6rMSFQF7AKyCoWV3fxOO8vJDs=
Date: Thu, 21 Apr 2011 17:20:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC,PATCH 3/3] trace,perf: add filter support for
 ftrace/function tracepoint event
Message-ID: <20110421152038.GA1772@nowhere>
References: <1303382458-11072-1-git-send-email-jolsa@redhat.com>
 <1303382458-11072-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303382458-11072-4-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 12:40:58PM +0200, Jiri Olsa wrote:
> Added support to be able to pass "ip == glob" filter for the ftrace/function
> tracepoint.
> 
> Respective functions are hot-patched/updated when the filter is set,
> and the filter predicate is set to be allways true.

Ideally, if the filter is set to "ip", we want to apply your hook
and not make the filter appearing in the tracing path. ie, Instead of
setting a filter with filter_pred_all callback, we should have no filter
to process from ftrace_function_call_*() things.

We probably need to make an exception when we filter parent_ip,
which can't be processed using hotpatching, so we need a real
filter for it.


> Probably missing
> several cases.. not sure this is the way.
> 
> wbr,
> jirka
> 
> ---
>  include/linux/ftrace_event.h       |    3 ++
>  kernel/trace/ftrace.c              |   35 ++++++++++++++++++++++++++++
>  kernel/trace/trace.h               |    2 +
>  kernel/trace/trace_events_filter.c |   45 ++++++++++++++++++++++++++++++++---
>  kernel/trace/trace_export.c        |   26 ++++++++++++++++----
>  5 files changed, 102 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 22b32af..bbf7cc6 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -144,6 +144,8 @@ struct ftrace_event_class {
>  	struct list_head	*(*get_fields)(struct ftrace_event_call *);
>  	struct list_head	fields;
>  	int			(*raw_init)(struct ftrace_event_call *);
> +	void			(*filter)(struct ftrace_event_call *call,
> +					  int enable);

Good, but this should take the parsed filter as a parameter.
But that's also a problem of un-globalizing the function tracer. Several
perf events, and ftrace, should be able to set different filters. Thus
you need to compute a kind of union of all these filters and keep
track of who needs which function.

perf event A may want to trace func1()
perf event B may want to trace func2()

So you need to enable func1() and func2(), although they both
have set different filters for that, but trigger an event on A
only when func1() is called, and trigger an event on B only when func2()
is called.

So we probably need a kind of function hlist to keep track of that.

I started something a while ago:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/hlist

The thing is very outdated now I think, and it needed some rework.

>  };
>  
>  extern int ftrace_event_reg(struct ftrace_event_call *event,
> @@ -221,6 +223,7 @@ enum {
>  	FILTER_STATIC_STRING,
>  	FILTER_DYN_STRING,
>  	FILTER_PTR_STRING,
> +	FILTER_TRACE_FN,

But yeah that kind of interface is cool. Although I would rather
call that FILTER_CUSTOM or FILTER_OVERRIDEN, to avoid confusion
with TRACE_FN, as this is deemed to express the fact we override
the interpretation of the filter. ftrace should be only a specific
user of that. More are perhaps coming.

Also, we may need to override the effects of the filtering endpoint
to express every capabilities of set_ftrace_filter, like
trace_on/trace_off commands. So that we can get rid of that global file in
the end.

One idea was to have a "triggers" directory in each event directories,
and have one intepretation of filters per file:

$ls triggers
filter
trace_on
trace_off

Then, when the user tries:

$ echo "ip == lambda" > trace_off

This simply disables tracing when we hit the lambda function.
Echoing the same in filter would filter when we hit that function.

The filter file in that triggers directory would refer to the same
inode of the filter file in the event directory. We would just keep
the old one for compatibility.

>  };
>  
>  #define EVENT_STORAGE_SIZE 128
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 49fbc8c..b52db6e 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3285,6 +3285,41 @@ int ftrace_event_class_register(struct ftrace_event_call *call,
>  	return -EINVAL;
>  }
>  
> +void ftrace_event_tracefn_filter(int enable)
> +{
> +	char *filter = event_function.data;
> +
> +	if (enable) {
> +		WARN_ON(!filter);
> +		if (filter)
> +			ftrace_match_records(filter, strlen(filter), 1);
> +	} else {
> +		ftrace_filter_reset(1);
> +		if (filter) {
> +			kfree(filter);
> +			event_function.data = NULL;
> +		}
> +	}
> +
> +	mutex_lock(&ftrace_lock);
> +	if (ftrace_enabled)
> +		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
> +	mutex_unlock(&ftrace_lock);
> +}

Note we may have complicated expressions linked with either && or ||.
Thus you need to be able to compute unions and intersections or
functions sets. The ftrace_match_record() won't be sufficient enough
for that. Best would be to evaluate the whole tree of the parsed expression.

This can be done gradually though, we can start with simple expressions
and reject complicated ones to begin with.

Thanks.
