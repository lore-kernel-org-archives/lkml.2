Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0EQLGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:06:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab0EQLGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:06:10 -0400
Date: Mon, 17 May 2010 13:04:57 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Stephane Eranian <eranian@google.com>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf_events: fix errors path in perf_output_begin()
In-Reply-To: <4bf11ea4.dd29e30a.026d.4627@mx.google.com>
Message-ID: <alpine.LFD.2.00.1005171303260.21420@localhost.localdomain>
References: <4bf11ea4.dd29e30a.026d.4627@mx.google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 May 2010, Stephane Eranian wrote:

>   In case the sampling buffer has no "payload" pages, nr_pages is 0.
>   The problem is that the error path in perf_output_begin() skips to
>   a label which assumes perf_output_lock() has been issued which is
>   not the case. That triggers a WARN_ON() is perf_output_unlock().
> 
>   This patch fixes the problem by adding a new label and skipping
>   perf_task_unlock() in case data->nr_pages is 0. 

It does? Your code looks good to me, but the description above is
a little flawed, since no new label is added.

Thanks

> 
>   Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> --
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index a4fa381..95137b6 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -3035,8 +3035,10 @@ int perf_output_begin(struct perf_output_handle *handle,
>  	handle->nmi	= nmi;
>  	handle->sample	= sample;
>  
> -	if (!data->nr_pages)
> -		goto fail;
> +	if (!data->nr_pages) {
> +		atomic_inc(&data->lost);
> +		goto out;
> +	}
>  
>  	have_lost = atomic_read(&data->lost);
>  	if (have_lost)
> --
