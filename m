Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab0JQF42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 01:56:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54984 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab0JQF41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 01:56:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JuEQJgUrheVtzj5eMF777EDarxeg73Q4zxqsulHKgIzeCjSPS/lJfKfZtAdq1uuYiD
         19Aitmg/15WPZQRLnW8eDljTnMnU0ZHSNs38DEOEMHF9Gk2J+2IlJ14XKblUs0ZlAVcc
         Aww2u+1IVdIV161XFQgx6N34f7u4ahIi6G9Sg=
MIME-Version: 1.0
In-Reply-To: <1287177279-30876-5-git-send-email-gthelen@google.com>
References: <1287177279-30876-1-git-send-email-gthelen@google.com>
	<1287177279-30876-5-git-send-email-gthelen@google.com>
Date: Sun, 17 Oct 2010 14:56:20 +0900
Message-ID: <AANLkTimosH8egHCY1BJ_8DisweJDm1VwxXJ=sGzxUJJe@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] memcg: disable softirq in lock_page_cgroup()
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 6:14 AM, Greg Thelen <gthelen@google.com> wrote:
> If pages are being migrated from a memcg, then updates to that
> memcg's page statistics are protected by grabbing a bit spin lock
> using lock_page_cgroup().  In an upcoming commit memcg dirty page
> accounting will be updating memcg page accounting (specifically:
> num writeback pages) from softirq.  Avoid a deadlocking nested
> spin lock attempt by disabling softirq on the local processor
> when grabbing the page_cgroup bit_spin_lock in lock_page_cgroup().
> This avoids the following deadlock:
> statistic
>      CPU 0             CPU 1
>                    inc_file_mapped
>                    rcu_read_lock
>  start move
>  synchronize_rcu
>                    lock_page_cgroup
>                      softirq
>                      test_clear_page_writeback
>                      mem_cgroup_dec_page_stat(NR_WRITEBACK)
>                      rcu_read_lock
>                      lock_page_cgroup   /* deadlock */
>                      unlock_page_cgroup
>                      rcu_read_unlock
>                    unlock_page_cgroup
>                    rcu_read_unlock
>
> By disabling softirq in lock_page_cgroup, nested calls are avoided.
> The softirq would be delayed until after inc_file_mapped enables
> softirq when calling unlock_page_cgroup().
>
> The normal, fast path, of memcg page stat updates typically
> does not need to call lock_page_cgroup(), so this change does
> not affect the performance of the common case page accounting.
>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  include/linux/page_cgroup.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index b59c298..0585546 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -3,6 +3,8 @@
>
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
>  #include <linux/bit_spinlock.h>
> +#include <linux/hardirq.h>
> +
>  /*
>  * Page Cgroup can be considered as an extended mem_map.
>  * A page_cgroup page is associated with every page descriptor. The
> @@ -119,12 +121,16 @@ static inline enum zone_type page_cgroup_zid(struct page_cgroup *pc)
>
>  static inline void lock_page_cgroup(struct page_cgroup *pc)
>  {
> +       /* This routine is only deadlock safe from softirq or lower. */
> +       VM_BUG_ON(in_irq());
> +       local_bh_disable();
>        bit_spin_lock(PCG_LOCK, &pc->flags);
>  }
>
>  static inline void unlock_page_cgroup(struct page_cgroup *pc)
>  {
>        bit_spin_unlock(PCG_LOCK, &pc->flags);
> +       local_bh_enable();
>  }
>
>  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
> --
> 1.7.1
>
>

Please, see recent Kame's patch.
http://lkml.org/lkml/2010/10/15/54

-- 
Kind regards,
Minchan Kim
