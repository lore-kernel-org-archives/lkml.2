Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2KIAwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 19:52:43 -0500
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33350 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab2KIAwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 19:52:42 -0500
From: Sonny Rao <sonnyrao@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Mandeep Singh Baines <msb@chromium.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Olof Johansson <olofj@chromium.org>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, Aaron Durbin <adurbin@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Puneet Kumar <puneetster@chromium.org>
Subject: [PATCHv2] mm: Fix calculation of dirtyable memory
Date: Thu,  8 Nov 2012 16:52:33 -0800
Message-Id: <1352422353-11229-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CAPz6YkVruULzvmn4a8G05xPJUEXdhHqAZnW4sZAHCWMZpW338g@mail.gmail.com>
References: <CAPz6YkVruULzvmn4a8G05xPJUEXdhHqAZnW4sZAHCWMZpW338g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system uses global_dirtyable_memory() to calculate
number of dirtyable pages/pages that can be allocated
to the page cache.  A bug causes an underflow thus making
the page count look like a big unsigned number.  This in turn
confuses the dirty writeback throttling to aggressively write
back pages as they become dirty (usually 1 page at a time).

Fix is to ensure there is no underflow while doing the math.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Puneet Kumar <puneetster@chromium.org>
---
 v2: added apkm's suggestion to make the highmem calculation better
 mm/page-writeback.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 830893b..ce62442 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -201,6 +201,18 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
 		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
 	}
 	/*
+	 * Unreclaimable memory (kernel memory or anonymous memory
+	 * without swap) can bring down the dirtyable pages below
+	 * the zone's dirty balance reserve and the above calculation
+	 * will underflow.  However we still want to add in nodes
+	 * which are below threshold (negative values) to get a more
+	 * accurate calculation but make sure that the total never
+	 * underflows.
+	 */
+	if ((long)x < 0)
+		x = 0;
+
+	/*
 	 * Make sure that the number of highmem pages is never larger
 	 * than the number of the total dirtyable memory. This can only
 	 * occur in very strange VM situations but we want to make sure
@@ -222,8 +234,9 @@ static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages() -
-	    dirty_balance_reserve;
+	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+	if (x >= dirty_balance_reserve)
+		x -= dirty_balance_reserve;
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
-- 
1.7.7.3

