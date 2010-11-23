Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0KWM1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:27:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48718 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0KWM1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=GfUVfjRkkCPM68whOU9wCDVvMEuJnQgHCMqXxYI7MOLedVEsFlomjefAQVBrFWwTcG
         Jki5l1ZPXOyTesJRD8zA+QEoF+ho59Qx2c9bwUQSy8d3Shx+eQRtGZtHqpsyRv4Y4Snq
         rmCXzbbQ+9bDCnBN29OKQEbJSz3896vVBBjHE=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/6] staging: ft1000: Remove functions which create devices in kernel space.
Date: Tue, 23 Nov 2010 13:29:28 +0100
Message-Id: <1290515373-16145-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
References: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove exec_mknod() and rm_mknod() helpers which was used for
device nodes creating/removing in kernel space.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   93 ----------------------
 1 files changed, 0 insertions(+), 93 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 76cee9e..1aec926 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -78,88 +78,6 @@ static struct file_operations ft1000fops =
 	.llseek		= no_llseek,
 };
 
-
-
-
-//---------------------------------------------------------------------------
-// Function:    exec_mknod
-//
-// Parameters:
-//
-// Returns:
-//
-// Description:
-//
-// Notes:
-//
-//---------------------------------------------------------------------------
-static int exec_mknod (void *pdata)
-{
-	struct ft1000_info *info;
-    char mjnum[4];
-    char minornum[4];
-    char temp[32];
-    int retcode;
-//    int i;					//aelias [-] reason : unused variable
-    char *envp[] = { "HOME=/", "PATH=/usr/bin:/bin", NULL };
-    char *argv[]={"-m 666",temp,"c",mjnum,minornum,NULL};
-
-    info = pdata;
-    DEBUG("ft1000_chdev:exec_mknod is called with major number = %d\n", info->DeviceMajor);
-    sprintf(temp, "%s%s", "/dev/", info->DeviceName) ;
-    sprintf(mjnum, "%d", info->DeviceMajor);
-    sprintf(minornum, "%d", info->CardNumber);
-
-    //char *argv[]={"mknod","-m 666",temp,"c",mjnum,minornum,NULL};
-//    char *argv[]={"-m 666",temp,"c",mjnum,minornum,NULL};
-
-    //for (i=0; i<7;i++)
-    //    DEBUG("argv[%d]=%s\n", i, argv[i]);
-
-
-    retcode = call_usermodehelper ("/bin/mknod", argv, envp, 1);
-    if (retcode) {
-        DEBUG("ft1000_chdev:exec_mknod failed to make the node: retcode = %d\n", retcode);
-    }
-
-
-
-    return retcode;
-
-}
-
-//---------------------------------------------------------------------------
-// Function:    rm_mknod
-//
-// Description: This module removes the FT1000 device file
-//
-//---------------------------------------------------------------------------
-static int rm_mknod (void *pdata)
-{
-
-	struct ft1000_info *info;
-    //char *argv[4]={"rm", "-f", "/dev/FT1000", NULL};
-    int retcode;
-    char temp[32];
-    char *argv[]={"rm", "-f", temp, NULL};
-
-	info = (struct ft1000_info *)pdata;
-    DEBUG("ft1000_chdev:rm_mknod is called for device %s\n", info->DeviceName);
-    sprintf(temp, "%s%s", "/dev/", info->DeviceName) ;
-
-//    char *argv[]={"rm", "-f", temp, NULL};
-
-    retcode = call_usermodehelper ("/bin/rm", argv, NULL, 1);
-    if (retcode) {
-        DEBUG("ft1000_chdev:rm_mknod failed to remove the node: retcode = %d\n", retcode);
-    }
-    else
-        DEBUG("ft1000_chdev:rm_mknod done!\n");
-
-
-    return retcode;
-
-}
 //---------------------------------------------------------------------------
 // Function:    ft1000_get_buffer
 //
@@ -238,15 +156,10 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
 	struct ft1000_info *info = netdev_priv(dev->net);
     int result;
     int i;
-    pid_t pid;
 
     // make a new device name
     sprintf(info->DeviceName, "%s%d", "FT100", info->CardNumber);
 
-    // Delete any existing FT1000 node
-    pid = kernel_thread (rm_mknod,(void *)info, 0);
-    msleep(1000);
-
     DEBUG("ft1000_CreateDevice: number of instance = %d\n", ft1000_flarion_cnt);
     DEBUG("DeviceCreated = %x\n", info->DeviceCreated);
 
@@ -282,9 +195,6 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
 	DEBUG("ft1000_PcdCreateDevice: device major = %d\n", info->DeviceMajor);
     }
 
-    // Create a thread to call user mode app to mknod
-    pid = kernel_thread (exec_mknod, (void *)info, 0);
-
     // initialize application information
 
 //    if (ft1000_flarion_cnt == 0) {
@@ -350,7 +260,6 @@ void ft1000_DestroyDevice(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
     int result = 0;
-    pid_t pid;
 		int i;
 	struct dpram_blk *pdpram_blk;
 	struct dpram_blk *ptr;
@@ -366,8 +275,6 @@ void ft1000_DestroyDevice(struct net_device *dev)
 		DEBUG("ft1000_DestroyDevice: unregistered device \"%s\", result = %d\n",
 					   info->DeviceName, result);
 
-       pid = kernel_thread (rm_mknod, (void *)info, 0);
-
         // Make sure we free any memory reserve for slow Queue
         for (i=0; i<MAX_NUM_APP; i++) {
             while (list_empty(&info->app_info[i].app_sqlist) == 0) {
-- 
1.7.1

