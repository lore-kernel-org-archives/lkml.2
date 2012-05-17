Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030294Ab2EQPrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:47:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab2EQPri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:47:38 -0400
Date: Thu, 17 May 2012 12:47:26 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, robert.richter@amd.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perf script/python: Pass thread/dso name and symbol
 info to event handler in python
Message-ID: <20120517154726.GC2636@infradead.org>
References: <1337173155-25780-1-git-send-email-feng.tang@intel.com>
 <1337173155-25780-3-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337173155-25780-3-git-send-email-feng.tang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 16, 2012 at 08:59:15PM +0800, Feng Tang escreveu:
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  .../util/scripting-engines/trace-event-python.c    |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index a202881..c96f5e2 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -336,6 +336,7 @@ static void python_process_general_event(union perf_event *pevent __unused,
>  	static char handler_name[64];
>  	unsigned n = 0;
>  	void *data = sample->raw_data;
> +	struct thread *thread = al->thread;
>  
>  	t = PyTuple_New(MAX_FIELDS);
>  	if (!t)
> @@ -348,13 +349,21 @@ static void python_process_general_event(union perf_event *pevent __unused,
>  		goto exit;
>  	}
>  
> -	/* Pass 3 parameters: event_attr, perf_sample, raw data, thread name */
> +	/* Pass parameters: attr, perf_sample, raw data, thread and dso name */
>  	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
>  			(const char *)&evsel->attr, sizeof(evsel->attr)));
>  	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
>  			(const char *)sample, sizeof(*sample)));
>  	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
>  			data, sample->raw_size));
> +	PyTuple_SetItem(t, n++, PyString_FromString(thread->comm));
> +	PyTuple_SetItem(t, n++, PyString_FromString(al->map->dso->name));
> +
> +	/* Pass the resolved symbol if there is, othersize pass "Unkown" */
> +	if (al->sym)
> +		PyTuple_SetItem(t, n++, PyString_FromString(al->sym->name));
> +	else
> +		PyTuple_SetItem(t, n++, PyString_FromString("Unknown"));

Isn't this getting a little bit convoluted?

I.e. python has dictionaries, perhaps we could pass a dict instead of a
tuple, in that case we would simply not add the "symbol" key.

>  	if (_PyTuple_Resize(&t, n) == -1)
>  		Py_FatalError("error resizing Python tuple");
> -- 
> 1.7.1
