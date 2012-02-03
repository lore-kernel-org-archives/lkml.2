Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2BCOQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:16:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51547 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab2BCOQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:16:43 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=DRUHs_wQD4QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=NkJcUYbgp_8H0TUyWG8A:9 a=GlmRKowBsIVsifts_QQA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328278601.5882.150.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 6/7] ftrace, perf: Distinguish ftrace function event
 field type
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Fri, 03 Feb 2012 09:16:41 -0500
In-Reply-To: <1327776209-4883-7-git-send-email-jolsa@redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-7-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-28 at 19:43 +0100, Jiri Olsa wrote:
>  
> +#define FILTER_TYPE_TRACE_FN           FILTER_TRACE_FN
> +#define FILTER_TYPE_TRACE_GRAPH_ENT    FILTER_OTHER
> +#define FILTER_TYPE_TRACE_GRAPH_RET    FILTER_OTHER
> +#define FILTER_TYPE_TRACE_CTX          FILTER_OTHER
> +#define FILTER_TYPE_TRACE_WAKE         FILTER_OTHER
> +#define FILTER_TYPE_TRACE_STACK                FILTER_OTHER
> +#define FILTER_TYPE_TRACE_USER_STACK   FILTER_OTHER
> +#define FILTER_TYPE_TRACE_BPRINT       FILTER_OTHER
> +#define FILTER_TYPE_TRACE_PRINT                FILTER_OTHER
> +#define FILTER_TYPE_TRACE_MMIO_RW      FILTER_OTHER
> +#define FILTER_TYPE_TRACE_MMIO_MAP     FILTER_OTHER
> +#define FILTER_TYPE_TRACE_BRANCH       FILTER_OTHER
> +#define FILTER_TYPE(arg)               FILTER_TYPE_##arg
> +
>  #undef FTRACE_ENTRY
>  #define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\

If all FTRACE_ENTRY needs a filter defined (as you did with the #defines
above), then we should just add a FILTER field to FTRACE_ENTRY(). The
defines are just ugly, and will be a pain if we ever add or remove a
type. If we remove a type, we'll probably forget to remove the define
for it.

#define FTRACE_ENTRY(name, struct_name, id, tstruct, print, filter)

	int filter_type = filter;

And then the trace entries can have the type of filter.

	F_STRUCT(
		...
	),

	FILTER_OTHER

That would be much cleaner.

-- Steve

>  int									\
> @@ -123,6 +137,7 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
>  {									\
>  	struct struct_name field;					\
>  	int ret;							\
> +	int filter_type = FILTER_TYPE(id);				\
>  									\
>  	tstruct;							\
>  									\


