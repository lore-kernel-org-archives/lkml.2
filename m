Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0HYSZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 14:25:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab0HYSZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 14:25:20 -0400
Date: Wed, 25 Aug 2010 20:22:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: [RFC V2 PATCH 3/3] timer: warn when del_timer_sync() used in
	hardirq context
Message-ID: <20100825182204.GB22671@redhat.com>
References: <1282743959-5427-1-git-send-email-yong.zhang0@gmail.com> <1282743959-5427-4-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282743959-5427-4-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Yong Zhang wrote:
>
> From: Yong Zhang <yong.zhang@windriver.com>
>
> Add explict warning to prevent del_timer_sync() from using
> in hardirq context.

Agreed, del_timer_sync() from softirq should be OK.

> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/timer.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 08c9559..1bc4b4a 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -996,7 +996,11 @@ int del_timer_sync(struct timer_list *timer)
>  	lock_map_release(&timer->lockdep_map);
>  	local_bh_enable();
>  #endif
> -
> +	/*
> +	 * don't use it in hardirq context, because it
> +	 * could lead to deadlock.
> +	 */
> +	WARN_ON(in_irq());
>  	for (;;) {
>  		int ret = try_to_del_timer_sync(timer);
>  		if (ret >= 0)
> -- 
> 1.7.0.4
> 

