Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0EFNWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 09:22:32 -0400
Received: from fwil.voltaire.com ([193.47.165.2]:42259 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751208Ab0EFNWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 09:22:30 -0400
Message-ID: <4BE2C28D.1090108@Voltaire.com>
Date: Thu, 06 May 2010 16:22:21 +0300
From: Or Gerlitz <ogerlitz@Voltaire.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Dan Carpenter <error27@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       linux-rdma <linux-rdma@vger.kernel.org>
Subject: Re: [patch v3] infiniband: ulp/iser, fix error retval in iser_create_ib_conn_res
References: <1268750962-13547-1-git-send-email-jslaby@suse.cz>	<ada634v9644.fsf@roland-alpha.cisco.com> <20100317151122.GF5331@bicker>	<adak4ssi4ky.fsf@roland-alpha.cisco.com> <20100402112736.GH5265@bicker> <ada4oimmd9p.fsf@roland-alpha.cisco.com>
In-Reply-To: <ada4oimmd9p.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 May 2010 13:22:25.0739 (UTC) FILETIME=[2B2981B0:01CAED1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Or, I don't think we ever fixed this.  This patch looks correct to me,
> any problem with merging this for 2.6.35?

Roland, please use V4 below, the patch is okay and would apply before and after 
applying the multipathing patches I sent yesterday (same goes for them).

[PATCH V4] ib/iser: fix error flow in iser_create_ib_conn_res

From: Dan Carpenter <error27@gmail.com>

We shouldn't free things here because we free them later. 
The call tree looks like this: 
	iser_connect() ==> initiating the connection establishment
and later 
	iser_cma_handler() => iser_route_handler() => iser_create_ib_conn_res()
if we fail here, eventually iser_conn_release() is called, resulted in double free.
                                                                                                 
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Or Gerlitz <ogerlitz@voltaire.com>
---
V1 fixed unreachable code
V2 noticed that the original code had a double free
V3 Roland Dreier points out that I left a dangling ERR_PTR() in
   "ib_conn->fmr_pool" which would be freed later on.
V4 reviewed/enhanced the change-log
---
 drivers/infiniband/ulp/iser/iser_verbs.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

Index: linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iser_verbs.c
===================================================================
--- linux-2.6.34-rc6.orig/drivers/infiniband/ulp/iser/iser_verbs.c
+++ linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -163,10 +163,8 @@ static int iser_create_ib_conn_res(struc
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
@@ -175,10 +173,9 @@ static int iser_create_ib_conn_res(struc
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
@@ -198,7 +195,8 @@ static int iser_create_ib_conn_res(struc
 	ib_conn->fmr_pool = ib_create_fmr_pool(device->pd, &params);
 	if (IS_ERR(ib_conn->fmr_pool)) {
 		ret = PTR_ERR(ib_conn->fmr_pool);
-		goto fmr_pool_err;
+		ib_conn->fmr_pool = NULL;
+		goto out_err;
 	}
 
 	memset(&init_attr, 0, sizeof init_attr);
@@ -216,7 +214,7 @@ static int iser_create_ib_conn_res(struc
 
 	ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
 	if (ret)
-		goto qp_err;
+		goto out_err;
 
 	ib_conn->qp = ib_conn->cma_id->qp;
 	iser_err("setting conn %p cma_id %p: fmr_pool %p qp %p\n",
@@ -224,12 +222,7 @@ static int iser_create_ib_conn_res(struc
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
