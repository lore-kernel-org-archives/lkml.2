Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab2JPA3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:29:20 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:39461 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754940Ab2JPA3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:29:13 -0400
Subject: [PATCH 06/10] VMCI: handle array implementation.
To: linux-kernel@vger.kernel.org, georgezhang@vmware.com,
        virtualization@lists.linux-foundation.org
From: George Zhang <georgezhang@vmware.com>
Cc: pv-drivers@vmware.com, vm-crosstalk@vmware.com, gregkh@linuxfoundation.org
Date: Mon, 15 Oct 2012 17:29:13 -0700
Message-ID: <20121016002904.26205.35108.stgit@promb-2n-dhcp175.eng.vmware.com>
In-Reply-To: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
References: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMCI handle code adds support for dynamic arrays that will grow if they need to.


Signed-off-by: George Zhang <georgezhang@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_handle_array.c |  162 +++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_handle_array.h |   46 ++++++++
 2 files changed, 208 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_handle_array.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_handle_array.h

diff --git a/drivers/misc/vmw_vmci/vmci_handle_array.c b/drivers/misc/vmw_vmci/vmci_handle_array.c
new file mode 100644
index 0000000..c7db831
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_handle_array.c
@@ -0,0 +1,162 @@
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
+ */
+
+#include <linux/slab.h>
+#include "vmci_handle_array.h"
+
+static size_t handle_arr_calc_size(size_t capacity)
+{
+	return sizeof(struct vmci_handle_arr) +
+	    capacity * sizeof(struct vmci_handle);
+}
+
+struct vmci_handle_arr *vmci_handle_arr_create(size_t capacity)
+{
+	struct vmci_handle_arr *array;
+
+	if (capacity == 0)
+		capacity = VMCI_HANDLE_ARRAY_DEFAULT_SIZE;
+
+	array = kmalloc(handle_arr_calc_size(capacity), GFP_ATOMIC);
+	if (!array)
+		return NULL;
+
+	array->capacity = capacity;
+	array->size = 0;
+
+	return array;
+}
+
+void vmci_handle_arr_destroy(struct vmci_handle_arr *array)
+{
+	kfree(array);
+}
+
+void vmci_handle_arr_append_entry(struct vmci_handle_arr **array_ptr,
+				  struct vmci_handle handle)
+{
+	struct vmci_handle_arr *array;
+
+	BUG_ON(!array_ptr || !*array_ptr);
+	array = *array_ptr;
+
+	if (unlikely(array->size >= array->capacity)) {
+		/* reallocate. */
+		struct vmci_handle_arr *new_array;
+		size_t new_capacity = array->capacity * VMCI_ARR_CAP_MULT;
+		size_t new_size = handle_arr_calc_size(new_capacity);
+
+		new_array = krealloc(array, new_size, GFP_ATOMIC);
+		if (!new_array)
+			return;
+
+		new_array->capacity = new_capacity;
+		*array_ptr = array = new_array;
+	}
+
+	array->entries[array->size] = handle;
+	array->size++;
+}
+
+/*
+ * Handle that was removed, VMCI_INVALID_HANDLE if entry not found.
+ */
+struct vmci_handle vmci_handle_arr_remove_entry(struct vmci_handle_arr *array,
+						struct vmci_handle entry_handle)
+{
+	struct vmci_handle handle = VMCI_INVALID_HANDLE;
+	size_t i;
+
+	BUG_ON(!array);
+
+	for (i = 0; i < array->size; i++) {
+		if (VMCI_HANDLE_EQUAL(array->entries[i], entry_handle)) {
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
+ * Handle that was removed, VMCI_INVALID_HANDLE if array was empty.
+ */
+struct vmci_handle vmci_handle_arr_remove_tail(struct vmci_handle_arr *array)
+{
+	struct vmci_handle handle = VMCI_INVALID_HANDLE;
+
+	BUG_ON(!array);
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
+ * Handle at given index, VMCI_INVALID_HANDLE if invalid index.
+ */
+struct vmci_handle
+vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, size_t index)
+{
+	BUG_ON(!array);
+
+	if (unlikely(index >= array->size))
+		return VMCI_INVALID_HANDLE;
+
+	return array->entries[index];
+}
+
+size_t vmci_handle_arr_get_size(const struct vmci_handle_arr *array)
+{
+	BUG_ON(!array);
+
+	return array->size;
+}
+
+bool vmci_handle_arr_has_entry(const struct vmci_handle_arr *array,
+			       struct vmci_handle entry_handle)
+{
+	size_t i;
+
+	BUG_ON(!array);
+
+	for (i = 0; i < array->size; i++)
+		if (VMCI_HANDLE_EQUAL(array->entries[i], entry_handle))
+			return true;
+
+	return false;
+}
+
+/*
+ * NULL if the array is empty. Otherwise, a pointer to the array
+ * of VMCI handles in the handle array.
+ */
+struct vmci_handle *vmci_handle_arr_get_handles(struct vmci_handle_arr *array)
+{
+	BUG_ON(!array);
+
+	if (array->size)
+		return array->entries;
+
+	return NULL;
+}
diff --git a/drivers/misc/vmw_vmci/vmci_handle_array.h b/drivers/misc/vmw_vmci/vmci_handle_array.h
new file mode 100644
index 0000000..37d1214
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_handle_array.h
@@ -0,0 +1,46 @@
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
+ */
+
+#ifndef _VMCI_HANDLE_ARRAY_H_
+#define _VMCI_HANDLE_ARRAY_H_
+
+#include <linux/vmw_vmci_defs.h>
+#include <linux/types.h>
+
+#define VMCI_HANDLE_ARRAY_DEFAULT_SIZE 4
+#define VMCI_ARR_CAP_MULT 2	/* Array capacity multiplier */
+
+struct vmci_handle_arr {
+	size_t capacity;
+	size_t size;
+	struct vmci_handle entries[];
+};
+
+struct vmci_handle_arr *vmci_handle_arr_create(size_t capacity);
+void vmci_handle_arr_destroy(struct vmci_handle_arr *array);
+void vmci_handle_arr_append_entry(struct vmci_handle_arr **array_ptr,
+				  struct vmci_handle handle);
+struct vmci_handle vmci_handle_arr_remove_entry(struct vmci_handle_arr *array,
+						struct vmci_handle
+						entry_handle);
+struct vmci_handle vmci_handle_arr_remove_tail(struct vmci_handle_arr *array);
+struct vmci_handle
+vmci_handle_arr_get_entry(const struct vmci_handle_arr *array, size_t index);
+size_t vmci_handle_arr_get_size(const struct vmci_handle_arr *array);
+bool vmci_handle_arr_has_entry(const struct vmci_handle_arr *array,
+			       struct vmci_handle entry_handle);
+struct vmci_handle *vmci_handle_arr_get_handles(struct vmci_handle_arr *array);
+
+#endif /* _VMCI_HANDLE_ARRAY_H_ */

