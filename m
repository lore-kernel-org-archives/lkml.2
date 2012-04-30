Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab2D3QRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 12:17:17 -0400
Received: from [124.207.24.138] ([124.207.24.138]:46680 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2D3QRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 12:17:16 -0400
Subject: [PATCH v2] xen/apic: implement io apic read with hypercall
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 01 May 2012 00:16:27 +0800
Message-ID: <1335802587.4746.2.camel@chief-river-32>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements xen_io_apic_read with hypercall, so it returns proper
IO-APIC information instead of fabricated one.

Fallback to return an emulated IO_APIC values if hypercall fails.

Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
---

v2: fallback to return an emulated IO_APIC values if hypercall fails

 arch/x86/xen/apic.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index aee16ab..1913bf2 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -1,14 +1,27 @@
 #include <linux/init.h>
 #include <asm/x86_init.h>
+#include <asm/apic.h>
+#include <xen/interface/physdev.h>
+#include <asm/xen/hypercall.h>
 
 unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
 {
+	struct physdev_apic apic_op;
+	int ret;
+
+	apic_op.apic_physbase = mpc_ioapic_addr(apic);
+	apic_op.reg = reg;
+	ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
+	if (!ret)
+		return apic_op.value;
+
+	/* fallback to return an emulated IO_APIC values */
 	if (reg == 0x1)
 		return 0x00170020;
 	else if (reg == 0x0)
 		return apic << 24;
 
-	return 0xff;
+	return 0xfd;
 }
 
 void __init xen_init_apic(void)
-- 
1.7.9



