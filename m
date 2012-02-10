Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565Ab2BJWo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:44:26 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911Ab2BJWoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:17 -0500
MIME-Version: 1.0
Message-Id: <20120210223441.903376575@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Sadler <dsadler@us.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>,
        Louis Alex Eisner <leisner@cs.ucsd.edu>,
        Hugh Dickins <hughd@google.com>
Subject: [patch 18/55] mm/filemap_xip.c: fix race condition in xip_file_fault()
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -263,7 +263,12 @@ found:
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


