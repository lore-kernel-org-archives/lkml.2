Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab2BHChk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 21:37:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab2BHChj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 21:37:39 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC][PATCH 0/2] cgroup: Fix some races against css_set task links
Date: Wed,  8 Feb 2012 03:37:25 +0100
Message-Id: <1328668647-24125-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is trying to fix some races in the way to link all the tasks to
the css_set links. I hope some people can have a look at this, especially
as I'm definetly not an SMP ordering expert.

To give you the big picture, as long as nobody never calls
cgroup_iter_start(), we don't link the tasks to their css_set (this 'link'
is a simple list_add()).

But once somebody calls cgroup_iter_start(), we call
cgroup_enable_task_cg_lists() that grossly does this:

cgroup_enable_task_cg_lists() {
	use_task_set_css_links = 1;
	do_each_thread(g, p) {
		link p to css_set
	} while_each_thread(g, p);
}

But this links only existing tasks, we also need to link all the tasks
that will be created later, this is what does cgroup_post_fork():

cgroup_post_fork() {
	if (use_task_set_css_links)
		link p to css_set
}

So we have some races here:

- cgroup_enable_task_cg_lists() iterates over the tasklist
  without protection. The comments are advertizing we are using RCU
  but we don't. And in fact RCU doesn't yet protect against
  while_each_thread().

- Moreover with RCU there is a risk that we iterate the tasklist but
  we don't immediately see all the last updates that happened. For
  example if a task forks and passes cgroup_post_fork() while
  use_task_set_css_links = 0 then another CPU calling
  cgroup_enable_task_cg_list() can miss the new child while walking the
  tasklist with RCU as it doesn't appear immediately.

- There is no ordering constraint on use_task_set_css_links read/write
  against the tasklist traversal and modification. cgroup_post_fork()
  may deal with a stale value.

The second patch of the series is a proposal to fix the three above
points. Tell me what you think.

Thanks.

Frederic Weisbecker (2):
  cgroup: Remove wrong comment on cgroup_enable_task_cg_list()
  cgroup: Walk task list under tasklist_lock in
    cgroup_enable_task_cg_list

 kernel/cgroup.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

-- 
1.7.5.4

