Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab1DYUlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:41:53 -0400
Received: from 1wt.eu ([62.212.114.60]:34368 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab1DYUYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:54 -0400
Message-Id: <20110425200236.079177121@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kerin Millar <kerframil@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 071/173] mm: fix possible cause of a page_mapped BUG
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit a3e8cc643d22d2c8ed36b9be7d9c9ca21efcf7f7 upstream.

Robert Swiecki reported a BUG_ON(page_mapped) from a fuzzer, punching
a hole with madvise(,, MADV_REMOVE).  That path is under mutex, and
cannot be explained by lack of serialization in unmap_mapping_range().

Reviewing the code, I found one place where vm_truncate_count handling
should have been updated, when I switched at the last minute from one
way of managing the restart_addr to another: mremap move changes the
virtual addresses, so it ought to adjust the restart_addr.

But rather than exporting the notion of restart_addr from memory.c, or
converting to restart_pgoff throughout, simply reset vm_truncate_count
to 0 to force a rescan if mremap move races with preempted truncation.

We have no confirmation that this fixes Robert's BUG,
but it is a fix that's worth making anyway.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kerin Millar <kerframil@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mremap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -92,9 +92,7 @@ static void move_ptes(struct vm_area_str
 		 */
 		mapping = vma->vm_file->f_mapping;
 		spin_lock(&mapping->i_mmap_lock);
-		if (new_vma->vm_truncate_count &&
-		    new_vma->vm_truncate_count != vma->vm_truncate_count)
-			new_vma->vm_truncate_count = 0;
+		new_vma->vm_truncate_count = 0;
 	}
 
 	/*


