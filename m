Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab1JSFn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 01:43:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50702 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab1JSFnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 01:43:55 -0400
MIME-Version: 1.0
In-Reply-To: <20111014003601.GC22527@ghc17.ghc.andrew.cmu.edu>
References: <20110727171101.5e32d8eb@notabene.brown> <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com> <20110728110813.7ff84b13@notabene.brown>
 <20110728062616.GC15204@unix33.andrew.cmu.edu> <20110728171345.67d3797d@notabene.brown>
 <20110729142842.GA8462@unix33.andrew.cmu.edu> <20110815184957.GA16588@redhat.com>
 <20111014003601.GC22527@ghc17.ghc.andrew.cmu.edu>
From: Paul Menage <paul@paulmenage.org>
Date: Tue, 18 Oct 2011 22:43:35 -0700
X-Google-Sender-Auth: VKbgYTdaFhPOwd4fpFWu6Bf2AI8
Message-ID: <CALdu-PDVh+JDqaVs1Ps6qxwZdXiTkrs-NJSP5uHnokiGvAYKZA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cgroups: convert ss->attach to use whole threadgroup
 flex_array (cpuset, memcontrol)
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        paulmck@linux.vnet.ibm.com, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 5:36 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> Convert ss->attach to take a flex_array of tasks instead of just the leader.
>
> From: Ben Blum <bblum@andrew.cmu.edu>
>
> This lets subsystems with whole-threadgroup attach calls (i.e., cpuset and
> memcontrol) to accurately find the group's mm even when a non-leader does exec
> and leaves the leader with a NULL mm pointer.
>
> Also converts cpuset and memcontrol to take the flex_array and iterate down it
> until an mm is found, instead of just attempting to use the leader's mm.
>
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

Reviewed-by: Paul Menage <paul@paulmenage.org>

Thanks,
Paul

> ---
>  Documentation/cgroups/cgroups.txt |    7 ++++++-
>  include/linux/cgroup.h            |    4 +++-
>  kernel/cgroup.c                   |   16 +++++++++++++---
>  kernel/cpuset.c                   |   16 ++++++++++++++--
>  mm/memcontrol.c                   |   17 +++++++++++++++--
>  5 files changed, 51 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> index 3fa646f..8e900ec 100644
> --- a/Documentation/cgroups/cgroups.txt
> +++ b/Documentation/cgroups/cgroups.txt
> @@ -637,12 +637,17 @@ For any non-per-thread attachment work that needs to happen before
>  attach_task. Needed by cpuset.
>
>  void attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
> -           struct cgroup *old_cgrp, struct task_struct *task)
> +           struct cgroup *old_cgrp, struct flex_array *group,
> +           int group_size)

Maybe flex_array should have a size field, so that you can just pass a
single pointer here?

> @@ -1452,7 +1455,16 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>         */
>        cpuset_attach_nodemask_from = oldcs->mems_allowed;
>        cpuset_attach_nodemask_to = cs->mems_allowed;
> -       mm = get_task_mm(tsk);
> +       /*
> +        * Find the first task in the group that still has its mm. (This could
> +        * be not the first one if another did exec() and the leader exited.

Maybe rephrase this as "This might not be the first one"?

Paul
