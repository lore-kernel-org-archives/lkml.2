Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab2ABJ5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 04:57:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:12915 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab2ABJ5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 04:57:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="91467010"
Date: Mon, 2 Jan 2012 17:57:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: =?utf-8?B?77+977+977+977+9yKM=?= <chanho.min@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "'Jens Axboe'" <axboe@kernel.dk>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/backing-dev.c: fix crash when USB/SCSI device is
 detached
Message-ID: <20120102095711.GA16570@localhost>
References: <004401ccc932$444a0070$ccde0150$@min@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <004401ccc932$444a0070$ccde0150$@min@lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 06:38:21PM +0900, ����ȣ wrote:
> from Chanho Min <chanho.min@lge.com>
> 
> System may crash in backing-dev.c when removal SCSI device is detached.
> bdi task is killed by bdi_unregister()/'khubd', but task's point remains.
> Shortly afterward, If 'wb->wakeup_timer' is expired before
> del_timer()/bdi_forker_thread,
> wakeup_timer_fn() may wake up the dead thread which cause the crash.
> 'bdi->wb.task' should be NULL as this patch.

Is it some race condition between del_timer() and del_timer_sync()?

bdi_unregister() calls 

        del_timer_sync
        bdi_wb_shutdown
            kthread_stop

in turn, and del_timer_sync() should guarantee wakeup_timer_fn() is
no longer called to access the stopped task.

Thanks,
Fengguang


> Signed-off-by: Chanho Min <chanho.min@lge.com>
> ---
>  mm/backing-dev.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 71034f4..4378a5e 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -607,6 +607,7 @@ static void bdi_wb_shutdown(struct backing_dev_info
> *bdi)
>         if (bdi->wb.task) {
>                 thaw_process(bdi->wb.task);
>                 kthread_stop(bdi->wb.task);
> +               bdi->wb.task = NULL;
>         }
>  }
> 
> -- 
> 1.7.0.4
