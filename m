Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0D0LCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:02:42 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14598 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754339Ab0D0LCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:02:12 -0400
Message-ID: <001e01cae5f9$1510a430$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Intel OTC" <joel.clark@intel.com>,
       "Andrew" <andrew.chih.howe.khor@intel.com>
Subject: [PATCH] Topcliff UART: Add the UART driver [1/2]
MIME-Version: 1.0
Date: Tue, 27 Apr 2010 20:01:30 +0900
Content-Type: message/partial;
	total=2;
	id="01CAE5F9.14B84B00@tsmail03";
	number=1
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>,
	"Wang, Qi" <qi.wang@intel.com>,
	"Intel OTC" <joel.clark@intel.com>,
	"Andrew" <andrew.chih.howe.khor@intel.com>
Subject: [PATCH] Topcliff UART: Add the UART driver
Date: Tue, 27 Apr 2010 20:01:30 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983

From: Masayuki Ohtake <masa-korg@dsn.okisemi.com>

This driver implements UART controls for Topcliff.

Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>

---
 drivers/serial/8250.c      |
 drivers/serial/8250_pch.h  |
 drivers/serial/8250_pci.c  |
 drivers/serial/Kconfig     |
 drivers/serial/Makefile    |
+++++++++++++++++++++++++++++++ 5 files changed, zz insertions(+)
diff -urN linux-2.6.33.1/drivers/serial/8250.c
topcliff-2.6.33.1/drivers/serial/8250.c
--- linux-2.6.33.1/drivers/serial/8250.c 2010-03-16 01:09:39.000000000 +0900
+++ topcliff-2.6.33.1/drivers/serial/8250.c 2010-04-27 15:35:39.000000000
+0900
@@ -39,11 +39,19 @@
 #include <linux/nmi.h>
 #include <linux/mutex.h>

+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+/* For using DMA features. */
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/dma-mapping.h>
+#include "pch_dma_main.h"
+#endif
+
 #include <asm/io.h>
 #include <asm/irq.h>

 #include "8250.h"
-
+#include "8250_pch.h"
 #ifdef CONFIG_SPARC
 #include "suncore.h"
 #endif
@@ -129,6 +137,21 @@
 static unsigned int probe_rsa_count;
 #endif /* CONFIG_SERIAL_8250_RSA  */

+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+/* Structure for storing the DMA channel related information. */
+struct pch_dma_feature {
+ u32 buf;
+ u32 phy_addr;
+ s32 channel;
+ u32 size;
+};
+
+static u32 g_pch_uart_tx_flag;/*For exclusive processing*/
+
+#endif
+
+
+
 struct uart_8250_port {
  struct uart_port port;
  struct timer_list timer;  /* "no irq" timer */
@@ -159,6 +182,17 @@
   */
  void   (*pm)(struct uart_port *port,
           unsigned int state, unsigned int old);
+
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ struct pch_dma_feature rx_dma; /* DMA operation for Receive.  */
+ struct pch_dma_feature tx_dma; /* DMA operation for Transmit.  */
+ unsigned int buffer;  /* The buffer for DMA descriptors.*/
+ unsigned int buffer_phy; /* The physical address of the buffer.*/
+ unsigned int dma_flag;/* DMA flag variable for enabling DMA transfer. */
+ unsigned int rx_fifo_size;  /* The UART Rx fifo size.*/
+ unsigned int dma_progress;  /* The DMA in progress flag.*/
+ unsigned int dma_enabled;  /* The DMA enable flag. */
+#endif
 };

 struct irq_info {
@@ -299,6 +333,25 @@
   .fcr  = UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_00,
   .flags  = UART_CAP_FIFO | UART_CAP_AFE,
  },
+#if defined(ENABLE_SERIAL_8250_PCH)
+ [PORT_PCH_256FIFO] = {
+  .name       = "PCH_256FIFO",
+  .fifo_size  = 256,
+  .tx_loadsz  = 256,
+  .fcr        = UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10 |
+       UART_FCR7_256BYTE,
+  .flags      = UART_CAP_FIFO | UART_CAP_AFE,
+ },
+
+ [PORT_PCH_64FIFO] = {
+  .name       = "PCH_64FIFO",
+  .fifo_size  = 64,
+  .tx_loadsz  = 64,
+  .fcr        = UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10 |
+       UART_FCR7_64BYTE,
+  .flags      = UART_CAP_FIFO | UART_BUG_NOMSR,
+ },
+#endif
 };

 #if defined (CONFIG_SERIAL_8250_AU1X00)
@@ -383,6 +436,78 @@

 #endif

