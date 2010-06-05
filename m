Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0FETXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:23:08 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:54847 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab0FETXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:23:04 -0400
Date: Sat, 5 Jun 2010 21:23:01 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] zorro: BKL removal
Message-ID: <alpine.DEB.2.00.1006052121550.12934@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove BKL use from proc_bus_zorro_lseek(), like was done for
proc_bus_pci_lseek() a long time ago.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/proc.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index 3c7046d..4f4ea88 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -22,8 +22,9 @@ static loff_t
 proc_bus_zorro_lseek(struct file *file, loff_t off, int whence)
 {
 	loff_t new = -1;
+	struct inode *inode = file->f_path.dentry->d_inode;
 
-	lock_kernel();
+	mutex_lock(&inode->i_mutex);
 	switch (whence) {
 	case 0:
 		new = off;
@@ -35,12 +36,12 @@ proc_bus_zorro_lseek(struct file *file, loff_t off, int whence)
 		new = sizeof(struct ConfigDev) + off;
 		break;
 	}
-	if (new < 0 || new > sizeof(struct ConfigDev)) {
-		unlock_kernel();
-		return -EINVAL;
-	}
-	unlock_kernel();
-	return (file->f_pos = new);
+	if (new < 0 || new > sizeof(struct ConfigDev))
+		new = -EINVAL;
+	else
+		file->f_pos = new;
+	mutex_unlock(&inode->i_mutex);
+	return new;
 }
 
 static ssize_t
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
