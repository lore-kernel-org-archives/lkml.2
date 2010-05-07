Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab0EGVHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:07:22 -0400
Received: from smtp-out.google.com ([74.125.121.35]:7658 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab0EGVHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:07:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=sUrVMKlntRC9DDfCz5q4ZgSt83NWN7K2fC+eSFGGsgPgTBrw+sEnkUFFeDrSP+v9o
	PBjiUtBe5FNXq0QB8Kq0A==
MIME-Version: 1.0
In-Reply-To: <l2pcc557aab1005070446y1f9c8169v58a3f7847676eaa@mail.gmail.com>
References: <l2pcc557aab1005070446y1f9c8169v58a3f7847676eaa@mail.gmail.com>
Date: Fri, 7 May 2010 14:07:13 -0700
Message-ID: <p2l6599ad831005071407yaa994357s1261317cc7f552b@mail.gmail.com>
Subject: Re: [PATCH] cgroups: make cftype.unregister_event() void-returning
From: Paul Menage <menage@google.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, containers@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like the principle. I think this patch leaks arrays, though.

I think the sequence:

register;register;unregister;unregister

will leak the array of size 2. Using the notation Ax, Bx, Cx, etc to
represent distinct buffers of size x, we have:

initially: size = 0, thresholds = NULL, spare = NULL
register: size = 1, thresholds = A1, spare = NULL
register: size = 2, thresholds = B2, spare = A1
unregister: size = 1, thresholds = A1, spare = B2
unregister: size = 0, thresholds = NULL, spare = A1 (B2 is leaked)

In the case when you're unregistering and the size goes down to 0, you
need to free the spare before doing the swap. Maybe get rid of the
thresholds_new local variable, and instead in the if(!size) {} branch
just free and the spare buffer and set its pointer to NULL? Then at
swap_buffers:, unconditionally swap the two.

Also, I think the code would be cleaner if you created a structure to
hold a primary threshold and its spare; then you could have one for
each threshold set, and just pass that to the register/unregister
functions, rather than them having to be aware of how the type maps to
the primary and backup array pointers.

Paul

On Fri, May 7, 2010 at 4:46 AM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> Since we unable to handle error returned by cftype.unregister_event()
> properly, let's make the callback void-returning.
>
> mem_cgroup_unregister_event() has been rewritten to be "never fail"
> function. On mem_cgroup_usage_register_event() we save old buffer
> for thresholds array and reuse it in mem_cgroup_usage_unregister_event()
> to avoid allocation.
>
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  include/linux/cgroup.h |    2 +-
>  kernel/cgroup.c        |    1 -
>  mm/memcontrol.c        |   64 ++++++++++++++++++++++++++++++------------------
>  3 files changed, 41 insertions(+), 26 deletions(-)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 8f78073..0c62160 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -397,7 +397,7 @@ struct cftype {
>         * This callback must be implemented, if you want provide
>         * notification functionality.
>         */
> -       int (*unregister_event)(struct cgroup *cgrp, struct cftype *cft,
> +       void (*unregister_event)(struct cgroup *cgrp, struct cftype *cft,
>                        struct eventfd_ctx *eventfd);
>  };
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 06dbf97..6675e8c 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2988,7 +2988,6 @@ static void cgroup_event_remove(struct work_struct *work)
>                        remove);
>        struct cgroup *cgrp = event->cgrp;
>
> -       /* TODO: check return code */
>        event->cft->unregister_event(cgrp, event->cft, event->eventfd);
>
>        eventfd_ctx_put(event->eventfd);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8cb2722..0a37b5d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -226,9 +226,19 @@ struct mem_cgroup {
>        /* thresholds for memory usage. RCU-protected */
>        struct mem_cgroup_threshold_ary *thresholds;
>
> +       /*
> +        * Preallocated buffer to be used in mem_cgroup_unregister_event()
> +        * to make it "never fail".
> +        * It must be able to store at least thresholds->size - 1 entries.
> +        */
> +       struct mem_cgroup_threshold_ary *__thresholds;
> +
>        /* thresholds for mem+swap usage. RCU-protected */
>        struct mem_cgroup_threshold_ary *memsw_thresholds;
>
> +       /* the same as __thresholds, but for memsw_thresholds */
> +       struct mem_cgroup_threshold_ary *__memsw_thresholds;
> +
>        /* For oom notifier event fd */
>        struct list_head oom_notify;
>
> @@ -3575,17 +3585,27 @@ static int
> mem_cgroup_usage_register_event(struct cgroup *cgrp,
>        else
>                rcu_assign_pointer(memcg->memsw_thresholds, thresholds_new);
>
> -       /* To be sure that nobody uses thresholds before freeing it */
> +       /* To be sure that nobody uses thresholds */
>        synchronize_rcu();
>
> -       kfree(thresholds);
> +       /*
> +        * Free old preallocated buffer and use thresholds as new
> +        * preallocated buffer.
> +        */
> +       if (type == _MEM) {
> +               kfree(memcg->__thresholds);
> +               memcg->__thresholds = thresholds;
> +       } else {
> +               kfree(memcg->__memsw_thresholds);
> +               memcg->__memsw_thresholds = thresholds;
> +       }
>  unlock:
>        mutex_unlock(&memcg->thresholds_lock);
>
>        return ret;
>  }
>
> -static int mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
> +static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
>        struct cftype *cft, struct eventfd_ctx *eventfd)
>  {
>        struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> @@ -3593,7 +3613,7 @@ static int
> mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
>        int type = MEMFILE_TYPE(cft->private);
>        u64 usage;
>        int size = 0;
> -       int i, j, ret = 0;
> +       int i, j;
>
>        mutex_lock(&memcg->thresholds_lock);
>        if (type == _MEM)
> @@ -3623,17 +3643,15 @@ static int
> mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
>        /* Set thresholds array to NULL if we don't have thresholds */
>        if (!size) {
>                thresholds_new = NULL;
> -               goto assign;
> +               goto swap_buffers;
>        }
>
> -       /* Allocate memory for new array of thresholds */
> -       thresholds_new = kmalloc(sizeof(*thresholds_new) +
> -                       size * sizeof(struct mem_cgroup_threshold),
> -                       GFP_KERNEL);
> -       if (!thresholds_new) {
> -               ret = -ENOMEM;
> -               goto unlock;
> -       }
> +       /* Use preallocated buffer for new array of thresholds */
> +       if (type == _MEM)
> +               thresholds_new = memcg->__thresholds;
> +       else
> +               thresholds_new = memcg->__memsw_thresholds;
> +
>        thresholds_new->size = size;
>
>        /* Copy thresholds and find current threshold */
> @@ -3654,20 +3672,20 @@ static int
> mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
>                j++;
>        }
>
> -assign:
> -       if (type == _MEM)
> +swap_buffers:
> +       /* Swap thresholds array and preallocated buffer */
> +       if (type == _MEM) {
> +               memcg->__thresholds = thresholds;
>                rcu_assign_pointer(memcg->thresholds, thresholds_new);
> -       else
> +       } else {
> +               memcg->__memsw_thresholds = thresholds;
>                rcu_assign_pointer(memcg->memsw_thresholds, thresholds_new);
> +       }
>
> -       /* To be sure that nobody uses thresholds before freeing it */
> +       /* To be sure that nobody uses thresholds */
>        synchronize_rcu();
>
> -       kfree(thresholds);
> -unlock:
>        mutex_unlock(&memcg->thresholds_lock);
> -
> -       return ret;
>  }
>
>  static int mem_cgroup_oom_register_event(struct cgroup *cgrp,
> @@ -3695,7 +3713,7 @@ static int mem_cgroup_oom_register_event(struct
> cgroup *cgrp,
>        return 0;
>  }
>
> -static int mem_cgroup_oom_unregister_event(struct cgroup *cgrp,
> +static void mem_cgroup_oom_unregister_event(struct cgroup *cgrp,
>        struct cftype *cft, struct eventfd_ctx *eventfd)
>  {
>        struct mem_cgroup *mem = mem_cgroup_from_cont(cgrp);
> @@ -3714,8 +3732,6 @@ static int
> mem_cgroup_oom_unregister_event(struct cgroup *cgrp,
>        }
>
>        mutex_unlock(&memcg_oom_mutex);
> -
> -       return 0;
>  }
>
>  static int mem_cgroup_oom_control_read(struct cgroup *cgrp,
> --
> 1.7.0.4
>