+
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+
+/* Function for calculating the Rx FIFO size of the PCH UART. */
+void get_rx_fifo_size(struct uart_8250_port *up, u8 fcr_value)
+{
+ unsigned fifo_size;
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"get_rx_fifo -> The FCR register value: %x.\n",
+         fcr_value);
+#endif
+/* check if the UART is a 64 byte FIFO UART */
+ if ((up->port.flags & UPF_PCH_UART_64_FIFO) != 0) {
+  switch ((fcr_value & 0xC0)) {
+  case 0:
+   fifo_size = 1;
+   break;
+
+  case 0x40:
+   fifo_size = 16;
+   break;
+
+  case 0x80:
+   fifo_size = 32;
+   break;
+
+  case 0xC0:
+   fifo_size = 56;
+   break;
+
+  default:
+   fifo_size = 1;
+   break;
+  }
+ } else {
+/* UART is 256 byte byte FIFO UART */
+  switch ((fcr_value & 0xC0)) {
+  case 0:
+   fifo_size = 1;
+   break;
+
+  case 0x40:
+   fifo_size = 64;
+   break;
+
+  case 0x80:
+   fifo_size = 128;
+   break;
+
+  case 0xC0:
+   fifo_size = 224;
+   break;
+
+  default:
+   fifo_size = 1;
+   break;
+  }
+ }
+/* save the fifo size for reference */
+ up->rx_fifo_size = fifo_size;
+#ifdef DEBUG
+ printk(KERN_DEBUG"Function get_rx_fifo_size stores fifo_size as: %u.\n",
+         fifo_size);
+#endif
+}
+
+#endif
+
+
+
+
 static unsigned int hub6_serial_in(struct uart_port *p, int offset)
 {
  offset = map_8250_in_reg(p, offset) << p->regshift;
@@ -550,15 +675,289 @@
  (up->port.serial_in(&(up)->port, (offset)))
 #define serial_out(up, offset, value) \
  (up->port.serial_out(&(up)->port, (offset), (value)))
+
 /*
  * We used to support using pause I/O for certain machines.  We
  * haven't supported this for a while, but just in case it's badly
  * needed for certain old 386 machines, I've left these #define's
  * in....
  */
+
 #define serial_inp(up, offset)  serial_in(up, offset)
 #define serial_outp(up, offset, value) serial_out(up, offset, value)

+
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+
+/* DMA TX callback function */
+void pch_dma_tx_callback(int status, unsigned long data)
+{
+ struct uart_8250_port *up = (struct uart_8250_port *)data;
+/* struct circ_buf *xmit = &up->port.info->xmit;*/
+ struct circ_buf *xmit = &up->port.state->xmit;/*for 2.6.33-rc3*/
+ u8 value;
+#ifdef DEBUG
+ if (status == PCH_DMA_END) {
+  printk(KERN_DEBUG"pch_dma_tx_callback -> DMA END interrupt"
+      "obtained "
+     "for transmission.\n");
+
+ }
+#endif
+ if (status == PCH_DMA_ABORT) {
+  printk(KERN_ERR"pch_dma_tx_callback -> DMA ABORT interrupt"
+     "obtained "
+    "for transmission.\n");
+ }
+
+ /* Un-mapping the DMA buffer. */
+ if (up->tx_dma.phy_addr > 0)
+  dma_unmap_single(up->port.dev, up->tx_dma.phy_addr,
+      up->tx_dma.size, DMA_TO_DEVICE);
+
+ dma_unmap_single(up->port.dev, up->buffer_phy,
+       PAGE_SIZE, DMA_TO_DEVICE);
+
+ /*Enable TX interrupt.*/
+ if (uart_circ_chars_pending(xmit)) {
+  value = (u8)serial_in(up, UART_IER);
+  serial_out(up, UART_IER, (value | 0x02));
+  up->ier = serial_in(up, UART_IER);
+ }
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ g_pch_uart_tx_flag = 0;
+#endif
+#ifdef DEBUG
+ printk(KERN_DEBUG"Function pch_dma_tx_callback invoked.\n");
+#endif
+}
+
+/* Function for DMA setting for Scatter Gather Mode. */
+void set_scatter_gather_dma_mode(struct uart_8250_port *up, unsigned count)
+{
+ u32 in_address;
+ u32 out_address;
+ u32 desc_address;
+ u32 total_desc;
+ u32 i, j;
+ u8 value;
+ struct pch_dma_desc *desc;
+ int channel = up->tx_dma.channel;
+ struct pch_dma_mode_param mode = {
+  .TransferDirection = PCH_DMA_DIR_OUT_TO_IN,
+  .DMASizeType  = PCH_DMA_SIZE_TYPE_8BIT,
+  .DMATransferMode = DMA_SCATTER_GATHER_MODE
+ };
+
+ desc = (struct pch_dma_desc *)up->tx_dma.buf;
+
+ /* Mapping the DMA buffer for transfer. */
+ out_address  = dma_map_single(up->port.dev, (void *)up->buffer,
+       PAGE_SIZE, DMA_TO_DEVICE);
+ in_address = up->port.mapbase + (map_8250_in_reg(up, UART_TX));
+ desc_address = dma_map_single(up->port.dev, (void *)up->tx_dma.buf,
+      up->tx_dma.size, DMA_TO_DEVICE);
+ up->buffer_phy = out_address;
+ up->tx_dma.phy_addr = desc_address;
+
+ /* Disable Transmit hardware interrupt.*/
+ g_pch_uart_tx_flag = 1;
+ value = (u8)serial_in(up, UART_IER);
+ serial_out(up, UART_IER, (value & 0xFD));
+ up->ier = serial_in(up, UART_IER);
+
+ total_desc = count/(up->tx_loadsz);
+
+ if ((count % (up->tx_loadsz)) > 0)
+  total_desc++;
+
+ dma_sync_single_for_cpu(up->port.dev, desc_address, up->tx_dma.size,
+         DMA_TO_DEVICE);
+
+ /* Organising the DMA descriptors. */
+ for (i = 0, j = 0; (i < total_desc && count > 0); i++) {
+  desc[i].insideAddress = in_address;
+  desc[i].outsideAddress = (out_address + j);
+
+  if ((int)(count - (up->tx_loadsz)) > 0) {
+   desc[i].size = up->tx_loadsz | PCH_DMA_SIZE_TYPE_8BIT;
+   count = count - (up->tx_loadsz);
+   j += (up->tx_loadsz);
+  } else {
+   desc[i].size = count | PCH_DMA_SIZE_TYPE_8BIT;
+   j += count;
+   count = 0;
+  }
+
+  desc[i].nextDesc = ((((u32)((desc_address +
+   ((i + 1)*(sizeof(struct pch_dma_desc)))))) & 0xFFFFFFFC) |
+     DMA_DESC_FOLLOW_WITHOUT_INTERRUPT);
+ }
+
+ desc[i - 1].nextDesc = (DMA_DESC_END_WITH_INTERRUPT);
+
+ dma_sync_single_for_device(up->port.dev, desc_address, up->tx_dma.size,
+         DMA_TO_DEVICE);
+
+ /* Initiating the DMA transfer. */
+ pch_set_dma_mode(channel, mode);
+ pch_set_dma_desc(channel, (struct pch_dma_desc *)((desc_address &
+   0xFFFFFFFC) | DMA_DESC_FOLLOW_WITHOUT_INTERRUPT),\
+  (((struct pch_dma_desc *)desc_address) + (total_desc - 1)));
+ pch_dma_set_callback(channel, pch_dma_tx_callback, (u32)up);
+ pch_enable_dma(channel);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"Function set_scatter_gather_dma_mode invoked.\n");
+#endif
+}
+
+/* Function for DMA settings for ONE SHOT mode. */
+void set_one_shot_dma_mode(struct uart_8250_port *up, unsigned count)
+{
+ u32 in_address;
+ u32 out_address;
+ u8 value;
+ int channel = up->tx_dma.channel;
+ struct pch_dma_mode_param mode = {
+  .TransferDirection = PCH_DMA_DIR_OUT_TO_IN,
+  .DMASizeType  = PCH_DMA_SIZE_TYPE_8BIT,
+  .DMATransferMode = DMA_ONE_SHOT_MODE
+        };
+
+ /* Disable Receive hardware interrupt.*/
+ g_pch_uart_tx_flag = 1;
+ value = (u8)serial_in(up, UART_IER);
+ serial_out(up, UART_IER, (value & 0xFD));
+ up->ier = serial_in(up, UART_IER);
+
+ /* Mapping the DMA buffer for transfer. */
+ out_address  = dma_map_single(up->port.dev, (void *)up->buffer,
+       PAGE_SIZE, DMA_TO_DEVICE);
+ in_address = up->port.mapbase + (map_8250_in_reg(up, UART_TX));
+ up->buffer_phy = out_address;
+ up->tx_dma.phy_addr = 0;
+
+ /* Initiating the DMA transfer. */
+ pch_set_dma_mode(channel, mode);
+ pch_set_dma_addr(channel, in_address, out_address);
+ pch_set_dma_count(channel, count);
+ pch_dma_set_callback(channel, pch_dma_tx_callback, (u32)up);
+ pch_enable_dma(channel);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"Function set_one_shot_dma_mode invoked.\n");
+#endif
+}
+
+/* Function for pushing the received characters to tty buffer. */
+/* At high baud rates tty buffer does not get emptied sufficiently fast
+     and hence multiple retries are required to push the data into the
buffer */
+
+static int push_rx(struct tty_struct *tty, const unsigned char *buf, int
size)
+{
+ u32 sz, i, j;
+ u32 loop;
+ u32 pushed;
+
+ for (pushed = 0, i = 0, loop = 1; (pushed < size) && loop;
+        pushed += sz, i++) {
+  sz = tty_insert_flip_string(tty, &buf[pushed], size - pushed);
+
+  for (j = 0; (j < 100000) && (sz == 0); j++) {
+   tty_flip_buffer_push(tty);
+   sz = tty_insert_flip_string(tty, &buf[pushed],
+         size - pushed);
+  }
+
+  if (sz == 0)
+   loop = 0;
+
+ }
+
+ tty_flip_buffer_push(tty);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"push_rx -> %d characters pushed. Remained " \
+   "%d characters.\n", pushed, size - pushed);
+ printk(KERN_DEBUG"Function push_rx return %u.\n", pushed);
+#endif
+
+ return pushed;
+}
+
+/* The DMA reception callback function. */
+void pch_dma_rx_callback(int status, unsigned long data)
+{
+ struct uart_8250_port *up = (struct uart_8250_port *)data;
+ unsigned fifo_size;
+      unsigned long flags;
+ u8 value;
+
+ spin_lock_irqsave(&up->port.lock, flags);
+
+ /* Normal end. */
+ if (status == PCH_DMA_END) {
+  /* Preparing the DMA buffer to be accessed by the CPU*/
+  dma_sync_single_for_cpu(up->port.dev, up->rx_dma.phy_addr,
+      up->rx_dma.size, DMA_FROM_DEVICE);
+
+#ifdef DEBUG
+  printk(KERN_DEBUG"pch_dma_rx_callback -> DMA END interrupt"
+       "obtained for reception.\n");
+#endif
+  fifo_size = up->rx_fifo_size;
+/*  push_rx(up->port.info->port.tty, (char *)up->rx_dma.buf,
+         fifo_size);*/
+  push_rx(up->port.state->port.tty, (char *)up->rx_dma.buf,
+      fifo_size);  /*for 2.6.33-rc3 */
+
+ } else if (status == PCH_DMA_ABORT) { /* DMA abort. */
+  printk(KERN_ERR"pch_dma_rx_callback -> DMA ABORT interrupt"
+       "obtained for reception.\n");
+ }
+
+ /* Unmapping the buffer from DMA accesible area. */
+ dma_unmap_single(up->port.dev, up->rx_dma.phy_addr, up->rx_dma.size,
+        DMA_FROM_DEVICE);
+
+ /*Enable hardware interrupt.*/
+ value = (u8)serial_in(up, UART_IER);
+ serial_out(up, UART_IER, (value | 0x01));
+ up->ier = serial_in(up, UART_IER);
+ up->dma_progress = 0;
+
+ spin_unlock_irqrestore(&up->port.lock, flags);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"pch_dma_rx_callback -> Function pch_dma_rx_callback"
+        "is invoked.\n");
+#endif
+}
+
+/* For initiating the DMA operation.*/
+void handle_dma_operation(struct uart_8250_port *up)
+{
+ u8 value;
+ int channel = up->rx_dma.channel;
+
+ /* Disable Receive hardware interrupt.*/
+ value = (u8)serial_in(up, UART_IER);
+ serial_out(up, UART_IER, (value & 0xFE));
+ up->ier = serial_in(up, UART_IER);
+
+ /* Enabling the DMA transfer. */
+ pch_enable_dma(channel);
+ up->dma_progress = 1;
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"handle_dma_operation -> DMA settings for reception"
+        "completed.\n");
+ printk(KERN_DEBUG"Function handle_dma_operation invoked.\n");
+#endif
+}
+#endif    /*for 2.6.33-rc3 */
+
 /* Uart divisor latch read */
 static inline int _serial_dl_read(struct uart_8250_port *up)
 {
@@ -725,7 +1124,8 @@
   result = !(mode & UART_RSA_MSR_FIFO);

   if (!result) {
-   serial_outp(up, UART_RSA_MSR, mode & ~UART_RSA_MSR_FIFO);
+   serial_outp(up, UART_RSA_MSR,
+       mode & ~UART_RSA_MSR_FIFO);
    mode = serial_inp(up, UART_RSA_MSR);
    result = !(mode & UART_RSA_MSR_FIFO);
   }
@@ -1093,7 +1493,18 @@
   return;

  DEBUG_AUTOCONF("ttyS%d: autoconf (0x%04lx, 0x%p): ",
-         serial_index(&up->port), up->port.iobase, up->port.membase);
+      serial_index(&up->port), up->port.iobase, up->port.membase);
+
+#if defined(ENABLE_SERIAL_8250_PCH)
+ if ((up->port.flags & UPF_PCH_UART) != 0) {
+  if ((up->port.flags & UPF_PCH_UART_64_FIFO) != 0)
+   /* PCH 2 Line 64 FIFO UART */
+   up->port.type = PORT_PCH_64FIFO;
+  else
+   /* PCH 8 Line 256 FIFO UART */
+    up->port.type = PORT_PCH_256FIFO;
+ }
+#endif

  /*
   * We really do need global IRQs disabled here - we're going to
@@ -1196,7 +1607,34 @@
   up->port.type = PORT_16550;
   break;
  case 3:
-  autoconfig_16550a(up);
+#ifdef ENABLE_SERIAL_8250_PCH
+  if ((up->port.type != PORT_PCH_256FIFO) &&
+      (up->port.type != PORT_PCH_64FIFO)) {
+#endif
+
+#ifdef DEBUG
+   printk(KERN_DEBUG
+   "PCH UART LOG:function autoconfig->autoconfig_16550a"
+    "invoked "
+   "for port %d\n", up->port.type);
+#endif
+   autoconfig_16550a(up);
+
+#ifdef ENABLE_SERIAL_8250_PCH
+  }
+#endif
+
+#ifdef ENABLE_SERIAL_8250_PCH
+  else {
+
+#ifdef DEBUG
+   printk(KERN_DEBUG
+   "PCH UART LOG:function autoconfig->autoconfig_16550a"
+    "not "
+   "invoked for PCH UART port %d\n", up->port.type);
+#endif
+  }
+#endif
   break;
  }

@@ -1224,18 +1662,40 @@
 #endif

  serial_outp(up, UART_LCR, save_lcr);
+#ifdef ENABLE_SERIAL_8250_PCH
+ if ((up->port.type != PORT_PCH_256FIFO) &&
+      (up->port.type != PORT_PCH_64FIFO)) {
+  /* autoconfig is not done for pch uarts.
+     hence do not report any kernel warning */
+#endif
+
+  if (up->capabilities != uart_config[up->port.type].flags) {
+    printk(KERN_WARNING "ttyS%d: detected"
+      "caps %08x should be %08x\n",
+     up->port.line, up->capabilities,
+     uart_config[up->port.type].flags);
+   }

