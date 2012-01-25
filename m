Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048Ab2AYSbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 13:31:11 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57451 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832Ab2AYSbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 13:31:09 -0500
Date: Wed, 25 Jan 2012 19:31:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <htejun@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/8] cgroups: add res_counter_write_u64() API
Message-ID: <20120125183100.GD20878@somewhere>
References: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
 <1326478441-3048-4-git-send-email-fweisbec@gmail.com>
 <20120116122713.GA25863@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116122713.GA25863@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 02:27:13PM +0200, Kirill A. Shutemov wrote:
> On Fri, Jan 13, 2012 at 07:13:47PM +0100, Frederic Weisbecker wrote:
> > Extend the resource counter API with a mirror of res_counter_read_u64() to
> > make it handy to update a resource counter value from a cgroup subsystem
> > u64 value file.
> 
> I still think it worth to have two versions of res_counter_write_u64().
> From my POV, it's clean enough, but consistent with res_counter_read_u64()
> and faster on 64bit system.
> 
> What do you think?

Yeah right let's do this. Can I get your signed-off-by to take the below?

Thanks.

> 
> ---
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
> index 6d269cc..aad4ddb 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -167,12 +167,27 @@ int res_counter_memparse_write_strategy(const char *buf,
>  	return 0;
>  }
>  
> +#if BITS_PER_LONG == 32
> +void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&counter->lock, flags);
> +	*res_counter_member(counter, member) = val;
> +	spin_unlock_irqrestore(&counter->lock, flags);
> +}
> +#else
> +void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
> +{
> +	*res_counter_member(counter, member) = val;
> +}
> +#endif
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
> @@ -182,9 +197,8 @@ int res_counter_write(struct res_counter *counter, int member,
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
>  Kirill A. Shutemov
