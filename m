Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2JQODs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:03:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44568 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab2JQODp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:03:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, hpa@zytor.com,
        x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/4] xen/lowlevel: Implement pvop call for load_idt (sidt).
Date: Wed, 17 Oct 2012 09:49:44 -0400
Message-Id: <1350481786-4969-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the past it used to point to 'sidt' (native_store_idt) operation
which is a non-privileged operation. This resulted in the
'struct desc_ptr' value containing the address of Xen's IDT table,
instead of the IDT table that Linux thinks its using. The end result
is that doing:

  store_idt(&desc);
  load_idt(&desc);

would blow up b/c xen_load_idt would try to parse the IDT contents
(desc) and de-reference a virtual address that is outside Linux's
__va (it is in Xen's virtual address).

With this patch we are providing the last written IDT address.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e3497f2..f29d6d6 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -777,7 +777,13 @@ static void xen_load_idt(const struct desc_ptr *desc)
 
 	spin_unlock(&lock);
 }
+static void xen_store_idt(struct desc_ptr *dtr)
+{
+	const struct desc_ptr *desc = &__get_cpu_var(idt_desc);
 
+	dtr->address = desc->address;
+	dtr->size = desc->size;
+}
 /* Write a GDT descriptor entry.  Ignore LDT descriptors, since
    they're handled differently. */
 static void xen_write_gdt_entry(struct desc_struct *dt, int entry,
@@ -1200,7 +1206,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.free_ldt = xen_free_ldt,
 
 	.store_gdt = native_store_gdt,
-	.store_idt = native_store_idt,
+	.store_idt = xen_store_idt,
 	.store_tr = xen_store_tr,
 
 	.write_ldt_entry = xen_write_ldt_entry,
-- 
1.7.7.6