- if (up->capabilities != uart_config[up->port.type].flags) {
-  printk(KERN_WARNING
-         "ttyS%d: detected caps %08x should be %08x\n",
-         serial_index(&up->port), up->capabilities,
-         uart_config[up->port.type].flags);
+#ifdef ENABLE_SERIAL_8250_PCH
  }
+#endif

  up->port.fifosize = uart_config[up->port.type].fifo_size;
  up->capabilities = uart_config[up->port.type].flags;
  up->tx_loadsz = uart_config[up->port.type].tx_loadsz;

+#ifdef DEBUG
+    printk(KERN_DEBUG
+ "PCH UART LOG:autoconfig: up->port.type = %d, up->port.fifosize =%d,"
+       "up->capabilities = %x, up->tx_loadsz = %d\n", up->port.type,
+        up->port.fifosize, up->capabilities, up->tx_loadsz);
+
+ printk(KERN_DEBUG
+       "PCH UART LOG:autoconfig: port.name = %s, port.fcr = %x\n",
+       uart_config[up->port.type].name, uart_config[up->port.type].fcr);
+
+#endif
+
  if (up->port.type == PORT_UNKNOWN)
   goto out;

@@ -1313,6 +1773,7 @@
  if (p->ier & UART_IER_THRI) {
   p->ier &= ~UART_IER_THRI;
   serial_out(p, UART_IER, p->ier);
+  g_pch_uart_tx_flag = 0;
  }
 }

