Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1HHHIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 03:08:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46374 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1HHHIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 03:08:21 -0400
MIME-Version: 1.0
In-Reply-To: <1312787021-11324-2-git-send-email-david@fromorbit.com>
References: <1312787021-11324-1-git-send-email-david@fromorbit.com>
	<1312787021-11324-2-git-send-email-david@fromorbit.com>
Date: Mon, 8 Aug 2011 10:08:20 +0300
X-Google-Sender-Auth: WnzZCGsvLHovi5oUBEdzH_aC7vw
Message-ID: <CAOJsxLEqNZYV-4qs3HM9EkX-C=KAzjuAXpDOaijykWaa4NSRbg@mail.gmail.com>
Subject: Re: [PATCH 1/2] dcache: convert dentry_stat.nr_unused to per-cpu counters
From: Pekka Enberg <penberg@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 10:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Before we split up the dcache_lru_lock, the unused dentry counter
> needs to be made independent of the global dcache_lru_lock. Convert
> it to per-cpu counters to do this.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/dcache.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/fs/dcache.c b/fs/dcache.c
> index b05aac3..5e5208d 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -116,6 +116,7 @@ struct dentry_stat_t dentry_stat = {
>  };
>
>  static DEFINE_PER_CPU(unsigned int, nr_dentry);
> +static DEFINE_PER_CPU(unsigned int, nr_dentry_unused);
>
>  #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
>  static int get_nr_dentry(void)
> @@ -127,10 +128,20 @@ static int get_nr_dentry(void)
>        return sum < 0 ? 0 : sum;
>  }
>
> +static int get_nr_dentry_unused(void)
> +{
> +       int i;
> +       int sum = 0;
> +       for_each_possible_cpu(i)
> +               sum += per_cpu(nr_dentry_unused, i);
> +       return sum < 0 ? 0 : sum;
> +}

Why not use struct percpu_counter and percpu_counter_sum_positive() for this?

> +
>  int proc_nr_dentry(ctl_table *table, int write, void __user *buffer,
>                   size_t *lenp, loff_t *ppos)
>  {
>        dentry_stat.nr_dentry = get_nr_dentry();
> +       dentry_stat.nr_unused = get_nr_dentry_unused();
>        return proc_dointvec(table, write, buffer, lenp, ppos);
>  }
>  #endif
> @@ -233,7 +244,7 @@ static void dentry_lru_add(struct dentry *dentry)
>                spin_lock(&dcache_lru_lock);
>                list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
>                dentry->d_sb->s_nr_dentry_unused++;
> -               dentry_stat.nr_unused++;
> +               this_cpu_inc(nr_dentry_unused);
>                spin_unlock(&dcache_lru_lock);
>        }
>  }
> @@ -242,7 +253,7 @@ static void __dentry_lru_del(struct dentry *dentry)
>  {
>        list_del_init(&dentry->d_lru);
>        dentry->d_sb->s_nr_dentry_unused--;
> -       dentry_stat.nr_unused--;
> +       this_cpu_dec(nr_dentry_unused);
>  }
>
>  static void dentry_lru_del(struct dentry *dentry)
> @@ -260,7 +271,7 @@ static void dentry_lru_move_tail(struct dentry *dentry)
>        if (list_empty(&dentry->d_lru)) {
>                list_add_tail(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
>                dentry->d_sb->s_nr_dentry_unused++;
> -               dentry_stat.nr_unused++;
> +               this_cpu_inc(nr_dentry_unused);
>        } else {
>                list_move_tail(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
>        }
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
