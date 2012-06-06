Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab2FFQuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:50:10 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:3897 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2FFQuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:50:08 -0400
Message-ID: <1339001406.2763.49.camel@lorien2>
Subject: [PATCH RFC] iommu/amd: Fix missing iommu_shutdown initialization in
 passthrough mode
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: joerg.roedel@amd.com
Cc: iommu@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah.khan@hp.com>
Date: Wed, 06 Jun 2012 10:50:06 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change AMD iommu driver to call disable iommus in pass-through mode. AMD
iommu driver's amd_iommu_init() routine doesn't initialize iommu_shutdown
in pass-through mode. As a result iommu disable via a call to disable_iommus()
doesn't happen at shutdown. Enable and disable of iommus is inconsistent in
pass-through mode. IOMMU is enabled, but not disabled. IOMMU disable is called
from error legs in amd_iommu_init() in pass-through mode.

Requesting for comments as I don't have access to AMD system that supports
IOMMU. I tested the change on AMD platforms with GART IOMMU which is not
sufficient.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 drivers/iommu/amd_iommu_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index c567903..1d8ab7f 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1644,6 +1644,8 @@ static int __init amd_iommu_init(void)
 
 	amd_iommu_init_api();
 
+	x86_platform.iommu_shutdown = disable_iommus;
+
 	if (iommu_pass_through)
 		goto out;
 
@@ -1652,8 +1654,6 @@ static int __init amd_iommu_init(void)
 	else
 		printk(KERN_INFO "AMD-Vi: Lazy IO/TLB flushing enabled\n");
 
-	x86_platform.iommu_shutdown = disable_iommus;
-
 out:
 	return ret;
 
-- 
1.7.9.5



