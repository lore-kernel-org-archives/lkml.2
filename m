Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1GZAv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 20:51:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:36193 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GZAvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 20:51:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=pNPUInnEiJIBKICY8qx4w29AkWxra3ObDE7x2R8D1u9G8ADyP9DpAQzmXsq2Dnc1R
	VhQtWfZ/FSd7q8gDtPN0A==
MIME-Version: 1.0
In-Reply-To: <1310393706-321-6-git-send-email-fweisbec@gmail.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com> <1310393706-321-6-git-send-email-fweisbec@gmail.com>
From: Paul Menage <menage@google.com>
Date: Mon, 25 Jul 2011 17:50:54 -0700
Message-ID: <CAJniumXTq18gDTyirNwu-QRxRdZQZs75j-ffGUcxsnTQs7CshQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] cgroups: Ability to stop res charge propagation on
 bounded ancestor
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 7:15 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
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

Acked-by: Paul Menage <menage@google.com>

Looks good, thanks.
Paul

> Cc: Paul Menage <menage@google.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Aditya Kali <adityakali@google.com>
> ---
>  include/linux/res_counter.h |    6 ++++++
>  kernel/res_counter.c        |   23 ++++++++++++++++++-----
>  2 files changed, 24 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index 109d118..8c421ac 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -117,6 +117,10 @@ void res_counter_init(struct res_counter *counter, struct res_counter *parent);
>
>  int __must_check res_counter_charge_locked(struct res_counter *counter,
>                unsigned long val);
> +int __must_check res_counter_charge_until(struct res_counter *counter,
> +                                         struct res_counter *limit,
> +                                         unsigned long val,
> +                                         struct res_counter **limit_fail_at);
>  int __must_check res_counter_charge(struct res_counter *counter,
>                unsigned long val, struct res_counter **limit_fail_at);
>
> @@ -131,6 +135,8 @@ int __must_check res_counter_charge(struct res_counter *counter,
>  */
>
>  void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
> +void res_counter_uncharge_until(struct res_counter *counter, struct res_counter *limit,
> +                               unsigned long val);
>  void res_counter_uncharge(struct res_counter *counter, unsigned long val);
>
>  /**
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 8cb0362..39f2513 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -35,8 +35,9 @@ int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
>        return 0;
>  }
>
> -int res_counter_charge(struct res_counter *counter, unsigned long val,
> -                       struct res_counter **limit_fail_at)
> +int res_counter_charge_until(struct res_counter *counter,
> +                            struct res_counter *limit, unsigned long val,
> +                            struct res_counter **limit_fail_at)
>  {
>        int ret;
>        unsigned long flags;
> @@ -44,7 +45,7 @@ int res_counter_charge(struct res_counter *counter, unsigned long val,
>
>        *limit_fail_at = NULL;
>        local_irq_save(flags);
> -       for (c = counter; c != NULL; c = c->parent) {
> +       for (c = counter; c != limit; c = c->parent) {
>                spin_lock(&c->lock);
>                ret = res_counter_charge_locked(c, val);
>                spin_unlock(&c->lock);
> @@ -66,6 +67,12 @@ done:
>        return ret;
>  }
>
> +int res_counter_charge(struct res_counter *counter, unsigned long val,
> +                       struct res_counter **limit_fail_at)
> +{
> +       return res_counter_charge_until(counter, NULL, val, limit_fail_at);
> +}
> +
>  void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
>  {
>        if (WARN_ON(counter->usage < val))
> @@ -74,13 +81,15 @@ void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
>        counter->usage -= val;
>  }
>
> -void res_counter_uncharge(struct res_counter *counter, unsigned long val)
> +void res_counter_uncharge_until(struct res_counter *counter,
> +                               struct res_counter *limit,
> +                               unsigned long val)
>  {
>        unsigned long flags;
>        struct res_counter *c;
>
>        local_irq_save(flags);
> -       for (c = counter; c != NULL; c = c->parent) {
> +       for (c = counter; c != limit; c = c->parent) {
>                spin_lock(&c->lock);
>                res_counter_uncharge_locked(c, val);
>                spin_unlock(&c->lock);
> @@ -88,6 +97,10 @@ void res_counter_uncharge(struct res_counter *counter, unsigned long val)
>        local_irq_restore(flags);
>  }
>
> +void res_counter_uncharge(struct res_counter *counter, unsigned long val)
> +{
> +       res_counter_uncharge_until(counter, NULL, val);
> +}
>
>  static inline unsigned long long *
>  res_counter_member(struct res_counter *counter, int member)
> --
> 1.7.5.4
>
>
