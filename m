Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab2BWJPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 04:15:17 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:49962 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab2BWJPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 04:15:14 -0500
From: Tang Liang <liang.tang@oracle.com>
To: mjg59@srcf.ucam.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        konrad.wilk@oracle.com, JBeulich@suse.com
Cc: liang.tang@oracle.com
Subject: [PATCH 3/5V2] EFI: add efi driver for Xen efi
Date: Thu, 23 Feb 2012 17:13:45 +0800
Message-Id: <1329988425-26970-1-git-send-email-liang.tang@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1329988283-26722-1-git-send-email-liang.tang@oracle.com>
References: <1329988283-26722-1-git-send-email-liang.tang@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090203.4F46032F.0025,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

The efi memory is owned by Xen and efi run-time service can not be called
directly,so a new efi driver is needed by Xen efi.
We call efi run-time service through the Xen in Xen efi driver.

[v2: Modifications done to abstract calls]

Signed-off-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Tang Liang <liang.tang@oracle.com>
---
 arch/x86/platform/efi/Makefile   |    3 +
 arch/x86/platform/efi/efi-xen.c  |  432 ++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h              |    1 +
 include/xen/interface/platform.h |  122 +++++++++++
 4 files changed, 558 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/platform/efi/efi-xen.c

diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
index 73b8be0..9577899 100644
--- a/arch/x86/platform/efi/Makefile
+++ b/arch/x86/platform/efi/Makefile
@@ -1 +1,4 @@
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
+ifdef CONFIG_XEN
+obj-$(CONFIG_EFI)		+= efi-xen.o
+endif
diff --git a/arch/x86/platform/efi/efi-xen.c b/arch/x86/platform/efi/efi-xen.c
new file mode 100644
index 0000000..c133d60
--- /dev/null
+++ b/arch/x86/platform/efi/efi-xen.c
@@ -0,0 +1,432 @@
+/*
+ * Common EFI (Extensible Firmware Interface) support functions
+ * Based on Extensible Firmware Interface Specification version 1.0
+ *
+ * Copyright (C) 1999 VA Linux Systems
+ * Copyright (C) 1999 Walt Drummond <drummond@valinux.com>
+ * Copyright (C) 1999-2002 Hewlett-Packard Co.
+ *	David Mosberger-Tang <davidm@hpl.hp.com>
+ *	Stephane Eranian <eranian@hpl.hp.com>
+ * Copyright (C) 2005-2008 Intel Co.
+ *	Fenghua Yu <fenghua.yu@intel.com>
+ *	Bibo Mao <bibo.mao@intel.com>
+ *	Chandramouli Narayanan <mouli@linux.intel.com>
+ *	Huang Ying <ying.huang@intel.com>
+ * Copyright (C) 2011 Novell Co.
+ *	Jan Beulic <JBeulich@suse.com>
+ * Copyright (C) 2011-2012 Oracle Co.
+ *	Liang Tang <liang.tang@oracle.com>
+ *
+ *
+ * Copied from efi_32.c to eliminate the duplicated code between EFI
+ * 32/64 support code. --ying 2007-10-26
+ *
+ * All EFI Runtime Services are not implemented yet as EFI only
+ * supports physical mode addressing on SoftSDV. This is to be fixed
+ * in a future version.  --drummond 1999-07-20
+ *
+ * Implemented EFI runtime services and virtual mode calls.  --davidm
+ *
+ * Goutham Rao: <goutham.rao@intel.com>
+ *	Skip non-WB memory and ignore empty memory ranges.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/efi.h>
+#include <linux/export.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/time.h>
+
+#include <asm/setup.h>
+#include <asm/efi.h>
+#include <asm/time.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+#include <asm/x86_init.h>
+
+#include <xen/interface/platform.h>
+#include <asm/xen/hypercall.h>
+
+#define PFX		"EFI: "
+
+#define call (op.u.efi_runtime_call)
+#define DECLARE_CALL(what) \
+	struct xen_platform_op op; \
+	op.cmd = XENPF_efi_runtime_call; \
+	call.function = XEN_EFI_##what; \
+	call.misc = 0
+
+static void register_xen_efi_function(void);
+
+static efi_status_t xen_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	int err;
+	DECLARE_CALL(get_time);
+
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	if (tm) {
+		BUILD_BUG_ON(sizeof(*tm) != sizeof(call.u.get_time.time));
+		memcpy(tm, &call.u.get_time.time, sizeof(*tm));
+	}
+
+	if (tc) {
+		tc->resolution = call.u.get_time.resolution;
+		tc->accuracy = call.u.get_time.accuracy;
+		tc->sets_to_zero = !!(call.misc &
+				      XEN_EFI_GET_TIME_SET_CLEARS_NS);
+	}
+
+	return call.status;
+}
+
+static efi_status_t xen_efi_set_time(efi_time_t *tm)
+{
+	DECLARE_CALL(set_time);
+
+	BUILD_BUG_ON(sizeof(*tm) != sizeof(call.u.set_time));
+	memcpy(&call.u.set_time, tm, sizeof(*tm));
+
+	return HYPERVISOR_dom0_op(&op) ? EFI_UNSUPPORTED : call.status;
+}
+
+static efi_status_t xen_efi_get_wakeup_time(efi_bool_t *enabled,
+					    efi_bool_t *pending,
+					    efi_time_t *tm)
+{
+	int err;
+	DECLARE_CALL(get_wakeup_time);
+
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	if (tm) {
+		BUILD_BUG_ON(sizeof(*tm) != sizeof(call.u.get_wakeup_time));
+		memcpy(tm, &call.u.get_wakeup_time, sizeof(*tm));
+	}
+
+	if (enabled)
+		*enabled = !!(call.misc & XEN_EFI_GET_WAKEUP_TIME_ENABLED);
+
+	if (pending)
+		*pending = !!(call.misc & XEN_EFI_GET_WAKEUP_TIME_PENDING);
+
+	return call.status;
+}
+
+static efi_status_t xen_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	DECLARE_CALL(set_wakeup_time);
+
+	BUILD_BUG_ON(sizeof(*tm) != sizeof(call.u.set_wakeup_time));
+	if (enabled)
+		call.misc = XEN_EFI_SET_WAKEUP_TIME_ENABLE;
+	if (tm)
+		memcpy(&call.u.set_wakeup_time, tm, sizeof(*tm));
+	else
+		call.misc |= XEN_EFI_SET_WAKEUP_TIME_ENABLE_ONLY;
+
+	return HYPERVISOR_dom0_op(&op) ? EFI_UNSUPPORTED : call.status;
+}
+
+static efi_status_t xen_efi_get_variable(efi_char16_t *name,
+					 efi_guid_t *vendor,
+					 u32 *attr,
+					 unsigned long *data_size,
+					 void *data)
+{
+	int err;
+	DECLARE_CALL(get_variable);
+
+	set_xen_guest_handle(call.u.get_variable.name, name);
+	BUILD_BUG_ON(sizeof(*vendor) !=
+		     sizeof(call.u.get_variable.vendor_guid));
+	memcpy(&call.u.get_variable.vendor_guid, vendor, sizeof(*vendor));
+	call.u.get_variable.size = *data_size;
+	set_xen_guest_handle(call.u.get_variable.data, data);
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	*data_size = call.u.get_variable.size;
+	*attr = call.misc; /* misc in struction is U32 variable*/
+
+	return call.status;
+}
+
+static efi_status_t xen_efi_get_next_variable(unsigned long *name_size,
+					      efi_char16_t *name,
+					      efi_guid_t *vendor)
+{
+	int err;
+	DECLARE_CALL(get_next_variable_name);
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+	call.u.get_next_variable_name.size = *name_size;
+	set_xen_guest_handle(call.u.get_next_variable_name.name, name);
+	BUILD_BUG_ON(sizeof(*vendor) !=
+		     sizeof(call.u.get_next_variable_name.vendor_guid));
+	memcpy(&call.u.get_next_variable_name.vendor_guid, vendor,
+	       sizeof(*vendor));
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	*name_size = call.u.get_next_variable_name.size;
+	memcpy(vendor, &call.u.get_next_variable_name.vendor_guid,
+	       sizeof(*vendor));
+
+	return call.status;
+}
+
+static efi_status_t xen_efi_set_variable(efi_char16_t *name,
+					 efi_guid_t *vendor,
+					 u32 attr,
+					 unsigned long data_size,
+					 void *data)
+{
+	DECLARE_CALL(set_variable);
+
+	set_xen_guest_handle(call.u.set_variable.name, name);
+	call.misc = attr;
+	BUILD_BUG_ON(sizeof(*vendor) !=
+		     sizeof(call.u.set_variable.vendor_guid));
+	memcpy(&call.u.set_variable.vendor_guid, vendor, sizeof(*vendor));
+	call.u.set_variable.size = data_size;
+	set_xen_guest_handle(call.u.set_variable.data, data);
+
+	return HYPERVISOR_dom0_op(&op) ? EFI_UNSUPPORTED : call.status;
+}
+
+static efi_status_t xen_efi_query_variable_info(u32 attr,
+						u64 *storage_space,
+						u64 *remaining_space,
+						u64 *max_variable_size)
+{
+	int err;
+	DECLARE_CALL(query_variable_info);
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	*storage_space = call.u.query_variable_info.max_store_size;
+	*remaining_space = call.u.query_variable_info.remain_store_size;
+	*max_variable_size = call.u.query_variable_info.max_size;
+
+	return call.status;
+}
+
+static efi_status_t xen_efi_get_next_high_mono_count(u32 *count)
+{
+	int err;
+	DECLARE_CALL(get_next_high_monotonic_count);
+
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	*count = call.misc;
+
+	return call.status;
+}
+
+static efi_status_t xen_efi_update_capsule(efi_capsule_header_t **capsules,
+					   unsigned long count,
+					   unsigned long sg_list)
+{
+	DECLARE_CALL(update_capsule);
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	set_xen_guest_handle(call.u.update_capsule.capsule_header_array,
+			     capsules);
+	call.u.update_capsule.capsule_count = count;
+	call.u.update_capsule.sg_list = sg_list;
+
+	return HYPERVISOR_dom0_op(&op) ? EFI_UNSUPPORTED : call.status;
+}
+
+static efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
+					       unsigned long count,
+					       u64 *max_size,
+					       int *reset_type)
+{
+	int err;
+	DECLARE_CALL(query_capsule_capabilities);
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	set_xen_guest_handle(call.u.query_capsule_capabilities.
+		capsule_header_array, capsules);
+	call.u.query_capsule_capabilities.capsule_count = count;
+
+	err = HYPERVISOR_dom0_op(&op);
+	if (err)
+		return EFI_UNSUPPORTED;
+
+	*max_size = call.u.query_capsule_capabilities.max_capsule_size;
+	*reset_type = call.u.query_capsule_capabilities.reset_type;
+
+	return call.status;
+}
+
+#undef DECLARE_CALL
+#undef call
+
+static struct efi __read_mostly efi_xen = {
+	.mps                      = EFI_INVALID_TABLE_ADDR,
+	.acpi                     = EFI_INVALID_TABLE_ADDR,
+	.acpi20                   = EFI_INVALID_TABLE_ADDR,
+	.smbios                   = EFI_INVALID_TABLE_ADDR,
+	.sal_systab               = EFI_INVALID_TABLE_ADDR,
+	.boot_info                = EFI_INVALID_TABLE_ADDR,
+	.hcdp                     = EFI_INVALID_TABLE_ADDR,
+	.uga                      = EFI_INVALID_TABLE_ADDR,
+	.uv_systab                = EFI_INVALID_TABLE_ADDR,
+	.get_time                 = xen_efi_get_time,
+	.set_time                 = xen_efi_set_time,
+	.get_wakeup_time          = xen_efi_get_wakeup_time,
+	.set_wakeup_time          = xen_efi_set_wakeup_time,
+	.get_variable             = xen_efi_get_variable,
+	.get_next_variable        = xen_efi_get_next_variable,
+	.set_variable             = xen_efi_set_variable,
+	.get_next_high_mono_count = xen_efi_get_next_high_mono_count,
+	.query_variable_info      = xen_efi_query_variable_info,
+	.update_capsule           = xen_efi_update_capsule,
+	.query_capsule_caps       = xen_efi_query_capsule_caps,
+};
+
+void xen_efi_probe(void)
+{
+	static struct xen_platform_op __initdata op = {
+		.cmd = XENPF_firmware_info,
+		.u.firmware_info = {
+			.type = XEN_FW_EFI_INFO,
+			.index = XEN_FW_EFI_CONFIG_TABLE
+		}
+	};
+
+	if (HYPERVISOR_dom0_op(&op) == 0) {
+		efi_enabled = 1;
+
+		register_xen_efi_function();
+	}
+}
+
+
+static void __init efi_init_xen(void)
+{
+	efi_config_table_t *config_tables;
+	efi_char16_t c16[100];
+	char vendor[ARRAY_SIZE(c16)] = "unknown";
+	int ret, i;
+	struct xen_platform_op op;
+	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
+
+	efi = efi_xen;
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+
+	/*
+	 * Show what we know for posterity
+	 */
+	op.u.firmware_info.index = XEN_FW_EFI_VENDOR;
+	info->vendor.bufsz = sizeof(c16);
+	set_xen_guest_handle(info->vendor.name, c16);
+	ret = HYPERVISOR_dom0_op(&op);
+	if (!ret) {
+		for (i = 0; i < sizeof(vendor) - 1 && c16[i]; ++i)
+			vendor[i] = c16[i];
+		vendor[i] = '\0';
+	} else
+		pr_err("Could not get the firmware vendor!\n");
+
+	op.u.firmware_info.index = XEN_FW_EFI_VERSION;
+	ret = HYPERVISOR_dom0_op(&op);
+	if (!ret)
+		pr_info("EFI v%u.%.02u by %s\n",
+		       info->version >> 16,
+		       info->version & 0xffff, vendor);
+	else
+		pr_err("Could not get EFI revision!\n");
+
+	op.u.firmware_info.index = XEN_FW_EFI_RT_VERSION;
+	ret = HYPERVISOR_dom0_op(&op);
+	if (!ret)
+		efi.runtime_version = info->version;
+	else
+		pr_warn(PFX "Could not get runtime services revision.\n");
+
+	/*
+	 * Let's see what config tables the firmware passed to us.
+	 */
+	op.u.firmware_info.index = XEN_FW_EFI_CONFIG_TABLE;
+	if (HYPERVISOR_dom0_op(&op))
+		BUG();
+	config_tables = early_ioremap(
+		info->cfg.addr,
+		info->cfg.nent * sizeof(efi_config_table_t));
+	if (config_tables == NULL)
+		panic("Could not map EFI Configuration Table!\n");
+
+	get_efi_table_info(config_tables, info->cfg.nent, &efi);
+
+	early_iounmap(config_tables,
+		info->cfg.nent * sizeof(efi_config_table_t));
+
+	x86_platform.get_wallclock = efi_get_time;
+	x86_platform.set_wallclock = efi_set_rtc_mmss;
+}
+
+/*
+ * Convenience functions to obtain memory types and attributes
+ */
+static u32 efi_mem_type_xen(unsigned long phys_addr)
+{
+	struct xen_platform_op op;
+	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
+
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+	op.u.firmware_info.index = XEN_FW_EFI_MEM_INFO;
+	info->mem.addr = phys_addr;
+	info->mem.size = 0;
+	return HYPERVISOR_dom0_op(&op) ? 0 : info->mem.type;
+}
+
+static u64 efi_mem_attributes_xen(unsigned long phys_addr)
+{
+	struct xen_platform_op op;
+	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
+
+	op.cmd = XENPF_firmware_info;
+	op.u.firmware_info.type = XEN_FW_EFI_INFO;
+	op.u.firmware_info.index = XEN_FW_EFI_MEM_INFO;
+	info->mem.addr = phys_addr;
+	info->mem.size = 0;
+	return HYPERVISOR_dom0_op(&op) ? 0 : info->mem.attr;
+}
+
+static const struct efi_init_funcs xen_efi_funcs = {
+	.efi_init		     = efi_init_xen,
+	.efi_reserve_boot_services = NULL,
+	.efi_enter_virtual_mode    = NULL,
+	.efi_mem_type		     = efi_mem_type_xen,
+	.efi_mem_attributes	     = efi_mem_attributes_xen
+};
+
+static void register_xen_efi_function(void)
+{
+	efi_init_function_register(&xen_efi_funcs);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 4276c96..7b46590 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -477,6 +477,7 @@ extern struct efi_memory_map memmap;
 extern void efi_init_function_register(const struct efi_init_funcs *funcs);
 extern void get_efi_table_info(efi_config_table_t *config_tables, int nr_tables,
 			       struct efi *efi_t);
+extern void xen_efi_probe(void);
 
 /**
  * efi_range_is_wc - check the WC bit on an address range
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
index c168468..77eb0fa 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -108,10 +108,112 @@ struct xenpf_platform_quirk {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_platform_quirk_t);
 
+#define XENPF_efi_runtime_call    49
+#define XEN_EFI_get_time                      1
+#define XEN_EFI_set_time                      2
+#define XEN_EFI_get_wakeup_time               3
+#define XEN_EFI_set_wakeup_time               4
+#define XEN_EFI_get_next_high_monotonic_count 5
+#define XEN_EFI_get_variable                  6
+#define XEN_EFI_set_variable                  7
+#define XEN_EFI_get_next_variable_name        8
+#define XEN_EFI_query_variable_info           9
+#define XEN_EFI_query_capsule_capabilities   10
+#define XEN_EFI_update_capsule               11
+
+struct xenpf_efi_runtime_call {
+	uint32_t function;
+    /*
+     * This field is generally used for per sub-function flags (defined
+     * below), except for the XEN_EFI_get_next_high_monotonic_count case,
+     * where it holds the single returned value.
+     */
+	uint32_t misc;
+	unsigned long status;
+	union {
+#define XEN_EFI_GET_TIME_SET_CLEARS_NS 0x00000001
+	struct {
+		struct xenpf_efi_time {
+			uint16_t year;
+			uint8_t month;
+			uint8_t day;
+			uint8_t hour;
+			uint8_t min;
+			uint8_t sec;
+			uint32_t ns;
+			int16_t tz;
+			uint8_t daylight;
+		} time;
+		uint32_t resolution;
+		uint32_t accuracy;
+	} get_time;
+
+	struct xenpf_efi_time set_time;
+
+#define XEN_EFI_GET_WAKEUP_TIME_ENABLED 0x00000001
+#define XEN_EFI_GET_WAKEUP_TIME_PENDING 0x00000002
+	struct xenpf_efi_time get_wakeup_time;
+
+#define XEN_EFI_SET_WAKEUP_TIME_ENABLE      0x00000001
+#define XEN_EFI_SET_WAKEUP_TIME_ENABLE_ONLY 0x00000002
+	struct xenpf_efi_time set_wakeup_time;
+
+#define XEN_EFI_VARIABLE_NON_VOLATILE       0x00000001
+#define XEN_EFI_VARIABLE_BOOTSERVICE_ACCESS 0x00000002
+#define XEN_EFI_VARIABLE_RUNTIME_ACCESS     0x00000004
+	struct {
+		GUEST_HANDLE(void) name;  /* UCS-2/UTF-16 string */
+		unsigned long size;
+		GUEST_HANDLE(void) data;
+		struct xenpf_efi_guid {
+			uint32_t data1;
+			uint16_t data2;
+			uint16_t data3;
+			uint8_t data4[8];
+			} vendor_guid;
+		} get_variable, set_variable;
+
+	struct {
+		unsigned long size;
+		GUEST_HANDLE(void) name;  /* UCS-2/UTF-16 string */
+		struct xenpf_efi_guid vendor_guid;
+		} get_next_variable_name;
+
+	struct {
+		uint32_t attr;
+		uint64_t max_store_size;
+		uint64_t remain_store_size;
+		uint64_t max_size;
+		} query_variable_info;
+
+	struct {
+		GUEST_HANDLE(void) capsule_header_array;
+		unsigned long capsule_count;
+		uint64_t max_capsule_size;
+		unsigned int reset_type;
+		} query_capsule_capabilities;
+
+	struct {
+		GUEST_HANDLE(void) capsule_header_array;
+		unsigned long capsule_count;
+		uint64_t sg_list; /* machine address */
+		} update_capsule;
+	} u;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xenpf_efi_runtime_call);
+
+#define  XEN_FW_EFI_VERSION        0
+#define  XEN_FW_EFI_CONFIG_TABLE   1
+#define  XEN_FW_EFI_VENDOR         2
+#define  XEN_FW_EFI_MEM_INFO       3
+#define  XEN_FW_EFI_RT_VERSION     4
+
 #define XENPF_firmware_info       50
 #define XEN_FW_DISK_INFO          1 /* from int 13 AH=08/41/48 */
 #define XEN_FW_DISK_MBR_SIGNATURE 2 /* from MBR offset 0x1b8 */
 #define XEN_FW_VBEDDC_INFO        3 /* from int 10 AX=4f15 */
