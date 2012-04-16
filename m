Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2DPRUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:20:54 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30301 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2DPRUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:20:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/8] xen/p2m: An early bootup variant of set_phys_to_machine
Date: Mon, 16 Apr 2012 13:15:35 -0400
Message-Id: <1334596539-18172-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F8C54EC.0009,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During early bootup we can't use alloc_page, so to allocate
leaf pages in the P2M we need to use extend_brk. For that
we are utilizing the early_alloc_p2m and early_alloc_p2m_middle
functions to do the job for us. This function follows the
same logic as set_phys_to_machine.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    1 +
 arch/x86/xen/p2m.c              |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index c34f96c..93971e8 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -44,6 +44,7 @@ extern unsigned long  machine_to_phys_nr;
 
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
+extern bool __init early_set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 extern bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 extern unsigned long set_phys_range_identity(unsigned long pfn_s,
 					     unsigned long pfn_e);
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 952edef..ffd08c4 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -570,6 +570,21 @@ static bool __init early_alloc_p2m(unsigned long pfn)
 	}
 	return true;
 }
+bool __init early_set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
+		if (!early_alloc_p2m(pfn))
+			return false;
+
+		if (!early_alloc_p2m_middle(pfn, false /* boundary crossover OK!*/))
+			return false;
+
+		if (!__set_phys_to_machine(pfn, mfn))
+			return false;
+	}
+
+	return true;
+}
 unsigned long __init set_phys_range_identity(unsigned long pfn_s,
 				      unsigned long pfn_e)
 {
-- 
1.7.7.5

