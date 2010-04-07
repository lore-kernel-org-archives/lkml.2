Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab0DGMtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:49:17 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:14514
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757896Ab0DGMsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:48:11 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i87h6bh2a8h63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJL-02-96I-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       Vivek Goyal <vgoyal@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/12] x86/amd-iommu: enable iommu before attaching devices
Date: Wed, 7 Apr 2010 14:46:43 +0200
Message-ID: <1270644409-10123-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Apr 2010 12:46:56.0039 (UTC) FILETIME=[67C85370:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

Hit another kdump problem as reported by Neil Horman.  When initializaing
the IOMMU, we attach devices to their domains before the IOMMU is
fully (re)initialized.  Attaching a device will issue some important
invalidations.  In the context of the newly kexec'd kdump kernel, the
IOMMU may have stale cached data from the original kernel.  Because we
do the attach too early, the invalidation commands are placed in the new
command buffer before the IOMMU is updated w/ that buffer.  This leaves
the stale entries in the kdump context and can renders device unusable.
Simply enable the IOMMU before we do the attach.

Cc: stable@kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index feaf471..8975965 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1304,6 +1304,8 @@ static int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
+	enable_iommus();
+
 	if (iommu_pass_through)
 		ret = amd_iommu_init_passthrough();
 	else
@@ -1316,8 +1318,6 @@ static int __init amd_iommu_init(void)
 
 	amd_iommu_init_notifier();
 
-	enable_iommus();
-
 	if (iommu_pass_through)
 		goto out;
 
@@ -1331,6 +1331,7 @@ out:
 	return ret;
 
 free:
+	disable_iommus();
 
 	amd_iommu_uninit_devices();
 
-- 
1.7.0.4


