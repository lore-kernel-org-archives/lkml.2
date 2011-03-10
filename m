Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab1CJITY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:19:24 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63346 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1CJITW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:19:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lXtz+qv4vGpz1hrBbAT97wU5BLhuLFiiNeXiI/0J3uB+EANu5/bJHRIeeHfGFl+5dv
         YvcRjOFaKESxxn+kL1AIGo9+EnI4OxDsPvYteGORsabxj1lSKDRZq7q0s2kg8DJtsAy6
         qxBBaG7w+gwmw7RFhYohuAmNyAEKIL6zqAuzU=
Subject: [PATCH] drivers/misc: atmel_tclib: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 Mar 2011 16:19:16 +0800
Message-Id: <1299745156.18619.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_mem_region() will call kzalloc to allocate memory for struct resource.
release_resource() unregisters the resource but does not free the allocated
memory, thus use release_mem_region() instead to fix the memory leak.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/misc/atmel_tclib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/atmel_tclib.c b/drivers/misc/atmel_tclib.c
index 3891124..a844810 100644
--- a/drivers/misc/atmel_tclib.c
+++ b/drivers/misc/atmel_tclib.c
@@ -75,7 +75,7 @@ out:
 	return tc;
 
 fail_ioremap:
-	release_resource(r);
+	release_mem_region(r->start, ATMEL_TC_IOMEM_SIZE);
 fail:
 	tc = NULL;
 	goto out;
@@ -95,7 +95,7 @@ void atmel_tc_free(struct atmel_tc *tc)
 	spin_lock(&tc_list_lock);
 	if (tc->regs) {
 		iounmap(tc->regs);
-		release_resource(tc->iomem);
+		release_mem_region(tc->iomem->start, ATMEL_TC_IOMEM_SIZE);
 		tc->regs = NULL;
 		tc->iomem = NULL;
 	}
-- 
1.7.2



