Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab1AVSjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 13:39:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab1AVSjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 13:39:15 -0500
Date: Sat, 22 Jan 2011 19:38:00 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] compaction: don't depend on HUGETLB_PAGE
Message-ID: <20110122183800.GU9506@random.random>
References: <AANLkTikdwZp1r_MD4TH7bsLjzPAtHzq7XWoLZmFwdK=S@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikdwZp1r_MD4TH7bsLjzPAtHzq7XWoLZmFwdK=S@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jan 22, 2011 at 03:48:03PM +0100, Luca Tettamanti wrote:
> Hello Andrea,
> this commit:
> 
> commit 5d6892407cab23d4bf2f6de065ca351a53849323
> Author: Andrea Arcangeli <aarcange@redhat.com>
> Date:   Thu Jan 13 15:47:07 2011 -0800
> 
>     thp: select CONFIG_COMPACTION if TRANSPARENT_HUGEPAGE enabled
> 
> causes this warning during the configuration process:
> 
> warning: (TRANSPARENT_HUGEPAGE) selects COMPACTION which has unmet
> direct dependencies (EXPERIMENTAL && HUGETLB_PAGE && MMU)
> 
> This happens because 'select' does not enable the dependencies of its
> target, so when I selected THP it also enabled COMPATION but I don't
> have HUGETLBFS (=HUGETLB_PAGE) enabled.
> Making THP select HUGETLB_PAGE fixes the warning but I'm not 100% sure
> that's correct (does it work without HUGETLBFS?).

Mel, what's your take about this issue?

Luca does the below fix all your .config problems?

====
Subject: compaction: don't depend on HUGETLB_PAGE

From: Andrea Arcangeli <aarcange@redhat.com>

COMPACTION doesn't depend on HUGETLB_PAGE, it doesn't depend on THP
either, it is also useful for regular alloc_pages(order > 0) including
the very kernel stack during fork (THREAD_ORDER = 1). It's always
better to enable COMPACTION.

The warning should be an error because we would end up with MIGRATION
not selected, and COMPACTION wouldn't work without migration (despite
it seems to build with an inline migrate_pages returning -ENOSYS).

I'd also like to remove EXPERIMENTAL: compaction has been in the
kernel for some releases (for full safety the default remains
disabled which I think is enough).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/Kconfig b/mm/Kconfig
index 3ad483b..e9c0c61 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -179,7 +179,7 @@ config SPLIT_PTLOCK_CPUS
 config COMPACTION
 	bool "Allow for memory compaction"
 	select MIGRATION
-	depends on EXPERIMENTAL && HUGETLB_PAGE && MMU
+	depends on MMU
 	help
 	  Allows the compaction of memory for the allocation of huge pages.
 
