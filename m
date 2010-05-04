Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071Ab0EDVX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 17:23:56 -0400
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:44227 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933820Ab0EDVXz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 17:23:55 -0400
X-MXL-Hash: 4be0906a4706b811-cc3a46ed5673bc6e3beca2fd10bf0c3272dd18d1
X-MXL-Hash: 4be090524381d3a8-3f94d44684780942d87637a3d5ce8fd5cea6e844
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: Joe Perches <joe@perches.com>, Greg KH <gregkh@suse.de>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 4 May 2010 16:22:47 -0500
Subject: RE: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Topic: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Index: AcrrzVnGlPVK+abARvq4qHcYDK7nTAAAbAfQ
Message-ID: <0D753D10438DA54287A00B0270842697636EB83EC9@AUSP01VMBX24.collaborationhost.net>
References: <20100503211751.GB21402@kroah.com>
 <0D753D10438DA54287A00B0270842697636EADE1D2@AUSP01VMBX24.collaborationhost.net>
 <0D753D10438DA54287A00B0270842697636EADE26A@AUSP01VMBX24.collaborationhost.net>
 <20100503234123.GC13519@suse.de>
 <1272931198.30040.218.camel@Joe-Laptop.home>
 <20100504025430.GA26421@suse.de> <1273000031.4143.56.camel@Joe-Laptop.home>
 <0D753D10438DA54287A00B0270842697636EB83CE8@AUSP01VMBX24.collaborationhost.net>
 <20100504201207.GA7096@kroah.com>
 <0D753D10438DA54287A00B0270842697636EB83E2A@AUSP01VMBX24.collaborationhost.net>
 <20100504210229.GA21128@kroah.com>
