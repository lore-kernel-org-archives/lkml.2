Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0INTkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:40:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52995 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab0INTkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:40:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 04/18] isapnp: BKL removal
Date: Tue, 14 Sep 2010 21:40:08 +0200
Message-Id: <1284493213-7263-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493139-7233-1-git-send-email-arnd@arndb.de>
References: <1284493139-7233-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:4olcAXuVW2qtNbpjFTU0kRt0C3Okasy9HTMf8HNklQw
 AjR5A8yyXA5CXU0BOH2rFA39XIa9Sin/w7DzUmKlMFJmGYJZEb
 sSjnE09CpGxdnvzzqpS98Qxc4UsLPLYjCwVPoQVpbcAbmJ++LO
 CChoN9XZQvM4nKZN02ygf+9RVDtRu1ZDgd77wjIE6HylZaF+MW
 sghdoXqRRNg7l5+tWvgHQ==
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

