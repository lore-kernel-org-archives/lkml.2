Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2HQQSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:18:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45291 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab2HQQRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:17:21 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, David Airlie <airlied@linux.ie>,
        Andreas Heider <andreas@meetr.de>,
        Bernhard Froemel <froemel@vmars.tuwien.ac.at>
Subject: [PATCH v2 1/3] vga_switcheroo: Don't require handler init callback
Date: Fri, 17 Aug 2012 11:17:02 -0500
Message-Id: <1345220224-22872-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345220224-22872-1-git-send-email-seth.forshee@canonical.com>
References: <1345220224-22872-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This callback is a no-op in nouveau, and the upcoming apple-gmux
switcheroo support won't require it either. Rather than forcing drivers
to stub it out, just make it optional and remove the callback from
nouveau.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_acpi.c |    6 ------
 drivers/gpu/vga/vga_switcheroo.c       |    3 ++-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index fc841e8..26ebffe 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -211,11 +211,6 @@ static int nouveau_dsm_power_state(enum vga_switcheroo_client_id id,
 	return nouveau_dsm_set_discrete_state(nouveau_dsm_priv.dhandle, state);
 }
 
-static int nouveau_dsm_init(void)
-{
-	return 0;
-}
-
 static int nouveau_dsm_get_client_id(struct pci_dev *pdev)
 {
 	/* easy option one - intel vendor ID means Integrated */
@@ -232,7 +227,6 @@ static int nouveau_dsm_get_client_id(struct pci_dev *pdev)
 static struct vga_switcheroo_handler nouveau_dsm_handler = {
 	.switchto = nouveau_dsm_switchto,
 	.power_state = nouveau_dsm_power_state,
-	.init = nouveau_dsm_init,
 	.get_client_id = nouveau_dsm_get_client_id,
 };
 
diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index 5b3c7d1..ec9069d 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -98,7 +98,8 @@ static void vga_switcheroo_enable(void)
 	struct vga_switcheroo_client *client;
 
 	/* call the handler to init */
-	vgasr_priv.handler->init();
+	if (vgasr_priv.handler->init)
+		vgasr_priv.handler->init();
 
 	list_for_each_entry(client, &vgasr_priv.clients, list) {
 		if (client->id != -1)
-- 
1.7.9.5

