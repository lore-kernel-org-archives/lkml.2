Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab1GKUao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:30:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46559 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab1GKUan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:30:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=hScaOubbou9tkVib5ffWEiqXRufOeMsDJ5igKdWSuPKZyiYhjo3nOp4c3RPrEZgt3
	K3/XpZRDwSrEsFezt+JEA==
MIME-Version: 1.0
In-Reply-To: <1310393706-321-2-git-send-email-fweisbec@gmail.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com> <1310393706-321-2-git-send-email-fweisbec@gmail.com>
From: Paul Menage <menage@google.com>
Date: Mon, 11 Jul 2011 13:30:17 -0700
Message-ID: <CAJniumVRz7PC0L56=jzWOXXHWM1T1iPMO=sXtMMKyj1e8tekFQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] cgroups: Add res_counter_write_u64() API
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
> Extend the resource counter API with a mirror of
> res_counter_read_u64() to make it handy to update a resource
> counter value from a cgroup subsystem u64 value file.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Paul Menage <menage@google.com>

Thanks,
Paul

> Cc: Paul Menage <menage@google.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Aditya Kali <adityakali@google.com>
> ---
>  include/linux/res_counter.h |    2 ++
>  kernel/res_counter.c        |   21 +++++++++++++++------
>  2 files changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index c9d625c..1b3fe05 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -82,6 +82,8 @@ int res_counter_memparse_write_strategy(const char *buf,
>  int res_counter_write(struct res_counter *counter, int member,
>                      const char *buffer, write_strategy_fn write_strategy);
>
> +void res_counter_write_u64(struct res_counter *counter, int member, u64 val);
> +
>  /*
>  * the field descriptors. one for each member of res_counter
>  */
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 34683ef..806d041 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -168,12 +168,22 @@ int res_counter_memparse_write_strategy(const char *buf,
>        return 0;
>  }
>
> +void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
> +{
> +       unsigned long long *target;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&counter->lock, flags);
> +       target = res_counter_member(counter, member);
> +       *target = val;
> +       spin_unlock_irqrestore(&counter->lock, flags);
> +}
> +
>  int res_counter_write(struct res_counter *counter, int member,
>                      const char *buf, write_strategy_fn write_strategy)
>  {
>        char *end;
> -       unsigned long flags;
> -       unsigned long long tmp, *val;
> +       unsigned long long tmp;
>
>        if (write_strategy) {
>                if (write_strategy(buf, &tmp))
> @@ -183,9 +193,8 @@ int res_counter_write(struct res_counter *counter, int member,
>                if (*end != '\0')
>                        return -EINVAL;
>        }
> -       spin_lock_irqsave(&counter->lock, flags);
> -       val = res_counter_member(counter, member);
> -       *val = tmp;
> -       spin_unlock_irqrestore(&counter->lock, flags);
> +
> +       res_counter_write_u64(counter, member, tmp);
> +
>        return 0;
>  }
> --
> 1.7.5.4
>
>
