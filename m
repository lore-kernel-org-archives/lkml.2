Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab1CCSjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:39:23 -0500
Received: from smtp-out.google.com ([216.239.44.51]:25973 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1CCSjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:39:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JOmUZ9Jdh8ZPs1tMqzBarQJplsRMnadc6/mPNxlQ+yhBhJkIFDgb9qEGC5g0wFbLP2
         zdRp5T7HJXBAAGE+ZfnA==
MIME-Version: 1.0
In-Reply-To: <20110208013950.GF31569@ghc17.ghc.andrew.cmu.edu>
References: <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu> <20110208013950.GF31569@ghc17.ghc.andrew.cmu.edu>
From: Paul Menage <menage@google.com>
Date: Thu, 3 Mar 2011 10:38:58 -0800
Message-ID: <AANLkTinEnNsu8=PEktXL_EECzGYqsgdf+uogGxe7k4W+@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] cgroups: make procs file writable
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
        matthltc@us.ibm.com, oleg@redhat.com,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 5:39 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> Makes procs file writable to move all threads by tgid at once
>
> From: Ben Blum <bblum@andrew.cmu.edu>
>
> This patch adds functionality that enables users to move all threads in a
> threadgroup at once to a cgroup by writing the tgid to the 'cgroup.procs'
> file. This current implementation makes use of a per-threadgroup rwsem that's
> taken for reading in the fork() path to prevent newly forking threads within
> the threadgroup from "escaping" while the move is in progress.
>
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
> ---
> +       /* remember the number of threads in the array for later. */
> +       BUG_ON(i == 0);

This BUG_ON() seems unnecessary, given the i++ directly above it.

> +       group_size = i;
> +       rcu_read_unlock();
> +
> +       /*
> +        * step 1: check that we can legitimately attach to the cgroup.
> +        */
> +       for_each_subsys(root, ss) {
> +               if (ss->can_attach) {
> +                       retval = ss->can_attach(ss, cgrp, leader);
> +                       if (retval) {
> +                               failed_ss = ss;
> +                               goto out_cancel_attach;
> +                       }
> +               }
> +               /* a callback to be run on every thread in the threadgroup. */
> +               if (ss->can_attach_task) {
> +                       /* run on each task in the threadgroup. */
> +                       for (i = 0; i < group_size; i++) {
> +                               retval = ss->can_attach_task(cgrp, group[i]);
> +                               if (retval) {
> +                                       failed_ss = ss;

Should we be setting failed_ss here? Doesn't that mean that if all
subsystems pass the can_attach() check but the first one fails a
can_attach_task() check, we don't call any cancel_attach() methods?

What are the rollback semantics for failing a can_attach_task() check?

> +               if (threadgroup) {
> +                       /*
> +                        * it is safe to find group_leader because tsk was found
> +                        * in the tid map, meaning it can't have been unhashed
> +                        * by someone in de_thread changing the leadership.
> +                        */
> +                       tsk = tsk->group_leader;
> +                       BUG_ON(!thread_group_leader(tsk));

Can this race with an exiting/execing group leader?

> +               } else if (tsk->flags & PF_EXITING) {

The check for PF_EXITING doesn't apply to group leaders?

> +                       /* optimization for the single-task-only case */
> +                       rcu_read_unlock();
> +                       cgroup_unlock();
>                        return -ESRCH;
>                }
>
> +               /*
> +                * even if we're attaching all tasks in the thread group, we
> +                * only need to check permissions on one of them.
> +                */
>                tcred = __task_cred(tsk);
>                if (cred->euid &&
>                    cred->euid != tcred->uid &&
>                    cred->euid != tcred->suid) {
>                        rcu_read_unlock();
> +                       cgroup_unlock();
>                        return -EACCES;

Maybe turn these returns into "goto out;" statements and put the
unlock after the out: label?
