Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab0LNAwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:52:46 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38497 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758461Ab0LNAwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:52:44 -0500
Date: Tue, 14 Dec 2010 11:52:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: linux-next: manual merge of the vfs-scale tree with the fuse tree
Message-Id: <20101214115239.7b105382.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Today's linux-next merge of the vfs-scale tree got a conflict in
fs/fuse/inode.c between commit 07e77dca8a1f17a724a9b7449f0ca02e70e9d057
("fuse: separate queue for FORGET requests") from the fuse tree and
commit 63f9f95ab724a86391d1f5370aacacac5f87fadc ("fs: icache RCU free
inodes") from the vfs-scale tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/fuse/inode.c
index 7ba4d35,a8b31da..0000000
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@@ -109,10 -111,24 +116,10 @@@ static void fuse_destroy_inode(struct i
  	struct fuse_inode *fi = get_fuse_inode(inode);
  	BUG_ON(!list_empty(&fi->write_files));
  	BUG_ON(!list_empty(&fi->queued_writes));
 -	if (fi->forget_req)
 -		fuse_request_free(fi->forget_req);
 +	kfree(fi->forget);
- 	kmem_cache_free(fuse_inode_cachep, inode);
+ 	call_rcu(&inode->i_rcu, fuse_i_callback);
  }
  
 -void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
 -		      u64 nodeid, u64 nlookup)
 -{
 -	struct fuse_forget_in *inarg = &req->misc.forget_in;
 -	inarg->nlookup = nlookup;
 -	req->in.h.opcode = FUSE_FORGET;
 -	req->in.h.nodeid = nodeid;
 -	req->in.numargs = 1;
 -	req->in.args[0].size = sizeof(struct fuse_forget_in);
 -	req->in.args[0].value = inarg;
 -	fuse_request_send_noreply(fc, req);
 -}
 -
  static void fuse_evict_inode(struct inode *inode)
  {
  	truncate_inode_pages(&inode->i_data, 0);
