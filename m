Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0EQLqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:46:08 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38262 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab0EQLqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jdDIF26ds5IrLy8yeDOZwYzAmBHa7obyaHgd5TqPneG7moBBzdsdLhRfTC32zpxmB9
         rWjMcLB3Lh6wQHCussiCJw523bvWbW51R/YTgHB8eQAmmnwmW83bjoBfQHg/qo2SQPyN
         gyDhbirz1uyrBvUBXqJvCib/9tFVzxNdgtbnE=
Date: Mon, 17 May 2010 13:46:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, acme@infradead.org,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf_events: fix errors path in perf_output_begin()
Message-ID: <20100517114605.GB5291@nowhere>
References: <4bf11ea4.dd29e30a.026d.4627@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bf11ea4.dd29e30a.026d.4627@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 12:46:01PM +0200, Stephane Eranian wrote:
>   In case the sampling buffer has no "payload" pages, nr_pages is 0.
>   The problem is that the error path in perf_output_begin() skips to
>   a label which assumes perf_output_lock() has been issued which is
>   not the case. That triggers a WARN_ON() is perf_output_unlock().
> 
>   This patch fixes the problem by adding a new label and skipping
>   perf_task_unlock() in case data->nr_pages is 0. 
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



Oh indeed, handle->lock is in a random state.
Whatever its value we have an unbalanced put_cpu()
anyway.

And we don't race with someone else, data->lock = -1
and will then warn.

I just have a tiny doubt: should we really count this
path to the lost events? I'm not sure when we can have
data->nr_pages == 0, does this happen if we mmap after
enabling the event?

All I know is that I observed I already lost events in
this path using perf lock.

