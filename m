Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1LUDno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 22:43:44 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:33448 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1LUDnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 22:43:41 -0500
Date: Wed, 21 Dec 2011 04:43:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20111221034334.GD17668@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Starring at some parts of cgroups, I have a few questions:

- Is cgroup_enable_task_cg_list()'s while_each_thread() safe
against concurrent exec()? The leader may change in de_thread()
and invalidate the test done in while_each_thread().

- do_each_thread() also needs RCU and cgroup_enable_task_cg_list()
seems to remind it. But it seems there is at least one caller that
doesn't call rcu_read_lock(): update_cpu_mask() -> update_tasks_cpumask() -> cgroup_scan_tasks()

- By the time we call cgroup_post_fork(), it is ready to be woken up
and usable by the scheduler. I was thinking about a possible race
where somebody kills the child just before we call cgroup_post_fork()
and then it ends up calling cgroup_exit(). In this case should we perhaps
check for PF_EXITING. Of course I'm talking about a race that will certainly
never happen.
If I'm mistaken and the task can not exit concurrently, probably we don't need
the task_lock() there.

- Is the check for use_task_css_set_links in cgroup_post_fork() safe? given
it is checked outside css_set_lock?

Imagine this:

CPU 0                                                        CPU 1
----                                                         -----

cgroup_enable_task_cg() {                            
	uset_tasks_css_set_links = 1
	for_each_thread() {
		add tasks in the list
	}
}
                                                           do_fork() {
                                                               cgroup_post_fork() {
                                                                     use_tasks_css_set_links appears
                                                                     to be equal to 0 due to write/read
                                                                      not flushed. New task won't
                                                                      appear to the list.


- Is the read_lock() in cgroup_attach_proc() still necessary? It was added to protect
against exec() but now I think it is useless. rcu_read_lock() would be necessary to protect
against group_entry removal though I think.

Thanks.
