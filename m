Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab3AIUj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:39:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:42702 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab3AIUjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 41/80] nfsd4: fix oops on unusual readlike compound
Date: Wed,  9 Jan 2013 12:35:33 -0800
Message-Id: <20130109201505.675850523@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit d5f50b0c290431c65377c4afa1c764e2c3fe5305 upstream.

If the argument and reply together exceed the maximum payload size, then
a reply with a read-like operation can overlow the rq_pages array.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2920,11 +2920,16 @@ nfsd4_encode_read(struct nfsd4_compoundr
 	len = maxcount;
 	v = 0;
 	while (len > 0) {
-		pn = resp->rqstp->rq_resused++;
+		pn = resp->rqstp->rq_resused;
+		if (!resp->rqstp->rq_respages[pn]) { /* ran out of pages */
+			maxcount -= len;
+			break;
+		}
 		resp->rqstp->rq_vec[v].iov_base =
 			page_address(resp->rqstp->rq_respages[pn]);
 		resp->rqstp->rq_vec[v].iov_len =
 			len < PAGE_SIZE ? len : PAGE_SIZE;
+		resp->rqstp->rq_resused++;
 		v++;
 		len -= PAGE_SIZE;
 	}
@@ -2970,6 +2975,8 @@ nfsd4_encode_readlink(struct nfsd4_compo
 		return nfserr;
 	if (resp->xbuf->page_len)
 		return nfserr_resource;
+	if (!resp->rqstp->rq_respages[resp->rqstp->rq_resused])
+		return nfserr_resource;
 
 	page = page_address(resp->rqstp->rq_respages[resp->rqstp->rq_resused++]);
 
@@ -3019,6 +3026,8 @@ nfsd4_encode_readdir(struct nfsd4_compou
 		return nfserr;
 	if (resp->xbuf->page_len)
 		return nfserr_resource;
+	if (!resp->rqstp->rq_respages[resp->rqstp->rq_resused])
+		return nfserr_resource;
 
 	RESERVE_SPACE(NFS4_VERIFIER_SIZE);
 	savep = p;


