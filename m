Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab2LMOHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:07:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44444 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab2LMOG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 101/241] tmpfs: fix shmem_getpage_gfp() VM_BUG_ON
Date: Thu, 13 Dec 2012 11:57:46 -0200
Message-Id: <1355407206-17100-102-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 215c02bc33bbd5ff4d7379a909462d11f0103218 upstream.

Fuzzing with trinity hit the "impossible" VM_BUG_ON(error) (which Fedora
has converted to WARNING) in shmem_getpage_gfp():

  WARNING: at mm/shmem.c:1151 shmem_getpage_gfp+0xa5c/0xa70()
  Pid: 29795, comm: trinity-child4 Not tainted 3.7.0-rc2+ #49
  Call Trace:
    warn_slowpath_common+0x7f/0xc0
    warn_slowpath_null+0x1a/0x20
    shmem_getpage_gfp+0xa5c/0xa70
    shmem_fault+0x4f/0xa0
    __do_fault+0x71/0x5c0
    handle_pte_fault+0x97/0xae0
    handle_mm_fault+0x289/0x350
    __do_page_fault+0x18e/0x530
    do_page_fault+0x2b/0x50
    page_fault+0x28/0x30
    tracesys+0xe1/0xe6

Thanks to Johannes for pointing to truncation: free_swap_and_cache()
only does a trylock on the page, so the page lock we've held since
before confirming swap is not enough to protect against truncation.

What cleanup is needed in this case? Just delete_from_swap_cache(),
which takes care of the memcg uncharge.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 mm/shmem.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 06d48ca..c7f7a77 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1154,8 +1154,20 @@ repeat:
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
 						gfp, swp_to_radix_entry(swap));
-			/* We already confirmed swap, and make no allocation */
-			VM_BUG_ON(error);
+			/*
+			 * We already confirmed swap under page lock, and make
+			 * no memory allocation here, so usually no possibility
+			 * of error; but free_swap_and_cache() only trylocks a
+			 * page, so it is just possible that the entry has been
+			 * truncated or holepunched since swap was confirmed.
+			 * shmem_undo_range() will have done some of the
+			 * unaccounting, now delete_from_swap_cache() will do
+			 * the rest (including mem_cgroup_uncharge_swapcache).
+			 * Reset swap.val? No, leave it so "failed" goes back to
+			 * "repeat": reading a hole and writing should succeed.
+			 */
+			if (error)
+				delete_from_swap_cache(page);
 		}
 		if (error)
 			goto failed;
-- 
1.7.9.5