+#define XEN_FW_EFI_INFO           4 /* from EFI */
+
 struct xenpf_firmware_info {
 	/* IN variables. */
 	uint32_t type;
@@ -142,6 +244,25 @@ struct xenpf_firmware_info {
 			/* must refer to 128-byte buffer */
 			GUEST_HANDLE(uchar) edid;
 		} vbeddc_info; /* XEN_FW_VBEDDC_INFO */
+		union xenpf_efi_info {
+			uint32_t version;
+			struct {
+				uint64_t addr;   /* EFI_CONFIGURATION_TABLE */
+				uint32_t nent;
+			} cfg;
+			struct {
+				uint32_t revision;
+				uint32_t bufsz;  /* input, in bytes */
+				GUEST_HANDLE(void) name;
+				/* UCS-2/UTF-16 string */
+				} vendor;
+			struct {
+				uint64_t addr;
+				uint64_t size;
+				uint64_t attr;
+				uint32_t type;
+				} mem;
+		} efi_info; /* XEN_FW_EFI_INFO */
 	} u;
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_firmware_info_t);
@@ -307,6 +428,7 @@ struct xen_platform_op {
 		struct xenpf_read_memtype      read_memtype;
 		struct xenpf_microcode_update  microcode;
 		struct xenpf_platform_quirk    platform_quirk;
+		struct xenpf_efi_runtime_call  efi_runtime_call;
 		struct xenpf_firmware_info     firmware_info;
 		struct xenpf_enter_acpi_sleep  enter_acpi_sleep;
 		struct xenpf_change_freq       change_freq;
-- 
1.7.7.5

