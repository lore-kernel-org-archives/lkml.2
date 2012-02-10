Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab2BJXFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:05:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab2BJWnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:37 -0500
MIME-Version: 1.0
Message-Id: <20120210222950.729037851@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Brown <davidb@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 64/86] iommu/msm: Fix error handling in msm_iommu_unmap()
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 05df1f3c2afaef5672627f2b7095f0d4c4dbc3a0 upstream.

Error handling in msm_iommu_unmap() is broken. On some error
conditions retval is set to a non-zero value which causes
the function to return 'len' at the end. This hides the
error from the user. Zero should be returned in those error
cases.

Cc: David Brown <davidb@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: David Brown <davidb@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/msm_iommu.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -481,23 +481,19 @@ static int msm_iommu_unmap(struct iommu_
 
 	priv = domain->priv;
 
-	if (!priv) {
-		ret = -ENODEV;
+	if (!priv)
 		goto fail;
-	}
 
 	fl_table = priv->pgtable;
 
 	if (len != SZ_16M && len != SZ_1M &&
 	    len != SZ_64K && len != SZ_4K) {
 		pr_debug("Bad length: %d\n", len);
-		ret = -EINVAL;
 		goto fail;
 	}
 
 	if (!fl_table) {
 		pr_debug("Null page table\n");
-		ret = -EINVAL;
 		goto fail;
 	}
 
@@ -506,7 +502,6 @@ static int msm_iommu_unmap(struct iommu_
 
 	if (*fl_pte == 0) {
 		pr_debug("First level PTE is 0\n");
-		ret = -ENODEV;
 		goto fail;
 	}
 


