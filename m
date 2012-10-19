Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab2JSTPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:15:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40669 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab2JSTPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:15:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/hvm: If we fail to fetch an HVM parameter print out which flag it is.
Date: Fri, 19 Oct 2012 15:03:01 -0400
Message-Id: <1350673381-20342-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes it easier to troubleshoot in the field.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/xen/hvm.h |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/xen/hvm.h b/include/xen/hvm.h
index b193fa2..c2a4238 100644
--- a/include/xen/hvm.h
+++ b/include/xen/hvm.h
@@ -5,6 +5,33 @@
 #include <xen/interface/hvm/params.h>
 #include <asm/xen/hypercall.h>
 
+static const char *param_name(int op)
+{
+	static const char *const names[] = {
+		[HVM_PARAM_CALLBACK_IRQ] = "HVM_PARAM_CALLBACK_IRQ",
+		[HVM_PARAM_STORE_PFN] = "HVM_PARAM_STORE_PFN",
+		[HVM_PARAM_STORE_EVTCHN] = "HVM_PARAM_STORE_EVTCHN",
+		[HVM_PARAM_PAE_ENABLED] = "HVM_PARAM_PAE_ENABLED",
+		[HVM_PARAM_IOREQ_PFN] = "HVM_PARAM_IOREQ_PFN",
+		[HVM_PARAM_BUFIOREQ_PFN] = "HVM_PARAM_BUFIOREQ_PFN",
+		[HVM_PARAM_TIMER_MODE] = "HVM_PARAM_TIMER_MODE",
+		[HVM_PARAM_HPET_ENABLED] = "HVM_PARAM_HPET_ENABLED",
+		[HVM_PARAM_IDENT_PT] = "HVM_PARAM_IDENT_PT",
+		[HVM_PARAM_DM_DOMAIN] = "HVM_PARAM_DM_DOMAIN",
+		[HVM_PARAM_ACPI_S_STATE] = "HVM_PARAM_ACPI_S_STATE",
+		[HVM_PARAM_VM86_TSS] = "HVM_PARAM_VM86_TSS",
+		[HVM_PARAM_VPT_ALIGN] = "HVM_PARAM_VPT_ALIGN",
+		[HVM_PARAM_CONSOLE_PFN] = "HVM_PARAM_CONSOLE_PFN",
+		[HVM_PARAM_CONSOLE_EVTCHN] = "HVM_PARAM_CONSOLE_EVTCHN" };
+
+	if (op >= ARRAY_SIZE(names))
+		return "unknown";
+
+	if (!names[op])
+		return "reserved";
+
+	return names[op];
+}
 static inline int hvm_get_parameter(int idx, uint64_t *value)
 {
 	struct xen_hvm_param xhv;
@@ -14,8 +41,8 @@ static inline int hvm_get_parameter(int idx, uint64_t *value)
 	xhv.index = idx;
 	r = HYPERVISOR_hvm_op(HVMOP_get_param, &xhv);
 	if (r < 0) {
-		printk(KERN_ERR "Cannot get hvm parameter %d: %d!\n",
-			idx, r);
+		printk(KERN_ERR "Cannot get hvm parameter %s (%d): %d!\n",
+			param_name(idx), idx, r);
 		return r;
 	}
 	*value = xhv.value;
-- 
1.7.7.6

