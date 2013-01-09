Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708Ab3AIVSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:18:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:42733 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab3AIUj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Weston Andros Adamson <dros@netapp.com>, Tejun Heo <tj@kernel.org>,
        Bruce Fields <bfields@fieldses.org>
Subject: [ 053/123] NFS: Ensure that we free the rpc_task after read and write cleanups are done
Date: Wed,  9 Jan 2013 12:34:52 -0800
Message-Id: <20130109201505.347693293@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 6db6dd7d3fd8f7c765dabc376493d6791ab28bd6 upstream.

This patch ensures that we free the rpc_task after the cleanup callbacks
are done in order to avoid a deadlock problem that can be triggered if
the callback needs to wait for another workqueue item to complete.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Weston Andros Adamson <dros@netapp.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Bruce Fields <bfields@fieldses.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/read.c  |   10 +++++++---
 fs/nfs/write.c |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -91,12 +91,16 @@ void nfs_readdata_release(struct nfs_rea
 	put_nfs_open_context(rdata->args.context);
 	if (rdata->pages.pagevec != rdata->pages.page_array)
 		kfree(rdata->pages.pagevec);
-	if (rdata != &read_header->rpc_data)
-		kfree(rdata);
-	else
+	if (rdata == &read_header->rpc_data) {
 		rdata->header = NULL;
+		rdata = NULL;
+	}
 	if (atomic_dec_and_test(&hdr->refcnt))
 		hdr->completion_ops->completion(hdr);
+	/* Note: we only free the rpc_task after callbacks are done.
+	 * See the comment in rpc_free_task() for why
+	 */
+	kfree(rdata);
 }
 EXPORT_SYMBOL_GPL(nfs_readdata_release);
 
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -126,12 +126,16 @@ void nfs_writedata_release(struct nfs_wr
 	put_nfs_open_context(wdata->args.context);
 	if (wdata->pages.pagevec != wdata->pages.page_array)
 		kfree(wdata->pages.pagevec);
-	if (wdata != &write_header->rpc_data)
-		kfree(wdata);
-	else
+	if (wdata == &write_header->rpc_data) {
 		wdata->header = NULL;
+		wdata = NULL;
+	}
 	if (atomic_dec_and_test(&hdr->refcnt))
 		hdr->completion_ops->completion(hdr);
+	/* Note: we only free the rpc_task after callbacks are done.
+	 * See the comment in rpc_free_task() for why
+	 */
+	kfree(wdata);
 }
 EXPORT_SYMBOL_GPL(nfs_writedata_release);
 


