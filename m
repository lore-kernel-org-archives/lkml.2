Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221Ab1CDXUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 18:20:08 -0500
Received: from mail.ispras.ru ([83.149.199.43]:33387 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab1CDXUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:20:07 -0500
X-Greylist: delayed 1514 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 18:20:07 EST
Message-ID: <51766.91.79.113.99.1299279290.squirrel@mail.ispras.ru>
Date: Sat, 5 Mar 2011 01:54:50 +0300 (MSK)
Subject: [PATCH] usb-gadget: unlock data->lock mutex on error path in 
     ep_read()
From: "Alexey Khoroshilov" <khoroshilov@ispras.ru>
To: "David Brownell" <dbrownell@users.sourceforge.net>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: khoroshilov@ispras.ru
User-Agent: SquirrelMail/1.4.8-5.el5_3.7
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep_read() acquires data->lock mutex in get_ready_ep() and releases it on
all paths except for one: when usb_endpoint_xfer_isoc() failed. The patch
adds mutex_unlock(&data->lock) at that path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/gadget/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 3ed73f4..a01383f 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -386,8 +386,10 @@ ep_read (struct file *fd, char __user *buf, size_t
len, loff_t *ptr)

        /* halt any endpoint by doing a "wrong direction" i/o call */
        if (usb_endpoint_dir_in(&data->desc)) {
-               if (usb_endpoint_xfer_isoc(&data->desc))
+               if (usb_endpoint_xfer_isoc(&data->desc)) {
+                       mutex_unlock(&data->lock);
                        return -EINVAL;
+               }
                DBG (data->dev, "%s halt\n", data->name);
                spin_lock_irq (&data->dev->lock);
                if (likely (data->ep != NULL))
-- 
1.7.0.4

