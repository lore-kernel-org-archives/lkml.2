Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab1FATmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:42:05 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:37529 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339Ab1FATmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:42:03 -0400
Date: Wed, 1 Jun 2011 15:41:47 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:perf/urgent] perf: Fix SIGIO handling
In-Reply-To: <tip-2euus3f3x3dyvdk52cjxw8zu@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1106011516480.5384@cl320.eecs.utk.edu>
References: <tip-2euus3f3x3dyvdk52cjxw8zu@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 May 2011, tip-bot for Peter Zijlstra wrote:

> Commit-ID:  f506b3dc0ec454a16d40cab9ee5d75435b39dc50
> Gitweb:     http://git.kernel.org/tip/f506b3dc0ec454a16d40cab9ee5d75435b39dc50
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Thu, 26 May 2011 17:02:53 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 28 May 2011 17:04:59 +0200
> 
> perf: Fix SIGIO handling
> 
> Vince noticed that unless we mmap() a buffer, SIGIO gets lost. So
> explicitly push the wakeup (including signals) when requested.
> 
> Reported-by: Vince Weaver <vweaver1@eecs.utk.edu>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: <stable@kernel.org>
> Link: http://lkml.kernel.org/n/tip-2euus3f3x3dyvdk52cjxw8zu@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/events/core.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index c09767f..d863b3c 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5028,6 +5028,14 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
>  	else
>  		perf_event_output(event, nmi, data, regs);
>  
> +	if (event->fasync && event->pending_kill) {
> +		if (nmi) {
> +			event->pending_wakeup = 1;
> +			irq_work_queue(&event->pending);
> +		} else
> +			perf_event_wakeup(event);
> +	}
> +
>  	return ret;
>  }

there is something strange about this commit.  

With it I get many more overflows than expected (on the order of 40x more)
when I am using PERF_IOC_REFRESH,1 to restart the sampled counter
from the end of the signal handler.

Also if you use PERF_IOC_REFRESH with a value other than 1, the value
seems to be ignored and all of the counts are POLL_IN rather than
POLL_HUP as I'd expect.

Vince
