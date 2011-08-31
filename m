Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab1HaV1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:27:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604Ab1HaV1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:27:42 -0400
Date: Wed, 31 Aug 2011 14:27:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/1] fs-writeback: Using spin_lock to check for
 work_list empty
Message-Id: <20110831142710.160df16f.akpm@linux-foundation.org>
In-Reply-To: <1314767509-17862-1-git-send-email-rajan.aggarwal85@gmail.com>
References: <1314767509-17862-1-git-send-email-rajan.aggarwal85@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 10:41:49 +0530
Rajan Aggarwal <rajan.aggarwal85@gmail.com> wrote:

> The bdi_writeback_thread function does not use spin_lock to
> see if the work_list is empty.
> 
> If the list is not empty, and if an interrupt happens before we
> set the current->state to TASK_RUNNING then we could be stuck in
> a schedule() due to kernel preemption.
> 
> This patch acquires and releases the wb_lock to avoid this scenario.
> 
> Signed-off-by: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
> ---
>  fs/fs-writeback.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 04cf3b9..e333898 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -936,11 +936,14 @@ int bdi_writeback_thread(void *data)
>  		if (pages_written)
>  			wb->last_active = jiffies;
>  
> +		spin_lock_bh(&bdi->wb_lock);
>  		set_current_state(TASK_INTERRUPTIBLE);
>  		if (!list_empty(&bdi->work_list) || kthread_should_stop()) {
>  			__set_current_state(TASK_RUNNING);
> +			spin_unlock_bh(&bdi->wb_lock);
>  			continue;
>  		}
> +		spin_unlock_bh(&bdi->wb_lock);
>  
>  		if (wb_has_dirty_io(wb) && dirty_writeback_interval)
>  			schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));

I don't see anything particularly wrong with the current code.  If a
task gets preempted while in state TASK_INTERRUPTIBLE then it will
still be in that state when that task resumes running.

There might be some cross-CPU memory ordering issues in that code.  If
so, the effects would be:

a) list_empty() falsely thought to return "false": the thread will
   do one additional pointless loop and will then sleep.

b) list_empty() falsely thought to return "true": the thread will
   prematurely attempt to go to sleep, introducing a teent bit of
   additional latency in rare cases.  But I think this is a "can't
   happen" because of the memory barrier in
   set_current_state(TASK_INTERRUPTIBLE): if the task made this mistake
   running list_empty() then it will now be in state TASK_RUNNING and
   the schedule() calls will fall straight through.  I think.



