Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab0HHOau (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 10:30:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47730 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab0HHOas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 10:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Osj+YnedN8s15UIj4+PjtZdIeUWUUQxeJGnP5QfWuZ2vSfMSJUfuRYFkPaV632mu4C
         nR5+82rykCepNuwIbnEZB3JqVzu2uS8ElN62q7R1RPdm3sQQY3lNr/Kmee+A8uhrTVKR
         oErGcmgM3iKXFyFyRsYk4bPPg9eY/4zTOT/dE=
MIME-Version: 1.0
Date: Sun, 8 Aug 2010 15:30:48 +0100
Message-ID: <AANLkTi=G9+wqWhJmX7QarQXeSw-8qASXMrz6mKvbBNw2@mail.gmail.com>
Subject: [2.6.35 patch] add missing unlock_kernel calls...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Roger Lucas <vt8231@hiddenengine.co.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

Here is a fix for 2.6.36-rc1:

Ensure the BKL is dropped along all paths.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index c24d2fa..53263e7 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -271,16 +271,18 @@ static int hiddev_open(struct inode *inode,
struct file *file)
 	lock_kernel();
 	i = iminor(inode) - HIDDEV_MINOR_BASE;

-	if (i >= HIDDEV_MINORS || i < 0 || !hiddev_table[i])
+	if (i >= HIDDEV_MINORS || i < 0 || !hiddev_table[i]) {
+		unlock_kernel();
 		return -ENODEV;
+	}

-	if (!(list = kzalloc(sizeof(struct hiddev_list), GFP_KERNEL)))
+	if (!(list = kzalloc(sizeof(struct hiddev_list), GFP_KERNEL))) {
+		unlock_kernel();
 		return -ENOMEM;
-	mutex_init(&list->thread_lock);
+	}

+	mutex_init(&list->thread_lock);
 	list->hiddev = hiddev_table[i];
-
-
 	file->private_data = list;

 	/*
-- 
Daniel J Blueman
