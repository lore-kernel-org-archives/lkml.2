Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1BQXqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:46:46 -0500
Received: from smtp-out.google.com ([216.239.44.51]:47127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1BQXqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:46:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NzXP4+0rwH+E4ljsA8/3WTawrAXsTjfuY141cTvuJzS9iYn334SOW4JQv0MF2O+Tx5
         K5/EKO5LAgBKsSpdbfOQ==
MIME-Version: 1.0
In-Reply-To: <4D5C7EBF.2070603@cn.fujitsu.com>
References: <4D5C7EA7.1030409@cn.fujitsu.com> <4D5C7EBF.2070603@cn.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Thu, 17 Feb 2011 15:46:19 -0800
Message-ID: <AANLkTimRH=LVRLnajbtL3a8FwKkbEfLspAHXXeQLUY8=@mail.gmail.com>
Subject: Re: [PATCH 2/4] cpuset: Remove unneeded NODEMASK_ALLOC() in cpuset_attch()
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 5:49 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> oldcs->mems_allowed is not modified during cpuset_attch(), so
> we don't have to copy it to a buffer allocated by NODEMASK_ALLOC().
> Just pass it to cpuset_migrate_mm().
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I'd be inclined to skip this one - we're already allocating one
nodemask, so one more isn't really any extra complexity, and we're
doing horrendously complicated stuff in cpuset_migrate_mm() that's
much more likely to fail in low-memory situations.

It's true that mems_allowed can't change during the call to
cpuset_attach(), but that's due to the fact that both cgroup_attach()
and the cpuset.mems write paths take cgroup_mutex. I might prefer to
leave the allocated nodemask here and wrap callback_mutex around the
places in cpuset_attach() where we're reading from a cpuset's
mems_allowed - that would remove the implicit synchronization via
cgroup_mutex and leave the code a little more understandable.

> ---
>  kernel/cpuset.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index f13ff2e..70c9ca2 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1438,10 +1438,9 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>        struct mm_struct *mm;
>        struct cpuset *cs = cgroup_cs(cont);
>        struct cpuset *oldcs = cgroup_cs(oldcont);
> -       NODEMASK_ALLOC(nodemask_t, from, GFP_KERNEL);
>        NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
>
> -       if (from == NULL || to == NULL)
> +       if (to == NULL)
>                goto alloc_fail;
>
>        if (cs == &top_cpuset) {
> @@ -1463,18 +1462,16 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>        }
>
>        /* change mm; only needs to be done once even if threadgroup */
> -       *from = oldcs->mems_allowed;
>        *to = cs->mems_allowed;
>        mm = get_task_mm(tsk);
>        if (mm) {
>                mpol_rebind_mm(mm, to);
>                if (is_memory_migrate(cs))
> -                       cpuset_migrate_mm(mm, from, to);
> +                       cpuset_migrate_mm(mm, &oldcs->mems_allowed, to);
>                mmput(mm);
>        }
>
>  alloc_fail:
> -       NODEMASK_FREE(from);
>        NODEMASK_FREE(to);
>  }
>
> --
> 1.7.3.1
>
