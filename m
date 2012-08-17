Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab2HQQRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:17:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45303 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758367Ab2HQQRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:17:24 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, David Airlie <airlied@linux.ie>,
        Andreas Heider <andreas@meetr.de>,
        Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Subject: [PATCH v2 2/3] vga_switcheroo: Remove assumptions about registration/unregistration ordering
Date: Fri, 17 Aug 2012 11:17:03 -0500
Message-Id: <1345220224-22872-3-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345220224-22872-1-git-send-email-seth.forshee@canonical.com>
References: <1345220224-22872-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vga_switcheroo assumes that the handler will be registered before the
last client, otherwise switching will not be enabled. Likewise it's
assumed that the handler will not be unregistered without at least one
client also being unregistered, otherwise switching will remain enabled
despite no longer having a handler. These assumptions cannot be enforced
if the handler is in a separate driver from both clients, as with the
gmux found in Apple laptops. Remove this assumption.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/vga/vga_switcheroo.c |   58 +++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index ec9069d..e25cf31 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -70,27 +70,12 @@ static struct vgasr_priv vgasr_priv = {
 	.clients = LIST_HEAD_INIT(vgasr_priv.clients),
 };
 
-int vga_switcheroo_register_handler(struct vga_switcheroo_handler *handler)
-{
-	mutex_lock(&vgasr_mutex);
-	if (vgasr_priv.handler) {
-		mutex_unlock(&vgasr_mutex);
-		return -EINVAL;
-	}
-
-	vgasr_priv.handler = handler;
-	mutex_unlock(&vgasr_mutex);
-	return 0;
-}
-EXPORT_SYMBOL(vga_switcheroo_register_handler);
-
-void vga_switcheroo_unregister_handler(void)
+static bool vga_switcheroo_ready(void)
 {
-	mutex_lock(&vgasr_mutex);
-	vgasr_priv.handler = NULL;
-	mutex_unlock(&vgasr_mutex);
+	/* we're ready if we get two clients + handler */
+	return !vgasr_priv.active &&
+	       vgasr_priv.registered_clients == 2 && vgasr_priv.handler;
 }
-EXPORT_SYMBOL(vga_switcheroo_unregister_handler);
 
 static void vga_switcheroo_enable(void)
 {
@@ -114,6 +99,37 @@ static void vga_switcheroo_enable(void)
 	vgasr_priv.active = true;
 }
 
+int vga_switcheroo_register_handler(struct vga_switcheroo_handler *handler)
+{
+	mutex_lock(&vgasr_mutex);
+	if (vgasr_priv.handler) {
+		mutex_unlock(&vgasr_mutex);
+		return -EINVAL;
+	}
+
+	vgasr_priv.handler = handler;
+	if (vga_switcheroo_ready()) {
+		printk(KERN_INFO "vga_switcheroo: enabled\n");
+		vga_switcheroo_enable();
+	}
+	mutex_unlock(&vgasr_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(vga_switcheroo_register_handler);
+
+void vga_switcheroo_unregister_handler(void)
+{
+	mutex_lock(&vgasr_mutex);
+	vgasr_priv.handler = NULL;
+	if (vgasr_priv.active) {
+		pr_info("vga_switcheroo: disabled\n");
+		vga_switcheroo_debugfs_fini(&vgasr_priv);
+		vgasr_priv.active = false;
+	}
+	mutex_unlock(&vgasr_mutex);
+}
+EXPORT_SYMBOL(vga_switcheroo_unregister_handler);
+
 static int register_client(struct pci_dev *pdev,
 			   const struct vga_switcheroo_client_ops *ops,
 			   int id, bool active)
@@ -135,9 +151,7 @@ static int register_client(struct pci_dev *pdev,
 	if (client_is_vga(client))
 		vgasr_priv.registered_clients++;
 
-	/* if we get two clients + handler */
-	if (!vgasr_priv.active &&
-	    vgasr_priv.registered_clients == 2 && vgasr_priv.handler) {
+	if (vga_switcheroo_ready()) {
 		printk(KERN_INFO "vga_switcheroo: enabled\n");
 		vga_switcheroo_enable();
 	}
-- 
1.7.9.5