@@ -1337,6 +1798,11 @@
 {
  struct uart_8250_port *up = (struct uart_8250_port *)port;

+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ if (g_pch_uart_tx_flag == 1) /*TX DMA does not finish yet*/
+  return;
+#endif
+
  if (!(up->ier & UART_IER_THRI)) {
   up->ier |= UART_IER_THRI;
   serial_out(up, UART_IER, up->ier);
@@ -1359,6 +1825,7 @@
   up->acr &= ~UART_ACR_TXDIS;
   serial_icr_write(up, UART_ACR, up->acr);
  }
+
 }

 static void serial8250_stop_rx(struct uart_port *port)
@@ -1461,7 +1928,17 @@
 static void transmit_chars(struct uart_8250_port *up)
 {
  struct circ_buf *xmit = &up->port.state->xmit;
- int count;
+ int count = 0;
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ unsigned limit = 0;
+ unsigned size = 0;
+#endif
+
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ if (g_pch_uart_tx_flag == 1) { /*Now on DMA transmitting.*/
+  return;
+ }
+#endif

  if (up->port.x_char) {
   serial_outp(up, UART_TX, up->port.x_char);
@@ -1478,15 +1955,53 @@
   return;
  }

+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ if (((up->port.flags & UPF_PCH_UART) != 0)) {
+  size = uart_circ_chars_pending(xmit);
+
+  if (size  > PAGE_SIZE)
+   size = PAGE_SIZE;
+
+  count = size;
+ }
+
+ else
+#endif
  count = up->tx_loadsz;
  do {
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+  if ((((up->port.flags & UPF_PCH_UART) != 0)) && (size > 0)) {
+   ((char *)(up->buffer))[limit] = xmit->buf[xmit->tail];
+   limit++;
+
+  } else
+#endif
   serial_out(up, UART_TX, xmit->buf[xmit->tail]);
+
   xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
   up->port.icount.tx++;
   if (uart_circ_empty(xmit))
    break;
  } while (--count > 0);

+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ if (limit > 0) {
+  if (limit > up->tx_loadsz) {
+   set_scatter_gather_dma_mode(up, limit);
+#ifdef DEBUG
+   printk(KERN_DEBUG"transmit_chars -> Function"
+     "set_scatter_gather_dma_mode invoked.\n");
+#endif
+  } else {
+   set_one_shot_dma_mode(up, limit);
+#ifdef DEBUG
+   printk(KERN_DEBUG"transmit_chars -> Function"
+      "set_one_shot_dma_mode invoked.\n");
+#endif
+  }
+ }
+#endif
+
  if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
   uart_write_wakeup(&up->port);

@@ -1494,6 +2009,10 @@

  if (uart_circ_empty(xmit))
   __stop_tx(up);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"Function transmit_chars invoked.\n");
