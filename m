Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab1DNSHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:07:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:42210 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964993Ab1DNR6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 182/209] HID: hidraw: fix window in hidraw_release
Date: Thu, 14 Apr 2011 13:55:40 -0400
Message-Id: <1302803767-9715-69-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit cb174681a9ececa6702f114b85bdf82144b6a5af upstream.

There is a window between hidraw_table check and its dereference.
In that window, the device may be unplugged and removed form the
system and we will then dereference NULL.

Lock that place properly so that either we get NULL and jump out or we
can work with real pointer.

[PG: slightly/trivially reworked for backport to 34]

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hid/hidraw.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 9d3c663..23d936d 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -212,11 +212,12 @@ static int hidraw_release(struct inode * inode, struct file * file)
 	unsigned int minor = iminor(inode);
 	struct hidraw *dev;
 	struct hidraw_list *list = file->private_data;
+	int ret;
 
+	mutex_lock(&minors_lock);
 	if (!hidraw_table[minor]) {
-		printk(KERN_EMERG "hidraw device with minor %d doesn't exist\n",
-				minor);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto unlock;
 	}
 
 	list_del(&list->node);
@@ -230,10 +231,12 @@ static int hidraw_release(struct inode * inode, struct file * file)
 			kfree(list->hidraw);
 		}
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
-- 
1.7.4.4

