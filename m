Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1LTGoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 01:44:24 -0500
Received: from 206-223-182-18.beanfield.net ([206.223.182.18]:38088 "EHLO
	dev.gridcentric.ca" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1LTGoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 01:44:16 -0500
From: Adin Scannell <adin@scannell.ca>
To: xen-devel@lists.xensource.com
Cc: konrad@darnok.org, andres@gridcentric.ca, adin@gridcentric.com,
        olaf@aepfle.de, JBeulich@suse.com, linux-kernel@vger.kernel.org,
        Adin Scannell <adin@scannell.ca>
Subject: [PATCH 2/3] Small fix-ups for the xen/privcmd ioctls
Date: Tue, 20 Dec 2011 01:36:52 -0500
Message-Id: <1324363013-11031-3-git-send-email-adin@scannell.ca>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1324363013-11031-1-git-send-email-adin@scannell.ca>
References: <1324363013-11031-1-git-send-email-adin@scannell.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In implementing the mmap_batch_v2 ioctl, some of the feedback included small
fixups that were also relevant to the existing mmap_batch ioctl. Prior to the
mmap_batch_v2 patch, this adds those small fixups to the existing code.

The const addition for gather_array is necessary for the implementation of
mmap_batch_v2 and does not affect correctness.

Signed-off-by: Adin Scannell <adin@scannell.ca>
---
 drivers/xen/privcmd.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index ccee0f1..161681f 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -76,7 +76,7 @@ static void free_page_list(struct list_head *pages)
  */
 static int gather_array(struct list_head *pagelist,
 			unsigned nelem, size_t size,
-			void __user *data)
+			const void __user *data)
 {
 	unsigned pageidx;
 	void *pagedata;
@@ -246,7 +246,7 @@ struct mmap_batch_state {
 	domid_t domain;
 	unsigned long va;
 	struct vm_area_struct *vma;
-	int err;
+	unsigned long err;
 
 	xen_pfn_t __user *user;
 };
@@ -256,6 +256,8 @@ static int mmap_batch_fn(void *data, void *state)
 	xen_pfn_t *mfnp = data;
 	struct mmap_batch_state *st = state;
 
+	BUG_ON(st == NULL || st->vma == NULL);
+
 	if (xen_remap_domain_mfn_range(st->vma, st->va & PAGE_MASK, *mfnp, 1,
 				       st->vma->vm_page_prot, st->domain) < 0) {
 		*mfnp |= 0xf0000000U;
-- 
1.6.2.5

