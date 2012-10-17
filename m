Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab2JQOEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:04:42 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44659 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab2JQODs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:03:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, hpa@zytor.com,
        x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/4] xen/lowlevel: Implement pvop call for store_gdt (gidt)
Date: Wed, 17 Oct 2012 09:49:45 -0400
Message-Id: <1350481786-4969-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the past it used to point to 'sgdt' (native_store_gdt)
operation which is a non-privileged operation. This resulted
in the value of 'struct desc_ptr' pointing to an bogus address
0xffff820000000000, instead of the GDT table that Linux thinks
it is using. The end result is that doing:

      store_gdt(&desc);
      load_gdt(&desc);

would blow up b/c xen_load_gdt would try to parse the GDT contents
(desc) and de-reference an bogus virtual address.

With this patch we are providing the last written address and size
of the GDT.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f29d6d6..4a65138 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -471,6 +471,8 @@ static void xen_set_ldt(const void *addr, unsigned entries)
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
+static DEFINE_PER_CPU(struct desc_ptr, gdt_desc);
+
 static void xen_load_gdt(const struct desc_ptr *dtr)
 {
 	unsigned long va = dtr->address;
@@ -478,6 +480,7 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 	unsigned pages = (size + PAGE_SIZE - 1) / PAGE_SIZE;
 	unsigned long frames[pages];
 	int f;
+	struct desc_ptr *shadow;
 
 	/*
 	 * A GDT can be up to 64k in size, which corresponds to 8192
@@ -515,8 +518,19 @@ static void xen_load_gdt(const struct desc_ptr *dtr)
 
 	if (HYPERVISOR_set_gdt(frames, size / sizeof(struct desc_struct)))
 		BUG();
+
+	shadow = &__get_cpu_var(gdt_desc);
+	shadow->address = dtr->address;
+	shadow->size = size;
 }
 
+static void xen_store_gdt(struct desc_ptr *dtr)
+{
+	const struct desc_ptr *desc = &__get_cpu_var(gdt_desc);
+
+	dtr->address = desc->address;
+	dtr->size = desc->size;
+}
 /*
  * load_gdt for early boot, when the gdt is only mapped once
  */
@@ -1205,7 +1219,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.alloc_ldt = xen_alloc_ldt,
 	.free_ldt = xen_free_ldt,
 
-	.store_gdt = native_store_gdt,
+	.store_gdt = xen_store_gdt,
 	.store_idt = xen_store_idt,
 	.store_tr = xen_store_tr,
 
-- 
1.7.7.6

