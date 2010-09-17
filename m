Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab0IQHYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 03:24:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49194 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab0IQHYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 03:24:08 -0400
Message-ID: <4C931714.2080905@kernel.org>
Date: Fri, 17 Sep 2010 00:21:56 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Lin Ming <ming.m.lin@intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH] acpi: handle ACPI0007 Device in acpi_early_set_pdc
References: <4C89906B.1050406@kernel.org> <20100910164556.b72d848e.akpm@linux-foundation.org> <4C8AE422.4070602@kernel.org> <201009131128.42519.bjorn.helgaas@hp.com>
In-Reply-To: <201009131128.42519.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 10:28 AM, Bjorn Helgaas wrote:
> On Friday, September 10, 2010 08:06:26 pm Yinghai Lu wrote:
> 
> I timed the original on a 64-CPU box where the namespace walk cost
> should be relatively high, and the walk you added takes about 0.01
> seconds.  The one already there took about 0.03 seconds, so neither
> costs very much.
> 
> And I don't like the fact that the patch below changes the ACPI CA
> and it only partly implements acpi_get_devices(), since it ignores
> _CID and _STA.

please check this one. it still keep _STA etc.

[PATCH -v3] acpi: Handle ACPI0007 Device in acpi_early_set_pdc

After
| commit d8191fa4a33fdc817277da4f2b7f771ff605a41c
| Author: Alex Chiang <achiang@hp.com>
| Date:   Mon Feb 22 12:11:39 2010 -0700
|
|    ACPI: processor: driver doesn't need to evaluate _PDC
|
|    Now that the early _PDC evaluation path knows how to correctly
|    evaluate _PDC on only physically present processors, there's no
|    need for the processor driver to evaluate it later when it loads.
|
|    To cover the hotplug case, push _PDC evaluation down into the
|    hotplug paths.

only cpu with Processor Statement get processed with _PDC

If bios is using Device object instead of Processor statement.
SSDTs for Pstate/Cstate/Tstate can not be loaded dynamically.

Need to try to scan ACPI0007 in addition to Processor.

That commit is between 2.6.34-rc1 and 2.6.34-rc2, so stable tree for 2.6.34+
need this patch.

-v2: add 47 lines instead of 1 line to walk namespace one time only.
-v3: Let acpi_match_device_hid() call acpi_ns_get_device_callback()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/acpi/acpica/nsxfeval.c |   41 +++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/processor_core.c  |    8 +++++---
 include/acpi/acpixf.h          |    2 ++
 3 files changed, 48 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/acpi/processor_core.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_core.c
+++ linux-2.6/drivers/acpi/processor_core.c
@@ -189,7 +189,7 @@ int acpi_get_cpuid(acpi_handle handle, i
 EXPORT_SYMBOL_GPL(acpi_get_cpuid);
 #endif
 
-static bool processor_physically_present(acpi_handle handle)
+static bool is_processor_and_physically_present(acpi_handle handle)
 {
 	int cpuid, type;
 	u32 acpi_id;
@@ -211,6 +211,8 @@ static bool processor_physically_present
 		acpi_id = object.processor.proc_id;
 		break;
 	case ACPI_TYPE_DEVICE:
+		if (acpi_match_device_hid(handle, "ACPI0007") != AE_OK)
+			return false;
 		status = acpi_evaluate_integer(handle, "_UID", NULL, &tmp);
 		if (ACPI_FAILURE(status))
 			return false;
@@ -334,7 +336,7 @@ EXPORT_SYMBOL_GPL(acpi_processor_set_pdc
 static acpi_status
 early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
-	if (processor_physically_present(handle) == false)
+	if (is_processor_and_physically_present(handle) == false)
 		return AE_OK;
 
 	acpi_processor_set_pdc(handle);
@@ -349,7 +351,7 @@ void __init acpi_early_processor_set_pdc
 	 */
 	dmi_check_system(processor_idle_dmi_table);
 
-	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
+	acpi_walk_namespace(ACPI_TYPE_ANY, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
 			    early_init_pdc, NULL, NULL, NULL);
 }
Index: linux-2.6/drivers/acpi/acpica/nsxfeval.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/nsxfeval.c
+++ linux-2.6/drivers/acpi/acpica/nsxfeval.c
@@ -642,6 +642,47 @@ acpi_ns_get_device_callback(acpi_handle
 	return (status);
 }
 
+static acpi_status
+acpi_match_device_hid_callback(acpi_handle obj_handle,
+			    u32 nesting_level,
+			    void *context, void **return_value)
+{
+	*return_value = (void *)0xff;
+
+	return AE_OK;
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_match_device_hid
+ *
+ * PARAMETERS:  handle and HID to be compared
+ *
+ * RETURN:      AE_OK mean found match one
+ *
+ * DESCRIPTION: check if device coresponding to handle has HID
+ *
+ ******************************************************************************/
+acpi_status acpi_match_device_hid(acpi_handle obj_handle, const char *HID)
+{
+	struct acpi_get_devices_info info;
+	void *return_value = NULL;
+
+	ACPI_FUNCTION_TRACE(acpi_match_device_hid);
+
+	info.hid = HID;
+	info.context = NULL;
+	info.user_function = acpi_match_device_hid_callback;
+
+	acpi_ns_get_device_callback(obj_handle, ACPI_UINT32_MAX,
+				    &info, &return_value);
+
+	if (!return_value)
+		return AE_NOT_FOUND;
+
+	return AE_OK;
+}
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_get_devices
Index: linux-2.6/include/acpi/acpixf.h
===================================================================
--- linux-2.6.orig/include/acpi/acpixf.h
+++ linux-2.6/include/acpi/acpixf.h
@@ -160,6 +160,8 @@ acpi_walk_namespace(acpi_object_type typ
 		    acpi_walk_callback post_order_visit,
 		    void *context, void **return_value);
 
+acpi_status acpi_match_device_hid(acpi_handle obj_handle, const char *HID);
+
 acpi_status
 acpi_get_devices(const char *HID,
 		 acpi_walk_callback user_function,
