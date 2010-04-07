Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab0DGMtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:49:24 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:14514
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757884Ab0DGMsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:48:09 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJL-02-96K-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/12] x86/amd-iommu: Pt mode fix for domain_destroy
Date: Wed, 7 Apr 2010 14:46:40 +0200
Message-ID: <1270644409-10123-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Apr 2010 12:46:55.0804 (UTC) FILETIME=[67A477C0:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

After a guest is shutdown, assigned devices are not properly
returned to the pt domain.  This can leave the device using
stale cached IOMMU data, and result in a non-functional
device after it's re-bound to the host driver.  For example,
I see this upon rebinding:

 AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x0000 address=0x000000007e2a8000 flags=0x0050]
 AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x0000 address=0x000000007e2a8040 flags=0x0050]
 AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x0000 address=0x000000007e2a8080 flags=0x0050]
 AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x0000 address=0x000000007e2a80c0 flags=0x0050]
 0000:02:00.0: eth2: Detected Hardware Unit Hang:
 ...

The amd_iommu_destroy_domain() function calls do_detach()
which doesn't reattach the pt domain to the device.
Use __detach_device() instead.

Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b97f2f1..0c04254 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2298,7 +2298,7 @@ static void cleanup_domain(struct protection_domain *domain)
 	list_for_each_entry_safe(dev_data, next, &domain->dev_list, list) {
 		struct device *dev = dev_data->dev;
 
-		do_detach(dev);
+		__detach_device(dev);
 		atomic_set(&dev_data->bind, 0);
 	}
 
-- 
1.7.0.4


