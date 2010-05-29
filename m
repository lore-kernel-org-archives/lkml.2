Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0E2NSw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:18:52 -0400
Received: from mail.ampazis.net ([86.35.2.10]:37428 "EHLO enigma.wired-net.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab0E2NSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:18:49 -0400
Date: Sat, 29 May 2010 16:18:12 +0300
From: Nanakos Chrysostomos <nanakos@wired-net.gr>
To: gregkh@suse.de
Cc: horms@verge.net.au, hsweeten@visiongravers.com, ss@aao.gov.au,
       randy.dunlap@oracle.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: dt3155: dt3155_drv.c: Fix checkpatch.pl issues.
Message-ID: <20100529131812.GA5051@limpeloula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix resolves checkpatch.pl issues for dt3155_drv.c file.

Signed-off-by: Nanakos Chrysostomos <nanakos@wired-net.gr>
---
 drivers/staging/dt3155/dt3155_drv.c |  612 ++++++++++++++++-------------------
 1 files changed, 283 insertions(+), 329 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 40ef97f..394bc66 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -1,7 +1,7 @@
 /*
 
 Copyright 1996,2002,2005 Gregory D. Hager, Alfred A. Rizzi, Noah J. Cowan,
-                         Jason Lapenta, Scott Smedley, Greg Sharp
+			Jason Lapenta, Scott Smedley, Greg Sharp
 
 This file is part of the DT3155 Device Driver.
 
@@ -27,14 +27,14 @@ MA 02111-1307 USA
   03-Jul-2000 JML       n/a
   10-Oct-2001 SS        port to 2.4 kernel
   02-Apr-2002 SS        Mods to use allocator as a standalone module;
-                        Merged John Roll's changes (john@cfa.harvard.edu)
-                        to make work with multiple boards.
+			Merged John Roll's changes (john@cfa.harvard.edu)
+			to make work with multiple boards.
   02-Jul-2002 SS        Merged James Rose's chages (rosejr@purdue.edu) to:
-                         * fix successive interrupt-driven captures
-                         * add select/poll support.
+			*fix successive interrupt-driven captures
+			*add select/poll support.
   10-Jul-2002 GCS       Add error check when ndevices > MAXBOARDS.
   02-Aug-2002 GCS       Fix field mode so that odd (lower) field is stored
-                        in lower half of buffer.
+			in lower half of buffer.
   05-Aug-2005 SS        port to 2.6 kernel.
   26-Oct-2009 SS	port to 2.6.30 kernel.
 
@@ -65,8 +65,8 @@ extern void printques(int);
 #include <linux/sched.h>
 #include <linux/smp_lock.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 #include "dt3155.h"
 #include "dt3155_drv.h"
@@ -89,16 +89,16 @@ int dt3155_errno = 0;
 #define MAXPCI    16
 
 #ifdef DT_DEBUG
-#define DT_3155_DEBUG_MSG(x,y) printk(x,y)
+#define DT_3155_DEBUG_MSG(x, y) printk(x, y)
 #else
-#define DT_3155_DEBUG_MSG(x,y)
+#define DT_3155_DEBUG_MSG(x, y)
 #endif
 
 /* wait queue for interrupts */
 wait_queue_head_t dt3155_read_wait_queue[MAXBOARDS];
 
 #define DT_3155_SUCCESS 0
-#define DT_3155_FAILURE -EIO
+#define DT_3155_FAILURE (-EIO)
 
 /* set to dynamicaly allocate, but it is tunable: */
 /* insmod DT_3155 dt3155 dt3155_major=XX */
@@ -138,9 +138,9 @@ u32 unique_tag = 0;;
  * to idle.  I don't know why this works and the other way doesn't.
  * (James Rose)
  */
-static void quick_stop (int minor)
+static void quick_stop(int minor)
 {
-  // TODO: scott was here
+  /* TODO: scott was here */
 #if 1
   ReadMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
   /* disable interrupts */
@@ -177,41 +177,38 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 
   /* find out who issued the interrupt */
   for (index = 0; index < ndevices; index++) {
-    if(dev_id == (void*) &dt3155_status[index])
-      {
-	minor = index;
-	break;
+	if (dev_id == (void *) &dt3155_status[index]) {
+		minor = index;
+		break;
       }
   }
 
   /* hopefully we should not get here */
   if (minor < 0 || minor >= MAXBOARDS) {
-    printk(KERN_ERR "dt3155_isr called with invalid dev_id\n");
+	printk(KERN_ERR "dt3155_isr called with invalid dev_id\n");
     return;
   }
 
   /* Check for corruption and set a flag if so */
   ReadMReg((dt3155_lbase[minor] + CSR1), csr1_r.reg);
 
-  if ((csr1_r.fld.FLD_CRPT_EVE) || (csr1_r.fld.FLD_CRPT_ODD))
-    {
-      /* TODO: this should probably stop acquisition */
-      /* and set some flags so that dt3155_read      */
-      /* returns an error next time it is called     */
-      dt3155_errno = DT_ERR_CORRUPT;
-      printk("dt3155:  corrupt field\n");
-      return;
+  if ((csr1_r.fld.FLD_CRPT_EVE) || (csr1_r.fld.FLD_CRPT_ODD)) {
+	/* TODO: this should probably stop acquisition
+	* and set some flags so that dt3155_read
+	* returns an error next time it is called.
+	 */
+	dt3155_errno = DT_ERR_CORRUPT;
+	printk(KERN_INFO "dt3155:  corrupt field\n");
+	return;
     }
 
   ReadMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
 
   /* Handle the even field ... */
-  if (int_csr_r.fld.FLD_END_EVE)
-    {
-      if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD)
-	{
-	  dt3155_fbuffer[minor]->frame_count++;
+  if (int_csr_r.fld.FLD_END_EVE) {
+	if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
+	   DT3155_STATE_FLD) {
+		dt3155_fbuffer[minor]->frame_count++;
 	}
 
       ReadI2C(dt3155_lbase[minor], EVEN_CSR, &i2c_even_csr.reg);
@@ -220,28 +217,23 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       int_csr_r.fld.FLD_END_EVE = 1;
 
       /* disable the interrupt if last field */
-      if (dt3155_fbuffer[minor]->stop_acquire)
-	{
-	  printk("dt3155:  even stopped.\n");
+      if (dt3155_fbuffer[minor]->stop_acquire) {
+	printk(KERN_INFO "dt3155:  even stopped.\n");
 	  dt3155_fbuffer[minor]->even_stopped = 1;
 	  if (i2c_even_csr.fld.SNGL_EVE)
-	    {
-	      int_csr_r.fld.FLD_END_EVE_EN = 0;
-	    }
+		int_csr_r.fld.FLD_END_EVE_EN = 0;
 	  else
-	    {
 	      i2c_even_csr.fld.SNGL_EVE  = 1;
-	    }
 	}
 
       WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
 
       /* Set up next DMA if we are doing FIELDS */
       if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD)
-	{
-	  /* GCS (Aug 2, 2002) -- In field mode, dma the odd field
-	     into the lower half of the buffer */
+	   DT3155_STATE_FLD) {
+		/* GCS (Aug 2, 2002) -- In field mode, dma the odd field
+		* into the lower half of the buffer.
+		*/
 	  const u32 stride =  dt3155_status[minor].config.cols;
 	  buffer_addr = dt3155_fbuffer[minor]->
 	    frame_info[dt3155_fbuffer[minor]->active_buf].addr
@@ -275,42 +267,35 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
     }
 
   /* ... now handle the odd field */
-  if (int_csr_r.fld.FLD_END_ODD)
-    {
-      ReadI2C(dt3155_lbase[minor], ODD_CSR, &i2c_odd_csr.reg);
+  if (int_csr_r.fld.FLD_END_ODD) {
+	ReadI2C(dt3155_lbase[minor], ODD_CSR, &i2c_odd_csr.reg);
 
       /* Clear the interrupt? */
       int_csr_r.fld.FLD_END_ODD = 1;
 
       if (dt3155_fbuffer[minor]->even_happened ||
 	  (dt3155_status[minor].state & DT3155_STATE_MODE) ==
-	  DT3155_STATE_FLD)
-	{
-	  dt3155_fbuffer[minor]->frame_count++;
+	  DT3155_STATE_FLD) {
+	dt3155_fbuffer[minor]->frame_count++;
 	}
 
       if (dt3155_fbuffer[minor]->stop_acquire &&
-	   dt3155_fbuffer[minor]->even_stopped)
-	{
-	  printk(KERN_DEBUG "dt3155:  stopping odd..\n");
-	  if (i2c_odd_csr.fld.SNGL_ODD)
-	    {
-	      /* disable interrupts */
-	      int_csr_r.fld.FLD_END_ODD_EN = 0;
-	      dt3155_status[minor].state &= ~(DT3155_STATE_STOP|0xff);
+	   dt3155_fbuffer[minor]->even_stopped) {
+		printk(KERN_DEBUG "dt3155:  stopping odd..\n");
+	if (i2c_odd_csr.fld.SNGL_ODD) {
+		/* disable interrupts */
+		int_csr_r.fld.FLD_END_ODD_EN = 0;
+		dt3155_status[minor].state &= ~(DT3155_STATE_STOP|0xff);
 
 	      /* mark the system stopped: */
-	      dt3155_status[minor].state |= DT3155_STATE_IDLE;
-	      dt3155_fbuffer[minor]->stop_acquire = 0;
-	      dt3155_fbuffer[minor]->even_stopped = 0;
-
-	      printk(KERN_DEBUG "dt3155:  state is now %x\n",
+		dt3155_status[minor].state |= DT3155_STATE_IDLE;
+		dt3155_fbuffer[minor]->stop_acquire = 0;
+		dt3155_fbuffer[minor]->even_stopped = 0;
+		printk(KERN_DEBUG "dt3155:  state is now %x\n",
 		     dt3155_status[minor].state);
 	    }
 	  else
-	    {
-	      i2c_odd_csr.fld.SNGL_ODD  = 1;
-	    }
+		  i2c_odd_csr.fld.SNGL_ODD  = 1;
 	}
 
       WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
@@ -320,24 +305,21 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       /* and wake up the process if sleeping          */
       if (dt3155_fbuffer[minor]->even_happened ||
 	   (dt3155_status[minor].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD)
-	{
-
-	  local_save_flags(flags);
-	  local_irq_disable();
+	   DT3155_STATE_FLD) {
+		local_save_flags(flags);
+		local_irq_disable();
 
 #ifdef DEBUG_QUES_B
 	  printques(minor);
 #endif
-	  if (dt3155_fbuffer[minor]->nbuffers > 2)
-	    {
-	      if (!are_empty_buffers(minor))
-		{
-		  /* The number of active + locked buffers is
-		   * at most 2, and since there are none empty, there
-		   * must be at least nbuffers-2 ready buffers.
-		   * This is where we 'drop frames', oldest first. */
-		  push_empty(pop_ready(minor),  minor);
+	  if (dt3155_fbuffer[minor]->nbuffers > 2) {
+		if (!are_empty_buffers(minor)) {
+			/* The number of active + locked buffers is
+			* at most 2, and since there are none empty, there
+			* must be at least nbuffers-2 ready buffers.
+			* This is where we 'drop frames', oldest first.
+			*/
+			push_empty(pop_ready(minor),  minor);
 		}
 
 	      /* The ready_que can't be full, since we know
@@ -350,22 +332,20 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 		frame_info[dt3155_fbuffer[minor]->
 			    active_buf].tag = ++unique_tag;
 	    }
-	  else /* nbuffers == 2, special case */
-	    { /* There is 1 active buffer.
-	       * If there is a locked buffer, keep the active buffer
-	       * the same -- that means we drop a frame.
-	       */
-	      if (dt3155_fbuffer[minor]->locked_buf < 0)
-		{
-		  push_ready(minor,
+	  /* nbuffers == 2, special case */
+	  else {
+		/* There is 1 active buffer.
+		* If there is a locked buffer, keep the active buffer
+		* the same -- that means we drop a frame.
+		*/
+	      if (dt3155_fbuffer[minor]->locked_buf < 0) {
+			push_ready(minor,
 			      dt3155_fbuffer[minor]->active_buf);
-		  if (are_empty_buffers(minor))
-		    {
-		      dt3155_fbuffer[minor]->active_buf =
-			pop_empty(minor);
+		  if (are_empty_buffers(minor)) {
+			dt3155_fbuffer[minor]->active_buf =
+				pop_empty(minor);
 		    }
-		  else
-		    { /* no empty or locked buffers, so use a readybuf */
+		  else { /* no empty or locked buffers, so use a readybuf */
 		      dt3155_fbuffer[minor]->active_buf =
 			pop_ready(minor);
 		    }
@@ -388,12 +368,10 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       buffer_addr = dt3155_fbuffer[minor]->
 	frame_info[dt3155_fbuffer[minor]->active_buf].addr;
       if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD)
-	{
-	  WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START), buffer_addr);
+	   DT3155_STATE_FLD) {
+		WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START), buffer_addr);
 	}
-      else
-	{
+      else {
 	  WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START), buffer_addr);
 
 	  WriteMReg((dt3155_lbase[minor] + ODD_DMA_START), buffer_addr
@@ -410,7 +388,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       return;
     }
   /* If we get here, the Odd Field wasn't it either... */
-  printk("neither even nor odd.  shared perhaps?\n");
+  printk(KERN_INFO "neither even nor odd.  shared perhaps?\n");
 }
 
 /*****************************************************
@@ -423,32 +401,33 @@ static void dt3155_init_isr(int minor)
 {
   const u32 stride =  dt3155_status[minor].config.cols;
 
-  switch (dt3155_status[minor].state & DT3155_STATE_MODE)
-    {
-    case DT3155_STATE_FLD:
-      {
-	even_dma_start_r  = dt3155_status[minor].
-	  fbuffer.frame_info[dt3155_status[minor].fbuffer.active_buf].addr;
-	even_dma_stride_r = 0;
-	odd_dma_stride_r  = 0;
 
-	WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START),
-		  even_dma_start_r);
-	WriteMReg((dt3155_lbase[minor] + EVEN_DMA_STRIDE),
-		  even_dma_stride_r);
-	WriteMReg((dt3155_lbase[minor] + ODD_DMA_STRIDE),
-		  odd_dma_stride_r);
-	break;
-      }
+	switch (dt3155_status[minor].state & DT3155_STATE_MODE) {
+	case DT3155_STATE_FLD:
+	{
+		even_dma_start_r  = dt3155_status[minor].
+		fbuffer.frame_info[dt3155_status[minor].
+		fbuffer.active_buf].addr;
+		even_dma_stride_r = 0;
+		odd_dma_stride_r  = 0;
+		WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START),
+		even_dma_start_r);
+		WriteMReg((dt3155_lbase[minor] + EVEN_DMA_STRIDE),
+		even_dma_stride_r);
+		WriteMReg((dt3155_lbase[minor] + ODD_DMA_STRIDE),
+		odd_dma_stride_r);
+		break;
+	}
 
-    case DT3155_STATE_FRAME:
-    default:
-      {
-	even_dma_start_r  = dt3155_status[minor].
-	  fbuffer.frame_info[dt3155_status[minor].fbuffer.active_buf].addr;
-	odd_dma_start_r   =  even_dma_start_r + stride;
-	even_dma_stride_r =  stride;
-	odd_dma_stride_r  =  stride;
+	case DT3155_STATE_FRAME:
+	default:
+	{
+		even_dma_start_r  = dt3155_status[minor].
+		fbuffer.frame_info[dt3155_status[minor].
+		fbuffer.active_buf].addr;
+		odd_dma_start_r   =  even_dma_start_r + stride;
+		even_dma_stride_r =  stride;
+		odd_dma_stride_r  =  stride;
 
 	WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START),
 		  even_dma_start_r);
@@ -487,7 +466,7 @@ static void dt3155_init_isr(int minor)
   csr1_r.fld.FLD_CRPT_EVE   = 1; /* writing a 1 clears flags */
   csr1_r.fld.FLD_CRPT_ODD   = 1;
 
-  WriteMReg((dt3155_lbase[minor] + CSR1),csr1_r.reg);
+  WriteMReg((dt3155_lbase[minor] + CSR1), csr1_r.reg);
 
   /* Enable interrupts at the end of each field */
 
@@ -523,13 +502,12 @@ static int dt3155_ioctl(struct inode *inode,
   int minor = MINOR(inode->i_rdev); /* What device are we ioctl()'ing? */
 
   if (minor >= MAXBOARDS || minor < 0)
-    return -ENODEV;
+	return -ENODEV;
 
   /* make sure it is valid command */
-  if (_IOC_NR(cmd) > DT3155_IOC_MAXNR)
-    {
-      printk("DT3155: invalid IOCTL(0x%x)\n",cmd);
-      printk("DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
+  if (_IOC_NR(cmd) > DT3155_IOC_MAXNR) {
+	printk(KERN_INFO "DT3155: invalid IOCTL(0x%x)\n", cmd);
+	printk(KERN_INFO "DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
 	     (unsigned int)DT3155_GET_CONFIG,
 	     (unsigned int)DT3155_SET_CONFIG,
 	     (unsigned int)DT3155_START,
@@ -538,87 +516,78 @@ static int dt3155_ioctl(struct inode *inode,
       return -EINVAL;
     }
 
-  switch (cmd)
-    {
-    case DT3155_SET_CONFIG:
-      {
-	if (dt3155_status[minor].state != DT3155_STATE_IDLE)
-	  return -EBUSY;
-
+	switch (cmd) {
+	case DT3155_SET_CONFIG:
 	{
-	  struct dt3155_config tmp;
-	  if (copy_from_user((void *)&tmp, (void *) arg, sizeof(tmp)))
-	      return -EFAULT;
-	  /* check for valid settings */
-	  if (tmp.rows > DT3155_MAX_ROWS ||
-	      tmp.cols > DT3155_MAX_COLS ||
-	      (tmp.acq_mode != DT3155_MODE_FRAME &&
-	       tmp.acq_mode != DT3155_MODE_FIELD) ||
-	      (tmp.continuous != DT3155_SNAP &&
-	       tmp.continuous != DT3155_ACQ))
-	    {
-	      return -EINVAL;
+		if (dt3155_status[minor].state != DT3155_STATE_IDLE)
+			return -EBUSY;
+
+		struct dt3155_config tmp;
+		if (copy_from_user((void *)&tmp, (void *) arg, sizeof(tmp)))
+			return -EFAULT;
+		/* check for valid settings */
+		if (tmp.rows > DT3155_MAX_ROWS ||
+		tmp.cols > DT3155_MAX_COLS ||
+		(tmp.acq_mode != DT3155_MODE_FRAME &&
+		tmp.acq_mode != DT3155_MODE_FIELD) ||
+		(tmp.continuous != DT3155_SNAP &&
+		tmp.continuous != DT3155_ACQ)) {
+			return -EINVAL;
 	    }
 	  dt3155_status[minor].config = tmp;
-	}
 	return 0;
-      }
-    case DT3155_GET_CONFIG:
-      {
-	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
+	}
+	case DT3155_GET_CONFIG:
+	{
+		if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
 		     sizeof(struct dt3155_status)))
-	    return -EFAULT;
+			return -EFAULT;
 	return 0;
-      }
-    case DT3155_FLUSH: /* Flushes the buffers -- ensures fresh data */
-      {
-	if (dt3155_status[minor].state != DT3155_STATE_IDLE)
-	  return -EBUSY;
+	}
+	case DT3155_FLUSH: /* Flushes the buffers -- ensures fresh data */
+	{
+		if (dt3155_status[minor].state != DT3155_STATE_IDLE)
+			return -EBUSY;
 	return dt3155_flush(minor);
-      }
-    case DT3155_STOP:
-      {
-	if (dt3155_status[minor].state & DT3155_STATE_STOP ||
-	    dt3155_status[minor].fbuffer.stop_acquire)
-	  return -EBUSY;
-
-	if (dt3155_status[minor].state == DT3155_STATE_IDLE)
-	  return 0;
-
-	quick_stop(minor);
-	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
+	}
+	case DT3155_STOP:
+	{
+		if (dt3155_status[minor].state & DT3155_STATE_STOP ||
+				dt3155_status[minor].fbuffer.stop_acquire)
+			return -EBUSY;
+		if (dt3155_status[minor].state == DT3155_STATE_IDLE)
+			return 0;
+
+		quick_stop(minor);
+		if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
 		     sizeof(struct dt3155_status)))
-	    return -EFAULT;
+			return -EFAULT;
 	return 0;
-      }
-    case DT3155_START:
-      {
-	if (dt3155_status[minor].state != DT3155_STATE_IDLE)
-	  return -EBUSY;
+	}
+	case DT3155_START:
+	{
+		if (dt3155_status[minor].state != DT3155_STATE_IDLE)
+			return -EBUSY;
 
-	dt3155_status[minor].fbuffer.stop_acquire = 0;
-	dt3155_status[minor].fbuffer.frame_count = 0;
+		dt3155_status[minor].fbuffer.stop_acquire = 0;
+		dt3155_status[minor].fbuffer.frame_count = 0;
 
 	/* Set the MODE in the status -- we default to FRAME */
 	if (dt3155_status[minor].config.acq_mode == DT3155_MODE_FIELD)
-	  {
-	    dt3155_status[minor].state = DT3155_STATE_FLD;
-	  }
+		dt3155_status[minor].state = DT3155_STATE_FLD;
 	else
-	  {
-	    dt3155_status[minor].state = DT3155_STATE_FRAME;
-	  }
+		dt3155_status[minor].state = DT3155_STATE_FRAME;
 
 	dt3155_init_isr(minor);
 	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
 		      sizeof(struct dt3155_status)))
-	    return -EFAULT;
+		return -EFAULT;
 	return 0;
-      }
-    default:
-      {
-	printk("DT3155: invalid IOCTL(0x%x)\n",cmd);
-      printk("DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
+	}
+	default:
+	{
+		printk(KERN_INFO "DT3155: invalid IOCTL(0x%x)\n", cmd);
+		printk(KERN_INFO "DT3155: Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
 	     (unsigned int)DT3155_GET_CONFIG,
 	     (unsigned int)DT3155_SET_CONFIG,
 	     DT3155_START, DT3155_STOP, DT3155_FLUSH);
@@ -637,7 +606,7 @@ static int dt3155_ioctl(struct inode *inode,
  * It *looks* like it should work but since I'm not
  * sure how to use it, I'm not actually sure. (NJC? ditto by SS)
  *****************************************************/
-static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
+static int dt3155_mmap(struct file *file, struct vm_area_struct *vma)
 {
   /* which device are we mmapping? */
   int				minor = MINOR(file->f_dentry->d_inode->i_rdev);
@@ -645,7 +614,7 @@ static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
   offset = vma->vm_pgoff << PAGE_SHIFT;
 
   if (offset >= __pa(high_memory) || (file->f_flags & O_SYNC))
-    vma->vm_flags |= VM_IO;
+	vma->vm_flags |= VM_IO;
 
   /* Don't try to swap out physical pages.. */
   vma->vm_flags |= VM_RESERVED;
@@ -654,20 +623,18 @@ static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
   if ((offset == dt3155_status[minor].reg_addr &&
        vma->vm_end - vma->vm_start == PCI_PAGE_SIZE) ||
       (offset == dt3155_status[minor].mem_addr &&
-       vma->vm_end - vma->vm_start == dt3155_status[minor].mem_size))
-    {
-      if (remap_pfn_range(vma,
+       vma->vm_end - vma->vm_start == dt3155_status[minor].mem_size)) {
+	if (remap_pfn_range(vma,
 			vma->vm_start,
 			offset >> PAGE_SHIFT,
 			vma->vm_end - vma->vm_start,
 			vma->vm_page_prot)) {
-	  printk("DT3155: remap_page_range() failed.\n");
-	  return -EAGAIN;
+		printk(KERN_INFO "DT3155: remap_page_range() failed.\n");
+		return -EAGAIN;
 	}
     }
-  else
-    {
-      printk("DT3155: dt3155_mmap() bad call.\n");
+  else {
+      printk(KERN_INFO "DT3155: dt3155_mmap() bad call.\n");
       return -ENXIO;
     }
 
@@ -682,28 +649,27 @@ static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
  * MOD_INC_USE_COUNT make sure that the driver memory is not freed
  * while the device is in use.
  *****************************************************/
-static int dt3155_open(struct inode* inode, struct file* filep)
+static int dt3155_open(struct inode *inode, struct file *filep)
 {
   int minor = MINOR(inode->i_rdev); /* what device are we opening? */
   if (dt3155_dev_open[minor]) {
-    printk ("DT3155:  Already opened by another process.\n");
+	printk(KERN_INFO "DT3155:  Already opened by another process.\n");
     return -EBUSY;
   }
 
-  if (dt3155_status[minor].device_installed==0)
-    {
-      printk("DT3155 Open Error: No such device dt3155 minor number %d\n",
+  if (dt3155_status[minor].device_installed == 0) {
+	printk(KERN_INFO "DT3155 Open Error: No such device dt3155 minor number %d\n",
 	     minor);
       return -EIO;
     }
 
   if (dt3155_status[minor].state != DT3155_STATE_IDLE) {
-    printk ("DT3155:  Not in idle state (state = %x)\n",
+	printk(KERN_INFO "DT3155:  Not in idle state (state = %x)\n",
 	    dt3155_status[minor].state);
     return -EBUSY;
   }
 
-  printk("DT3155: Device opened.\n");
+  printk(KERN_INFO "DT3155: Device opened.\n");
 
   dt3155_dev_open[minor] = 1 ;
 
@@ -730,18 +696,14 @@ static int dt3155_close(struct inode *inode, struct file *filep)
   int minor;
 
   minor = MINOR(inode->i_rdev); /* which device are we closing */
-  if (!dt3155_dev_open[minor])
-    {
-      printk("DT3155: attempt to CLOSE a not OPEN device\n");
+  if (!dt3155_dev_open[minor]) {
+	printk(KERN_INFO "DT3155: attempt to CLOSE a not OPEN device\n");
     }
-  else
-    {
+  else {
       dt3155_dev_open[minor] = 0;
 
       if (dt3155_status[minor].state != DT3155_STATE_IDLE)
-	{
-	  quick_stop(minor);
-	}
+		quick_stop(minor);
     }
   return 0;
 }
@@ -761,9 +723,8 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
 
   /* TODO: this should check the error flag and */
   /*   return an error on hardware failures */
-  if (count != sizeof(struct dt3155_read))
-    {
-      printk("DT3155 ERROR (NJC): count is not right\n");
+  if (count != sizeof(struct dt3155_read)) {
+	printk(KERN_INFO "DT3155 ERROR (NJC): count is not right\n");
       return -EINVAL;
     }
 
@@ -779,16 +740,15 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   /*    return -EBUSY;*/
 
   /* non-blocking reads should return if no data */
-  if (filep->f_flags & O_NDELAY)
-    {
-      if ((frame_index = dt3155_get_ready_buffer(minor)) < 0) {
-	/*printk("dt3155:  no buffers available (?)\n");*/
-	/* 		printques(minor); */
+  if (filep->f_flags & O_NDELAY) {
+	frame_index = dt3155_get_ready_buffer(minor);
+      if (frame_index < 0) {
+	/*	printk("dt3155:  no buffers available (?)\n");*/
+	/*	printques(minor); */
 	return -EAGAIN;
       }
     }
-  else
-    {
+  else {
       /*
        * sleep till data arrives , or we get interrupted.
        * Note that wait_event_interruptible() does not actually
@@ -798,12 +758,11 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
 			       (frame_index = dt3155_get_ready_buffer(minor))
 			       >= 0);
 
-      if (frame_index < 0)
-	{
-	  printk ("DT3155: read: interrupted\n");
-	  quick_stop (minor);
-	  printques(minor);
-	  return -EINTR;
+      if (frame_index < 0) {
+		printk(KERN_INFO "DT3155: read: interrupted\n");
+		quick_stop(minor);
+		printques(minor);
+		return -EINTR;
 	}
     }
 
@@ -819,19 +778,19 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   put_user(dt3155_status[minor].state, (unsigned int *) buf);
   buf += sizeof(u32);
   if (copy_to_user(buf, frame_info, sizeof(*frame_info)))
-      return -EFAULT;
+	return -EFAULT;
 
   return sizeof(struct dt3155_read);
 }
 
-static unsigned int dt3155_poll (struct file * filp, poll_table *wait)
+static unsigned int dt3155_poll(struct file *filp, poll_table *wait)
 {
   int minor = MINOR(filp->f_dentry->d_inode->i_rdev);
 
   if (!is_ready_buf_empty(minor))
-    return POLLIN | POLLRDNORM;
+	return POLLIN | POLLRDNORM;
 
-  poll_wait (filp, &dt3155_read_wait_queue[minor], wait);
+  poll_wait(filp, &dt3155_read_wait_queue[minor], wait);
 
   return 0;
 }
@@ -853,7 +812,7 @@ dt3155_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
  *  needed by init_module
  *  register_chrdev
  *****************************************************/
-static struct file_operations dt3155_fops = {
+static const struct file_operations dt3155_fops = {
 	.read		= dt3155_read,
 	.unlocked_ioctl	= dt3155_unlocked_ioctl,
 	.mmap		= dt3155_mmap,
@@ -868,7 +827,7 @@ static struct file_operations dt3155_fops = {
  *
  * PCI has been totally reworked in 2.1..
  *****************************************************/
-static int find_PCI (void)
+static int find_PCI(void)
 {
   struct pci_dev *pci_dev = NULL;
   int error, pci_index = 0;
@@ -877,22 +836,22 @@ static int find_PCI (void)
   unsigned char irq;
 
   while ((pci_dev = pci_get_device
-	  (DT3155_VENDORID, DT3155_DEVICEID, pci_dev)) != NULL)
-    {
-      pci_index ++;
+		(DT3155_VENDORID, DT3155_DEVICEID, pci_dev)) != NULL) {
+		pci_index++;
 
       /* Is it really there? */
-      if ((error =
-	   pci_read_config_word(pci_dev, PCI_CLASS_DEVICE, &rev_device)))
+      error = pci_read_config_word(pci_dev, PCI_CLASS_DEVICE, &rev_device);
+      if (error)
 	continue;
 
       /* Found a board */
-      DT_3155_DEBUG_MSG("DT3155: Device number %d \n", pci_index);
+      DT_3155_DEBUG_MSG("DT3155: Device number %d\n", pci_index);
 
       /* Make sure the driver was compiled with enough buffers to handle
 	 this many boards */
       if (pci_index > MAXBOARDS) {
-	printk("DT3155: ERROR - found %d devices, but driver only configured "
+	printk(KERN_INFO "DT3155: ERROR - found %d devices,
+			but driver only configured "
 	       "for %d devices\n"
 	       "DT3155: Please change MAXBOARDS in dt3155.h\n",
 	       pci_index, MAXBOARDS);
@@ -901,39 +860,38 @@ static int find_PCI (void)
 
       /* Now, just go out and make sure that this/these device(s) is/are
 	 actually mapped into the kernel address space */
-      if ((error = pci_read_config_dword(pci_dev, PCI_BASE_ADDRESS_0,
-					  (u32 *) &base)))
-	{
-	  printk("DT3155: Was not able to find device \n");
+      error = pci_read_config_dword(pci_dev, PCI_BASE_ADDRESS_0,
+					  (u32 *) &base);
+      if (error) {
+		printk(KERN_INFO "DT3155: Was not able to find device\n");
 	  goto err;
 	}
 
-      DT_3155_DEBUG_MSG("DT3155: Base address 0 for device is %lx \n", base);
+      DT_3155_DEBUG_MSG("DT3155: Base address 0 for device is %lx\n", base);
       dt3155_status[pci_index-1].reg_addr = base;
 
       /* Remap the base address to a logical address through which we
        * can access it. */
-      dt3155_lbase[pci_index - 1] = ioremap(base,PCI_PAGE_SIZE);
+      dt3155_lbase[pci_index - 1] = ioremap(base, PCI_PAGE_SIZE);
       dt3155_status[pci_index - 1].reg_addr = base;
-      DT_3155_DEBUG_MSG("DT3155: New logical address is %p \n",
+      DT_3155_DEBUG_MSG("DT3155: New logical address is %p\n",
 			dt3155_lbase[pci_index-1]);
-      if (!dt3155_lbase[pci_index-1])
-	{
-	  printk("DT3155: Unable to remap control registers\n");
-	  goto err;
+      if (!dt3155_lbase[pci_index-1]) {
+		printk(KERN_INFO "DT3155: Unable to remap control registers\n");
+		goto err;
 	}
 
-      if ((error = pci_read_config_byte(pci_dev, PCI_INTERRUPT_LINE, &irq)))
-	{
-	  printk("DT3155: Was not able to find device \n");
-	  goto err;
+      error = pci_read_config_byte(pci_dev, PCI_INTERRUPT_LINE, &irq);
+      if (error) {
+		printk(KERN_INFO "DT3155: Was not able to find device\n");
+		goto err;
 	}
 
-      DT_3155_DEBUG_MSG("DT3155: IRQ is %d \n",irq);
+      DT_3155_DEBUG_MSG("DT3155: IRQ is %d\n", irq);
       dt3155_status[pci_index-1].irq = irq;
       /* Set flag: kth device found! */
       dt3155_status[pci_index-1].device_installed = 1;
-      printk("DT3155: Installing device %d w/irq %d and address %p\n",
+      printk(KERN_INFO "DT3155: Installing device %d w/irq %d and address %p\n",
 	     pci_index,
 	     dt3155_status[pci_index-1].irq,
 	     dt3155_lbase[pci_index-1]);
@@ -964,96 +922,94 @@ int init_module(void)
   devname[1] = "dt3155b";
 #endif
 
-  printk("DT3155: Loading module...\n");
+  printk(KERN_INFO "DT3155: Loading module...\n");
 
   /* Register the device driver */
   rcode = register_chrdev(dt3155_major, "dt3155", &dt3155_fops);
-  if(rcode < 0)
-    {
-      printk(KERN_INFO "DT3155: register_chrdev failed \n");
-      return rcode;
+  if (rcode < 0) {
+	printk(KERN_INFO "DT3155: register_chrdev failed\n");
+	return rcode;
     }
 
-  if(dt3155_major == 0)
-    dt3155_major = rcode; /* dynamic */
+  if (dt3155_major == 0)
+	dt3155_major = rcode; /* dynamic */
 
 
   /* init the status variables.                     */
   /* DMA memory is taken care of in setup_buffers() */
-  for (index = 0; index < MAXBOARDS; index++)
-    {
-      dt3155_status[index].config.acq_mode   = DT3155_MODE_FRAME;
-      dt3155_status[index].config.continuous = DT3155_ACQ;
-      dt3155_status[index].config.cols       = DT3155_MAX_COLS;
-      dt3155_status[index].config.rows       = DT3155_MAX_ROWS;
-      dt3155_status[index].state = DT3155_STATE_IDLE;
+  for (index = 0; index < MAXBOARDS; index++) {
+	dt3155_status[index].config.acq_mode   = DT3155_MODE_FRAME;
+	dt3155_status[index].config.continuous = DT3155_ACQ;
+	dt3155_status[index].config.cols       = DT3155_MAX_COLS;
+	dt3155_status[index].config.rows       = DT3155_MAX_ROWS;
+	dt3155_status[index].state = DT3155_STATE_IDLE;
 
       /* find_PCI() will check if devices are installed; */
       /* first assume they're not:                       */
-      dt3155_status[index].mem_addr          = 0;
-      dt3155_status[index].mem_size          = 0;
-      dt3155_status[index].state             = DT3155_STATE_IDLE;
-      dt3155_status[index].device_installed  = 0;
+	dt3155_status[index].mem_addr          = 0;
+	dt3155_status[index].mem_size          = 0;
+	dt3155_status[index].state             = DT3155_STATE_IDLE;
+	dt3155_status[index].device_installed  = 0;
     }
 
   /* Now let's find the hardware.  find_PCI() will set ndevices to the
    * number of cards found in this machine. */
     {
-      if ((rcode = find_PCI()) !=  DT_3155_SUCCESS)
-	{
-	  printk("DT3155 error: find_PCI() failed to find dt3155 board(s)\n");
+      rcode = find_PCI();
+      if (rcode !=  DT_3155_SUCCESS) {
+		printk(KERN_INFO "DT3155 error: find_PCI() failed to find dt3155 board(s)\n");
 	  unregister_chrdev(dt3155_major, "dt3155");
 	  return rcode;
 	}
     }
 
   /* Ok, time to setup the frame buffers */
-  if((rcode = dt3155_setup_buffers(&allocatorAddr)) < 0)
-    {
-      printk("DT3155: Error: setting up buffer not large enough.");
+  rcode = dt3155_setup_buffers(&allocatorAddr);
+  if (rcode < 0) {
+	printk(KERN_INFO "DT3155: Error: setting up buffer not large enough.");
       unregister_chrdev(dt3155_major, "dt3155");
       return rcode;
     }
 
   /* If we are this far, then there is enough RAM */
   /* for the buffers: Print the configuration.    */
-  for( index = 0;  index < ndevices;  index++)
-    {
-      printk("DT3155: Device = %d; acq_mode = %d; "
-	     "continuous = %d; cols = %d; rows = %d;\n",
-	     index ,
-	     dt3155_status[index].config.acq_mode,
-	     dt3155_status[index].config.continuous,
-	     dt3155_status[index].config.cols,
-	     dt3155_status[index].config.rows);
-      printk("DT3155: m_addr = 0x%x; m_size = %ld; "
-	     "state = %d; device_installed = %d\n",
-	     dt3155_status[index].mem_addr,
-	     (long int)dt3155_status[index].mem_size,
-	     dt3155_status[index].state,
-	     dt3155_status[index].device_installed);
+  for (index = 0;  index < ndevices;  index++) {
+		printk(KERN_INFO "DT3155: Device = %d; acq_mode = %d; "
+		"continuous = %d; cols = %d; rows = %d;\n",
+		index ,
+		dt3155_status[index].config.acq_mode,
+		dt3155_status[index].config.continuous,
+		dt3155_status[index].config.cols,
+		dt3155_status[index].config.rows);
+		printk(KERN_INFO "DT3155: m_addr = 0x%x; m_size = %ld; "
+				"state = %d; device_installed = %d\n",
+				dt3155_status[index].mem_addr,
+				(long int)dt3155_status[index].mem_size,
+				dt3155_status[index].state,
+				dt3155_status[index].device_installed);
     }
 
   /* Disable ALL interrupts */
   int_csr_r.reg = 0;
-  for( index = 0;  index < ndevices;  index++)
-    {
-      WriteMReg((dt3155_lbase[index] + INT_CSR), int_csr_r.reg);
-      if(dt3155_status[index].device_installed)
-	{
-	  /*
-	   * This driver *looks* like it can handle sharing interrupts,
-	   * but I can't actually test myself. I've had reports that it
-	   * DOES work so I'll enable it for now. This comment will remain
-	   * as a reminder in case any problems arise. (SS)
-	   */
-	  /* in older kernels flags are: SA_SHIRQ | SA_INTERRUPT */
-	  rcode = request_irq(dt3155_status[index].irq, (void *)dt3155_isr,
+  for (index = 0;  index < ndevices;  index++) {
+		WriteMReg((dt3155_lbase[index] + INT_CSR), int_csr_r.reg);
+      if (dt3155_status[index].device_installed) {
+		/*
+		   * This driver *looks* like it can handle sharing interrupts,
+		   * but I can't actually test myself. I've had reports that it
+		   * DOES work so I'll enable it for now.
+		   * This comment will remain
+		   * as a reminder in case any problems arise. (SS)
+		   */
+		/*
+		   * in older kernels flags are: SA_SHIRQ | SA_INTERRUPT
+		*/
+			rcode = request_irq(dt3155_status[index].irq,
+				(void *)dt3155_isr,
 			       IRQF_SHARED | IRQF_DISABLED, devname[index],
-			       (void*) &dt3155_status[index]);
-	  if(rcode < 0)
-	    {
-	      printk("DT3155: minor %d request_irq failed for IRQ %d\n",
+			       (void *) &dt3155_status[index]);
+	  if (rcode < 0) {
+		printk(KERN_INFO "DT3155: minor %d request_irq failed for IRQ %d\n",
 		     index, dt3155_status[index].irq);
 	      unregister_chrdev(dt3155_major, "dt3155");
 	      return rcode;
@@ -1061,7 +1017,7 @@ int init_module(void)
 	}
     }
 
-  printk("DT3155: finished loading\n");
+  printk(KERN_INFO "DT3155: finished loading\n");
 
   return 0;
 }
@@ -1074,25 +1030,23 @@ void cleanup_module(void)
 {
   int index;
 
-  printk("DT3155:  cleanup_module called\n");
+  printk(KERN_INFO "DT3155:  cleanup_module called\n");
 
   /* removed DMA allocated with the allocator */
 #ifdef STANDALONE_ALLOCATOR
   if (allocatorAddr != 0)
-    allocator_free_dma(allocatorAddr);
+		allocator_free_dma(allocatorAddr);
 #else
   allocator_cleanup();
 #endif
 
   unregister_chrdev(dt3155_major, "dt3155");
 
-  for(index = 0; index < ndevices; index++)
-    {
-      if(dt3155_status[index].device_installed == 1)
-	{
-	  printk("DT3155: Freeing irq %d for device %d\n",
-		  dt3155_status[index].irq, index);
-	  free_irq(dt3155_status[index].irq, (void*)&dt3155_status[index]);
+  for (index = 0; index < ndevices; index++) {
+	if (dt3155_status[index].device_installed == 1) {
+		printk(KERN_INFO "DT3155: Freeing irq %d for device %d\n",
+		 dt3155_status[index].irq, index);
+	  free_irq(dt3155_status[index].irq, (void *)&dt3155_status[index]);
 	}
     }
 }
-- 
1.5.6.5

