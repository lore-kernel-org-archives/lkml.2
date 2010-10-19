Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab0JSJaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:30:01 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:52021 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933423Ab0JSJaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:30:00 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2010 05:30:00 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: jkosina@suse.cz
Cc: alan@signal11.us, linux-input@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] HID: hidraw, fix window in hidraw_release
Date: Tue, 19 Oct 2010 11:29:55 +0200
Message-Id: <1287480595-5627-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287480285-5335-1-git-send-email-jslaby@suse.cz>
References: <1287480285-5335-1-git-send-email-jslaby@suse.cz>
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 19 Oct 2010 11:29:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a window between hidraw_table check and its dereference.
In that window, the device may be unplugged and removed form the
system and we will then dereference NULL.

Lock that place properly so that either we get NULL and jump out or we
can work with real pointer.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hidraw.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 925992f..8a4b32d 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -218,9 +218,13 @@ static int hidraw_release(struct inode * inode, struct file * file)
 	unsigned int minor = iminor(inode);
 	struct hidraw *dev;
 	struct hidraw_list *list = file->private_data;
+	int ret;
 
-	if (!hidraw_table[minor])
-		return -ENODEV;
+	mutex_lock(&minors_lock);
+	if (!hidraw_table[minor]) {
+		ret = -ENODEV;
+		goto unlock;
+	}
 
 	list_del(&list->node);
 	dev = hidraw_table[minor];
@@ -233,10 +237,12 @@ static int hidraw_release(struct inode * inode, struct file * file)
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
1.7.3.1

