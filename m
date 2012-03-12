Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2CLAuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:50:20 -0400
Received: from 1wt.eu ([62.212.114.60]:63094 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab2CLAss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:48 -0400
Message-Id: <20120312004411.443637720@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:14 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Carsten Otte <cotte@de.ibm.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 03/13] mm/filemap_xip.c: fix race condition in xip_file_fault()
In-Reply-To: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Carsten Otte <carsteno@de.ibm.com>

commit 99f02ef1f18631eb0a4e0ea0a3d56878dbcb4b90 upstream.

Fix a race condition that shows in conjunction with xip_file_fault() when
two threads of the same user process fault on the same memory page.

In this case, the race winner will install the page table entry and the
unlucky loser will cause an oops: xip_file_fault calls vm_insert_pfn (via
vm_insert_mixed) which drops out at this check:

	retval = -EBUSY;
	if (!pte_none(*pte))
		goto out_unlock;

The resulting -EBUSY return value will trigger a BUG_ON() in
xip_file_fault.

This fix simply considers the fault as fixed in this case, because the
race winner has successfully installed the pte.

[akpm@linux-foundation.org: use conventional (and consistent) comment layout]
Reported-by: David Sadler <dsadler@us.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Reported-by: Louis Alex Eisner <leisner@cs.ucsd.edu>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap_xip.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 1888b2d..e395030 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -262,7 +262,12 @@ found:
 							xip_pfn);
 		if (err == -ENOMEM)
 			return VM_FAULT_OOM;
-		BUG_ON(err);
+		/*
+		 * err == -EBUSY is fine, we've raced against another thread
+		 * that faulted-in the same page
+		 */
+		if (err != -EBUSY)
+			BUG_ON(err);
 		return VM_FAULT_NOPAGE;
 	} else {
 		int err, ret = VM_FAULT_OOM;
-- 
1.7.2.1.45.g54fbc



