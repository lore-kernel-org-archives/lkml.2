Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab2AMQxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 11:53:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab2AMQxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 11:53:32 -0500
Date: Fri, 13 Jan 2012 14:53:15 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com
Subject: Re: [PATCH] perf: fix broken perf inject -b
Message-ID: <20120113165315.GA24387@infradead.org>
References: <20120113144731.GA5458@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113144731.GA5458@quad>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 13, 2012 at 03:47:31PM +0100, Stephane Eranian escreveu:
> 
> perf inject -b was broken. It would not inject any build_ids
> into the stream. Furthermore, it would strip samples from the
> stream.

Against which tree is this patch?
 
> The reason was a missing initialization of the event attribute
> structures. The perf_tool.tool.attr() callback was pointing to
> a simple repipe. But there was no initialization of internal data
> structures to keep track of events and event ids. That later caused
> event id lookups to fail, and samples would get dropped.
> 
> The patch simply adds back the call to perf_event__process_attr()
> to initialize the evlist structure. Build_ids are again injected.
> The PID is also inject for PERF_RECORD_HEADER_BUILD_ID.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> 
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index 09c1061..f38f370 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -60,6 +60,11 @@ static int perf_event__repipe_tracing_data_synth(union perf_event *event,
>  static int perf_event__repipe_attr(union perf_event *event,
>  				   struct perf_evlist **pevlist __used)
>  {
> +	int ret;
> +	ret = perf_event__process_attr(event, pevlist);
> +	if (ret)
> +		return ret;
> +
>  	return perf_event__repipe_synth(NULL, event, NULL);
>  }
>  
> @@ -173,6 +178,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
>  		       event->header.type);
>  		goto repipe;
>  	}
> +	machine->pid = event->ip.pid;
>  
>  	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
>  			      event->ip.ip, &al);
