Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0JEQDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:03:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50430 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab0JEQDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HUxFhPKv+K0d3S3aYSYFWd/AhUx9lRS+wb9qZ87zphgk05oWeQpnd7KvA9YssQES5S
         1r2KP9WxBgdhEczanDbNFNlLK15PxGNiIOcf/SUJFNb4OEhqevgawEpdey0qeno78Ery
         BU7ijm39YhSSYTBAagC7oJnrr1JDefYFu5bN4=
Date: Wed, 6 Oct 2010 01:03:32 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 04/10] memcg: disable local interrupts in
 lock_page_cgroup()
Message-ID: <20101005160332.GB9515@barrios-desktop>
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
 <1286175485-30643-5-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286175485-30643-5-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 03, 2010 at 11:57:59PM -0700, Greg Thelen wrote:
> If pages are being migrated from a memcg, then updates to that
> memcg's page statistics are protected by grabbing a bit spin lock
> using lock_page_cgroup().  In an upcoming commit memcg dirty page
> accounting will be updating memcg page accounting (specifically:
> num writeback pages) from softirq.  Avoid a deadlocking nested
> spin lock attempt by disabling interrupts on the local processor
> when grabbing the page_cgroup bit_spin_lock in lock_page_cgroup().
> This avoids the following deadlock:
> statistic
>       CPU 0             CPU 1
>                     inc_file_mapped
>                     rcu_read_lock
>   start move
>   synchronize_rcu
>                     lock_page_cgroup
>                       softirq
>                       test_clear_page_writeback
>                       mem_cgroup_dec_page_stat(NR_WRITEBACK)
>                       rcu_read_lock
>                       lock_page_cgroup   /* deadlock */
>                       unlock_page_cgroup
>                       rcu_read_unlock
>                     unlock_page_cgroup
>                     rcu_read_unlock
> 
> By disabling interrupts in lock_page_cgroup, nested calls
> are avoided.  The softirq would be delayed until after inc_file_mapped
> enables interrupts when calling unlock_page_cgroup().
> 
> The normal, fast path, of memcg page stat updates typically
> does not need to call lock_page_cgroup(), so this change does
> not affect the performance of the common case page accounting.
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  include/linux/page_cgroup.h |    8 +++++-
>  mm/memcontrol.c             |   51 +++++++++++++++++++++++++-----------------
>  2 files changed, 36 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index b59c298..872f6b1 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -117,14 +117,18 @@ static inline enum zone_type page_cgroup_zid(struct page_cgroup *pc)
>  	return page_zonenum(pc->page);
>  }
>  
> -static inline void lock_page_cgroup(struct page_cgroup *pc)
> +static inline void lock_page_cgroup(struct page_cgroup *pc,
> +				    unsigned long *flags)
>  {
> +	local_irq_save(*flags);
>  	bit_spin_lock(PCG_LOCK, &pc->flags);
>  }

Hmm. Let me ask questions. 

1. Why do you add new irq disable region in general function?
I think __do_fault is a one of fast path.

Could you disable softirq using _local_bh_disable_ not in general function 
but in your context?
How do you expect that how many users need irq lock to update page state?
If they don't need to disalbe irq?

We can pass some argument which present to need irq lock or not.
But it seems to make code very ugly. 

2. So could you solve the problem in your design?
I mean you could update page state out of softirq?
(I didn't look at the your patches all. Sorry if I am missing something)

3. Normally, we have updated page state without disable irq. 
Why does memcg need it?

I hope we don't add irq disable region as far as possbile. 

-- 
Kind regards,
Minchan Kim
