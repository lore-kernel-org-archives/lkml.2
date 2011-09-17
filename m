Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1IQRwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 13:52:09 -0400
Received: from shutemov.name ([188.40.19.243]:47280 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab1IQRwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 13:52:08 -0400
Date: Sat, 17 Sep 2011 20:52:07 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 2/7] socket: initial cgroup code.
Message-ID: <20110917175207.GB1658@shutemov.name>
References: <1316051175-17780-1-git-send-email-glommer@parallels.com>
 <1316051175-17780-3-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316051175-17780-3-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 10:46:10PM -0300, Glauber Costa wrote:
> We aim to control the amount of kernel memory pinned at any
> time by tcp sockets. To lay the foundations for this work,
> this patch adds a pointer to the kmem_cgroup to the socket
> structure.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  include/linux/memcontrol.h |   38 ++++++++++++++++++++++++++++++++++++++
>  include/net/sock.h         |    2 ++
>  net/core/sock.c            |    3 +++
>  3 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 3b535db..be457ce 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -395,5 +395,43 @@ mem_cgroup_print_bad_page(struct page *page)
>  }
>  #endif
>  
> +#ifdef CONFIG_INET
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +#include <net/sock.h>
> +static inline void sock_update_memcg(struct sock *sk)
> +{
> +	/* right now a socket spends its whole life in the same cgroup */
> +	BUG_ON(sk->sk_cgrp);
> +
> +	rcu_read_lock();
> +	sk->sk_cgrp = mem_cgroup_from_task(current);
> +
> +	/*
> +	 * We don't need to protect against anything task-related, because
> +	 * we are basically stuck with the sock pointer that won't change,
> +	 * even if the task that originated the socket changes cgroups.
> +	 *
> +	 * What we do have to guarantee, is that the chain leading us to
> +	 * the top level won't change under our noses. Incrementing the
> +	 * reference count via cgroup_exclude_rmdir guarantees that.
> +	 */
> +	cgroup_exclude_rmdir(mem_cgroup_css(sk->sk_cgrp));
> +	rcu_read_unlock();
> +}
> +
> +static inline void sock_release_memcg(struct sock *sk)
> +{
> +	cgroup_release_and_wakeup_rmdir(mem_cgroup_css(sk->sk_cgrp));
> +}

Do we really need to have these functions in the header?

-- 
 Kirill A. Shutemov
