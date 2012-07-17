Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2GQFBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:01:39 -0400
Received: from ozlabs.org ([203.10.76.45]:46554 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab2GQFBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:01:03 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <kvm@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <matt@ozlabs.org>, <penberg@kernel.org>,
        <kvm-ppc@vger.kernel.org>, <prerna@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 10/10] kvm tools, powerpc: Use MMU info for ibm,slb-size
Date: Tue, 17 Jul 2012 15:00:20 +1000
Message-Id: <1342501220-10209-11-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/powerpc/cpu_info.c |    3 +--
 tools/kvm/powerpc/cpu_info.h |    1 -
 tools/kvm/powerpc/kvm.c      |    5 +++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/kvm/powerpc/cpu_info.c b/tools/kvm/powerpc/cpu_info.c
index 82a9d4f..1f440a5 100644
--- a/tools/kvm/powerpc/cpu_info.c
+++ b/tools/kvm/powerpc/cpu_info.c
@@ -25,13 +25,13 @@
 
 static struct cpu_info cpu_power7_info = {
 	.name = "POWER7",
-	.slb_size = 32,
 	.tb_freq = 512000000,
 	.d_bsize = 128,
 	.i_bsize = 128,
 	.flags = CPUINFO_FLAG_DFP | CPUINFO_FLAG_VSX | CPUINFO_FLAG_VMX,
 	.mmu_info = {
 		.flags = KVM_PPC_PAGE_SIZES_REAL | KVM_PPC_1T_SEGMENTS,
+		.slb_size = 32,
 	},
 };
 
@@ -39,7 +39,6 @@ static struct cpu_info cpu_power7_info = {
 
 static struct cpu_info cpu_970_info = {
 	.name = "G5",
-	.slb_size = 0,
 	.tb_freq = 33333333,
 	.d_bsize = 128,
 	.i_bsize = 128,
diff --git a/tools/kvm/powerpc/cpu_info.h b/tools/kvm/powerpc/cpu_info.h
index 00b9436b..f61707a 100644
--- a/tools/kvm/powerpc/cpu_info.h
+++ b/tools/kvm/powerpc/cpu_info.h
@@ -19,7 +19,6 @@
 
 struct cpu_info {
 	const char	*name;
-	u32		slb_size;
 	u32		tb_freq; /* timebase frequency */
 	u32		d_bsize; /* d-cache block size */
 	u32		i_bsize; /* i-cache block size */
diff --git a/tools/kvm/powerpc/kvm.c b/tools/kvm/powerpc/kvm.c
index 8353355..83b8edd 100644
--- a/tools/kvm/powerpc/kvm.c
+++ b/tools/kvm/powerpc/kvm.c
@@ -393,8 +393,9 @@ static void setup_fdt(struct kvm *kvm)
 		/* Lies, but safeish lies! */
 		_FDT(fdt_property_cell(fdt, "clock-frequency", 0xddbab200));
 
-		if (cpu_info->slb_size)
-			_FDT(fdt_property_cell(fdt, "ibm,slb-size", cpu_info->slb_size));
+		if (cpu_info->mmu_info.slb_size)
+			_FDT(fdt_property_cell(fdt, "ibm,slb-size", cpu_info->mmu_info.slb_size));
+
 		/*
 		 * HPT size is hardwired; KVM currently fixes it at 16MB but the
 		 * moment that changes we'll need to read it out of the kernel.
-- 
1.7.9.5

