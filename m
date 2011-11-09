Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab1KJEVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:21:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965135Ab1KJDko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:40:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:53 2011
Message-Id: <20111109213153.397749668@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andrea Arcangeli <aarcange@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [112/264] nfs: dont try to migrate pages with active requests
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 2da956523526e440ef4f4dd174e26f5ac06fe011 upstream.

nfs_find_and_lock_request will take a reference to the nfs_page and
will then put it if the req is already locked. It's possible though
that the reference will be the last one. That put then can kick off
a whole series of reference puts:

nfs_page
   nfs_open_context
      dentry
          inode

If the inode ends up being deleted, then the VFS will call
truncate_inode_pages. That function will try to take the page lock, but
it was already locked when migrate_page was called. The code
deadlocks.

Fix this by simply refusing the migration request if PagePrivate is
already set, indicating that the page is already associated with an
active read or write request.

We've had a customer test a backported version of this patch and
the preliminary results seem good.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Harshula Jayasuriya <harshula@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/write.c |   36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1714,34 +1714,20 @@ out_error:
 int nfs_migrate_page(struct address_space *mapping, struct page *newpage,
 		struct page *page)
 {
-	struct nfs_page *req;
-	int ret;
+	/*
+	 * If PagePrivate is set, then the page is currently associated with
+	 * an in-progress read or write request. Don't try to migrate it.
+	 *
+	 * FIXME: we could do this in principle, but we'll need a way to ensure
+	 *        that we can safely release the inode reference while holding
+	 *        the page lock.
+	 */
+	if (PagePrivate(page))
+		return -EBUSY;
 
 	nfs_fscache_release_page(page, GFP_KERNEL);
 
-	req = nfs_find_and_lock_request(page, false);
-	ret = PTR_ERR(req);
-	if (IS_ERR(req))
-		goto out;
-
-	ret = migrate_page(mapping, newpage, page);
-	if (!req)
-		goto out;
-	if (ret)
-		goto out_unlock;
-	page_cache_get(newpage);
-	spin_lock(&mapping->host->i_lock);
-	req->wb_page = newpage;
-	SetPagePrivate(newpage);
-	set_page_private(newpage, (unsigned long)req);
-	ClearPagePrivate(page);
-	set_page_private(page, 0);
-	spin_unlock(&mapping->host->i_lock);
-	page_cache_release(page);
-out_unlock:
-	nfs_clear_page_tag_locked(req);
-out:
-	return ret;
+	return migrate_page(mapping, newpage, page);
 }
 #endif
 