+#endif
 }

 static unsigned int check_modem_status(struct uart_8250_port *up)
@@ -1509,9 +2028,11 @@
   if (status & UART_MSR_DDSR)
    up->port.icount.dsr++;
   if (status & UART_MSR_DDCD)
-   uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
+   uart_handle_dcd_change(&up->port,
+       status & UART_MSR_DCD);
   if (status & UART_MSR_DCTS)
-   uart_handle_cts_change(&up->port, status & UART_MSR_CTS);
+   uart_handle_cts_change(&up->port,
+       status & UART_MSR_CTS);

   wake_up_interruptible(&up->port.state->port.delta_msr_wait);
  }
@@ -1533,13 +2054,36 @@

  DEBUG_INTR("status = %x...", status);

- if (status & (UART_LSR_DR | UART_LSR_BI))
-  receive_chars(up, &status);
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ if ((up->dma_flag) && (up->dma_enabled)) {
+  /* If reception has to be done through DMA. */
+#ifdef DEBUG
+  printk(KERN_DEBUG"serial8250_handle_port ->"
+     "Proceeding to handle reception "
+    "interrupt through DMA operation.\n");
+#endif
+  handle_dma_operation(up);
+ } else {
+#endif
+
+  if ((status & (UART_LSR_DR | UART_LSR_BI))
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+   && (!up->dma_progress)
+#endif
+   )
+   receive_chars(up, &status);
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ }
+#endif
  check_modem_status(up);
  if (status & UART_LSR_THRE)
   transmit_chars(up);

  spin_unlock_irqrestore(&up->port.lock, flags);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"serial8250_handle_port invoked.\n");
+#endif
 }

 /*
@@ -1575,6 +2119,26 @@

   iir = serial_in(up, UART_IIR);
   if (!(iir & UART_IIR_NO_INT)) {
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+   /* Determing whether the receive FIFO is full. */
+   if ((iir & UART_IIR_RDI) && !(iir & 0x8) &&
+     ((up->port.flags & UPF_PCH_UART) != 0)) {
+
+    up->dma_flag = 1;
+
+#ifdef DEBUG
+    printk(KERN_DEBUG"serial8250_interrupt ->"
+      "DMA Mode enabled for reception.\n");
+#endif
+   } else {
+    up->dma_flag = 0;
+#ifdef DEBUG
+    printk(KERN_DEBUG"serial8250_interrupt ->"
+      "DMA Mode disabled for reception.\n");
+#endif
+   }
+#endif
+
    serial8250_handle_port(up);

    handled = 1;
@@ -1946,6 +2510,167 @@
  unsigned char lsr, iir;
  int retval;

+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ /* Initialising the device for DMA support. */
+ int dma_flag = 0;
+ up->dma_progress = 0;
+ up->dma_enabled = 0;
+
+ if ((up->port.flags & UPF_PCH_UART) != 0) {
+  struct pci_dev pdev;
+
+/*  switch((up->port.flags & 0xE000000))*/
+  switch ((up->port.flags & (UPF_PCH_UART | UPF_PCH_UART_BIT0 |
+       UPF_PCH_UART_BIT1))) {
+  case UPF_PCH_UART0:
+#ifdef DEBUG
+   printk(KERN_DEBUG"serial8250_startup ->"
+        "UART0 detected.\n");
+#endif
+   pdev.device = PCI_DEVICE_ID_PCH_UART0;
+   up->port.mctrl |= TIOCM_RTS;
+   break;
+
+  case UPF_PCH_UART1:
+#ifdef DEBUG
+   printk(KERN_DEBUG"serial8250_startup ->"
+        "UART1 detected.\n");
+#endif
+   pdev.device = PCI_DEVICE_ID_PCH_UART1;
+   break;
+
+  case UPF_PCH_UART2:
+#ifdef DEBUG
+   printk(KERN_DEBUG"serial8250_startup ->"
+        "UART2 detected.\n");
+#endif
+   pdev.device = PCI_DEVICE_ID_PCH_UART2;
+   break;
+
+  case UPF_PCH_UART3:
+#ifdef DEBUG
+   printk(KERN_DEBUG"serial8250_startup ->"
+        "UART3 detected.\n");
+#endif
+   pdev.device = PCI_DEVICE_ID_PCH_UART3;
+   break;
+
+  default:
+   break;
+  }
+
+  /* Allocating space for DMA buffer. */
+  up->rx_dma.buf = (u32)__get_free_page(GFP_KERNEL|GFP_DMA);
+  if (!(up->rx_dma.buf)) {
+   printk(KERN_ERR"serial8250_startup -> DMA buffer"
+      "allocation "
+     "failed for Rx DMA buffer.\n");
+   return -ENOMEM;
+  }
+
+  /* For transmission process. */
+  up->tx_dma.buf = (u32)__get_free_page(GFP_KERNEL|GFP_DMA);
+  if (!(up->tx_dma.buf)) {
+   free_page(up->rx_dma.buf);
+   printk(KERN_ERR"serial8250_startup -> DMA buffer"
+      "allocation "
+     "failed for TX DMA buffer.\n");
+   return -ENOMEM;
+  }
+
+  /* For copying of transmit data. */
+  up->buffer = (u32)__get_free_page(GFP_KERNEL|GFP_DMA);
+  if (!(up->buffer)) {
+   free_page(up->rx_dma.buf);
+   free_page(up->tx_dma.buf);
+   printk(KERN_ERR"serial8250_startup -> DMA buffer"
+      "allocation "
+     "failed for Buffer.\n");
+   return -ENOMEM;
+  }
+
+  up->rx_dma.size = PAGE_SIZE;
+  up->tx_dma.size = PAGE_SIZE;
+
+  /* Requesting for DMA channel for reception. */
+  up->rx_dma.channel = pch_request_dma(&pdev,
+        PCH_DMA_RX_DATA_REQ0);
+  if (up->rx_dma.channel < 0) {
+   free_page(up->rx_dma.buf);
+   free_page(up->tx_dma.buf);
+   free_page(up->buffer);
+   up->rx_dma.buf = 0;
+   up->tx_dma.buf = 0;
+   up->buffer = 0;
+
+   printk(KERN_ERR"serial8250_startup -> DMA channel"
+      "allocation for "
+     "reception failed.\n");
+   return -EIO;
+  }
+
+  /* Requesting DMA channel for transmission. */
+  up->tx_dma.channel = pch_request_dma(&pdev,
+        PCH_DMA_TX_DATA_REQ0);
+  if (up->tx_dma.channel < 0) {
+   free_page(up->rx_dma.buf);
+   free_page(up->tx_dma.buf);
+   free_page(up->buffer);
+   up->rx_dma.buf = 0;
+   up->tx_dma.buf = 0;
+   up->buffer = 0;
+   pch_free_dma(up->rx_dma.channel);
+
+   printk(KERN_ERR"serial8250_startup -> DMA channel"
+        "allocation for "
+     "transmission failed.\n");
+   return -EIO;
+  }
+
+  /* Performing DMA settings for reception. */
+  {
+   u32 in_address;
+   u32 out_address;
+   u32 size;
+   int channel = up->rx_dma.channel;
+   struct pch_dma_mode_param mode = {
+    .TransferDirection = PCH_DMA_DIR_IN_TO_OUT,
+    .DMASizeType = PCH_DMA_SIZE_TYPE_8BIT,
+    .DMATransferMode = DMA_ONE_SHOT_MODE
+   };
+
+   /* Mapping the DMA buffer to DMA accessible area and
+       obtaining its base address. */
+   out_address = dma_map_single(up->port.dev,
+       (void *)up->rx_dma.buf,
+       up->rx_dma.size,
+       DMA_FROM_DEVICE);
+   in_address = up->port.mapbase +
+       (map_8250_in_reg(up, UART_RX));
+   size  = up->rx_fifo_size;
+   up->rx_dma.phy_addr = out_address;
+
+   /* Setting the DMA settings. */
+   (void)pch_set_dma_mode(channel, mode);
+   (void)pch_set_dma_addr(channel, in_address,
+         out_address);
+   (void)pch_set_dma_count(channel, size);
+   (void)pch_dma_set_callback(channel, pch_dma_rx_callback,
+         (u32)up);
+  }
+
+  dma_flag = 1;
+
+#ifdef DEBUG
+  printk(KERN_DEBUG"serial8250_startup -> Buffer Allocation"
+        "successful and DMA "
+    "channels obtained are Reception: %d"
+       "Transmission: %d.\n",
+    up->rx_dma.channel, up->tx_dma.channel);
+#endif
+ }
+#endif
+
  up->capabilities = uart_config[up->port.type].flags;
  up->mcr = 0;

