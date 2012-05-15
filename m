Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab2EOPIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:08:55 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:55162 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933095Ab2EOPH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:07:29 -0400
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: acking@vmware.com, dtor@vmware.com, dsouders@vmware.com,
        cschamp@vmware.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, virtualization@lists.linux-foundation.org,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [vmw_vmci RFC 06/11] Apply dynamic array code
Date: Tue, 15 May 2012 08:07:03 -0700
Message-Id: <1337094428-20453-7-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
References: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code adds support for dynamic arrays that will grow if they
need to.

Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_handle_array.c |  300 +++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_handle_array.h |   50 +++++
 2 files changed, 350 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_handle_array.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_handle_array.h

diff --git a/drivers/misc/vmw_vmci/vmci_handle_array.c b/drivers/misc/vmw_vmci/vmci_handle_array.c
new file mode 100644
index 0000000..799e66b
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_handle_array.c
@@ -0,0 +1,300 @@
+/*
+ * VMware VMCI Driver
+ *
+ * Copyright (C) 2012 VMware, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation version 2 and no later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
+ */
+
+#include <linux/slab.h>
+
+#include "vmci_common_int.h"
+#include "vmci_handle_array.h"
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * handle_arr_calc_size --
+ *
+ * Results:
+ *      Size in bytes of the handle array.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+static unsigned handle_arr_calc_size(uint32_t c) {
+	/* Decrement c b/c vmci_handle_arr includes one vmci_handle entry */
+	return sizeof (struct vmci_handle_arr) +
+		--c  * sizeof(struct vmci_handle);
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * vmci_handle_arr_create --
+ *
+ * Results:
+ *      Array if successful, NULL if not.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+struct vmci_handle_arr *vmci_handle_arr_create(uint32_t capacity)
+{
+	struct vmci_handle_arr *array;
+	uint32_t arr_size;
+
+	if (capacity == 0)
+		capacity = VMCI_HANDLE_ARRAY_DEFAULT_SIZE;
+
+	arr_size = handle_arr_calc_size(capacity);
+	array = kmalloc(arr_size, GFP_ATOMIC);
+	if (!array)
+		return NULL;
+
+	array->capacity = capacity;
+	array->size = 0;
+
+	return array;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * vmci_handle_arr_destroy --
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+void vmci_handle_arr_destroy(struct vmci_handle_arr *array)
+{
+	kfree(array);
+}
+
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * vmci_handle_arr_append_entry --
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      Array may be reallocated.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+void vmci_handle_arr_append_entry(struct vmci_handle_arr **arrayPtr,
+				  struct vmci_handle handle)
+{
+	struct vmci_handle_arr *array;
+
+	ASSERT(arrayPtr && *arrayPtr);
+	array = *arrayPtr;
+
+	if (unlikely(array->size >= array->capacity)) {
+		/* reallocate. */
+		struct vmci_handle_arr *newArray;
+		const uint32_t arraySize =
+			handle_arr_calc_size(array->capacity *
+					     VMCI_ARR_CAP_MULT);
+
+		newArray = kmalloc(arraySize, GFP_ATOMIC);
+		if (!newArray)
+			return;
+
+		memcpy(newArray, array, arraySize);
+		newArray->capacity *= VMCI_ARR_CAP_MULT;
+		kfree(array);
+		*arrayPtr = newArray;
+		array = newArray;
+	}
+
+	array->entries[array->size] = handle;
+	array->size++;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * vmci_handle_arr_remove_entry --
+ *
+ * Results:
+ *      Handle that was removed, VMCI_INVALID_HANDLE if entry not found.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+struct vmci_handle vmci_handle_arr_remove_entry(struct vmci_handle_arr *array,
+						struct vmci_handle entryHandle)
+{
+	uint32_t i;
+	struct vmci_handle handle = VMCI_INVALID_HANDLE;
+
+	ASSERT(array);
+	for (i = 0; i < array->size; i++) {
+		if (VMCI_HANDLE_EQUAL(array->entries[i], entryHandle)) {
+			handle = array->entries[i];
+			array->size--;
+			array->entries[i] = array->entries[array->size];
+			array->entries[array->size] = VMCI_INVALID_HANDLE;
+			break;
+		}
+	}
+
+	return handle;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * vmci_handle_arr_remove_tail --
+ *
+ * Results:
+ *      Handle that was removed, VMCI_INVALID_HANDLE if array was empty.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+struct vmci_handle vmci_handle_arr_remove_tail(struct vmci_handle_arr *array)
+{
+	struct vmci_handle handle = VMCI_INVALID_HANDLE;
+
+	if (array->size) {
+		array->size--;
+		handle = array->entries[array->size];
+		array->entries[array->size] = VMCI_INVALID_HANDLE;
+	}
+
+	return handle;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * vmci_handle_arr_get_entry --
+ *
+ * Results:
+ *      Handle at given index, VMCI_INVALID_HANDLE if invalid index.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+struct vmci_handle
+vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, uint32_t index)
+{
+	ASSERT(array);
+
+	if (unlikely(index >= array->size))
+		return VMCI_INVALID_HANDLE;
+
+	return array->entries[index];
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * vmci_handle_arr_get_size --
+ *
+ * Results:
+ *      Number of entries in array.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+uint32_t vmci_handle_arr_get_size(const struct vmci_handle_arr *array)
+{
+	ASSERT(array);
+	return array->size;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * vmci_handle_arr_has_entry --
+ *
+ * Results:
+ *      true is entry exists in array, false if not.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+bool
+vmci_handle_arr_has_entry(const struct vmci_handle_arr *array,
+			  struct vmci_handle entryHandle)
+{
+	uint32_t i;
+
+	ASSERT(array);
+	for (i = 0; i < array->size; i++)
+		if (VMCI_HANDLE_EQUAL(array->entries[i], entryHandle))
+			return true;
+
+	return false;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * vmci_handle_arr_get_handles --
+ *
+ * Results:
+ *      NULL if the array is empty. Otherwise, a pointer to the array
+ *      of VMCI handles in the handle array.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+struct vmci_handle *vmci_handle_arr_get_handles(struct vmci_handle_arr *array)	// IN
+{
+	ASSERT(array);
+
+	if (array->size)
+		return array->entries;
+
+	return NULL;
+}
+
diff --git a/drivers/misc/vmw_vmci/vmci_handle_array.h b/drivers/misc/vmw_vmci/vmci_handle_array.h
new file mode 100644
index 0000000..6d9e93e
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_handle_array.h
@@ -0,0 +1,50 @@
+/*
+ * VMware VMCI Driver
+ *
+ * Copyright (C) 2012 VMware, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation version 2 and no later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
+ */
+
+#ifndef _VMCI_HANDLE_ARRAY_H_
+#define _VMCI_HANDLE_ARRAY_H_
+
+#include <linux/slab.h>
+
+#include <linux/vmw_vmci_defs.h>
+
+#define VMCI_HANDLE_ARRAY_DEFAULT_SIZE 4
+#define VMCI_ARR_CAP_MULT 2	/* Array capacity multiplier */
+
+struct vmci_handle_arr {
+	uint32_t capacity;
+	uint32_t size;
+	struct vmci_handle entries[1];
+};
+
+struct vmci_handle_arr *vmci_handle_arr_create(uint32_t capacity);
+void vmci_handle_arr_destroy(struct vmci_handle_arr *array);
+void vmci_handle_arr_append_entry(struct vmci_handle_arr **arrayPtr,
+				  struct vmci_handle handle);
+struct vmci_handle vmci_handle_arr_remove_entry(struct vmci_handle_arr *array,
+						struct vmci_handle entryHandle);
+struct vmci_handle vmci_handle_arr_remove_tail(struct vmci_handle_arr *array);
+struct vmci_handle vmci_handle_arr_get_entry(const struct vmci_handle_arr *array,
+					     uint32_t index);
+uint32_t vmci_handle_arr_get_size(const struct vmci_handle_arr *array);
+bool vmci_handle_arr_has_entry(const struct vmci_handle_arr *array,
+			       struct vmci_handle entryHandle);
+struct vmci_handle *vmci_handle_arr_get_handles(struct vmci_handle_arr *array);
+
+#endif /* _VMCI_HANDLE_ARRAY_H_ */
-- 
1.7.0.4

