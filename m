Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab0FYRAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 13:00:43 -0400
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:46296 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab0FYRAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 13:00:41 -0400
X-MXL-Hash: 4c24e0b96e5a3544-84b36037783300763b0d2139a2013f50c77b8448
X-MXL-Hash: 4c24e0ac0a64b882-3f0e4062851df827606fcfc7513c1610c5627607
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: dt3155_drv.c: dereference dt3155_status[]
Date: Fri, 25 Jun 2010 09:59:33 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201006250959.34279.hartleys@visionengravers.com>
X-Spam: [F=0.2147891344; CM=0.500; S=0.214(2010062201)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.69]
X-AnalysisOut: [v=1.0 c=1 a=igE2JTYsi3YA:10 a=UBIxAjGgU1YA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=TYbMNos9eHUa9bm6/o8foQ==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=7GuO_crRqup-dRxMjIkA:9 a=cUt60NmyOF788Mla_j]
X-AnalysisOut: [wA:7 a=APRfd2rkatN7-HJDzG9CLss35-YA:4 a=QEXdDO2ut3YA:10 a=]
X-AnalysisOut: [x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10 a=fuEp3xXfZzHhArAI:21 a=]
X-AnalysisOut: [d1kJGlbVTeNViLnu:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where used, dereference the global symbol dt3155_status[] as a local
pointer.  This improves the readability of the code and reduces the
overall length of some of the really long lines.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index f19cc1f..6d35a6f 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -135,7 +135,8 @@ u32 unique_tag = 0;;
  */
 static void quick_stop (int minor)
 {
-  struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+  struct dt3155_status *dts = &dt3155_status[minor];
+  struct dt3155_fbuffer *fb = &dts->fbuffer;
 
   // TODO: scott was here
 #if 1
@@ -145,13 +146,13 @@ static void quick_stop (int minor)
   int_csr_r.fld.FLD_END_ODD_EN = 0;
   writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);
 
-  dt3155_status[minor].state &= ~(DT3155_STATE_STOP|0xff);
+  dts->state &= ~(DT3155_STATE_STOP|0xff);
   /* mark the system stopped: */
-  dt3155_status[minor].state |= DT3155_STATE_IDLE;
+  dts->state |= DT3155_STATE_IDLE;
   fb->stop_acquire = 0;
   fb->even_stopped = 0;
 #else
-  dt3155_status[minor].state |= DT3155_STATE_STOP;
+  dts->state |= DT3155_STATE_STOP;
   fb->stop_acquire = 1;
 #endif
 
@@ -172,6 +173,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
   unsigned long flags;
   u32 buffer_addr;
   void __iomem *mmio;
+  struct dt3155_status *dts;
   struct dt3155_fbuffer *fb;
 
   /* find out who issued the interrupt */
@@ -190,7 +192,8 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
   }
 
   mmio = dt3155_lbase[minor];
-  fb = &dt3155_status[minor].fbuffer;
+  dts = &dt3155_status[minor];
+  fb = &dts->fbuffer;
 
   /* Check for corruption and set a flag if so */
   csr1_r.reg = readl(mmio + CSR1);
