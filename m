Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab0C3XSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:18:37 -0400
Received: from kroah.org ([198.145.64.141]:45225 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab0C3XSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:17 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:37 2010
Message-Id: <20100330225637.492975019@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [060/116] NFS: Prevent another deadlock in nfs_release_page()
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit d812e575822a2b7ab1a7cadae2571505ec6ec2bd upstream.

We should not attempt to free the page if __GFP_FS is not set. Otherwise we
can deadlock as per

  http://bugzilla.kernel.org/show_bug.cgi?id=15578

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -486,7 +486,8 @@ static int nfs_release_page(struct page
 {
 	dfprintk(PAGECACHE, "NFS: release_page(%p)\n", page);
 
-	if (gfp & __GFP_WAIT)
+	/* Only do I/O if gfp is a superset of GFP_KERNEL */
+	if ((gfp & GFP_KERNEL) == GFP_KERNEL)
 		nfs_wb_page(page->mapping->host, page);
 	/* If PagePrivate() is set, then the page is not freeable */
 	if (PagePrivate(page))


