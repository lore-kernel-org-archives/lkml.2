Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0C2He5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 03:34:57 -0400
Received: from mail.perches.com ([173.55.12.10]:1211 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab0C2Hed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 03:34:33 -0400
From: Joe Perches <joe@perches.com>
To: devel@driverdev.osuosl.org
Cc: Simon Horman <horms@verge.net.au>, Jason Baldus <jason.baldus@gmail.com>,
       Greg KH <gregkh@suse.de>, Scott Smedley <ss@aao.gov.au>,
       Harley Sweeten <hsweeten@visionengravers.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drivers/staging/dt3155: Integrate 3 badly styled files into 1 clean file
Date: Mon, 29 Mar 2010 00:34:28 -0700
Message-Id: <ba7a1e2464417043f00f78f6ddaab260c23c3cc9.1269847733.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269847733.git.joe@perches.com>
References: <20100329032301.GC27607@verge.net.au> <cover.1269847733.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make variables static where appropriate
Rename dt3155_<foo_with_long_names> variables to dt_<foo_tla>
to reduce code length and make more lines fit well in 80 chars
Remove now unnecessary .h files
Change indent to use tabs
Remove unused functions
Used bool more often
Checkpatch clean

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/dt3155/Makefile      |    5 +-
 drivers/staging/dt3155/dt3155_io.h   |   51 --
 drivers/staging/dt3155/dt3155_main.c | 1524 ++++++++++++++++++++++++++++++++++
 3 files changed, 1525 insertions(+), 55 deletions(-)
 create mode 100644 drivers/staging/dt3155/dt3155_main.c

diff --git a/drivers/staging/dt3155/Makefile b/drivers/staging/dt3155/Makefile
index 136f21f..ae2fc08 100644
--- a/drivers/staging/dt3155/Makefile
+++ b/drivers/staging/dt3155/Makefile
@@ -1,6 +1,3 @@
 obj-$(CONFIG_DT3155)	+= dt3155.o
-dt3155-objs :=	\
-		dt3155_drv.o	\
-		dt3155_isr.o	\
-		dt3155_io.o	\
+dt3155-objs :=	dt3155_main.o	\
 		allocator.o
diff --git a/drivers/staging/dt3155/dt3155_io.h b/drivers/staging/dt3155/dt3155_io.h
index d1a2510..74dcac0 100644
--- a/drivers/staging/dt3155/dt3155_io.h
+++ b/drivers/staging/dt3155/dt3155_io.h
@@ -214,31 +214,6 @@ typedef union dma_upper_lmt_tag   {
 /*
  * Global declarations of local copies of boards' 32 bit registers
  */
-extern u32 even_dma_start_r;		/*  bit 0 should always be 0 */
-extern u32 odd_dma_start_r;		/*               ..          */
-extern u32 even_dma_stride_r;	/*  bits 0&1 should always be 0 */
-extern u32 odd_dma_stride_r;		/*               ..             */
-extern u32 even_pixel_fmt_r;
-extern u32 odd_pixel_fmt_r;
-
-extern FIFO_TRIGGER_R		fifo_trigger_r;
-extern XFER_MODE_R		xfer_mode_r;
-extern CSR1_R			csr1_r;
-extern RETRY_WAIT_CNT_R		retry_wait_cnt_r;
-extern INT_CSR_R		int_csr_r;
-
-extern u32 even_fld_mask_r;
-extern u32 odd_fld_mask_r;
-
-extern MASK_LENGTH_R		mask_length_r;
-extern FIFO_FLAG_CNT_R		fifo_flag_cnt_r;
-extern IIC_CLK_DUR_R		iic_clk_dur_r;
-extern IIC_CSR1_R		iic_csr1_r;
-extern IIC_CSR2_R		iic_csr2_r;
-extern DMA_UPPER_LMT_R		even_dma_upper_lmt_r;
-extern DMA_UPPER_LMT_R		odd_dma_upper_lmt_r;
-
-
 
 /***************** 8 bit I2C register globals  ***********/
 #define CSR2		0x010	/* indices of 8-bit I2C mapped reg's*/
@@ -329,30 +304,4 @@ typedef union i2c_ad_cmd_tag {
 	} bt252_iout1;
 } I2C_AD_CMD;
 
-
-/***** Global declarations of local copies of boards' 8 bit I2C registers ***/
-
-extern I2C_CSR2			i2c_csr2;
-extern I2C_EVEN_CSR		i2c_even_csr;
-extern I2C_ODD_CSR		i2c_odd_csr;
-extern I2C_CONFIG		i2c_config;
-extern u8			i2c_dt_id;
-extern u8			i2c_x_clip_start;
-extern u8			i2c_y_clip_start;
-extern u8			i2c_x_clip_end;
-extern u8			i2c_y_clip_end;
-extern u8			i2c_ad_addr;
-extern u8			i2c_ad_lut;
-extern I2C_AD_CMD		i2c_ad_cmd;
-extern u8			i2c_dig_out;
-extern u8			i2c_pm_lut_addr;
-extern u8			i2c_pm_lut_data;
-
-/* Functions for Global use */
-
-/* access 8-bit IIC registers */
-
-extern int ReadI2C(u8 *lpReg, u_short wIregIndex, u8 *byVal);
-extern int WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal);
-
 #endif
