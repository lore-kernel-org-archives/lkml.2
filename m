Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab0KBMmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 08:42:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab0KBMmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 08:42:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=v+gVxlXrRzFQjdzt7dhjCKkx32Ww7WVGmi0j/eSX3pAJlmhQMm0Ln6G0hNxeBXqBka
         G7ZneupNltw/k03DGgFfV4+SBP4enCZ3EPLWuzpVu4fTTRe8fVVcQXOabGKvuLCqr2d7
         0YsPhTEiV6cvSiltSgYQ/w/JuJ2ZlOPcr5SHY=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 2/3] staging: ft1000: Remove dead code.
Date: Tue,  2 Nov 2010 13:44:09 +0100
Message-Id: <1288701850-29123-2-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288701850-29123-1-git-send-email-marek.belisko@gmail.com>
References: <1288701850-29123-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove functions which was used nowhere. Also remove dead
variables used by this functions.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c  |  199 ------------------------
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    1 -
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    3 -
 3 files changed, 0 insertions(+), 203 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index bc6aaf4..5a9edfb 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -45,33 +45,6 @@ static unsigned long gCardIndex;
 
 #define MAX_RCV_LOOP   100
 
-/****************************************************************
- *     ft1000_control_complete
- ****************************************************************/
-static void ft1000_control_complete(struct urb *urb)
-{
-    struct ft1000_device *ft1000dev = (struct ft1000_device *)urb->context;
-
-    //DEBUG("FT1000_CONTROL_COMPLETE ENTERED\n");
-    if (ft1000dev == NULL )
-    {
-        DEBUG("NULL ft1000dev, failure\n");
-        return ;
-    }
-    else if ( ft1000dev->dev == NULL )
-    {
-        DEBUG("NULL ft1000dev->dev, failure\n");
-        return ;
-    }
-
-    if(waitqueue_active(&ft1000dev->control_wait))
-    {
-        wake_up(&ft1000dev->control_wait);
-    }
-
-    //DEBUG("FT1000_CONTROL_COMPLETE RETURNED\n");
-}
-
 //---------------------------------------------------------------------------
 // Function:    ft1000_control
 //
@@ -1023,178 +996,6 @@ static void ft1000_usb_transmit_complete(struct urb *urb)
     //DEBUG("Return from ft1000_usb_transmit_complete\n");
 }
 
