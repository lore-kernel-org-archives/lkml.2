Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab0FAVE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:04:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51023 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab0FAVEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:04:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       linux-usb@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 5/6] usb/gadget: Do not take BKL for gadget->ops->ioctl
Date: Tue,  1 Jun 2010 23:04:44 +0200
Message-Id: <1275426285-9088-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275426285-9088-1-git-send-email-arnd@arndb.de>
References: <1275426285-9088-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19PgioIKPFJX646PgFLfcIGsdt5D50b16jFHFb
 +fgofOtp3LEtuef+g1nN4SidgqBOVrc/HneFWrn9R4Wm6FsYsK
 72yv2vG8y/A+IvbYO8a+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no gadget driver in the tree that
actually implements the ioctl operation, so
obviously it is not necessary to hold the
BKL around the call.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/gadget/f_fs.c  |    2 --
 drivers/usb/gadget/inode.c |    6 ++----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index d69eccf..715da23 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -714,9 +714,7 @@ static long ffs_ep0_ioctl(struct file *file, unsigned code, unsigned long value)
 		struct ffs_function *func = ffs->func;
 		ret = func ? ffs_func_revmap_intf(func, value) : -ENODEV;
 	} else if (gadget->ops->ioctl) {
-		lock_kernel();
 		ret = gadget->ops->ioctl(gadget, code, value);
-		unlock_kernel();
 	} else {
 		ret = -ENOTTY;
 	}
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index de8a838..5308392 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1299,11 +1299,9 @@ static long dev_ioctl (struct file *fd, unsigned code, unsigned long value)
 	struct usb_gadget	*gadget = dev->gadget;
 	long ret = -ENOTTY;
 
-	if (gadget->ops->ioctl) {
-		lock_kernel();
+	if (gadget->ops->ioctl)
 		ret = gadget->ops->ioctl (gadget, code, value);
-		unlock_kernel();
-	}
+
 	return ret;
 }
 
-- 
1.7.0.4

