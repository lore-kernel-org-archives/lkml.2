Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab0K1Egb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 23:36:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52539 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0K1Eg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 23:36:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LqzWZVvZJEUKpSORA4h3CvAkzuJxRcaX9OO+sg28CDM47lQrLTAzE5CDjYtI0i6XT0
         pv7a22nimoB1NxBPagU5HzTQPQ8tDuNfER+DmGb7+DKtyEMzpOu/AS/Z2sQwEDbk5e14
         4kKnPdzskS+50BgMJ/GFAN0RaSASYoEopuxdQ=
MIME-Version: 1.0
In-Reply-To: <tip-dddd3379a619a4cb8247bfd3c94ca9ae3797aa2e@git.kernel.org>
References: <tip-dddd3379a619a4cb8247bfd3c94ca9ae3797aa2e@git.kernel.org>
Date: Sun, 28 Nov 2010 10:36:26 +0600
Message-ID: <AANLkTimWMD5fCLfwPNh1_Qc3w08Vy=ErsRKpbprAimeX@mail.gmail.com>
Subject: Re: [tip:perf/core] perf: Fix inherit vs. context rotation bug
From: Rakib Mullick <rakib.mullick@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 9:00 PM, tip-bot for Thomas Gleixner
<tglx@linutronix.de> wrote:
> Commit-ID:  dddd3379a619a4cb8247bfd3c94ca9ae3797aa2e
> Gitweb:     http://git.kernel.org/tip/dddd3379a619a4cb8247bfd3c94ca9ae3797aa2e
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Wed, 24 Nov 2010 10:05:55 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 26 Nov 2010 15:00:56 +0100
>
> perf: Fix inherit vs. context rotation bug
>
> It was found that sometimes children of tasks with inherited events had
> one extra event. Eventually it turned out to be due to the list rotation
> no being exclusive with the list iteration in the inheritance code.
>
> Cure this by temporarily disabling the rotation while we inherit the events.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> Cc: <stable@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/perf_event.h |    1 +
>  kernel/perf_event.c        |   22 ++++++++++++++++++++--
>  2 files changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 40150f3..142e3d6 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -850,6 +850,7 @@ struct perf_event_context {
>        int                             nr_active;
>        int                             is_active;
>        int                             nr_stat;
> +       int                             rotate_disable;

Isn't it convincing to use atomic_t instead of int as rotate_disable
type. Since, we just have to increment or decrement it  inside
raw_spin_lock_irqsave(), we could've easily do it using
atomic_inc/atomic_dec and atomic_read while calling
list_rotate_left(). It will allow us to remove raw_spin_lock_irqsave()
at increment/decrement. Am I missing anyting?

thanks,
rakib

>        atomic_t                        refcount;
>        struct task_struct              *task;
>
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 671f6c8..f365dd8 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1622,8 +1622,12 @@ static void rotate_ctx(struct perf_event_context *ctx)
>  {
>        raw_spin_lock(&ctx->lock);
>
> -       /* Rotate the first entry last of non-pinned groups */
> -       list_rotate_left(&ctx->flexible_groups);
> +       /*
> +        * Rotate the first entry last of non-pinned groups. Rotation might be
> +        * disabled by the inheritance code.
> +        */
> +       if (!ctx->rotate_disable)
> +               list_rotate_left(&ctx->flexible_groups);
>
>        raw_spin_unlock(&ctx->lock);
>  }
> @@ -6162,6 +6166,7 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
>        struct perf_event *event;
>        struct task_struct *parent = current;
>        int inherited_all = 1;
> +       unsigned long flags;
>        int ret = 0;
>
>        child->perf_event_ctxp[ctxn] = NULL;
> @@ -6202,6 +6207,15 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
>                        break;
>        }
>
> +       /*
> +        * We can't hold ctx->lock when iterating the ->flexible_group list due
> +        * to allocations, but we need to prevent rotation because
> +        * rotate_ctx() will change the list from interrupt context.
> +        */
> +       raw_spin_lock_irqsave(&parent_ctx->lock, flags);
> +       parent_ctx->rotate_disable = 1;
> +       raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);
> +
>        list_for_each_entry(event, &parent_ctx->flexible_groups, group_entry) {
>                ret = inherit_task_group(event, parent, parent_ctx,
>                                         child, ctxn, &inherited_all);
> @@ -6209,6 +6223,10 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
>                        break;
>        }
>
> +       raw_spin_lock_irqsave(&parent_ctx->lock, flags);
> +       parent_ctx->rotate_disable = 0;
> +       raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);
> +
>        child_ctx = child->perf_event_ctxp[ctxn];
>
>        if (child_ctx && inherited_all) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
