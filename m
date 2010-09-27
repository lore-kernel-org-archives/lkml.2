Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab0I0OCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:02:18 -0400
Received: from mx2.netapp.com ([216.240.18.37]:41416 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0I0OCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:02:17 -0400
X-IronPort-AV: E=Sophos;i="4.57,243,1283756400"; 
   d="scan'208";a="458805494"
Message-ID: <4CA0A3E5.8000405@netapp.com>
Date: Mon, 27 Sep 2010 10:02:13 -0400
From: Bryan Schumaker <bjschuma@netapp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Lightning/1.0b2 Lanikai/3.1.4
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the  tree (nfs tree
 related)
References: <20100927152304.a6463447.sfr@canb.auug.org.au> <1285588055.19362.7.camel@heimdal.trondhjem.org>
In-Reply-To: <1285588055.19362.7.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 07:47 AM, Trond Myklebust wrote:
> Agreed: fs/nfs/dir.c needs to #include <vmalloc.h> in order to use those
> functions. Bryan, can you please fix that up?

No problem.  An updated patch is pasted below.

-Bryan



We can use vmapped pages to read more information from the network at once.
This will reduce the number of calls needed to complete a readdir.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index e734072..9e2fcc8 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -901,8 +901,8 @@ static void nfs_server_set_fsinfo(struct nfs_server *server, struct nfs_fsinfo *
 	server->wtmult = nfs_block_bits(fsinfo->wtmult, NULL);
 
 	server->dtsize = nfs_block_size(fsinfo->dtpref, NULL);
-	if (server->dtsize > PAGE_CACHE_SIZE)
-		server->dtsize = PAGE_CACHE_SIZE;
+	if (server->dtsize > PAGE_CACHE_SIZE * NFS_MAX_READDIR_PAGES)
+		server->dtsize = PAGE_CACHE_SIZE * NFS_MAX_READDIR_PAGES;
 	if (server->dtsize > server->rsize)
 		server->dtsize = server->rsize;
 
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 8a54a07..207cc47 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -33,6 +33,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
+#include <linux/vmalloc.h>
 
 #include "nfs4_fs.h"
 #include "delegation.h"
@@ -326,7 +327,7 @@ out:
 
 /* Fill a page with xdr information before transferring to the cache page */
 static
-int nfs_readdir_xdr_filler(struct page *xdr_page, nfs_readdir_descriptor_t *desc,
+int nfs_readdir_xdr_filler(struct page **pages, nfs_readdir_descriptor_t *desc,
 			struct nfs_entry *entry, struct file *file, struct inode *inode)
 {
 	struct rpc_cred	*cred = nfs_file_cred(file);
@@ -336,7 +337,7 @@ int nfs_readdir_xdr_filler(struct page *xdr_page, nfs_readdir_descriptor_t *desc
  again:
 	timestamp = jiffies;
 	gencount = nfs_inc_attr_generation_counter();
-	error = NFS_PROTO(inode)->readdir(file->f_path.dentry, cred, entry->cookie, xdr_page,
+	error = NFS_PROTO(inode)->readdir(file->f_path.dentry, cred, entry->cookie, pages,
 					  NFS_SERVER(inode)->dtsize, desc->plus);
 	if (error < 0) {
 		/* We requested READDIRPLUS, but the server doesn't grok it */
@@ -437,22 +438,63 @@ out:
 /* Perform conversion from xdr to cache array */
 static
 void nfs_readdir_page_filler(nfs_readdir_descriptor_t *desc, struct nfs_entry *entry,
-				struct page *xdr_page, struct page *page)
+				void *xdr_page, struct page *page)
 {
-	__be32 *ptr = kmap(xdr_page);
+	__be32 *ptr = xdr_page;
 	while (xdr_decode(desc, entry, &ptr) == 0) {
 		if (nfs_readdir_add_to_array(entry, page) == -1)
 			break;
 		if (desc->plus == 1)
 			nfs_prime_dcache(desc->file->f_path.dentry, entry);
 	}
-	kunmap(xdr_page);
+}
+
+static
+void nfs_readdir_free_pagearray(struct page **pages, unsigned int npages)
+{
+	unsigned int i;
+	for (i = 0; i < npages; i++)
+		put_page(pages[i]);
+}
+
+static
+void nfs_readdir_free_large_page(void *ptr, struct page **pages,
+		unsigned int npages)
+{
+	vm_unmap_ram(ptr, npages);
+	nfs_readdir_free_pagearray(pages, npages);
+}
+
+/*
+ * nfs_readdir_large_page will allocate pages that must be freed with a call
+ * to nfs_readdir_free_large_page
+ */
+static
+void *nfs_readdir_large_page(struct page **pages, unsigned int npages)
+{
+	void *ptr;
+	unsigned int i;
+
+	for (i = 0; i < npages; i++) {
+		struct page *page = alloc_page(GFP_KERNEL);
+		if (page == NULL)
+			goto out_freepages;
+		pages[i] = page;
+	}
+
+	ptr = vm_map_ram(pages, NFS_MAX_READDIR_PAGES, 0, PAGE_KERNEL);
+	if (!IS_ERR_OR_NULL(ptr))
+		return ptr;
+out_freepages:
+	nfs_readdir_free_pagearray(pages, i);
+	return NULL;
 }
 
 static
 int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page, struct inode *inode)
 {
-	struct page *xdr_page;
+	struct page *pages[NFS_MAX_READDIR_PAGES];
+	void *pages_ptr = NULL;
 	struct nfs_entry entry;
 	struct file	*file = desc->file;
 	struct nfs_cache_array *array;
@@ -470,17 +512,17 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
 	memset(array, 0, sizeof(struct nfs_cache_array));
 	array->eof_index = -1;
 
-	xdr_page = alloc_page(GFP_KERNEL);
-	if (!xdr_page)
+	pages_ptr = nfs_readdir_large_page(pages, ARRAY_SIZE(pages));
+	if (!pages_ptr)
 		goto out_release_array;
 	do {
-		status = nfs_readdir_xdr_filler(xdr_page, desc, &entry, file, inode);
+		status = nfs_readdir_xdr_filler(pages, desc, &entry, file, inode);
 		if (status < 0)
 			break;
-		nfs_readdir_page_filler(desc, &entry, xdr_page, page);
+		nfs_readdir_page_filler(desc, &entry, pages_ptr, page);
 	} while (array->eof_index < 0 && array->size < MAX_READDIR_ARRAY);
 
-	put_page(xdr_page);
+	nfs_readdir_free_large_page(pages_ptr, pages, ARRAY_SIZE(pages));
 out_release_array:
 	nfs_readdir_release_array(page);
 out:
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index c961bc9..f64382c 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -63,6 +63,12 @@ struct nfs_clone_mount {
 #define NFS_UNSPEC_PORT		(-1)
 
 /*
+ * Maximum number of pages that readdir can use for creating
+ * a vmapped array of pages.
+ */
+#define NFS_MAX_READDIR_PAGES 8
+
+/*
  * In-kernel mount arguments
  */
 struct nfs_parsed_mount_data {
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index fabb4f2..033ed04 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -611,7 +611,7 @@ out:
  */
 static int
 nfs3_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
-		  u64 cookie, struct page *page, unsigned int count, int plus)
+		  u64 cookie, struct page **pages, unsigned int count, int plus)
 {
 	struct inode		*dir = dentry->d_inode;
 	__be32			*verf = NFS_COOKIEVERF(dir);
@@ -621,7 +621,7 @@ nfs3_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 		.verf		= {verf[0], verf[1]},
 		.plus		= plus,
 		.count		= count,
-		.pages		= &page
+		.pages		= pages
 	};
 	struct nfs3_readdirres	res = {
 		.verf		= verf,
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 089da5b..479f422 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2896,12 +2896,12 @@ static int nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
 }
 
 static int _nfs4_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
-                  u64 cookie, struct page *page, unsigned int count, int plus)
+		u64 cookie, struct page **pages, unsigned int count, int plus)
 {
 	struct inode		*dir = dentry->d_inode;
 	struct nfs4_readdir_arg args = {
 		.fh = NFS_FH(dir),
-		.pages = &page,
+		.pages = pages,
 		.pgbase = 0,
 		.count = count,
 		.bitmask = NFS_SERVER(dentry->d_inode)->attr_bitmask,
@@ -2932,14 +2932,14 @@ static int _nfs4_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
 }
 
 static int nfs4_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
-                  u64 cookie, struct page *page, unsigned int count, int plus)
+		u64 cookie, struct page **pages, unsigned int count, int plus)
 {
 	struct nfs4_exception exception = { };
 	int err;
 	do {
 		err = nfs4_handle_exception(NFS_SERVER(dentry->d_inode),
 				_nfs4_proc_readdir(dentry, cred, cookie,
-					page, count, plus),
+					pages, count, plus),
 				&exception);
 	} while (exception.retry);
 	return err;
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 08ef912..f2e2f97 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4225,7 +4225,7 @@ static int decode_readdir(struct xdr_stream *xdr, struct rpc_rqst *req, struct n
 		pglen = recvd;
 	xdr_read_pages(xdr, pglen);
 
-	BUG_ON(pglen + readdir->pgbase > PAGE_CACHE_SIZE);
+	BUG_ON(pglen + readdir->pgbase > PAGE_CACHE_SIZE * NFS_MAX_READDIR_PAGES);
 	kaddr = p = kmap_atomic(page, KM_USER0);
 	end = p + ((pglen + readdir->pgbase) >> 2);
 	entry = p;
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 611bec2..3f1c181 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -519,14 +519,14 @@ nfs_proc_rmdir(struct inode *dir, struct qstr *name)
  */
 static int
 nfs_proc_readdir(struct dentry *dentry, struct rpc_cred *cred,
-		 u64 cookie, struct page *page, unsigned int count, int plus)
+		 u64 cookie, struct page **pages, unsigned int count, int plus)
 {
 	struct inode		*dir = dentry->d_inode;
 	struct nfs_readdirargs	arg = {
 		.fh		= NFS_FH(dir),
 		.cookie		= cookie,
 		.count		= count,
-		.pages		= &page,
+		.pages		= pages,
 	};
 	struct rpc_message	msg = {
 		.rpc_proc	= &nfs_procedures[NFSPROC_READDIR],
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index fc46192..7d8cafa 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1044,7 +1044,7 @@ struct nfs_rpc_ops {
 	int	(*mkdir)   (struct inode *, struct dentry *, struct iattr *);
 	int	(*rmdir)   (struct inode *, struct qstr *);
 	int	(*readdir) (struct dentry *, struct rpc_cred *,
-			    u64, struct page *, unsigned int, int);
+			    u64, struct page **, unsigned int, int);
 	int	(*mknod)   (struct inode *, struct dentry *, struct iattr *,
 			    dev_t);
 	int	(*statfs)  (struct nfs_server *, struct nfs_fh *,





