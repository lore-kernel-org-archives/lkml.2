Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1JDAlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 20:41:47 -0400
Received: from shutemov.name ([188.40.19.243]:51180 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab1JDAlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 20:41:46 -0400
Date: Tue, 4 Oct 2011 03:41:45 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 05/10] cgroups: Ability to stop res charge propagation on
 bounded ancestor
Message-ID: <20111004004145.GE6727@shutemov.name>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <1317668832-10784-6-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317668832-10784-6-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:07:07PM +0200, Frederic Weisbecker wrote:
> Moving a task from a cgroup to another may require to substract
> its resource charge from the old cgroup and add it to the new one.
> 
> For this to happen, the uncharge/charge propagation can just stop
> when we reach the common ancestor for the two cgroups. Further
> the performance reasons, we also want to avoid to temporarily
> overload the common ancestors with a non-accurate resource
> counter usage if we charge first the new cgroup and uncharge the
> old one thereafter. This is going to be a requirement for the coming
> max number of task subsystem.
> 
> To solve this, provide a pair of new API that can charge/uncharge
> a resource counter until we reach a given ancestor.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Acked-by: Paul Menage <paul@paulmenage.org>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

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
>  Documentation/cgroups/resource_counter.txt |   18 +++++++++++++++++-
>  include/linux/res_counter.h                |   20 +++++++++++++++++---
>  kernel/res_counter.c                       |   13 ++++++++-----
>  3 files changed, 42 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/cgroups/resource_counter.txt b/Documentation/cgroups/resource_counter.txt
> index 95b24d7..a2cd05b 100644
> --- a/Documentation/cgroups/resource_counter.txt
> +++ b/Documentation/cgroups/resource_counter.txt
> @@ -83,7 +83,15 @@ to work with it.
>  	res_counter->lock internally (it must be called with res_counter->lock
>  	held).
>  
> - e. void res_counter_uncharge[_locked]
> + e. int res_counter_charge_until(struct res_counter *counter,
> +			     struct res_counter *limit, unsigned long val,
> +			     struct res_counter **limit_fail_at)
> +
> +	The same as res_counter_charge(), but the charge propagation to
> +	the hierarchy stops at the limit given in the "limit" parameter.
> +
> +
> + f. void res_counter_uncharge[_locked]
>  			(struct res_counter *rc, unsigned long val)
>  
>  	When a resource is released (freed) it should be de-accounted
> @@ -92,6 +100,14 @@ to work with it.
>  
>  	The _locked routines imply that the res_counter->lock is taken.
>  
> +
> + g. void res_counter_uncharge_until(struct res_counter *counter,
> +				struct res_counter *limit,
> +				unsigned long val)
> +
> +	The same as res_counter_charge, but the uncharge propagation to
> +	the hierarchy stops at the limit given in the "limit" parameter.
> +
>   2.1 Other accounting routines
>  
>      There are more routines that may help you with common needs, like
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index 109d118..de4ba29 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -117,8 +117,16 @@ void res_counter_init(struct res_counter *counter, struct res_counter *parent);
>  
>  int __must_check res_counter_charge_locked(struct res_counter *counter,
>  		unsigned long val);
> -int __must_check res_counter_charge(struct res_counter *counter,
> -		unsigned long val, struct res_counter **limit_fail_at);
> +int __must_check res_counter_charge_until(struct res_counter *counter,
> +					  struct res_counter *limit,
> +					  unsigned long val,
> +					  struct res_counter **limit_fail_at);
> +static inline int __must_check
> +res_counter_charge(struct res_counter *counter, unsigned long val,
> +		   struct res_counter **limit_fail_at)
> +{
> +	return res_counter_charge_until(counter, NULL, val, limit_fail_at);
> +}
>  
>  /*
>   * uncharge - tell that some portion of the resource is released
> @@ -131,7 +139,13 @@ int __must_check res_counter_charge(struct res_counter *counter,
>   */
>  
>  void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
> -void res_counter_uncharge(struct res_counter *counter, unsigned long val);
> +void res_counter_uncharge_until(struct res_counter *counter,
> +				struct res_counter *limit, unsigned long val);
> +static inline void res_counter_uncharge(struct res_counter *counter,
> +					unsigned long val)
> +{
> +	res_counter_uncharge_until(counter, NULL, val);
> +}
>  
>  /**
>   * res_counter_margin - calculate chargeable space of a counter
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 37abf4e..0cc9c7e 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -35,8 +35,9 @@ int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
>  	return 0;
>  }
>  
> -int res_counter_charge(struct res_counter *counter, unsigned long val,
> -			struct res_counter **limit_fail_at)
> +int res_counter_charge_until(struct res_counter *counter,
> +			     struct res_counter *limit, unsigned long val,
> +			     struct res_counter **limit_fail_at)
>  {
>  	int ret;
>  	unsigned long flags;
> @@ -44,7 +45,7 @@ int res_counter_charge(struct res_counter *counter, unsigned long val,
>  
>  	*limit_fail_at = NULL;
>  	local_irq_save(flags);
> -	for (c = counter; c != NULL; c = c->parent) {
> +	for (c = counter; c != limit; c = c->parent) {
>  		spin_lock(&c->lock);
>  		ret = res_counter_charge_locked(c, val);
>  		spin_unlock(&c->lock);
> @@ -74,13 +75,15 @@ void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
>  	counter->usage -= val;
>  }
>  
> -void res_counter_uncharge(struct res_counter *counter, unsigned long val)
> +void res_counter_uncharge_until(struct res_counter *counter,
> +				struct res_counter *limit,
> +				unsigned long val)
>  {
>  	unsigned long flags;
>  	struct res_counter *c;
>  
>  	local_irq_save(flags);
> -	for (c = counter; c != NULL; c = c->parent) {
> +	for (c = counter; c != limit; c = c->parent) {
>  		spin_lock(&c->lock);
>  		res_counter_uncharge_locked(c, val);
>  		spin_unlock(&c->lock);
> -- 
> 1.7.5.4
> 

-- 
 Kirill A. Shutemov
