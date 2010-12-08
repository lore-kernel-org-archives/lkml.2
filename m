Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab0LHAj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:39:56 -0500
Received: from kroah.org ([198.145.64.141]:54783 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab0LHAeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:34:31 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:06:41 2010
Message-Id: <20101208000641.326992756@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:04:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segooon@gmail.com>
Subject: [18/44] usb: core: fix information leak to userland
In-Reply-To: <20101208003205.GA4286@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segooon@gmail.com>

commit 886ccd4520064408ce5876cfe00554ce52ecf4a7 upstream.

Structure usbdevfs_connectinfo is copied to userland with padding byted
after "slow" field uninitialized.  It leads to leaking of contents of
kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -883,10 +883,11 @@ static int proc_getdriver(struct dev_sta
 
 static int proc_connectinfo(struct dev_state *ps, void __user *arg)
 {
-	struct usbdevfs_connectinfo ci;
+	struct usbdevfs_connectinfo ci = {
+		.devnum = ps->dev->devnum,
+		.slow = ps->dev->speed == USB_SPEED_LOW
+	};
 
-	ci.devnum = ps->dev->devnum;
-	ci.slow = ps->dev->speed == USB_SPEED_LOW;
 	if (copy_to_user(arg, &ci, sizeof(ci)))
 		return -EFAULT;
 	return 0;


