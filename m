Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1A0B5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:57:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386Ab1A0B5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:57:34 -0500
Date: Wed, 26 Jan 2011 17:57:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX v2] memcg: fix res_counter_read_u64 lock aware (Was Re:
 [PATCH] oom: handle overflow in mem_cgroup_out_of_memory()
Message-Id: <20110126175722.01b0db3a.akpm@linux-foundation.org>
In-Reply-To: <20110127104339.0f580bac.kamezawa.hiroyu@jp.fujitsu.com>
References: <1296030555-3594-1-git-send-email-gthelen@google.com>
	<20110126170713.GA2401@cmpxchg.org>
	<xr93y667lgdm.fsf@gthelen.mtv.corp.google.com>
	<20110126183023.GB2401@cmpxchg.org>
	<xr9362tbl83f.fsf@gthelen.mtv.corp.google.com>
	<20110126142909.0b710a0c.akpm@linux-foundation.org>
	<20110127092434.df18c7a6.kamezawa.hiroyu@jp.fujitsu.com>
	<20110127095342.3d81cf5f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110127104339.0f580bac.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 10:43:39 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> --- mmotm-0125.orig/kernel/res_counter.c
> +++ mmotm-0125/kernel/res_counter.c
> @@ -126,10 +126,24 @@ ssize_t res_counter_read(struct res_coun
>  			pos, buf, s - buf);
>  }
>  
> +#if BITS_PER_LONG == 32
> +u64 res_counter_read_u64(struct res_counter *counter, int member)
> +{
> +	unsigned long flags;
> +	u64 ret;
> +
> +	spin_lock_irqsave(&counter->lock, flags);
> +	ret = *res_counter_member(counter, member);
> +	spin_unlock_irqrestore(&counter->lock, flags);
> +
> +	return ret;
> +}
> +#else
>  u64 res_counter_read_u64(struct res_counter *counter, int member)
>  {
>  	return *res_counter_member(counter, member);
>  }
> +#endif

_irqsave is only needed if the lock will be taken from irq context. 
Does that happen?

