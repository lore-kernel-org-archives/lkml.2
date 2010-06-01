Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab0FAJEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:04:36 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:14741
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754764Ab0FAJEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:04:02 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i2a8h87h43h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L3BVUE-01-T62-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, <stable@kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] arch/x86/kernel: Add missing spin_unlock
Date: Tue, 1 Jun 2010 11:03:39 +0200
Message-ID: <1275383021-20172-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275383021-20172-1-git-send-email-joerg.roedel@amd.com>
References: <1275383021-20172-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a spin_unlock missing on the error path.  The locks and unlocks are
balanced in other functions, so it seems that the same should be the case
here.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock(E1,...);
// </smpl>

Cc: stable@kernel.org
Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index fa5a147..8a9aaa8 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1487,6 +1487,7 @@ static int __attach_device(struct device *dev,
 			   struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data, *alias_data;
+	int ret;
 
 	dev_data   = get_dev_data(dev);
 	alias_data = get_dev_data(dev_data->alias);
@@ -1498,13 +1499,14 @@ static int __attach_device(struct device *dev,
 	spin_lock(&domain->lock);
 
 	/* Some sanity checks */
+	ret = -EBUSY;
 	if (alias_data->domain != NULL &&
 	    alias_data->domain != domain)
-		return -EBUSY;
+		goto out_unlock;
 
 	if (dev_data->domain != NULL &&
 	    dev_data->domain != domain)
-		return -EBUSY;
+		goto out_unlock;
 
 	/* Do real assignment */
 	if (dev_data->alias != dev) {
@@ -1520,10 +1522,14 @@ static int __attach_device(struct device *dev,
 
 	atomic_inc(&dev_data->bind);
 
+	ret = 0;
+
+out_unlock:
+
 	/* ready */
 	spin_unlock(&domain->lock);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.7.1


