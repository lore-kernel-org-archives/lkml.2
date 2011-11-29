Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1K2KPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:15:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab1K2KPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:15:05 -0500
Date: Tue, 29 Nov 2011 11:14:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 8/9] ftrace, perf: Add FILTER_TRACE_FN event field type
Message-ID: <20111129101454.GC1602@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1322417074-5834-9-git-send-email-jolsa@redhat.com>
 <1322510483.17003.16.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322510483.17003.16.camel@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 03:01:23PM -0500, Steven Rostedt wrote:
> BTW, Please Cc Peter Zijlstra too, as he maintains perf inside the
> kernel.
> 
> On Sun, 2011-11-27 at 19:04 +0100, Jiri Olsa wrote:
> > Adding FILTER_TRACE_FN event field type for function tracepoint
> > event, so it can be properly recognized within filtering code.
> 
> -ECHANGELOGTOOSHORT
> 
> I'm not sure what this is for.

need a way to distinguish fucntion trace field for the next patch,
I'll make this more fit or do it some other way.. ;)

thanks,
jirka

> 
> -- Steve
> 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  include/linux/ftrace_event.h       |    1 +
> >  kernel/trace/trace_events_filter.c |    7 ++++++-
> >  kernel/trace/trace_export.c        |   25 ++++++++++++++++++++-----
> >  3 files changed, 27 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> > index 2bf677c..dd478fc 100644
> > --- a/include/linux/ftrace_event.h
> > +++ b/include/linux/ftrace_event.h
> > @@ -245,6 +245,7 @@ enum {
> >  	FILTER_STATIC_STRING,
> >  	FILTER_DYN_STRING,
> >  	FILTER_PTR_STRING,
> > +	FILTER_TRACE_FN,
> >  };
> >  
> >  #define EVENT_STORAGE_SIZE 128
> > diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> > index fdc6d22..7b0b04c 100644
> > --- a/kernel/trace/trace_events_filter.c
> > +++ b/kernel/trace/trace_events_filter.c
> > @@ -900,6 +900,11 @@ int filter_assign_type(const char *type)
> >  	return FILTER_OTHER;
> >  }
> >  
> > +static bool is_function_field(struct ftrace_event_field *field)
> > +{
> > +	return field->filter_type == FILTER_TRACE_FN;
> > +}
> > +
> >  static bool is_string_field(struct ftrace_event_field *field)
> >  {
> >  	return field->filter_type == FILTER_DYN_STRING ||
> > @@ -987,7 +992,7 @@ static int init_pred(struct filter_parse_state *ps,
> >  			fn = filter_pred_strloc;
> >  		else
> >  			fn = filter_pred_pchar;
> > -	} else {
> > +	} else if (!is_function_field(field)) {
> >  		if (field->is_signed)
> >  			ret = strict_strtoll(pred->regex.pattern, 0, &val);
> >  		else
> > diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> > index 62e86a5..7b035ab 100644
> > --- a/kernel/trace/trace_export.c
> > +++ b/kernel/trace/trace_export.c
> > @@ -67,7 +67,7 @@ static void __always_unused ____ftrace_check_##name(void)	\
> >  	ret = trace_define_field(event_call, #type, #item,		\
> >  				 offsetof(typeof(field), item),		\
> >  				 sizeof(field.item),			\
> > -				 is_signed_type(type), FILTER_OTHER);	\
> > +				 is_signed_type(type), filter_type);	\
> >  	if (ret)							\
> >  		return ret;
> >  
> > @@ -77,7 +77,7 @@ static void __always_unused ____ftrace_check_##name(void)	\
> >  				 offsetof(typeof(field),		\
> >  					  container.item),		\
> >  				 sizeof(field.container.item),		\
> > -				 is_signed_type(type), FILTER_OTHER);	\
> > +				 is_signed_type(type), filter_type);	\
> >  	if (ret)							\
> >  		return ret;
> >  
> > @@ -91,7 +91,7 @@ static void __always_unused ____ftrace_check_##name(void)	\
> >  		ret = trace_define_field(event_call, event_storage, #item, \
> >  				 offsetof(typeof(field), item),		\
> >  				 sizeof(field.item),			\
> > -				 is_signed_type(type), FILTER_OTHER);	\
> > +				 is_signed_type(type), filter_type);	\
> >  		mutex_unlock(&event_storage_mutex);			\
> >  		if (ret)						\
> >  			return ret;					\
> > @@ -104,7 +104,7 @@ static void __always_unused ____ftrace_check_##name(void)	\
> >  				 offsetof(typeof(field),		\
> >  					  container.item),		\
> >  				 sizeof(field.container.item),		\
> > -				 is_signed_type(type), FILTER_OTHER);	\
> > +				 is_signed_type(type), filter_type);	\
> >  	if (ret)							\
> >  		return ret;
> >  
> > @@ -112,10 +112,24 @@ static void __always_unused ____ftrace_check_##name(void)	\
> >  #define __dynamic_array(type, item)					\
> >  	ret = trace_define_field(event_call, #type, #item,		\
> >  				 offsetof(typeof(field), item),		\
> > -				 0, is_signed_type(type), FILTER_OTHER);\
> > +				 0, is_signed_type(type), filter_type);\
> >  	if (ret)							\
> >  		return ret;
> >  
> > +#define FILTER_TYPE_TRACE_FN           FILTER_TRACE_FN
> > +#define FILTER_TYPE_TRACE_GRAPH_ENT    FILTER_OTHER
> > +#define FILTER_TYPE_TRACE_GRAPH_RET    FILTER_OTHER
> > +#define FILTER_TYPE_TRACE_CTX          FILTER_OTHER
> > +#define FILTER_TYPE_TRACE_WAKE         FILTER_OTHER
> > +#define FILTER_TYPE_TRACE_STACK                FILTER_OTHER
> > +#define FILTER_TYPE_TRACE_USER_STACK   FILTER_OTHER
> > +#define FILTER_TYPE_TRACE_BPRINT       FILTER_OTHER
> > +#define FILTER_TYPE_TRACE_PRINT                FILTER_OTHER
> > +#define FILTER_TYPE_TRACE_MMIO_RW      FILTER_OTHER
> > +#define FILTER_TYPE_TRACE_MMIO_MAP     FILTER_OTHER
> > +#define FILTER_TYPE_TRACE_BRANCH       FILTER_OTHER
> > +#define FILTER_TYPE(arg)               FILTER_TYPE_##arg
> > +
> >  #undef FTRACE_ENTRY
> >  #define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\
> >  int									\
> > @@ -123,6 +137,7 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
> >  {									\
> >  	struct struct_name field;					\
> >  	int ret;							\
> > +	int filter_type = FILTER_TYPE(id);				\
> >  									\
> >  	tstruct;							\
> >  									\
> 
> 
