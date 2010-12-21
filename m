Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0LUViJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:38:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25114 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab0LUViG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Dec 2010 16:38:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 01/10] xen: Make all reserved pages for the balloon be INVALID_P2M_ENTRY.
Date: Tue, 21 Dec 2010 16:37:31 -0500
Message-Id: <1292967460-15709-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares ourselves for the case where void entries in the P2M
tree structure do not necessarily imply that the pages are missing.
With this, we diligently set regions that will be used by the
balloon driver to be INVALID_P2M_ENTRY and under the ownership
of the balloon driver.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c  |    8 ++++++++
 drivers/xen/balloon.c |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index b5a7f92..d984d36 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -52,6 +52,8 @@ phys_addr_t xen_extra_mem_start, xen_extra_mem_size;
 
 static __init void xen_add_extra_mem(unsigned long pages)
 {
+	unsigned long pfn;
+
 	u64 size = (u64)pages * PAGE_SIZE;
 	u64 extra_start = xen_extra_mem_start + xen_extra_mem_size;
 
@@ -66,6 +68,11 @@ static __init void xen_add_extra_mem(unsigned long pages)
 	xen_extra_mem_size += size;
 
 	xen_max_p2m_pfn = PFN_DOWN(extra_start + size);
+
+	for (pfn = PFN_DOWN(extra_start); pfn <= xen_max_p2m_pfn; pfn++) {
+		BUG_ON(!set_phys_to_machine(pfn, INVALID_P2M_ENTRY));
+		BUG_ON(get_phys_to_machine(pfn) != INVALID_P2M_ENTRY);
+	}
 }
 
 static unsigned long __init xen_release_chunk(phys_addr_t start_addr,
@@ -105,6 +112,7 @@ static unsigned long __init xen_release_chunk(phys_addr_t start_addr,
 		     start, end, ret);
 		if (ret == 1) {
 			set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+			BUG_ON(get_phys_to_machine(pfn) != INVALID_P2M_ENTRY);
 			len++;
 		}
 	}
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 43f9f02..f82bb48 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -297,6 +297,7 @@ static int decrease_reservation(unsigned long nr_pages)
 	for (i = 0; i < nr_pages; i++) {
 		pfn = mfn_to_pfn(frame_list[i]);
 		set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+		BUG_ON(get_phys_to_machine(pfn) != INVALID_P2M_ENTRY);
 		balloon_append(pfn_to_page(pfn));
 	}
 
-- 
1.7.1

