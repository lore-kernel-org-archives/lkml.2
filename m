Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2AQNWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:22:15 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:61857 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2AQNWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:22:11 -0500
X-Greylist: delayed 3603 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 08:22:10 EST
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 11/50] ACPI 5.0: New interfaces to allow driver access to AML
 mutex objects
Date: Tue, 17 Jan 2012 07:21:03 -0500
Message-id: <ffef68273b6278e98a99dd4051671d4854b20fe0.1326802229.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

Adds acpi_acquire_mutex, acpi_release_mutex external interfaces.
New file, utxfmutex.c.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/Makefile    |    2 +-
 drivers/acpi/acpica/utxfmutex.c |  187 +++++++++++++++++++++++++++++++++++++++
 include/acpi/acpixf.h           |   15 +++-
 3 files changed, 201 insertions(+), 3 deletions(-)
 create mode 100644 drivers/acpi/acpica/utxfmutex.c

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index 301bd2d..1bd4661 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -45,4 +45,4 @@ acpi-y += tbxface.o tbinstal.o tbutils.o tbfind.o tbfadt.o tbxfroot.o
 acpi-y += utalloc.o utdebug.o uteval.o utinit.o utmisc.o utxface.o \
 		utcopy.o utdelete.o utglobal.o utmath.o utobject.o \
 		utstate.o utmutex.o utobject.o utresrc.o utlock.o utids.o \
-		utosi.o utxferror.o utdecode.o
+		utosi.o utxferror.o utdecode.o utxfmutex.o
diff --git a/drivers/acpi/acpica/utxfmutex.c b/drivers/acpi/acpica/utxfmutex.c
new file mode 100644
index 0000000..1ea016b
--- /dev/null
+++ b/drivers/acpi/acpica/utxfmutex.c
@@ -0,0 +1,187 @@
+/*******************************************************************************
+ *
+ * Module Name: utxfmutex - external AML mutex access functions
+ *
+ ******************************************************************************/
+
+/*
+ * Copyright (C) 2000 - 2011, Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#include <acpi/acpi.h>
+#include "accommon.h"
+#include "acnamesp.h"
+
+#define _COMPONENT          ACPI_UTILITIES
+ACPI_MODULE_NAME("utxfmutex")
+
+/* Local prototypes */
+static acpi_status
+acpi_ut_get_mutex_object(acpi_handle handle,
+			 acpi_string pathname,
+			 union acpi_operand_object **ret_obj);
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ut_get_mutex_object
+ *
+ * PARAMETERS:  Handle              - Mutex or prefix handle (optional)
+ *              Pathname            - Mutex pathname (optional)
+ *              ret_obj             - Where the mutex object is returned
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Get an AML mutex object. The mutex node is pointed to by
+ *              Handle:Pathname. Either Handle or Pathname can be NULL, but
+ *              not both.
+ *
+ ******************************************************************************/
+
+static acpi_status
+acpi_ut_get_mutex_object(acpi_handle handle,
+			 acpi_string pathname,
+			 union acpi_operand_object **ret_obj)
+{
+	struct acpi_namespace_node *mutex_node;
+	union acpi_operand_object *mutex_obj;
+	acpi_status status;
+
+	/* Parameter validation */
+
+	if (!ret_obj || (!handle && !pathname)) {
+		return (AE_BAD_PARAMETER);
+	}
+
+	/* Get a the namespace node for the mutex */
+
+	mutex_node = handle;
+	if (pathname != NULL) {
+		status = acpi_get_handle(handle, pathname,
+					 ACPI_CAST_PTR(acpi_handle,
+						       &mutex_node));
+		if (ACPI_FAILURE(status)) {
+			return (status);
+		}
+	}
+
+	/* Ensure that we actually have a Mutex object */
+
+	if (!mutex_node || (mutex_node->type != ACPI_TYPE_MUTEX)) {
+		return (AE_TYPE);
+	}
+
+	/* Get the low-level mutex object */
+
+	mutex_obj = acpi_ns_get_attached_object(mutex_node);
+	if (!mutex_obj) {
+		return (AE_NULL_OBJECT);
+	}
+
+	*ret_obj = mutex_obj;
+	return (AE_OK);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_acquire_mutex
+ *
+ * PARAMETERS:  Handle              - Mutex or prefix handle (optional)
+ *              Pathname            - Mutex pathname (optional)
+ *              Timeout             - Max time to wait for the lock (millisec)
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Acquire an AML mutex. This is a device driver interface to
+ *              AML mutex objects, and allows for transaction locking between
+ *              drivers and AML code. The mutex node is pointed to by
+ *              Handle:Pathname. Either Handle or Pathname can be NULL, but
+ *              not both.
+ *
+ ******************************************************************************/
+
+acpi_status
+acpi_acquire_mutex(acpi_handle handle, acpi_string pathname, u16 timeout)
+{
+	acpi_status status;
+	union acpi_operand_object *mutex_obj;
+
+	/* Get the low-level mutex associated with Handle:Pathname */
+
+	status = acpi_ut_get_mutex_object(handle, pathname, &mutex_obj);
+	if (ACPI_FAILURE(status)) {
+		return (status);
+	}
+
+	/* Acquire the OS mutex */
+
+	status = acpi_os_acquire_mutex(mutex_obj->mutex.os_mutex, timeout);
+	return (status);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_release_mutex
+ *
+ * PARAMETERS:  Handle              - Mutex or prefix handle (optional)
+ *              Pathname            - Mutex pathname (optional)
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Release an AML mutex. This is a device driver interface to
+ *              AML mutex objects, and allows for transaction locking between
+ *              drivers and AML code. The mutex node is pointed to by
+ *              Handle:Pathname. Either Handle or Pathname can be NULL, but
+ *              not both.
+ *
+ ******************************************************************************/
+
+acpi_status acpi_release_mutex(acpi_handle handle, acpi_string pathname)
+{
+	acpi_status status;
+	union acpi_operand_object *mutex_obj;
+
+	/* Get the low-level mutex associated with Handle:Pathname */
+
+	status = acpi_ut_get_mutex_object(handle, pathname, &mutex_obj);
+	if (ACPI_FAILURE(status)) {
+		return (status);
+	}
+
+	/* Release the OS mutex */
+
+	acpi_os_release_mutex(mutex_obj->mutex.os_mutex);
+	return (AE_OK);
+}
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 9ba2e3a..dd86610 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -277,12 +277,23 @@ acpi_status acpi_install_exception_handler(acpi_exception_handler handler);
 acpi_status acpi_install_interface_handler(acpi_interface_handler handler);
 
 /*
- * Event interfaces
+ * Global Lock interfaces
  */
 acpi_status acpi_acquire_global_lock(u16 timeout, u32 * handle);
 
 acpi_status acpi_release_global_lock(u32 handle);
 
+/*
+ * Interfaces to AML mutex objects
+ */
+acpi_status
+acpi_acquire_mutex(acpi_handle handle, acpi_string pathname, u16 timeout);
+
+acpi_status acpi_release_mutex(acpi_handle handle, acpi_string pathname);
+
+/*
+ * Fixed Event interfaces
+ */
 acpi_status acpi_enable_event(u32 event, u32 flags);
 
 acpi_status acpi_disable_event(u32 event, u32 flags);
@@ -292,7 +303,7 @@ acpi_status acpi_clear_event(u32 event);
 acpi_status acpi_get_event_status(u32 event, acpi_event_status * event_status);
 
 /*
- * GPE Interfaces
+ * General Purpose Event (GPE) Interfaces
  */
 acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number);
 
-- 
1.7.9.rc1

