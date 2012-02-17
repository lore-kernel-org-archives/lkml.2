Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab2BQFii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 00:38:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60862 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2BQFig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 00:38:36 -0500
Message-ID: <4F3DE881.6090503@cn.fujitsu.com>
Date: Fri, 17 Feb 2012 13:41:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/2] cgroup: Fix some races against css_set task
 links
References: <1328668647-24125-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1328668647-24125-1-git-send-email-fweisbec@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-17 13:36:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-17 13:36:57,
	Serialize complete at 2012-02-17 13:36:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for the delayed reply. I had been off for quite a few days.

Frederic Weisbecker wrote:
> Hi,
> 
> This is trying to fix some races in the way to link all the tasks to
> the css_set links. I hope some people can have a look at this, especially
> as I'm definetly not an SMP ordering expert.

me neither.

> 
> To give you the big picture, as long as nobody never calls
> cgroup_iter_start(), we don't link the tasks to their css_set (this 'link'
> is a simple list_add()).
> 
> But once somebody calls cgroup_iter_start(), we call
> cgroup_enable_task_cg_lists() that grossly does this:
> 
> cgroup_enable_task_cg_lists() {
> 	use_task_set_css_links = 1;
> 	do_each_thread(g, p) {
> 		link p to css_set
> 	} while_each_thread(g, p);
> }
> 
> But this links only existing tasks, we also need to link all the tasks
> that will be created later, this is what does cgroup_post_fork():
> 
> cgroup_post_fork() {
> 	if (use_task_set_css_links)
> 		link p to css_set
> }
> 
> So we have some races here:
> 
> - cgroup_enable_task_cg_lists() iterates over the tasklist
>   without protection. The comments are advertizing we are using RCU
>   but we don't. And in fact RCU doesn't yet protect against
>   while_each_thread().
> 
> - Moreover with RCU there is a risk that we iterate the tasklist but
>   we don't immediately see all the last updates that happened. For
>   example if a task forks and passes cgroup_post_fork() while
>   use_task_set_css_links = 0 then another CPU calling
>   cgroup_enable_task_cg_list() can miss the new child while walking the
>   tasklist with RCU as it doesn't appear immediately.
> 
> - There is no ordering constraint on use_task_set_css_links read/write
>   against the tasklist traversal and modification. cgroup_post_fork()
>   may deal with a stale value.
> 
> The second patch of the series is a proposal to fix the three above
> points. Tell me what you think.
> 

The patch looks good to me.

As cgroup_enable_task_cg_lists() is an one-off function, won't be
called more than once, so there's little chance it can happen
in reality, so should be ok to queue it for 3.4.

> Thanks.
> 
> Frederic Weisbecker (2):
>   cgroup: Remove wrong comment on cgroup_enable_task_cg_list()
>   cgroup: Walk task list under tasklist_lock in
>     cgroup_enable_task_cg_list
> 

for both patches

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

>  kernel/cgroup.c |   23 ++++++++++++++++++++---
>  1 files changed, 20 insertions(+), 3 deletions(-)
> 
