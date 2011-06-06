Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1FFVWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:22:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:36123 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab1FFVW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:22:29 -0400
Date: Mon, 6 Jun 2011 21:22:24 GMT
From: tip-bot for Matthew Garrett <mjg@redhat.com>
Message-ID: <tip-3b3702377c576f6624348c7c6fd113bfd934fbd7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1307388985-7852-2-git-send-email-mjg@redhat.com>
References: <1307388985-7852-2-git-send-email-mjg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Add infrastructure for UEFI 2.0 runtime services
Git-Commit-ID: 3b3702377c576f6624348c7c6fd113bfd934fbd7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 21:22:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b3702377c576f6624348c7c6fd113bfd934fbd7
Gitweb:     http://git.kernel.org/tip/3b3702377c576f6624348c7c6fd113bfd934fbd7
Author:     Matthew Garrett <mjg@redhat.com>
AuthorDate: Mon, 6 Jun 2011 15:36:25 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 6 Jun 2011 13:30:30 -0700

x86, efi: Add infrastructure for UEFI 2.0 runtime services

We're currently missing support for any of the runtime service calls
introduced with the UEFI 2.0 spec in 2006. Add the infrastructure for
supporting them.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Link: http://lkml.kernel.org/r/1307388985-7852-2-git-send-email-mjg@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi.c |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/efi.h         |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f4f6de9..a0e4244 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -131,6 +131,18 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
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
@@ -145,6 +157,28 @@ static void virt_efi_reset_system(int reset_type,
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
@@ -651,6 +685,9 @@ void __init efi_enter_virtual_mode(void)
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
index 0758753..ec25726 100644
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
