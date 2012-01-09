Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab2AIUmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:42:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50068 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151Ab2AIUmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:42:51 -0500
Message-ID: <4F0B5146.6090200@gmail.com>
Date: Mon, 09 Jan 2012 15:42:46 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: kosaki.motohiro@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/2] SHM_UNLOCK: fix Unevictable pages stranded after
 swap
References: <alpine.LSU.2.00.1201061303320.12082@eggly.anvils> <alpine.LSU.2.00.1201061310340.12082@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1201061310340.12082@eggly.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2012/1/6 Hugh Dickins <hughd@google.com>:
> Commit cc39c6a9bbde "mm: account skipped entries to avoid looping in
> find_get_pages" correctly fixed an infinite loop; but left a problem
> that find_get_pages() on shmem would return 0 (appearing to callers
> to mean end of tree) when it meets a run of nr_pages swap entries.
>
> The only uses of find_get_pages() on shmem are via pagevec_lookup(),
> called from invalidate_mapping_pages(), and from shmctl SHM_UNLOCK's
> scan_mapping_unevictable_pages().  The first is already commented,
> and not worth worrying about; but the second can leave pages on the
> Unevictable list after an unusual sequence of swapping and locking.
>
> Fix that by using shmem_find_get_pages_and_swap() (then ignoring
> the swap) instead of pagevec_lookup().
>
> But I don't want to contaminate vmscan.c with shmem internals, nor
> shmem.c with LRU locking.  So move scan_mapping_unevictable_pages()
> into shmem.c, renaming it shmem_unlock_mapping(); and rename
> check_move_unevictable_page() to check_move_unevictable_pages(),
> looping down an array of pages, oftentimes under the same lock.
>
> Leave out the "rotate unevictable list" block: that's a leftover
> from when this was used for /proc/sys/vm/scan_unevictable_pages,
> whose flawed handling involved looking at pages at tail of LRU.
>
> Was there significance to the sequence first ClearPageUnevictable,
> then test page_evictable, then SetPageUnevictable here?  I think
> not, we're under LRU lock, and have no barriers between those.

If I understand correctly, this is not exactly correct. Because of,
PG_mlocked operation is not protected by LRU lock. So, I think we
have three choice.

1) check_move_unevictable_pages() aimed retry logic and put pages back
    into correct lru.
2) check_move_unevictable_pages() unconditionally move the pages into
    evictable lru, and vmacan put them back into correct lru later.
3) To protect PG_mlock operation by lru lock.


other parts looks fine to me.

