Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab0FUPx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:53:57 -0400
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:38259 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab0FUPx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:53:56 -0400
X-MXL-Hash: 4c1f8b136c3660e9-ed0b85535e192daf4afe4db68025ad665e936964
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
CC: "ss@aao.gov.au" <ss@aao.gov.au>, Greg KH <gregkh@suse.de>
Date: Mon, 21 Jun 2010 10:51:54 -0500
Subject: [PATCH v2] Staging: dt3155: Cleanup memory mapped i/o access
Thread-Topic: [PATCH v2] Staging: dt3155: Cleanup memory mapped i/o access
Thread-Index: AcrtWpT8zurJhB4wQMS/O4aLB6EyhAj/rTog
Message-ID: <0D753D10438DA54287A00B027084269763715265FE@AUSP01VMBX24.collaborationhost.net>
References: <20100503234123.GC13519@suse.de>
 <1272931198.30040.218.camel@Joe-Laptop.home>
 <20100504025430.GA26421@suse.de> <1273000031.4143.56.camel@Joe-Laptop.home>
 <0D753D10438DA54287A00B0270842697636EB83CE8@AUSP01VMBX24.collaborationhost.net>
 <20100504201207.GA7096@kroah.com>
 <0D753D10438DA54287A00B0270842697636EB83E2A@AUSP01VMBX24.collaborationhost.net>
 <20100504210229.GA21128@kroah.com>
 <0D753D10438DA54287A00B0270842697636EB83EC9@AUSP01VMBX24.collaborationhost.net>
 <0D753D10438DA54287A00B0270842697636ECB4D7B@AUSP01VMBX24.collaborationhost.net>
 <20100506202535.GA28600@kroah.com>
In-Reply-To: <20100506202535.GA28600@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010061701)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=vAyqc9n2grwA:10 a=UBIxAjGgU1YA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=kj9zAlcOel0A:10 a=38uLcFpo6nJaFUi5eYvXHw==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=OdlTqyd7nAGy97Ab6gAA:9 a=c_8uiVqd0K4SIlGH4D]
X-AnalysisOut: [kA:7 a=86McDiY31zfbJ2pYhQGUnTJ0dDkA:4 a=CjuIK1q_8ugA:10 a=]
X-AnalysisOut: [x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10 a=LQEUiNagE6YXuCXd:21 a=]
X-AnalysisOut: [cadvoil1k7c4SKpg:21]
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

V2 - rebased to next-20100621

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index dcd3849..88c9e59 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -64,8 +64,8 @@ extern void printques(int);
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/smp_lock.h>
+#include <linux/io.h>

-#include <asm/io.h>
 #include <asm/uaccess.h>

 #include "dt3155.h"
@@ -112,14 +112,12 @@ int dt3155_major = 0;
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
@@ -139,11 +137,11 @@ static void quick_stop (int minor)
 {
   // TODO: scott was here
 #if 1
-  ReadMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+  int_csr_r.reg = readl(dt3155_lbase[minor] + INT_CSR);
   /* disable interrupts */
   int_csr_r.fld.FLD_END_EVE_EN = 0;
   int_csr_r.fld.FLD_END_ODD_EN = 0;
-  WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+  writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);

   dt3155_status[minor].state &= ~(DT3155_STATE_STOP|0xff);
   /* mark the system stopped: */
@@ -171,6 +169,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
   int    index;
   unsigned long flags;
   u32 buffer_addr;
+  void __iomem *mmio;

   /* find out who issued the interrupt */
   for (index = 0; index < ndevices; index++) {
@@ -187,8 +186,10 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
     return;
   }

+  mmio = dt3155_lbase[minor];
+
   /* Check for corruption and set a flag if so */
-  ReadMReg((dt3155_lbase[minor] + CSR1), csr1_r.reg);
+  csr1_r.reg = readl(mmio + CSR1);

   if ((csr1_r.fld.FLD_CRPT_EVE) || (csr1_r.fld.FLD_CRPT_ODD))
     {
@@ -200,7 +201,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       return;
     }

-  ReadMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+  int_csr_r.reg = readl(mmio + INT_CSR);

   /* Handle the even field ... */
   if (int_csr_r.fld.FLD_END_EVE)
@@ -211,7 +212,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
          dt3155_fbuffer[minor]->frame_count++;
        }

-      ReadI2C(dt3155_lbase[minor], EVEN_CSR, &i2c_even_csr.reg);
+      ReadI2C(mmio, EVEN_CSR, &i2c_even_csr.reg);

       /* Clear the interrupt? */
       int_csr_r.fld.FLD_END_EVE = 1;
@@ -231,7 +232,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
            }
        }

-      WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+      writel(int_csr_r.reg, mmio + INT_CSR);

       /* Set up next DMA if we are doing FIELDS */
       if ((dt3155_status[minor].state & DT3155_STATE_MODE) ==
@@ -249,7 +250,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)

          /* Set up the DMA address for the next field */
          local_irq_restore(flags);
-         WriteMReg((dt3155_lbase[minor] + ODD_DMA_START), buffer_addr);
+         writel(buffer_addr, mmio + ODD_DMA_START);
        }

       /* Check for errors. */
@@ -257,7 +258,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       if (i2c_even_csr.fld.ERROR_EVE)
        dt3155_errno = DT_ERR_OVERRUN;

-      WriteI2C(dt3155_lbase[minor], EVEN_CSR, i2c_even_csr.reg);
+      WriteI2C(mmio, EVEN_CSR, i2c_even_csr.reg);

       /* Note that we actually saw an even field meaning  */
       /* that subsequent odd field complete the frame     */
