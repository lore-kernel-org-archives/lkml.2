Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0DVM2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 08:28:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:41988 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab0DVM2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 08:28:06 -0400
Subject: Re: [PATCH 4/5] freezer cgroup: Fix an RCU warning in
 cgroup_freezing_or_frozen()
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <4BD01768.2020606@cn.fujitsu.com>
References: <4BD016F4.8060108@cn.fujitsu.com>
	 <4BD01768.2020606@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 14:27:55 +0200
Message-ID: <1271939275.1776.345.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 17:31 +0800, Li Zefan wrote:
> with CONFIG_PROVE_RCU, a warning can be triggered when we
> resume from suspend:
> 
> ...
> include/linux/cgroup.h:533 invoked rcu_dereference_check() without protection!
> ...
> 
> task_freezer() calls task_subsys_state(), which needs to be
> protected by rcu_read_lock or cgroup_mutex.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup_freezer.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index 5038f4c..ac76983 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -53,6 +53,7 @@ int cgroup_freezing_or_frozen(struct task_struct *task)
>  	struct freezer *freezer;
>  	enum freezer_state state;
>  
> +	rcu_read_lock();
>  	task_lock(task);
>  	freezer = task_freezer(task);
>  	if (!freezer->css.cgroup->parent)
> @@ -60,6 +61,7 @@ int cgroup_freezing_or_frozen(struct task_struct *task)
>  	else
>  		state = freezer->state;
>  	task_unlock(task);
> +	rcu_read_unlock();
>  
>  	return (state == CGROUP_FREEZING) || (state == CGROUP_FROZEN);
>  }

Hmm cgroup_attach_task() does hold task_lock() over setting
tsk->cgroups, so doesn't that also pin the task to the cgroup and thus
the cgroup itself?

