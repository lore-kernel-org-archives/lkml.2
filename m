Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab1KCBYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:24:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59412 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab1KCBYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:24:15 -0400
Message-ID: <4EB1ED9F.3060708@cn.fujitsu.com>
Date: Thu, 03 Nov 2011 09:25:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Restore system filter behavior
References: <4EAF46CF.8040408@cn.fujitsu.com>	 <1320258167.4793.45.camel@gandalf.stny.rr.com>	 <1320259868.4793.46.camel@gandalf.stny.rr.com> <1320266741.4793.50.camel@gandalf.stny.rr.com>
In-Reply-To: <1320266741.4793.50.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-03 09:24:14,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-03 09:24:14,
	Serialize complete at 2011-11-03 09:24:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2011-11-02 at 14:51 -0400, Steven Rostedt wrote:
>> On Wed, 2011-11-02 at 14:22 -0400, Steven Rostedt wrote:
>>
>>> The above shows how things are just ambiguous. I have no problem in
>>> using the top filter to set multiple events. But the top filter should
>>> not keep the state of what was set. Perhaps just have system event
>>> filters always show default text. Like:
>>>
>>> # cat /debug/tracing/events/sched/filter
>>> ### global filter ###
>>> # Use this to set multiple event filters
>>> # Only affects events that have the event fields specified in the filter
>>>
>>>
>>> I'll add your patch, but are you OK with the above always printing for
>>> system event filters?  Just to remove the ambiguous state.
>>
>>
>> As the filter is also used to show errors, I'll only have it print the
>> "message" if the filter worked. If there's an error, then the error
>> message will display instead.
>>
> 
> What's your thought on the below patch?
> 

I'm fine with this idea. 

a comment below..

> -- Steve
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 86040d9..6dee2b5 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -27,6 +27,12 @@
>  #include "trace.h"
>  #include "trace_output.h"
>  
> +#define DEFAULT_SYS_FILTER_MESSAGE					\
> +	"### global filter ###\n"					\
> +	"# Use this to set filters for multiple events.\n"		\
> +	"# Only events with the given fields will be affected.\n"	\
> +	"# If no events are modified, an error message will be displayed here"
> +
>  enum filter_op_ids
>  {
>  	OP_OR,
> @@ -646,7 +652,7 @@ void print_subsystem_event_filter(struct event_subsystem *system,
>  	if (filter && filter->filter_string)
>  		trace_seq_printf(s, "%s\n", filter->filter_string);
>  	else
> -		trace_seq_printf(s, "none\n");
> +		trace_seq_printf(s, DEFAULT_SYS_FILTER_MESSAGE "\n");
>  	mutex_unlock(&event_mutex);
>  }
>  
> @@ -1838,7 +1844,8 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
>  	if (!filter)
>  		goto out;
>  
> -	replace_filter_string(filter, filter_string);
> +	/* System filters just show a default message */
> +	replace_filter_string(filter, DEFAULT_SYS_FILTER_MESSAGE);

Seems we can call remove_filter_string() instead to save memory.

>  	/*
>  	 * No event actually uses the system filter
>  	 * we can free it without synchronize_sched().
> @@ -1848,14 +1855,12 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
>  
>  	parse_init(ps, filter_ops, filter_string);
>  	err = filter_parse(ps);
> -	if (err) {
> -		append_filter_err(ps, system->filter);
> -		goto out;
> -	}
> +	if (err)
> +		goto err_filter;
>  
>  	err = replace_system_preds(system, ps, filter_string);
>  	if (err)
> -		append_filter_err(ps, system->filter);
> +		goto err_filter;
>  
>  out:
>  	filter_opstack_clear(ps);
> @@ -1865,6 +1870,11 @@ out_unlock:
>  	mutex_unlock(&event_mutex);
>  
>  	return err;
> +
> +err_filter:
> +	replace_filter_string(filter, filter_string);
> +	append_filter_err(ps, system->filter);
> +	goto out;
>  }
>  
>  #ifdef CONFIG_PERF_EVENTS
> 
> 
> 
