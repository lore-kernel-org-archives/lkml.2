Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab0C3XMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:12:52 -0400
Received: from kroah.org ([198.145.64.141]:49149 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600Ab0C3XMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:48 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:47 2010
Message-Id: <20100330225846.951960815@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:58:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       David Howells <dhowells@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [62/89] NFS: Fix a bug in nfs_fscache_release_page()
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 2c1740098c708b465e87637b237feb2fd98f129a upstream.

Not having an fscache cookie is perfectly valid if the user didn't mount
with the fscache option.

This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=15234

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/fscache.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -337,21 +337,20 @@ void nfs_fscache_reset_inode_cookie(stru
  */
 int nfs_fscache_release_page(struct page *page, gfp_t gfp)
 {
-	struct nfs_inode *nfsi = NFS_I(page->mapping->host);
-	struct fscache_cookie *cookie = nfsi->fscache;
-
-	BUG_ON(!cookie);
-
-	if (fscache_check_page_write(cookie, page)) {
-		if (!(gfp & __GFP_WAIT))
-			return 0;
-		fscache_wait_on_page_write(cookie, page);
-	}
-
 	if (PageFsCache(page)) {
+		struct nfs_inode *nfsi = NFS_I(page->mapping->host);
+		struct fscache_cookie *cookie = nfsi->fscache;
+
+		BUG_ON(!cookie);
 		dfprintk(FSCACHE, "NFS: fscache releasepage (0x%p/0x%p/0x%p)\n",
 			 cookie, page, nfsi);
 
+		if (fscache_check_page_write(cookie, page)) {
+			if (!(gfp & __GFP_WAIT))
+				return 0;
+			fscache_wait_on_page_write(cookie, page);
+		}
+
 		fscache_uncache_page(cookie, page);
 		nfs_add_fscache_stats(page->mapping->host,
 				      NFSIOS_FSCACHE_PAGES_UNCACHED, 1);


