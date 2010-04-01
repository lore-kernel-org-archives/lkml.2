Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab0DACJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:09:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:59297 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab0DACJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:09:50 -0400
Message-ID: <4BB3FFE4.4010909@kernel.org>
Date: Wed, 31 Mar 2010 19:07:32 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Peter Jones <pjones@redhat.com>,
       Konrad Rzeszutek Wilk <konrad@kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: [PATCH] ibft, x86: Change reserve_ibft_region() to find_ibft_region()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



So arch code could decide the way to reserve the ibft.

And We should reserve ibft as early as possible, instead of BOOTMEM stage,
in case the table is in RAM range and is not reserved by BIOS.

move that just sfter find_smp_config()

Also when CONFIG_NO_BOOTMEM=y, We will not have reserve_bootmem() anymore

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Jones <pjones@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/setup.c            |   14 ++++++++++++--
 drivers/firmware/iscsi_ibft_find.c |   11 ++++++++---
 include/linux/iscsi_ibft.h         |    8 ++++++--
 3 files changed, 26 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -608,6 +608,16 @@ static int __init setup_elfcorehdr(char
 early_param("elfcorehdr", setup_elfcorehdr);
 #endif
 
+static __init void reserve_ibft_region(void)
+{
+	unsigned long addr, size = 0;
+
+	addr = find_ibft_region(&size);
+
+	if (size)
+		reserve_early_overlap_ok(addr, addr + size, "ifbt");
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
Index: linux-2.6/drivers/firmware/iscsi_ibft_find.c
===================================================================
--- linux-2.6.orig/drivers/firmware/iscsi_ibft_find.c
+++ linux-2.6/drivers/firmware/iscsi_ibft_find.c
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
Index: linux-2.6/include/linux/iscsi_ibft.h
===================================================================
--- linux-2.6.orig/include/linux/iscsi_ibft.h
+++ linux-2.6/include/linux/iscsi_ibft.h
@@ -42,9 +42,13 @@ extern struct ibft_table_header *ibft_ad
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
