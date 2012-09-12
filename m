Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab2ILBq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:46:57 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44728 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2ILBq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:46:56 -0400
X-AuditID: 9c93016f-b7bffae000003557-f6-504fe98cbfce
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 16/18] perf evsel: Introduce perf_evsel__{str,int}val methods
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
	<1347407590-30960-17-git-send-email-acme@infradead.org>
Date: Wed, 12 Sep 2012 10:40:00 +0900
In-Reply-To: <1347407590-30960-17-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Tue, 11 Sep 2012 20:53:08 -0300")
Message-ID: <87oblc9fyn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012 20:53:08 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> Wrappers to the libtraceevent routines, so that we can further reduce
> the surface contact perf builtins have with it.
[snip]
> +char *perf_evsel__strval(struct perf_evsel *evsel, struct perf_sample *sample,
> +			 const char *name)
> +{
> +	struct format_field *field = pevent_find_field(evsel->tp_format, name);
> +	int offset;
> +
> +        if (!field)
> +                return NULL;

Whitespace problem?

Btw, as a generic wrapper shouldn't it handle common fields also?  If
you care about performance, how about switching the order of finding
fields in question, i.e.:

	struct format_field *field = pevent_find_field(evsel->tp_format, name);

	if (!field) {
		field = pevent_find_common_field(evsel->tp_format, name);
		if (!field)
			return NULL;
	}

> +
> +	offset = field->offset;
> +
> +	if (field->flags & FIELD_IS_DYNAMIC) {
> +		offset = *(int *)(sample->raw_data + field->offset);
> +		offset &= 0xffff;
> +	}
> +
> +	return sample->raw_data + offset;
> +}
> +
> +u64 perf_evsel__intval(struct perf_evsel *evsel, struct perf_sample *sample,
> +		       const char *name)
> +{
> +	struct format_field *field = pevent_find_field(evsel->tp_format, name);
> +	u64 val;
> +
> +        if (!field)
> +                return 0;

Ditto.

Thanks,
Namhyung

> +
> +	val = pevent_read_number(evsel->tp_format->pevent,
> +				 sample->raw_data + field->offset, field->size);
> +	return val;
> +
> +}
