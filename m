Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1GZA6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 20:58:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53304 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1GZA6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 20:58:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=i6FAZGX2ISFm6YvA1MKio0JQKOyh7F9vP5XD4cbp83WSQK2iYYAkU6DXCG+1O4JKL
	i6YTLMSPaKHMr0mNdbAfg==
MIME-Version: 1.0
In-Reply-To: <1310393706-321-5-git-send-email-fweisbec@gmail.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com> <1310393706-321-5-git-send-email-fweisbec@gmail.com>
From: Paul Menage <menage@google.com>
Date: Mon, 25 Jul 2011 17:57:41 -0700
Message-ID: <CAJniumVhPWpzpoLmv6Owtr8iofkxxJ19Mwdx8iycF5D8TgvD_Q@mail.gmail.com>
Subject: Re: [PATCH 4/7] cgroups: New cancel_attach_task subsystem callback
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 7:15 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> To cancel a process attachment on a subsystem, we only call the
> cancel_attach() callback once on the leader but we have no
> way to cancel the attachment individually for each member of
> the process group.
>
> This is going to be needed for the max number of tasks susbystem
> that is coming.
>
> To prepare for this integration, call a new cancel_attach_task()
> callback on each task of the group until we reach the member that
> failed to attach.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Paul Menage <menage@google.com>


> Cc: Paul Menage <menage@google.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Aditya Kali <adityakali@google.com>
> ---
>  include/linux/cgroup.h |    1 +
>  kernel/cgroup.c        |   15 ++++++++++++---
>  2 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index e8288a0..94454143 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -472,6 +472,7 @@ struct cgroup_subsys {
>                               struct task_struct *tsk);
>        void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
>                              struct task_struct *tsk);
> +       void (*cancel_attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
>        void (*pre_attach)(struct cgroup *cgrp);
>        void (*attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp, struct task_struct *tsk);
>        void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c3ee4cf..210dc05 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1989,7 +1989,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  {
>        int retval, i, group_size;
>        struct cgroup_subsys *ss, *failed_ss = NULL;
> -       bool cancel_failed_ss = false;
> +       struct task_struct *failed_task = NULL;
>        /* guaranteed to be initialized later, but the compiler needs this */
>        struct cgroup *oldcgrp = NULL;
>        struct css_set *oldcg;
> @@ -2077,7 +2077,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>                                retval = ss->can_attach_task(cgrp, oldcgrp, tsk);
>                                if (retval) {
>                                        failed_ss = ss;
> -                                       cancel_failed_ss = true;
> +                                       failed_task = tsk;
>                                        goto out_cancel_attach;
>                                }
>                        }
> @@ -2172,8 +2172,17 @@ out_cancel_attach:
>        /* same deal as in cgroup_attach_task */
>        if (retval) {
>                for_each_subsys(root, ss) {
> +                       if (ss->cancel_attach_task && (ss != failed_ss || failed_task)) {
> +                               for (i = 0; i < group_size; i++) {
> +                                       tsk = flex_array_get_ptr(group, i);
> +                                       if (tsk == failed_task)
> +                                               break;
> +                                       ss->cancel_attach_task(cgrp, tsk);
> +                               }
> +                       }
> +
>                        if (ss == failed_ss) {
> -                               if (cancel_failed_ss && ss->cancel_attach)
> +                               if (failed_task && ss->cancel_attach)
>                                        ss->cancel_attach(ss, cgrp, leader);
>                                break;
>                        }
> --
> 1.7.5.4
>
>
