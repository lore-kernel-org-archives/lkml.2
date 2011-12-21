Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1LUNOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 08:14:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab1LUNO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 08:14:29 -0500
Date: Wed, 21 Dec 2011 14:08:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20111221130848.GA19679@redhat.com>
References: <20111221034334.GD17668@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221034334.GD17668@somewhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Frederic Weisbecker wrote:
> Hi,
>
> Starring at some parts of cgroups, I have a few questions:
>
> - Is cgroup_enable_task_cg_list()'s while_each_thread() safe
> against concurrent exec()? The leader may change in de_thread()
> and invalidate the test done in while_each_thread().

Yes. Oh, we need to do something with while_each_thread.

> - do_each_thread() also needs RCU and cgroup_enable_task_cg_list()
> seems to remind it. But it seems there is at least one caller that
> doesn't call rcu_read_lock(): update_cpu_mask() -> update_tasks_cpumask() -> cgroup_scan_tasks()

I don't see any caller which takes rcu_read_lock...

> - By the time we call cgroup_post_fork(), it is ready to be woken up
> and usable by the scheduler.

No, the new child can't run until do_fork()->wake_up_new_task().

> - Is the check for use_task_css_set_links in cgroup_post_fork() safe? given
> it is checked outside css_set_lock?
>
> Imagine this:
>
> CPU 0                                                        CPU 1
> ----                                                         -----
>
> cgroup_enable_task_cg() {
> 	uset_tasks_css_set_links = 1
> 	for_each_thread() {
> 		add tasks in the list
> 	}
> }
>                                                            do_fork() {
>                                                                cgroup_post_fork() {
>                                                                      use_tasks_css_set_links appears
>                                                                      to be equal to 0 due to write/read
>                                                                       not flushed. New task won't
>                                                                       appear to the list.

Yes, I was thinking about this too.

Or (I think) they can race "contrariwise". CPU_1 creates the new child,
then CPU_0 sets uset_tasks_css_set_links = 1. But afaics there is no any
guarantee that CPU_0 sees the result of list_add_tail_rcu().

Oleg.

