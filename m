Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab0D1WTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:19:07 -0400
Received: from tex.lwn.net ([70.33.254.29]:48922 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286Ab0D1WS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:18:29 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 29/30] viafb: fix proc entry removal
Date: Wed, 28 Apr 2010 16:17:30 -0600
Message-Id: <1272493051-25380-30-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272493051-25380-1-git-send-email-corbet@lwn.net>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

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
index e94f913..51e9106 100644
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
 
@@ -1967,12 +1970,10 @@ void __devexit via_fb_pci_remove(struct pci_dev *pdev)
 	unregister_framebuffer(viafbinfo);
 	if (viafb_dual_fb)
 		unregister_framebuffer(viafbinfo1);
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
1.7.0.1

