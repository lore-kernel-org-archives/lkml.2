Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0KIXWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:22:47 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56739 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab0KIXWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:22:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BhOQBLBwjunYZDFYpSMeQkCZWtzKt5SjNUQR1/K/23iZHLDn+FbUCI60gtCLgyL7JB
         gCFlAMyOOimiYIFWzek2Ge+/OZcwCxveuEF25pOTqeGcFWpsFE2wYUyvis4svHAIo5rd
         XhcRgBwxkA6qIodQCwpOnGCZgntNDqfqk6WD8=
MIME-Version: 1.0
In-Reply-To: <1289294671-6865-4-git-send-email-gthelen@google.com>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-4-git-send-email-gthelen@google.com>
Date: Wed, 10 Nov 2010 08:22:44 +0900
Message-ID: <AANLkTinX9FSC=9azJWH7LELvLs2jYjOYUeQe4KhD_th=@mail.gmail.com>
Subject: Re: [PATCH 3/6] memcg: make throttle_vm_writeout() memcg aware
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 6:24 PM, Greg Thelen <gthelen@google.com> wrote:
> If called with a mem_cgroup, then throttle_vm_writeout() should
> query the given cgroup for its dirty memory usage limits.
>
> dirty_writeback_pages() is no longer used, so delete it.
>
> Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

> ---
>  include/linux/writeback.h |    2 +-
>  mm/page-writeback.c       |   31 ++++++++++++++++---------------
>  mm/vmscan.c               |    2 +-
>  3 files changed, 18 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index 335dba1..1bacdda 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -97,7 +97,7 @@ void laptop_mode_timer_fn(unsigned long data);
>  #else
>  static inline void laptop_sync_completion(void) { }
>  #endif
> -void throttle_vm_writeout(gfp_t gfp_mask);
> +void throttle_vm_writeout(gfp_t gfp_mask, struct mem_cgroup *mem_cgroup);
>
>  /* These are exported to sysctl. */
>  extern int dirty_background_ratio;
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index d717fa9..bf85062 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -131,18 +131,6 @@ EXPORT_SYMBOL(laptop_mode);
>  static struct prop_descriptor vm_completions;
>  static struct prop_descriptor vm_dirties;
>
> -static unsigned long dirty_writeback_pages(void)
> -{
> -       unsigned long ret;
> -
> -       ret = mem_cgroup_page_stat(NULL, MEMCG_NR_DIRTY_WRITEBACK_PAGES);
> -       if ((long)ret < 0)
> -               ret = global_page_state(NR_UNSTABLE_NFS) +
> -                       global_page_state(NR_WRITEBACK);
> -
> -       return ret;
> -}
> -

Nice cleanup.

>  /*
>  * couple the period to the dirty_ratio:
>  *
> @@ -703,12 +691,25 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
>
> -void throttle_vm_writeout(gfp_t gfp_mask)
> +/*
> + * Throttle the current task if it is near dirty memory usage limits.
> + * If @mem_cgroup is NULL or the root_cgroup, then use global dirty memory
> + * information; otherwise use the per-memcg dirty limits.
> + */
> +void throttle_vm_writeout(gfp_t gfp_mask, struct mem_cgroup *mem_cgroup)
>  {
>        struct dirty_info dirty_info;
> +       unsigned long nr_writeback;
>
>         for ( ; ; ) {
> -               global_dirty_info(&dirty_info);
> +               if (!mem_cgroup || !memcg_dirty_info(mem_cgroup, &dirty_info)) {
> +                       global_dirty_info(&dirty_info);
> +                       nr_writeback = global_page_state(NR_UNSTABLE_NFS) +
> +                               global_page_state(NR_WRITEBACK);
> +               } else {
> +                       nr_writeback = mem_cgroup_page_stat(
> +                               mem_cgroup, MEMCG_NR_DIRTY_WRITEBACK_PAGES);

In point of view rcu_read_lock removal, memcg can't destroy due to
mem_cgroup_select_victim's css_tryget?
Then, we can remove unnecessary rcu_read_lock in mem_cgroup_page_stat.



-- 
Kind regards,
Minchan Kim
