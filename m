Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab2HIVXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 17:23:32 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:6938 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109Ab2HIVXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:23:30 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M8IBEY-02-FML-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 5/5] x86: Move enabling of PSE and PGE out of init_memory_mapping
Date: Thu, 9 Aug 2012 16:23:09 -0500
Message-ID: <1344547389-4599-6-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now call init_memory_mapping for each E820_RAM region in a
loop, move cr4 writes out to setup_arch.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/setup.c |   10 ++++++++++
 arch/x86/mm/init.c      |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4f26944..5dfeb8f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -958,6 +958,16 @@ void __init setup_arch(char **cmdline_p)
 
 	init_gbpages();
 
+	/* Enable PSE if available */
+	if (cpu_has_pse)
+		set_in_cr4(X86_CR4_PSE);
+
+	/* Enable PGE if available */
+	if (cpu_has_pge) {
+		set_in_cr4(X86_CR4_PGE);
+		__supported_pte_mask |= _PAGE_GLOBAL;
+	}
+
 	init_pfn = max_pfn_mapped;
 
 	memset(pfn_mapped, 0, sizeof(pfn_mapped));
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d4e01a7..99f111e 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -152,16 +152,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
-	/* Enable PSE if available */
-	if (cpu_has_pse)
-		set_in_cr4(X86_CR4_PSE);
-
-	/* Enable PGE if available */
-	if (cpu_has_pge) {
-		set_in_cr4(X86_CR4_PGE);
-		__supported_pte_mask |= _PAGE_GLOBAL;
-	}
-
 	if (use_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
 	if (use_pse)
-- 
1.7.9.5


