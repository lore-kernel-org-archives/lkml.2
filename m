Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab2BIDcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 22:32:14 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:35028 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab2BIDcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 22:32:12 -0500
From: Tang Liang <liang.tang@oracle.com>
To: mjg59@srcf.ucam.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        konrad.wilk@oracle.com
Cc: liang.tang@oracle.com
Subject: [PATCH 1/5] EFI: Provide registration for efi_init.. etc efi public  function
Date: Thu,  9 Feb 2012 11:32:08 +0800
Message-Id: <1328758328-24156-1-git-send-email-liang.tang@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1328758250-23989-1-git-send-email-liang.tang@oracle.com>
References: <1328758250-23989-1-git-send-email-liang.tang@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F333E38.0040,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The efi public functions are changed to function pointer in efi_init_funcs
struct.
They act as efi generic functions as default.
As a benefit from this change, we can register xen efi init func.

Signed-off-by: Tang Liang <liang.tang@oracle.com>
---
 arch/x86/platform/efi/efi.c |   65 +++++++++++++++++++++++++++++++++++++++---
 include/linux/efi.h         |   12 +++++++-
 2 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 4cf9bd0..d567e29 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -50,6 +50,23 @@
 #define PFX 		"EFI: "
 
 int efi_enabled;
+
+static void efi_init_generic(void);
+
+static void efi_enter_virtual_mode_generic(void);
+static u32 efi_mem_type_generic(unsigned long phys_addr);
+static u64 efi_mem_attributes_generic(unsigned long phys_addr);
+
+struct efi_init_funcs efi_generic_funcs = {
+	.__efi_init		     = efi_init_generic,
+	.__efi_reserve_boot_services = efi_reserve_boot_services_generic,
+	.__efi_enter_virtual_mode    = efi_enter_virtual_mode_generic,
+	.__efi_mem_type		     = efi_mem_type_generic,
+	.__efi_mem_attributes	     = efi_mem_attributes_generic
+};
+
+struct efi_init_funcs *efi_override_funcs =  &efi_generic_funcs;
+
 EXPORT_SYMBOL(efi_enabled);
 
 struct efi __read_mostly efi = {
@@ -376,7 +393,7 @@ static void __init print_efi_memmap(void)
 }
 #endif  /*  EFI_DEBUG  */
 
-void __init efi_reserve_boot_services(void)
+static void efi_reserve_boot_services_generic(void)
 {
 	void *p;
 
@@ -429,7 +446,7 @@ static void __init efi_free_boot_services(void)
 	}
 }
 
-void __init efi_init(void)
+static void efi_init_generic(void)
 {
 	efi_config_table_t *config_tables;
 	efi_runtime_services_t *runtime;
@@ -618,7 +635,7 @@ static void __init runtime_code_page_mkexec(void)
  * This enables the runtime services to be called without having to
  * thunk back into physical mode for every invocation.
  */
-void __init efi_enter_virtual_mode(void)
+static void efi_enter_virtual_mode_generic(void)
 {
 	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
@@ -752,7 +769,7 @@ void __init efi_enter_virtual_mode(void)
 /*
  * Convenience functions to obtain memory types and attributes
  */
-u32 efi_mem_type(unsigned long phys_addr)
+static u32 efi_mem_type_generic(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
 	void *p;
@@ -767,7 +784,7 @@ u32 efi_mem_type(unsigned long phys_addr)
 	return 0;
 }
 
-u64 efi_mem_attributes(unsigned long phys_addr)
+static u64 efi_mem_attributes_generic(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
 	void *p;
@@ -781,3 +798,41 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	}
 	return 0;
 }
+
+void efi_init_function_register(struct efi_init_funcs *funcs)
+{
+	efi_override_funcs = funcs;
+}
+
+void __init efi_init(void)
+{
+	if (efi_override_funcs->__efi_init)
+		efi_override_funcs->__efi_init();
+}
+
+void __init efi_reserve_boot_services(void)
+{
+	if (efi_override_funcs->__efi_reserve_boot_services)
+		efi_override_funcs->__efi_reserve_boot_services();
+}
+
+void __init efi_enter_virtual_mode(void)
+{
+	if (efi_override_funcs->__efi_enter_virtual_mode)
+		efi_override_funcs->__efi_enter_virtual_mode();
+}
+
+
+u32 efi_mem_type(unsigned long phys_addr)
+{
+	if (efi_override_funcs->__efi_mem_type)
+		return efi_override_funcs->__efi_mem_type(phys_addr);
+	return EFI_INVALID_TYPE;
+}
+
+u64 efi_mem_attributes(unsigned long phys_addr)
+{
+	if (efi_override_funcs->__efi_mem_attributes)
+		return efi_override_funcs->__efi_mem_attributes(phys_addr);
+	return EFI_INVALID_ATTRIBUTE;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 37c3007..62e0a1f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -79,8 +79,9 @@ typedef	struct {
 #define EFI_MEMORY_MAPPED_IO_PORT_SPACE	12
 #define EFI_PAL_CODE			13
 #define EFI_MAX_MEMORY_TYPE		14
-
+#define EFI_INVALID_TYPE		0xffffffff
 /* Attribute values: */
+#define EFI_INVALID_ATTRIBUTE	((u64)0x0000000000000000ULL)	/* invalid attribute*/
 #define EFI_MEMORY_UC		((u64)0x0000000000000001ULL)	/* uncached */
 #define EFI_MEMORY_WC		((u64)0x0000000000000002ULL)	/* write-coalescing */
 #define EFI_MEMORY_WT		((u64)0x0000000000000004ULL)	/* write-through */
@@ -434,6 +435,14 @@ extern struct efi {
 	efi_set_virtual_address_map_t *set_virtual_address_map;
 } efi;
 
+struct efi_init_funcs {
+	void (*__efi_init)(void);
+	void (*__efi_reserve_boot_services)(void);
+	void (*__efi_enter_virtual_mode)(void);
+	u32 (*__efi_mem_type)(unsigned long phys_addr);
+	u64 (*__efi_mem_attributes)(unsigned long phys_addr);
+};
+
 static inline int
 efi_guidcmp (efi_guid_t left, efi_guid_t right)
 {
@@ -464,6 +473,7 @@ extern unsigned long efi_get_time(void);
 extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
+extern void efi_init_function_register(struct efi_init_funcs *funcs);
 
 /**
  * efi_range_is_wc - check the WC bit on an address range
-- 
1.7.7.5

