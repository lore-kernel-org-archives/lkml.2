Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab0DGMsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:48:24 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:23504 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886Ab0DGMsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:48:10 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJT-01-9UT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
       stable@kernel.org
Subject: [PATCH 05/12] x86/amd-iommu: Use helper function to destroy domain
Date: Wed, 7 Apr 2010 14:46:42 +0200
Message-ID: <1270644409-10123-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Apr 2010 12:46:56.0039 (UTC) FILETIME=[67C85370:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the amd_iommu_domain_destroy the protection_domain_free
function is partly reimplemented. The 'partly' is the bug
here because the domain is not deleted from the domain list.
This results in use-after-free errors and data-corruption.
Fix it by just using protection_domain_free instead.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0c04254..b06f29e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2380,9 +2380,7 @@ static void amd_iommu_domain_destroy(struct iommu_domain *dom)
 
 	free_pagetable(domain);
 
-	domain_id_free(domain->id);
-
-	kfree(domain);
+	protection_domain_free(domain);
 
 	dom->priv = NULL;
 }
-- 
1.7.0.4


