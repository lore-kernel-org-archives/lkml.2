Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0JGVAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:00:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61006 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab0JGVAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mD6WM8TwzSyaxsS4fwqJVBE04m7Fagr4Us4GbGFePjRt7PoYHBUnV/F3Rq8AeiWwxe
         O8nFU7EZHKLO1X07mozA==
MIME-Version: 1.0
In-Reply-To: <1285742774-5013-2-git-send-email-dima@android.com>
References: <1285742774-5013-1-git-send-email-dima@android.com>
	<1285742774-5013-2-git-send-email-dima@android.com>
Date: Thu, 7 Oct 2010 14:00:09 -0700
X-Google-Sender-Auth: hmKGXGUGc3EyoK1nApING-Tnr98
Message-ID: <AANLkTimR3pmxNF5TLTyEHZjPTrQeLrTB+HLsj-X6jPRx@mail.gmail.com>
Subject: Re: [PATCH 2/2] sched: use the old min_vruntime when normalizing on dequeue
From: Dima Zavin <dima@android.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dima Zavin <dima@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

Thanks for the Ack for patch 1/2, could you take a look at this one too?

Should I re-upload the series as v2 or you can pick the latest from
patch 1 and take this one?

--Dima

On Tue, Sep 28, 2010 at 11:46 PM, Dima Zavin <dima@android.com> wrote:
> After pulling the thread off the run-queue during a cgroup change,
> the cfs_rq.min_vruntime gets recalculated. The dequeued thread's vruntime
> then gets normalized to this new value. This can then lead to the thread
> getting an unfair boost in the new group if the vruntime of the next
> task in the old run-queue was way further ahead.
>
> Cc: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: Dima Zavin <dima@android.com>
> ---
>  kernel/sched_fair.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 008fe57..cb24ddb 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -802,6 +802,8 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  static void
>  dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  {
> +       u64 min_vruntime;
> +
>        /*
>         * Update run-time statistics of the 'current'.
>         */
> @@ -826,6 +828,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>        if (se != cfs_rq->curr)
>                __dequeue_entity(cfs_rq, se);
>        account_entity_dequeue(cfs_rq, se);
> +
> +       min_vruntime = cfs_rq->min_vruntime;
>        update_min_vruntime(cfs_rq);
>
>        /*
> @@ -834,7 +838,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>         * movement in our normalized position.
>         */
>        if (!(flags & DEQUEUE_SLEEP))
> -               se->vruntime -= cfs_rq->min_vruntime;
> +               se->vruntime -= min_vruntime;
>  }
>
>  /*
> --
> 1.6.6
>
>
