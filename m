Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab0LHBcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:32:52 -0500
Received: from kroah.org ([198.145.64.141]:49064 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab0LHBBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:43 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:36 2010
Message-Id: <20101208005736.104744573@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [147/289] nfs: handle lock context allocation failures in nfs_create_request
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 015f0212d51d85bd281a831639a769b4a1a3307a upstream.

nfs_get_lock_context can return NULL on an allocation failure.
Regression introduced by commit f11ac8db.

Reported-by: Steve Dickson <steved@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/pagelist.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -65,6 +65,13 @@ nfs_create_request(struct nfs_open_conte
 	if (req == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	/* get lock context early so we can deal with alloc failures */
+	req->wb_lock_context = nfs_get_lock_context(ctx);
+	if (req->wb_lock_context == NULL) {
+		nfs_page_free(req);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	/* Initialize the request struct. Initially, we assume a
 	 * long write-back delay. This will be adjusted in
 	 * update_nfs_request below if the region is not locked. */
@@ -79,7 +86,6 @@ nfs_create_request(struct nfs_open_conte
 	req->wb_pgbase	= offset;
 	req->wb_bytes   = count;
 	req->wb_context = get_nfs_open_context(ctx);
-	req->wb_lock_context = nfs_get_lock_context(ctx);
 	kref_init(&req->wb_kref);
 	return req;
 }


