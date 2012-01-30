Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2A3XMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:12:51 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:49114 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab2A3XMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:12:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAB4jJ09bdWOb/2dsb2JhbABDhQuqUYFzAQUjBAsBIyMQJQIYDgICOQMbBgESh3+nBpFdgS+JUAEFAgICCAEBBA0EBgELCQgUg0peFYJCgRYElRqFVox8
X-IronPort-AV: E=Sophos;i="4.71,592,1320620400"; 
   d="scan'208";a="945795214"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2 2/8] staging: tidspbridge: remove unused header
Date: Tue, 31 Jan 2012 00:12:18 +0100
Message-Id: <0015295b5c3789dbe01f4840700e46095f1354cc.1327964066.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <cover.1327964066.git.vjaquez@igalia.com>
References: <cover.1327964066.git.vjaquez@igalia.com>
In-Reply-To: <cover.1327964066.git.vjaquez@igalia.com>
References: <cover.1327964066.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

The header file drv_interface.h was only used locally, hence there's no need
to have it.

Also the only prototyped functions were the file_operations callbacks, then
this commit moves them up to avoid prototyping too.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 drivers/staging/tidspbridge/rmgr/drv_interface.c |  313 +++++++++++-----------
 drivers/staging/tidspbridge/rmgr/drv_interface.h |   28 --
 2 files changed, 155 insertions(+), 186 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/rmgr/drv_interface.h

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 85f6e8e..5ea753c 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -48,9 +48,6 @@
 /*  ----------------------------------- Resource Manager */
 #include <dspbridge/pwr.h>
 
-/*  ----------------------------------- This */
-#include <drv_interface.h>
-
 #include <dspbridge/resourcecleanup.h>
 #include <dspbridge/chnl.h>
 #include <dspbridge/proc.h>
@@ -133,6 +130,161 @@ MODULE_VERSION(DSPBRIDGE_VERSION);
 
 static char *driver_name = DRIVER_NAME;
 
