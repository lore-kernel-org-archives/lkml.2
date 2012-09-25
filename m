Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2IYEXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 00:23:30 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57334 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2IYEX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 00:23:29 -0400
X-AuditID: 9c930179-b7bfcae0000020b4-76-506131bf2520
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
Subject: Re: [PATCH 27/30] tools lib traceevent: Carve out events format parsing routine
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
	<1348502384-14442-28-git-send-email-acme@infradead.org>
Date: Tue, 25 Sep 2012 13:15:05 +0900
In-Reply-To: <1348502384-14442-28-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Mon, 24 Sep 2012 12:59:41 -0300")
Message-ID: <878vbyybzq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2012 12:59:41 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> The pevent_parse_event() routine will parse a events/sys/tp/format file
> and add an event_format instance to the pevent struct.
>
> This patch introduces a pevent_parse_format() routine with just the bits
> needed to parse the event/sys/tp/format file and just return the
> event_format instance, useful for when all we want is to parse the
> format file, without requiring the pevent struct.
[snip]
> +enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
> +				     unsigned long size, const char *sys)
> +{
> +	struct event_format *event = NULL;
> +	int ret = __pevent_parse_format(&event, pevent, buf, size, sys);
> +
> +	if (event == NULL)
> +		return ret;
> +
> +	/* Add pevent to event so that it can be referenced */
> +	event->pevent = pevent;
> +
> +	if (add_event(pevent, event))
> +		goto event_add_failed;

It seems we should set the 'ret' to a proper pevent_errno -
PEVENT_ERRNO__MEM_ALLOC_FAILED.


> +
> +#define PRINT_ARGS 0
> +	if (PRINT_ARGS && event->print_fmt.args)
> +		print_args(event->print_fmt.args);
> +
> +	return 0;
> +
> +event_add_failed:
> +	free(event->system);
> +	free(event->name);
> +	free(event);

At this point, the 'event' also has fields and format information and
they all need to be freed.  Looks like calling pevent_free_format()
would be the right thing IMHO.

Thanks,
Namhyung

>  	return ret;
>  }
