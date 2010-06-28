Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0F1Qsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:48:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:3987 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0F1Qsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jR7eiD1HX6NPK3TQ0nU4nGs+pAwCsbVA4WgNkZ/DQOm2EEyqGp3jnw0xWzWkzGJyM4
         YlwGwTbhI1dU7/kA9DTdaiFm6LXOMm6pzelErHE/KqKGcWtgDBdLD99UqDpcs9hggfVE
         JQWDfFX7tB5JE2JSzobXaCwSrk14AOXyGvcl4=
MIME-Version: 1.0
In-Reply-To: <20100625212101.622422748@quilx.com>
References: <20100625212026.810557229@quilx.com>
	<20100625212101.622422748@quilx.com>
Date: Mon, 28 Jun 2010 19:48:34 +0300
X-Google-Sender-Auth: FGJdJPQ3Smo1nUpZ7aYNbm1_FcI
Message-ID: <AANLkTinmvRtH24uflD9e7MknaW6tgMSnN75vVgaj0IM6@mail.gmail.com>
Subject: Re: [S+Q 01/16] [PATCH] ipc/sem.c: Bugfix for semop() not reporting 
	successful operation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-mm@kvack.org, Manfred Spraul <manfred@colorfullife.com>,
       Nick Piggin <npiggin@suse.de>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 12:20 AM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> [Necessary to make 2.6.35-rc3 not deadlock. Not sure if this is the "right"(tm)
> fix]

Is this related to the SLUB patches? Regardless, lets add Andrew and
linux-kernel on CC.

> The last change to improve the scalability moved the actual wake-up out of
> the section that is protected by spin_lock(sma->sem_perm.lock).
>
> This means that IN_WAKEUP can be in queue.status even when the spinlock is
> acquired by the current task. Thus the same loop that is performed when
> queue.status is read without the spinlock acquired must be performed when
> the spinlock is acquired.
>
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
>
> ---
>  ipc/sem.c |   36 ++++++++++++++++++++++++++++++------
>  1 files changed, 30 insertions(+), 6 deletions(-)
>
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 506c849..523665f 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1256,6 +1256,32 @@ out:
>        return un;
>  }
>
> +
> +/** get_queue_result - Retrieve the result code from sem_queue
> + * @q: Pointer to queue structure
> + *
> + * The function retrieve the return code from the pending queue. If
> + * IN_WAKEUP is found in q->status, then we must loop until the value
> + * is replaced with the final value: This may happen if a task is
> + * woken up by an unrelated event (e.g. signal) and in parallel the task
> + * is woken up by another task because it got the requested semaphores.
> + *
> + * The function can be called with or without holding the semaphore spinlock.
> + */
> +static int get_queue_result(struct sem_queue *q)
> +{
> +       int error;
> +
> +       error = q->status;
> +       while(unlikely(error == IN_WAKEUP)) {
> +               cpu_relax();
> +               error = q->status;
> +       }
> +
> +       return error;
> +}
> +
> +
>  SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>                unsigned, nsops, const struct timespec __user *, timeout)
>  {
> @@ -1409,11 +1435,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>        else
>                schedule();
>
> -       error = queue.status;
> -       while(unlikely(error == IN_WAKEUP)) {
> -               cpu_relax();
> -               error = queue.status;
> -       }
> +       error = get_queue_result(&queue);
>
>        if (error != -EINTR) {
>                /* fast path: update_queue already obtained all requested
> @@ -1427,10 +1449,12 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>                goto out_free;
>        }
>
> +       error = get_queue_result(&queue);
> +
>        /*
>         * If queue.status != -EINTR we are woken up by another process
>         */
> -       error = queue.status;
> +
>        if (error != -EINTR) {
>                goto out_unlock_free;
>        }
> --
> 1.7.0.1
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
