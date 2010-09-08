Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab0IHXM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 19:12:26 -0400
Received: from [69.28.251.93] ([69.28.251.93]:47035 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab0IHXMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 19:12:21 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Wed, 8 Sep 2010 16:02:14 -0700
Subject: [PATCH 2/3] MIPS: Allow UserLocal on MIPS_R1 processors
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Message-Id: <d57a8d9cc346a9235a93e528beac4c40@localhost>
In-Reply-To: <064bb0722da5d8c271c2bd9fe0a521cc@localhost>
References: <064bb0722da5d8c271c2bd9fe0a521cc@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some MIPS32R1 processors implement UserLocal (RDHWR $29) to accelerate
programs that make extensive use of thread-local storage.  Therefore,
setting up the HWRENA register should not depend on cpu_has_mips_r2.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/kernel/traps.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 03ec001..ec6cbd2 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1469,6 +1469,7 @@ void __cpuinit per_cpu_trap_init(void)
 {
 	unsigned int cpu = smp_processor_id();
 	unsigned int status_set = ST0_CU0;
+	unsigned int hwrena = cpu_hwrena_impl_bits;
 #ifdef CONFIG_MIPS_MT_SMTC
 	int secondaryTC = 0;
 	int bootTC = (cpu == 0);
@@ -1501,14 +1502,14 @@ void __cpuinit per_cpu_trap_init(void)
 	change_c0_status(ST0_CU|ST0_MX|ST0_RE|ST0_FR|ST0_BEV|ST0_TS|ST0_KX|ST0_SX|ST0_UX,
 			 status_set);
 
-	if (cpu_has_mips_r2) {
-		unsigned int enable = 0x0000000f | cpu_hwrena_impl_bits;
+	if (cpu_has_mips_r2)
+		hwrena |= 0x0000000f;
 
-		if (!noulri && cpu_has_userlocal)
-			enable |= (1 << 29);
+	if (!noulri && cpu_has_userlocal)
+		hwrena |= (1 << 29);
 
-		write_c0_hwrena(enable);
-	}
+	if (hwrena)
+		write_c0_hwrena(hwrena);
 
 #ifdef CONFIG_MIPS_MT_SMTC
 	if (!secondaryTC) {
-- 
1.7.0.4

