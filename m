Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab1I3WbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 18:31:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44743 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab1I3Waw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 18:30:52 -0400
Date: Fri, 30 Sep 2011 15:30:49 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>,
        container ML <containers@lists.linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Miao Xie <miaox@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [BUGFIX] cgroup: create a workqueue for cgroup
Message-Id: <20110930153049.6719a14e.akpm00@gmail.com>
In-Reply-To: <20110930165452.19c0fdf4.nishimura@mxp.nes.nec.co.jp>
References: <20110930165452.19c0fdf4.nishimura@mxp.nes.nec.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011 16:54:52 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> In commit:f90d4118, cpuset_wq, a separate workqueue for cpuset, was introduced
> to avoid a dead lock against cgroup_mutex between async_rebuild_sched_domains()
> and cgroup_tasks_write().
> 
> But check_for_release() has a similar problem:
> 
>   check_for_release()
>     schedule_work(release_agent_work)
>       cgroup_release_agent()
>         mutex_lock(&cgroup_mutex)
> 
> And I actually see a lockup which seems to be caused by this problem
> on 2.6.32-131.0.15.el6.x86_64.

Are you sure the bug is still present in current kernels?  Perhaps
Tejun's workqueue changes magically made it go away.

>
> ...
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -27,6 +27,8 @@ struct css_id;
>  
>  extern int cgroup_init_early(void);
>  extern int cgroup_init(void);
> +extern void cgroup_wq_init(void);
> +extern void queue_cgroup_work(struct work_struct *work);
>  extern void cgroup_lock(void);
>  extern int cgroup_lock_is_held(void);
>  extern bool cgroup_lock_live_group(struct cgroup *cgrp);

Can we spot the odd man out?

I shall rename queue_cgroup_work() to cgroup_queue_work().

>
> ...
>
