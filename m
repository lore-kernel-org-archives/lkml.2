Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450Ab0JGMes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 08:34:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61155 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab0JGMer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 08:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=W46UpkZnNa+dzcZXF3f0bHoco4tsKufsT/INAWo2wRsRlfircxCDFSR1HfPAU1v4Ks
         WhYL8oDWTvqOC4MrnydGGhiz/ixacStqByUZK7BNg967oSgFb5PXHRJLj9+XFwyi1ny8
         JQtljrZma80ylSnw5FsfmcMUUdh9Td1gSd5Ek=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH v2] staging:ft1000-usb: Add correct procedure for fw image downloading.
Date: Thu,  7 Oct 2010 14:36:37 +0200
Message-Id: <1286454997-6236-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   63 --------------------
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   35 ++++++++---
 2 files changed, 26 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index ba07d5d..1f7c7a6 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -132,69 +132,6 @@ typedef struct _DSP_IMAGE_INFO_V6 {
    unsigned short    pad1;
 } DSP_IMAGE_INFO_V6, *PDSP_IMAGE_INFO_V6;
 
-
-//---------------------------------------------------------------------------
-// Function:    getfw
-//
-// Parameters:  char *fn - input DSP image file name
-//              int  *pimgsz - output DSP image file size
-// Returns:     DSP image buffer
-//
-// Description: Read the DSP image file into a char buffer
-//
-// Notes:
-//
-//---------------------------------------------------------------------------
-char *getfw (char *fn, size_t *pimgsz)
-{
-    struct file *fd;
-    mm_segment_t fs = get_fs();
-    loff_t pos;
-    char *pfwimg;
-    int fwimgsz;
-
-    set_fs(get_ds());
-
-    fd = filp_open(fn, 0, 0);
-    if ( IS_ERR(fd) )
-    {
-       DEBUG("FT1000:%s:can not open dsp image\n", __FUNCTION__);
-       set_fs(fs);
-       return NULL;
-    }
-
-    fwimgsz = i_size_read(fd->f_dentry->d_inode);
-    *pimgsz = fwimgsz;
-
-    if (fwimgsz <= 0)
-    {
-       DEBUG("FT1000:%s:invalid file size\n", __FUNCTION__);
-       filp_close(fd, current->files);
-       set_fs(fs);
-       return NULL;
-    }
-    pfwimg = (char*)vmalloc ( fwimgsz );
-    if (pfwimg == NULL) {
-        DEBUG("FT1000:%s:can not allocate memory for dsp image\n", __FUNCTION__);
-        filp_close(fd, current->files);
-        set_fs(fs);
-        return NULL;
-    }
-    pos = 0;
-    if (vfs_read(fd, (void __user __force*)pfwimg, fwimgsz, &pos) != fwimgsz) {
-       vfree(pfwimg);
-       DEBUG("FT1000:%s:failed to read firmware image\n",__FUNCTION__);
-       filp_close(fd, current->files);
-       set_fs(fs);
-       return NULL;
-    }
-
-    filp_close(fd, current->files);
-    set_fs(fs);
-
-    return pfwimg;
-}
-
 //---------------------------------------------------------------------------
 // Function:    check_usb_db
 //
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 4aef1c4..3c9bb6d 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -13,6 +13,7 @@
 #include <linux/usb.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/firmware.h>
 #include "ft1000_usb.h"
 
 //#include <linux/sched.h>
@@ -88,10 +89,12 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
     struct usb_endpoint_descriptor *endpoint;
     struct usb_device *dev;
     unsigned numaltsetting;
-    int i;
+	int i, ret = 0, size;
 
     struct ft1000_device *ft1000dev;
     FT1000_INFO *pft1000info;
+	const struct firmware *dsp_fw;
+
 
     if(!(ft1000dev = kmalloc(sizeof(struct ft1000_device), GFP_KERNEL)))
     {
@@ -149,14 +152,24 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
 
     DEBUG("bulk_in=%d, bulk_out=%d\n", ft1000dev->bulk_in_endpointAddr, ft1000dev->bulk_out_endpointAddr);
 
-    //read DSP image
-    pFileStart = (void*)getfw("/etc/flarion/ft3000.img", &FileLength);
+	ret = request_firmware(&dsp_fw, "ft3000.img", &dev->dev);
+	if (ret < 0) {
+		printk(KERN_ERR "Error request_firmware().\n");
+		goto err_fw;
+	}
 
-    if (pFileStart == NULL )
-    {
-        DEBUG ("ft1000_probe: Read DSP image failed\n");
-        return 0;
-    }
+	size = max_t(uint, dsp_fw->size, 4096);
+	pFileStart = kmalloc(size, GFP_KERNEL);
+
+	if (!pFileStart) {
+		release_firmware(dsp_fw);
+		ret = -ENOMEM;
+		goto err_fw;
+	}
+
+	memcpy(pFileStart, dsp_fw->data, dsp_fw->size);
+	FileLength = dsp_fw->size;
+	release_firmware(dsp_fw);
 
     //for ( i=0; i< MAX_NUM_CARDS+2; i++)
     //    pdevobj[i] = NULL;
@@ -206,6 +219,10 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
 		ft1000InitProc(ft1000dev->net);// +mbelian
 
        return 0;
+
+err_fw:
+	kfree(ft1000dev);
+	return ret;
 }
 
 //---------------------------------------------------------------------------
@@ -262,7 +279,7 @@ static void ft1000_disconnect(struct usb_interface *interface)
 
 		kfree(pft1000info->pFt1000Dev); //+mbelian
     }
-
+	kfree(pFileStart);
     //terminate other kernel threads
     //in multiple instances case, first find the device
     //in the link list
-- 
1.7.1

