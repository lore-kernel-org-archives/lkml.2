Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab0EQQWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:22:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab0EQQWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:22:41 -0400
Subject: Re: [PATCH] Split executable and non-executable mmap tracking V2
From: Peter Zijlstra <peterz@infradead.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: mingo@elte.hu, acme@redhat.com, arjan@linux.intel.com, anton@samba.org,
       riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1274109965-25456-1-git-send-email-ebmunson@us.ibm.com>
References: <1274109965-25456-1-git-send-email-ebmunson@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 18:22:37 +0200
Message-ID: <1274113357.1674.1508.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 16:26 +0100, Eric B Munson wrote:
> This patch splits tracking of executable and non-executable mmaps.
> Executable mmaps are tracked normally and non-executable are
> tracked when --data is used.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> 
> Updated code for stable perf ABI
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> ---
> Changes from  V1:
> -Changed mmap_exec to mmap_data and left mmap as the executable mmap tracker
>  to maintain backwards compatibility
> -Insert mmap_data at the end of the attr bit map


> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index c8e3754..05c1dd1 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -196,15 +196,16 @@ struct perf_event_attr {
>  				exclude_kernel :  1, /* ditto kernel          */
>  				exclude_hv     :  1, /* ditto hypervisor      */
>  				exclude_idle   :  1, /* don't count when idle */
> -				mmap           :  1, /* include mmap data     */
> +				mmap           :  1, /* include exec mmap data*/
>  				comm	       :  1, /* include comm data     */
>  				freq           :  1, /* use freq, not period  */
>  				inherit_stat   :  1, /* per task counts       */
>  				enable_on_exec :  1, /* next exec enables     */
>  				task           :  1, /* trace fork/exit       */
>  				watermark      :  1, /* wakeup_watermark      */
> +				mmap_data      :  1, /* include mmap data     */
>  
> -				__reserved_1   : 49;
> +				__reserved_1   : 48;

That won't apply against the latest version.

> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 3d1552d..8ad6441 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1834,6 +1834,8 @@ static void free_event(struct perf_event *event)
>  		atomic_dec(&nr_events);
>  		if (event->attr.mmap)
>  			atomic_dec(&nr_mmap_events);
> +		if (event->attr.mmap_data)
> +			atomic_dec(&nr_mmap_events);
>  		if (event->attr.comm)
>  			atomic_dec(&nr_comm_events);
>  		if (event->attr.task)


> @@ -4641,6 +4655,8 @@ done:
>  		atomic_inc(&nr_events);
>  		if (event->attr.mmap)
>  			atomic_inc(&nr_mmap_events);
> +		if (event->attr.mmap_data)
> +			atomic_inc(&nr_mmap_events);
>  		if (event->attr.comm)
>  			atomic_inc(&nr_comm_events);
>  		if (event->attr.task)

Wouldn't you rather write:

  if (event->attr.mmap || event->attr.mmap_data)

and avoid an atomic op?

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 456ec6f..6ceee1d 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1781,6 +1781,7 @@ static int expand_downwards(struct vm_area_struct *vma,
>  		if (!error) {
>  			vma->vm_start = address;
>  			vma->vm_pgoff -= grow;
> +			perf_event_mmap(vma);
>  		}
>  	}
>  	anon_vma_unlock(vma);

This wants to live in expand_stack(), or get replicated in
expand_upwards().


