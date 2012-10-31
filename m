Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422998Ab2JaOgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:36:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422960Ab2JaOfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:35:52 -0400
From: Thomas Renninger <trenn@suse.de>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Subject: [PATCH 1/3] ACPI: Cleanup acpi_initrd_override declaration and remove ifdefs
Date: Wed, 31 Oct 2012 15:35:45 +0100
Message-Id: <1351694147-10904-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1351694147-10904-1-git-send-email-trenn@suse.de>
References: <1351694147-10904-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the acpi_initrd_override() declaration out of CONFIG_ACPI area so that
acpi_initrd_override is also defined if CONFIG_ACPI is not defined.

Move the acpi_initrd_override() call into reserve_initrd() inside the
CONFIG_BLK_DEV_INITRD block.

Now ifdefs around the call in setup.c can be removed.

Cleanup only, no functional change.

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/setup.c |    6 ++----
 include/linux/acpi.h    |   16 ++++++++--------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e800bc6..db3ba50 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -411,6 +411,8 @@ static void __init reserve_initrd(void)
 	relocate_initrd();
 
 	memblock_free(ramdisk_image, ramdisk_end - ramdisk_image);
+
+	acpi_initrd_override((void *)initrd_start, initrd_end - initrd_start);
 }
 #else
 static void __init reserve_initrd(void)
@@ -956,10 +958,6 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_initrd();
 
-#if defined(CONFIG_ACPI) && defined(CONFIG_BLK_DEV_INITRD)
-	acpi_initrd_override((void *)initrd_start, initrd_end - initrd_start);
-#endif
-
 	reserve_crashkernel();
 
 	vsmp_init();
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index f70f18d..e4f9445 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -76,14 +76,6 @@ typedef int (*acpi_table_handler) (struct acpi_table_header *table);
 
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
-#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
-void acpi_initrd_override(void *data, size_t size);
-#else
-static inline void acpi_initrd_override(void *data, size_t size)
-{
-}
-#endif
-
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
 void __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
@@ -446,4 +438,12 @@ static inline void arch_reserve_mem_area(acpi_physical_address addr,
 #define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while (0)
 #endif
 
+#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
+void acpi_initrd_override(void *data, size_t size);
+#else
+static inline void acpi_initrd_override(void *data, size_t size)
+{
+}
+#endif
+
 #endif	/*_LINUX_ACPI_H*/
-- 
1.7.6.1

