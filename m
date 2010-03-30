Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab0C3XTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:19:00 -0400
Received: from kroah.org ([198.145.64.141]:45326 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271Ab0C3XSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:37 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:50 2010
Message-Id: <20100330225649.970174115@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [079/116] SUNRPC: Fix a potential memory leak in auth_gss
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit cdead7cf12896c0e50a8be2e52de52c364603095 upstream.

The function alloc_enc_pages() currently fails to release the pointer
rqstp->rq_enc_pages in the error path.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/auth_gss/auth_gss.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1273,9 +1273,8 @@ alloc_enc_pages(struct rpc_rqst *rqstp)
 	rqstp->rq_release_snd_buf = priv_release_snd_buf;
 	return 0;
 out_free:
-	for (i--; i >= 0; i--) {
-		__free_page(rqstp->rq_enc_pages[i]);
-	}
+	rqstp->rq_enc_pages_num = i;
+	priv_release_snd_buf(rqstp);
 out:
 	return -EAGAIN;
 }


