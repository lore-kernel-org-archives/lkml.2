Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab2IYO4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:56:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab2IYO42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:56:28 -0400
From: Thomas Renninger <trenn@suse.de>
To: hpa@zytor.com
Cc: lenb@kernel.org, initramfs@vger.kernel.org, robert.moore@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        yinghai@kernel.org, Thomas Renninger <trenn@suse.de>
Subject: [PATCH 2/6] X86 ACPI: Introduce x86 arch specific arch_reserve_mem_area() for e820 handling
Date: Tue, 25 Sep 2012 16:55:57 +0200
Message-Id: <1348584961-1476-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1348584961-1476-1-git-send-email-trenn@suse.de>
References: <1348584961-1476-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for ACPI table overriding via initrd. Beside reserving
memblocks, X86 also requires to flag the memory area to E820_RESERVED or
E820_ACPI in the e820 mappings to be able to io(re)map it later.

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/acpi/boot.c |    6 ++++++
 include/linux/acpi.h        |    9 +++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b2297e5..6b75777 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1700,3 +1700,9 @@ int __acpi_release_global_lock(unsigned int *lock)
 	} while (unlikely (val != old));
 	return old & 0x1;
 }
+
+void __init arch_reserve_mem_area(acpi_physical_address addr, size_t size)
+{
+	e820_add_region(addr, size, E820_ACPI);
+	update_e820();
+}
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 4f2a762..bf6a0ad 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -430,4 +430,13 @@ acpi_status acpi_os_prepare_sleep(u8 sleep_state,
 #define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while (0)
 #endif
 
+#if CONFIG_X86
+void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
+#else
+static inline void void arch_reserve_mem_area(acpi_physical_address addr,
+					      size_t size)
+{
+}
+#endif /* CONFIG_X86 */
+
 #endif	/*_LINUX_ACPI_H*/
-- 
1.7.6.1

