Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab2KVVVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:21:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:49649 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab2KVSkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 45/83] tmpfs: fix shmem_getpage_gfp() VM_BUG_ON
Date: Wed, 21 Nov 2012 16:42:07 -0800
Message-Id: <20121122004217.581496709@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/shmem.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1156,8 +1156,20 @@ repeat:
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


