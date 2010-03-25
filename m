Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0CYFR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:17:27 -0400
Received: from mail.perches.com ([173.55.12.10]:1081 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab0CYFRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:24 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 02/13] drivers/staging/dt3155: Hoist assign from if
Date: Wed, 24 Mar 2010 22:16:56 -0700
Message-Id: <4c48eda8f1057b8911e16c4bcc3bac0c87855e12.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269493047.git.joe@perches.com>
References: <cover.1269493047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/dt3155/dt3155_drv.c |   20 ++++++++++++--------
 drivers/staging/dt3155/dt3155_isr.c |    3 ++-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index a67c622..4a073c4 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -788,7 +788,8 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   /* non-blocking reads should return if no data */
   if (filep->f_flags & O_NDELAY)
     {
-      if ((frame_index = dt3155_get_ready_buffer(minor)) < 0) {
+      frame_index = dt3155_get_ready_buffer(minor);
+      if (frame_index < 0) {
 	/*printk( "dt3155:  no buffers available (?)\n");*/
 	/* 		printques(minor); */
 	return -EAGAIN;
@@ -878,8 +879,8 @@ static int find_PCI (void)
       pci_index ++;
 
       /* Is it really there? */
-      if ((error =
-	   pci_read_config_word(pci_dev, PCI_CLASS_DEVICE, &rev_device)))
+      error = pci_read_config_word(pci_dev, PCI_CLASS_DEVICE, &rev_device);
+      if (error)
 	continue;
 
       /* Found a board */
@@ -897,8 +898,8 @@ static int find_PCI (void)
 
       /* Now, just go out and make sure that this/these device(s) is/are
 	 actually mapped into the kernel address space */
-      if ((error = pci_read_config_dword( pci_dev, PCI_BASE_ADDRESS_0,
-					  (u32 *) &base)))
+      error = pci_read_config_dword(pci_dev, PCI_BASE_ADDRESS_0, (u32 *)&base);
+      if (error)
 	{
 	  printk("DT3155: Was not able to find device \n");
 	  goto err;
@@ -919,7 +920,8 @@ static int find_PCI (void)
 	  goto err;
 	}
 
-      if ( (error = pci_read_config_byte( pci_dev, PCI_INTERRUPT_LINE, &irq)) )
+      error = pci_read_config_byte( pci_dev, PCI_INTERRUPT_LINE, &irq);
+      if (error)
 	{
 	  printk("DT3155: Was not able to find device \n");
 	  goto err;
@@ -995,7 +997,8 @@ int init_module(void)
   /* Now let's find the hardware.  find_PCI() will set ndevices to the
    * number of cards found in this machine. */
     {
-      if ( (rcode = find_PCI()) !=  DT_3155_SUCCESS )
+      rcode = find_PCI();
+      if (rcode !=  DT_3155_SUCCESS)
 	{
 	  printk("DT3155 error: find_PCI() failed to find dt3155 board(s)\n");
 	  unregister_chrdev( dt3155_major, "dt3155" );
@@ -1004,7 +1007,8 @@ int init_module(void)
     }
 
   /* Ok, time to setup the frame buffers */
-  if( (rcode = dt3155_setup_buffers(&allocatorAddr)) < 0 )
+  rcode = dt3155_setup_buffers(&allocatorAddr);
+  if (rcode < 0)
     {
       printk("DT3155: Error: setting up buffer not large enough.");
       unregister_chrdev( dt3155_major, "dt3155" );
diff --git a/drivers/staging/dt3155/dt3155_isr.c b/drivers/staging/dt3155/dt3155_isr.c
index fd7f93d..4109ea0 100644
--- a/drivers/staging/dt3155/dt3155_isr.c
+++ b/drivers/staging/dt3155/dt3155_isr.c
@@ -269,7 +269,8 @@ void allocate_buffers (u32 *buf_addr, u32* total_size_kbs,
   printk("DT3155: ...the allocator has: %d KB\n", allocator_max);
   size_kbs = (full_size_kbs <= allocator_max ? full_size_kbs : allocator_max);
   if (size_kbs > min_size_kbs) {
-    if ((*buf_addr = allocator_allocate_dma (size_kbs, GFP_KERNEL)) != 0) {
+    *buf_addr = allocator_allocate_dma(size_kbs, GFP_KERNEL);
+    if (*buf_addr != 0) {
       printk("DT3155:  Managed to allocate: %d KB\n", size_kbs);
       *total_size_kbs = size_kbs;
       return;
-- 
1.7.0.14.g7e948

