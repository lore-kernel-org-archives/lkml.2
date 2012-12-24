Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2LXVAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 16:00:54 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:51430 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab2LXVAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 16:00:52 -0500
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2012 16:00:52 EST
MIME-Version: 1.0
In-Reply-To: <1356336807-5517-3-git-send-email-avagin@openvz.org>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org> <1356336807-5517-3-git-send-email-avagin@openvz.org>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 24 Dec 2012 21:52:22 +0100
X-Google-Sender-Auth: sAL1BPrGRH_JAM3j_pB5HPG8W7c
Message-ID: <CAHO5Pa16cZeVV7_awtv8BJbSVmgJXz6d2HeqtrEoN-Yj96+e8w@mail.gmail.com>
Subject: Re: [PATCH 2/4] signal: add a helper for dequeuing signals from a
 specified queue
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-man@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC+=linux-api]

On Mon, Dec 24, 2012 at 9:13 AM, Andrey Vagin <avagin@openvz.org> wrote:
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> CC: Cyrill Gorcunov <gorcunov@openvz.org>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  include/linux/sched.h |  9 ++++++++-
>  kernel/signal.c       | 13 +++++++++----
>  2 files changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 0dd42a0..de9a4bf 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2159,7 +2159,14 @@ extern void flush_signals(struct task_struct *);
>  extern void __flush_signals(struct task_struct *);
>  extern void ignore_signals(struct task_struct *);
>  extern void flush_signal_handlers(struct task_struct *, int force_default);
> -extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
> +extern int do_dequeue_signal(struct task_struct *tsk,
> +                               sigset_t *mask, siginfo_t *info, int queue);
> +
> +static inline int dequeue_signal(struct task_struct *tsk,
> +                                       sigset_t *mask, siginfo_t *info)
> +{
> +       return do_dequeue_signal(tsk, mask, info, 0);
> +}
>
>  static inline int dequeue_signal_lock(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
>  {
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 0af8868..91bb76f2 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -597,17 +597,22 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
>   * Dequeue a signal and return the element to the caller, which is
>   * expected to free it.
>   *
> + * @queue: dequeue from a private queue, if a value is not positive

if a value is not positive ==> if value is nonpositive

> + *        dequeue from a shared queue, if a value if not negative

if a value is not negative ==> if value is nonnegative

Thanks,

Michael



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
