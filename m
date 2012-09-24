Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2IXT1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:27:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50090 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab2IXT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:27:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120826191209.GA4221@redhat.com>
References: <20120826191132.GA3743@redhat.com>
	<20120826191209.GA4221@redhat.com>
Date: Mon, 24 Sep 2012 21:27:05 +0200
X-Google-Sender-Auth: Jo4JrfbvOBC7NYHVdJf21-3_A2A
Message-ID: <CAMuHMdU7D+SM=xCN9Yp0KuGwiod=RojWjkpdYT-Hw=v9iry66A@mail.gmail.com>
Subject: Re: [PATCH 1/4] task_work: make task_work_add() lockless
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Oleg Nesterov <oleg@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 9:12 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Change task_works to use llist-like code to avoid pi_lock
> in task_work_add(), this makes it useable under rq->lock.
>
> task_work_cancel() and task_work_run() still use pi_lock
> to synchronize with each other.
>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c

> @@ -30,52 +23,60 @@ task_work_add(struct task_struct *task, struct callback_head *twork, bool notify
>  struct callback_head *
>  task_work_cancel(struct task_struct *task, task_work_func_t func)
>  {
> +       struct callback_head **pprev = &task->task_works;
> +       struct callback_head *work = NULL;
>         unsigned long flags;
> -       struct callback_head *last, *res = NULL;
> -
> +       /*
> +        * If cmpxchg() fails we continue without updating pprev.
> +        * Either we raced with task_work_add() which added the
> +        * new entry before this work, we will find it again. Or
> +        * we raced with task_work_run(), *pprev == NULL.
> +        */
>         raw_spin_lock_irqsave(&task->pi_lock, flags);
> -       last = task->task_works;
> -       if (last) {
> -               struct callback_head *q = last, *p = q->next;
> -               while (1) {
> -                       if (p->func == func) {
> -                               q->next = p->next;
> -                               if (p == last)
> -                                       task->task_works = q == p ? NULL : q;
> -                               res = p;
> -                               break;
> -                       }
> -                       if (p == last)
> -                               break;
> -                       q = p;
> -                       p = q->next;
> -               }
> +       while ((work = ACCESS_ONCE(*pprev))) {
> +               read_barrier_depends();

Woops, h8300 doesn't have read_barrier_depends():
kernel/task_work.c:38:3: error: implicit declaration of function
'read_barrier_depends' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [kernel/task_work.o] Error 1

http://kisskb.ellerman.id.au/kisskb/buildresult/7238385/

Perhaps an empty definition is fine? Most architectures have:

#define read_barrier_depends() do { } while(0)

The same issue on c6x just got fixed in -next in commit
2c8c2366077da5645bf9063b3cf5c94ecb16f691 ("c6x: use
asm-generic/barrier.h")

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
