Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2GQFCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:02:00 -0400
Received: from ozlabs.org ([203.10.76.45]:41892 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab2GQFA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:00:56 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <kvm@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <matt@ozlabs.org>, <penberg@kernel.org>,
        <kvm-ppc@vger.kernel.org>, <prerna@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 07/10] kvm tools, powerpc: Restructure find_cpu_info()
Date: Tue, 17 Jul 2012 15:00:17 +1000
Message-Id: <1342501220-10209-8-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are about to add more logic to find_cpu_info(). To support this we
need to pass kvm through to it, and also restructure the return flow
so we can operate on info before it is returned.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/powerpc/cpu_info.c |   16 +++++++++++-----
 tools/kvm/powerpc/cpu_info.h |    4 +++-
 tools/kvm/powerpc/kvm.c      |    2 +-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/kvm/powerpc/cpu_info.c b/tools/kvm/powerpc/cpu_info.c
index 586b232..5015a4b 100644
--- a/tools/kvm/powerpc/cpu_info.c
+++ b/tools/kvm/powerpc/cpu_info.c
@@ -72,18 +72,24 @@ static struct pvr_info host_pvr_info[] = {
         { 0xffff0000, 0x00450000, &cpu_970_info },
 };
 
-struct cpu_info *find_cpu_info(u32 pvr)
+struct cpu_info *find_cpu_info(struct kvm *kvm)
 {
+	struct cpu_info *info;
 	unsigned int i;
+	u32 pvr = kvm->pvr;
 
-	for (i = 0; i < ARRAY_SIZE(host_pvr_info); i++) {
+	for (info = NULL, i = 0; i < ARRAY_SIZE(host_pvr_info); i++) {
 		if ((pvr & host_pvr_info[i].pvr_mask) == host_pvr_info[i].pvr) {
-			return host_pvr_info[i].cpu_info;
+			info = host_pvr_info[i].cpu_info;
+			break;
 		}
 	}
 
 	/* Didn't find anything? Rut-ro. */
-	pr_warning("Host CPU unsupported by kvmtool\n");
+	if (!info) {
+		pr_warning("Host CPU unsupported by kvmtool\n");
+		info = &cpu_dummy_info;
+	}
 
-	return &cpu_dummy_info;
+	return info;
 }
diff --git a/tools/kvm/powerpc/cpu_info.h b/tools/kvm/powerpc/cpu_info.h
index 2115c7f..439f3940 100644
--- a/tools/kvm/powerpc/cpu_info.h
+++ b/tools/kvm/powerpc/cpu_info.h
@@ -11,6 +11,8 @@
 #ifndef CPU_INFO_H
 #define CPU_INFO_H
 
+#include <kvm/kvm.h>
+
 #include <linux/types.h>
 #include <linux/kernel.h>
 
@@ -38,6 +40,6 @@ struct pvr_info {
 #define CPUINFO_FLAG_VMX	0x00000002
 #define CPUINFO_FLAG_VSX	0x00000004
 
-struct cpu_info *find_cpu_info(u32 pvr);
+struct cpu_info *find_cpu_info(struct kvm *kvm);
 
 #endif
diff --git a/tools/kvm/powerpc/kvm.c b/tools/kvm/powerpc/kvm.c
index e3a7e52..dbfea3e 100644
--- a/tools/kvm/powerpc/kvm.c
+++ b/tools/kvm/powerpc/kvm.c
@@ -229,7 +229,7 @@ static void setup_fdt(struct kvm *kvm)
 	int 		i, j;
 	char 		cpu_name[30];
 	u8		staging_fdt[FDT_MAX_SIZE];
-	struct cpu_info *cpu_info = find_cpu_info(kvm->pvr);
+	struct cpu_info *cpu_info = find_cpu_info(kvm);
 
 	/* Generate an appropriate DT at kvm->fdt_gra */
 	void *fdt_dest = guest_flat_to_host(kvm, kvm->fdt_gra);
-- 
1.7.9.5

