Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2B0KdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:33:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:58327 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2B0KdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:33:21 -0500
Message-ID: <1330338785.11248.49.camel@twins>
Subject: Re: [PATCH] hw breakpoint: Fix possible memory leak
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 27 Feb 2012 11:33:05 +0100
In-Reply-To: <1330311739-24302-1-git-send-email-namhyung.kim@lge.com>
References: <1330311739-24302-1-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 12:02 +0900, Namhyung Kim wrote:
> If kzalloc() for TYPE_DATA failed on a given cpu, previous chunk
> will be leaked. Fix it.

so why not fix the error loop? wouldn't putting that err_cpu == cpu
break after the kfree sort it?

> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  kernel/events/hw_breakpoint.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> index b0309f76d777..58298b0d0e92 100644
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -645,8 +645,12 @@ int __init init_hw_breakpoint(void)
>  			task_bp_pinned = &per_cpu(nr_task_bp_pinned[i], cpu);
>  			*task_bp_pinned = kzalloc(sizeof(int) * nr_slots[i],
>  						  GFP_KERNEL);
> -			if (!*task_bp_pinned)
> +			if (!*task_bp_pinned) {
> +				while (--i >= 0)
> +					kfree(per_cpu(nr_task_bp_pinned[i],
> +						      cpu));
>  				goto err_alloc;
> +			}
>  		}
>  	}
>  

