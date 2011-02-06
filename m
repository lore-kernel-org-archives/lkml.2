Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab1BFXpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:45:47 -0500
Received: from 1wt.eu ([62.212.114.60]:60285 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab1BFXpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:45:44 -0500
Message-Id: <20110206232252.786428630@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:22:58 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 06/23] HID: hidraw: fix window in hidraw_release
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit cb174681a9ececa6702f114b85bdf82144b6a5af upstream.

[ Backport to .32.y by Antonio Ospite <ospite@studenti.unina.it> ]

There is a window between hidraw_table check and its dereference.
In that window, the device may be unplugged and removed form the
system and we will then dereference NULL.

Lock that place properly so that either we get NULL and jump out or we
can work with real pointer.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 drivers/hid/hidraw.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: longterm-2.6.27/drivers/hid/hidraw.c
===================================================================
--- longterm-2.6.27.orig/drivers/hid/hidraw.c	2011-01-29 11:19:14.681064282 +0100
+++ longterm-2.6.27/drivers/hid/hidraw.c	2011-01-29 11:27:11.371063762 +0100
@@ -196,11 +196,14 @@
 	unsigned int minor = iminor(inode);
 	struct hidraw *dev;
 	struct hidraw_list *list = file->private_data;
+	int ret;
 
+	mutex_lock(&minors_lock);
 	if (!hidraw_table[minor]) {
 		printk(KERN_EMERG "hidraw device with minor %d doesn't exist\n",
 				minor);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto unlock;
 	}
 
 	list_del(&list->node);
@@ -211,10 +214,12 @@
 		else
 			kfree(list->hidraw);
 	}
-
 	kfree(list);
+	ret = 0;
+unlock:
+	mutex_unlock(&minors_lock);
 
-	return 0;
+	return ret;
 }
 
 static long hidraw_ioctl(struct file *file, unsigned int cmd,


