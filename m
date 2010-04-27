Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0D0AbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 20:31:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab0D0AbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 20:31:21 -0400
Message-ID: <4BD63031.6050105@redhat.com>
Date: Mon, 26 Apr 2010 20:30:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
References: <1272321478-28481-1-git-send-email-mel@csn.ul.ie> <1272321478-28481-3-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1272321478-28481-3-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 06:37 PM, Mel Gorman wrote:

> diff --git a/mm/rmap.c b/mm/rmap.c
> index 85f203e..bc313a6 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1368,15 +1368,31 @@ static int rmap_walk_anon(struct page *page, int (*rmap_one)(struct page *,
>   	 * are holding mmap_sem. Users without mmap_sem are required to
>   	 * take a reference count to prevent the anon_vma disappearing
>   	 */
> +retry:
>   	anon_vma = page_anon_vma(page);
>   	if (!anon_vma)
>   		return ret;
>   	spin_lock(&anon_vma->lock);
>   	list_for_each_entry(avc,&anon_vma->head, same_anon_vma) {
>   		struct vm_area_struct *vma = avc->vma;
> -		unsigned long address = vma_address(page, vma);
> -		if (address == -EFAULT)
> -			continue;
> +		unsigned long address;
> +
> +		/*
> +		 * Guard against deadlocks by not spinning against
> +		 * vma->anon_vma->lock. If contention is found, release our
> +		 * lock and try again until VMA list can be traversed without
> +		 * contention.
> +		 */
> +		if (anon_vma != vma->anon_vma) {
> +			if (!spin_trylock(&vma->anon_vma->lock)) {
> +				spin_unlock(&anon_vma->lock);
> +				goto retry;
> +			}
> +		}

If you're part way down the list, surely you'll need to
unlock multiple anon_vmas here before going to retry?

Otherwise you could forget to unlock one that you already
locked, and live-lock here.

-- 
All rights reversed
