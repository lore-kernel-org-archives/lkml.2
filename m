Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab2E1DcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:32:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52226 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754165Ab2E1D3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:52 -0400
Message-Id: <20120528031217.765799936@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sachin Prabhu <sprabhu@redhat.com>,
        Jian Li <jiali@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 108/117] Avoid reading past buffer when calling GETACL
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

commit 5a00689930ab975fdd1b37b034475017e460cf2a upstream.

Bug noticed in commit
bf118a342f10dafe44b14451a1392c3254629a1f

When calling GETACL, if the size of the bitmap array, the length
attribute and the acl returned by the server is greater than the
allocated buffer(args.acl_len), we can Oops with a General Protection
fault at _copy_from_pages() when we attempt to read past the pages
allocated.

This patch allocates an extra PAGE for the bitmap and checks to see that
the bitmap + attribute_length + ACLs don't exceed the buffer space
allocated to it.

Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
Reported-by: Jian Li <jiali@redhat.com>
[Trond: Fixed a size_t vs unsigned int printk() warning]
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c |   16 ++++++++++------
 fs/nfs/nfs4xdr.c  |   18 +++++++++++-------
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 60d5f4c..f5f125f 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3684,19 +3684,23 @@ static ssize_t __nfs4_get_acl_uncached(struct inode *inode, void *buf, size_t bu
 	if (npages == 0)
 		npages = 1;
 
+	/* Add an extra page to handle the bitmap returned */
+	npages++;
+
 	for (i = 0; i < npages; i++) {
 		pages[i] = alloc_page(GFP_KERNEL);
 		if (!pages[i])
 			goto out_free;
 	}
-	if (npages > 1) {
-		/* for decoding across pages */
-		res.acl_scratch = alloc_page(GFP_KERNEL);
-		if (!res.acl_scratch)
-			goto out_free;
-	}
+
+	/* for decoding across pages */
+	res.acl_scratch = alloc_page(GFP_KERNEL);
+	if (!res.acl_scratch)
+		goto out_free;
+
 	args.acl_len = npages * PAGE_SIZE;
 	args.acl_pgbase = 0;
+
 	/* Let decode_getfacl know not to fail if the ACL data is larger than
 	 * the page we send as a guess */
 	if (buf == NULL)
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 77fc5f9..9312dd7 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4902,11 +4902,19 @@ static int decode_getacl(struct xdr_stream *xdr, struct rpc_rqst *req,
 		 bitmap[3] = {0};
 	struct kvec *iov = req->rq_rcv_buf.head;
 	int status;
+	size_t page_len = xdr->buf->page_len;
 
 	res->acl_len = 0;
 	if ((status = decode_op_hdr(xdr, OP_GETATTR)) != 0)
 		goto out;
+
 	bm_p = xdr->p;
+	res->acl_data_offset = be32_to_cpup(bm_p) + 2;
+	res->acl_data_offset <<= 2;
+	/* Check if the acl data starts beyond the allocated buffer */
+	if (res->acl_data_offset > page_len)
+		return -ERANGE;
+
 	if ((status = decode_attr_bitmap(xdr, bitmap)) != 0)
 		goto out;
 	if ((status = decode_attr_length(xdr, &attrlen, &savep)) != 0)
@@ -4916,28 +4924,24 @@ static int decode_getacl(struct xdr_stream *xdr, struct rpc_rqst *req,
 		return -EIO;
 	if (likely(bitmap[0] & FATTR4_WORD0_ACL)) {
 		size_t hdrlen;
-		u32 recvd;
 
 		/* The bitmap (xdr len + bitmaps) and the attr xdr len words
 		 * are stored with the acl data to handle the problem of
 		 * variable length bitmaps.*/
 		xdr->p = bm_p;
-		res->acl_data_offset = be32_to_cpup(bm_p) + 2;
-		res->acl_data_offset <<= 2;
 
 		/* We ignore &savep and don't do consistency checks on
 		 * the attr length.  Let userspace figure it out.... */
 		hdrlen = (u8 *)xdr->p - (u8 *)iov->iov_base;
 		attrlen += res->acl_data_offset;
-		recvd = req->rq_rcv_buf.len - hdrlen;
-		if (attrlen > recvd) {
+		if (attrlen > page_len) {
 			if (res->acl_flags & NFS4_ACL_LEN_REQUEST) {
 				/* getxattr interface called with a NULL buf */
 				res->acl_len = attrlen;
 				goto out;
 			}
-			dprintk("NFS: acl reply: attrlen %u > recvd %u\n",
-					attrlen, recvd);
+			dprintk("NFS: acl reply: attrlen %zu > page_len %u\n",
+					attrlen, page_len);
 			return -EINVAL;
 		}
 		xdr_read_pages(xdr, attrlen);


