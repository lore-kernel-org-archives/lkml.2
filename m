Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2IYEfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 00:35:12 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47142 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2IYEfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 00:35:10 -0400
X-AuditID: 9c930179-b7bfcae0000020b4-ee-5061347caaa4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 28/30] perf evsel: Provide a new constructor for tracepoints
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
	<1348502384-14442-29-git-send-email-acme@infradead.org>
Date: Tue, 25 Sep 2012 13:26:46 +0900
In-Reply-To: <1348502384-14442-29-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Mon, 24 Sep 2012 12:59:42 -0300")
Message-ID: <874nmmybg9.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2012 12:59:42 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> The existing constructor receives a perf_event_attr filled with the
> event type and the config.
>
> To reduce the boilerplate for tracepoints, provide a new constructor,
> perf_evsel__newtp() that receives the tracepoint name and will open
> the debugfs file, call into libtraceevent new pevent_parse_format file
> to fill its ->tp_format member, so that users can then just call
> perf_evsel__field() to access its fields.
[snip]
> +static struct event_format *event_format__new(const char *sys, const char *name)
> +{
> +	int fd, n;
> +	char *filename;
> +	void *bf = NULL, *nbf;
> +	size_t size = 0, alloc_size = 0;
> +	struct event_format *format = NULL;
> +
> +	if (asprintf(&filename, "%s/%s/%s/format", tracing_events_path, sys, name) < 0)
> +		goto out;
> +
> +	fd = open(filename, O_RDONLY);
> +	if (fd < 0)
> +		goto out_free_filename;
> +
> +	do {
> +		if (size == alloc_size) {
> +			alloc_size += BUFSIZ;
> +			nbf = realloc(bf, alloc_size);
> +			if (nbf == NULL)
> +				goto out_free_bf;
> +			bf = nbf;
> +		}
> +
> +		n = read(fd, bf + size, BUFSIZ);

Wouldn't it be better doing s/BUFSIZ/alloc_size - size/ ?  Although
there'll be no partial reading issue when working on debugfs I guess.

Thanks,
Namhyung


> +		if (n < 0)
> +			goto out_free_bf;
> +		size += n;
> +	} while (n > 0);
> +
> +	pevent_parse_format(&format, bf, size, sys);
> +
> +out_free_bf:
> +	free(bf);
> +	close(fd);
> +out_free_filename:
> +	free(filename);
> +out:
> +	return format;
> +}
