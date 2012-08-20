Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab2HTPbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:31:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53956 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab2HTPbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:31:15 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <mjg59@srcf.ucam.org>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andreas Heider <andreas@meetr.de>
Subject: [RFC PATCH 2/7] vga_switcheroo: Add helper function to get the active client
Date: Mon, 20 Aug 2012 10:30:59 -0500
Message-Id: <1345476664-22066-3-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
References: <20120806045150.GA23652@thinkpad-t410>
 <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add vga_switcheroo_get_active_client() to allow drivers to get the
active video client. This will be used by drivers wishing to temporarily
mux only the DDC to the inactive client.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/vga/vga_switcheroo.c |   14 ++++++++++++++
 include/linux/vga_switcheroo.h   |    2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index ea6bcc2..e53f67d 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -205,6 +205,20 @@ find_active_client(struct list_head *head)
 	return NULL;
 }
 
+struct pci_dev *vga_switcheroo_get_active_client(void)
+{
+	struct vga_switcheroo_client *client;
+	struct pci_dev *pdev = NULL;
+
+	mutex_lock(&vgasr_mutex);
+	client = find_active_client(&vgasr_priv.clients);
+	if (client)
+		pdev = client->pdev;
+	mutex_unlock(&vgasr_mutex);
+	return pdev;
+}
+EXPORT_SYMBOL(vga_switcheroo_get_active_client);
+
 int vga_switcheroo_get_client_state(struct pci_dev *pdev)
 {
 	struct vga_switcheroo_client *client;
diff --git a/include/linux/vga_switcheroo.h b/include/linux/vga_switcheroo.h
index b0d0839..e361858 100644
--- a/include/linux/vga_switcheroo.h
+++ b/include/linux/vga_switcheroo.h
@@ -61,6 +61,7 @@ void vga_switcheroo_unregister_handler(void);
 
 int vga_switcheroo_process_delayed_switch(void);
 
+struct pci_dev *vga_switcheroo_get_active_client(void);
 int vga_switcheroo_get_client_state(struct pci_dev *dev);
 
 #else
@@ -76,6 +77,7 @@ static inline int vga_switcheroo_register_audio_client(struct pci_dev *pdev,
 	int id, bool active) { return 0; }
 static inline void vga_switcheroo_unregister_handler(void) {}
 static inline int vga_switcheroo_process_delayed_switch(void) { return 0; }
+static inline struct pci_dev *vga_switcheroo_get_active_client(void) { return NULL; }
 static inline int vga_switcheroo_get_client_state(struct pci_dev *dev) { return VGA_SWITCHEROO_ON; }
 
 
-- 
1.7.9.5

