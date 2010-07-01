Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab0GAVbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:31:39 -0400
Received: from kroah.org ([198.145.64.141]:33200 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933126Ab0GAVPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:14 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:01 2010
Message-Id: <20100701174301.396919016@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [176/200] NFS: Fix another nfs_wb_page() deadlock
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 0522f6adedd2736cbca3c0e16ca51df668993eee upstream.

J.R. Okajima reports that the call to sync_inode() in nfs_wb_page() can
deadlock with other writeback flush calls. It boils down to the fact
that we cannot ever call writeback_single_inode() while holding a page
lock (even if we do set nr_to_write to zero) since another process may
already be waiting in the call to do_writepages(), and so will deny us
the I_SYNC lock.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/write.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1518,14 +1518,17 @@ int nfs_wb_page(struct inode *inode, str
 	};
 	int ret;
 
-	while(PagePrivate(page)) {
+	for (;;) {
 		wait_on_page_writeback(page);
 		if (clear_page_dirty_for_io(page)) {
 			ret = nfs_writepage_locked(page, &wbc);
 			if (ret < 0)
 				goto out_error;
+			continue;
 		}
-		ret = sync_inode(inode, &wbc);
+		if (!PagePrivate(page))
+			break;
+		ret = nfs_commit_inode(inode, FLUSH_SYNC);
 		if (ret < 0)
 			goto out_error;
 	}


