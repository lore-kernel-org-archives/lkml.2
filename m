Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab2HTPbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:31:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53963 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab2HTPbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:31:18 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <mjg59@srcf.ucam.org>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andreas Heider <andreas@meetr.de>
Subject: [RFC PATCH 3/7] vga_switcheroo: Add notifier call chain for switcheroo events
Date: Mon, 20 Aug 2012 10:31:00 -0500
Message-Id: <1345476664-22066-4-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
References: <20120806045150.GA23652@thinkpad-t410>
 <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRM needs to be notified of client and handler registration in order to
defer initialization of the secondary GPU until the EDID can be read
from the LVDS panel. To support this add a notifier call chain to
vga_switcheroo for subscribing to switcheroo events. Events are
generated for registration and unregistration of handlers and clients.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/vga/vga_switcheroo.c |   34 ++++++++++++++++++++++++++++++++++
 include/linux/vga_switcheroo.h   |   14 ++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index e53f67d..d5cd274 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -24,6 +24,7 @@
 #include <linux/fs.h>
 #include <linux/debugfs.h>
 #include <linux/fb.h>
+#include <linux/notifier.h>
 
 #include <linux/pci.h>
 #include <linux/vga_switcheroo.h>
@@ -70,6 +71,28 @@ static struct vgasr_priv vgasr_priv = {
 	.clients = LIST_HEAD_INIT(vgasr_priv.clients),
 };
 
+static BLOCKING_NOTIFIER_HEAD(vga_switcheroo_notifier_list);
+
+int vga_switcheroo_register_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&vga_switcheroo_notifier_list,
+						nb);
+}
+EXPORT_SYMBOL(vga_switcheroo_register_notifier);
+
+int vga_switcheroo_unregister_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&vga_switcheroo_notifier_list,
+						  nb);
+}
+EXPORT_SYMBOL(vga_switcheroo_unregister_notifier);
+
+static int vga_switcheroo_notifier_call_chain(enum vga_switcheroo_event event)
+{
+	return blocking_notifier_call_chain(&vga_switcheroo_notifier_list,
+					    event, NULL);
+}
+
 static bool vga_switcheroo_ready(void)
 {
 	/* we're ready if we get two clients + handler */
@@ -113,10 +136,18 @@ int vga_switcheroo_register_handler(struct vga_switcheroo_handler *handler)
 		vga_switcheroo_enable();
 	}
 	mutex_unlock(&vgasr_mutex);
+
+	vga_switcheroo_notifier_call_chain(VGA_SWITCHEROO_HANDLER_REGISTERED);
 	return 0;
 }
 EXPORT_SYMBOL(vga_switcheroo_register_handler);
 
+bool vga_switcheroo_handler_registered(void)
+{
+	return !!vgasr_priv.handler;
+}
+EXPORT_SYMBOL(vga_switcheroo_handler_registered);
+
 void vga_switcheroo_unregister_handler(void)
 {
 	mutex_lock(&vgasr_mutex);
@@ -127,6 +158,7 @@ void vga_switcheroo_unregister_handler(void)
 		vgasr_priv.active = false;
 	}
 	mutex_unlock(&vgasr_mutex);
+	vga_switcheroo_notifier_call_chain(VGA_SWITCHEROO_HANDLER_UNREGISTERED);
 }
 EXPORT_SYMBOL(vga_switcheroo_unregister_handler);
 
@@ -156,6 +188,7 @@ static int register_client(struct pci_dev *pdev,
 		vga_switcheroo_enable();
 	}
 	mutex_unlock(&vgasr_mutex);
+	vga_switcheroo_notifier_call_chain(VGA_SWITCHEROO_CLIENT_REGISTERED);
 	return 0;
 }
 
@@ -250,6 +283,7 @@ void vga_switcheroo_unregister_client(struct pci_dev *pdev)
 		vgasr_priv.active = false;
 	}
 	mutex_unlock(&vgasr_mutex);
+	vga_switcheroo_notifier_call_chain(VGA_SWITCHEROO_CLIENT_UNREGISTERED);
 }
 EXPORT_SYMBOL(vga_switcheroo_unregister_client);
 
diff --git a/include/linux/vga_switcheroo.h b/include/linux/vga_switcheroo.h
index e361858..c3d7c6f 100644
--- a/include/linux/vga_switcheroo.h
+++ b/include/linux/vga_switcheroo.h
@@ -11,6 +11,7 @@
 #define _LINUX_VGA_SWITCHEROO_H_
 
 #include <linux/fb.h>
+#include <linux/notifier.h>
 
 struct pci_dev;
 
@@ -28,6 +29,13 @@ enum vga_switcheroo_client_id {
 	VGA_SWITCHEROO_MAX_CLIENTS,
 };
 
+enum vga_switcheroo_event {
+	VGA_SWITCHEROO_CLIENT_REGISTERED,
+	VGA_SWITCHEROO_CLIENT_UNREGISTERED,
+	VGA_SWITCHEROO_HANDLER_REGISTERED,
+	VGA_SWITCHEROO_HANDLER_UNREGISTERED,
+};
+
 struct vga_switcheroo_handler {
 	int (*switch_ddc)(enum vga_switcheroo_client_id id);
 	int (*switchto)(enum vga_switcheroo_client_id id);
@@ -44,6 +52,9 @@ struct vga_switcheroo_client_ops {
 };
 
 #if defined(CONFIG_VGA_SWITCHEROO)
+int vga_switcheroo_register_notifier(struct notifier_block *nb);
+int vga_switcheroo_unregister_notifier(struct notifier_block *nb);
+bool vga_switcheroo_handler_registered(void);
 void vga_switcheroo_unregister_client(struct pci_dev *dev);
 int vga_switcheroo_register_client(struct pci_dev *dev,
 				   const struct vga_switcheroo_client_ops *ops);
@@ -66,6 +77,9 @@ int vga_switcheroo_get_client_state(struct pci_dev *dev);
 
 #else
 
+static inline int vga_switcheroo_register_notifier(struct notifier_block *nb) { return 0; }
+static inline int vga_switcheroo_unregister_notifier(struct notifier_block *nb) { return 0; }
+static inline bool vga_switcheroo_handler_registered(void) { return false; }
 static inline void vga_switcheroo_unregister_client(struct pci_dev *dev) {}
 static inline int vga_switcheroo_register_client(struct pci_dev *dev,
 		const struct vga_switcheroo_client_ops *ops) { return 0; }
-- 
1.7.9.5

