Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab1D2P3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:29:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46165 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759326Ab1D2P3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=YUuq0dctKLOWrNJhT9yDyqZTWdslLHsscLYS86ToNSWeMypv5mswvCyQvwE34SFCZX
         Ozrm30ocQlynPc9H8u2cfdEWVeY7l6vKl2N2dvz/3f/KgDj9iJlH/e/ekYS0cEfO1+zb
         PSL9FxhFAbkj90E2FOxcSwAjcMHaAvKgjzfFk=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/25] x86, NUMA: trivial cleanups
Date: Fri, 29 Apr 2011 17:28:27 +0200
Message-Id: <1304090924-8197-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kill no longer used struct bootnode.

* Kill dangling declaration of pxm_to_nid() in numa_32.h.

* Make setup_node_bootmem() static.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/acpi.h    |    2 --
 arch/x86/include/asm/amd_nb.h  |    1 -
 arch/x86/include/asm/numa_32.h |    2 --
 arch/x86/include/asm/numa_64.h |    7 -------
 arch/x86/mm/numa_64.c          |    2 +-
 5 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 12e0e7d..416d865 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -183,8 +183,6 @@ static inline void disable_acpi(void) { }
 
 #define ARCH_HAS_POWER_INIT	1
 
-struct bootnode;
-
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
 extern int x86_acpi_numa_init(void);
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 3316822..67f87f2 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -11,7 +11,6 @@ struct amd_nb_bus_dev_range {
 
 extern const struct pci_device_id amd_nb_misc_ids[];
 extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
-struct bootnode;
 
 extern bool early_is_amd_nb(u32 value);
 extern int amd_cache_northbridges(void);
diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
index 242522f..7e54b64 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -3,8 +3,6 @@
 
 extern int numa_off;
 
-extern int pxm_to_nid(int pxm);
-
 #ifdef CONFIG_HIGHMEM
 extern void set_highmem_pages_init(void);
 #else
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 12461eb..794da6d 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -3,18 +3,11 @@
 
 #include <linux/nodemask.h>
 
-struct bootnode {
-	u64 start;
-	u64 end;
-};
-
 #define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
 
 extern int numa_off;
 
 extern unsigned long numa_free_all_bootmem(void);
-extern void setup_node_bootmem(int nodeid, unsigned long start,
-			       unsigned long end);
 
 #ifdef CONFIG_NUMA
 /*
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 3598fbf..813a161 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -95,7 +95,7 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 }
 
 /* Initialize bootmem allocator for a node */
-void __init
+static void __init
 setup_node_bootmem(int nid, unsigned long start, unsigned long end)
 {
 	const u64 nd_low = (u64)MAX_DMA_PFN << PAGE_SHIFT;
-- 
1.7.1

