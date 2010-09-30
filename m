Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0I3I0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:26:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60656 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab0I3IY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:24:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/6] staging: make new character devices nonseekable
Date: Thu, 30 Sep 2010 10:24:07 +0200
Message-Id: <1285835052-11880-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285835052-11880-1-git-send-email-arnd@arndb.de>
References: <1285835052-11880-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:jg4o37PJULSr03tvfv2u1VFef5bHW1CA0T3U4Nkd1DE
 C6V2K0CBC/0nPO3uVlM/tm19kU4XyRMBEaNmF01/Bat0rspKla
 gwgOlz9RMoOnpsWtPb5bJj6t83om0jv2MaJEsILaeyfdfHzIc9
 3E73sB6RywyPyT4f69jAnHJeAAJtCqKMC/vDEgJ9iLnhi43BW0
 SzR56bl0vsL6ldb1bSzPQ==
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
 drivers/staging/bcm/Bcmchar.c                    |    5 +++++
 drivers/staging/bcm/InterfaceInit.c              |    1 +
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   10 ++++++----
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index b239862..afde77a 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1,3 +1,5 @@
+#include <linux/fs.h>
+
 #include "headers.h"
 /***************************************************************
 * Function	  - bcm_char_open()
@@ -35,6 +37,8 @@ static int bcm_char_open(struct inode *inode, struct file * filp)
 
 	/*Start Queuing the control response Packets*/
 	atomic_inc(&Adapter->ApplicationRunning);
+
+	nonseekable_open(inode, filp);
 	return 0;
 }
 static int bcm_char_release(struct inode *inode, struct file *filp)
@@ -2360,6 +2364,7 @@ static struct file_operations bcm_fops = {
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
index 65087ce..89d9a58 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -81,10 +81,11 @@ int numofmsgbuf = 0;
 //
 static struct file_operations ft1000fops =
 {
-    unlocked_ioctl:    ft1000_ChIoctl,
-    poll:     ft1000_ChPoll,
-    open:     ft1000_ChOpen,
-    release:  ft1000_ChRelease
+	.unlocked_ioctl	= ft1000_ChIoctl,
+	.poll		= ft1000_ChPoll,
+	.open		= ft1000_ChOpen,
+	.release	= ft1000_ChRelease,
+	.llseek		= no_llseek,
 };
 
 
@@ -470,6 +471,7 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
 
     File->private_data = pdevobj[num]->net;
 
+	nonseekable_open(Inode, File);
     return 0;
 }
 
-- 
1.7.1

