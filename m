Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1HATca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 15:32:30 -0400
Received: from smtp-out.google.com ([74.125.121.67]:63357 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab1HATcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 15:32:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=w/L/S5A1eiJubRjEPP4y0MK0cwA8F8lkyP9DzsH5G6gGD9Aze1i8T4kXW0xZ4Tm6b
	tDL4zyFPju9u5OfLU+p7w==
MIME-Version: 1.0
In-Reply-To: <20110729142842.GA8462@unix33.andrew.cmu.edu>
References: <20110727171101.5e32d8eb@notabene.brown> <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com> <20110728110813.7ff84b13@notabene.brown>
 <20110728062616.GC15204@unix33.andrew.cmu.edu> <20110728171345.67d3797d@notabene.brown>
 <20110729142842.GA8462@unix33.andrew.cmu.edu>
From: Paul Menage <menage@google.com>
Date: Mon, 1 Aug 2011 12:31:59 -0700
Message-ID: <CAJniumX+L5bXoXNXTppcDTtG5gHee=_Vk=h5EuOUBnpLQYDY2Q@mail.gmail.com>
Subject: Re: [PATCH][BUGFIX] cgroups: more safe tasklist locking in cgroup_attach_proc
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: NeilBrown <neilb@suse.de>, paulmck@linux.vnet.ibm.com,
        Li Zefan <lizf@cn.fujitsu.com>, Oleg Nesterov <oleg@tv-sign.ru>,
        containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 7:28 AM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> Fix unstable tasklist locking in cgroup_attach_proc.
>
> From: Ben Blum <bblum@andrew.cmu.edu>
>
> According to this thread - https://lkml.org/lkml/2011/7/27/243 - RCU is
> not sufficient to guarantee the tasklist is stable w.r.t. de_thread and
> exit. Taking tasklist_lock for reading, instead of rcu_read_lock,
> ensures proper exclusion.
>
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

Acked-by: Paul Menage <menage@google.com>

Thanks,
Paul

> ---
>  kernel/cgroup.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff a/kernel/cgroup.c b/kernel/cgroup.c
> --- a/kernel/cgroup.c   2011-07-21 19:17:23.000000000 -0700
> +++ b/kernel/cgroup.c   2011-07-29 06:17:47.000000000 -0700
> @@ -2024,7 +2024,7 @@
>                goto out_free_group_list;
>
>        /* prevent changes to the threadgroup list while we take a snapshot. */
> -       rcu_read_lock();
> +       read_lock(&tasklist_lock);
>        if (!thread_group_leader(leader)) {
>                /*
>                 * a race with de_thread from another thread's exec() may strip
> @@ -2033,7 +2033,7 @@
>                 * throw this task away and try again (from cgroup_procs_write);
>                 * this is "double-double-toil-and-trouble-check locking".
>                 */
> -               rcu_read_unlock();
> +               read_unlock(&tasklist_lock);
>                retval = -EAGAIN;
>                goto out_free_group_list;
>        }
> @@ -2054,7 +2054,7 @@
>        } while_each_thread(leader, tsk);
>        /* remember the number of threads in the array for later. */
>        group_size = i;
> -       rcu_read_unlock();
> +       read_unlock(&tasklist_lock);
>
>        /*
>         * step 1: check that we can legitimately attach to the cgroup.
>