+/*
+ * This function is called when an application opens handle to the
+ * bridge driver.
+ */
+static int bridge_open(struct inode *ip, struct file *filp)
+{
+	int status = 0;
+	struct process_context *pr_ctxt = NULL;
+
+	/*
+	 * Allocate a new process context and insert it into global
+	 * process context list.
+	 */
+
+#ifdef CONFIG_TIDSPBRIDGE_RECOVERY
+	if (recover) {
+		if (filp->f_flags & O_NONBLOCK ||
+			wait_for_completion_interruptible(&bridge_open_comp))
+			return -EBUSY;
+	}
+#endif
+	pr_ctxt = kzalloc(sizeof(struct process_context), GFP_KERNEL);
+	if (pr_ctxt) {
+		pr_ctxt->res_state = PROC_RES_ALLOCATED;
+		spin_lock_init(&pr_ctxt->dmm_map_lock);
+		INIT_LIST_HEAD(&pr_ctxt->dmm_map_list);
+		spin_lock_init(&pr_ctxt->dmm_rsv_lock);
+		INIT_LIST_HEAD(&pr_ctxt->dmm_rsv_list);
+
+		pr_ctxt->node_id = kzalloc(sizeof(struct idr), GFP_KERNEL);
+		if (pr_ctxt->node_id) {
+			idr_init(pr_ctxt->node_id);
+		} else {
+			status = -ENOMEM;
+			goto err;
+		}
+
+		pr_ctxt->stream_id = kzalloc(sizeof(struct idr), GFP_KERNEL);
+		if (pr_ctxt->stream_id)
+			idr_init(pr_ctxt->stream_id);
+		else
+			status = -ENOMEM;
+	} else {
+		status = -ENOMEM;
+	}
+err:
+	filp->private_data = pr_ctxt;
+#ifdef CONFIG_TIDSPBRIDGE_RECOVERY
+	if (!status)
+		atomic_inc(&bridge_cref);
+#endif
+	return status;
+}
+
+/*
+ * This function is called when an application closes handle to the bridge
+ * driver.
+ */
+static int bridge_release(struct inode *ip, struct file *filp)
+{
+	int status = 0;
+	struct process_context *pr_ctxt;
+
+	if (!filp->private_data) {
+		status = -EIO;
+		goto err;
+	}
+
+	pr_ctxt = filp->private_data;
+	flush_signals(current);
+	drv_remove_all_resources(pr_ctxt);
+	proc_detach(pr_ctxt);
+	kfree(pr_ctxt);
+
+	filp->private_data = NULL;
+
+err:
+#ifdef CONFIG_TIDSPBRIDGE_RECOVERY
+	if (!atomic_dec_return(&bridge_cref))
+		complete(&bridge_comp);
+#endif
+	return status;
+}
+
+/* This function provides IO interface to the bridge driver. */
+static long bridge_ioctl(struct file *filp, unsigned int code,
+			 unsigned long args)
+{
+	int status;
+	u32 retval = 0;
+	union trapped_args buf_in;
+
+	DBC_REQUIRE(filp != NULL);
+#ifdef CONFIG_TIDSPBRIDGE_RECOVERY
+	if (recover) {
+		status = -EIO;
+		goto err;
+	}
+#endif
+#ifdef CONFIG_PM
+	status = omap34_xxbridge_suspend_lockout(&bridge_suspend_data, filp);
+	if (status != 0)
+		return status;
+#endif
+
+	if (!filp->private_data) {
+		status = -EIO;
+		goto err;
+	}
+
+	status = copy_from_user(&buf_in, (union trapped_args *)args,
+				sizeof(union trapped_args));
+
+	if (!status) {
+		status = api_call_dev_ioctl(code, &buf_in, &retval,
+					     filp->private_data);
+
+		if (!status) {
+			status = retval;
+		} else {
+			dev_dbg(bridge, "%s: IOCTL Failed, code: 0x%x "
+				"status 0x%x\n", __func__, code, status);
+			status = -1;
+		}
+
+	}
+
+err:
+	return status;
+}
+
+/* This function maps kernel space memory to user space memory. */
+static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	u32 offset = vma->vm_pgoff << PAGE_SHIFT;
+	u32 status;
+
+	DBC_ASSERT(vma->vm_start < vma->vm_end);
+
+	vma->vm_flags |= VM_RESERVED | VM_IO;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	dev_dbg(bridge, "%s: vm filp %p offset %x start %lx end %lx page_prot "
+		"%lx flags %lx\n", __func__, filp, offset,
+		vma->vm_start, vma->vm_end, vma->vm_page_prot, vma->vm_flags);
+
+	status = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+				 vma->vm_end - vma->vm_start,
+				 vma->vm_page_prot);
+	if (status != 0)
+		status = -EAGAIN;
+
+	return status;
+}
+
 static const struct file_operations bridge_fops = {
 	.open = bridge_open,
 	.release = bridge_release,
@@ -477,161 +629,6 @@ static void __exit bridge_exit(void)
 	platform_driver_unregister(&bridge_driver);
 }
 
