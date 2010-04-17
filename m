Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab0DQTiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:38:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:47327 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754749Ab0DQThH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:37:07 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/u3YEk9DPu5QheHXWSzpaoWSikAyj/j2d1f/Xv10
	iaWEOMFl7HjwPC
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, corbet@lwn.net,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 6/7] viafb: fix proc entry removal
Date: Sat, 17 Apr 2010 19:44:56 +0000
Message-Id: <1271533498-3376-6-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1271533498-3376-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1271533498-3376-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: fix proc entry removal

Trying to remove unregistered proc entries became painful and is
useless anyway. So remove the removal of an entry that was never
registered and duplicate the logic for one which is added
conditionally. Additionally move the removal above releasing fb_info
as we still need the information.
This prevents tainting the kernel by the procfs warn on and
avoiding access to already freed memory is probably also a good idea.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index c6c01ef..457a9b2 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1702,13 +1702,16 @@ static void viafb_init_proc(struct proc_dir_entry **viafb_entry)
 }
 static void viafb_remove_proc(struct proc_dir_entry *viafb_entry)
 {
-	/* no problem if it was not registered */
+	struct chip_information *chip_info = &viaparinfo->shared->chip_info;
+
 	remove_proc_entry("dvp0", viafb_entry);/* parent dir */
 	remove_proc_entry("dvp1", viafb_entry);
 	remove_proc_entry("dfph", viafb_entry);
 	remove_proc_entry("dfpl", viafb_entry);
-	remove_proc_entry("vt1636", viafb_entry);
-	remove_proc_entry("vt1625", viafb_entry);
+	if (chip_info->lvds_chip_info.lvds_chip_name == VT1636_LVDS
+		|| chip_info->lvds_chip_info2.lvds_chip_name == VT1636_LVDS)
+		remove_proc_entry("vt1636", viafb_entry);
+
 	remove_proc_entry("viafb", NULL);
 }
 
@@ -1951,12 +1954,10 @@ static void __devexit via_pci_remove(struct pci_dev *pdev)
 	iounmap(viaparinfo->shared->engine_mmio);
 
 	viafb_delete_i2c_buss(viaparinfo);
-
+	viafb_remove_proc(viaparinfo->shared->proc_entry);
 	framebuffer_release(viafbinfo);
 	if (viafb_dual_fb)
 		framebuffer_release(viafbinfo1);
-
-	viafb_remove_proc(viaparinfo->shared->proc_entry);
 }
 
 #ifndef MODULE
-- 
1.6.3.2