diff --git a/drivers/staging/dt3155/dt3155_main.c b/drivers/staging/dt3155/dt3155_main.c
new file mode 100644
index 0000000..adfd3a7
--- /dev/null
+++ b/drivers/staging/dt3155/dt3155_main.c
@@ -0,0 +1,1524 @@
+/*
+ * This is the DT3155 Device Driver.
+ *
+ * The DT3155 Device Driver is free software; you can redistribute it
+ * and/or modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+
+ * The DT3155 Device Driver is distributed in the hope that it will be
+ * useful, but WITHOUT ANY WARRANTY; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with the DT3155 Device Driver; if not, write to the Free
+ * Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ * Copyright 1996,2002,2005 Gregory D. Hager, Alfred A. Rizzi, Noah J. Cowan,
+ *                          Jason Lapenta, Scott Smedley, Greg Sharp
+ *
+ * to do:
+ * + might want to get rid of MAXboards for allocating initial buffer.
+ *   confusing and not necessary
+ *
+ * + in cleanup_module the MOD_IN_USE looks like it is check after it should
+ *
+ * + GFP_DMA should not be set with a PCI system (pg 291)
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#ifndef CONFIG_PCI
+#error  "DT3155: Kernel PCI support not enabled (DT3155 drive requires PCI)"
+#endif
+
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/delay.h>
+#include <linux/wait.h>
+
+#ifdef MODULE
+#include <linux/module.h>
+
+MODULE_LICENSE("GPL");
+
+#endif
+
+#include <asm/system.h>
+
+#include "dt3155.h"
+#include "dt3155_io.h"
+#include "allocator.h"
+
+/* Error variable.  Zero means no error. */
+static int dt_errno;
+
+#ifndef PCI_DEVICE_ID_INTEL_7116
+#define PCI_DEVICE_ID_INTEL_7116 0x1223
+#endif
+
+#define DT3155_VENDORID    PCI_VENDOR_ID_INTEL
+#define DT3155_DEVICEID    PCI_DEVICE_ID_INTEL_7116
+#define MAXPCI    16
+
+#ifdef DT_DEBUG
+#define DPRINTK(fmt, args...)					\
+	printk(KERN_DEBUG KBUILD_MODNAME ": " fmt, ##args)
+#else
+#define DPRINTK(fmt, args...)						\
+do {									\
+	if (0)								\
+		printk(KERN_DEBUG KBUILD_MODNAME ": " fmt, ##args);	\
+} while (0)
+#endif
+
+/* wait queue for interrupts */
+static wait_queue_head_t dt_rwq[MAXBOARDS];
+
+#define DT_3155_SUCCESS 0
+#define DT_3155_FAILURE (-EIO)
+
+static int dt_major;
+
+/* The minor numbers are 0 and 1 ... they are not tunable.
+ * They are used as the indices for the structure vectors,
+ * and register address vectors
+ */
+
+/* Global structures and variables */
+
+/* Status of each device */
+static struct dt3155_status_s dt_status[MAXBOARDS];
+
+/* kernel logical address of the board */
+static u8 *dt_lbase[MAXBOARDS];
+
+/* DT3155 registers */
+static u32 dt_dev_open[MAXBOARDS];
+
+/* Pointer into structure for handling buffers */
+static struct dt3155_fbuffer_s *dt_fb[MAXBOARDS];
+
+static u32 unique_tag;
+static int ndevices;
+static u32 allocatorAddr;
+
+/*
+ * This section provides some basic register io routines.
+ * It is modified from demo code provided by Data Translations.
+ */
+
+/****** local copies of board's 32 bit registers ******/
+static u32 even_dma_start_r;		/*  bit 0 should always be 0 */
+static u32 odd_dma_start_r;		/*               .. */
+static u32 even_dma_stride_r;		/*  bits 0&1 should always be 0 */
+static u32 odd_dma_stride_r;		/*               .. */
+
+static CSR1_R csr1_r;
+static INT_CSR_R int_csr_r;
+
+static IIC_CSR1_R iic_csr1_r;
+static IIC_CSR2_R iic_csr2_r;
+
+/******** local copies of board's 8 bit I2C registers ******/
+static I2C_CSR2 i2c_csr2;
+static I2C_EVEN_CSR i2c_even_csr;
+static I2C_ODD_CSR i2c_odd_csr;
+static I2C_CONFIG i2c_config;
+
+/*****************************************************
+ * get_tail()
+ * m is minor # of device
+ *
+ * Simply comptutes the tail given the head and the length.
+ *****************************************************/
+static int get_tail(int m)
+{
+	return (dt_fb[m]->ready_head -
+		dt_fb[m]->ready_len +
+		dt_fb[m]->nbuffers) % dt_fb[m]->nbuffers;
+}
+
+/*****************************************************
+ * printques
+ * m is minor # of device
+ *****************************************************/
+static void printques(int m)
+{
+	int head = dt_fb[m]->ready_head;
+	int tail;
+	int num = dt_fb[m]->nbuffers;
+	int frame_index;
+	int index;
+
+	tail = get_tail(m);
+
+	pr_info("R:");
+	for (index = tail; index != head; index++, index = index % (num)) {
+		frame_index = dt_fb[m]->ready_que[index];
+		pr_cont(" %d ", frame_index);
+	}
+
+	pr_cont("\n");
+	pr_info("E:");
+	for (index = 0; index < dt_fb[m]->empty_len; index++) {
+		frame_index = dt_fb[m]->empty_buffers[index];
+		pr_cont(" %d ", frame_index);
+	}
+	pr_cont("\n");
+
+	frame_index = dt_fb[m]->active_buf;
+	pr_info("A: %d\n", frame_index);
+
+	frame_index = dt_fb[m]->locked_buf;
+	pr_info("L: %d\n", frame_index);
+}
+
+/*
+ * wait_ibsyclr()
+ *
+ * This function handles read/write timing and r/w timeout error
+ *
+ * Returns TRUE  if NEW_CYCLE clears
+ * Returns FALSE if NEW_CYCLE doesn't clear in roughly 3 msecs, otherwise
+ * returns 0
+ */
+static bool wait_ibsyclr(u8 *lpReg)
+{
+	/* wait 100 microseconds */
+	udelay(100L);
+	/* __delay(loops_per_sec/10000); */
+	if (iic_csr2_r.fld.NEW_CYCLE) {
+		/* if NEW_CYCLE didn't clear */
+		/* TIMEOUT ERROR */
+		dt_errno = DT_ERR_I2C_TIMEOUT;
+		return false;
+	}
+
+	return true;	/* no error */
+}
+
+/*
+ * WriteI2C()
+ *
+ * This function handles writing to 8-bit DT3155 registers
+ *
+ * 1st parameter is pointer to 32-bit register base address
+ * 2nd parameter is reg. index;
+ * 3rd is value to be written
+ *
+ * Returns true   -  Successful completion
+ *         false  -  Timeout error - cycle did not complete!
+ */
+bool WriteI2C(u8 *lpReg, u_short wIregIndex, u8 byVal)
+{
+	/* read 32 bit IIC_CSR2 register data into union */
+	ReadMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+
+	/* for write operation */
+	iic_csr2_r.fld.DIR_RD = 0;
+	/* I2C address of I2C register: */
+	iic_csr2_r.fld.DIR_ADDR = wIregIndex;
+	/* 8 bit data to be written to I2C reg */
+	iic_csr2_r.fld.DIR_WR_DATA = byVal;
+	/* will start a direct I2C cycle: */
+	iic_csr2_r.fld.NEW_CYCLE = 1;
+
+	/* xfer union data into 32 bit IIC_CSR2 register */
+	WriteMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+
+	/* wait for IIC cycle to finish */
+	return wait_ibsyclr(lpReg);
+}
+
+/*
+ * ReadI2C()
+ *
+ * This function handles reading from 8-bit DT3155 registers
+ *
+ * 1st parameter is pointer to 32-bit register base address
+ * 2nd parameter is reg. index;
+ * 3rd is adrs of value to be read
+ *
+ * Returns TRUE   -  Successful completion
+ *         FALSE  -  Timeout error - cycle did not complete!
+ */
+int ReadI2C(u8 *lpReg, u_short wIregIndex, u8 *byVal)
+{
+	bool writestat;		/* status for return */
+
+	/*  read 32 bit IIC_CSR2 register data into union */
+	ReadMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+
+	/*  for read operation */
+	iic_csr2_r.fld.DIR_RD = 1;
+
+	/*  I2C address of I2C register: */
+	iic_csr2_r.fld.DIR_ADDR = wIregIndex;
+
+	/*  will start a direct I2C cycle: */
+	iic_csr2_r.fld.NEW_CYCLE = 1;
+
+	/*  xfer union's data into 32 bit IIC_CSR2 register */
+	WriteMReg((lpReg + IIC_CSR2), iic_csr2_r.reg);
+
+	/* wait for IIC cycle to finish */
+	writestat = wait_ibsyclr(lpReg);
+
+	/* Next 2 commands read 32 bit IIC_CSR1 register's data into union */
+	/* first read data is in IIC_CSR1 */
+	ReadMReg((lpReg + IIC_CSR1), iic_csr1_r.reg);
+
+	/* now get data u8 out of register */
+	*byVal = (u8) iic_csr1_r.fld.RD_DATA;
+
+	return writestat;
+}
+
+/******************************************************************************
+ * Purpose: Buffer management routines, and other routines for the ISR
+ *****************************************************************************/
+
+#define FOUR_MB         (0x0400000)	/* Can't DMA accross a 4MB boundary! */
+#define UPPER_10_BITS   (0x3FF<<22)	/* Can't DMA accross a 4MB boundary! */
+
+/******************************************************************************
+ * Simple array based queue struct
+ *
+ * Some handy functions using the buffering structure.
+ *****************************************************************************/
+
+/***************************
+ * are_empty_buffers
+ * m is minor # of device
+ ***************************/
+static int are_empty_buffers(int m)
+{
+	return dt_fb[m]->empty_len;
+}
+
+/**************************
+ * push_empty
+ * m is minor # of device
+ *
+ * This is slightly confusing.  The number empty_len is the literal #
+ * of empty buffers.  After calling, empty_len-1 is the index into the
+ * empty buffer stack.  So, if empty_len == 1, there is one empty buffer,
+ * given by dt_fb[m]->empty_buffers[0].
+ * empty_buffers should never fill up, though this is not checked.
+ **************************/
+static void push_empty(int index, int m)
+{
+	dt_fb[m]->empty_buffers[dt_fb[m]->empty_len] = index;
+	dt_fb[m]->empty_len++;
+}
+
+/**************************
+ * pop_empty( m )
+ * m is minor # of device
+ **************************/
+static int pop_empty(int m)
+{
+	dt_fb[m]->empty_len--;
+	return dt_fb[m]->empty_buffers[dt_fb[m]->empty_len];
+}
+
+/*************************
+ * is_ready_buf_empty( m )
+ * m is minor # of device
+ *************************/
+static bool is_ready_buf_empty(int m)
+{
+	return (dt_fb[m]->ready_len) == 0;
+}
+
+/*****************************************************
+ * push_ready( m, buffer )
+ * m is minor # of device
+ *
+ *****************************************************/
+static void push_ready(int m, int index)
+{
+	int head = dt_fb[m]->ready_head;
+
+	dt_fb[m]->ready_que[head] = index;
+	dt_fb[m]->ready_head = (head + 1) % dt_fb[m]->nbuffers;
+	dt_fb[m]->ready_len++;
+}
+
+/*****************************************************
+ * pop_ready()
+ * m is minor # of device
+ *
+ * This assumes that there is a ready buffer ready... should
+ * be checked (e.g. with is_ready_buf_empty()  prior to call.
+ *****************************************************/
+static int pop_ready(int m)
+{
+	int tail = get_tail(m);
+
+	dt_fb[m]->ready_len--;
+	return dt_fb[m]->ready_que[tail];
+}
+
+/*****************************************************
+ * adjust_4MB
+ *
+ *  If a buffer intersects the 4MB boundary, push
+ *  the start address up to the beginning of the
+ *  next 4MB chunk (assuming bufsize < 4MB).
+ *****************************************************/
+static u32 adjust_4MB(u32 buf_addr, u32 bufsize)
+{
+	if (((buf_addr + bufsize) & UPPER_10_BITS) !=
+	    (buf_addr & UPPER_10_BITS))
+		return (buf_addr + bufsize) & UPPER_10_BITS;
+	return buf_addr;
+}
+
+/*****************************************************
+ * allocate_buffers
+ *
+ *  Try to allocate enough memory for all requested
+ *  buffers.  If there is not enough free space
+ *  try for less memory.
+ *****************************************************/
+void allocate_buffers(u32 *buf_addr, u32 *total_size_kbs, u32 bufsize)
+{
+	/* Compute the minimum amount of memory guaranteed to hold all
+	   MAXBUFFERS such that no buffer crosses the 4MB boundary.
+	   Store this value in the variable "full_size" */
+
+	u32 allocator_max;
+	u32 bufs_per_chunk = FOUR_MB / bufsize;
+	u32 filled_chunks = (MAXBUFFERS - 1) / bufs_per_chunk;
+	u32 leftover_bufs = MAXBUFFERS - filled_chunks * bufs_per_chunk;
+
+	u32 full_size = bufsize	/* possibly unusable part of 1st chunk */
+		+ filled_chunks * FOUR_MB
+				/* max # of completely filled 4mb chunks */
+		+ leftover_bufs * bufsize;
+				/* these buffs will be in a partly filled
+				 * chunk at beginning or end */
+
+	u32 full_size_kbs = 1 + (full_size - 1) / 1024;
+	u32 min_size_kbs = 2 * ndevices * bufsize / 1024;
+	u32 size_kbs;
+
+	/* Now, try to allocate full_size.  If this fails, keep trying for
+	   less & less memory until it succeeds. */
+#ifndef STANDALONE_ALLOCATOR
+	/* initialize the allocator */
+	allocator_init(&allocator_max);
+#endif
+	size_kbs = full_size_kbs;
+	*buf_addr = 0;
+	pr_info("We would like to get: %d KB\n", full_size_kbs);
+	pr_info("...but need at least: %d KB\n", min_size_kbs);
+	pr_info("...the allocator has: %d KB\n", allocator_max);
+	size_kbs = min(full_size_kbs, allocator_max);
+	if (size_kbs > min_size_kbs) {
+		*buf_addr = allocator_allocate_dma(size_kbs, GFP_KERNEL);
+		if (*buf_addr != 0) {
+			pr_info("Managed to allocate: %d KB\n", size_kbs);
+			*total_size_kbs = size_kbs;
+			return;
+		}
+	}
+	/* If we got here, the allocation failed */
+	pr_err("Allocator failed!\n");
+	*buf_addr = 0;
+	*total_size_kbs = 0;
+}
+
+/*****************************************************
+ * dt3155_setup_buffers
+ *
+ *  setup_buffers just puts the buffering system into
+ *  a consistent state before the start of interrupts
+ *
+ * JML : it looks like all the buffers need to be
+ * continuous. So I'm going to try and allocate one
+ * continuous buffer.
+ *
+ * GCS : Fix DMA problems when buffer spans
+ * 4MB boundary.  Also, add error checking.  This
+ * function will return -ENOMEM when not enough memory.
+ *****************************************************/
+static u32 dt3155_setup_buffers(u32 *allocatorAddr)
+{
+	u32 index;
+	u32 rambuff_addr;	/* start of allocation */
+	u32 rambuff_size;	/* total size allocated to driver */
+	u32 rambuff_acm;	/* accumlator, keep track of how much
+				   is left after being split up */
+	u32 rambuff_end;	/* end of rambuff */
+	u32 numbufs;		/* number of useful buffers allocated
+				   (per device) */
+	u32 bufsize = DT3155_MAX_ROWS * DT3155_MAX_COLS;
+	int m;			/* minor # of device, looped for all devs */
+
+	/* zero the fbuffer status and address structure */
+	for (m = 0; m < ndevices; m++) {
+		u8 *ptr;
+
+		dt_fb[m] = &(dt_status[m].fbuffer);
+		/* Make sure the buffering variables are consistent */
+		ptr = (u8 *)dt_fb[m];
+		for (index = 0; index < sizeof(struct dt3155_fbuffer_s);
+		     index++)
+			*(ptr++) = 0;
+	}
+
+	/* allocate a large contiguous chunk of RAM */
+	allocate_buffers(&rambuff_addr, &rambuff_size, bufsize);
+	pr_info("mem info\n");
+	pr_info("  - rambuf_addr = 0x%x\n", rambuff_addr);
+	pr_info("  - length (kb) = %u\n", rambuff_size);
+	if (rambuff_addr == 0) {
+		pr_err("Error setup_buffers() allocator dma failed\n");
+		return -ENOMEM;
+	}
+	*allocatorAddr = rambuff_addr;
+	rambuff_end = rambuff_addr + 1024 * rambuff_size;
+
+	/* after allocation, we need to count how many useful buffers there
+	   are so we can give an equal number to each device */
+	rambuff_acm = rambuff_addr;
+	for (index = 0; index < MAXBUFFERS; index++) {
+		rambuff_acm = adjust_4MB(rambuff_acm, bufsize);
+					/*avoid spanning 4MB bdry */
+		if (rambuff_acm + bufsize > rambuff_end)
+			break;
+		rambuff_acm += bufsize;
+	}
+	/* Following line is OK, will waste buffers if index
+	 * not evenly divisible by ndevices -NJC*/
+	numbufs = index / ndevices;
+	pr_info("  - numbufs = %u\n", numbufs);
+	if (numbufs < 2) {
+		pr_err("Error setup_buffers() couldn't allocate 2 bufs/board\n");
+		return -ENOMEM;
+	}
+
+	/* now that we have board memory we spit it up */
+	/* between the boards and the buffers          */
+	rambuff_acm = rambuff_addr;
+	for (m = 0; m < ndevices; m++) {
+		rambuff_acm = adjust_4MB(rambuff_acm, bufsize);
+
+		/* Save the start of this boards buffer space (for mmap). */
+		dt_status[m].mem_addr = rambuff_acm;
+
+		for (index = 0; index < numbufs; index++) {
+			rambuff_acm = adjust_4MB(rambuff_acm, bufsize);
+			if (rambuff_acm + bufsize > rambuff_end) {
+				/* Should never happen */
+				pr_info("DT3155 PROGRAM ERROR (GCS)\n"
+					"Error distributing allocated buffers\n");
+				return -ENOMEM;
+			}
+
+			dt_fb[m]->frame_info[index].addr = rambuff_acm;
+			push_empty(index, m);
+			/* pr_info("  - Buffer : %lx\n",
+			 * dt_fb[ m ]->frame_info[ index ].addr );
+			 */
+			dt_fb[m]->nbuffers += 1;
+			rambuff_acm += bufsize;
+		}
+
+		/* Make sure there is an active buffer there. */
+		dt_fb[m]->active_buf = pop_empty(m);
+		dt_fb[m]->even_happened = 0;
+		dt_fb[m]->even_stopped = 0;
+
+		/* make sure there is no locked_buf JML 2/28/00 */
+		dt_fb[m]->locked_buf = -1;
+
+		dt_status[m].mem_size = rambuff_acm - dt_status[m].mem_addr;
+
+		/* setup the ready queue */
+		dt_fb[m]->ready_head = 0;
+		dt_fb[m]->ready_len = 0;
+		pr_info("Available buffers for device %d: %d\n",
+			m, dt_fb[m]->nbuffers);
+	}
+
+	return 1;
+}
+
+/*****************************************************
+ * internal_release_locked_buffer
+ *
+ * The internal function for releasing a locked buffer.
+ * It assumes interrupts are turned off.
+ *
+ * m is minor number of device
+ *****************************************************/
+static void internal_release_locked_buffer(int m)
+{
+	/* Pointer into global structure for handling buffers */
+	if (dt_fb[m]->locked_buf >= 0) {
+		push_empty(dt_fb[m]->locked_buf, m);
+		dt_fb[m]->locked_buf = -1;
+	}
+}
+
+/*****************************************************
+ * dt3155_flush()
+ * m is minor # of device
+ *
+ *****************************************************/
+static int dt3155_flush(int m)
+{
+	int index;
+	unsigned long int flags;
+	local_save_flags(flags);
+	local_irq_disable();
+
+	internal_release_locked_buffer(m);
+	dt_fb[m]->empty_len = 0;
+
+	for (index = 0; index < dt_fb[m]->nbuffers; index++)
+		push_empty(index, m);
+
+	/* Make sure there is an active buffer there. */
+	dt_fb[m]->active_buf = pop_empty(m);
+
+	dt_fb[m]->even_happened = 0;
+	dt_fb[m]->even_stopped = 0;
+
+	/* setup the ready queue  */
+	dt_fb[m]->ready_head = 0;
+	dt_fb[m]->ready_len = 0;
+
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+/*****************************************************
+ * dt3155_get_ready_buffer()
+ * m is minor # of device
+ *
+ * get_ready_buffer will grab the next chunk of data
+ * if it is already there, otherwise it returns 0.
+ * If the user has a buffer locked it will unlock
+ * that buffer before returning the new one.
+ *****************************************************/
+static int dt3155_get_ready_buffer(int m)
+{
+	int frame_index;
+	unsigned long int flags;
+
+	local_save_flags(flags);
+	local_irq_disable();
+
+#ifdef DEBUG_QUES_A
+	printques(m);
+#endif
+
+	internal_release_locked_buffer(m);
+
+	if (is_ready_buf_empty(m))
+		frame_index = -1;
+	else {
+		frame_index = pop_ready(m);
+		dt_fb[m]->locked_buf = frame_index;
+	}
+
+#ifdef DEBUG_QUES_B
+	printques(m);
+#endif
+
+	local_irq_restore(flags);
+
+	return frame_index;
+}
+
+/*
+ * Stops interrupt generation right away and resets the status
+ * to idle.  I don't know why this works and the other way doesn't.
+ * (James Rose)
+ */
+static void quick_stop(int minor)
+{
+	/* TODO: scott was here */
+#if 1
+	ReadMReg((dt_lbase[minor] + INT_CSR), int_csr_r.reg);
+	/* disable interrupts */
+	int_csr_r.fld.FLD_END_EVE_EN = 0;
+	int_csr_r.fld.FLD_END_ODD_EN = 0;
+	WriteMReg((dt_lbase[minor] + INT_CSR), int_csr_r.reg);
+
+	dt_status[minor].state &= ~(DT3155_STATE_STOP | 0xff);
+	/* mark the system stopped: */
+	dt_status[minor].state |= DT3155_STATE_IDLE;
+	dt_fb[minor]->stop_acquire = 0;
+	dt_fb[minor]->even_stopped = 0;
+#else
+	dt_status[minor].state |= DT3155_STATE_STOP;
+	dt_status[minor].fbuffer.stop_acquire = 1;
+#endif
+}
+
+/*****************************************************
+ *  dt3155_isr() Interrupt service routine
+ *
+ * - looks like this isr supports IRQ sharing (or could) JML
+ * - Assumes irq's are disabled, via SA_INTERRUPT flag
+ * being set in request_irq() call from init_module()
+ *****************************************************/
+static inline void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
+{
+	int minor = -1;
+	int index;
+	unsigned long flags;
+	u32 buffer_addr;
+
+	/* find out who issued the interrupt */
+	for (index = 0; index < ndevices; index++) {
+		if (dev_id == (void *)&dt_status[index]) {
+			minor = index;
+			break;
+		}
+	}
+
+	/* hopefully we should not get here */
+	if (minor < 0 || minor >= MAXBOARDS) {
+		pr_err("dt3155_isr called with invalid dev_id\n");
+		return;
+	}
+
+	/* Check for corruption and set a flag if so */
+	ReadMReg((dt_lbase[minor] + CSR1), csr1_r.reg);
+
+	if ((csr1_r.fld.FLD_CRPT_EVE) || (csr1_r.fld.FLD_CRPT_ODD)) {
+		/* TODO: this should probably stop acquisition */
+		/* and set some flags so that dt3155_read      */
+		/* returns an error next time it is called     */
+		dt_errno = DT_ERR_CORRUPT;
+		pr_err("corrupt field\n");
+		return;
+	}
+
+	ReadMReg((dt_lbase[minor] + INT_CSR), int_csr_r.reg);
+
+	/* Handle the even field ... */
+	if (int_csr_r.fld.FLD_END_EVE) {
+		if ((dt_status[minor].state & DT3155_STATE_MODE) ==
+		    DT3155_STATE_FLD)
+			dt_fb[minor]->frame_count++;
+
+		ReadI2C(dt_lbase[minor], EVEN_CSR, &i2c_even_csr.reg);
+
+		/* Clear the interrupt? */
+		int_csr_r.fld.FLD_END_EVE = 1;
+
+		/* disable the interrupt if last field */
+		if (dt_fb[minor]->stop_acquire) {
+			pr_info("even stopped\n");
+			dt_fb[minor]->even_stopped = 1;
+			if (i2c_even_csr.fld.SNGL_EVE)
+				int_csr_r.fld.FLD_END_EVE_EN = 0;
+			else
+				i2c_even_csr.fld.SNGL_EVE = 1;
+		}
+
+		WriteMReg((dt_lbase[minor] + INT_CSR), int_csr_r.reg);
+
+		/* Set up next DMA if we are doing FIELDS */
+		if ((dt_status[minor].state & DT3155_STATE_MODE) ==
+		    DT3155_STATE_FLD) {
+			/* GCS (Aug 2, 2002) -- In field mode, dma the odd field
+			   into the lower half of the buffer */
+			const u32 stride = dt_status[minor].config.cols;
+			buffer_addr = dt_fb[minor]->frame_info[dt_fb
+						     [minor]->active_buf].addr +
+			    (DT3155_MAX_ROWS / 2) * stride;
+			local_save_flags(flags);
+			local_irq_disable();
+			wake_up_interruptible(&dt_rwq[minor]);
+
+			/* Set up the DMA address for the next field */
+			local_irq_restore(flags);
+			WriteMReg((dt_lbase[minor] + ODD_DMA_START),
+				  buffer_addr);
+		}
+
+		/* Check for errors. */
+		i2c_even_csr.fld.DONE_EVE = 1;
+		if (i2c_even_csr.fld.ERROR_EVE)
+			dt_errno = DT_ERR_OVERRUN;
+
+		WriteI2C(dt_lbase[minor], EVEN_CSR, i2c_even_csr.reg);
+
+		/* Note that we actually saw an even field meaning  */
+		/* that subsequent odd field complete the frame     */
+		dt_fb[minor]->even_happened = 1;
+
+		/* recording the time that the even field finished,
+		 * this should be about time in the middle of the frame */
+		do_gettimeofday(&(dt_fb[minor]->frame_info
+				  [dt_fb[minor]->active_buf].time));
+		return;
+	}
+
+	/* ... now handle the odd field */
+	if (int_csr_r.fld.FLD_END_ODD) {
+		ReadI2C(dt_lbase[minor], ODD_CSR, &i2c_odd_csr.reg);
+
+		/* Clear the interrupt? */
+		int_csr_r.fld.FLD_END_ODD = 1;
+
+		if (dt_fb[minor]->even_happened ||
+		    (dt_status[minor].state & DT3155_STATE_MODE) ==
+		    DT3155_STATE_FLD)
+			dt_fb[minor]->frame_count++;
+
+		if (dt_fb[minor]->stop_acquire && dt_fb[minor]->even_stopped) {
+			printk(KERN_DEBUG KBUILD_MODNAME ": " "stopping odd\n");
+			if (i2c_odd_csr.fld.SNGL_ODD) {
+				/* disable interrupts */
+				int_csr_r.fld.FLD_END_ODD_EN = 0;
+				dt_status[minor].state &=
+				    ~(DT3155_STATE_STOP | 0xff);
+
+				/* mark the system stopped: */
+				dt_status[minor].state |= DT3155_STATE_IDLE;
+				dt_fb[minor]->stop_acquire = 0;
+				dt_fb[minor]->even_stopped = 0;
+
+				printk(KERN_DEBUG KBUILD_MODNAME ": " "state is now %x\n",
+				       dt_status[minor].state);
+			} else
+				i2c_odd_csr.fld.SNGL_ODD = 1;
+		}
+
+		WriteMReg((dt_lbase[minor] + INT_CSR), int_csr_r.reg);
+
+		/* if the odd field has been acquired, then     */
+		/* change the next dma location for both fields */
+		/* and wake up the process if sleeping          */
+		if (dt_fb[minor]->even_happened ||
+		    (dt_status[minor].state & DT3155_STATE_MODE) ==
+		    DT3155_STATE_FLD) {
+
+			local_save_flags(flags);
+			local_irq_disable();
+
+#ifdef DEBUG_QUES_B
+			printques(minor);
+#endif
+			/* The number of active + locked buffers is
+			 * at most 2, and since there are none empty, there
+			 * must be at least nbuffers-2 ready buffers.
+			 * This is where we 'drop frames', oldest first. */
+
+			if (dt_fb[minor]->nbuffers > 2) {
+				if (!are_empty_buffers(minor))
+					push_empty(pop_ready(minor), minor);
+
+				/* The ready_que can't be full, since we know
+				 * there is one active buffer right now,
+				 * so it's safe to push the active buf on
+				 * the ready_que. */
+				push_ready(minor, dt_fb[minor]->active_buf);
+				/* There's at least 1 empty -- make it active */
+				dt_fb[minor]->active_buf = pop_empty(minor);
+				dt_fb[minor]->frame_info[dt_fb
+							 [minor]->
+							 active_buf].tag =
+				    ++unique_tag;
+			} else {	/* nbuffers == 2, special case */
+				/* There is 1 active buffer.
+				 * If there is a locked buffer,
+				 * keep the active buffer the same --
+				 * that means we drop a frame.
+				 */
+				if (dt_fb[minor]->locked_buf < 0) {
+					push_ready(minor,
+						   dt_fb[minor]->active_buf);
+					if (are_empty_buffers(minor))
+						dt_fb[minor]->active_buf =
+						    pop_empty(minor);
+					else	/* no empty or locked buffers,
+						 * so use a readybuf */
+						dt_fb[minor]->active_buf =
+						    pop_ready(minor);
+				}
+			}
+
+#ifdef DEBUG_QUES_B
+			printques(minor);
+#endif
+
+			dt_fb[minor]->even_happened = 0;
+
+			wake_up_interruptible(&dt_rwq[minor]);
+
+			local_irq_restore(flags);
+		}
+
+		/* Set up the DMA address for the next frame/field */
+		buffer_addr =
+		    dt_fb[minor]->frame_info[dt_fb[minor]->active_buf].addr;
+		if ((dt_status[minor].state & DT3155_STATE_MODE) ==
+		    DT3155_STATE_FLD) {
+			WriteMReg((dt_lbase[minor] + EVEN_DMA_START),
+				  buffer_addr);
+		} else {
+			WriteMReg((dt_lbase[minor] + EVEN_DMA_START),
+				  buffer_addr);
+
+			WriteMReg((dt_lbase[minor] + ODD_DMA_START),
+				  buffer_addr +
+				  dt_status[minor].config.cols);
+		}
+
+		/* Do error checking */
+		i2c_odd_csr.fld.DONE_ODD = 1;
+		if (i2c_odd_csr.fld.ERROR_ODD)
+			dt_errno = DT_ERR_OVERRUN;
+
+		WriteI2C(dt_lbase[minor], ODD_CSR, i2c_odd_csr.reg);
+
+		return;
+	}
+	/* If we get here, the Odd Field wasn't it either... */
+	pr_info("neither even nor odd.  shared perhaps?\n");
+}
+
+/*****************************************************
+ * init_isr(int minor)
+ *   turns on interupt generation for the card
+ *   designated by "minor".
+ *   It is called *only* from inside ioctl().
+ *****************************************************/
+static void dt3155_init_isr(int minor)
+{
+	const u32 stride = dt_status[minor].config.cols;
+
+	switch (dt_status[minor].state & DT3155_STATE_MODE) {
+	case DT3155_STATE_FLD:
+		even_dma_start_r = dt_status[minor].
+			fbuffer.frame_info[dt_status[minor].fbuffer.
+					       active_buf].addr;
+		even_dma_stride_r = 0;
+		odd_dma_stride_r = 0;
+
+		WriteMReg((dt_lbase[minor] + EVEN_DMA_START),
+			  even_dma_start_r);
+		WriteMReg((dt_lbase[minor] + EVEN_DMA_STRIDE),
+			  even_dma_stride_r);
+		WriteMReg((dt_lbase[minor] + ODD_DMA_STRIDE),
+			  odd_dma_stride_r);
+		break;
+
+	case DT3155_STATE_FRAME:
+	default:
+		even_dma_start_r =
+			dt_status[minor].
+			fbuffer.frame_info[dt_status[minor].fbuffer.
+					   active_buf].addr;
+		odd_dma_start_r = even_dma_start_r + stride;
+		even_dma_stride_r = stride;
+		odd_dma_stride_r = stride;
+
+		WriteMReg((dt_lbase[minor] + EVEN_DMA_START),
+			  even_dma_start_r);
+		WriteMReg((dt_lbase[minor] + ODD_DMA_START),
+			  odd_dma_start_r);
+		WriteMReg((dt_lbase[minor] + EVEN_DMA_STRIDE),
+			  even_dma_stride_r);
+		WriteMReg((dt_lbase[minor] + ODD_DMA_STRIDE),
+			  odd_dma_stride_r);
+		break;
+	}
+
+	/* 50/60 Hz should be set before this point but let's make sure it is */
+	/* right anyway */
+
+	ReadI2C(dt_lbase[minor], CONFIG, &i2c_csr2.reg);
+	i2c_csr2.fld.HZ50 = FORMAT50HZ;
+	WriteI2C(dt_lbase[minor], CONFIG, i2c_config.reg);
+
+	/* enable busmaster chip, clear flags */
+
+	/*
+	 * TODO:
+	 * shouldn't we be concerned with continuous values of
+	 * DT3155_SNAP & DT3155_ACQ here? (SS)
+	 */
+
+	csr1_r.reg = 0;
+	csr1_r.fld.CAP_CONT_EVE = 1;	/* use continuous capture bits to */
+	csr1_r.fld.CAP_CONT_ODD = 1;	/* enable */
+	csr1_r.fld.FLD_DN_EVE = 1;	/* writing a 1 clears flags */
+	csr1_r.fld.FLD_DN_ODD = 1;
+	csr1_r.fld.SRST = 1;		/* reset        - must be 1 */
+	csr1_r.fld.FIFO_EN = 1;		/* fifo control - must be 1 */
+	csr1_r.fld.FLD_CRPT_EVE = 1;	/* writing a 1 clears flags */
+	csr1_r.fld.FLD_CRPT_ODD = 1;
+
+	WriteMReg((dt_lbase[minor] + CSR1), csr1_r.reg);
+
+	/* Enable interrupts at the end of each field */
+
+	int_csr_r.reg = 0;
+	int_csr_r.fld.FLD_END_EVE_EN = 1;
+	int_csr_r.fld.FLD_END_ODD_EN = 1;
+	int_csr_r.fld.FLD_START_EN = 0;
+
+	WriteMReg((dt_lbase[minor] + INT_CSR), int_csr_r.reg);
+
+	/* start internal BUSY bits */
+
+	ReadI2C(dt_lbase[minor], CSR2, &i2c_csr2.reg);
+	i2c_csr2.fld.BUSY_ODD = 1;
+	i2c_csr2.fld.BUSY_EVE = 1;
+	WriteI2C(dt_lbase[minor], CSR2, i2c_csr2.reg);
+
+	/* Now its up to the interrupt routine!! */
+
+	return;
+}
+
+/*****************************************************
+ * ioctl()
+ *
+ *****************************************************/
+static int dt3155_ioctl(struct inode *inode, struct file *file,
+			unsigned int cmd, unsigned long arg)
+{
+	int minor = MINOR(inode->i_rdev);	/* device are we ioctl()'ing */
+
+	if (minor >= MAXBOARDS || minor < 0)
+		return -ENODEV;
+
+	/* make sure it is valid command */
+	if (_IOC_NR(cmd) > DT3155_IOC_MAXNR) {
+		pr_info("invalid IOCTL(0x%x)\n", cmd);
+		pr_info("Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
+			(unsigned int)DT3155_GET_CONFIG,
+			(unsigned int)DT3155_SET_CONFIG,
+			(unsigned int)DT3155_START,
+			(unsigned int)DT3155_STOP,
+			(unsigned int)DT3155_FLUSH);
+		return -EINVAL;
+	}
+
+	switch (cmd) {
+	case DT3155_SET_CONFIG: {
+		struct dt3155_config_s tmp;
+		if (dt_status[minor].state != DT3155_STATE_IDLE)
+			return -EBUSY;
+
+		if (copy_from_user
+		    ((void *)&tmp, (void *)arg, sizeof(tmp)))
+			return -EFAULT;
+			/* check for valid settings */
+		if (tmp.rows > DT3155_MAX_ROWS ||
+		    tmp.cols > DT3155_MAX_COLS ||
+		    (tmp.acq_mode != DT3155_MODE_FRAME &&
+		     tmp.acq_mode != DT3155_MODE_FIELD) ||
+		    (tmp.continuous != DT3155_SNAP &&
+		     tmp.continuous != DT3155_ACQ))
+			return -EINVAL;
+		dt_status[minor].config = tmp;
+		return 0;
+	}
+
+	case DT3155_GET_CONFIG:
+		if (copy_to_user((void *)arg, (void *)&dt_status[minor],
+				 sizeof(dt3155_status_t)))
+			return -EFAULT;
+		return 0;
+
+	case DT3155_FLUSH:	/* Flushes the buffers -- ensures fresh data */
+		if (dt_status[minor].state != DT3155_STATE_IDLE)
+			return -EBUSY;
+		return dt3155_flush(minor);
+
+	case DT3155_STOP:
+		if (dt_status[minor].state & DT3155_STATE_STOP ||
+		    dt_status[minor].fbuffer.stop_acquire)
+			return -EBUSY;
+
+		if (dt_status[minor].state == DT3155_STATE_IDLE)
+			return 0;
+
+		quick_stop(minor);
+		if (copy_to_user((void *)arg, (void *)&dt_status[minor],
+				 sizeof(dt3155_status_t)))
+			return -EFAULT;
+		return 0;
+
+	case DT3155_START:
+		if (dt_status[minor].state != DT3155_STATE_IDLE)
+			return -EBUSY;
+
+		dt_status[minor].fbuffer.stop_acquire = 0;
+		dt_status[minor].fbuffer.frame_count = 0;
+
+		/* Set the MODE in the status -- we default to FRAME */
+		if (dt_status[minor].config.acq_mode == DT3155_MODE_FIELD)
+			dt_status[minor].state = DT3155_STATE_FLD;
+		else
+			dt_status[minor].state = DT3155_STATE_FRAME;
+
+		dt3155_init_isr(minor);
+		if (copy_to_user((void *)arg, (void *)&dt_status[minor],
+				 sizeof(dt3155_status_t)))
+			return -EFAULT;
+		return 0;
+
+	default:
+		pr_info("invalid IOCTL(0x%x)\n", cmd);
+		pr_info("Valid commands (0x%x), (0x%x), (0x%x), (0x%x), (0x%x)\n",
+			(unsigned int)DT3155_GET_CONFIG,
+			(unsigned int)DT3155_SET_CONFIG,
+			DT3155_START, DT3155_STOP, DT3155_FLUSH);
+		return -ENOSYS;
+	}
+	return -ENOSYS;
+}
+
+/*****************************************************
+ * mmap()
+ *
+ * only allow the user to mmap the registers and buffer
+ * It is quite possible that this is broken, since the
+ * addition of of the capacity for two cards!!!!!!!!
+ * It *looks* like it should work but since I'm not
+ * sure how to use it, I'm not actually sure. (NJC? ditto by SS)
+ *****************************************************/
+static int dt3155_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	/* which device are we mmapping? */
+	int minor = MINOR(file->f_dentry->d_inode->i_rdev);
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+
+	if (offset >= __pa(high_memory) || (file->f_flags & O_SYNC))
+		vma->vm_flags |= VM_IO;
+
+	/* Don't try to swap out physical pages.. */
+	vma->vm_flags |= VM_RESERVED;
+
+	/* they are mapping the registers or the buffer */
+	if ((offset == dt_status[minor].reg_addr &&
+	     vma->vm_end - vma->vm_start == PCI_PAGE_SIZE) ||
+	    (offset == dt_status[minor].mem_addr &&
+	     vma->vm_end - vma->vm_start == dt_status[minor].mem_size)) {
+		if (remap_pfn_range(vma,
+				    vma->vm_start,
+				    offset >> PAGE_SHIFT,
+				    vma->vm_end - vma->vm_start,
+				    vma->vm_page_prot)) {
+			pr_err("remap_page_range() failed\n");
+			return -EAGAIN;
+		}
+	} else {
+		pr_err("dt3155_mmap() bad call\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+/*****************************************************
+ * open()
+ *
+ * Our special open code.
+ * MOD_INC_USE_COUNT make sure that the driver memory is not freed
+ * while the device is in use.
+ *****************************************************/
+static int dt3155_open(struct inode *inode, struct file *filep)
+{
+	int minor = MINOR(inode->i_rdev);	/* device are we opening */
+	if (dt_dev_open[minor]) {
+		pr_err("Already opened by another process\n");
+		return -EBUSY;
+	}
+
+	if (dt_status[minor].device_installed == 0) {
+		pr_err("Open Error: No such device dt3155 minor number %d\n",
+		       minor);
+		return -EIO;
+	}
+
+	if (dt_status[minor].state != DT3155_STATE_IDLE) {
+		pr_err("Not in idle state (state = %x)\n",
+		       dt_status[minor].state);
+		return -EBUSY;
+	}
+
+	pr_info("Device opened\n");
+
+	dt_dev_open[minor] = 1;
+
+	dt3155_flush(minor);
+
+	/* Disable ALL interrupts */
+	int_csr_r.reg = 0;
+	WriteMReg((dt_lbase[minor] + INT_CSR), int_csr_r.reg);
+
+	init_waitqueue_head(&(dt_rwq[minor]));
+
+	return 0;
+}
+
+/*****************************************************
+ * close()
+ *
+ * Now decrement the use count.
+ *
+ *****************************************************/
+static int dt3155_close(struct inode *inode, struct file *filep)
+{
+	int minor;
+
+	minor = MINOR(inode->i_rdev);	/* device are we closing */
+	if (!dt_dev_open[minor]) {
+		pr_err("attempt to CLOSE a not OPEN device\n");
+	} else {
+		dt_dev_open[minor] = 0;
+
+		if (dt_status[minor].state != DT3155_STATE_IDLE)
+			quick_stop(minor);
+	}
+	return 0;
+}
+
+/*****************************************************
+ * read()
+ *
+ *****************************************************/
+static ssize_t dt3155_read(struct file *filep, char __user *buf,
+			   size_t count, loff_t *ppos)
+{
+	/* which device are we reading from? */
+	int minor = MINOR(filep->f_dentry->d_inode->i_rdev);
+	u32 offset;
+	int frame_index;
+	frame_info_t *frame_info_p;
+
+	/* TODO: this should check the error flag and */
+	/*   return an error on hardware failures */
+	if (count != sizeof(dt3155_read_t)) {
+		pr_err("DT3155 ERROR (NJC): count is not right\n");
+		return -EINVAL;
+	}
+
+	/* Hack here -- I'm going to allow reading even when idle.
+	 * this is so that the frames can be read after STOP has
+	 * been called.  Leaving it here, commented out, as a reminder
+	 * for a short while to make sure there are no problems.
+	 * Note that if the driver is not opened in non_blocking mode,
+	 * and the device is idle, then it could sit here forever! */
+
+	/*  if (dt_status[minor].state == DT3155_STATE_IDLE) */
+	/*    return -EBUSY; */
+
+	/* non-blocking reads should return if no data */
+	if (filep->f_flags & O_NDELAY) {
+		frame_index = dt3155_get_ready_buffer(minor);
+		if (frame_index < 0) {
+			/*pr_info("no buffers available (?)\n"); */
+			/*              printques(minor); */
+			return -EAGAIN;
+		}
+	} else {
+		/*
+		 * sleep till data arrives , or we get interrupted.
+		 * Note that wait_event_interruptible() does not actually
+		 * sleep/wait if it's condition evaluates to true upon entry.
+		 */
+		wait_event_interruptible(dt_rwq[minor],
+					 (frame_index =
+					  dt3155_get_ready_buffer(minor))
+					 >= 0);
+
+		if (frame_index < 0) {
+			pr_err("read: interrupted\n");
+			quick_stop(minor);
+			printques(minor);
+			return -EINTR;
+		}
+	}
+
+	frame_info_p = &dt_status[minor].fbuffer.frame_info[frame_index];
+
+	/* make this an offset */
+	offset = frame_info_p->addr - dt_status[minor].mem_addr;
+
+	put_user(offset, (unsigned int *)buf);
+	buf += sizeof(u32);
+	put_user(dt_status[minor].fbuffer.frame_count, (unsigned int *)buf);
+	buf += sizeof(u32);
+	put_user(dt_status[minor].state, (unsigned int *)buf);
+	buf += sizeof(u32);
+	if (copy_to_user(buf, frame_info_p, sizeof(frame_info_t)))
+		return -EFAULT;
+
+	return sizeof(dt3155_read_t);
+}
+
+static unsigned int dt3155_poll(struct file *filp, poll_table *wait)
+{
+	int minor = MINOR(filp->f_dentry->d_inode->i_rdev);
+
+	if (!is_ready_buf_empty(minor))
+		return POLLIN | POLLRDNORM;
+
+	poll_wait(filp, &dt_rwq[minor], wait);
+
+	return 0;
+}
+
+/*****************************************************
+ * file operations supported by DT3155 driver
+ *  needed by init_module
+ *  register_chrdev
+ *****************************************************/
+static const struct file_operations dt3155_fops = {
+	.read		= dt3155_read,
+	.ioctl		= dt3155_ioctl,
+	.mmap		= dt3155_mmap,
+	.poll		= dt3155_poll,
+	.open		= dt3155_open,
+	.release	= dt3155_close
+};
+
+/*****************************************************
+ * find_PCI();
+ *
+ * PCI has been totally reworked in 2.1..
+ *****************************************************/
+static int find_PCI(void)
+{
+	struct pci_dev *pci_dev = NULL;
+	int error, pci_index = 0;
+	unsigned short rev_device;
+	unsigned long base;
+	unsigned char irq;
+
+	while ((pci_dev = pci_get_device
+		(DT3155_VENDORID, DT3155_DEVICEID, pci_dev)) != NULL) {
+		pci_index++;
+
+		/* Is it really there? */
+		error = pci_read_config_word(pci_dev, PCI_CLASS_DEVICE,
+					  &rev_device);
+		if (error)
+			continue;
+
+		/* Found a board */
+		DPRINTK("Device number %d\n", pci_index);
+
+		/* Make sure the driver was compiled with enough buffers
+		 * to handle this many boards */
+		if (pci_index > MAXBOARDS) {
+			pr_err("ERROR - found %d devices, but driver only configured for %d devices\n"
+			       "Please change MAXBOARDS in dt3155.h\n",
+			       pci_index, MAXBOARDS);
+			goto err;
+		}
+
+		/* Now, just go out and make sure that this/these device(s)
+		   is/are actually mapped into the kernel address space */
+		error = pci_read_config_dword(pci_dev, PCI_BASE_ADDRESS_0,
+					      (u32 *)&base);
+		if (error) {
+			pr_err("Was not able to find device\n");
+			goto err;
+		}
+
+		DPRINTK("Base address 0 for device is %lx\n", base);
+		dt_status[pci_index - 1].reg_addr = base;
+
+		/* Remap the base address to a logical address through which we
+		 * can access it. */
+		dt_lbase[pci_index - 1] = ioremap(base, PCI_PAGE_SIZE);
+		dt_status[pci_index - 1].reg_addr = base;
+		DPRINTK("New logical address is %p\n", dt_lbase[pci_index - 1]);
+		if (!dt_lbase[pci_index - 1]) {
+			pr_err("Unable to remap control registers\n");
+			goto err;
+		}
+
+		error = pci_read_config_byte(pci_dev, PCI_INTERRUPT_LINE, &irq);
+		if (error) {
+			pr_err("Was not able to find device\n");
+			goto err;
+		}
+
+		DPRINTK("IRQ is %d\n", irq);
+		dt_status[pci_index - 1].irq = irq;
+		/* Set flag: kth device found! */
+		dt_status[pci_index - 1].device_installed = 1;
+		pr_info("Installing device %d w/irq %d and address %p\n",
+			pci_index,
+			dt_status[pci_index - 1].irq,
+			dt_lbase[pci_index - 1]);
+
+	}
+	ndevices = pci_index;
+
+	return DT_3155_SUCCESS;
+
+err:
+	pci_dev_put(pci_dev);
+	return DT_3155_FAILURE;
+}
+
+/*****************************************************
+ * init_module()
+ *****************************************************/
+int init_module(void)
+{
+	int index;
+	int rcode = 0;
+	char *devname[MAXBOARDS];
+
+	devname[0] = "dt3155a";
+#if MAXBOARDS == 2
+	devname[1] = "dt3155b";
+#endif
+
+	pr_info("Loading module...\n");
+
+	/* Register the device driver */
+	rcode = register_chrdev(dt_major, "dt3155", &dt3155_fops);
+	if (rcode < 0) {
+		pr_err("register_chrdev failed\n");
+		return rcode;
+	}
+
+	if (dt_major == 0)
+		dt_major = rcode;	/* dynamic */
+
+	/* init the status variables.                     */
+	/* DMA memory is taken care of in setup_buffers() */
+	for (index = 0; index < MAXBOARDS; index++) {
+		dt_status[index].config.acq_mode = DT3155_MODE_FRAME;
+		dt_status[index].config.continuous = DT3155_ACQ;
+		dt_status[index].config.cols = DT3155_MAX_COLS;
+		dt_status[index].config.rows = DT3155_MAX_ROWS;
+		dt_status[index].state = DT3155_STATE_IDLE;
+
+		/* find_PCI() will check if devices are installed; */
+		/* first assume they're not:                       */
+		dt_status[index].mem_addr = 0;
+		dt_status[index].mem_size = 0;
+		dt_status[index].state = DT3155_STATE_IDLE;
+		dt_status[index].device_installed = 0;
+	}
+
+	/* Now let's find the hardware.  find_PCI() will set ndevices to the
+	 * number of cards found in this machine. */
+	{
+		rcode = find_PCI();
+		if (rcode != DT_3155_SUCCESS) {
+			pr_err("find_PCI() failed to find dt3155 board(s)\n");
+			unregister_chrdev(dt_major, "dt3155");
+			return rcode;
+		}
+	}
+
+	/* Ok, time to setup the frame buffers */
+	rcode = dt3155_setup_buffers(&allocatorAddr);
+	if (rcode < 0) {
+		pr_err("setting up buffer not large enough\n");
+		unregister_chrdev(dt_major, "dt3155");
+		return rcode;
+	}
+
+	/* If we are this far, then there is enough RAM */
+	/* for the buffers: Print the configuration.    */
+	for (index = 0; index < ndevices; index++) {
+		pr_info("Device = %d; acq_mode = %d; continuous = %d; cols = %d; rows = %d\n",
+			index,
+			dt_status[index].config.acq_mode,
+			dt_status[index].config.continuous,
+			dt_status[index].config.cols,
+			dt_status[index].config.rows);
+		pr_info("m_addr = 0x%x; m_size = %ld; state = %d; device_installed = %d\n",
+			dt_status[index].mem_addr,
+			(long int)dt_status[index].mem_size,
+			dt_status[index].state,
+			dt_status[index].device_installed);
+	}
+
+	/* Disable ALL interrupts */
+	int_csr_r.reg = 0;
+	for (index = 0; index < ndevices; index++) {
+		WriteMReg((dt_lbase[index] + INT_CSR), int_csr_r.reg);
+		if (dt_status[index].device_installed) {
+			/*
+			 * This driver *looks* like it can handle sharing
+			 * interrupts, but I can't actually test myself.
+			 * I've had reports that it DOES work so I'll enable
+			 * it for now. This comment will remain as a reminder
+			 * in case any problems arise. (SS)
+			 */
+			/* in older kernels flags are:
+			 *   SA_SHIRQ | SA_INTERRUPT */
+			rcode = request_irq(dt_status[index].irq,
+					    (void *)dt3155_isr,
+					    IRQF_SHARED | IRQF_DISABLED,
+					    devname[index],
+					    (void *)&dt_status[index]);
+			if (rcode < 0) {
+				pr_err("minor %d request_irq failed for IRQ %d\n",
+				       index, dt_status[index].irq);
+				unregister_chrdev(dt_major, "dt3155");
+				return rcode;
+			}
+		}
+	}
+
+	pr_info("finished loading\n");
+
+	return 0;
+}
+
+/*****************************************************
+ * cleanup_module(void)
+ *
+ *****************************************************/
+void cleanup_module(void)
+{
+	int index;
+
+	pr_info("cleanup_module called\n");
+
+	/* removed DMA allocated with the allocator */
+#ifdef STANDALONE_ALLOCATOR
+	if (allocatorAddr != 0)
+		allocator_free_dma(allocatorAddr);
+#else
+	allocator_cleanup();
+#endif
+
+	unregister_chrdev(dt_major, "dt3155");
+
+	for (index = 0; index < ndevices; index++) {
+		if (dt_status[index].device_installed == 1) {
+			pr_info("Freeing irq %d for device %d\n",
+				dt_status[index].irq, index);
+			free_irq(dt_status[index].irq,
+				 (void *)&dt_status[index]);
+		}
+	}
+}
-- 
1.7.0.14.g7e948

