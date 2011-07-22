Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1GVOvC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:51:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52559 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab1GVOvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:51:00 -0400
Date: Fri, 22 Jul 2011 16:50:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/efi changes for v3.1
Message-ID: <20110722145020.GA16108@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-efi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-efi-for-linus

 Thanks,

	Ingo

------------------>
Jan Beulich (1):
      x86, efi: Properly pre-initialize table pointers

Matthew Garrett (2):
      x86, efi: Fix argument types for SetVariable()
      x86, efi: Add infrastructure for UEFI 2.0 runtime services


 arch/x86/platform/efi/efi.c |   51 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/efi.h         |   34 +++++++++++++++++++++++++++-
 2 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0d3a4fa..11e766d 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -51,7 +51,17 @@
 int efi_enabled;
 EXPORT_SYMBOL(efi_enabled);
 
-struct efi efi;
+struct efi __read_mostly efi = {
+	.mps        = EFI_INVALID_TABLE_ADDR,
+	.acpi       = EFI_INVALID_TABLE_ADDR,
+	.acpi20     = EFI_INVALID_TABLE_ADDR,
+	.smbios     = EFI_INVALID_TABLE_ADDR,
+	.sal_systab = EFI_INVALID_TABLE_ADDR,
+	.boot_info  = EFI_INVALID_TABLE_ADDR,
+	.hcdp       = EFI_INVALID_TABLE_ADDR,
+	.uga        = EFI_INVALID_TABLE_ADDR,
+	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+};
 EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
@@ -122,7 +132,7 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 
 static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 					  efi_guid_t *vendor,
-					  unsigned long attr,
+					  u32 attr,
 					  unsigned long data_size,
 					  void *data)
 {
@@ -131,6 +141,18 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 			      data_size, data);
 }
 
+static efi_status_t virt_efi_query_variable_info(u32 attr,
+						 u64 *storage_space,
+						 u64 *remaining_space,
+						 u64 *max_variable_size)
+{
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	return efi_call_virt4(query_variable_info, attr, storage_space,
+			      remaining_space, max_variable_size);
+}
+
 static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
 {
 	return efi_call_virt1(get_next_high_mono_count, count);
@@ -145,6 +167,28 @@ static void virt_efi_reset_system(int reset_type,
 		       data_size, data);
 }
 
+static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
+					    unsigned long count,
+					    unsigned long sg_list)
+{
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	return efi_call_virt3(update_capsule, capsules, count, sg_list);
+}
+
+static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
+						unsigned long count,
+						u64 *max_size,
+						int *reset_type)
+{
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	return efi_call_virt4(query_capsule_caps, capsules, count, max_size,
+			      reset_type);
+}
+
 static efi_status_t __init phys_efi_set_virtual_address_map(
 	unsigned long memory_map_size,
 	unsigned long descriptor_size,
@@ -651,6 +695,9 @@ void __init efi_enter_virtual_mode(void)
 	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
 	efi.reset_system = virt_efi_reset_system;
 	efi.set_virtual_address_map = NULL;
+	efi.query_variable_info = virt_efi_query_variable_info;
+	efi.update_capsule = virt_efi_update_capsule;
+	efi.query_capsule_caps = virt_efi_query_capsule_caps;
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
 	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index e376270..ec25726 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -101,6 +101,13 @@ typedef struct {
 	u64 attribute;
 } efi_memory_desc_t;
 
+typedef struct {
+	efi_guid_t guid;
+	u32 headersize;
+	u32 flags;
+	u32 imagesize;
+} efi_capsule_header_t;
+
 typedef int (*efi_freemem_callback_t) (u64 start, u64 end, void *arg);
 
 /*
@@ -156,6 +163,9 @@ typedef struct {
 	unsigned long set_variable;
 	unsigned long get_next_high_mono_count;
 	unsigned long reset_system;
+	unsigned long update_capsule;
+	unsigned long query_capsule_caps;
+	unsigned long query_variable_info;
 } efi_runtime_services_t;
 
 typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
@@ -168,7 +178,7 @@ typedef efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *vendor,
 typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char16_t *name,
 					      efi_guid_t *vendor);
 typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor, 
-					 unsigned long attr, unsigned long data_size, 
+					 u32 attr, unsigned long data_size,
 					 void *data);
 typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
 typedef void efi_reset_system_t (int reset_type, efi_status_t status,
@@ -177,6 +187,17 @@ typedef efi_status_t efi_set_virtual_address_map_t (unsigned long memory_map_siz
 						unsigned long descriptor_size,
 						u32 descriptor_version,
 						efi_memory_desc_t *virtual_map);
+typedef efi_status_t efi_query_variable_info_t(u32 attr,
+					       u64 *storage_space,
+					       u64 *remaining_space,
+					       u64 *max_variable_size);
+typedef efi_status_t efi_update_capsule_t(efi_capsule_header_t **capsules,
+					  unsigned long count,
+					  unsigned long sg_list);
+typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
+					      unsigned long count,
+					      u64 *max_size,
+					      int *reset_type);
 
 /*
  *  EFI Configuration Table and GUID definitions
@@ -218,6 +239,13 @@ typedef struct {
 
 #define EFI_SYSTEM_TABLE_SIGNATURE ((u64)0x5453595320494249ULL)
 
+#define EFI_2_30_SYSTEM_TABLE_REVISION  ((2 << 16) | (30))
+#define EFI_2_20_SYSTEM_TABLE_REVISION  ((2 << 16) | (20))
+#define EFI_2_10_SYSTEM_TABLE_REVISION  ((2 << 16) | (10))
+#define EFI_2_00_SYSTEM_TABLE_REVISION  ((2 << 16) | (00))
+#define EFI_1_10_SYSTEM_TABLE_REVISION  ((1 << 16) | (10))
+#define EFI_1_02_SYSTEM_TABLE_REVISION  ((1 << 16) | (02))
+
 typedef struct {
 	efi_table_hdr_t hdr;
 	unsigned long fw_vendor;	/* physical addr of CHAR16 vendor string */
@@ -250,6 +278,7 @@ struct efi_memory_map {
  */
 extern struct efi {
 	efi_system_table_t *systab;	/* EFI system table */
+	unsigned int runtime_version;	/* Runtime services version */
 	unsigned long mps;		/* MPS table */
 	unsigned long acpi;		/* ACPI table  (IA64 ext 0.71) */
 	unsigned long acpi20;		/* ACPI table  (ACPI 2.0) */
@@ -266,6 +295,9 @@ extern struct efi {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
+	efi_query_variable_info_t *query_variable_info;
+	efi_update_capsule_t *update_capsule;
+	efi_query_capsule_caps_t *query_capsule_caps;
 	efi_get_next_high_mono_count_t *get_next_high_mono_count;
 	efi_reset_system_t *reset_system;
 	efi_set_virtual_address_map_t *set_virtual_address_map;
