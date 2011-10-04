Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1JDARx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 20:17:53 -0400
Received: from shutemov.name ([188.40.19.243]:46045 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab1JDARw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 20:17:52 -0400
Date: Tue, 4 Oct 2011 03:17:51 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 01/10] cgroups: Add res_counter_write_u64() API
Message-ID: <20111004001751.GA6727@shutemov.name>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <1317668832-10784-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317668832-10784-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:07:03PM +0200, Frederic Weisbecker wrote:
> Extend the resource counter API with a mirror of
> res_counter_read_u64() to make it handy to update a resource
> counter value from a cgroup subsystem u64 value file.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Acked-by: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Aditya Kali <adityakali@google.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Tim Hockin <thockin@hockin.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Containers <containers@lists.linux-foundation.org>
> ---
>  include/linux/res_counter.h |    2 ++
>  kernel/res_counter.c        |   25 +++++++++++++++++++------
>  2 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index c9d625c..1b3fe05 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -82,6 +82,8 @@ int res_counter_memparse_write_strategy(const char *buf,
>  int res_counter_write(struct res_counter *counter, int member,
>  		      const char *buffer, write_strategy_fn write_strategy);
>  
> +void res_counter_write_u64(struct res_counter *counter, int member, u64 val);
> +
>  /*
>   * the field descriptors. one for each member of res_counter
>   */
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 34683ef..0faafcc 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -168,12 +168,26 @@ int res_counter_memparse_write_strategy(const char *buf,
>  	return 0;
>  }
>  
> +void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
> +{
> +	unsigned long long *target;
> +	unsigned long flags;
> +
> +	/*
> +	 * We need the lock to protect against concurrent add/dec on 32 bits.
> +	 * No need to ifdef it's seldom used.
> +	 */

Should we hace two version of res_counter_write_u64() for 32/64 bit host?
As with res_counter_read_u64().

> +	spin_lock_irqsave(&counter->lock, flags);
> +	target = res_counter_member(counter, member);
> +	*target = val;
> +	spin_unlock_irqrestore(&counter->lock, flags);
> +}
> +
>  int res_counter_write(struct res_counter *counter, int member,
>  		      const char *buf, write_strategy_fn write_strategy)
>  {
>  	char *end;
> -	unsigned long flags;
> -	unsigned long long tmp, *val;
> +	unsigned long long tmp;
>  
>  	if (write_strategy) {
>  		if (write_strategy(buf, &tmp))
> @@ -183,9 +197,8 @@ int res_counter_write(struct res_counter *counter, int member,
>  		if (*end != '\0')
>  			return -EINVAL;
>  	}
> -	spin_lock_irqsave(&counter->lock, flags);
> -	val = res_counter_member(counter, member);
> -	*val = tmp;
> -	spin_unlock_irqrestore(&counter->lock, flags);
> +
> +	res_counter_write_u64(counter, member, tmp);
> +
>  	return 0;
>  }
> -- 
> 1.7.5.4
> 

-- 
 Kirill A. Shutemov
