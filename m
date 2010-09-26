Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab0IZPcF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 11:32:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0IZPcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 11:32:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: greg@kroah.com
Subject: [PATCH] staging: make new character devices nonseekable
Date: Sun, 26 Sep 2010 17:31:52 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009261731.53062.arnd@arndb.de>
X-Provags-ID: V02:K0:zL/kyQOxEXR7ba2EG/rNwqC4HcR+iu3VDIh7/dg49pZ
 +cSatUw4iM7AIFpYT3n8iu1+jOf3jIHKi3pp+uRAIq+1Gwbt6A
 BCSiU9t8nzyRrTm9cvdnR8vjN/G6jteel7DNIk6S3kEgUt2hTL
 gg3uIosyR7zeVBE7wnitaMxTa5qy8TcnkQJ7KgFSTu3pkOS1mr
 i0JQy2P3FrYcDV3BxY/9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a preparation for changing the default behaviour of llseek to no_llseek,
every file_operations structure should have a .llseek operation.

There are three new instances in staging now, which can all be changed
into no_llseek explicitly since the devices do not need to seek.

Add nonseekable_open where appropriate, to prevent pread/pwrite as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 bcm/Bcmchar.c                    |    3 +++
 bcm/InterfaceInit.c              |    1 +
 ft1000/ft1000-usb/ft1000_chdev.c |    2 ++
 3 files changed, 6 insertions(+)

These are the only instances I can't patch automatically because the code
is not yet upstream. Please apply.

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index b239862..559d909 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -35,6 +35,8 @@ static int bcm_char_open(struct inode *inode, struct file * filp)
 
 	/*Start Queuing the control response Packets*/
 	atomic_inc(&Adapter->ApplicationRunning);
+
+	nonseekable_open(inode, file);
 	return 0;
 }
 static int bcm_char_release(struct inode *inode, struct file *filp)
@@ -2360,6 +2362,7 @@ static struct file_operations bcm_fops = {
     .release  = bcm_char_release,
     .read     = bcm_char_read,
     .unlocked_ioctl    = bcm_char_ioctl,
+	.llseek = no_llseek,
 };
 
 
diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index d22a0e5..67d8572 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -163,6 +163,7 @@ static struct file_operations usbbcm_fops = {
     .read    =  usbbcm_read,
     .write   =  usbbcm_write,
     .owner   =  THIS_MODULE,
+	.llseek = no_llseek,
 };
 
 static struct usb_class_driver usbbcm_class = {
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 65087ce..92c0c04 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -85,6 +85,7 @@ static struct file_operations ft1000fops =
     poll:     ft1000_ChPoll,
     open:     ft1000_ChOpen,
     release:  ft1000_ChRelease
+	.llseek = no_llseek,
 };
 
 
@@ -470,6 +471,7 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
 
     File->private_data = pdevobj[num]->net;
 
+	nonseekable_open(Inode, File);
     return 0;
 }
 
