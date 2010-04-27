Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0D0LCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:02:15 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14594 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276Ab0D0LCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:02:12 -0400
Message-ID: <001f01cae5f9$157be920$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Intel OTC" <joel.clark@intel.com>,
       "Andrew" <andrew.chih.howe.khor@intel.com>
Subject: [PATCH] Topcliff UART: Add the UART driver [2/2]
MIME-Version: 1.0
Date: Tue, 27 Apr 2010 20:01:30 +0900
Content-Type: message/partial;
	total=2;
	id="01CAE5F9.14B84B00@tsmail03";
	number=2
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


+  .subvendor  = PCI_ANY_ID,
+  .subdevice  = PCI_ANY_ID,
+  .init  = pci_pch_init,
+  .setup      = pci_pch_setup,
+ },
+ {
+  .vendor     = PCI_VENDOR_ID_INTEL,
+  .device     = PCI_DEVICE_ID_PCH_UART3,
+  .subvendor  = PCI_ANY_ID,
+  .subdevice  = PCI_ANY_ID,
+  .init  = pci_pch_init,
+  .setup      = pci_pch_setup,
+ },
+#endif
+ /*
   * Default "match everything" terminator entry
   */
  {
@@ -1571,6 +1691,10 @@
  pbn_ADDIDATA_PCIe_2_3906250,
  pbn_ADDIDATA_PCIe_4_3906250,
  pbn_ADDIDATA_PCIe_8_3906250,
+#if defined(ENABLE_SERIAL_8250_PCH)
+ pbn_pch_uart_8L_256FIFO,  /* pch 8 Line UART with 256 byte FIFO */
+ pbn_pch_uart_2L_64FIFO    /* pch 2 Line UART with 64 byte FIFO */
+#endif
 };

 /*
@@ -2228,6 +2352,27 @@
   .uart_offset = 0x200,
   .first_offset = 0x1000,
  },
+
+#if defined(ENABLE_SERIAL_8250_PCH)
+
+ /*
+  * PCH UART
+  */
+ [pbn_pch_uart_8L_256FIFO] = {
+  .flags      = FL_BASE0,
+  .num_ports  = 1,
+  .base_baud  = 115200,  /* OKISEMI For LSI */
+  .reg_shift  = 0,
+ },
+
+ [pbn_pch_uart_2L_64FIFO] = {
+  .flags      = FL_BASE0,
+  .num_ports  = 1,
+  .base_baud  = 115200,  /* OKISEMI For LSI*/
+  .reg_shift  = 0,
+ },
+#endif
+
 };

 static const struct pci_device_id softmodem_blacklist[] = {
@@ -2473,8 +2618,20 @@
   return -EINVAL;
  }

+#ifdef DEBUG
+ printk(KERN_DEBUG "PCH UART LOG:function pciserial_init_one ent->vendor"
+        " = %x\n, ent->device = %x, ent->driver_data = %ld\n  ",
+        ent->vendor, ent->device, ent->driver_data);
+#endif
+
  board = &pci_boards[ent->driver_data];

+#ifdef DEBUG
+ printk(KERN_DEBUG "PCH UART LOG:function pciserial_init_one board->"
+       "base_baud = %u\n, board->flags = %d, board->num_ports = %d\n "
+       , board->base_baud, board->flags, board->num_ports);
+#endif
+
  rc = pci_enable_device(dev);
  if (rc)
   return rc;
@@ -2540,6 +2697,17 @@
  if (priv)
   pciserial_suspend_ports(priv);

+#if defined(ENABLE_SERIAL_8250_PCH)
+
+#ifdef DEBUG
+ printk(KERN_DEBUG "PCH UART LOG:pciserial_suspend_one->pci_enable_wake"
+       "invoked \n");
+#endif
+
+
+ pci_enable_wake(dev, PCI_D3hot, 1);
+#endif
+
  pci_save_state(dev);
  pci_set_power_state(dev, pci_choose_state(dev, state));
  return 0;
@@ -2561,6 +2729,17 @@
   /* FIXME: We cannot simply error out here */
   if (err)
    printk(KERN_ERR "pciserial: Unable to re-enable ports, trying to
continue.\n");
+
+#if defined(ENABLE_SERIAL_8250_PCH)
+
+#ifdef DEBUG
+ printk(KERN_DEBUG "PCH UART LOG:pciserial_resume_one->pci_enable_wake"
+       "invoked \n");
+#endif
+
+ pci_enable_wake(dev, PCI_D3hot, 0);
+#endif
+
   pciserial_resume_ports(priv);
  }
  return 0;
