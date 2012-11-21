Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab2KUUdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:33:04 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:44726 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756359Ab2KUUdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:33:02 -0500
Subject: [PATCH 04/12] VMCI: device driver implementaton.
To: linux-kernel@vger.kernel.org, georgezhang@vmware.com,
        virtualization@lists.linux-foundation.org
From: George Zhang <georgezhang@vmware.com>
Cc: pv-drivers@vmware.com, gregkh@linuxfoundation.org
Date: Wed, 21 Nov 2012 12:33:02 -0800
Message-ID: <20121121203247.13252.40138.stgit@promb-2n-dhcp175.eng.vmware.com>
In-Reply-To: <20121121202625.13252.86346.stgit@promb-2n-dhcp175.eng.vmware.com>
References: <20121121202625.13252.86346.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMCI driver code implementes both the host and guest personalities of the VMCI driver.

Signed-off-by: George Zhang <georgezhang@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Andy King <acking@vmware.com>

---
 drivers/misc/vmw_vmci/vmci_driver.c |  117 +++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_driver.h |   50 +++++++++++++++
 2 files changed, 167 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_driver.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_driver.h

diff --git a/drivers/misc/vmw_vmci/vmci_driver.c b/drivers/misc/vmw_vmci/vmci_driver.c
new file mode 100644
index 0000000..c04c24c
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_driver.c
@@ -0,0 +1,117 @@
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
+#include <linux/vmw_vmci_defs.h>
+#include <linux/vmw_vmci_api.h>
+#include <linux/atomic.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+
+#include "vmci_driver.h"
+#include "vmci_event.h"
+
+static bool vmci_disable_host;
+module_param_named(disable_host, vmci_disable_host, bool, 0);
+MODULE_PARM_DESC(disable_host,
+		 "Disable driver host personality (default=enabled)");
+
+static bool vmci_disable_guest;
+module_param_named(disable_guest, vmci_disable_guest, bool, 0);
+MODULE_PARM_DESC(disable_guest,
+		 "Disable driver guest personality (default=enabled)");
+
+static bool vmci_guest_personality_initialized;
+static bool vmci_host_personality_initialized;
+
+/*
+ * vmci_get_context_id() - Gets the current context ID.
+ *
+ * Returns the current context ID.  Note that since this is accessed only
+ * from code running in the host, this always returns the host context ID.
+ */
+u32 vmci_get_context_id(void)
+{
+	if (vmci_guest_code_active())
+		return vmci_get_vm_context_id();
+	else if (vmci_host_code_active())
+		return VMCI_HOST_CONTEXT_ID;
+
+	return VMCI_INVALID_ID;
+}
+EXPORT_SYMBOL_GPL(vmci_get_context_id);
+
+static int __init vmci_drv_init(void)
+{
+	int vmci_err;
+	int error;
+
+	vmci_err = vmci_event_init();
+	if (vmci_err < VMCI_SUCCESS) {
+		pr_err("Failed to initialize VMCIEvent (result=%d).\n",
+			vmci_err);
+		return -EINVAL;
+	}
+
+	if (!vmci_disable_guest) {
+		error = vmci_guest_init();
+		if (error) {
+			pr_warn("Failed to initialize guest personality (err=%d).\n",
+				error);
+		} else {
+			vmci_guest_personality_initialized = true;
+			pr_info("Guest personality initialized and is %s\n",
+				vmci_guest_code_active() ?
+				"active" : "inactive");
+		}
+	}
+
+	if (!vmci_disable_host) {
+		error = vmci_host_init();
+		if (error) {
+			pr_warn("Unable to initialize host personality (err=%d).\n",
+				error);
+		} else {
+			vmci_host_personality_initialized = true;
+			pr_info("Initialized host personality\n");
+		}
+	}
+
+	if (!vmci_guest_personality_initialized &&
+	    !vmci_host_personality_initialized) {
+		vmci_event_exit();
+		return -ENODEV;
+	}
+
+	return 0;
+}
+module_init(vmci_drv_init);
+
+static void __exit vmci_drv_exit(void)
+{
+	if (vmci_guest_personality_initialized)
+		vmci_guest_exit();
+
+	if (vmci_host_personality_initialized)
+		vmci_host_exit();
+
+	vmci_event_exit();
+}
+module_exit(vmci_drv_exit);
+
+MODULE_AUTHOR("VMware, Inc.");
+MODULE_DESCRIPTION("VMware Virtual Machine Communication Interface.");
+MODULE_VERSION(VMCI_DRIVER_VERSION_STRING);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/misc/vmw_vmci/vmci_driver.h b/drivers/misc/vmw_vmci/vmci_driver.h
new file mode 100644
index 0000000..f69156a
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_driver.h
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
+ */
+
+#ifndef _VMCI_DRIVER_H_
+#define _VMCI_DRIVER_H_
+
+#include <linux/vmw_vmci_defs.h>
+#include <linux/wait.h>
+
+#include "vmci_queue_pair.h"
+#include "vmci_context.h"
+
+enum vmci_obj_type {
+	VMCIOBJ_VMX_VM = 10,
+	VMCIOBJ_CONTEXT,
+	VMCIOBJ_SOCKET,
+	VMCIOBJ_NOT_SET,
+};
+
+/* For storing VMCI structures in file handles. */
+struct vmci_obj {
+	void *ptr;
+	enum vmci_obj_type type;
+};
+
+u32 vmci_get_context_id(void);
+int vmci_send_datagram(struct vmci_datagram *dg);
+
+int vmci_host_init(void);
+void vmci_host_exit(void);
+bool vmci_host_code_active(void);
+
+int vmci_guest_init(void);
+void vmci_guest_exit(void);
+bool vmci_guest_code_active(void);
+u32 vmci_get_vm_context_id(void);
+
+#endif /* _VMCI_DRIVER_H_ */

