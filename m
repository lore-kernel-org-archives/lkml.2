Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0G0RVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:21:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36687 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab0G0RUo (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 27 Jul 2010 13:20:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, alex.williamson@redhat.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/9] vmap: add flag to allow lazy unmap to be disabled at runtime
Date: Tue, 27 Jul 2010 12:59:58 -0400
Message-Id: <1280250002-20279-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280250002-20279-1-git-send-email-konrad.wilk@oracle.com>
References: <1280250002-20279-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C4F1538.0334:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Add a flag to force lazy_max_pages() to zero to prevent any outstanding
mapped pages.  We'll need this for Xen.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Nick Piggin <npiggin@suse.de>
---
 include/linux/vmalloc.h |    2 ++
 mm/vmalloc.c            |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 227c2a5..b840fda 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -7,6 +7,8 @@
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 
+extern bool vmap_lazy_unmap;
+
 /* bits in flags of vmalloc's vm_struct below */
 #define VM_IOREMAP	0x00000001	/* ioremap() and friends */
 #define VM_ALLOC	0x00000002	/* vmalloc() */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ae00746..7f35fe2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -31,6 +31,7 @@
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
+bool vmap_lazy_unmap __read_mostly = true;
 
 /*** Page table manipulation functions ***/
 
@@ -502,6 +503,9 @@ static unsigned long lazy_max_pages(void)
 {
 	unsigned int log;
 
+	if (!vmap_lazy_unmap)
+		return 0;
+
 	log = fls(num_online_cpus());
 
 	return log * (32UL * 1024 * 1024 / PAGE_SIZE);
-- 
1.7.0.1

