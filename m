Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0CaOJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 10:09:52 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:48969 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab0CaOJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 10:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=pixwzUDg8yispjCm2dh2W9cEYHXbP40iSV635u/DkpAGEXAQJJtWPmWJHPq3WYJpsk
         fCDoDINR2r+PHRRFihYsGnhv05xoUA6qUwzHPQSkLIMhqRiu/F+nlLIduKt+JQ9IxMnN
         Xj4mHlqOBdWkZJrAFPqbw+F5cAikCyoSn1Pq4=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] USB: Remove BKL from remount() function in usbfs
Date: Wed, 31 Mar 2010 16:09:38 +0200
Message-Id: <1270044578-4291-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL was used into remount_fs pointed function for serialized access to
super_block from the others super_operations functions.

The function update_sb(), invoked by remount(), seems already well serialized
with &root->d_inode->i_mutex. Moreover don't seems there are others
super_operations functions in USB core for usbfs that should access to
super_block in a way which require BKL.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/usb/core/inode.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 97b40ce..54972d6 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -39,7 +39,6 @@
 #include <linux/parser.h>
 #include <linux/notifier.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <asm/byteorder.h>
 #include "usb.h"
 #include "hcd.h"
@@ -265,13 +264,9 @@ static int remount(struct super_block *sb, int *flags, char *data)
 		return -EINVAL;
 	}
 
-	lock_kernel();
-
 	if (usbfs_mount && usbfs_mount->mnt_sb)
 		update_sb(usbfs_mount->mnt_sb);
 
-	unlock_kernel();
-
 	return 0;
 }
 
-- 
1.6.3.3

