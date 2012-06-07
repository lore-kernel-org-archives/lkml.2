Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807Ab2FGESB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:18:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759739Ab2FGER5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:17:57 -0400
Message-Id: <20120607040341.473637854@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:11 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Jones <davej@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [ 35/82] mm: fix vma_resv_map() NULL pointer
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave@linux.vnet.ibm.com>

commit 4523e1458566a0e8ecfaff90f380dd23acc44d27 upstream.

hugetlb_reserve_pages() can be used for either normal file-backed
hugetlbfs mappings, or MAP_HUGETLB.  In the MAP_HUGETLB, semi-anonymous
mode, there is not a VMA around.  The new call to resv_map_put() assumed
that there was, and resulted in a NULL pointer dereference:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
  IP: vma_resv_map+0x9/0x30
  PGD 141453067 PUD 1421e1067 PMD 0
  Oops: 0000 [#1] PREEMPT SMP
  ...
  Pid: 14006, comm: trinity-child6 Not tainted 3.4.0+ #36
  RIP: vma_resv_map+0x9/0x30
  ...
  Process trinity-child6 (pid: 14006, threadinfo ffff8801414e0000, task ffff8801414f26b0)
  Call Trace:
    resv_map_put+0xe/0x40
    hugetlb_reserve_pages+0xa6/0x1d0
    hugetlb_file_setup+0x102/0x2c0
    newseg+0x115/0x360
    ipcget+0x1ce/0x310
    sys_shmget+0x5a/0x60
    system_call_fastpath+0x16/0x1b

This was reported by Dave Jones, but was reproducible with the
libhugetlbfs test cases, so shame on me for not running them in the
first place.

With this, the oops is gone, and the output of libhugetlbfs's
run_tests.py is identical to plain 3.4 again.

[ Marked for stable, since this was introduced by commit c50ac050811d
  ("hugetlb: fix resv_map leak in error path") which was also marked for
  stable ]

Reported-by: Dave Jones <davej@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3035,7 +3035,8 @@ int hugetlb_reserve_pages(struct inode *
 		region_add(&inode->i_mapping->private_list, from, to);
 	return 0;
 out_err:
-	resv_map_put(vma);
+	if (vma)
+		resv_map_put(vma);
 	return ret;
 }
 