In-Reply-To: <20100504210229.GA21128@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.4814077164; CM=0.500; S=0.481(2010050401)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.97]
X-AnalysisOut: [v=1.0 c=1 a=n2LqRRw_DHMA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=qhvANl0glaz90f+3g7Keqg==:17 a=i00gxMtYAAAA:8 a=iJm]
X-AnalysisOut: [o1fpu2jL5WZFQph4A:9 a=d0dNQnpUfdb821ZDhkEA:7 a=0BMrBWV-Rnv]
X-AnalysisOut: [oCOXJp2gp9asBsEUA:4 a=CjuIK1q_8ugA:10 a=x1WnkoZAwusA:10 a=]
X-AnalysisOut: [0kPLrQdw3YYA:10 a=CIdUAKeG0qmA_EO5:21 a=scOcsuubtu2_e4BL:2]
X-AnalysisOut: [1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The macros ReadMReg and WriteMReg are really just private versions of
the kernel's readl and writel functions.  Use the kernel's functions
instead.  And since ioremap returns a (void __iomem *) not a (u8 *),
change all the uses of dt3155_lbase to reflect this.

While here, make dt3155_lbase static since it is only used in the
dt3155_drv.c file.  Also, remove the global variable dt3155_bbase
since it is not used anywhere in the code.

Where is makes sense, create a local 'mmio' variable instead of using
dt3155_lbase[minor] to make the code more readable.

This change also affects the {Read|Write}I2C functions so they are
also modified as needed.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

Greg, here is the patch rebased to your staging-next tree.
The main issue I can see is a conflict with:

commit 6536560cabab170ed2969b005bf69a496e9c45bf
    Staging: dt3155: fix 50Hz configuration

This patch modifies the same two lines that were changed by that patch.

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 993ed2f..8ebfe14 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -75,8 +75,8 @@ MODULE_LICENSE("GPL");
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/smp_lock.h>
+#include <linux/io.h>

-#include <asm/io.h>
 #include <asm/uaccess.h>

 #include "dt3155.h"
@@ -123,14 +123,12 @@ int dt3155_major = 0;
 struct dt3155_status dt3155_status[MAXBOARDS];

 /* kernel logical address of the board */
-u8 *dt3155_lbase[MAXBOARDS] = { NULL
+static void __iomem *dt3155_lbase[MAXBOARDS] = { NULL
 #if MAXBOARDS == 2
                                      , NULL
 #endif
 };
-/* DT3155 registers              */
-u8 *dt3155_bbase = NULL;                 /* kernel logical address of the *
-                                          * buffer region                 */
+
 u32  dt3155_dev_open[MAXBOARDS] = {0
 #if MAXBOARDS == 2
                                       , 0
@@ -150,11 +148,13 @@ static void quick_stop (int minor)
 {
   // TODO: scott was here
 #if 1
-  ReadMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+  void __iomem *mmio = dt3155_lbase[minor];
+
+  int_csr_r.reg = readl(mmio + INT_CSR);
   /* disable interrupts */
   int_csr_r.fld.FLD_END_EVE_EN = 0;
   int_csr_r.fld.FLD_END_ODD_EN = 0;
-  WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+  writel(int_csr_r.reg, mmio + INT_CSR);

   dt3155_status[minor].state &= ~(DT3155_STATE_STOP|0xff);
   /* mark the system stopped: */
@@ -182,6 +182,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
   int    index;
   unsigned long flags;
   u32 buffer_addr;
+  void __iomem *mmio;

   /* find out who issued the interrupt */
   for (index = 0; index < ndevices; index++) {
@@ -198,8 +199,10 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
     return;
   }

+  mmio = dt3155_lbase[minor];
+
   /* Check for corruption and set a flag if so */
-  ReadMReg((dt3155_lbase[minor] + CSR1), csr1_r.reg);
+  csr1_r.reg = readl(mmio + CSR1);

   if ((csr1_r.fld.FLD_CRPT_EVE) || (csr1_r.fld.FLD_CRPT_ODD))
     {
@@ -211,7 +214,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       return;
     }

-  ReadMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+  int_csr_r.reg = readl(mmio + INT_CSR);

   /* Handle the even field ... */
   if (int_csr_r.fld.FLD_END_EVE)
@@ -222,7 +225,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
          dt3155_fbuffer[minor]->frame_count++;
        }

-      ReadI2C(dt3155_lbase[minor], EVEN_CSR, &i2c_even_csr.reg);
+      ReadI2C(mmio, EVEN_CSR, &i2c_even_csr.reg);

       /* Clear the interrupt? */
       int_csr_r.fld.FLD_END_EVE = 1;
@@ -242,7 +245,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
            }
        }

-      WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+      writel(int_csr_r.reg, mmio + INT_CSR);

       /* Set up next DMA if we are doing FIELDS */
       if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
@@ -260,7 +263,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)

          /* Set up the DMA address for the next field */
          local_irq_restore(flags);
-         WriteMReg((dt3155_lbase[minor] + ODD_DMA_START), buffer_addr);
+         writel(buffer_addr, mmio + ODD_DMA_START);
        }

       /* Check for errors. */
@@ -268,7 +271,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       if (i2c_even_csr.fld.ERROR_EVE)
        dt3155_errno = DT_ERR_OVERRUN;

-      WriteI2C(dt3155_lbase[minor], EVEN_CSR, i2c_even_csr.reg);
+      WriteI2C(mmio, EVEN_CSR, i2c_even_csr.reg);

       /* Note that we actually saw an even field meaning  */
       /* that subsequent odd field complete the frame     */
@@ -285,7 +288,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
   /* ... now handle the odd field */
   if (int_csr_r.fld.FLD_END_ODD)
     {
-      ReadI2C(dt3155_lbase[minor], ODD_CSR, &i2c_odd_csr.reg);
+      ReadI2C(mmio, ODD_CSR, &i2c_odd_csr.reg);

       /* Clear the interrupt? */
       int_csr_r.fld.FLD_END_ODD = 1;
@@ -321,7 +324,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
            }
        }

-      WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+      writel(int_csr_r.reg, mmio + INT_CSR);

       /* if the odd field has been acquired, then     */
       /* change the next dma location for both fields */
@@ -398,14 +401,14 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
           DT3155_STATE_FLD)
        {
-         WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START), buffer_addr);
+         writel(buffer_addr, mmio + EVEN_DMA_START);
        }
       else
        {
-         WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START), buffer_addr);
+         writel(buffer_addr, mmio + EVEN_DMA_START);

