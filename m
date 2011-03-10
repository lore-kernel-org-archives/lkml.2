Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1CKABi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:01:38 -0500
Received: from kroah.org ([198.145.64.141]:46852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab1CJX5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:37 2011
Message-Id: <20110310235537.232316841@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>, Kerin Millar <kerframil@gmail.com>
Subject: [patch 12/29] mm: fix possible cause of a page_mapped BUG
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
@@ -91,9 +91,7 @@ static void move_ptes(struct vm_area_str
 		 */
 		mapping = vma->vm_file->f_mapping;
 		spin_lock(&mapping->i_mmap_lock);
-		if (new_vma->vm_truncate_count &&
-		    new_vma->vm_truncate_count != vma->vm_truncate_count)
-			new_vma->vm_truncate_count = 0;
+		new_vma->vm_truncate_count = 0;
 	}
 
 	/*


