Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1ADVYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 16:24:03 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34001 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1ADVYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 16:24:01 -0500
Date: Tue, 4 Jan 2011 13:23:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] cgroups: fix incorrect using rcu_dereference()
 in cgroup_subsys_state()
Message-ID: <20110104212357.GU2026@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D22D7BE.4070702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D22D7BE.4070702@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 04:18:06PM +0800, Lai Jiangshan wrote:
> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Mon, 25 Aug 2008 11:05:28 +0800
> (Original) Subject: [PATCH] cgroup: fix wrong rcu_dereference()
> 
> It is tsk->cgroups which is protected by RCU, not ->subsys[subsys_id].
> 
> laijs: updated it(the surrounding code have been changed since these two years).

This looks plausible to me, assuming that the cgroups guys are OK with
it.

One requested change: could you please delete the rcu_read_lock_held()?
This is now implied by rcu_dereference_check().  With that:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index ed4ba11..a798814 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -535,10 +535,11 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
>   * cgroup_subsys::attach() methods.
>   */
>  #define task_subsys_state_check(task, subsys_id, __c)			\
> -	rcu_dereference_check(task->cgroups->subsys[subsys_id],		\
> +	rcu_dereference_check(task->cgroups,				\
>  			      rcu_read_lock_held() ||			\
>  			      lockdep_is_held(&task->alloc_lock) ||	\
> -			      cgroup_lock_is_held() || (__c))
> +			      cgroup_lock_is_held() ||			\
> +			      (__c))->subsys[subsys_id]
> 
>  static inline struct cgroup_subsys_state *
>  task_subsys_state(struct task_struct *task, int subsys_id)
