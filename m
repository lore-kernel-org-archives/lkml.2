Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2IGPW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:22:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50021 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2IGPWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:22:20 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 1/7] vga_switcheroo: Add support for switching only the DDC
Date: Fri,  7 Sep 2012 10:22:04 -0500
Message-Id: <1347031330-19657-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347031330-19657-1-git-send-email-seth.forshee@canonical.com>
References: <1347031330-19657-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During graphics driver initialization its useful to be able to mux only
the DDC to the inactive client in order to read the EDID. Add a
switch_ddc callback to allow capable handlers to provide this
functionality, and add vga_switcheroo_switch_ddc() to allow DRM to mux
only the DDC.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/vga/vga_switcheroo.c |   39 +++++++++++++++++++++++++++++++++++++-
 include/linux/vga_switcheroo.h   |    4 ++++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index e25cf31..ea6bcc2 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -252,6 +252,29 @@ void vga_switcheroo_client_fb_set(struct pci_dev *pdev,
 }
 EXPORT_SYMBOL(vga_switcheroo_client_fb_set);
 
+int vga_switcheroo_switch_ddc(struct pci_dev *pdev)
+{
+	int ret = 0;
+	int id;
+
+	mutex_lock(&vgasr_mutex);
+
+	if (!vgasr_priv.handler) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (vgasr_priv.handler->switch_ddc) {
+		id = vgasr_priv.handler->get_client_id(pdev);
+		ret = vgasr_priv.handler->switch_ddc(id);
+	}
+
+out:
+	mutex_unlock(&vgasr_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(vga_switcheroo_switch_ddc);
+
 static int vga_switcheroo_show(struct seq_file *m, void *v)
 {
 	struct vga_switcheroo_client *client;
@@ -342,9 +365,15 @@ static int vga_switchto_stage2(struct vga_switcheroo_client *new_client)
 		fb_notifier_call_chain(FB_EVENT_REMAP_ALL_CONSOLE, &event);
 	}
 
+	if (vgasr_priv.handler->switch_ddc) {
+		ret = vgasr_priv.handler->switch_ddc(new_client->id);
+		if (ret)
+			return ret;
+	}
+
 	ret = vgasr_priv.handler->switchto(new_client->id);
 	if (ret)
-		return ret;
+		goto restore_ddc;
 
 	if (new_client->ops->reprobe)
 		new_client->ops->reprobe(new_client->pdev);
@@ -356,6 +385,14 @@ static int vga_switchto_stage2(struct vga_switcheroo_client *new_client)
 
 	new_client->active = true;
 	return 0;
+
+restore_ddc:
+	if (vgasr_priv.handler->switch_ddc) {
+		int id = (new_client->id == VGA_SWITCHEROO_IGD) ?
+				VGA_SWITCHEROO_DIS : VGA_SWITCHEROO_IGD;
+		ret = vgasr_priv.handler->switch_ddc(id);
+	}
+	return ret;
 }
 
 static bool check_can_switch(void)
diff --git a/include/linux/vga_switcheroo.h b/include/linux/vga_switcheroo.h
index ddb419c..b0d0839 100644
--- a/include/linux/vga_switcheroo.h
+++ b/include/linux/vga_switcheroo.h
@@ -29,6 +29,7 @@ enum vga_switcheroo_client_id {
 };
 
 struct vga_switcheroo_handler {
+	int (*switch_ddc)(enum vga_switcheroo_client_id id);
 	int (*switchto)(enum vga_switcheroo_client_id id);
 	int (*power_state)(enum vga_switcheroo_client_id id,
 			   enum vga_switcheroo_state state);
@@ -53,6 +54,8 @@ int vga_switcheroo_register_audio_client(struct pci_dev *pdev,
 void vga_switcheroo_client_fb_set(struct pci_dev *dev,
 				  struct fb_info *info);
 
+int vga_switcheroo_switch_ddc(struct pci_dev *pdev);
+
 int vga_switcheroo_register_handler(struct vga_switcheroo_handler *handler);
 void vga_switcheroo_unregister_handler(void);
 
@@ -66,6 +69,7 @@ static inline void vga_switcheroo_unregister_client(struct pci_dev *dev) {}
 static inline int vga_switcheroo_register_client(struct pci_dev *dev,
 		const struct vga_switcheroo_client_ops *ops) { return 0; }
 static inline void vga_switcheroo_client_fb_set(struct pci_dev *dev, struct fb_info *info) {}
+static inline void vga_switcheroo_switch_ddc(struct pci_dev *pdev) { return NULL; }
 static inline int vga_switcheroo_register_handler(struct vga_switcheroo_handler *handler) { return 0; }
 static inline int vga_switcheroo_register_audio_client(struct pci_dev *pdev,
 	const struct vga_switcheroo_client_ops *ops,
-- 
1.7.9.5

