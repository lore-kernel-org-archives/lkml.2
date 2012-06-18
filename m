Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2FRNlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:41:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2FRNlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:41:07 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=hLebNBF7oocA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=TgFeZDeRXF0FsDkMJO0A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340026865.25903.86.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v2 4/5] tools lib traceevent: Introduce pevent_strerror
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Mon, 18 Jun 2012 09:41:05 -0400
In-Reply-To: <1339987851-22491-4-git-send-email-namhyung@kernel.org>
References: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
	 <1339987851-22491-4-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 11:50 +0900, Namhyung Kim wrote:

> +	if (errnum <= __PEVENT_ERRNO__START ||
> +	    errnum >= __PEVENT_ERRNO__END)
> +		return -1;

OK, so you changed it to have both START and END be exclusive in the
range. No more 'MEM_ALLOC_FAILED = START'.

> +
> +	idx = errnum - __PEVENT_ERRNO__START;
> +	msg = pevent_error_str[idx];
> +
> +	switch (errnum) {
> +	case PEVENT_ERRNO__MEM_ALLOC_FAILED:
> +	case PEVENT_ERRNO__PARSE_EVENT_FAILED:
> +	case PEVENT_ERRNO__READ_ID_FAILED:
> +	case PEVENT_ERRNO__READ_FORMAT_FAILED:
> +	case PEVENT_ERRNO__READ_PRINT_FAILED:
> +	case PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED:
> +		snprintf(buf, buflen, "%s", msg);
> +		break;
> +
> +	default:
> +		/* cannot reach here */
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
>  int get_field_val(struct trace_seq *s, struct format_field *field,
>  		  const char *name, struct pevent_record *record,
>  		  unsigned long long *val, int err)
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 24b7649d530b..a8121d78a046 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -338,6 +338,16 @@ enum pevent_flag {
>  	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
>  };
>  
> +#define PEVENT_ERRORS 							      \
> +	_PE(MEM_ALLOC_FAILED,	"failed to allocate memory"),		      \
> +	_PE(PARSE_EVENT_FAILED,	"failed to parse event"),		      \
> +	_PE(READ_ID_FAILED,	"failed to read event id"),		      \
> +	_PE(READ_FORMAT_FAILED,	"failed to read event format"),		      \
> +	_PE(READ_PRINT_FAILED,	"failed to read event print fmt"), 	      \
> +	_PE(OLD_FTRACE_ARG_FAILED,"failed to allocate field name for ftrace")
> +
> +#undef _PE
> +#define _PE(__code, __str) PEVENT_ERRNO__ ## __code
>  enum pevent_errno {
>  	PEVENT_ERRNO__SUCCESS			= 0,
>  
> @@ -350,15 +360,11 @@ enum pevent_errno {
>  	 */
>  	__PEVENT_ERRNO__START			= -100000,
>  
> -	PEVENT_ERRNO__MEM_ALLOC_FAILED		= __PEVENT_ERRNO__START,
> -	PEVENT_ERRNO__PARSE_EVENT_FAILED,
> -	PEVENT_ERRNO__READ_ID_FAILED,
> -	PEVENT_ERRNO__READ_FORMAT_FAILED,
> -	PEVENT_ERRNO__READ_PRINT_FAILED,
> -	PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED,
> +	PEVENT_ERRORS,
>  

Looks good.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  	__PEVENT_ERRNO__END,
>  };
> +#undef _PE
>  
>  struct cmdline;
>  struct cmdline_list;
> @@ -576,6 +582,8 @@ int pevent_data_pid(struct pevent *pevent, struct pevent_record *rec);
>  const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid);
>  void pevent_event_info(struct trace_seq *s, struct event_format *event,
>  		       struct pevent_record *record);
> +int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
> +		    char *buf, size_t buflen);
>  
>  struct event_format **pevent_list_events(struct pevent *pevent, enum event_sort_type);
>  struct format_field **pevent_event_common_fields(struct event_format *event);


