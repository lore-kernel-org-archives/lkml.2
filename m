Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2IQAvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33482 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151Ab2IQAtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:50 -0400
Message-Id: <20120917003642.413673073@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 117/135] NFS: return error from decode_getfh in decode open
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

I'm not sure whether my expansion of the fix is correct here.

------------------

From: Weston Andros Adamson <dros@netapp.com>

commit 01913b49cf1dc6409a07dd2a4cc6af2e77f3c410 upstream.

If decode_getfh failed, nfs4_xdr_dec_open would return 0 since the last
decode_* call must have succeeded.

Signed-off-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[bwh: Backported to 3.2: this function makes two more function calls
 (no longer present in mainline) with the same issue, so fix them up
 similarly.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4xdr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -6113,12 +6113,15 @@ static int nfs4_xdr_dec_open(struct rpc_
 	status = decode_open(xdr, res);
 	if (status)
 		goto out;
-	if (decode_getfh(xdr, &res->fh) != 0)
+	status = decode_getfh(xdr, &res->fh);
+	if (status)
 		goto out;
-	if (decode_getfattr(xdr, res->f_attr, res->server,
-				!RPC_IS_ASYNC(rqstp->rq_task)) != 0)
+	status = decode_getfattr(xdr, res->f_attr, res->server,
+				 !RPC_IS_ASYNC(rqstp->rq_task));
+	if (status)
 		goto out;
-	if (decode_restorefh(xdr) != 0)
+	status = decode_restorefh(xdr);
+	if (status)
 		goto out;
 	decode_getfattr(xdr, res->dir_attr, res->server,
 			!RPC_IS_ASYNC(rqstp->rq_task));


