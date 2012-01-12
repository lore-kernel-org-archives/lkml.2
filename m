Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2ALO6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:58:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab2ALO6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:58:00 -0500
Date: Thu, 12 Jan 2012 15:50:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using
	BPF
Message-ID: <20120112145040.GA19472@redhat.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org> <1326302710-9427-2-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326302710-9427-2-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, Will Drewry wrote:
>
> This patch adds support for seccomp mode 2.  This mode enables dynamic
> enforcement of system call filtering policy in the kernel as specified
> by a userland task.  The policy is expressed in terms of a BPF program,
> as is used for userland-exposed socket filtering.  Instead of network
> data, the BPF program is evaluated over struct user_regs_struct at the
> time of the system call (as retrieved using regviews).

Cool ;)

I didn't really read this patch yet, just one nit.

> +#define seccomp_filter_init_task(_tsk) do { \
> +	(_tsk)->seccomp.filter = NULL; \
> +} while (0);

Cosmetic and subjective, but imho it would be better to add inline
functions instead of define's.

> @@ -166,6 +167,7 @@ void free_task(struct task_struct *tsk)
>  	free_thread_info(tsk->stack);
>  	rt_mutex_debug_task_free(tsk);
>  	ftrace_graph_exit_task(tsk);
> +	seccomp_filter_free_task(tsk);
>  	free_task_struct(tsk);
>  }
>  EXPORT_SYMBOL(free_task);
> @@ -1209,6 +1211,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	/* Perform scheduler related setup. Assign this task to a CPU. */
>  	sched_fork(p);
>  
> +	seccomp_filter_init_task(p);

This doesn't look right or I missed something. something seccomp_filter_init_task()
should be called right after dup_task_struct(), at least before copy process can
fail.

Otherwise copy_process()->free_fork()->seccomp_filter_free_task() can put
current->seccomp.filter copied by arch_dup_task_struct().

> +struct seccomp_filter {
> +	struct kref usage;
> +	struct pid *creator;

Why? seccomp_filter->creator is never used, no?

Oleg.

