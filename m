Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab2D3Ccr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 22:32:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35259 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab2D3Ccp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 22:32:45 -0400
MIME-Version: 1.0
In-Reply-To: <1335681937-3715-3-git-send-email-levinsasha928@gmail.com>
References: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
	<1335681937-3715-3-git-send-email-levinsasha928@gmail.com>
Date: Sun, 29 Apr 2012 22:32:43 -0400
Message-ID: <CACLa4ptMy0GkS=XSGVOPx4Ba2HN+N2EyK50BARr2xaOXfvDqcg@mail.gmail.com>
Subject: Re: [PATCH 03/14] sched rt,sysctl: remove proc input checks out of
 sysctl handlers
From: Eric Paris <eparis@parisplace.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net, james.l.morris@oracle.com,
        ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK

old_period = sysctl_sched_rt_period;

Doesn't make any sense in the callback, since you already updated
sysctl_sched_rt_period.

I'll leave the remainder of the series as an exercise for the reader.
But I get the feeling this isn't the only place where you are doing
things after the proc_dointvec() which must be done before.

-Eric

On Sun, Apr 29, 2012 at 2:45 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Simplify sysctl handler by removing user input checks and using the callback
> provided by the sysctl table.
>
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  include/linux/sched.h |    4 +---
>  kernel/sched/core.c   |   25 ++++++++++---------------
>  kernel/sysctl.c       |    6 ++++--
>  3 files changed, 15 insertions(+), 20 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 722da9a..9509d80 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2152,9 +2152,7 @@ static inline unsigned int get_sysctl_timer_migration(void)
>  extern unsigned int sysctl_sched_rt_period;
>  extern int sysctl_sched_rt_runtime;
>
> -int sched_rt_handler(struct ctl_table *table, int write,
> -               void __user *buffer, size_t *lenp,
> -               loff_t *ppos);
> +int sched_rt_handler(void);
>
>  #ifdef CONFIG_SCHED_AUTOGROUP
>  extern unsigned int sysctl_sched_autogroup_enabled;
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 477b998..ca4a806 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7573,9 +7573,7 @@ static int sched_rt_global_constraints(void)
>  }
>  #endif /* CONFIG_RT_GROUP_SCHED */
>
> -int sched_rt_handler(struct ctl_table *table, int write,
> -               void __user *buffer, size_t *lenp,
> -               loff_t *ppos)
> +int sched_rt_handler(void)
>  {
>        int ret;
>        int old_period, old_runtime;
> @@ -7585,19 +7583,16 @@ int sched_rt_handler(struct ctl_table *table, int write,
>        old_period = sysctl_sched_rt_period;
>        old_runtime = sysctl_sched_rt_runtime;
>
> -       ret = proc_dointvec(table, write, buffer, lenp, ppos);
> -
> -       if (!ret && write) {
> -               ret = sched_rt_global_constraints();
> -               if (ret) {
> -                       sysctl_sched_rt_period = old_period;
> -                       sysctl_sched_rt_runtime = old_runtime;
> -               } else {
> -                       def_rt_bandwidth.rt_runtime = global_rt_runtime();
> -                       def_rt_bandwidth.rt_period =
> -                               ns_to_ktime(global_rt_period());
> -               }
> +       ret = sched_rt_global_constraints();
> +       if (ret) {
> +               sysctl_sched_rt_period = old_period;
> +               sysctl_sched_rt_runtime = old_runtime;
> +       } else {
> +               def_rt_bandwidth.rt_runtime = global_rt_runtime();
> +               def_rt_bandwidth.rt_period =
> +                       ns_to_ktime(global_rt_period());
>        }
> +
>        mutex_unlock(&mutex);
>
>        return ret;
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 23f1ac6..fad9ff6 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -347,14 +347,16 @@ static struct ctl_table kern_table[] = {
>                .data           = &sysctl_sched_rt_period,
>                .maxlen         = sizeof(unsigned int),
>                .mode           = 0644,
> -               .proc_handler   = sched_rt_handler,
> +               .proc_handler   = proc_dointvec,
> +               .callback       = sched_rt_handler,
>        },
>        {
>                .procname       = "sched_rt_runtime_us",
>                .data           = &sysctl_sched_rt_runtime,
>                .maxlen         = sizeof(int),
>                .mode           = 0644,
> -               .proc_handler   = sched_rt_handler,
> +               .proc_handler   = proc_dointvec,
> +               .callback       = sched_rt_handler,
>        },
>  #ifdef CONFIG_SCHED_AUTOGROUP
>        {
> --
> 1.7.8.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
