Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1K1UHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:07:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1K1UHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:07:07 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ZsTE2hiNTAsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=gV-hjTlzs9DlWSVGPYgA:9 a=vphVwsejWItdDu2iFgkA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 9/9] ftrace, perf: Add filter support for function
 trace event
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
In-Reply-To: <1322417074-5834-10-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-10-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 15:07:04 -0500
Message-ID: <1322510824.17003.18.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-27 at 19:04 +0100, Jiri Olsa wrote:
> Adding support to filter function trace event via perf
> interface. It is now possible to use filter interface
> in the perf tool like:
> 
>   perf record -e ftrace:function --filter="(ip == mm_*)" ls
> 
> The filter syntax is restricted to the the 'ip' field only,
> and following operators are accepted '==' '!=' '&&', ending
> up with the filter strings like:
> 
>   "ip == f1 f2 ..." && "ip != f3 f4 ..." ...
> 
> The '==' operator adds trace filter with same efect as would

effect

> be added via set_ftrace_filter file.
> 
> The '!=' operator adds trace filter with same efect as would

effect

> be added via set_ftrace_notrace file.
> 
> The right side of the '!=', '==' operators is list of functions
> or regexp. to be added to filter separated by space. Same syntax
> is supported/required as for the set_ftrace_filter and
> set_ftrace_notrace files.
> 
> The '&&' operator is used for connecting multiple filter definitions
> together. It is possible to have more than one '==' and '!='
> opearators within one filter string.

operators


Interesting way to handle it. I'll have to test it out. I wonder if we
could also make this work the same way with ftrace too.

-- Steve

> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/trace.h               |    4 +-
>  kernel/trace/trace_events_filter.c |  111 +++++++++++++++++++++++++++++++++---
>  kernel/trace/trace_export.c        |    5 ++
>  3 files changed, 110 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index c4330dc..fde4d2a 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -589,6 +589,8 @@ static inline int ftrace_trace_task(struct task_struct *task)
>  static inline int ftrace_is_dead(void) { return 0; }
>  #endif
>  
> +int ftrace_event_is_function(struct ftrace_event_call *call);
> +
>  /*
>   * struct trace_parser - servers for reading the user input separated by spaces
>   * @cont: set if the input is not complete - no final space char was found
> @@ -765,9 +767,7 @@ struct filter_pred {
>  	u64 			val;
>  	struct regex		regex;
>  	unsigned short		*ops;
> -#ifdef CONFIG_FTRACE_STARTUP_TEST
>  	struct ftrace_event_field *field;
> -#endif
>  	int 			offset;
>  	int 			not;
>  	int 			op;
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 7b0b04c..7434f50 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -54,6 +54,13 @@ struct filter_op {
>  	int precedence;
>  };
>  
> +static struct filter_op filter_ftrace_ops[] = {
> +	{ OP_AND,	"&&",		1 },
> +	{ OP_NE,	"!=",		2 },
> +	{ OP_EQ,	"==",		2 },
> +	{ OP_NONE,	"OP_NONE",	0 },
> +};
> +
>  static struct filter_op filter_ops[] = {
>  	{ OP_OR,	"||",		1 },
>  	{ OP_AND,	"&&",		2 },
> @@ -81,6 +88,7 @@ enum {
>  	FILT_ERR_TOO_MANY_PREDS,
>  	FILT_ERR_MISSING_FIELD,
>  	FILT_ERR_INVALID_FILTER,
> +	FILT_ERR_IP_FIELD_ONLY,
>  };
>  
>  static char *err_text[] = {
> @@ -96,6 +104,7 @@ static char *err_text[] = {
>  	"Too many terms in predicate expression",
>  	"Missing field name and/or value",
>  	"Meaningless filter expression",
> +	"Only 'ip' field is supported for function trace",
>  };
>  
>  struct opstack_op {
> @@ -992,7 +1001,12 @@ static int init_pred(struct filter_parse_state *ps,
>  			fn = filter_pred_strloc;
>  		else
>  			fn = filter_pred_pchar;
> -	} else if (!is_function_field(field)) {
> +	} else if (is_function_field(field)) {
> +		if (strcmp(field->name, "ip")) {
> +			parse_error(ps, FILT_ERR_IP_FIELD_ONLY, 0);
> +			return -EINVAL;
> +		}
> +	} else {
>  		if (field->is_signed)
>  			ret = strict_strtoll(pred->regex.pattern, 0, &val);
>  		else
> @@ -1339,10 +1353,8 @@ static struct filter_pred *create_pred(struct filter_parse_state *ps,
>  
>  	strcpy(pred.regex.pattern, operand2);
>  	pred.regex.len = strlen(pred.regex.pattern);
> -
> -#ifdef CONFIG_FTRACE_STARTUP_TEST
>  	pred.field = field;
> -#endif
> +
>  	return init_pred(ps, field, &pred) ? NULL : &pred;
>  }
>  
> @@ -1894,6 +1906,81 @@ void ftrace_profile_free_filter(struct perf_event *event)
>  	__free_filter(filter);
>  }
>  
> +struct function_filter_data {
> +	struct ftrace_ops *ops;
> +	int first_filter;
> +	int first_notrace;
> +};
> +
> +static int __ftrace_function_set_filter(int filter, char *buf, int len,
> +					struct function_filter_data *data)
> +{
> +	int *reset;
> +
> +	reset = filter ? &data->first_filter : &data->first_notrace;
> +
> +	if (filter)
> +		ftrace_set_filter(data->ops, buf, len, *reset);
> +	else
> +		ftrace_set_notrace(data->ops, buf, len, *reset);
> +
> +	if (*reset)
> +		*reset = 0;
> +
> +	return WALK_PRED_DEFAULT;
> +}
> +
> +static int ftrace_function_check_pred(struct filter_pred *pred)
> +{
> +	struct ftrace_event_field *field = pred->field;
> +
> +	/*
> +	  Check the predicate for function trace, verify:
> +	   - only '==' and '!=' is used
> +	   - the 'ip' field is used
> +	*/
> +	if (WARN((pred->op != OP_EQ) && (pred->op != OP_NE),
> +		 "wrong operator for function filter: %d\n", pred->op))
> +		return -EINVAL;
> +
> +	if (strcmp(field->name, "ip"))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int ftrace_function_set_filter_cb(enum move_type move,
> +					 struct filter_pred *pred,
> +					 int *err, void *data)
> +{
> +	if ((move != MOVE_DOWN) ||
> +	    (pred->left != FILTER_PRED_INVALID))
> +		return WALK_PRED_DEFAULT;
> +
> +	/* Double checking the predicate is valid for function trace. */
> +	*err = ftrace_function_check_pred(pred);
> +	if (*err)
> +		return WALK_PRED_ABORT;
> +
> +	return __ftrace_function_set_filter(pred->op == OP_EQ,
> +					    pred->regex.pattern,
> +					    pred->regex.len,
> +					    data);
> +}
> +
> +static int ftrace_function_set_filter(struct perf_event *event,
> +				      struct event_filter *filter)
> +{
> +	struct function_filter_data data = {
> +		.first_filter  = 1,
> +		.first_notrace = 1,
> +		.ops           = &event->ftrace_ops,
> +	};
> +
> +	return walk_pred_tree(filter->preds, filter->root,
> +			      ftrace_function_set_filter_cb, &data);
> +}
> +
>  int ftrace_profile_set_filter(struct perf_event *event, int event_id,
>  			      char *filter_str)
>  {
> @@ -1901,6 +1988,7 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
>  	struct event_filter *filter;
>  	struct filter_parse_state *ps;
>  	struct ftrace_event_call *call;
> +	struct filter_op *fops = filter_ops;
>  
>  	mutex_lock(&event_mutex);
>  
> @@ -1925,14 +2013,21 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
>  	if (!ps)
>  		goto free_filter;
>  
> -	parse_init(ps, filter_ops, filter_str);
> +	if (ftrace_event_is_function(call))
> +		fops = filter_ftrace_ops;
> +
> +	parse_init(ps, fops, filter_str);
>  	err = filter_parse(ps);
>  	if (err)
>  		goto free_ps;
>  
>  	err = replace_preds(call, filter, ps, filter_str, false);
> -	if (!err)
> -		event->filter = filter;
> +	if (!err) {
> +		if (ftrace_event_is_function(call))
> +			err = ftrace_function_set_filter(event, filter);
> +		else
> +			event->filter = filter;
> +	}
>  
>  free_ps:
>  	filter_opstack_clear(ps);
> @@ -1940,7 +2035,7 @@ free_ps:
>  	kfree(ps);
>  
>  free_filter:
> -	if (err)
> +	if (err || ftrace_event_is_function(call))
>  		__free_filter(filter);
>  
>  out_unlock:
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index 7b035ab..46c35e2 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -208,4 +208,9 @@ struct ftrace_event_call __used event_##call = {			\
>  struct ftrace_event_call __used						\
>  __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
>  
> +int ftrace_event_is_function(struct ftrace_event_call *call)
> +{
> +	return call == &event_function;
> +}
> +
>  #include "trace_entries.h"


