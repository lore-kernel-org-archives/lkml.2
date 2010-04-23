Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab0DWEKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 00:10:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38448 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab0DWEKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 00:10:06 -0400
Date: Thu, 22 Apr 2010 21:10:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Lai JIangshan <laijs@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup: Check task_lock in task_subsys_state()
Message-ID: <20100423041003.GC2619@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BD10788.8060006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD10788.8060006@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 10:35:52AM +0800, Li Zefan wrote:
> task_subsys_state() is safe under task_lock(). See
> Documentation/cgroups/cgroups.txt for locking rule.
> 
> This fixes an RCU warning when resume from suspend. The
> warning comes from freezer cgroup in cgroup_freezing_or_frozen().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
> 
> I'm not sure which is preferable - access ->alloc_lock directly
> like this patch or add task_lock_is_held() in sched.h

This is for the maintainers to decide, either way works from my viewpoint.

I have queued it as is with Matt's Acked-by, and am testing it.  Thank you!!!

							Thanx, Paul

> ---
>  include/linux/cgroup.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index b8ad1ea..8f78073 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -530,6 +530,7 @@ static inline struct cgroup_subsys_state *task_subsys_state(
>  {
>  	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
>  				     rcu_read_lock_held() ||
> +				     lockdep_is_held(&task->alloc_lock) ||
>  				     cgroup_lock_is_held());
>  }
> 
> -- 
> 1.6.3
