Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab2CaM1v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:27:51 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38405 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab2CaM1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:27:48 -0400
MIME-Version: 1.0
In-Reply-To: <201203302018.q2UKIFH5020745@farm-0012.internal.tilera.com>
References: <201203302018.q2UKIFH5020745@farm-0012.internal.tilera.com>
Date: Sat, 31 Mar 2012 20:27:46 +0800
Message-ID: <CAJd=RBCoLNB+iRX1shKGAwSbE8PsZXyk9e3inPTREcm2kk3nXA@mail.gmail.com>
Subject: Re: [PATCH] hugetlb: fix race condition in hugetlb_fault()
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
> Cc: stable@kernel.org
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  mm/hugetlb.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4531be2..ab674fc 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2703,8 +2703,10 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>         * so no worry about deadlock.
>         */
>        page = pte_page(entry);
> -       if (page != pagecache_page)
> +       if (page != pagecache_page) {
> +               get_page(page);
>                lock_page(page);
> +       }
>
Perhaps, directly get page?

	page = pte_page(entry);
+	get_page(page);
	if (page != pagecache_page)
		lock_page(page);