@@ -1996,6 +2721,21 @@
      (serial_inp(up, UART_LSR) == 0xff)) {
   printk(KERN_INFO "ttyS%d: LSR safety check engaged!\n",
          serial_index(&up->port));
+
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ /* Releasing the DMA resources on failure.*/
+ if (dma_flag == 1) {
+  pch_free_dma(up->rx_dma.channel);
+  pch_free_dma(up->tx_dma.channel);
+  free_page(up->rx_dma.buf);
+  free_page(up->tx_dma.buf);
+  free_page(up->buffer);
+  up->rx_dma.buf = 0;
+  up->tx_dma.buf = 0;
+  up->buffer = 0;
+ }
+#endif
+
   return -ENODEV;
  }

@@ -2008,9 +2748,11 @@
   serial_outp(up, UART_LCR, 0xbf);

   fctr = serial_inp(up, UART_FCTR) & ~(UART_FCTR_RX|UART_FCTR_TX);
-  serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD | UART_FCTR_RX);
+  serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD |
+         UART_FCTR_RX);
   serial_outp(up, UART_TRG, UART_TRG_96);
-  serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD | UART_FCTR_TX);
+  serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD |
+         UART_FCTR_TX);
   serial_outp(up, UART_TRG, UART_TRG_96);

   serial_outp(up, UART_LCR, 0);
@@ -2076,8 +2818,22 @@
   mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout));
  } else {
   retval = serial_link_irq_chain(up);
-  if (retval)
+  if (retval) {
+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+   /* Releasing the DMA resources on failure.*/
+   if (dma_flag == 1) {
+    pch_free_dma(up->rx_dma.channel);
+    pch_free_dma(up->tx_dma.channel);
+    free_page(up->rx_dma.buf);
+    free_page(up->tx_dma.buf);
+    free_page(up->buffer);
+    up->rx_dma.buf = 0;
+    up->tx_dma.buf = 0;
+    up->buffer = 0;
+   }
+  #endif
    return retval;
+  }
  }

  /*
@@ -2124,7 +2880,8 @@
  if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT) {
   if (!(up->bugs & UART_BUG_TXEN)) {
    up->bugs |= UART_BUG_TXEN;
-   pr_debug("ttyS%d - enabling bad tx status workarounds\n",
+   pr_debug("ttyS%d - enabling bad tx status"
+     "workarounds\n",
      serial_index(port));
   }
  } else {
@@ -2172,6 +2929,31 @@
  struct uart_8250_port *up = (struct uart_8250_port *)port;
  unsigned long flags;

+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ /* Releasing the DMA resources on exit.*/
+ if ((up->port.flags & UPF_PCH_UART) != 0) {
+  if (up->rx_dma.channel >= 0)
+   pch_free_dma(up->rx_dma.channel);
+  if (up->tx_dma.channel >= 0)
+   pch_free_dma(up->tx_dma.channel);
+
+  if (up->rx_dma.buf)
+   free_page(up->rx_dma.buf);
+  if (up->tx_dma.buf)
+   free_page(up->tx_dma.buf);
+  if (up->buffer)
+   free_page(up->buffer);
+
+  up->rx_dma.buf = 0;
+  up->tx_dma.buf = 0;
+  up->buffer = 0;
+
+#ifdef DEBUG
+  printk(KERN_DEBUG"serial8250_shutdown -> DMA buffers and"
+       "channels released.\n");
+#endif
+ }
+#endif
  /*
   * Disable interrupts from this port
   */
@@ -2214,7 +2996,8 @@
   serial_unlink_irq_chain(up);
 }

