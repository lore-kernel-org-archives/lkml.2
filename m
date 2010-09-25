Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0IYObY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 10:31:24 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40129 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0IYObX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 10:31:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=v46/xUAsuiMDncmnuoAOBz38BftZDkSyKG1s1vmkVusXmACsk9eiOEOUdTxcz4zq7J
         8nLlwk2iQOJbd6J6TZPX8q3GjFUQnTDI7WDyHCw6xb5eQ9xgjIrIm9HBFkWjByiC2PpU
         qVuCbqSz/3W1GkDitg3BBU5HxVwtDjYV8HiF8=
MIME-Version: 1.0
In-Reply-To: <1285423491-5892-1-git-send-email-namhyung@gmail.com>
References: <1285423491-5892-1-git-send-email-namhyung@gmail.com>
From: Namhyung Kim <namhyung@gmail.com>
Date: Sat, 25 Sep 2010 23:31:02 +0900
Message-ID: <AANLkTim3GS+O9DnLZ+nh73DkoNnxa+pyAajjX2O-wb-X@mail.gmail.com>
Subject: Re: [PATCH] signal: annotate lock_task_sighand()
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Dumazet <eric.dumazet@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing Cc.


On Sat, Sep 25, 2010 at 23:04, Namhyung Kim <namhyung@gmail.com> wrote:
> lock_task_sighand() grabs sighand->siglock in case of returning
> non-NULL but unlock_task_sighand() releases it unconditionally.
> This leads sparse to complain about the lock context imbalance.
> Rename and wrap lock_task_sighand() using __cond_lock() macro
> to make sparse happy.
>
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>

> ---
>  include/linux/sched.h |    9 ++++++++-
>  kernel/signal.c       |    3 ++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 1e2a6db..9937998 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2210,9 +2210,16 @@ static inline void task_unlock(struct task_struct *p)
>        spin_unlock(&p->alloc_lock);
>  }
>
> -extern struct sighand_struct *lock_task_sighand(struct task_struct *tsk,
> +extern struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
>                                                        unsigned long *flags);
>
> +#define lock_task_sighand(tsk, flags)                                  \
> +({     struct sighand_struct *__ss;                                    \
> +       __cond_lock(&(tsk)->sighand->siglock,                           \
> +                   (__ss = __lock_task_sighand(tsk, flags)));          \
> +       __ss;                                                           \
> +})                                                                     \
> +
>  static inline void unlock_task_sighand(struct task_struct *tsk,
>                                                unsigned long *flags)
>  {
> diff --git a/kernel/signal.c b/kernel/signal.c
> index bded651..e4e8cfe 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1105,7 +1105,8 @@ int zap_other_threads(struct task_struct *p)
>        return count;
>  }
>
> -struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)
> +struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
> +                                          unsigned long *flags)
>  {
>        struct sighand_struct *sighand;
>
> --
> 1.7.2.2
>
>



-- 
Regards,
Namhyung Kim
