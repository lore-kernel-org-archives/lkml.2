Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1HCXk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:40:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab1HCX1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:27:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:49 2011
Message-Id: <20110803221249.303937980@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peng Tao <peng_tao@emc.com>, Boaz Harrosh <bharrosh@panasas.com>,
        Jim Rees <rees@umich.edu>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [053/102] pnfs: save layoutcommit cred at layout header init
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peng Tao <bergwolf@gmail.com>

commit 9fa4075878a5faac872a63f4a97ce79c776264e9 upstream.

No need to save it for every lseg.
No need to save it at every pnfs_set_layoutcommit.

[Needed in v3.0]
Signed-off-by: Peng Tao <peng_tao@emc.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Jim Rees <rees@umich.edu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/pnfs.c |   21 +++++++++++----------
 fs/nfs/pnfs.h |    2 +-
 2 files changed, 12 insertions(+), 11 deletions(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -189,6 +189,7 @@ static void
 pnfs_free_layout_hdr(struct pnfs_layout_hdr *lo)
 {
 	struct pnfs_layoutdriver_type *ld = NFS_SERVER(lo->plh_inode)->pnfs_curr_ld;
+	put_rpccred(lo->plh_lc_cred);
 	return ld->alloc_layout_hdr ? ld->free_layout_hdr(lo) : kfree(lo);
 }
 
@@ -805,7 +806,9 @@ out:
 }
 
 static struct pnfs_layout_hdr *
-alloc_init_layout_hdr(struct inode *ino, gfp_t gfp_flags)
+alloc_init_layout_hdr(struct inode *ino,
+		      struct nfs_open_context *ctx,
+		      gfp_t gfp_flags)
 {
 	struct pnfs_layout_hdr *lo;
 
@@ -817,11 +820,14 @@ alloc_init_layout_hdr(struct inode *ino,
 	INIT_LIST_HEAD(&lo->plh_segs);
 	INIT_LIST_HEAD(&lo->plh_bulk_recall);
 	lo->plh_inode = ino;
+	lo->plh_lc_cred = get_rpccred(ctx->state->owner->so_cred);
 	return lo;
 }
 
 static struct pnfs_layout_hdr *
-pnfs_find_alloc_layout(struct inode *ino, gfp_t gfp_flags)
+pnfs_find_alloc_layout(struct inode *ino,
+		       struct nfs_open_context *ctx,
+		       gfp_t gfp_flags)
 {
 	struct nfs_inode *nfsi = NFS_I(ino);
 	struct pnfs_layout_hdr *new = NULL;
@@ -836,7 +842,7 @@ pnfs_find_alloc_layout(struct inode *ino
 			return nfsi->layout;
 	}
 	spin_unlock(&ino->i_lock);
-	new = alloc_init_layout_hdr(ino, gfp_flags);
+	new = alloc_init_layout_hdr(ino, ctx, gfp_flags);
 	spin_lock(&ino->i_lock);
 
 	if (likely(nfsi->layout == NULL))	/* Won the race? */
@@ -928,7 +934,7 @@ pnfs_update_layout(struct inode *ino,
 	if (!pnfs_enabled_sb(NFS_SERVER(ino)))
 		return NULL;
 	spin_lock(&ino->i_lock);
-	lo = pnfs_find_alloc_layout(ino, gfp_flags);
+	lo = pnfs_find_alloc_layout(ino, ctx, gfp_flags);
 	if (lo == NULL) {
 		dprintk("%s ERROR: can't get pnfs_layout_hdr\n", __func__);
 		goto out_unlock;
@@ -1218,8 +1224,6 @@ pnfs_set_layoutcommit(struct nfs_write_d
 	if (!test_and_set_bit(NFS_INO_LAYOUTCOMMIT, &nfsi->flags)) {
 		/* references matched in nfs4_layoutcommit_release */
 		get_lseg(wdata->lseg);
-		wdata->lseg->pls_lc_cred =
-			get_rpccred(wdata->args.context->state->owner->so_cred);
 		mark_as_dirty = true;
 		dprintk("%s: Set layoutcommit for inode %lu ",
 			__func__, wdata->inode->i_ino);
@@ -1251,7 +1255,6 @@ pnfs_layoutcommit_inode(struct inode *in
 	struct nfs4_layoutcommit_data *data;
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct pnfs_layout_segment *lseg;
-	struct rpc_cred *cred;
 	loff_t end_pos;
 	int status = 0;
 
@@ -1281,9 +1284,7 @@ pnfs_layoutcommit_inode(struct inode *in
 	lseg = pnfs_list_write_lseg(inode);
 
 	end_pos = nfsi->layout->plh_lwb;
-	cred = lseg->pls_lc_cred;
 	nfsi->layout->plh_lwb = 0;
-	lseg->pls_lc_cred = NULL;
 
 	memcpy(&data->args.stateid.data, nfsi->layout->plh_stateid.data,
 		sizeof(nfsi->layout->plh_stateid.data));
@@ -1291,7 +1292,7 @@ pnfs_layoutcommit_inode(struct inode *in
 
 	data->args.inode = inode;
 	data->lseg = lseg;
-	data->cred = cred;
+	data->cred = get_rpccred(nfsi->layout->plh_lc_cred);
 	nfs_fattr_init(&data->fattr);
 	data->args.bitmask = NFS_SERVER(inode)->cache_consistency_bitmask;
 	data->res.fattr = &data->fattr;
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -44,7 +44,6 @@ struct pnfs_layout_segment {
 	atomic_t pls_refcount;
 	unsigned long pls_flags;
 	struct pnfs_layout_hdr *pls_layout;
-	struct rpc_cred	*pls_lc_cred; /* LAYOUTCOMMIT credential */
 };
 
 enum pnfs_try_status {
@@ -124,6 +123,7 @@ struct pnfs_layout_hdr {
 	u32			plh_barrier; /* ignore lower seqids */
 	unsigned long		plh_flags;
 	loff_t			plh_lwb; /* last write byte for layoutcommit */
+	struct rpc_cred		*plh_lc_cred; /* layoutcommit cred */
 	struct inode		*plh_inode;
 };
 


