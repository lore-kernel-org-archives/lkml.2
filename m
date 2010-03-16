Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966311Ab0CPOqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:46:11 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:52299 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933060Ab0CPOqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:46:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: airlied@redhat.com
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 1/1] GPU: vga_switcheroo, fix lock imbalance
Date: Tue, 16 Mar 2010 15:45:51 +0100
Message-Id: <1268750751-13087-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that one error path in vga_switcheroo_debugfs_write
omits to unlock vgasr_mutex. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/vga/vga_switcheroo.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index d6d1149..c8768f3 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -276,8 +276,10 @@ vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
 
 	mutex_lock(&vgasr_mutex);
 
-	if (!vgasr_priv.active)
-		return -EINVAL;
+	if (!vgasr_priv.active) {
+		cnt = -EINVAL;
+		goto out;
+	}
 
 	/* pwr off the device not in use */
 	if (strncmp(usercmd, "OFF", 3) == 0) {
-- 
1.7.0.1


