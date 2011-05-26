Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab1EZGyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:54:24 -0400
Received: from mail.ispras.ru ([83.149.199.43]:46001 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab1EZGyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:54:22 -0400
X-Greylist: delayed 1294 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 May 2011 02:54:22 EDT
Message-ID: <4DDDF3EA.6050501@ispras.ru>
Date: Thu, 26 May 2011 10:32:10 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb-gadget: unlock data->lock mutex on error path in ep_write()
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep_write() acquires data->lock mutex in get_ready_ep() and releases it on
all paths except for one: when usb_endpoint_xfer_isoc() failed. The
patch adds mutex_unlock(&data->lock) at that path.

It is similar to commit 00cc7a5faf25b3ba5cf30fcffc62249bdd152006 for ep_read(),
it was not fixed at that time by accident.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/gadget/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index a01383f..a56876a 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -431,8 +431,10 @@ ep_write (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)

 	/* halt any endpoint by doing a "wrong direction" i/o call */
 	if (!usb_endpoint_dir_in(&data->desc)) {
-		if (usb_endpoint_xfer_isoc(&data->desc))
+		if (usb_endpoint_xfer_isoc(&data->desc)) {
+			mutex_unlock(&data->lock);
 			return -EINVAL;
+		}
 		DBG (data->dev, "%s halt\n", data->name);
 		spin_lock_irq (&data->dev->lock);
 		if (likely (data->ep != NULL))
-- 
1.7.4.1