@@ -274,7 +275,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
   /* ... now handle the odd field */
   if (int_csr_r.fld.FLD_END_ODD)
     {
-      ReadI2C(dt3155_lbase[minor], ODD_CSR, &i2c_odd_csr.reg);
+      ReadI2C(mmio, ODD_CSR, &i2c_odd_csr.reg);

       /* Clear the interrupt? */
       int_csr_r.fld.FLD_END_ODD = 1;
@@ -310,7 +311,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
            }
        }

-      WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+      writel(int_csr_r.reg, mmio + INT_CSR);

       /* if the odd field has been acquired, then     */
       /* change the next dma location for both fields */
@@ -387,14 +388,14 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
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
@@ -402,7 +403,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
       if (i2c_odd_csr.fld.ERROR_ODD)
        dt3155_errno = DT_ERR_OVERRUN;

-      WriteI2C(dt3155_lbase[minor], ODD_CSR, i2c_odd_csr.reg);
+      WriteI2C(mmio, ODD_CSR, i2c_odd_csr.reg);

       return;
     }
@@ -419,6 +420,7 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
 static void dt3155_init_isr(int minor)
 {
   const u32 stride =  dt3155_status[minor].config.cols;
+  void __iomem *mmio = dt3155_lbase[minor];

   switch (dt3155_status[minor].state & DT3155_STATE_MODE)
     {
@@ -429,12 +431,9 @@ static void dt3155_init_isr(int minor)
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

@@ -447,14 +446,10 @@ static void dt3155_init_isr(int minor)
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
@@ -462,9 +457,9 @@ static void dt3155_init_isr(int minor)
   /* 50/60 Hz should be set before this point but let's make sure it is */
   /* right anyway */

-  ReadI2C(dt3155_lbase[minor], CSR2, &i2c_csr2.reg);
+  ReadI2C(mmio, CSR2, &i2c_csr2.reg);
   i2c_csr2.fld.HZ50 = FORMAT50HZ;
-  WriteI2C(dt3155_lbase[minor], CSR2, i2c_csr2.reg);
+  WriteI2C(mmio, CSR2, i2c_csr2.reg);

   /* enable busmaster chip, clear flags */

@@ -484,7 +479,7 @@ static void dt3155_init_isr(int minor)
   csr1_r.fld.FLD_CRPT_EVE   = 1; /* writing a 1 clears flags */
   csr1_r.fld.FLD_CRPT_ODD   = 1;

-  WriteMReg((dt3155_lbase[minor] + CSR1),csr1_r.reg);
+  writel(csr1_r.reg, mmio + CSR1);

   /* Enable interrupts at the end of each field */

@@ -493,14 +488,14 @@ static void dt3155_init_isr(int minor)
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

@@ -709,7 +704,7 @@ static int dt3155_open(struct inode* inode, struct file* filep)

   /* Disable ALL interrupts */
   int_csr_r.reg = 0;
-  WriteMReg((dt3155_lbase[minor] + INT_CSR), int_csr_r.reg);
+  writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);

   init_waitqueue_head(&(dt3155_read_wait_queue[minor]));

@@ -911,7 +906,7 @@ static int find_PCI (void)

       /* Remap the base address to a logical address through which we
        * can access it. */
-      dt3155_lbase[pci_index - 1] = ioremap(base,PCI_PAGE_SIZE);
+      dt3155_lbase[pci_index - 1] = ioremap(base, PCI_PAGE_SIZE);
       dt3155_status[pci_index - 1].reg_addr = base;
       DT_3155_DEBUG_MSG("DT3155: New logical address is %p \n",
                        dt3155_lbase[pci_index-1]);
@@ -1036,7 +1031,7 @@ int init_module(void)
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
index 7792e71..485cc5e 100644
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
@@ -101,11 +103,11 @@ static int wait_ibsyclr(u8 *lpReg)
  * 2nd parameter is reg. index;
  * 3rd is value to be written
  */
-int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
+int WriteI2C(void __iomem *mmio, u_short wIregIndex, u8 byVal)
 {
        /* read 32 bit IIC_CSR2 register data into union */

-       ReadMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+       iic_csr2_r.reg = readl(mmio + IIC_CSR2);

        /* for write operation */
        iic_csr2_r.fld.DIR_RD      = 0;
@@ -117,10 +119,10 @@ int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
        iic_csr2_r.fld.NEW_CYCLE   = 1;

        /* xfer union data into 32 bit IIC_CSR2 register */
-       WriteMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+       writel(iic_csr2_r.reg, mmio + IIC_CSR2);

        /* wait for IIC cycle to finish */
-       return wait_ibsyclr(lpReg);
+       return wait_ibsyclr(mmio);
 }

 /*
@@ -132,12 +134,12 @@ int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
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
@@ -149,14 +151,14 @@ int ReadI2C(u8 *lpReg, u_short wIregIndex, u8 *byVal)
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
index d1a2510..a9aa754 100644
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
@@ -352,7 +347,7 @@ extern u8                   i2c_pm_lut_data;

 /* access 8-bit IIC registers */

-extern int ReadI2C(u8 *lpReg, u_short wIregIndex, u8 *byVal);
-extern int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal);
+extern int ReadI2C(void __iomem *mmio, u_short wIregIndex, u8 *byVal);
+extern int WriteI2C(void __iomem *mmio, u_short wIregIndex, u8 byVal);

 #endif