-         WriteMReg((dt3155_lbase[minor] + ODD_DMA_START), buffer_addr
-                   + dt3155_status[minor].config.cols);
+         writel(buffer_addr + dt3155_status[minor].config.cols,
+               mmio + ODD_DMA_START);
        }

       /* Do error checking */
@@ -413,7 +416,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       if (i2c_odd_csr.fld.ERROR_ODD)
        dt3155_errno = DT_ERR_OVERRUN;

-      WriteI2C(dt3155_lbase[minor], ODD_CSR, i2c_odd_csr.reg);
+      WriteI2C(mmio, ODD_CSR, i2c_odd_csr.reg);

       return;
     }
@@ -430,6 +433,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 static void dt3155_init_isr(int minor)
 {
   const u32 stride =  dt3155_status[minor].config.cols;
+  void __iomem *mmio = dt3155_lbase[minor];

   switch (dt3155_status[minor].state & DT3155_STATE_MODE)
     {
@@ -440,12 +444,9 @@ static void dt3155_init_isr(int minor)
        even_dma_stride_r = 0;
        odd_dma_stride_r  = 0;

-       WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START),
-                 even_dma_start_r);
-       WriteMReg((dt3155_lbase[minor] + EVEN_DMA_STRIDE),
-                 even_dma_stride_r);
-       WriteMReg((dt3155_lbase[minor] + ODD_DMA_STRIDE),
-                 odd_dma_stride_r);
+       writel(even_dma_start_r, mmio + EVEN_DMA_START);
+       writel(even_dma_stride_r, mmio + EVEN_DMA_STRIDE);
+       writel(odd_dma_stride_r, mmio + ODD_DMA_STRIDE);
        break;
       }

@@ -458,14 +459,10 @@ static void dt3155_init_isr(int minor)
        even_dma_stride_r =  stride;
        odd_dma_stride_r  =  stride;

-       WriteMReg((dt3155_lbase[minor] + EVEN_DMA_START),
-                 even_dma_start_r);
-       WriteMReg((dt3155_lbase[minor] + ODD_DMA_START),
-                 odd_dma_start_r);
-       WriteMReg((dt3155_lbase[minor] + EVEN_DMA_STRIDE),
-                 even_dma_stride_r);
-       WriteMReg((dt3155_lbase[minor] + ODD_DMA_STRIDE),
-                 odd_dma_stride_r);
+       writel(even_dma_start_r, mmio + EVEN_DMA_START);
+       writel(odd_dma_start_r, mmio + ODD_DMA_START);
+       writel(even_dma_stride_r, mmio + EVEN_DMA_STRIDE);
+       writel(odd_dma_stride_r, mmio + ODD_DMA_STRIDE);
        break;
       }
     }
@@ -473,9 +470,9 @@ static void dt3155_init_isr(int minor)
   /* 50/60 Hz should be set before this point but let's make sure it is */
   /* right anyway */

-  ReadI2C(dt3155_lbase[minor], CONFIG, &i2c_csr2.reg);
+  ReadI2C(mmio, CSR2, &i2c_csr2.reg);
   i2c_csr2.fld.HZ50 = FORMAT50HZ;
-  WriteI2C(dt3155_lbase[minor], CONFIG, i2c_config.reg);
+  WriteI2C(mmio, CSR2, i2c_csr2.reg);

   /* enable busmaster chip, clear flags */

@@ -495,7 +492,7 @@ static void dt3155_init_isr(int minor)
   csr1_r.fld.FLD_CRPT_EVE   = 1; /* writing a 1 clears flags */
   csr1_r.fld.FLD_CRPT_ODD   = 1;

-  WriteMReg((dt3155_lbase[minor] + CSR1),csr1_r.reg);
+  writel(csr1_r.reg, mmio + CSR1);

   /* Enable interrupts at the end of each field */

@@ -504,14 +501,14 @@ static void dt3155_init_isr(int minor)
   int_csr_r.fld.FLD_END_ODD_EN = 1;
   int_csr_r.fld.FLD_START_EN = 0;

