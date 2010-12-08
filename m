Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0LHAr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:58 -0500
Received: from kroah.org ([198.145.64.141]:58566 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756311Ab0LHAr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:56 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:33 2010
Message-Id: <20101208004433.697737658@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Antonio Ospite <ospite@studenti.unina.it>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [094/127] HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Antonio Ospite <ospite@studenti.unina.it>

commit d20d5ffab92f00188f360c44c791a5ffb988247c upstream.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffffa02c66b4>] hidraw_ioctl+0xfc/0x32c [hid]
[...]

This is reproducible by disconnecting the device while userspace does
ioctl in a loop and doesn't check return values in order to exit the
loop.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hidraw.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -237,11 +237,16 @@ static long hidraw_ioctl(struct file *fi
 	struct inode *inode = file->f_path.dentry->d_inode;
 	unsigned int minor = iminor(inode);
 	long ret = 0;
-	/* FIXME: What stops hidraw_table going NULL */
-	struct hidraw *dev = hidraw_table[minor];
+	struct hidraw *dev;
 	void __user *user_arg = (void __user*) arg;
 
 	lock_kernel();
+	dev = hidraw_table[minor];
+	if (!dev) {
+		ret = -ENODEV;
+		goto out;
+	}
+
 	switch (cmd) {
 		case HIDIOCGRDESCSIZE:
 			if (put_user(dev->hid->rsize, (int __user *)arg))
@@ -314,6 +319,7 @@ static long hidraw_ioctl(struct file *fi
 
 		ret = -ENOTTY;
 	}
+out:
 	unlock_kernel();
 	return ret;
 }


