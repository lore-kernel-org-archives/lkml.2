Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1HaGqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 02:46:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38884 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab1HaGqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 02:46:30 -0400
MIME-Version: 1.0
In-Reply-To: <1314767509-17862-1-git-send-email-rajan.aggarwal85@gmail.com>
References: <1314767509-17862-1-git-send-email-rajan.aggarwal85@gmail.com>
Date: Wed, 31 Aug 2011 12:16:29 +0530
Message-ID: <CALN+fr2uOFEG1neX2H=ObDZKPHkOCaOhhdK_Vvu+nCPEaQKN-g@mail.gmail.com>
Subject: Re: [PATCH 1/1] fs-writeback: Using spin_lock to check for work_list empty
From: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
To: KAMEZAWA Hiroyuk <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamezawa,

I noticed that you are responding to emails right now.

Can you please review the patch below and tell me whether it is
technically correct ?

Or, can you please suggest a suitable change for solving this ?

Thanks.
Kautuk

On Wed, Aug 31, 2011 at 10:41 AM, Rajan Aggarwal
<rajan.aggarwal85@gmail.com> wrote:
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
>  fs/fs-writeback.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 04cf3b9..e333898 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -936,11 +936,14 @@ int bdi_writeback_thread(void *data)
>                if (pages_written)
>                        wb->last_active = jiffies;
>
> +               spin_lock_bh(&bdi->wb_lock);
>                set_current_state(TASK_INTERRUPTIBLE);
>                if (!list_empty(&bdi->work_list) || kthread_should_stop()) {
>                        __set_current_state(TASK_RUNNING);
> +                       spin_unlock_bh(&bdi->wb_lock);
>                        continue;
>                }
> +               spin_unlock_bh(&bdi->wb_lock);
>
>                if (wb_has_dirty_io(wb) && dirty_writeback_interval)
>                        schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
> --
> 1.7.4.1
>
>