-  WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+  writel(int_csr_r.reg, mmio + INT_CSR);

   /* start internal BUSY bits */

-  ReadI2C(dt3155_lbase[minor], CSR2, &i2c_csr2.reg);
+  ReadI2C(mmio, CSR2, &i2c_csr2.reg);
   i2c_csr2.fld.BUSY_ODD  = 1;
   i2c_csr2.fld.BUSY_EVE  = 1;
-  WriteI2C(dt3155_lbase[minor], CSR2, i2c_csr2.reg);
+  WriteI2C(mmio, CSR2, i2c_csr2.reg);

   /* Now its up to the interrupt routine!! */

@@ -693,6 +690,8 @@ static int dt3155_mmap (struct file * file, struct vm_area_struct * vma)
 static int dt3155_open(struct inode* inode, struct file* filep)
 {
   int minor = MINOR(inode->i_rdev); /* what device are we opening? */
+  void __iomem *mmio = dt3155_lbase[minor];
+
   if (dt3155_dev_open[minor]) {
     printk ("DT3155:  Already opened by another process.\n");
     return -EBUSY;
@@ -719,7 +718,7 @@ static int dt3155_open(struct inode* inode, struct file* filep)

   /* Disable ALL interrupts */
   int_csr_r.reg = 0;
-  WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+  writel(int_csr_r.reg, mmio + INT_CSR);

   init_waitqueue_head(&(dt3155_read_wait_queue[minor]));

@@ -921,7 +920,7 @@ static int find_PCI (void)

       /* Remap the base address to a logical address through which we
        * can access it. */
-      dt3155_lbase[pci_index - 1] = ioremap(base,PCI_PAGE_SIZE);
+      dt3155_lbase[pci_index - 1] = ioremap(base, PCI_PAGE_SIZE);
       dt3155_status[pci_index - 1].reg_addr = base;
       DT_3155_DEBUG_MSG("DT3155: New logical address is %p \n",
                        dt3155_lbase[pci_index-1]);
@@ -1046,7 +1045,7 @@ int init_module(void)
   int_csr_r.reg = 0;
   for( index = 0;  index < ndevices;  index++)
     {
-      WriteMReg((dt3155_lbase[index] + INT_CSR), int_csr_r.reg);
+      writel(int_csr_r.reg, dt3155_lbase[index] + INT_CSR);
       if(dt3155_status[index].device_installed)
        {
          /*
diff --git a/drivers/staging/dt3155/dt3155_drv.h b/drivers/staging/dt3155/dt3155_drv.h
index 95e68c3..c447c61 100644
--- a/drivers/staging/dt3155/dt3155_drv.h
+++ b/drivers/staging/dt3155/dt3155_drv.h
@@ -24,12 +24,6 @@ MA 02111-1307 USA
 #ifndef DT3155_DRV_INC
 #define DT3155_DRV_INC

-/* kernel logical address of the frame grabbers */
-extern u8 *dt3155_lbase[MAXBOARDS];
-
-/* kernel logical address of ram buffer */
-extern u8 *dt3155_bbase;
-
 #ifdef __KERNEL__
 #include <linux/wait.h>

diff --git a/drivers/staging/dt3155/dt3155_io.c b/drivers/staging/dt3155/dt3155_io.c
index 7792e71..c99bd57 100644
--- a/drivers/staging/dt3155/dt3155_io.c
+++ b/drivers/staging/dt3155/dt3155_io.c
@@ -21,6 +21,8 @@
  */

 #include <linux/delay.h>
+#include <linux/io.h>
+
 #include "dt3155.h"
 #include "dt3155_io.h"
 #include "dt3155_drv.h"
@@ -75,13 +77,13 @@ u8 i2c_pm_lut_data;
  *
  * This function handles read/write timing and r/w timeout error
  */
-static int wait_ibsyclr(u8 *lpReg)
+static int wait_ibsyclr(void __iomem *mmio)
 {
        /* wait 100 microseconds */
        udelay(100L);
        /* __delay(loops_per_sec/10000); */

-       ReadMReg(lpReg + IIC_CSR2, iic_csr2_r.reg);
+       iic_csr2_r.reg = readl(mmio + IIC_CSR2);
        if (iic_csr2_r.fld.NEW_CYCLE) {
                /* if NEW_CYCLE didn't clear */
                /* TIMEOUT ERROR */
@@ -101,11 +103,10 @@ static int wait_ibsyclr(u8 *lpReg)
  * 2nd parameter is reg. index;
  * 3rd is value to be written
  */
-int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
+int WriteI2C(void __iomem *mmio, u_short wIregIndex, u8 byVal)
 {
        /* read 32 bit IIC_CSR2 register data into union */
-
-       ReadMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+       iic_csr2_r.reg = readl(mmio + IIC_CSR2);

        /* for write operation */
        iic_csr2_r.fld.DIR_RD      = 0;
@@ -117,10 +118,10 @@ int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
        iic_csr2_r.fld.NEW_CYCLE   = 1;

        /* xfer union data into 32 bit IIC_CSR2 register */
-       WriteMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+       writel(iic_csr2_r.reg, mmio + IIC_CSR2);

        /* wait for IIC cycle to finish */
-       return wait_ibsyclr(lpReg);
+       return wait_ibsyclr(mmio);
 }

 /*
@@ -132,12 +133,12 @@ int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
  * 2nd parameter is reg. index;
  * 3rd is adrs of value to be read
  */
-int ReadI2C(u8 *lpReg, u_short wIregIndex, u8 *byVal)
+int ReadI2C(void __iomem *mmio, u_short wIregIndex, u8 *byVal)
 {
        int writestat;  /* status for return */

        /*  read 32 bit IIC_CSR2 register data into union */
-       ReadMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+       iic_csr2_r.reg = readl(mmio + IIC_CSR2);

        /*  for read operation */
        iic_csr2_r.fld.DIR_RD     = 1;
@@ -149,14 +150,14 @@ int ReadI2C(u8 *lpReg, u_short wIregIndex, u8 *byVal)
        iic_csr2_r.fld.NEW_CYCLE  = 1;

        /*  xfer union's data into 32 bit IIC_CSR2 register */
-       WriteMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+       writel(iic_csr2_r.reg, mmio + IIC_CSR2);

        /* wait for IIC cycle to finish */
-       writestat = wait_ibsyclr(lpReg);
+       writestat = wait_ibsyclr(mmio);

        /* Next 2 commands read 32 bit IIC_CSR1 register's data into union */
        /* first read data is in IIC_CSR1 */
-       ReadMReg((lpReg + IIC_CSR1), iic_csr1_r.reg);
+       iic_csr1_r.reg = readl(mmio + IIC_CSR1);

        /* now get data u8 out of register */
        *byVal = (u8) iic_csr1_r.fld.RD_DATA;
diff --git a/drivers/staging/dt3155/dt3155_io.h b/drivers/staging/dt3155/dt3155_io.h
index d1a2510..1445082 100644
--- a/drivers/staging/dt3155/dt3155_io.h
+++ b/drivers/staging/dt3155/dt3155_io.h
@@ -34,11 +34,6 @@ MA 02111-1307 USA
 #ifndef DT3155_IO_INC
 #define DT3155_IO_INC

-/* macros to access registers */
-
-#define WriteMReg(Address, Data)       (*((u32 *)(Address)) = Data)
-#define ReadMReg(Address, Data)                (Data = *((u32 *)(Address)))
-
 /***************** 32 bit register globals  **************/

 /*  offsets for 32-bit memory mapped registers */
@@ -351,8 +346,7 @@ extern u8                   i2c_pm_lut_data;
 /* Functions for Global use */

 /* access 8-bit IIC registers */
-
-extern int ReadI2C(u8 *lpReg, u_short wIregIndex, u8 *byVal);
-extern int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal);
+extern int ReadI2C(void __iomem *mmio, u_short wIregIndex, u8 *byVal);
+extern int WriteI2C(void __iomem *mmio, u_short wIregIndex, u8 byVal);

 #endif

