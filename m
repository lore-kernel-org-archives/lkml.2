Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab0GCWDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:03:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49677 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab0GCWDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:03:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 6/8] isapnp: BKL removal
Date: Sun,  4 Jul 2010 00:02:30 +0200
Message-Id: <1278194552-24943-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278194552-24943-1-git-send-email-arnd@arndb.de>
References: <1278194552-24943-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:dETmdJNPF0iWp8y8DerCjn1yY1Sg+QpDoIgQAmci0ep
 ac6VidVFT8lKlI/gduzYAKGkFIoyDnKdGJcbFOpVGusbvc/L/N
 RnI+lMHy9f3LQCOOQOiLvrpdZi/nO77XaLnCanhFT5J00ipmv9
 OBPCoC0DcFmt/xGRyVRnUjqKkVZB5kjkLn7dy5j0de30o9DcVu
 EsdVoUNjQxF0J0kFD47xQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove BKL use from isapnp_proc_bus_lseek(), like was done for
proc_bus_pci_lseek() a long time ago and recently for Zorro
by Geert Uytterhoeven.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jaroslav Kysela <perex@perex.cz>
---
 drivers/pnp/isapnp/proc.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
index 3f94eda..4249999 100644
--- a/drivers/pnp/isapnp/proc.c
+++ b/drivers/pnp/isapnp/proc.c
@@ -31,8 +31,9 @@ static struct proc_dir_entry *isapnp_proc_bus_dir = NULL;
 static loff_t isapnp_proc_bus_lseek(struct file *file, loff_t off, int whence)
 {
 	loff_t new = -1;
+	struct inode *inode = file->f_path.dentry->d_inode;
 
-	lock_kernel();
+	mutex_lock(&inode->i_mutex);
 	switch (whence) {
 	case 0:
 		new = off;
@@ -45,11 +46,11 @@ static loff_t isapnp_proc_bus_lseek(struct file *file, loff_t off, int whence)
 		break;
 	}
 	if (new < 0 || new > 256) {
-		unlock_kernel();
-		return -EINVAL;
-	}
-	unlock_kernel();
-	return (file->f_pos = new);
+		new = -EINVAL;
+	else
+		file->f_pos = new;
+	mutex_unlock(&inode->i_mutex);
+	return new;
 }
 
 static ssize_t isapnp_proc_bus_read(struct file *file, char __user * buf,
-- 
1.7.1

