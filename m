Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2HNWjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:39:32 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:25823
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785Ab2HNWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:39:27 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M8RO9K-02-1VW-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 1/4] x86: Move enabling of PSE and PGE out of init_memory_mapping
Date: Tue, 14 Aug 2012 17:39:14 -0500
Message-ID: <1344983957-4996-2-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344983957-4996-1-git-send-email-jacob.shin@amd.com>
References: <1344983957-4996-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on the platform, init_memory_mapping() may be called multiple
times. Move it out to setup_arch() to avoid writing to cr4 on every call.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/setup.c |   10 ++++++++++
 arch/x86/mm/init.c      |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..751e020 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -913,6 +913,16 @@ void __init setup_arch(char **cmdline_p)
 
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
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e0e6990..2f07e09 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -149,16 +149,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
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


