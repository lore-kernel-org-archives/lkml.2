Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978Ab2KVS6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:58:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964933Ab2KVS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:42 -0500
Date: Wed, 21 Nov 2012 17:50:56 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-5101730cb0613b91d40b9bb7be6bb023d2f6aa24@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-14-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-14-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: use pfn_range_is_mapped() with gart
Git-Commit-ID: 5101730cb0613b91d40b9bb7be6bb023d2f6aa24
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 17:51:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5101730cb0613b91d40b9bb7be6bb023d2f6aa24
Gitweb:     http://git.kernel.org/tip/5101730cb0613b91d40b9bb7be6bb023d2f6aa24
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:38:50 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:10 -0800

x86, mm: use pfn_range_is_mapped() with gart

We are going to map ram only, so under max_low_pfn_mapped,
between 4g and max_pfn_mapped does not mean mapped at all.

Use pfn_range_is_mapped() directly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-14-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/amd_gart_64.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index e663112..b574b29 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -768,10 +768,9 @@ int __init gart_iommu_init(void)
 	aper_base	= info.aper_base;
 	end_pfn		= (aper_base>>PAGE_SHIFT) + (aper_size>>PAGE_SHIFT);
 
-	if (end_pfn > max_low_pfn_mapped) {
-		start_pfn = (aper_base>>PAGE_SHIFT);
+	start_pfn = PFN_DOWN(aper_base);
+	if (!pfn_range_is_mapped(start_pfn, end_pfn))
 		init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
-	}
 
 	pr_info("PCI-DMA: using GART IOMMU.\n");
 	iommu_size = check_iommu_size(info.aper_base, aper_size);
