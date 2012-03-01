Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965293Ab2CAQ67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 11:58:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964779Ab2CAQ65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 11:58:57 -0500
Date: Thu, 1 Mar 2012 17:51:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jamie Lokier <jamie@shareable.org>, Mike Frysinger <vapier@gentoo.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Take rcu read lock when iterating through thread
	group
Message-ID: <20120301165153.GA4211@redhat.com>
References: <20120228174049.GA11136@redhat.com> <201202241112.46337.vapier@gentoo.org> <1330579259-3456-1-git-send-email-siddhesh.poyarekar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330579259-3456-1-git-send-email-siddhesh.poyarekar@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01, Siddhesh Poyarekar wrote:
>
> Protect the iteration through thread group with rcu_read_lock when
> looking for tasks in the group that use the current vma as
> stack. Thanks KOSAKI Motohiro (kosaki.motohiro@gmail.com) for pointing
> it out.
>
> Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
> ---
>  mm/memory.c |   15 +++++++++++----
>  1 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 601a920..a88b764 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3915,20 +3915,27 @@ void print_vma_addr(char *prefix, unsigned long ip)
>   * just check in the current task.
>   */
>  int vm_is_stack(struct task_struct *task,
> -			      struct vm_area_struct *vma, int in_group)
> +		struct vm_area_struct *vma, int in_group)
>  {
> +	int ret = 0;
> +
>  	if (vm_is_stack_for_task(task, vma))
>  		return 1;
>  
>  	if (in_group) {
>  		struct task_struct *t = task;
> +		rcu_read_lock();
>  		while_each_thread(task, t) {

This is the commont mistake. rcu_read_lock() can not help unless you
verify that ->thread_group.next still points to the rcu-protected
memory.

Just suppose that this task exits, then next_thread() exits too. Now
you take rcu_read_lock() but it is too late, ->next points to nowhere.

Also. In fact while_each_thread() is not safe under rcu. We are going
to fix this, but only for the case when while_each_thread() starts at
the thread group leader.

Oleg.

