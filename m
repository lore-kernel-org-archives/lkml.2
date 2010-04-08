Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab0DHPxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:53:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:58705 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661Ab0DHPxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:53:50 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Jones <pjones@redhat.com>,
       Konrad Rzeszutek Wilk <konrad@kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: [PATCH 1/1] ibft, x86: Change reserve_ibft_region() to find_ibft_region()
Date: Thu,  8 Apr 2010 15:52:16 +0000
Message-Id: <1270741936-1306-2-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270741936-1306-1-git-send-email-konrad@kernel.org>
References: <1270741936-1306-1-git-send-email-konrad@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Apr 2010 15:52:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

So arch code could decide the way to reserve the ibft.

And We should reserve ibft as early as possible, instead of BOOTMEM stage,
in case the table is in RAM range and is not reserved by BIOS.

move that just sfter find_smp_config()

Also when CONFIG_NO_BOOTMEM=y, We will not have reserve_bootmem() anymore

-v2: fix typo about ibft pointed by Konrad Rzeszutek Wilk <konrad@darnok.org>

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Jones <pjones@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
---
 arch/x86/kernel/setup.c            |   14 ++++++++++++--
 drivers/firmware/iscsi_ibft_find.c |   11 ++++++++---
 include/linux/iscsi_ibft.h         |    8 ++++++--
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d76e185..580e6b3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -608,6 +608,16 @@ static int __init setup_elfcorehdr(char *arg)
 early_param("elfcorehdr", setup_elfcorehdr);
 #endif
 
+static __init void reserve_ibft_region(void)
+{
+	unsigned long addr, size = 0;
+
+	addr = find_ibft_region(&size);
+
+	if (size)
+		reserve_early_overlap_ok(addr, addr + size, "ibft");
+}
+
 #ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
@@ -910,6 +920,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	find_smp_config();
 
+	reserve_ibft_region();
+
 	reserve_trampoline_memory();
 
 #ifdef CONFIG_ACPI_SLEEP
@@ -977,8 +989,6 @@ void __init setup_arch(char **cmdline_p)
 
 	dma32_reserve_bootmem();
 
-	reserve_ibft_region();
-
 #ifdef CONFIG_KVM_CLOCK
 	kvmclock_init();
 #endif
diff --git a/drivers/firmware/iscsi_ibft_find.c b/drivers/firmware/iscsi_ibft_find.c
index dfb15c0..8f5d9e2 100644
--- a/drivers/firmware/iscsi_ibft_find.c
+++ b/drivers/firmware/iscsi_ibft_find.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL_GPL(ibft_addr);
  * Routine used to find the iSCSI Boot Format Table. The logical
  * kernel address is set in the ibft_addr global variable.
  */
-void __init reserve_ibft_region(void)
+unsigned long __init find_ibft_region(unsigned long *sizep)
 {
 	unsigned long pos;
 	unsigned int len = 0;
@@ -78,6 +78,11 @@ void __init reserve_ibft_region(void)
 			}
 		}
 	}
-	if (ibft_addr)
-		reserve_bootmem(pos, PAGE_ALIGN(len), BOOTMEM_DEFAULT);
+	if (ibft_addr) {
+		*sizep = PAGE_ALIGN(len);
+		return pos;
+	}
+
+	*sizep = 0;
+	return 0;
 }
diff --git a/include/linux/iscsi_ibft.h b/include/linux/iscsi_ibft.h
index 6092487..d2e4042 100644
--- a/include/linux/iscsi_ibft.h
+++ b/include/linux/iscsi_ibft.h
@@ -42,9 +42,13 @@ extern struct ibft_table_header *ibft_addr;
  * mapped address is set in the ibft_addr variable.
  */
 #ifdef CONFIG_ISCSI_IBFT_FIND
-extern void __init reserve_ibft_region(void);
+unsigned long find_ibft_region(unsigned long *sizep);
 #else
-static inline void reserve_ibft_region(void) { }
+static inline unsigned long find_ibft_region(unsigned long *sizep)
+{
+	*sizep = 0;
+	return 0;
+}
 #endif
 
 #endif /* ISCSI_IBFT_H */
-- 
1.6.2.5

