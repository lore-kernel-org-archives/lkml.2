Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0LHAy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:54:58 -0500
Received: from kroah.org ([198.145.64.141]:58574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab0LHAr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:57 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:33 2010
Message-Id: <20101208004433.810778286@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Antonio Ospite <ospite@studenti.unina.it>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [095/127] HID: hidraw, fix a NULL pointer dereference in hidraw_write
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Antonio Ospite <ospite@studenti.unina.it>

commit e42dee9a99a3ecd32b5c027e8f7411fb5bc11eb6 upstream.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffffa0f0a625>] hidraw_write+0x3b/0x116 [hid]
[...]

This is reproducible by disconnecting the device while userspace writes
to dev node in a loop and doesn't check return values in order to exit
the loop.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hidraw.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -105,11 +105,15 @@ out:
 static ssize_t hidraw_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
 {
 	unsigned int minor = iminor(file->f_path.dentry->d_inode);
-	/* FIXME: What stops hidraw_table going NULL */
-	struct hid_device *dev = hidraw_table[minor]->hid;
+	struct hid_device *dev;
 	__u8 *buf;
 	int ret = 0;
 
+	if (!hidraw_table[minor])
+		return -ENODEV;
+
+	dev = hidraw_table[minor]->hid;
+
 	if (!dev->hid_output_raw_report)
 		return -ENODEV;
 


