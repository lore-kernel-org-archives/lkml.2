Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0KFOlj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 10:41:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55386 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab0KFOlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 10:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ET2eaiv/J5/+xy71owEmSqrIr0HvMJxOyfFk9uubars5kDGJgQcqPpp9ScHVyq9G3b
         B8+BxL4h+KjBf/ZW6OSpcDGtYqAWfyLbJzRMgCOUxFFQSpZLuEu1wrnzlu4wWlbXjkcv
         Gvthu/Ex8BuoTdQ7rL3qsbmVvAahmh8t/5j7o=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Oliver Neukum <oliver@neukum.org>, Kees Cook <kees.cook@canonical.com>,
        Joe Perches <joe@perches.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: misc: iowarrior: fix information leak to userland
Date: Sat,  6 Nov 2010 17:41:31 +0300
Message-Id: <1289054492-18278-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure iowarrior_info is copied to userland with padding byted
between "serial" and "revision" fields uninitialized.  It leads to
leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/usb/misc/iowarrior.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 3756641..c9078e4 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -553,6 +553,7 @@ static long iowarrior_ioctl(struct file *file, unsigned int cmd,
 			/* needed for power consumption */
 			struct usb_config_descriptor *cfg_descriptor = &dev->udev->actconfig->desc;
 
+			memset(&info, 0, sizeof(info));
 			/* directly from the descriptor */
 			info.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
 			info.product = dev->product_id;
-- 
1.7.0.4

