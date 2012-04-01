Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab2DAMKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 08:10:35 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51943 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2DAMKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 08:10:32 -0400
MIME-Version: 1.0
In-Reply-To: <201203311339.q2VDdJMD006254@farm-0012.internal.tilera.com>
References: <201203302018.q2UKIFH5020745@farm-0012.internal.tilera.com>
	<CAJd=RBCoLNB+iRX1shKGAwSbE8PsZXyk9e3inPTREcm2kk3nXA@mail.gmail.com>
	<201203311339.q2VDdJMD006254@farm-0012.internal.tilera.com>
Date: Sun, 1 Apr 2012 20:10:31 +0800
Message-ID: <CAJd=RBBWx7uZcw=_oA06RVunPAGeFcJ7LY=RwFCyB_BreJb_kg@mail.gmail.com>
Subject: Re: [PATCH v2] hugetlb: fix race condition in hugetlb_fault()
From: Hillf Danton <dhillf@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 4:07 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> The race is as follows.  Suppose a multi-threaded task forks a new
> process, thus bumping up the ref count on all the pages.  While the fork
> is occurring (and thus we have marked all the PTEs as read-only), another
> thread in the original process tries to write to a huge page, taking an
> access violation from the write-protect and calling hugetlb_cow().  Now,
> suppose the fork() fails.  It will undo the COW and decrement the ref
> count on the pages, so the ref count on the huge page drops back to 1.
> Meanwhile hugetlb_cow() also decrements the ref count by one on the
> original page, since the original address space doesn't need it any more,
> having copied a new page to replace the original page.  This leaves the
> ref count at zero, and when we call unlock_page(), we panic.
>
> The solution is to take an extra reference to the page while we are
> holding the lock on it.
>
If the following chart matches the above description,

===
	fork on CPU A				fault on CPU B
	=============				==============
	...
	down_write(&parent->mmap_sem);
	down_write_nested(&child->mmap_sem);
	...
	while duplicating vmas
		if error
			break;
	...
	up_write(&child->mmap_sem);
	up_write(&parent->mmap_sem);		...
						down_read(&parent->mmap_sem);
						...
						lock_page(page);
						handle COW
						page_mapcount(old_page) == 2
						alloc and prepare new_page
	...
	handle error
	page_remove_rmap(page);
	put_page(page);
	...
						fold new_page into pte
						page_remove_rmap(page);
						put_page(page);
						...
				oops ==>	unlock_page(page);
						up_read(&parent->mmap_sem);
===

would you please spin with description refreshed?

> Cc: stable@kernel.org

Let Andrew do the stable work, ok?

Best Regards
-hd

> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> This change incorporates Hillf Danton's suggestion to just unconditionally
> get and put the page around the region of code in question.
>
>  mm/hugetlb.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 1871753..5f53d6b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2701,6 +2701,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>         * so no worry about deadlock.
>         */
>        page = pte_page(entry);
> +       get_page(page);
>        if (page != pagecache_page)
>                lock_page(page);
>
> @@ -2732,6 +2733,7 @@ out_page_table_lock:
>        }
>        if (page != pagecache_page)
>                unlock_page(page);
> +       put_page(page);
>
>  out_mutex:
>        mutex_unlock(&hugetlb_instantiation_mutex);
> --
> 1.6.5.2
>
