Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2FLSB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:01:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27932 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2FLSBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:01:55 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ag8JG7z7P3cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=57SyGIRnAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=xOx-NkpWTd6BDVzQWhAA:9 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339524114.13377.140.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/3] tools lib traceevent: Introduce pevent_strerror
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Tue, 12 Jun 2012 14:01:54 -0400
In-Reply-To: <1339486959-25241-4-git-send-email-namhyung@kernel.org>
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
	 <1339486959-25241-4-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 16:42 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The pevent_strerror() sets @buf to a string that describes the
> (libtraceevent-specific) error condition that is passed via @errnum.
> 
> This is similar to strerror_r() and does same thing if @errnum has a
> standard errno value.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/event-parse.c |   48 ++++++++++++++++++++++++++++++++++++
>  tools/lib/traceevent/event-parse.h |    2 ++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 866bdca4825d..3ed2d9362e69 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -4706,6 +4706,54 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
>  	return ret;
>  }
>  
> +/*
> + * This must have a same ordering as the enum pevent_errno.
> + */
> +static const char * const pevent_error_str[] = {
> +	"failed to allocate memory",
> +	"failed to parse event",
> +	"failed to read event id",
> +	"failed to read event format",
> +	"failed to read event print fmt",
> +	"failed to allocate field name for ftrace",
> +};
> +
> +int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
> +		    char *buf, size_t buflen)

Hmm, actually I wonder if we should put the error into the pevent
structure. Then we wouldn't even need to waste time to pass the data
through.

That is, you can simply do:

	ret = pevent_foo();
	if (ret < 0) {
		pevent_strerr(pevent, buf, buflen);
		printf("%s\n", buf);
	}

Perhaps even include a pevent_perror(), to just do:

	if (ret < 0) {
		pevent_perror(pevent);
		return ret;
	}

-- Steve

> +{
> +	int idx;
> +	const char *msg;
> +
> +	if (errnum >= 0) {
> +		strerror_r(errnum, buf, buflen);
> +		return 0;
> +	}
> +
> +	if (errnum <  __PEVENT_ERRNO__START ||
> +	    errnum >= __PEVENT_ERRNO__END)
> +		return -1;
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
> index 24b7649d530b..7e90aba20850 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -576,6 +576,8 @@ int pevent_data_pid(struct pevent *pevent, struct pevent_record *rec);
>  const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid);
>  void pevent_event_info(struct trace_seq *s, struct event_format *event,
>  		       struct pevent_record *record);
> +int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
> +		    char *buf, size_t buflen);
>  
>  struct event_format **pevent_list_events(struct pevent *pevent, enum event_sort_type);
>  struct format_field **pevent_event_common_fields(struct event_format *event);


