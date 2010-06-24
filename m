Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab0FXQda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:33:30 -0400
Received: from p01c12o144.mxlogic.net ([208.65.145.67]:44205 "EHLO
	p01c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab0FXQd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:33:28 -0400
X-MXL-Hash: 4c2388d855d6dce5-c2589b6cd82928f589a8f69340c7fddd6e35d462
X-MXL-Hash: 4c2388cd1cf59750-cbc88dd37a3311e0074fcf7d4a44e0d8df80834c
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: d53155_drv.c: cleanup fbuffer usage
Date: Thu, 24 Jun 2010 09:31:13 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201006240931.13833.hartleys@visionengravers.com>
X-Spam: [F=0.2278786122; CM=0.500; S=0.227(2010062201)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.180]
X-AnalysisOut: [v=1.0 c=1 a=_nYCMCr01AYA:10 a=GQCbJdZ--msA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=38uLcFpo6nJaFUi5eYvXHw==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=p5I7jlFuPVvjtnRJ48AA:9 a=QGbVXIlrib2XUXMo-t]
X-AnalysisOut: [8A:7 a=DqfX0VC3TbXZ8jeAvpw6GoGwRv0A:4 a=QEXdDO2ut3YA:10 a=]
X-AnalysisOut: [x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The global symbol dt3155_fbuffer[], declared in dt3155_isr.c, is really
just a pointer to dt3155_status[].fbuffer. To improve readability, make
some of the really long lines shorter, and make the buffer access more
consistent, use &dt3155_status[].fbuffer to access the buffer structure.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 88c9e59..f19cc1f 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -135,6 +135,8 @@ u32 unique_tag = 0;;
  */
 static void quick_stop (int minor)
 {
+  struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+
   // TODO: scott was here
 #if 1
   int_csr_r.reg = readl(dt3155_lbase[minor] + INT_CSR);
@@ -146,11 +148,11 @@ static void quick_stop (int minor)
   dt3155_status[minor].state &= ~(DT3155_STATE_STOP|0xff);
   /* mark the system stopped: */
   dt3155_status[minor].state |= DT3155_STATE_IDLE;
-  dt3155_fbuffer[minor]->stop_acquire = 0;
-  dt3155_fbuffer[minor]->even_stopped = 0;
+  fb->stop_acquire = 0;
+  fb->even_stopped = 0;
 #else
   dt3155_status[minor].state |= DT3155_STATE_STOP;
-  dt3155_status[minor].fbuffer.stop_acquire = 1;
+  fb->stop_acquire = 1;
 #endif
 
 }
@@ -170,6 +172,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
   unsigned long flags;
   u32 buffer_addr;
   void __iomem *mmio;
+  struct dt3155_fbuffer *fb;
 
   /* find out who issued the interrupt */
   for (index = 0; index < ndevices; index++) {
@@ -187,6 +190,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
   }
 
   mmio = dt3155_lbase[minor];
+  fb = &dt3155_status[minor].fbuffer;
 
   /* Check for corruption and set a flag if so */
   csr1_r.reg = readl(mmio + CSR1);
@@ -209,7 +213,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
 	   DT3155_STATE_FLD)
 	{
-	  dt3155_fbuffer[minor]->frame_count++;
+	  fb->frame_count++;
 	}
 
       ReadI2C(mmio, EVEN_CSR, &i2c_even_csr.reg);
@@ -218,10 +222,10 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       int_csr_r.fld.FLD_END_EVE = 1;
 
       /* disable the interrupt if last field */
-      if (dt3155_fbuffer[minor]->stop_acquire)
+      if (fb->stop_acquire)
 	{
 	  printk("dt3155:  even stopped.\n");
-	  dt3155_fbuffer[minor]->even_stopped = 1;
+	  fb->even_stopped = 1;
 	  if (i2c_even_csr.fld.SNGL_EVE)
 	    {
 	      int_csr_r.fld.FLD_END_EVE_EN = 0;
@@ -241,9 +245,8 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 	  /* GCS (Aug 2, 2002) -- In field mode, dma the odd field
 	     into the lower half of the buffer */
 	  const u32 stride =  dt3155_status[minor].config.cols;
-	  buffer_addr = dt3155_fbuffer[minor]->
-	    frame_info[dt3155_fbuffer[minor]->active_buf].addr
-	    + (DT3155_MAX_ROWS / 2) * stride;
+	  buffer_addr = fb->frame_info[fb->active_buf].addr +
+			(DT3155_MAX_ROWS / 2) * stride;
 	  local_save_flags(flags);
 	  local_irq_disable();
 	  wake_up_interruptible(&dt3155_read_wait_queue[minor]);
@@ -262,13 +265,11 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 
       /* Note that we actually saw an even field meaning  */
       /* that subsequent odd field complete the frame     */
-      dt3155_fbuffer[minor]->even_happened = 1;
+      fb->even_happened = 1;
 
       /* recording the time that the even field finished, this should be */
       /* about time in the middle of the frame */
-      do_gettimeofday(&(dt3155_fbuffer[minor]->
-			 frame_info[dt3155_fbuffer[minor]->
-				     active_buf].time));
+      do_gettimeofday(&fb->frame_info[fb->active_buf].time);
       return;
     }
 
@@ -280,15 +281,14 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       /* Clear the interrupt? */
       int_csr_r.fld.FLD_END_ODD = 1;
 
-      if (dt3155_fbuffer[minor]->even_happened ||
+      if (fb->even_happened ||
 	  (dt3155_status[minor].state & DT3155_STATE_MODE) ==
 	  DT3155_STATE_FLD)
 	{
-	  dt3155_fbuffer[minor]->frame_count++;
+	  fb->frame_count++;
 	}
 
-      if (dt3155_fbuffer[minor]->stop_acquire &&
-	   dt3155_fbuffer[minor]->even_stopped)
+      if (fb->stop_acquire && fb->even_stopped)
 	{
 	  printk(KERN_DEBUG "dt3155:  stopping odd..\n");
 	  if (i2c_odd_csr.fld.SNGL_ODD)
@@ -299,8 +299,8 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 
 	      /* mark the system stopped: */
 	      dt3155_status[minor].state |= DT3155_STATE_IDLE;
-	      dt3155_fbuffer[minor]->stop_acquire = 0;
-	      dt3155_fbuffer[minor]->even_stopped = 0;
+	      fb->stop_acquire = 0;
+	      fb->even_stopped = 0;
 
 	      printk(KERN_DEBUG "dt3155:  state is now %x\n",
 		     dt3155_status[minor].state);
@@ -316,7 +316,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       /* if the odd field has been acquired, then     */
       /* change the next dma location for both fields */
       /* and wake up the process if sleeping          */
-      if (dt3155_fbuffer[minor]->even_happened ||
+      if (fb->even_happened ||
 	   (dt3155_status[minor].state & DT3155_STATE_MODE) ==
 	   DT3155_STATE_FLD)
 	{
@@ -327,7 +327,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 #ifdef DEBUG_QUES_B
 	  printques(minor);
 #endif
-	  if (dt3155_fbuffer[minor]->nbuffers > 2)
+	  if (fb->nbuffers > 2)
 	    {
 	      if (!are_empty_buffers(minor))
 		{
@@ -341,31 +341,26 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 	      /* The ready_que can't be full, since we know
 	       * there is one active buffer right now, so it's safe
 	       * to push the active buf on the ready_que. */
-	      push_ready(minor, dt3155_fbuffer[minor]->active_buf);
+	      push_ready(minor, fb->active_buf);
 	      /* There's at least 1 empty -- make it active */
-	      dt3155_fbuffer[minor]->active_buf = pop_empty(minor);
-	      dt3155_fbuffer[minor]->
-		frame_info[dt3155_fbuffer[minor]->
-			    active_buf].tag = ++unique_tag;
+	      fb->active_buf = pop_empty(minor);
+	      fb->frame_info[fb->active_buf].tag = ++unique_tag;
 	    }
 	  else /* nbuffers == 2, special case */
 	    { /* There is 1 active buffer.
 	       * If there is a locked buffer, keep the active buffer
 	       * the same -- that means we drop a frame.
 	       */
-	      if (dt3155_fbuffer[minor]->locked_buf < 0)
+	      if (fb->locked_buf < 0)
 		{
-		  push_ready(minor,
-			      dt3155_fbuffer[minor]->active_buf);
+		  push_ready(minor, fb->active_buf);
 		  if (are_empty_buffers(minor))
 		    {
-		      dt3155_fbuffer[minor]->active_buf =
-			pop_empty(minor);
+		      fb->active_buf = pop_empty(minor);
 		    }
 		  else
 		    { /* no empty or locked buffers, so use a readybuf */
-		      dt3155_fbuffer[minor]->active_buf =
-			pop_ready(minor);
+		      fb->active_buf = pop_ready(minor);
 		    }
 		}
 	    }
@@ -374,7 +369,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 	  printques(minor);
 #endif
 
-	  dt3155_fbuffer[minor]->even_happened = 0;
+	  fb->even_happened = 0;
 
 	  wake_up_interruptible(&dt3155_read_wait_queue[minor]);
 
@@ -383,8 +378,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 
 
       /* Set up the DMA address for the next frame/field */
-      buffer_addr = dt3155_fbuffer[minor]->
-	frame_info[dt3155_fbuffer[minor]->active_buf].addr;
+      buffer_addr = fb->frame_info[fb->active_buf].addr;
       if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
 	   DT3155_STATE_FLD)
 	{
@@ -421,13 +415,13 @@ static void dt3155_init_isr(int minor)
 {
   const u32 stride =  dt3155_status[minor].config.cols;
   void __iomem *mmio = dt3155_lbase[minor];
+  struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
 
   switch (dt3155_status[minor].state & DT3155_STATE_MODE)
     {
     case DT3155_STATE_FLD:
       {
-	even_dma_start_r  = dt3155_status[minor].
-	  fbuffer.frame_info[dt3155_status[minor].fbuffer.active_buf].addr;
+	even_dma_start_r  = fb->frame_info[fb->active_buf].addr;
 	even_dma_stride_r = 0;
 	odd_dma_stride_r  = 0;
 
@@ -440,8 +434,7 @@ static void dt3155_init_isr(int minor)
     case DT3155_STATE_FRAME:
     default:
       {
-	even_dma_start_r  = dt3155_status[minor].
-	  fbuffer.frame_info[dt3155_status[minor].fbuffer.active_buf].addr;
+	even_dma_start_r  = fb->frame_info[fb->active_buf].addr;
 	odd_dma_start_r   =  even_dma_start_r + stride;
 	even_dma_stride_r =  stride;
 	odd_dma_stride_r  =  stride;
@@ -514,6 +507,7 @@ static int dt3155_ioctl(struct inode *inode,
 {
   int minor = MINOR(inode->i_rdev); /* What device are we ioctl()'ing? */
   void __user *up = (void __user *)arg;
+  struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
 
   if (minor >= MAXBOARDS || minor < 0)
     return -ENODEV;
@@ -572,7 +566,7 @@ static int dt3155_ioctl(struct inode *inode,
     case DT3155_STOP:
       {
 	if (dt3155_status[minor].state & DT3155_STATE_STOP ||
-	    dt3155_status[minor].fbuffer.stop_acquire)
+	    fb->stop_acquire)
 	  return -EBUSY;
 
 	if (dt3155_status[minor].state == DT3155_STATE_IDLE)
@@ -589,8 +583,8 @@ static int dt3155_ioctl(struct inode *inode,
 	if (dt3155_status[minor].state != DT3155_STATE_IDLE)
 	  return -EBUSY;
 
-	dt3155_status[minor].fbuffer.stop_acquire = 0;
-	dt3155_status[minor].fbuffer.frame_count = 0;
+	fb->stop_acquire = 0;
+	fb->frame_count = 0;
 
 	/* Set the MODE in the status -- we default to FRAME */
 	if (dt3155_status[minor].config.acq_mode == DT3155_MODE_FIELD)
@@ -750,6 +744,7 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   int		minor = MINOR(filep->f_dentry->d_inode->i_rdev);
   u32		offset;
   int		frame_index;
+  struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
   struct frame_info	*frame_info;
 
   /* TODO: this should check the error flag and */
@@ -800,14 +795,14 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
 	}
     }
 
-  frame_info = &dt3155_status[minor].fbuffer.frame_info[frame_index];
+  frame_info = &fb->frame_info[frame_index];
 
   /* make this an offset */
   offset = frame_info->addr - dt3155_status[minor].mem_addr;
 
   put_user(offset, (unsigned int __user *)buf);
   buf += sizeof(u32);
-  put_user(dt3155_status[minor].fbuffer.frame_count, (unsigned int __user *)buf);
+  put_user(fb->frame_count, (unsigned int __user *)buf);
   buf += sizeof(u32);
   put_user(dt3155_status[minor].state, (unsigned int __user *)buf);
   buf += sizeof(u32);
