Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab1EJMi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:38:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36405 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab1EJMi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Sg4ZRG0aMtF8TdhColcbLZqfeANXjqU/7kpwrYHb4vg95AzmWKwnXxVpulK2CABS8q
         bGhHgyYscvbTlVH4/BjSPvj+roonPoVuS1OHSfwicUGNdXzgHo7FIsGJBJtJ/fsL8aiZ
         UulLhNhkxMFEmwpy9NACS6AFL2+c5RWzYFP5U=
MIME-Version: 1.0
In-Reply-To: <20110509140705.GA2219@zhy>
References: <BANLkTi=tPbwNP3xDYZVHHqQ2zZujCBT6jw@mail.gmail.com>
	<BANLkTimjkK-q63x5DrEj+9=pF8zbW7mJ2g@mail.gmail.com>
	<BANLkTimrHnX5BcK5Q6eJgCAzP+j7azAqow@mail.gmail.com>
	<20110509140705.GA2219@zhy>
Date: Tue, 10 May 2011 20:38:24 +0800
Message-ID: <BANLkTinrrV7LMqYz+CqkVzG-Bc6fj0vSXw@mail.gmail.com>
Subject: Re: [PATCH] sched: shorten setting the allowed cpu mask of task
From: Hillf Danton <dhillf@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 10:07 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Mon, May 09, 2011 at 08:52:53PM +0800, Hillf Danton wrote:
>> On Mon, May 9, 2011 at 12:39 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
>> > On Fri, May 6, 2011 at 8:52 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> >> When setting the allowed cpu mask for a given task, if the task is
>> >> already bound to certain cpu, after checking the validity of the new
>> >
>> > Maybe we don't need to restrict it only on task bound to certain cpu.
>> >
>> Hi Yong
>>
>> The original code guards, I guess, casual change in the mask of
>> allowed CPUs, if bounded,
>> for tasks such as the workers of work queue. So the restriction looks necessary.
>
> Yeah, that is true; but I don't think we need to go ahead for
> unbounded task if cpu_allowed will not be changed.
>
> My thought is like below:
>
> ---
> Subject: [PATCH] sched: avoid going ahead if cpu_allowed will not be changed
>
> If cpumask_equal(&p->cpus_allowed, new_mask) is true, seems
> there is no reason to prevent set_cpus_allowed_ptr() return
> directly.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Hillf Danton <dhillf@gmail.com>

> ---
>  kernel/sched.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index da93381..56bc1fa 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5946,13 +5946,15 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
>
>        rq = task_rq_lock(p, &flags);
>
> +       if (cpumask_equal(&p->cpus_allowed, new_mask))
> +               goto out;
> +
>        if (!cpumask_intersects(new_mask, cpu_active_mask)) {
>                ret = -EINVAL;
>                goto out;
>        }
>
> -       if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
> -                    !cpumask_equal(&p->cpus_allowed, new_mask))) {
> +       if (unlikely((p->flags & PF_THREAD_BOUND) && p != current)) {
>                ret = -EINVAL;
>                goto out;
>        }
> --
> 1.7.1
>
>
