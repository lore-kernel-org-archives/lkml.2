Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab0LQDGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:06:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33588 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0LQDGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:06:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jM/7rZhQ6AwHvgr0RGWTzbuKtewtNm9PfS7NhorjfFhw4xJMUESJYgqereCtWagpTD
         i3TlNSOpOqv4vrauW+eZrAKYLW7UVu2YCV5mKygDkp95/oNreuJL53n/AazLK48fJLSv
         7n0YA9dz23fqKfXQsLZF3R2ftXQbzSG9Jz1wc=
MIME-Version: 1.0
In-Reply-To: <1292531553.2708.89.camel@laptop>
References: <20101216145602.899838254@chello.nl>
	<20101216150920.968046926@chello.nl>
	<20101216184229.GA15889@redhat.com>
	<1292525893.2708.50.camel@laptop>
	<1292526220.2708.55.camel@laptop>
	<1292528874.2708.85.camel@laptop>
	<1292531553.2708.89.camel@laptop>
Date: Fri, 17 Dec 2010 11:06:19 +0800
X-Google-Sender-Auth: akySgcNiJD0b6DJx4fRdps-R4iM
Message-ID: <AANLkTimXyic51Qhe_WsfFBwAw10AKdB7e-Z2q0oLRYKP@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 4:32 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> @@ -953,7 +955,7 @@ static inline struct rq *__task_rq_lock(
>        for (;;) {
>                rq = task_rq(p);
>                raw_spin_lock(&rq->lock);
> -               if (likely(rq == task_rq(p)))
> +               if (likely(rq == task_rq(p)) && !task_is_waking(p))
>                        return rq;
>                raw_spin_unlock(&rq->lock);
>        }
> @@ -973,7 +975,7 @@ static struct rq *task_rq_lock(struct ta
>                local_irq_save(*flags);
>                rq = task_rq(p);
>                raw_spin_lock(&rq->lock);
> -               if (likely(rq == task_rq(p)))
> +               if (likely(rq == task_rq(p)) && !task_is_waking(p))
>                        return rq;
>                raw_spin_unlock_irqrestore(&rq->lock, *flags);
>        }

Looks like nothing prevents ttwu() from changing task's CPU while
some one else is holding task_rq_lock(). Is this OK?

Thanks
Yan, Zheng
