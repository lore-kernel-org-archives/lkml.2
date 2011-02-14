Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1BNEd3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 23:33:29 -0500
Received: from smtp-out.google.com ([74.125.121.67]:1613 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1BNEdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 23:33:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=G5KBXY4p7H2wByVydjePU+FQhn0eY5DZmR1rJU5q5+X7T8xgMj2VI11PuyM4lQXdPj
         KR/DSKU1g68nfy18C8iA==
MIME-Version: 1.0
In-Reply-To: <1297160655.13327.92.camel@laptop>
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>
 <1295534345.28776.175.camel@laptop> <1296646160.26581.315.camel@laptop>
 <20110202115012.GA16409@balbir.in.ibm.com> <1296650792.26581.319.camel@laptop>
 <20110202190251.GB16409@balbir.in.ibm.com> <1297095033.13327.46.camel@laptop>
 <AANLkTimF+8XAZxF4psrXSKx1CHFxin6AW=tu5OLGUgNi@mail.gmail.com>
 <1297108959.13327.54.camel@laptop> <AANLkTikWS86TPjp+J=iiwCQJ56pqYTQo8Z9_V20GEcEz@mail.gmail.com>
 <1297160655.13327.92.camel@laptop>
From: Paul Menage <menage@google.com>
Date: Sun, 13 Feb 2011 20:32:58 -0800
Message-ID: <AANLkTikBEbAhN_0SSz76SMewuUueOrE7K7cYr=zS3DB0@mail.gmail.com>
Subject: Re: [RFC][PATCH] cgroup: Fix cgroup_subsys::exit callback
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbir@linux.vnet.ibm.com, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 2:24 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> And here I thought Google was starting to understand what community
> participation meant.. is there anybody you know who can play a more
> active role in the whole cgroup thing?

Google has plenty of people actively working on various aspects of
cgroups (particularly memory and I/O scheduling) in mainline. There's
no one tasked with core cgroups framework maintenance, but there are
folks from Fujitsu and IBM (Li Zefan, Balbir Singh, etc) who have more
experience and state in the core framework than anyone else in Google
anyway.

>
> Like the below? Both the perf and sched exit callback are fine with
> being called under task_lock afaict, but I haven't actually ran with

Sounds good to me.

Acked-by: Paul Menage <menage@google.com>

> lockdep enabled to see if I missed something.
>
> I also pondered doing the cgroup exit from __put_task_struct() but that
> had another problem iirc.

My guess is that by that time, so much of the task's context has been
destroyed that it comes too late in the tear-down for some/many
subsystems? Proving that guess either true or false (for all current
and future potential subsystems) would probably be tricky, though.

>
> ---
> Index: linux-2.6/include/linux/cgroup.h
> ===================================================================
> --- linux-2.6.orig/include/linux/cgroup.h
> +++ linux-2.6/include/linux/cgroup.h
> @@ -474,7 +474,8 @@ struct cgroup_subsys {
>                        struct cgroup *old_cgrp, struct task_struct *tsk,
>                        bool threadgroup);
>        void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
> -       void (*exit)(struct cgroup_subsys *ss, struct task_struct *task);
> +       void (*exit)(struct cgroup_subsys *ss, struct cgroup *cgrp,
> +                       struct cgroup *old_cgrp, struct task_struct *task);
>        int (*populate)(struct cgroup_subsys *ss,
>                        struct cgroup *cgrp);
>        void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
> Index: linux-2.6/kernel/cgroup.c
> ===================================================================

Probably also worth including a note in the docs:

--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -602,6 +602,7 @@ void fork(struct cgroup_subsy *ss, struct task_struct *task)
 Called when a task is forked into a cgroup.

 void exit(struct cgroup_subsys *ss, struct task_struct *task)
+(task->alloc_lock held by caller)

 Called during task exit.


> --- linux-2.6.orig/kernel/cgroup.c
> +++ linux-2.6/kernel/cgroup.c
> @@ -4230,20 +4230,8 @@ void cgroup_post_fork(struct task_struct
>  */
>  void cgroup_exit(struct task_struct *tsk, int run_callbacks)
>  {
> -       int i;
>        struct css_set *cg;
> -
> -       if (run_callbacks && need_forkexit_callback) {
> -               /*
> -                * modular subsystems can't use callbacks, so no need to lock
> -                * the subsys array
> -                */
> -               for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
> -                       struct cgroup_subsys *ss = subsys[i];
> -                       if (ss->exit)
> -                               ss->exit(ss, tsk);
> -               }
> -       }
> +       int i;
>
>        /*
>         * Unlink from the css_set task list if necessary.
> @@ -4261,7 +4249,24 @@ void cgroup_exit(struct task_struct *tsk
>        task_lock(tsk);
>        cg = tsk->cgroups;
>        tsk->cgroups = &init_css_set;
> +
> +       if (run_callbacks && need_forkexit_callback) {
> +               /*
> +                * modular subsystems can't use callbacks, so no need to lock
> +                * the subsys array
> +                */
> +               for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
> +                       struct cgroup_subsys *ss = subsys[i];
> +                       if (ss->exit) {
> +                               struct cgroup *old_cgrp =
> +                                       rcu_dereference_raw(cg->subsys[i])->cgroup;
> +                               struct cgroup *cgrp = task_cgroup(tsk, i);
> +                               ss->exit(ss, cgrp, old_cgrp, tsk);
> +                       }
> +               }
> +       }
>        task_unlock(tsk);
> +
>        if (cg)
>                put_css_set_taskexit(cg);
>  }
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -606,9 +606,6 @@ static inline struct task_group *task_gr
>        struct task_group *tg;
>        struct cgroup_subsys_state *css;
>
> -       if (p->flags & PF_EXITING)
> -               return &root_task_group;
> -
>        css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
>                        lockdep_is_held(&task_rq(p)->lock));
>        tg = container_of(css, struct task_group, css);
> @@ -9081,7 +9078,8 @@ cpu_cgroup_attach(struct cgroup_subsys *
>  }
>
>  static void
> -cpu_cgroup_exit(struct cgroup_subsys *ss, struct task_struct *task)
> +cpu_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
> +               struct cgroup *old_cgrp, struct task_struct *task)
>  {
>        /*
>         * cgroup_exit() is called in the copy_process() failure path.
>
>
>
