Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab1IAVdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 17:33:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758062Ab1IAVdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 17:33:44 -0400
Date: Thu, 1 Sep 2011 14:33:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <dchinner@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/backing-dev.c: Call del_timer_sync instead of
 del_timer
Message-Id: <20110901143333.51baf4ae.akpm@linux-foundation.org>
In-Reply-To: <1314892622-18267-1-git-send-email-consul.kautuk@gmail.com>
References: <1314892622-18267-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Sep 2011 21:27:02 +0530
Kautuk Consul <consul.kautuk@gmail.com> wrote:

> This is important for SMP scenario, to check whether the timer
> callback is executing on another CPU when we are deleting the
> timer.
> 

I don't see why?

> index d6edf8d..754b35a 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -385,7 +385,7 @@ static int bdi_forker_thread(void *ptr)
>  		 * dirty data on the default backing_dev_info
>  		 */
>  		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list)) {
> -			del_timer(&me->wakeup_timer);
> +			del_timer_sync(&me->wakeup_timer);
>  			wb_do_writeback(me, 0);
>  		}

It isn't a use-after-free fix: bdi_unregister() safely shoots down any
running timer.

Please completely explain what you believe the problem is here.
