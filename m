Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab0FAVFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:05:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59635 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab0FAVFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:05:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       linux-usb@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/6] USB-BKL: Remove BKL use in uhci-debug
Date: Tue,  1 Jun 2010 23:04:43 +0200
Message-Id: <1275426285-9088-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275426285-9088-1-git-send-email-arnd@arndb.de>
References: <1275426285-9088-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/jxAHmJgC6U7y78kx4dwWyT6Oidg5HUfn3MEt
 vIWxkpuJVqDCKa3VPLSgZu+75U9sWcJBvbDnerpApur0p1rjoR
 4NQ1j3ZVQVvOwKT6l/huA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

BKL was not really needed, just came from earlier push downs.

The only part that's a bit dodgy is the lseek function. Would
need another lock or atomic access to fpos on 32bit?
Better to have a libfs lseek

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/usb/host/uhci-debug.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/host/uhci-debug.c b/drivers/usb/host/uhci-debug.c
index 98cf0b2..b0cf4f8 100644
--- a/drivers/usb/host/uhci-debug.c
+++ b/drivers/usb/host/uhci-debug.c
@@ -495,18 +495,16 @@ static int uhci_debug_open(struct inode *inode, struct file *file)
 {
 	struct uhci_hcd *uhci = inode->i_private;
 	struct uhci_debug *up;
-	int ret = -ENOMEM;
 	unsigned long flags;
 
-	lock_kernel();
 	up = kmalloc(sizeof(*up), GFP_KERNEL);
 	if (!up)
-		goto out;
+		return -ENOMEM;
 
 	up->data = kmalloc(MAX_OUTPUT, GFP_KERNEL);
 	if (!up->data) {
 		kfree(up);
-		goto out;
+		return -ENOMEM;
 	}
 
 	up->size = 0;
@@ -517,10 +515,7 @@ static int uhci_debug_open(struct inode *inode, struct file *file)
 
 	file->private_data = up;
 
-	ret = 0;
-out:
-	unlock_kernel();
-	return ret;
+	return 0;
 }
 
 static loff_t uhci_debug_lseek(struct file *file, loff_t off, int whence)
@@ -528,9 +523,9 @@ static loff_t uhci_debug_lseek(struct file *file, loff_t off, int whence)
 	struct uhci_debug *up;
 	loff_t new = -1;
 
-	lock_kernel();
 	up = file->private_data;
 
+	/* XXX: atomic 64bit seek access, but that needs to be fixed in the VFS */
 	switch (whence) {
 	case 0:
 		new = off;
@@ -539,11 +534,11 @@ static loff_t uhci_debug_lseek(struct file *file, loff_t off, int whence)
 		new = file->f_pos + off;
 		break;
 	}
+
+	/* XXX: Can size shrink? */
 	if (new < 0 || new > up->size) {
-		unlock_kernel();
 		return -EINVAL;
 	}
-	unlock_kernel();
 	return (file->f_pos = new);
 }
 
-- 
1.7.0.4

