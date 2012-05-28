Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2E1DgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:36:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52231 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122Ab2E1D3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:46 -0400
Message-Id: <20120528031217.901560287@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sachin Prabhu <sprabhu@redhat.com>,
        Jian Li <jiali@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 109/117] Avoid beyond bounds copy while caching ACL
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Prabhu <sprabhu@redhat.com>

commit 5794d21ef4639f0e33440927bb903f9598c21e92 upstream.

When attempting to cache ACLs returned from the server, if the bitmap
size + the ACL size is greater than a PAGE_SIZE but the ACL size itself
is smaller than a PAGE_SIZE, we can read past the buffer page boundary.

Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
Reported-by: Jian Li <jiali@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c |   12 +++++-------
 fs/nfs/nfs4xdr.c  |    2 +-
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f5f125f..2ce0698 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3628,16 +3628,16 @@ out:
 	return ret;
 }
 
-static void nfs4_write_cached_acl(struct inode *inode, const char *buf, size_t acl_len)
+static void nfs4_write_cached_acl(struct inode *inode, struct page **pages, size_t pgbase, size_t acl_len)
 {
 	struct nfs4_cached_acl *acl;
 
-	if (buf && acl_len <= PAGE_SIZE) {
+	if (pages && acl_len <= PAGE_SIZE) {
 		acl = kmalloc(sizeof(*acl) + acl_len, GFP_KERNEL);
 		if (acl == NULL)
 			goto out;
 		acl->cached = 1;
-		memcpy(acl->data, buf, acl_len);
+		_copy_from_pages(acl->data, pages, pgbase, acl_len);
 	} else {
 		acl = kmalloc(sizeof(*acl), GFP_KERNEL);
 		if (acl == NULL)
@@ -3670,7 +3670,6 @@ static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t bu
 	struct nfs_getaclres res = {
 		.acl_len = buflen,
 	};
-	void *resp_buf;
 	struct rpc_message msg = {
 		.rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_GETACL],
 		.rpc_argp = &args,
@@ -3705,7 +3704,6 @@ static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t bu
 	 * the page we send as a guess */
 	if (buf == NULL)
 		res.acl_flags |= NFS4_ACL_LEN_REQUEST;
-	resp_buf = page_address(pages[0]);
 
 	dprintk("%s  buf %p buflen %zu npages %d args.acl_len %zu\n",
 		__func__, buf, buflen, npages, args.acl_len);
@@ -3716,9 +3714,9 @@ static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t bu
 
 	acl_len = res.acl_len - res.acl_data_offset;
 	if (acl_len > args.acl_len)
-		nfs4_write_cached_acl(inode, NULL, acl_len);
+		nfs4_write_cached_acl(inode, NULL, 0, acl_len);
 	else
-		nfs4_write_cached_acl(inode, resp_buf + res.acl_data_offset,
+		nfs4_write_cached_acl(inode, pages, res.acl_data_offset,
 				      acl_len);
 	if (buf) {
 		ret = -ERANGE;
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 9312dd7..203c096 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4940,7 +4940,7 @@ static int decode_getacl(struct xdr_stream *xdr, struct rpc_rqst *req,
 				res->acl_len = attrlen;
 				goto out;
 			}
-			dprintk("NFS: acl reply: attrlen %zu > page_len %u\n",
+			dprintk("NFS: acl reply: attrlen %u > page_len %zu\n",
 					attrlen, page_len);
 			return -EINVAL;
 		}


