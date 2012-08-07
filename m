Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab2HGT4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:56:16 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36268 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab2HGT4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:56:12 -0400
Message-ID: <1344369417.24990.6.camel@footlong>
Subject: [PATCH 2/3] PPC64: Add support for instantiating SML from Open
 Firmware
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, key@linux.vnet.ibm.com, adlai@us.ibm.com,
        adlai@linux.vnet.ibm.com
Date: Tue, 07 Aug 2012 14:56:57 -0500
In-Reply-To: <1344367748.24990.1.camel@footlong>
References: <1344367748.24990.1.camel@footlong>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080719-4242-0000-0000-00000289A485
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch instantiate Stored Measurement Log (SML) and put the
log address and size in the device tree.

Signed-off-by: Ashley Lai <adlai@us.ibm.com>
---
 arch/powerpc/kernel/prom_init.c |   64 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 1b488e5..3f54bd4 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1624,6 +1624,65 @@ static void __init prom_instantiate_rtas(void)
 
 #ifdef CONFIG_PPC64
 /*
+ * Allocate room for and instantiate Stored Measurement Log (SML)
+ */
+static void __init prom_instantiate_sml(void)
+{
+	phandle ibmvtpm_node;
+	ihandle ibmvtpm_inst;
+	u32 entry = 0, size = 0;
+	u64 base;
+
+	prom_debug("prom_instantiate_sml: start...\n");
+
+	ibmvtpm_node = call_prom("finddevice", 1, 1, ADDR("/ibm,vtpm"));
+	prom_debug("ibmvtpm_node: %x\n", ibmvtpm_node);
+	if (!PHANDLE_VALID(ibmvtpm_node))
+		return;
+
+	ibmvtpm_inst = call_prom("open", 1, 1, ADDR("/ibm,vtpm"));
+	if (!IHANDLE_VALID(ibmvtpm_inst)) {
+		prom_printf("opening vtpm package failed (%x)\n", ibmvtpm_inst);
+		return;
+	}
+
+	if (call_prom_ret("call-method", 2, 2, &size,
+			  ADDR("sml-get-handover-size"),
+			  ibmvtpm_inst) != 0) {
+		prom_printf("SML get handover size failed\n");
+		return;
+	}
+	if (size == 0)
+		return;
+
+	base = alloc_down(size, PAGE_SIZE, 0);
+	if (base == 0)
+		prom_panic("Could not allocate memory for sml\n");
+
+	prom_printf("instantiating sml at 0x%x...", base);
+
+	if (call_prom_ret("call-method", 4, 2, &entry,
+			  ADDR("sml-handover"),
+			  ibmvtpm_inst, size, base) != 0 || entry == 0) {
+		prom_printf("SML handover failed\n");
+		return;
+	}
+	prom_printf(" done\n");
+
+	reserve_mem(base, size);
+
+	prom_setprop(ibmvtpm_node, "/ibm,vtpm", "linux,sml-base",
+		     &base, sizeof(base));
+	prom_setprop(ibmvtpm_node, "/ibm,vtpm", "linux,sml-size",
+		     &size, sizeof(size));
+
+	prom_debug("sml base     = 0x%x\n", base);
+	prom_debug("sml size     = 0x%x\n", (long)size);
+
+	prom_debug("prom_instantiate_sml: end...\n");
+}
+
+/*
  * Allocate room for and initialize TCE tables
  */
 static void __init prom_initialize_tce_table(void)
@@ -2916,6 +2975,11 @@ unsigned long __init prom_init(unsigned long r3, unsigned long r4,
 		prom_instantiate_opal();
 #endif
 
+#ifdef CONFIG_PPC64
+	/* instantiate sml */
+	prom_instantiate_sml();
+#endif
+
 	/*
 	 * On non-powermacs, put all CPUs in spin-loops.
 	 *
-- 
1.7.1


