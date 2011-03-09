Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab1CIIKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 03:10:23 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:40725 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab1CIIKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 03:10:19 -0500
Message-ID: <4D772F2B.6030209@ispras.ru>
Date: Wed, 09 Mar 2011 10:41:31 +0300
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb-gadget: unlock data->lock mutex on error path in ep_read()
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep_read() acquires data->lock mutex in get_ready_ep() and releases it on
all paths except for one: when usb_endpoint_xfer_isoc() failed. The
patch adds mutex_unlock(&data->lock) at that path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov<khoroshilov@ispras.ru>
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
-		if (usb_endpoint_xfer_isoc(&data->desc))
+		if (usb_endpoint_xfer_isoc(&data->desc)) {
+			mutex_unlock(&data->lock);
			return -EINVAL;
+		}
	DBG (data->dev, "%s halt\n", data->name);
	spin_lock_irq (&data->dev->lock);
	if (likely (data->ep != NULL))
-- 1.7.0.4
