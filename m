Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab0GEQTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 12:19:31 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:47329 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab0GEQT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 12:19:29 -0400
Date: Mon, 5 Jul 2010 18:19:25 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, Linux RDMA <linux-rdma@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
Subject: [PATCH] ib/ehca: Catch failing ioremap()
Message-ID: <20100705181925.2e34d798@alex-laptop>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ioremap() fails with a NULL pointer, catch the error and pass it to the
caller of create_qp() or create_cq() instead of trying to dereference the NULL
pointer later on.

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---

Hi Roland, another patch for 2.6.36...

 drivers/infiniband/hw/ehca/hcp_if.c   |   32 ++++++++++++++++++++++++++++----
 drivers/infiniband/hw/ehca/hcp_phyp.c |   11 +++++------
 drivers/infiniband/hw/ehca/hcp_phyp.h |    2 +-
 3 files changed, 34 insertions(+), 11 deletions(-)

--- linux-2.6.orig/drivers/infiniband/hw/ehca/hcp_if.c
+++ linux-2.6/drivers/infiniband/hw/ehca/hcp_if.c
@@ -269,6 +269,7 @@ u64 hipz_h_alloc_resource_cq(const struc
 			     struct ehca_cq *cq,
 			     struct ehca_alloc_cq_parms *param)
 {
+	int rc;
 	u64 ret;
 	unsigned long outs[PLPAR_HCALL9_BUFSIZE];
 
@@ -283,8 +284,19 @@ u64 hipz_h_alloc_resource_cq(const struc
 	param->act_nr_of_entries = (u32)outs[3];
 	param->act_pages = (u32)outs[4];
 
-	if (ret == H_SUCCESS)
-		hcp_galpas_ctor(&cq->galpas, 0, outs[5], outs[6]);
+	if (ret == H_SUCCESS) {
+		rc = hcp_galpas_ctor(&cq->galpas, 0, outs[5], outs[6]);
+		if (rc) {
+			ehca_gen_err("Could not establish HW access. rc=%d paddr=%#lx",
+				     rc, outs[5]);
+
+			ehca_plpar_hcall_norets(H_FREE_RESOURCE,
+						adapter_handle.handle,     /* r4 */
+						cq->ipz_cq_handle.handle,  /* r5 */
+						0, 0, 0, 0, 0);
+			ret = H_NO_MEM;
+		}
+	}
 
 	if (ret == H_NOT_ENOUGH_RESOURCES)
 		ehca_gen_err("Not enough resources. ret=%lli", ret);
@@ -295,6 +307,7 @@ u64 hipz_h_alloc_resource_cq(const struc
 u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 			     struct ehca_alloc_qp_parms *parms, int is_user)
 {
+	int rc;
 	u64 ret;
 	u64 allocate_controls, max_r10_reg, r11, r12;
 	unsigned long outs[PLPAR_HCALL9_BUFSIZE];
@@ -358,8 +371,19 @@ u64 hipz_h_alloc_resource_qp(const struc
 	parms->rqueue.queue_size =
 		(u32)EHCA_BMASK_GET(H_ALL_RES_QP_RQUEUE_SIZE_PAGES, outs[4]);
 
-	if (ret == H_SUCCESS)
-		hcp_galpas_ctor(&parms->galpas, is_user, outs[6], outs[6]);
+	if (ret == H_SUCCESS) {
+		rc = hcp_galpas_ctor(&parms->galpas, is_user, outs[6], outs[6]);
+		if (rc) {
+			ehca_gen_err("Could not establish HW access. rc=%d paddr=%#lx",
+				     rc, outs[6]);
+
+			ehca_plpar_hcall_norets(H_FREE_RESOURCE,
+						adapter_handle.handle,     /* r4 */
+						parms->qp_handle.handle,  /* r5 */
+						0, 0, 0, 0, 0);
+			ret = H_NO_MEM;
+		}
+	}
 
 	if (ret == H_NOT_ENOUGH_RESOURCES)
 		ehca_gen_err("Not enough resources. ret=%lli", ret);
--- linux-2.6.orig/drivers/infiniband/hw/ehca/hcp_phyp.c
+++ linux-2.6/drivers/infiniband/hw/ehca/hcp_phyp.c
@@ -42,10 +42,9 @@
 #include "ehca_classes.h"
 #include "hipz_hw.h"
 
-int hcall_map_page(u64 physaddr, u64 *mapaddr)
+u64 hcall_map_page(u64 physaddr)
 {
-	*mapaddr = (u64)(ioremap(physaddr, EHCA_PAGESIZE));
-	return 0;
+	return (u64)ioremap(physaddr, EHCA_PAGESIZE);
 }
 
 int hcall_unmap_page(u64 mapaddr)
@@ -58,9 +57,9 @@ int hcp_galpas_ctor(struct h_galpas *gal
 		    u64 paddr_kernel, u64 paddr_user)
 {
 	if (!is_user) {
-		int ret = hcall_map_page(paddr_kernel, &galpas->kernel.fw_handle);
-		if (ret)
-			return ret;
+		galpas->kernel.fw_handle = hcall_map_page(paddr_kernel);
+		if (!galpas->kernel.fw_handle)
+			return -ENOMEM;
 	} else
 		galpas->kernel.fw_handle = 0;
 
--- linux-2.6.orig/drivers/infiniband/hw/ehca/hcp_phyp.h
+++ linux-2.6/drivers/infiniband/hw/ehca/hcp_phyp.h
@@ -83,7 +83,7 @@ int hcp_galpas_ctor(struct h_galpas *gal
 
 int hcp_galpas_dtor(struct h_galpas *galpas);
 
-int hcall_map_page(u64 physaddr, u64 * mapaddr);
+u64 hcall_map_page(u64 physaddr);
 
 int hcall_unmap_page(u64 mapaddr);
 
