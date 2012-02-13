Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab2BMQt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:49:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38489 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab2BMQt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:49:26 -0500
MIME-Version: 1.0
In-Reply-To: <20120210200051.GC20898@redhat.com>
References: <20120210200004.GA20890@redhat.com> <20120210200051.GC20898@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 13 Feb 2012 11:49:06 -0500
Message-ID: <CAHGf_=oTUEXBU+szTBSpzcaApKatRGPJMDRZgdMYottf2cGvYA@mail.gmail.com>
Subject: Re: [PATCH 3/4] signal: oom_kill_task: use SEND_SIG_FORCED instead of force_sig()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/10 Oleg Nesterov <oleg@redhat.com>:
> Change oom_kill_task() to use do_send_sig_info(SEND_SIG_FORCED)
> instead of force_sig(SIGKILL). With the recent changes we do not
> need force_ to kill the CLONE_NEWPID tasks.
>
> And this is more correct. force_sig() can race with the exiting
> thread even if oom_kill_task() checks p->mm != NULL, while
> do_send_sig_info(group => true) kille the whole process.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  mm/oom_kill.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 2958fd8..b1e9643 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -472,11 +472,11 @@ static int oom_kill_task(struct task_struct *p)
>                        pr_err("Kill process %d (%s) sharing same memory\n",
>                                task_pid_nr(q), q->comm);
>                        task_unlock(q);
> -                       force_sig(SIGKILL, q);
> +                       do_send_sig_info(SIGKILL, SEND_SIG_FORCED, q, true);
>                }
>
>        set_tsk_thread_flag(p, TIF_MEMDIE);
> -       force_sig(SIGKILL, p);
> +       do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
>
>        return 0;

I don't think I clearly understand this series. But, at least, this
patch is ok to me. thanks.
