Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965281Ab1KJEUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:20:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965282Ab1KJDlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:41:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:51 2011
Message-Id: <20111109213151.238176747@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peng Tao <peng_tao@emc.com>,
        Jim Rees <rees@umich.edu>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [091/264] pnfs: recoalesce when ld read pagelist fails
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Tao <bergwolf@gmail.com>

commit 9b7eecdcfeb943f130d86bbc249fde4994b6fe30 upstream.

For pnfs pagelist read failure, we need to pg_recoalesce and resend IO to
mds.

Signed-off-by: Peng Tao <peng_tao@emc.com>
Signed-off-by: Jim Rees <rees@umich.edu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/pnfs.c |   20 +++++++-------------
 fs/nfs/pnfs.h |    2 +-
 fs/nfs/read.c |   12 +++++++++++-
 3 files changed, 19 insertions(+), 15 deletions(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1262,23 +1262,17 @@ EXPORT_SYMBOL_GPL(pnfs_generic_pg_writep
 /*
  * Called by non rpc-based layout drivers
  */
-int
-pnfs_ld_read_done(struct nfs_read_data *data)
+void pnfs_ld_read_done(struct nfs_read_data *data)
 {
-	int status;
-
-	if (!data->pnfs_error) {
+	if (likely(!data->pnfs_error)) {
 		__nfs4_read_done_cb(data);
 		data->mds_ops->rpc_call_done(&data->task, data);
-		data->mds_ops->rpc_release(data);
-		return 0;
+	} else {
+		put_lseg(data->lseg);
+		data->lseg = NULL;
+		dprintk("pnfs write error = %d\n", data->pnfs_error);
 	}
-
-	dprintk("%s: pnfs_error=%d, retry via MDS\n", __func__,
-		data->pnfs_error);
-	status = nfs_initiate_read(data, NFS_CLIENT(data->inode),
-				   data->mds_ops);
-	return status ? : -EAGAIN;
+	data->mds_ops->rpc_release(data);
 }
 EXPORT_SYMBOL_GPL(pnfs_ld_read_done);
 
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -202,7 +202,7 @@ void pnfs_cleanup_layoutcommit(struct nf
 int pnfs_layoutcommit_inode(struct inode *inode, bool sync);
 int _pnfs_return_layout(struct inode *);
 void pnfs_ld_write_done(struct nfs_write_data *);
-int pnfs_ld_read_done(struct nfs_read_data *);
+void pnfs_ld_read_done(struct nfs_read_data *);
 struct pnfs_layout_segment *pnfs_update_layout(struct inode *ino,
 					       struct nfs_open_context *ctx,
 					       loff_t pos,
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -541,13 +541,23 @@ static void nfs_readpage_result_full(str
 static void nfs_readpage_release_full(void *calldata)
 {
 	struct nfs_read_data *data = calldata;
+	struct nfs_pageio_descriptor pgio;
 
+	if (data->pnfs_error) {
+		nfs_pageio_init_read_mds(&pgio, data->inode);
+		pgio.pg_recoalesce = 1;
+	}
 	while (!list_empty(&data->pages)) {
 		struct nfs_page *req = nfs_list_entry(data->pages.next);
 
 		nfs_list_remove_request(req);
-		nfs_readpage_release(req);
+		if (!data->pnfs_error)
+			nfs_readpage_release(req);
+		else
+			nfs_pageio_add_request(&pgio, req);
 	}
+	if (data->pnfs_error)
+		nfs_pageio_complete(&pgio);
 	nfs_readdata_release(calldata);
 }
 


