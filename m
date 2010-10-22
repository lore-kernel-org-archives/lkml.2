Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab0JVSz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:55:57 -0400
Received: from kroah.org ([198.145.64.141]:33931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab0JVSzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:55 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:28 2010
Message-Id: <20101022185228.309333037@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Antonio Ospite <ospite@studenti.unina.it>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [011/103] HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
 drivers/hid/hidraw.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -246,6 +246,10 @@ static long hidraw_ioctl(struct file *fi
 
 	mutex_lock(&minors_lock);
 	dev = hidraw_table[minor];
+	if (!dev) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	switch (cmd) {
 		case HIDIOCGRDESCSIZE:
@@ -319,6 +323,7 @@ static long hidraw_ioctl(struct file *fi
 
 		ret = -ENOTTY;
 	}
+out:
 	mutex_unlock(&minors_lock);
 	return ret;
 }


