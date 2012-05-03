Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2ECIly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:41:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:60771 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab2ECIlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:41:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95870270"
From: Octavian Purdila <octavian.purdila@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linuxram@us.ibm.com, bjorn.helgaas@hp.com,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH] resource: make sure requested range intersects root range
Date: Thu,  3 May 2012 11:40:57 +0300
Message-Id: <1336034457-26708-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the requested and root ranges do not intersect,
__reserve_region_with_split will eventually overflow the stack.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 kernel/resource.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 7e8ea66..1f8d698 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -789,7 +789,11 @@ void __init reserve_region_with_split(struct resource *root,
 		const char *name)
 {
 	write_lock(&resource_lock);
-	__reserve_region_with_split(root, start, end, name);
+	if (start > root->end || end < root->start)
+		printk(KERN_ERR "Requested range (0x%llx-0x%llx) not in root range (0x%llx-0x%llx)\n",
+		       start, end, root->start, root->end);
+	else
+		__reserve_region_with_split(root, start, end, name);
 	write_unlock(&resource_lock);
 }
 
-- 
1.7.5.4