@@ -3649,6 +3828,48 @@
   0, 0, pbn_b0_1_115200 },

  /*
+  * PCH UART
+  */
+#if defined(ENABLE_SERIAL_8250_PCH)
+
+ {   PCI_VENDOR_ID_INTEL,
+  /*device id for pch uart with 8 i/o lines and 256 byte fifo. */
+  PCI_DEVICE_ID_PCH_UART0,
+  PCI_ANY_ID,
+  PCI_ANY_ID,
+  0,
+  0,
+  pbn_pch_uart_8L_256FIFO },
+
+ {   PCI_VENDOR_ID_INTEL,
+  /*device id for pch uart with 2 i/o lines and 256 byte fifo. */
+  PCI_DEVICE_ID_PCH_UART1,
+  PCI_ANY_ID,
+  PCI_ANY_ID,
+  0,
+  0,
+  pbn_pch_uart_2L_64FIFO },
+
+ {   PCI_VENDOR_ID_INTEL,
+  /*device id for pch uart with 8 i/o lines and 64 byte fifo. */
+  PCI_DEVICE_ID_PCH_UART2,
+  PCI_ANY_ID,
+  PCI_ANY_ID,
+  0,
+  0,
+  pbn_pch_uart_2L_64FIFO },
+
+ {   PCI_VENDOR_ID_INTEL,
+  /*device id for pch uart with 2 i/o lines and 64 byte fifo. */
+  PCI_DEVICE_ID_PCH_UART3,
+  PCI_ANY_ID,
+  PCI_ANY_ID,
+  0,
+  0,
+  pbn_pch_uart_2L_64FIFO },
+#endif
+
+ /*
   * These entries match devices with class COMMUNICATION_SERIAL,
   * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
   */
diff -urN linux-2.6.33.1/drivers/serial/Kconfig
topcliff-2.6.33.1/drivers/serial/Kconfig
--- linux-2.6.33.1/drivers/serial/Kconfig 2010-03-16 01:09:39.000000000
+0900
+++ topcliff-2.6.33.1/drivers/serial/Kconfig 2010-03-23 10:34:44.000000000
+0900
@@ -89,6 +89,21 @@
    disable this feature if you only need legacy serial support.
    Saves about 9K.

+config SERIAL_8250_PCH
+ tristate "PCH PCI serial device support"
+ depends on SERIAL_8250 && PCI && SERIAL_8250_PCI
+ default SERIAL_8250_PCI
+ help
+   This makes the PCH PCI serial driver to support high speed PCH serial
ports.
+
+config SERIAL_8250_PCH_DMA
+ bool "Enable DMA mode of PCH PCI serial device"
+ depends on SERIAL_8250_PCH
+ select PCH_UART_DMA
+ default y
+ help
+   This makes the PCH PCI serial driver with DMA mode.
+
 config SERIAL_8250_PNP
  tristate "8250/16550 PNP device support" if EMBEDDED
  depends on SERIAL_8250 && PNP
diff -urN linux-2.6.33.1/drivers/serial/Makefile
topcliff-2.6.33.1/drivers/serial/Makefile
--- linux-2.6.33.1/drivers/serial/Makefile 2010-03-16 01:09:39.000000000
+0900
+++ topcliff-2.6.33.1/drivers/serial/Makefile 2010-04-27 11:29:58.000000000
+0900
@@ -1,6 +1,17 @@
 #
 # Makefile for the kernel serial device drivers.
 #
+#
+#This is needed to enable pch dma#
+#EXTRA_CFLAGS +=-DENABLE_PCH_DMA_FEATURE
+ifdef CONFIG_SERIAL_8250_PCH
+EXTRA_CFLAGS +=-DENABLE_SERIAL_8250_PCH
+endif
+
+ifdef CONFIG_PCH_UART_DMA
+EXTRA_CFLAGS +=-DENABLE_PCH_DMA_FEATURE
+EXTRA_CFLAGS +=-Idrivers/dma/pch_dma/
+endif

 obj-$(CONFIG_SERIAL_CORE) += serial_core.o
 obj-$(CONFIG_SERIAL_21285) += 21285.o