-static unsigned int serial8250_get_divisor(struct uart_port *port, unsigned
int baud)
+static unsigned int serial8250_get_divisor(struct uart_port *port,
+        unsigned int baud)
 {
  unsigned int quot;

@@ -2242,6 +3025,7 @@
  unsigned char cval, fcr = 0;
  unsigned long flags;
  unsigned int baud, quot;
+ unsigned int bdrate;

  switch (termios->c_cflag & CSIZE) {
  case CS5:
@@ -2278,6 +3062,11 @@
       port->uartclk / 16);
  quot = serial8250_get_divisor(port, baud);

+#ifdef DEBUG
+ printk(KERN_DEBUG "PCH UART LOG:max_baud: %d\n,baud :%d\n quot:%d\n"
+       , max_baud, baud, quot);
+#endif
+
  /*
   * Oxford Semi 952 rev B workaround
   */
@@ -2285,12 +3074,37 @@
   quot++;

  if (up->capabilities & UART_CAP_FIFO && up->port.fifosize > 1) {
-  if (baud < 2400)
+  if (baud < 2400) {
    fcr = UART_FCR_ENABLE_FIFO | UART_FCR_TRIGGER_1;
-  else
-   fcr = uart_config[up->port.type].fcr;
+
+#ifdef ENABLE_SERIAL_8250_PCH
+    if ((up->port.flags & UPF_PCH_UART) != 0)
+     /*This enables 256 byte FIFO
+        for UART 0.*/
+     fcr |= UART_FCR7_64BYTE;
+
+#endif
+   } else
+    fcr = uart_config[up->port.type].fcr;
  }

+#if defined(ENABLE_SERIAL_8250_PCH) && defined(ENABLE_PCH_DMA_FEATURE)
+ /* Deciding whether to use DMA feature or not.*/
+ if ((baud >= 38400) && ((up->port.flags & UPF_PCH_UART) != 0))
+  up->dma_enabled = 1;
+ else
+  up->dma_enabled = 0;
+
+
+ get_rx_fifo_size(up, fcr);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG"serial8250_set_termios -> The Rx fifo size is: %u\n",
+        up->rx_fifo_size);
+#endif
+
+#endif
+
  /*
   * MCR-based auto flow control.  When AFE is enabled, RTS will be
   * deasserted when the receive FIFO contains more characters than
@@ -2409,8 +3223,22 @@
  serial8250_set_mctrl(&up->port, up->port.mctrl);
  spin_unlock_irqrestore(&up->port.lock, flags);
  /* Don't rewrite B0 */
- if (tty_termios_baud_rate(termios))
+
+ bdrate = tty_termios_baud_rate(termios);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG "tty_termios_baud_rate value:%d\n", bdrate);
+#endif
+
+ if (bdrate) {
   tty_termios_encode_baud_rate(termios, baud, baud);
+
+#ifdef DEBUG
+  printk(KERN_DEBUG "termios->c_ispeed:%d\n,"
+    "termios->c_ospeed:%d\n "
+   , termios->c_ispeed, termios->c_ospeed);
+#endif
+ }
 }

 static void
@@ -2580,18 +3408,24 @@
  if (ret < 0)
   probeflags &= ~PROBE_RSA;

+
  if (up->port.iotype != up->cur_iotype)
   set_io_from_upio(port);

+
  if (flags & UART_CONFIG_TYPE)
   autoconfig(up, probeflags);
+
  if (up->port.type != PORT_UNKNOWN && flags & UART_CONFIG_IRQ)
   autoconfig_irq(up);

+
  if (up->port.type != PORT_RSA && probeflags & PROBE_RSA)
   serial8250_release_rsa_resource(up);
+
  if (up->port.type == PORT_UNKNOWN)
   serial8250_release_std_resource(up);
+
 }

 static int
@@ -2686,6 +3520,7 @@
   up->port.regshift = old_serial_port[i].iomem_reg_shift;
   set_io_from_upio(&up->port);
   up->port.irqflags |= irqflag;
+
  }
 }

@@ -2967,7 +3802,8 @@
   port.irqflags  |= irqflag;
   ret = serial8250_register_port(&port);
   if (ret < 0) {
-   dev_err(&dev->dev, "unable to register port at index %d "
+   dev_err(&dev->dev, "unable to register port at"
+     "index %d "
     "(IO%lx MEM%llx IRQ%d): %d\n", i,
     p->iobase, (unsigned long long)p->mapbase,
     p->irq, ret);
@@ -3044,7 +3880,8 @@
  */
 static DEFINE_MUTEX(serial_mutex);

-static struct uart_8250_port *serial8250_find_match_or_unused(struct
uart_port *port)
+static
+struct uart_8250_port *serial8250_find_match_or_unused(struct uart_port
*port)
 {
  int i;

@@ -3251,7 +4088,8 @@
  " (unsafe)");

 module_param(nr_uarts, uint, 0644);
-MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. (1-"
__MODULE_STRING(CONFIG_SERIAL_8250_NR_UARTS) ")");
+MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. \
+   (1-" __MODULE_STRING(CONFIG_SERIAL_8250_NR_UARTS) ")");

 module_param(skip_txen_test, uint, 0644);
 MODULE_PARM_DESC(skip_txen_test, "Skip checking for the TXEN bug at init
time");
diff -urN linux-2.6.33.1/drivers/serial/8250_pch.h
topcliff-2.6.33.1/drivers/serial/8250_pch.h
--- linux-2.6.33.1/drivers/serial/8250_pch.h 1970-01-01 09:00:00.000000000
+0900
+++ topcliff-2.6.33.1/drivers/serial/8250_pch.h 2010-04-27
11:46:21.000000000 +0900
@@ -0,0 +1,58 @@
+/*!
+ * @file 8250_pch.h
+ * @brief Provides the macro definitions used by all files.
+ * @version 1.0.0.0
+ * @sectionc
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307,
USA.
+ */
+
+/*
+ * History:
+ * Copyright (C) 2008 OKI SEMICONDUCTOR Co., LTD.
+ *
+ *
+ * created:
+ * OKISEMI 04/14/2010
+ *
+ */
+
+#ifndef __PCH_8250_PCH_H__
+#define __PCH_8250_PCH_H__
+
+#define PORT_PCH_256FIFO 128 /* PCH UART with 256 byte FIFO */
+#define PORT_PCH_64FIFO  129 /* PCH UART with 64 byte FIFO */
+
+/* flags for PCH port detection */
+/* The below fields are used to identify the PCH UART port 0 to 3 */
+#define UPF_PCH_UART_BIT0 ((__force upf_t) (1 << 17))
+#define UPF_PCH_UART_BIT1  ((__force upf_t) (1 << 18))
+
+#define UPF_PCH_UART    ((__force upf_t) (1 << 19))
+#define UPF_PCH_UART0    ((UPF_PCH_UART) | (0))
+#define UPF_PCH_UART1 ((UPF_PCH_UART) | ((__force upf_t)
(UPF_PCH_UART_BIT0)))
+#define UPF_PCH_UART2 ((UPF_PCH_UART) | ((__force upf_t)
(UPF_PCH_UART_BIT1)))
+#define UPF_PCH_UART3 ((UPF_PCH_UART) | ((__force upf_t) (UPF_PCH_UART_BIT0
|\
+        UPF_PCH_UART_BIT1)))
+#define UPF_PCH_UART_64_FIFO  ((__force upf_t) ((UPF_PCH_UART_BIT0 |\
+        UPF_PCH_UART_BIT1)))
+
+#define UART_FCR7_256BYTE 0x20 /* Go into 256 byte FIFO mode (PCH UART) */
+
+/* Intel PCH GE UART PCI device IDs */
+#define PCI_DEVICE_ID_PCH_UART0 (0x8811)
+#define PCI_DEVICE_ID_PCH_UART1 (0x8812)
+#define PCI_DEVICE_ID_PCH_UART2 (0x8813)
+#define PCI_DEVICE_ID_PCH_UART3 (0x8814)
+
+#endif
diff -urN linux-2.6.33.1/drivers/serial/8250_pci.c
topcliff-2.6.33.1/drivers/serial/8250_pci.c
--- linux-2.6.33.1/drivers/serial/8250_pci.c 2010-03-16 01:09:39.000000000
+0900
+++ topcliff-2.6.33.1/drivers/serial/8250_pci.c 2010-04-27
16:13:47.000000000 +0900
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/pci_ids.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -27,7 +28,7 @@
 #include <asm/io.h>

 #include "8250.h"