-
-/****************************************************************
- *     ft1000_control
- ****************************************************************/
-static int ft1000_read_fifo_reg(struct ft1000_device *ft1000dev,unsigned int pipe,
-                          u8 request,
-                          u8 requesttype,
-                          u16 value,
-                          u16 index,
-                          void *data,
-                          u16 size,
-                          int timeout)
-{
-    u16 ret;
-
-    DECLARE_WAITQUEUE(wait, current);
-    struct urb *urb;
-    struct usb_ctrlrequest *dr;
-    int status;
-
-    if (ft1000dev == NULL )
-    {
-        DEBUG("NULL ft1000dev, failure\n");
-        return STATUS_FAILURE;
-    }
-    else if ( ft1000dev->dev == NULL )
-    {
-        DEBUG("NULL ft1000dev->dev, failure\n");
-        return STATUS_FAILURE;
-    }
-
-    spin_lock(&ft1000dev->device_lock);
-
-    if(in_interrupt())
-    {
-        spin_unlock(&ft1000dev->device_lock);
-        return -EBUSY;
-    }
-
-    urb = usb_alloc_urb(0, GFP_KERNEL);
-    dr = kmalloc(sizeof(struct usb_ctrlrequest), in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);
-
-    if(!urb || !dr)
-    {
-	kfree(dr);
-	usb_free_urb(urb);
-        spin_unlock(&ft1000dev->device_lock);
-        return -ENOMEM;
-    }
-
-
-
-    dr->bRequestType = requesttype;
-    dr->bRequest = request;
-    dr->wValue = value;
-    dr->wIndex = index;
-    dr->wLength = size;
-
-    usb_fill_control_urb(urb, ft1000dev->dev, pipe, (char*)dr, (void*)data, size, (void *)ft1000_control_complete, (void*)ft1000dev);
-
-
-    init_waitqueue_head(&ft1000dev->control_wait);
-
-	set_current_state(TASK_INTERRUPTIBLE);
-
-    add_wait_queue(&ft1000dev->control_wait, &wait);
-
-
-
-
-    status = usb_submit_urb(urb, GFP_KERNEL);
-
-    if(status)
-    {
-        usb_free_urb(urb);
-        kfree(dr);
-        remove_wait_queue(&ft1000dev->control_wait, &wait);
-        spin_unlock(&ft1000dev->device_lock);
-        return status;
-    }
-
-    if(urb->status == -EINPROGRESS)
-    {
-        while(timeout && urb->status == -EINPROGRESS)
-        {
-            status = timeout = schedule_timeout(timeout);
-        }
-    }
-    else
-    {
-        status = 1;
-    }
-
-    remove_wait_queue(&ft1000dev->control_wait, &wait);
-
-    if(!status)
-    {
-        usb_unlink_urb(urb);
-        printk("ft1000 timeout\n");
-        status = -ETIMEDOUT;
-    }
-    else
-    {
-        status = urb->status;
-
-        if(urb->status)
-        {
-            printk("ft1000 control message failed (urb addr: %p) with error number: %i\n", urb, (int)status);
-
-            usb_clear_halt(ft1000dev->dev, usb_rcvctrlpipe(ft1000dev->dev, 0));
-            usb_clear_halt(ft1000dev->dev, usb_sndctrlpipe(ft1000dev->dev, 0));
-            usb_unlink_urb(urb);
-        }
-    }
-
-
-
-    usb_free_urb(urb);
-    kfree(dr);
-    spin_unlock(&ft1000dev->device_lock);
-    return ret;
-
-
-}
-
-//---------------------------------------------------------------------------
-// Function:    ft1000_read_fifo_len
-//
-// Parameters:  ft1000dev - device structure
-//
-//
-// Returns:     none
-//
-// Description: read the fifo length register content
-//
-// Notes:
-//
-//---------------------------------------------------------------------------
-static inline u16 ft1000_read_fifo_len (struct net_device *dev)
-{
-    u16 temp;
-    u16 ret;
-
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
-    struct ft1000_device *ft1000dev = info->pFt1000Dev;
-//    DEBUG("ft1000_read_fifo_len: enter ft1000dev %x\n", ft1000dev);			//aelias [-] reason: warning: format ???%x??? expects type ???unsigned int???, but argument 2 has type ???struct ft1000_device *???
-    DEBUG("ft1000_read_fifo_len: enter ft1000dev %p\n", ft1000dev);	//aelias [+] reason: up
-
-    ret = STATUS_SUCCESS;
-
-    ret = ft1000_read_fifo_reg(ft1000dev,
-                          usb_rcvctrlpipe(ft1000dev->dev,0),
-                          HARLEY_READ_REGISTER,
-                          HARLEY_READ_OPERATION,
-                          0,
-                          FT1000_REG_MAG_UFSR,
-                          &temp,
-                          2,
-                          LARGE_TIMEOUT);
-
-    if (ret>0)
-        ret = STATUS_SUCCESS;
-    else
-        ret = STATUS_FAILURE;
-
-    DEBUG("ft1000_read_fifo_len: returned %d\n", temp);
-
-    return (temp- 16);
-
-}
-
-
 //---------------------------------------------------------------------------
 //
 // Function:   ft1000_copy_down_pkt
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 28f55b2..4e81bdd 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -84,7 +84,6 @@ static int ft1000_probe(struct usb_interface *interface,
 	ft1000dev->dev = dev;
 	ft1000dev->status = 0;
 	ft1000dev->net = NULL;
-	spin_lock_init(&ft1000dev->device_lock);
 	ft1000dev->tx_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	ft1000dev->rx_urb = usb_alloc_urb(0, GFP_ATOMIC);
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index a9d419a..503481a 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -466,12 +466,9 @@ struct ft1000_device
 {
 	struct usb_device *dev;
 	struct net_device *net;
-	spinlock_t device_lock;
 
 	u32 status;
 
-	wait_queue_head_t control_wait;
-
 	struct urb *rx_urb;
 	struct urb *tx_urb;
 
-- 
1.7.1

