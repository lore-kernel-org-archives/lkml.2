Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab0DBLea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 07:34:30 -0400
Received: from mail-bw0-f217.google.com ([209.85.218.217]:59760 "EHLO
	mail-bw0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab0DBLeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 07:34:23 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Apr 2010 07:34:22 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=aJVPK0KymPZN7Y5/aO/UpA5XPfY2DfE7bxO0GMfVf7IW50QmzAnn5ZiNZz70KjmQxo
         u+jAo/IyTW5q9e30f3H9VgqJesVG418NVG2SDmn5Foe+0g9R9UvFdRCHsxAazb03FbXR
         YsNYWdiOO4hwFZNUD5sfE28doAJH2Hb98TJUA=
Date: Fri, 2 Apr 2010 14:27:36 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Or Gerlitz <ogerlitz@voltaire.com>
Subject: [patch v3] infiniband: ulp/iser, fix error retval in
	iser_create_ib_conn_res
Message-ID: <20100402112736.GH5265@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Roland Dreier <rdreier@cisco.com>, Jiri Slaby <jslaby@suse.cz>,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Or Gerlitz <ogerlitz@voltaire.com>
References: <1268750962-13547-1-git-send-email-jslaby@suse.cz> <ada634v9644.fsf@roland-alpha.cisco.com> <20100317151122.GF5331@bicker> <adak4ssi4ky.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adak4ssi4ky.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't free things here because we free them later.  The call 
tree looks like this:
iser_connect() => iser_cma_handler() => iser_route_handler()
        => iser_create_ib_conn_res()

                We fail here and return failures back down the tree.

iser_connect() => iser_conn_release()

                Double free.                                                                                                 

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
V1 fixed unreachable code
V2 noticed that the original code had a double free
V3 Roland Dreier points out that I left a dangling ERR_PTR() in
   "ib_conn->fmr_pool" which would be freed later on.

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 308d17b..ccab795 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -148,10 +148,8 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 	device = ib_conn->device;
 
 	ib_conn->login_buf = kmalloc(ISER_RX_LOGIN_SIZE, GFP_KERNEL);
-	if (!ib_conn->login_buf) {
-		goto alloc_err;
-		ret = -ENOMEM;
-	}
+	if (!ib_conn->login_buf)
+		goto out_err;
 
 	ib_conn->login_dma = ib_dma_map_single(ib_conn->device->ib_device,
 				(void *)ib_conn->login_buf, ISER_RX_LOGIN_SIZE,
@@ -160,10 +158,9 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 	ib_conn->page_vec = kmalloc(sizeof(struct iser_page_vec) +
 				    (sizeof(u64) * (ISCSI_ISER_SG_TABLESIZE +1)),
 				    GFP_KERNEL);
-	if (!ib_conn->page_vec) {
-		ret = -ENOMEM;
-		goto alloc_err;
-	}
+	if (!ib_conn->page_vec)
+		goto out_err;
+
 	ib_conn->page_vec->pages = (u64 *) (ib_conn->page_vec + 1);
 
 	params.page_shift        = SHIFT_4K;
@@ -183,7 +180,8 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 	ib_conn->fmr_pool = ib_create_fmr_pool(device->pd, &params);
 	if (IS_ERR(ib_conn->fmr_pool)) {
 		ret = PTR_ERR(ib_conn->fmr_pool);
-		goto fmr_pool_err;
+		ib_conn->fmr_pool = NULL;
+		goto out_err;
 	}
 
 	memset(&init_attr, 0, sizeof init_attr);
@@ -201,7 +199,7 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 
 	ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
 	if (ret)
-		goto qp_err;
+		goto out_err;
 
 	ib_conn->qp = ib_conn->cma_id->qp;
 	iser_err("setting conn %p cma_id %p: fmr_pool %p qp %p\n",
@@ -209,12 +207,7 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 		 ib_conn->fmr_pool, ib_conn->cma_id->qp);
 	return ret;
 
-qp_err:
-	(void)ib_destroy_fmr_pool(ib_conn->fmr_pool);
-fmr_pool_err:
-	kfree(ib_conn->page_vec);
-	kfree(ib_conn->login_buf);
-alloc_err:
+out_err:
 	iser_err("unable to alloc mem or create resource, err %d\n", ret);
 	return ret;
 }
