Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965107Ab0HFTAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:00:20 -0400
Received: from kroah.org ([198.145.64.141]:58496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964980Ab0HFTAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:00:01 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:34 2010
Message-Id: <20100806185834.291812353@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:57:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [05/34] NFS: kswapd must not block in nfs_release_page
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit b608b283a962caaa280756bc8563016a71712acf upstream

See https://bugzilla.kernel.org/show_bug.cgi?id=16056

If other processes are blocked waiting for kswapd to free up some memory so
that they can make progress, then we cannot allow kswapd to block on those
processes.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/file.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -27,6 +27,8 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/aio.h>
+#include <linux/gfp.h>
+#include <linux/swap.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -484,11 +486,19 @@ static void nfs_invalidate_page(struct p
  */
 static int nfs_release_page(struct page *page, gfp_t gfp)
 {
+	struct address_space *mapping = page->mapping;
+
 	dfprintk(PAGECACHE, "NFS: release_page(%p)\n", page);
 
 	/* Only do I/O if gfp is a superset of GFP_KERNEL */
-	if ((gfp & GFP_KERNEL) == GFP_KERNEL)
-		nfs_wb_page(page->mapping->host, page);
+	if (mapping && (gfp & GFP_KERNEL) == GFP_KERNEL) {
+		int how = FLUSH_SYNC;
+
+		/* Don't let kswapd deadlock waiting for OOM RPC calls */
+		if (current_is_kswapd())
+			how = 0;
+		nfs_commit_inode(mapping->host, how);
+	}
 	/* If PagePrivate() is set, then the page is not freeable */
 	if (PagePrivate(page))
 		return 0;


