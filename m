Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0EQNVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 09:21:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58226 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab0EQNVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 09:21:19 -0400
Subject: Re: [PATCH] Split executable and non-executable mmap tracking
From: Peter Zijlstra <peterz@infradead.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: mingo@elte.hu, acme@redhat.com, arjan@linux.intel.com, anton@samba.org,
       riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1273223135-22695-1-git-send-email-ebmunson@us.ibm.com>
References: <1273223135-22695-1-git-send-email-ebmunson@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 15:21:15 +0200
Message-ID: <1274102475.1674.1494.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 10:05 +0100, Eric B Munson wrote:
> This patch splits tracking of executable and non-executable mmaps.
> Executable mmaps are tracked normally and non-executable are
> tracked when --data is used.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> 
> Updated code for stable perf ABI
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>

> +++ b/include/linux/perf_event.h
> @@ -197,6 +197,7 @@ struct perf_event_attr {
>  				exclude_hv     :  1, /* ditto hypervisor      */
>  				exclude_idle   :  1, /* don't count when idle */
>  				mmap           :  1, /* include mmap data     */
> +				mmap_exec      :  1, /* include exec mmap data*/
>  				comm	       :  1, /* include comm data     */
>  				freq           :  1, /* use freq, not period  */
>  				inherit_stat   :  1, /* per task counts       */

You cannot add a field in the middle, that breaks ABI.

> -static inline void perf_event_mmap(struct vm_area_struct *vma)
> -{
> -	if (vma->vm_flags & VM_EXEC)
> -		__perf_event_mmap(vma);
> -}

Also, the current behaviour of perf_event_attr::mmap() is to trace
VM_EXEC maps only, apps relying on that will be broken after this patch
because they'd have to set mmap_exec.

If you want to do this, you'll have to add mmap_data (to the tail of the
bitfield) and have that add !VM_EXEC mmap() tracing.




