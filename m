Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab1KKRZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:25:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab1KKRZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:25:02 -0500
Date: Fri, 11 Nov 2011 18:24:58 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mmap: fix loop when adjusting vma
Message-ID: <20111111172458.GC4479@redhat.com>
References: <CAJd=RBAhHS4txg-2tnJyER=GeT4X95z6COMzJvRhcwFgXu6oOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBAhHS4txg-2tnJyER=GeT4X95z6COMzJvRhcwFgXu6oOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 08:53:23PM +0800, Hillf Danton wrote:
> --- a/mm/mmap.c	Fri Nov 11 20:35:46 2011
> +++ b/mm/mmap.c	Fri Nov 11 20:41:32 2011
> @@ -490,6 +490,7 @@ __vma_unlink(struct mm_struct *mm, struc
>  int vma_adjust(struct vm_area_struct *vma, unsigned long start,
>  	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert)
>  {
> +	unsigned long saved_end = end;
>  	struct mm_struct *mm = vma->vm_mm;
>  	struct vm_area_struct *next = vma->vm_next;
>  	struct vm_area_struct *importer = NULL;
> @@ -634,7 +635,14 @@ again:			remove_next = 1 + (end > next->
>  		 */
>  		if (remove_next == 2) {
>  			next = vma->vm_next;
> -			goto again;
> +			if (next) {
> +				/*
> +				 * we have more work, reload @end in case
> +				 * it is clobbered.
> +				 */
> +				end = saved_end;
> +				goto again;
> +			}
>  		}

Doesn't matter if it's clobbered, remove_next will be set to 1 and
that's all we care about. Caller should use vma->vm_next->vm_end as
"end" anyway for case 6 so it wouldn't be set to 2. Also next can't be
NULL if remove_next == 2. So I don't think this is necessary.
