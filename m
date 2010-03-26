Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab0CZPvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:51:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62518 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0CZPvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:51:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T+AR08e/c6ZiSMB9tzR9kEbhcNibQPNSlnIVXYm5Q3/4G6BnWJ4uPx8a+1f8zOvUfG
         zTspk5I7ZD/ThSH7Y0aExqYfpEyKNf5lJT5VSiaWpSasyD41ZeLd2EMbUJ6yitrACrQO
         3jBk9qK2Mx2+e6OlJaRUrkSSmikwzOuuikgHs=
MIME-Version: 1.0
In-Reply-To: <4BA9A05F.7010407@cn.fujitsu.com>
References: <4BA9A05F.7010407@cn.fujitsu.com>
Date: Fri, 26 Mar 2010 16:51:02 +0100
Message-ID: <8aa016e11003260851j78da1a74i85cd5fb2ab2defac@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: Remove remaining USER_SCHED code
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 6:17 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> This is left over from commit 7c9414385e ("sched: Remove USER_SCHED"")
>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks for catching it.

Ack for the user.c segments

> ---
>  init/Kconfig            |    3 +--
>  kernel/capability.c     |    1 -
>  kernel/cred-internals.h |   21 ---------------------
>  kernel/cred.c           |    3 ---
>  kernel/exit.c           |    1 -
>  kernel/sched_debug.c    |    5 -----
>  kernel/user.c           |   10 +---------
>  7 files changed, 2 insertions(+), 42 deletions(-)
>  delete mode 100644 kernel/cred-internals.h
>
> diff --git a/init/Kconfig b/init/Kconfig
> index c6c8903..f173018 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -604,8 +604,7 @@ config RT_GROUP_SCHED
>        default n
>        help
>          This feature lets you explicitly allocate real CPU bandwidth
> -         to users or control groups (depending on the "Basis for grouping tasks"
> -         setting below. If enabled, it will also make it impossible to
> +         to task groups. If enabled, it will also make it impossible to
>          schedule realtime tasks for non-root users until you allocate
>          realtime bandwidth for them.
>          See Documentation/scheduler/sched-rt-group.txt for more information.
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 9e4697e..2f05303 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -15,7 +15,6 @@
>  #include <linux/syscalls.h>
>  #include <linux/pid_namespace.h>
>  #include <asm/uaccess.h>
> -#include "cred-internals.h"
>
>  /*
>  * Leveraged for setting/resetting capabilities
> diff --git a/kernel/cred-internals.h b/kernel/cred-internals.h
> deleted file mode 100644
> index 2dc4fc2..0000000
> --- a/kernel/cred-internals.h
> +++ /dev/null
> @@ -1,21 +0,0 @@
> -/* Internal credentials stuff
> - *
> - * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
> - * Written by David Howells (dhowells@redhat.com)
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public Licence
> - * as published by the Free Software Foundation; either version
> - * 2 of the Licence, or (at your option) any later version.
> - */
> -
> -/*
> - * user.c
> - */
> -static inline void sched_switch_user(struct task_struct *p)
> -{
> -#ifdef CONFIG_USER_SCHED
> -       sched_move_task(p);
> -#endif /* CONFIG_USER_SCHED */
> -}
> -
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 1ed8ca1..69a4da6 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -16,7 +16,6 @@
>  #include <linux/init_task.h>
>  #include <linux/security.h>
>  #include <linux/cn_proc.h>
> -#include "cred-internals.h"
>
>  #if 0
>  #define kdebug(FMT, ...) \
> @@ -553,8 +552,6 @@ int commit_creds(struct cred *new)
>                atomic_dec(&old->user->processes);
>        alter_cred_subscribers(old, -2);
>
> -       sched_switch_user(task);
> -
>        /* send notifications */
>        if (new->uid   != old->uid  ||
>            new->euid  != old->euid ||
> diff --git a/kernel/exit.c b/kernel/exit.c
> index cce59cb..84dc4b2 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -55,7 +55,6 @@
>  #include <asm/unistd.h>
>  #include <asm/pgtable.h>
>  #include <asm/mmu_context.h>
> -#include "cred-internals.h"
>
>  static void exit_mm(struct task_struct * tsk);
>
> diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
> index 8a46a71..0932c5c 100644
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -173,11 +173,6 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>        task_group_path(tg, path, sizeof(path));
>
>        SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
> -#elif defined(CONFIG_USER_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
> -       {
> -               uid_t uid = cfs_rq->tg->uid;
> -               SEQ_printf(m, "\ncfs_rq[%d] for UID: %u\n", cpu, uid);
> -       }
>  #else
>        SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
>  #endif
> diff --git a/kernel/user.c b/kernel/user.c
> index ec3b222..8e1c8c0 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -16,7 +16,6 @@
>  #include <linux/interrupt.h>
>  #include <linux/module.h>
>  #include <linux/user_namespace.h>
> -#include "cred-internals.h"
>
>  struct user_namespace init_user_ns = {
>        .kref = {
> @@ -137,9 +136,7 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
>        struct hlist_head *hashent = uidhashentry(ns, uid);
>        struct user_struct *up, *new;
>
> -       /* Make uid_hash_find() + uids_user_create() + uid_hash_insert()
> -        * atomic.
> -        */
> +       /* Make uid_hash_find() + uid_hash_insert() atomic. */
>        spin_lock_irq(&uidhash_lock);
>        up = uid_hash_find(uid, hashent);
>        spin_unlock_irq(&uidhash_lock);
> @@ -161,11 +158,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
>                spin_lock_irq(&uidhash_lock);
>                up = uid_hash_find(uid, hashent);
>                if (up) {
> -                       /* This case is not possible when CONFIG_USER_SCHED
> -                        * is defined, since we serialize alloc_uid() using
> -                        * uids_mutex. Hence no need to call
> -                        * sched_destroy_user() or remove_user_sysfs_dir().
> -                        */
>                        key_put(new->uid_keyring);
>                        key_put(new->session_keyring);
>                        kmem_cache_free(uid_cachep, new);
> --
> 1.6.3
>
>