-/*
- * This function is called when an application opens handle to the
- * bridge driver.
- */
-static int bridge_open(struct inode *ip, struct file *filp)
-{
-	int status = 0;
-	struct process_context *pr_ctxt = NULL;
-
-	/*
-	 * Allocate a new process context and insert it into global
-	 * process context list.
-	 */
-
-#ifdef CONFIG_TIDSPBRIDGE_RECOVERY
-	if (recover) {
-		if (filp->f_flags & O_NONBLOCK ||
-			wait_for_completion_interruptible(&bridge_open_comp))
-			return -EBUSY;
-	}
-#endif
-	pr_ctxt = kzalloc(sizeof(struct process_context), GFP_KERNEL);
-	if (pr_ctxt) {
-		pr_ctxt->res_state = PROC_RES_ALLOCATED;
-		spin_lock_init(&pr_ctxt->dmm_map_lock);
-		INIT_LIST_HEAD(&pr_ctxt->dmm_map_list);
-		spin_lock_init(&pr_ctxt->dmm_rsv_lock);
-		INIT_LIST_HEAD(&pr_ctxt->dmm_rsv_list);
-
-		pr_ctxt->node_id = kzalloc(sizeof(struct idr), GFP_KERNEL);
-		if (pr_ctxt->node_id) {
-			idr_init(pr_ctxt->node_id);
-		} else {
-			status = -ENOMEM;
-			goto err;
-		}
-
-		pr_ctxt->stream_id = kzalloc(sizeof(struct idr), GFP_KERNEL);
-		if (pr_ctxt->stream_id)
-			idr_init(pr_ctxt->stream_id);
-		else
-			status = -ENOMEM;
-	} else {
-		status = -ENOMEM;
-	}
-err:
-	filp->private_data = pr_ctxt;
-#ifdef CONFIG_TIDSPBRIDGE_RECOVERY
-	if (!status)
-		atomic_inc(&bridge_cref);
-#endif
-	return status;
-}
-
-/*
- * This function is called when an application closes handle to the bridge
- * driver.
- */
-static int bridge_release(struct inode *ip, struct file *filp)
-{
-	int status = 0;
-	struct process_context *pr_ctxt;
-
-	if (!filp->private_data) {
-		status = -EIO;
-		goto err;
-	}
-
-	pr_ctxt = filp->private_data;
-	flush_signals(current);
-	drv_remove_all_resources(pr_ctxt);
-	proc_detach(pr_ctxt);
-	kfree(pr_ctxt);
-
-	filp->private_data = NULL;
-
-err:
-#ifdef CONFIG_TIDSPBRIDGE_RECOVERY
-	if (!atomic_dec_return(&bridge_cref))
-		complete(&bridge_comp);
-#endif
-	return status;
-}
-
-/* This function provides IO interface to the bridge driver. */
-static long bridge_ioctl(struct file *filp, unsigned int code,
-			 unsigned long args)
-{
-	int status;
-	u32 retval = 0;
-	union trapped_args buf_in;
-
-	DBC_REQUIRE(filp != NULL);
-#ifdef CONFIG_TIDSPBRIDGE_RECOVERY
-	if (recover) {
-		status = -EIO;
-		goto err;
-	}
-#endif
-#ifdef CONFIG_PM
-	status = omap34_xxbridge_suspend_lockout(&bridge_suspend_data, filp);
-	if (status != 0)
-		return status;
-#endif
-
-	if (!filp->private_data) {
-		status = -EIO;
-		goto err;
-	}
-
-	status = copy_from_user(&buf_in, (union trapped_args *)args,
-				sizeof(union trapped_args));
-
-	if (!status) {
-		status = api_call_dev_ioctl(code, &buf_in, &retval,
-					     filp->private_data);
-
-		if (!status) {
-			status = retval;
-		} else {
-			dev_dbg(bridge, "%s: IOCTL Failed, code: 0x%x "
-				"status 0x%x\n", __func__, code, status);
-			status = -1;
-		}
-
-	}
-
-err:
-	return status;
-}
-
-/* This function maps kernel space memory to user space memory. */
-static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	u32 offset = vma->vm_pgoff << PAGE_SHIFT;
-	u32 status;
-
-	DBC_ASSERT(vma->vm_start < vma->vm_end);
-
-	vma->vm_flags |= VM_RESERVED | VM_IO;
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-
-	dev_dbg(bridge, "%s: vm filp %p offset %x start %lx end %lx page_prot "
-		"%lx flags %lx\n", __func__, filp, offset,
-		vma->vm_start, vma->vm_end, vma->vm_page_prot, vma->vm_flags);
-
-	status = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-				 vma->vm_end - vma->vm_start,
-				 vma->vm_page_prot);
-	if (status != 0)
-		status = -EAGAIN;
-
-	return status;
-}
-
 /* To remove all process resources before removing the process from the
  * process context list */
 int drv_remove_all_resources(void *process_ctxt)
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.h b/drivers/staging/tidspbridge/rmgr/drv_interface.h
deleted file mode 100644
index ab07060..0000000
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * drv_interface.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Copyright (C) 2005-2006 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef	_DRV_INTERFACE_H_
-#define _DRV_INTERFACE_H_
-
-/* Prototypes for all functions in this bridge */
-static int __init bridge_init(void);	/* Initialize bridge */
-static void __exit bridge_exit(void);	/* Opposite of initialize */
-static int bridge_open(struct inode *ip, struct file *filp);	/* Open */
-static int bridge_release(struct inode *ip, struct file *filp);	/* Release */
-static long bridge_ioctl(struct file *filp, unsigned int code,
-				unsigned long args);
-static int bridge_mmap(struct file *filp, struct vm_area_struct *vma);
-#endif /* ifndef _DRV_INTERFACE_H_ */
-- 
1.7.8.3

