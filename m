Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab0IKCJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 22:09:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30360 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab0IKCJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 22:09:09 -0400
Message-ID: <4C8AE422.4070602@kernel.org>
Date: Fri, 10 Sep 2010 19:06:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Lin Ming <ming.m.lin@intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH] acpi: handle ACPI0007 Device in acpi_early_set_pdc
References: <4C89906B.1050406@kernel.org>	<201009101210.31942.bjorn.helgaas@hp.com>	<4C8A8504.9000606@kernel.org> <20100910164556.b72d848e.akpm@linux-foundation.org>
In-Reply-To: <20100910164556.b72d848e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 04:45 PM, Andrew Morton wrote:
> On Fri, 10 Sep 2010 12:20:36 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> On 09/10/2010 11:10 AM, Bjorn Helgaas wrote:
>>> On Thursday, September 09, 2010 07:56:59 pm Yinghai Lu wrote:
>>>>
>>>> When bios switch to use Device object instead of Processor statement.
>>>>
>>>> the SSDT for Pstate/Cstate/Tstate can not be loaded dynamically.
>>>>
>>>> So try to scan ACPI0007 in addition to Processor.
>>>>
>>>> this fix regression: 2.6.32 is ok.
>>>
>>> Can you include the URL of the regression bug report?  And maybe
>>> the commit that introduced the regression?
>>
>> the commit should be
>>
>> commit d8191fa4a33fdc817277da4f2b7f771ff605a41c
>> Author: Alex Chiang <achiang@hp.com>
>> Date:   Mon Feb 22 12:11:39 2010 -0700
>>
>>     ACPI: processor: driver doesn't need to evaluate _PDC
>>     
>>     Now that the early _PDC evaluation path knows how to correctly
>>     evaluate _PDC on only physically present processors, there's no
>>     need for the processor driver to evaluate it later when it loads.
>>     
>>     To cover the hotplug case, push _PDC evaluation down into the
>>     hotplug paths.
>>     
>>     Cc: x86@kernel.org
>>     Cc: Tony Luck <tony.luck@intel.com>
>>     Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>>     Signed-off-by: Alex Chiang <achiang@hp.com>
>>     Signed-off-by: Len Brown <len.brown@intel.com>
>>
>> that is between 2.6.34-rc1 and 2.6.34-rc2.
>>
>> So we need put this patch in stable tree for 2.6.34, .35, .36
>>
> 
> Maybe.  But first can you please address Bjorn's suggestions below?

fine, if you prefer 47 lines instead one line changes.

[PATCH -v2] acpi: handle ACPI0007 Device in acpi_early_set_pdc

When bios switch to use Device object instead of Processor statement.

the SSDT for Pstate/Cstate/Tstate can not loaded dynamically.

So try to scan ACPI0007 in addition to Processor.

-v2: add 47 lines instead of 1 line to walk namespace one time only.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/acpi/acpica/nsxfeval.c |   43 +++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/processor_core.c  |    8 ++++---
 include/acpi/acpixf.h          |    2 +
 3 files changed, 50 insertions(+), 3 deletions(-)

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
@@ -524,6 +524,49 @@ ACPI_EXPORT_SYMBOL(acpi_walk_namespace)
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_match_device_hid
+ *
+ * PARAMETERS:  handle and HID to be compared
+ *
+ * RETURN:      bool
+ *
+ * DESCRIPTION: check if device coresponding to handle has HID
+ *
+ ******************************************************************************/
+acpi_status acpi_match_device_hid(acpi_handle obj_handle, const char *HID)
+{
+	acpi_status status;
+	struct acpi_namespace_node *node;
+	struct acpica_device_id *hid;
+	int no_match;
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	node = acpi_ns_validate_handle(obj_handle);
+	status = acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	if (!node)
+		return AE_BAD_PARAMETER;
+
+	status = acpi_ut_execute_HID(node, &hid);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	no_match = ACPI_STRCMP(hid->string, HID);
+	ACPI_FREE(hid);
+
+	if (no_match)
+		return AE_NOT_FOUND;
+
+	return AE_OK;
+}
+
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_ns_get_device_callback
  *
  * PARAMETERS:  Callback from acpi_get_device
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
