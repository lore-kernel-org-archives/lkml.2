Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2BWJOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 04:14:42 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:17042 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab2BWJOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 04:14:39 -0500
From: Tang Liang <liang.tang@oracle.com>
To: mjg59@srcf.ucam.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        konrad.wilk@oracle.com, JBeulich@suse.com
Cc: liang.tang@oracle.com
Subject: [PATCH 1/5V2] EFI: Provide registration for efi_init.. etc efi public  function
Date: Thu, 23 Feb 2012 17:12:58 +0800
Message-Id: <1329988378-26895-1-git-send-email-liang.tang@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1329988283-26722-1-git-send-email-liang.tang@oracle.com>
References: <1329988283-26722-1-git-send-email-liang.tang@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A02020A.4F460301.00B7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The efi public functions are changed to function pointer in efi_init_funcs
struct.
They act as efi generic functions as default.
As a benefit from this change, we can register xen efi init func.

[v2: Fixed compile issues spotted by Konrad,
change variables defined suggested by Jan]

Signed-off-by: Tang Liang <liang.tang@oracle.com>
---
 arch/x86/platform/efi/efi.c |   66 +++++++++++++++++++++++++++++++++++++++---
 include/linux/efi.h         |   11 +++++++
 2 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 4cf9bd0..dd690e6 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -50,6 +50,24 @@
 #define PFX 		"EFI: "
 
 int efi_enabled;
+
+static void efi_init_generic(void);
+
+static void efi_enter_virtual_mode_generic(void);
+static u32 efi_mem_type_generic(unsigned long phys_addr);
+static u64 efi_mem_attributes_generic(unsigned long phys_addr);
+static void efi_reserve_boot_services_generic(void);
+
+static const struct efi_init_funcs efi_generic_funcs = {
+	.efi_init		     = efi_init_generic,
+	.efi_reserve_boot_services = efi_reserve_boot_services_generic,
+	.efi_enter_virtual_mode    = efi_enter_virtual_mode_generic,
+	.efi_mem_type		     = efi_mem_type_generic,
+	.efi_mem_attributes	     = efi_mem_attributes_generic
+};
+
+const struct efi_init_funcs *efi_override_funcs =  &efi_generic_funcs;
+
 EXPORT_SYMBOL(efi_enabled);
 
 struct efi __read_mostly efi = {
@@ -376,7 +394,7 @@ static void __init print_efi_memmap(void)
 }
 #endif  /*  EFI_DEBUG  */
 
-void __init efi_reserve_boot_services(void)
+static void efi_reserve_boot_services_generic(void)
 {
 	void *p;
 
@@ -429,7 +447,7 @@ static void __init efi_free_boot_services(void)
 	}
 }
 
-void __init efi_init(void)
+static void efi_init_generic(void)
 {
 	efi_config_table_t *config_tables;
 	efi_runtime_services_t *runtime;
@@ -618,7 +636,7 @@ static void __init runtime_code_page_mkexec(void)
  * This enables the runtime services to be called without having to
  * thunk back into physical mode for every invocation.
  */
-void __init efi_enter_virtual_mode(void)
+static void efi_enter_virtual_mode_generic(void)
 {
 	efi_memory_desc_t *md, *prev_md = NULL;
 	efi_status_t status;
@@ -752,7 +770,7 @@ void __init efi_enter_virtual_mode(void)
 /*
  * Convenience functions to obtain memory types and attributes
  */
-u32 efi_mem_type(unsigned long phys_addr)
+static u32 efi_mem_type_generic(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
 	void *p;
@@ -767,7 +785,7 @@ u32 efi_mem_type(unsigned long phys_addr)
 	return 0;
 }
 
-u64 efi_mem_attributes(unsigned long phys_addr)
+static u64 efi_mem_attributes_generic(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
 	void *p;
@@ -781,3 +799,41 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	}
 	return 0;
 }
+
+void efi_init_function_register(const struct efi_init_funcs *funcs)
+{
+	efi_override_funcs = funcs;
+}
+
+void __init efi_init(void)
+{
+	if (efi_override_funcs->efi_init)
+		efi_override_funcs->efi_init();
+}
+
+void __init efi_reserve_boot_services(void)
+{
+	if (efi_override_funcs->efi_reserve_boot_services)
+		efi_override_funcs->efi_reserve_boot_services();
+}
+
+void __init efi_enter_virtual_mode(void)
+{
+	if (efi_override_funcs->efi_enter_virtual_mode)
+		efi_override_funcs->efi_enter_virtual_mode();
+}
+
+
+u32 efi_mem_type(unsigned long phys_addr)
+{
+	if (efi_override_funcs->efi_mem_type)
+		return efi_override_funcs->efi_mem_type(phys_addr);
+	return EFI_INVALID_TYPE;
+}
+
+u64 efi_mem_attributes(unsigned long phys_addr)
+{
+	if (efi_override_funcs->efi_mem_attributes)
+		return efi_override_funcs->efi_mem_attributes(phys_addr);
+	return EFI_INVALID_ATTRIBUTE;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 37c3007..469ac66 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -79,8 +79,10 @@ typedef	struct {
 #define EFI_MEMORY_MAPPED_IO_PORT_SPACE	12
 #define EFI_PAL_CODE			13
 #define EFI_MAX_MEMORY_TYPE		14
+#define EFI_INVALID_TYPE		0xffffffff
 
 /* Attribute values: */
+#define EFI_INVALID_ATTRIBUTE	((u64)0x0000000000000000ULL)	/* invalid attribute*/
 #define EFI_MEMORY_UC		((u64)0x0000000000000001ULL)	/* uncached */
 #define EFI_MEMORY_WC		((u64)0x0000000000000002ULL)	/* write-coalescing */
 #define EFI_MEMORY_WT		((u64)0x0000000000000004ULL)	/* write-through */
@@ -434,6 +436,14 @@ extern struct efi {
 	efi_set_virtual_address_map_t *set_virtual_address_map;
 } efi;
 
+struct efi_init_funcs {
+	void (*efi_init)(void);
+	void (*efi_reserve_boot_services)(void);
+	void (*efi_enter_virtual_mode)(void);
+	u32 (*efi_mem_type)(unsigned long phys_addr);
+	u64 (*efi_mem_attributes)(unsigned long phys_addr);
+};
+
 static inline int
 efi_guidcmp (efi_guid_t left, efi_guid_t right)
 {
@@ -464,6 +474,7 @@ extern unsigned long efi_get_time(void);
 extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
+extern void efi_init_function_register(const struct efi_init_funcs *funcs);
 
 /**
  * efi_range_is_wc - check the WC bit on an address range
-- 
1.7.7.5

