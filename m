Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761069Ab2EIUhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:37:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56934 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2EIUhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:37:13 -0400
Date: Wed, 9 May 2012 13:36:54 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: paulmck@linux.vnet.ibm.com, Sasha Levin <levinsasha928@gmail.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, yinghan@google.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: rcu: BUG on exit_group
In-Reply-To: <4FA9F9CF.8050706@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1205091319080.20983@eggly.anvils>
References: <CA+1xoqd_z8Zavzraq1oXVRpwkJRoac57tojBYf7x=Kzs+cbJ_w@mail.gmail.com> <20120503154140.GA2592@linux.vnet.ibm.com> <CA+1xoqepggR4YRzDXFz=Hk9EeXACMRyeXorQm7rE3r5MQyY6Fw@mail.gmail.com> <20120503170101.GF2592@linux.vnet.ibm.com>
 <CA+1xoqcXMVG0J4r8XhtzcxxDqLuyR30x5a3o8BsrBqDakDdHgg@mail.gmail.com> <20120504053331.GA16836@linux.vnet.ibm.com> <4FA9F9CF.8050706@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, KAMEZAWA Hiroyuki wrote:
> [PATCH] memcg: fix taking mutex under rcu at munlock
> 
> Following bug was reported because mutex is held under rcu_read_lock().
> 
> [   83.820976] BUG: sleeping function called from invalid context at
> kernel/mutex.c:269
> [   83.827870] in_atomic(): 0, irqs_disabled(): 0, pid: 4506, name: trinity
> [   83.832154] 1 lock held by trinity/4506:
> [   83.834224]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff811a7d87>]
> munlock_vma_page+0x197/0x200
> [   83.839310] Pid: 4506, comm: trinity Tainted: G        W
> 3.4.0-rc5-next-20120503-sasha-00002-g09f55ae-dirty #108
> [   83.849418] Call Trace:
> [   83.851182]  [<ffffffff810e7218>] __might_sleep+0x1f8/0x210
> [   83.854076]  [<ffffffff82d9540a>] mutex_lock_nested+0x2a/0x50
> [   83.857120]  [<ffffffff811b0830>] try_to_unmap_file+0x40/0x2f0
> [   83.860242]  [<ffffffff82d984bb>] ? _raw_spin_unlock_irq+0x2b/0x80
> [   83.863423]  [<ffffffff810e7ffe>] ? sub_preempt_count+0xae/0xf0
> [   83.866347]  [<ffffffff82d984e9>] ? _raw_spin_unlock_irq+0x59/0x80
> [   83.869570]  [<ffffffff811b0caa>] try_to_munlock+0x6a/0x80
> [   83.872667]  [<ffffffff811a7cc6>] munlock_vma_page+0xd6/0x200
> [   83.875646]  [<ffffffff811a7d87>] ? munlock_vma_page+0x197/0x200
> [   83.878798]  [<ffffffff811a7e7f>] munlock_vma_pages_range+0x8f/0xd0
> [   83.882235]  [<ffffffff811a8b8a>] exit_mmap+0x5a/0x160
> 
> This bug was introduced by mem_cgroup_begin/end_update_page_stat()
> which uses rcu_read_lock(). This patch fixes the bug by modifying
> the range of rcu_read_lock().
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Yes, I expect that this does fix the reported issue - thanks.  But
Ying and I would prefer for her memcg mlock stats patch simply to be
reverted from akpm's tree for now, as she requested on Friday.

Hannes kindly posted his program which would bypass these memcg mlock
statistics, so we need to fix that case, and bring back the warning
when mlocked pages are freed.

And although I think there's no immediate problem with doing the
isolate_lru_page/putback_lru_page while under the memcg stats lock,
I do have a potential (post-per-memcg-per-zone lru locking) patch
which just uses lru_lock for the move_lock (fixes an unlikely race
Konstantin pointed out with my version of lru locking patches) -
which would (of course) require us not to hold stats lock while
doing the lru part of it.

Though what I'd really like (but fail to find) is a better way of
handling the stats versus move, that doesn't get us into locking
hierarchy questions.

Ongoing work to come later.  For now, Andrew, please just revert Ying's
"memcg: add mlock statistic in memory.stat" patch (and your fix to it).

Thanks,
Hugh

> ---
>  mm/mlock.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 2fd967a..05ac10d1 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -123,6 +123,7 @@ void munlock_vma_page(struct page *page)
>  	if (TestClearPageMlocked(page)) {
>  		dec_zone_page_state(page, NR_MLOCK);
>  		mem_cgroup_dec_page_stat(page, MEMCG_NR_MLOCK);
> +		mem_cgroup_end_update_page_stat(page, &locked, &flags);
>  		if (!isolate_lru_page(page)) {
>  			int ret = SWAP_AGAIN;
>  
> @@ -154,8 +155,8 @@ void munlock_vma_page(struct page *page)
>  			else
>  				count_vm_event(UNEVICTABLE_PGMUNLOCKED);
>  		}
> -	}
> -	mem_cgroup_end_update_page_stat(page, &locked, &flags);
> +	} else
> +		mem_cgroup_end_update_page_stat(page, &locked, &flags);
>  }
>  
>  /**
> -- 
> 1.7.4.1
