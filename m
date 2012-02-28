Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073Ab2B1BJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:09:17 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37330 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965045Ab2B1BI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:08:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.218.228 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010430.744352074@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Andy Adamson <andros@netapp.com>
Subject: [ 15/72] NFSv4: Fix an Oops in the NFSv4 getacl code
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 331818f1c468a24e581aedcbe52af799366a9dfe upstream.

Commit bf118a342f10dafe44b14451a1392c3254629a1f (NFSv4: include bitmap
in nfsv4 get acl data) introduces the 'acl_scratch' page for the case
where we may need to decode multi-page data. However it fails to take
into account the fact that the variable may be NULL (for the case where
we're not doing multi-page decode), and it also attaches it to the
encoding xdr_stream rather than the decoding one.

The immediate result is an Oops in nfs4_xdr_enc_getacl due to the
call to page_address() with a NULL page pointer.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andy Adamson <andros@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c       |    8 ++++----
 fs/nfs/nfs4xdr.c        |    5 ++++-
 include/linux/nfs_xdr.h |    2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3568,8 +3568,8 @@ static ssize_t __nfs4_get_acl_uncached(s
 	}
 	if (npages > 1) {
 		/* for decoding across pages */
-		args.acl_scratch = alloc_page(GFP_KERNEL);
-		if (!args.acl_scratch)
+		res.acl_scratch = alloc_page(GFP_KERNEL);
+		if (!res.acl_scratch)
 			goto out_free;
 	}
 	args.acl_len = npages * PAGE_SIZE;
@@ -3605,8 +3605,8 @@ out_free:
 	for (i = 0; i < npages; i++)
 		if (pages[i])
 			__free_page(pages[i]);
-	if (args.acl_scratch)
-		__free_page(args.acl_scratch);
+	if (res.acl_scratch)
+		__free_page(res.acl_scratch);
 	return ret;
 }
 
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -2522,7 +2522,6 @@ static void nfs4_xdr_enc_getacl(struct r
 
 	xdr_inline_pages(&req->rq_rcv_buf, replen << 2,
 		args->acl_pages, args->acl_pgbase, args->acl_len);
-	xdr_set_scratch_buffer(xdr, page_address(args->acl_scratch), PAGE_SIZE);
 
 	encode_nops(&hdr);
 }
@@ -6034,6 +6033,10 @@ nfs4_xdr_dec_getacl(struct rpc_rqst *rqs
 	struct compound_hdr hdr;
 	int status;
 
+	if (res->acl_scratch != NULL) {
+		void *p = page_address(res->acl_scratch);
+		xdr_set_scratch_buffer(xdr, p, PAGE_SIZE);
+	}
 	status = decode_compound_hdr(xdr, &hdr);
 	if (status)
 		goto out;
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -602,7 +602,6 @@ struct nfs_getaclargs {
 	size_t				acl_len;
 	unsigned int			acl_pgbase;
 	struct page **			acl_pages;
-	struct page *			acl_scratch;
 	struct nfs4_sequence_args 	seq_args;
 };
 
@@ -612,6 +611,7 @@ struct nfs_getaclres {
 	size_t				acl_len;
 	size_t				acl_data_offset;
 	int				acl_flags;
+	struct page *			acl_scratch;
 	struct nfs4_sequence_res	seq_res;
 };
 


