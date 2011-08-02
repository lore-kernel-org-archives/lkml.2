Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab1HBJpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:45:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab1HBJpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:45:40 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] xen: Fix misleading WARN message at xen_release_chunk
Date: Tue,  2 Aug 2011 11:45:25 +0200
Message-Id: <1312278325-4246-4-git-send-email-imammedo@redhat.com>
In-Reply-To: <1312278325-4246-1-git-send-email-imammedo@redhat.com>
References: <1312278325-4246-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARN message should not complain
 "Failed to release memory %lx-%lx err=%d\n"
                           ^^^^^^^
about range when it fails to release just one page,
instead it should say what pfn is not freed.

In addition line:
 printk(KERN_INFO "xen_release_chunk: looking at area pfn %lx-%lx: "
 ...
 printk(KERN_CONT "%lu pages freed\n", len);
will be broken if WARN in between this line is fired. So fix it
by using a single printk for this.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/xen/setup.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index d9eef1e..1ec79b7 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -92,8 +92,6 @@ static unsigned long __init xen_release_chunk(phys_addr_t start_addr,
 	if (end <= start)
 		return 0;
 
-	printk(KERN_INFO "xen_release_chunk: looking at area pfn %lx-%lx: ",
-	       start, end);
 	for(pfn = start; pfn < end; pfn++) {
 		unsigned long mfn = pfn_to_mfn(pfn);
 
@@ -106,14 +104,14 @@ static unsigned long __init xen_release_chunk(phys_addr_t start_addr,
 
 		ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
 					   &reservation);
-		WARN(ret != 1, "Failed to release memory %lx-%lx err=%d\n",
-		     start, end, ret);
+		WARN(ret != 1, "Failed to release pfn %lx err=%d\n", pfn, ret);
 		if (ret == 1) {
 			__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
 			len++;
 		}
 	}
-	printk(KERN_CONT "%lu pages freed\n", len);
+	printk(KERN_INFO "Freeing  %lx-%lx pfn range: %lu pages freed\n",
+	       start, end, len);
 
 	return len;
 }
-- 
1.7.5