-
+#include "8250_pch.h"
 #undef SERIAL_DEBUG_PCI

 /*
@@ -726,6 +727,87 @@
 #define NI8430_PORTCON 0x0f
 #define NI8430_PORTCON_TXVR_ENABLE (1 << 3)

+#if defined(ENABLE_SERIAL_8250_PCH)
+
+static int
+pci_pch_init(struct pci_dev *dev)
+{
+ int retval = 0;
+
+#ifdef DEBUG
+ printk(KERN_DEBUG "PCH UART LOG:function pci_pch_init invoked \n");
+
+ printk(KERN_DEBUG "PCH UART LOG:function pci_pch_init->pci_enable_wake
invoked \n");
+#endif
+
+ /* disable Wake on UART */
+ pci_enable_wake(dev, PCI_D3hot, 0);
+
+#ifdef DEBUG
+ printk(KERN_DEBUG "PCH UART LOG:function pci_pch_init return = %d\n",
+         retval);
+#endif
+
+ return retval;
+}
+
+static int
+pci_pch_setup(struct serial_private *priv, const struct pciserial_board
*board,
+  struct uart_port *port, int idx)
+{
+ int retval = 1 ;
+ unsigned int bar = 0;
+ unsigned int offset = 0;
+
+ if (idx == 0) {
+  /* PCH UART has only 1 channel per device */
+  switch (priv->dev->device) {
+  case PCI_DEVICE_ID_PCH_UART0:
+   port->flags |= UPF_PCH_UART0;
+   break;
+
+  case PCI_DEVICE_ID_PCH_UART1:
+   port->flags |= UPF_PCH_UART1;
+   break;
+
+  case PCI_DEVICE_ID_PCH_UART2:
+   port->flags |= UPF_PCH_UART2;
+   break;
+
+  case PCI_DEVICE_ID_PCH_UART3:
+   port->flags |= UPF_PCH_UART3;
+   break;
+
+  default:
+   break;
+  }
+
+  retval = setup_port(priv, port, bar, offset, board->reg_shift);
+
+  #ifdef ENABLE_PCH_DMA_FEATURE
+   /* Obtaing the Memory Map base for DMA operations. */
+   port->mapbase = pci_resource_start(priv->dev, 1);
+  #ifdef DEBUG
+   printk(KERN_DEBUG"pci_pch_setup -> The Map Base has been obtained.\n");
+  #endif
+  #endif
+ }
+
+
+#ifdef DEBUG
+ printk(KERN_DEBUG "pci_pch_setup -> Function pci_pch_setup invoked \n");
+ printk(KERN_DEBUG "pci_pch_setup -> board.base_baud = %d, flags = %d,"
+    "num_ports = %d,reg_shift = %d\n",
+   board->base_baud, board->flags,
+    board->num_ports, board->reg_shift);
+ printk(KERN_DEBUG "pci_pch_setup -> port->flags =%x\n", port->flags);
+ printk(KERN_DEBUG "Function pci_pch_setup return = %d\n", retval);
+
+#endif
+ return retval;
+}
+#endif
+
 static int
 pci_ni8430_setup(struct serial_private *priv,
    const struct pciserial_board *board,
@@ -918,7 +1000,8 @@
      (dev->device & 0xF000) != 0xC000)
   return 0;

- p = pci_iomap(dev, 0, 5);
+ /*p = pci_iomap(dev, 0, 5);*/
+ p = pci_iomap(dev, 1, 5);
  if (p == NULL)
   return -ENOMEM;

@@ -1393,6 +1476,43 @@
   .setup  = pci_default_setup,
  },
  /*
+  * PCH UART
+  */
+#if defined(ENABLE_SERIAL_8250_PCH)
+ {
+  .vendor     = PCI_VENDOR_ID_INTEL,
+  .device     = PCI_DEVICE_ID_PCH_UART0,
+  .subvendor  = PCI_ANY_ID,
+  .subdevice  = PCI_ANY_ID,
+  .init  = pci_pch_init,
+  .setup      = pci_pch_setup,
+ },
+ {
+  .vendor     = PCI_VENDOR_ID_INTEL,
+  .device     = PCI_DEVICE_ID_PCH_UART1,
+  .subvendor  = PCI_ANY_ID,
+  .subdevice  = PCI_ANY_ID,
+  .init  = pci_pch_init,
+  .setup      = pci_pch_setup,
+ },
+ {
+  .vendor     = PCI_VENDOR_ID_INTEL,
+  .device     = PCI_DEVICE_ID_PCH_UART2,