@@ -210,8 +213,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
   /* Handle the even field ... */
   if (int_csr_r.fld.FLD_END_EVE)
     {
-      if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD)
+      if ((dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
 	{
 	  fb->frame_count++;
 	}
@@ -239,12 +241,11 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       writel(int_csr_r.reg, mmio + INT_CSR);
 
       /* Set up next DMA if we are doing FIELDS */
-      if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD)
+      if ((dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
 	{
 	  /* GCS (Aug 2, 2002) -- In field mode, dma the odd field
 	     into the lower half of the buffer */
-	  const u32 stride =  dt3155_status[minor].config.cols;
+	  const u32 stride =  dts->config.cols;
 	  buffer_addr = fb->frame_info[fb->active_buf].addr +
 			(DT3155_MAX_ROWS / 2) * stride;
 	  local_save_flags(flags);
@@ -282,8 +283,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       int_csr_r.fld.FLD_END_ODD = 1;
 
       if (fb->even_happened ||
-	  (dt3155_status[minor].state & DT3155_STATE_MODE) ==
-	  DT3155_STATE_FLD)
+	  (dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
 	{
 	  fb->frame_count++;
 	}
@@ -295,15 +295,14 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 	    {
 	      /* disable interrupts */
 	      int_csr_r.fld.FLD_END_ODD_EN = 0;
-	      dt3155_status[minor].state &= ~(DT3155_STATE_STOP|0xff);
+	      dts->state &= ~(DT3155_STATE_STOP|0xff);
 
 	      /* mark the system stopped: */
-	      dt3155_status[minor].state |= DT3155_STATE_IDLE;
+	      dts->state |= DT3155_STATE_IDLE;
 	      fb->stop_acquire = 0;
 	      fb->even_stopped = 0;
 
-	      printk(KERN_DEBUG "dt3155:  state is now %x\n",
-		     dt3155_status[minor].state);
+	      printk(KERN_DEBUG "dt3155:  state is now %x\n", dts->state);
 	    }
 	  else
 	    {
@@ -317,8 +316,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       /* change the next dma location for both fields */
       /* and wake up the process if sleeping          */
       if (fb->even_happened ||
-	   (dt3155_status[minor].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD)
+	   (dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
 	{
 
 	  local_save_flags(flags);
@@ -379,8 +377,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 
       /* Set up the DMA address for the next frame/field */
       buffer_addr = fb->frame_info[fb->active_buf].addr;
-      if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
-	   DT3155_STATE_FLD)
+      if ((dts->state & DT3155_STATE_MODE) == DT3155_STATE_FLD)
 	{
 	  writel(buffer_addr, mmio + EVEN_DMA_START);
 	}
@@ -388,8 +385,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 	{
 	  writel(buffer_addr, mmio + EVEN_DMA_START);
 
-	  writel(buffer_addr + dt3155_status[minor].config.cols,
-		mmio + ODD_DMA_START);
+	  writel(buffer_addr + dts->config.cols, mmio + ODD_DMA_START);
 	}
 
       /* Do error checking */
@@ -413,11 +409,12 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
  *****************************************************/
 static void dt3155_init_isr(int minor)
 {
-  const u32 stride =  dt3155_status[minor].config.cols;
+  struct dt3155_status *dts = &dt3155_status[minor];
+  struct dt3155_fbuffer *fb = &dts->fbuffer;
+  const u32 stride = dts->config.cols;
   void __iomem *mmio = dt3155_lbase[minor];
-  struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
 
-  switch (dt3155_status[minor].state & DT3155_STATE_MODE)
+  switch (dts->state & DT3155_STATE_MODE)
     {
     case DT3155_STATE_FLD:
       {
@@ -507,7 +504,8 @@ static int dt3155_ioctl(struct inode *inode,
 {
   int minor = MINOR(inode->i_rdev); /* What device are we ioctl()'ing? */
   void __user *up = (void __user *)arg;
-  struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+  struct dt3155_status *dts = &dt3155_status[minor];
+  struct dt3155_fbuffer *fb = &dts->fbuffer;
 
   if (minor >= MAXBOARDS || minor < 0)
     return -ENODEV;
@@ -529,7 +527,7 @@ static int dt3155_ioctl(struct inode *inode,
     {
     case DT3155_SET_CONFIG:
       {
-	if (dt3155_status[minor].state != DT3155_STATE_IDLE)
+	if (dts->state != DT3155_STATE_IDLE)
 	  return -EBUSY;
 
 	{
@@ -546,59 +544,55 @@ static int dt3155_ioctl(struct inode *inode,
 	    {
 	      return -EINVAL;
 	    }
-	  dt3155_status[minor].config = tmp;
+	  dts->config = tmp;
 	}
 	return 0;
       }
     case DT3155_GET_CONFIG:
       {
-	if (copy_to_user(up, &dt3155_status[minor],
-		     sizeof(struct dt3155_status)))
+	if (copy_to_user(up, dts, sizeof(*dts)))
 	    return -EFAULT;
 	return 0;
       }
     case DT3155_FLUSH: /* Flushes the buffers -- ensures fresh data */
       {
-	if (dt3155_status[minor].state != DT3155_STATE_IDLE)
+	if (dts->state != DT3155_STATE_IDLE)
 	  return -EBUSY;
 	return dt3155_flush(minor);
       }
     case DT3155_STOP:
       {
-	if (dt3155_status[minor].state & DT3155_STATE_STOP ||
-	    fb->stop_acquire)
+	if (dts->state & DT3155_STATE_STOP || fb->stop_acquire)
 	  return -EBUSY;
 
-	if (dt3155_status[minor].state == DT3155_STATE_IDLE)
+	if (dts->state == DT3155_STATE_IDLE)
 	  return 0;
 
 	quick_stop(minor);
-	if (copy_to_user(up, &dt3155_status[minor],
-		     sizeof(struct dt3155_status)))
+	if (copy_to_user(up, dts, sizeof(*dts)))
 	    return -EFAULT;
 	return 0;
       }
     case DT3155_START:
       {
-	if (dt3155_status[minor].state != DT3155_STATE_IDLE)
+	if (dts->state != DT3155_STATE_IDLE)
 	  return -EBUSY;
 
 	fb->stop_acquire = 0;
 	fb->frame_count = 0;
 
 	/* Set the MODE in the status -- we default to FRAME */
-	if (dt3155_status[minor].config.acq_mode == DT3155_MODE_FIELD)
+	if (dts->config.acq_mode == DT3155_MODE_FIELD)
 	  {
-	    dt3155_status[minor].state = DT3155_STATE_FLD;
+	    dts->state = DT3155_STATE_FLD;
 	  }
 	else
 	  {
-	    dt3155_status[minor].state = DT3155_STATE_FRAME;
+	    dts->state = DT3155_STATE_FRAME;
 	  }
 
 	dt3155_init_isr(minor);
-	if (copy_to_user(up, &dt3155_status[minor],
-		      sizeof(struct dt3155_status)))
+	if (copy_to_user(up, dts, sizeof(*dts)))
 	    return -EFAULT;
 	return 0;
       }
@@ -627,7 +621,8 @@ static int dt3155_ioctl(struct inode *inode,
 static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
 {
   /* which device are we mmapping? */
-  int				minor = MINOR(file->f_dentry->d_inode->i_rdev);
+  int minor = MINOR(file->f_dentry->d_inode->i_rdev);
+  struct dt3155_status *dts = &dt3155_status[minor];
   unsigned long	offset;
   offset = vma->vm_pgoff << PAGE_SHIFT;
 
@@ -638,10 +633,10 @@ static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
   vma->vm_flags |= VM_RESERVED;
 
   /* they are mapping the registers or the buffer */
-  if ((offset == dt3155_status[minor].reg_addr &&
+  if ((offset == dts->reg_addr &&
        vma->vm_end - vma->vm_start == PCI_PAGE_SIZE) ||
-      (offset == dt3155_status[minor].mem_addr &&
-       vma->vm_end - vma->vm_start == dt3155_status[minor].mem_size))
+      (offset == dts->mem_addr &&
+       vma->vm_end - vma->vm_start == dts->mem_size))
     {
       if (remap_pfn_range(vma,
 			vma->vm_start,
@@ -672,21 +667,23 @@ static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
 static int dt3155_open(struct inode* inode, struct file* filep)
 {
   int minor = MINOR(inode->i_rdev); /* what device are we opening? */
+  struct dt3155_status *dts = &dt3155_status[minor];
+
   if (dt3155_dev_open[minor]) {
     printk ("DT3155:  Already opened by another process.\n");
     return -EBUSY;
   }
 
-  if (dt3155_status[minor].device_installed==0)
+  if (dts->device_installed==0)
     {
       printk("DT3155 Open Error: No such device dt3155 minor number %d\n",
 	     minor);
       return -EIO;
     }
 
-  if (dt3155_status[minor].state != DT3155_STATE_IDLE) {
+  if (dts->state != DT3155_STATE_IDLE) {
     printk ("DT3155:  Not in idle state (state = %x)\n",
-	    dt3155_status[minor].state);
+	    dts->state);
     return -EBUSY;
   }
 
@@ -714,9 +711,9 @@ static int dt3155_open(struct inode* inode, struct file* filep)
  *****************************************************/
 static int dt3155_close(struct inode *inode, struct file *filep)
 {
-  int minor;
+  int minor = MINOR(inode->i_rdev); /* which device are we closing */
+  struct dt3155_status *dts = &dt3155_status[minor];
 
-  minor = MINOR(inode->i_rdev); /* which device are we closing */
   if (!dt3155_dev_open[minor])
     {
       printk("DT3155: attempt to CLOSE a not OPEN device\n");
@@ -725,7 +722,7 @@ static int dt3155_close(struct inode *inode, struct file *filep)
     {
       dt3155_dev_open[minor] = 0;
 
-      if (dt3155_status[minor].state != DT3155_STATE_IDLE)
+      if (dts->state != DT3155_STATE_IDLE)
 	{
 	  quick_stop(minor);
 	}
@@ -744,7 +741,8 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   int		minor = MINOR(filep->f_dentry->d_inode->i_rdev);
   u32		offset;
   int		frame_index;
-  struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
+  struct dt3155_status *dts = &dt3155_status[minor];
+  struct dt3155_fbuffer *fb = &dts->fbuffer;
   struct frame_info	*frame_info;
 
   /* TODO: this should check the error flag and */
@@ -763,7 +761,7 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
    * Note that if the driver is not opened in non_blocking mode,
    * and the device is idle, then it could sit here forever! */
 
-  /*  if (dt3155_status[minor].state == DT3155_STATE_IDLE)*/
+  /*  if (dts->state == DT3155_STATE_IDLE)*/
   /*    return -EBUSY;*/
 
   /* non-blocking reads should return if no data */
@@ -798,13 +796,13 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   frame_info = &fb->frame_info[frame_index];
 
   /* make this an offset */
-  offset = frame_info->addr - dt3155_status[minor].mem_addr;
+  offset = frame_info->addr - dts->mem_addr;
 
   put_user(offset, (unsigned int __user *)buf);
   buf += sizeof(u32);
   put_user(fb->frame_count, (unsigned int __user *)buf);
   buf += sizeof(u32);
-  put_user(dt3155_status[minor].state, (unsigned int __user *)buf);
+  put_user(dts->state, (unsigned int __user *)buf);
   buf += sizeof(u32);
   if (copy_to_user(buf, frame_info, sizeof(*frame_info)))
       return -EFAULT;
@@ -859,6 +857,7 @@ static struct file_operations dt3155_fops = {
 static int find_PCI (void)
 {
   struct pci_dev *pci_dev = NULL;
+  struct dt3155_status *dts;
   int error, pci_index = 0;
   unsigned short rev_device;
   unsigned long base;
@@ -867,7 +866,7 @@ static int find_PCI (void)
   while ((pci_dev = pci_get_device
 	  (DT3155_VENDORID, DT3155_DEVICEID, pci_dev)) != NULL)
     {
-      pci_index ++;
+      dts = &dt3155_status[pci_index++];
 
       /* Is it really there? */
       if ((error =
@@ -897,12 +896,12 @@ static int find_PCI (void)
 	}
 
       DT_3155_DEBUG_MSG("DT3155: Base address 0 for device is %lx \n", base);
-      dt3155_status[pci_index-1].reg_addr = base;
+      dts->reg_addr = base;
 
       /* Remap the base address to a logical address through which we
        * can access it. */
       dt3155_lbase[pci_index - 1] = ioremap(base, PCI_PAGE_SIZE);
-      dt3155_status[pci_index - 1].reg_addr = base;
+      dts->reg_addr = base;
       DT_3155_DEBUG_MSG("DT3155: New logical address is %p \n",
 			dt3155_lbase[pci_index-1]);
       if (!dt3155_lbase[pci_index-1])
@@ -918,12 +917,12 @@ static int find_PCI (void)
 	}
 
       DT_3155_DEBUG_MSG("DT3155: IRQ is %d \n",irq);
-      dt3155_status[pci_index-1].irq = irq;
+      dts->irq = irq;
       /* Set flag: kth device found! */
-      dt3155_status[pci_index-1].device_installed = 1;
+      dts->device_installed = 1;
       printk("DT3155: Installing device %d w/irq %d and address %p\n",
 	     pci_index,
-	     dt3155_status[pci_index-1].irq,
+	     dts->irq,
 	     dt3155_lbase[pci_index-1]);
 
     }
@@ -943,6 +942,7 @@ u32 allocatorAddr = 0;
  *****************************************************/
 int init_module(void)
 {
+  struct dt3155_status *dts;
   int index;
   int rcode = 0;
   char *devname[MAXBOARDS];
@@ -970,18 +970,20 @@ int init_module(void)
   /* DMA memory is taken care of in setup_buffers() */
   for (index = 0; index < MAXBOARDS; index++)
     {
-      dt3155_status[index].config.acq_mode   = DT3155_MODE_FRAME;
-      dt3155_status[index].config.continuous = DT3155_ACQ;
-      dt3155_status[index].config.cols       = DT3155_MAX_COLS;
-      dt3155_status[index].config.rows       = DT3155_MAX_ROWS;
-      dt3155_status[index].state = DT3155_STATE_IDLE;
+      dts = &dt3155_status[index];
+
+      dts->config.acq_mode   = DT3155_MODE_FRAME;
+      dts->config.continuous = DT3155_ACQ;
+      dts->config.cols       = DT3155_MAX_COLS;
+      dts->config.rows       = DT3155_MAX_ROWS;
+      dts->state = DT3155_STATE_IDLE;
 
       /* find_PCI() will check if devices are installed; */
       /* first assume they're not:                       */
-      dt3155_status[index].mem_addr          = 0;
-      dt3155_status[index].mem_size          = 0;
-      dt3155_status[index].state             = DT3155_STATE_IDLE;
-      dt3155_status[index].device_installed  = 0;
+      dts->mem_addr          = 0;
+      dts->mem_size          = 0;
+      dts->state             = DT3155_STATE_IDLE;
+      dts->device_installed  = 0;
     }
 
   /* Now let's find the hardware.  find_PCI() will set ndevices to the
@@ -1007,27 +1009,31 @@ int init_module(void)
   /* for the buffers: Print the configuration.    */
   for( index = 0;  index < ndevices;  index++)
     {
+      dts = &dt3155_status[index];
+
       printk("DT3155: Device = %d; acq_mode = %d; "
 	     "continuous = %d; cols = %d; rows = %d;\n",
 	     index ,
-	     dt3155_status[index].config.acq_mode,
-	     dt3155_status[index].config.continuous,
-	     dt3155_status[index].config.cols,
-	     dt3155_status[index].config.rows);
+	     dts->config.acq_mode,
+	     dts->config.continuous,
+	     dts->config.cols,
+	     dts->config.rows);
       printk("DT3155: m_addr = 0x%x; m_size = %ld; "
 	     "state = %d; device_installed = %d\n",
-	     dt3155_status[index].mem_addr,
-	     (long int)dt3155_status[index].mem_size,
-	     dt3155_status[index].state,
-	     dt3155_status[index].device_installed);
+	     dts->mem_addr,
+	     (long int)dts->mem_size,
+	     dts->state,
+	     dts->device_installed);
     }
 
   /* Disable ALL interrupts */
   int_csr_r.reg = 0;
   for( index = 0;  index < ndevices;  index++)
     {
+      dts = &dt3155_status[index];
+
       writel(int_csr_r.reg, dt3155_lbase[index] + INT_CSR);
-      if(dt3155_status[index].device_installed)
+      if(dts->device_installed)
 	{
 	  /*
 	   * This driver *looks* like it can handle sharing interrupts,
@@ -1036,13 +1042,13 @@ int init_module(void)
 	   * as a reminder in case any problems arise. (SS)
 	   */
 	  /* in older kernels flags are: SA_SHIRQ | SA_INTERRUPT */
-	  rcode = request_irq(dt3155_status[index].irq, (void *)dt3155_isr,
+	  rcode = request_irq(dts->irq, (void *)dt3155_isr,
 			       IRQF_SHARED | IRQF_DISABLED, devname[index],
-			       (void*) &dt3155_status[index]);
+			       (void *)dts);
 	  if(rcode < 0)
 	    {
 	      printk("DT3155: minor %d request_irq failed for IRQ %d\n",
-		     index, dt3155_status[index].irq);
+		     index, dts->irq);
 	      unregister_chrdev(dt3155_major, "dt3155");
 	      return rcode;
 	    }
@@ -1060,6 +1066,7 @@ int init_module(void)
  *****************************************************/
 void cleanup_module(void)
 {
+  struct dt3155_status *dts;
   int index;
 
   printk("DT3155:  cleanup_module called\n");
@@ -1076,11 +1083,12 @@ void cleanup_module(void)
 
   for(index = 0; index < ndevices; index++)
     {
-      if(dt3155_status[index].device_installed == 1)
+      dts = &dt3155_status[index];
+      if(dts->device_installed == 1)
 	{
 	  printk("DT3155: Freeing irq %d for device %d\n",
-		  dt3155_status[index].irq, index);
-	  free_irq(dt3155_status[index].irq, (void*)&dt3155_status[index]);
+		  dts->irq, index);
+	  free_irq(dts->irq, (void *)dts);
 	}
     }
 }
