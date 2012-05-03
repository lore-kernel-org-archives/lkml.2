Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab2ECHs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:48:26 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:37088 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2ECHsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:48:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAFo3ok9bdWOb/2dsb2JhbABEsyOBB4IKAQUaAQxAEhBRVwYThhGCALsEkQgElX6BEYRlikyCaoFa
X-IronPort-AV: E=Sophos;i="4.75,522,1330902000"; 
   d="scan'208";a="508220748"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Staging: ipack: add support for IP-OCTAL mezzanine board
Date: Thu,  3 May 2012 09:47:47 +0200
Message-Id: <1336031267-10689-4-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336031267-10689-1-git-send-email-siglesias@igalia.com>
References: <1336031267-10689-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IP-OCTAL is a 8-channels serial port device. There are several models one per
each standard: RS-232, RS-422, RS-485.

This driver can manage all of them.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/Kconfig           |    2 +
 drivers/staging/ipack/Makefile          |    1 +
 drivers/staging/ipack/devices/Kconfig   |    7 +
 drivers/staging/ipack/devices/Makefile  |    1 +
 drivers/staging/ipack/devices/ipoctal.c |  841 +++++++++++++++++++++++++++++++
 drivers/staging/ipack/devices/ipoctal.h |   81 +++
 drivers/staging/ipack/devices/scc2698.h |  229 +++++++++
 7 files changed, 1162 insertions(+)

diff --git a/drivers/staging/ipack/Kconfig b/drivers/staging/ipack/Kconfig
index a3f5925..7fa8676 100644
--- a/drivers/staging/ipack/Kconfig
+++ b/drivers/staging/ipack/Kconfig
@@ -10,6 +10,8 @@ menuconfig IPACK_BUS
 
 if IPACK_BUS
 
+source "drivers/staging/ipack/devices/Kconfig"
+
 source "drivers/staging/ipack/bridges/Kconfig"
 
 endif # IPACK
diff --git a/drivers/staging/ipack/Makefile b/drivers/staging/ipack/Makefile
index 59b8762..85ff223 100644
--- a/drivers/staging/ipack/Makefile
+++ b/drivers/staging/ipack/Makefile
@@ -2,4 +2,5 @@
 # Makefile for the IPACK bridge device drivers.
 #
 obj-$(CONFIG_IPACK_BUS)		+= ipack.o
+obj-y				+= devices/
 obj-y				+= bridges/
diff --git a/drivers/staging/ipack/devices/Kconfig b/drivers/staging/ipack/devices/Kconfig
new file mode 100644
index 0000000..a8b61e2
--- /dev/null
+++ b/drivers/staging/ipack/devices/Kconfig
@@ -0,0 +1,7 @@
+config SERIAL_IPOCTAL
+	bool "IndustryPack IP-OCTAL uart support"
+	depends on IPACK_BUS
+	help
+	  This driver supports the IPOCTAL serial port device for the IndustryPack bus.
+	default n
+
diff --git a/drivers/staging/ipack/devices/Makefile b/drivers/staging/ipack/devices/Makefile
new file mode 100644
index 0000000..6de18bd
--- /dev/null
+++ b/drivers/staging/ipack/devices/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SERIAL_IPOCTAL) += ipoctal.o
diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
new file mode 100644
index 0000000..91b77ca
--- /dev/null
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -0,0 +1,841 @@
+/**
+ * ipoctal.c
+ *
+ * driver for the GE IP-OCTAL boards
+ * Copyright (c) 2009 Nicolas Serafini, EIC2 SA
+ * Copyright (c) 2010,2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
+ * Copyright (c) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/interrupt.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/tty.h>
+#include <linux/serial.h>
+#include <linux/tty_flip.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include "../ipack.h"
+#include "ipoctal.h"
+#include "scc2698.h"
+
+#define MODULE_NAME "ipoctal"
+#define PFX MODULE_NAME ": "
+#define IP_OCTAL_MANUFACTURER_ID    0xF0
+#define IP_OCTAL_232_ID             0x22
+#define IP_OCTAL_422_ID             0x2A
+#define IP_OCTAL_485_ID             0x48
+
+#define IP_OCTAL_ID_SPACE_VECTOR    0x41
+#define IP_OCTAL_NB_BLOCKS          4
+#define DELAY_MICROSECONDS          1
+#define MAX_CHAR		    256
+
+static struct ipack_driver driver;
+const struct tty_operations ipoctal_fops;
+
+struct ipoctal {
+	struct list_head		list;
+	struct ipack_device		*dev;
+	unsigned int			board_id;
+	struct scc2698_channel		*chan_regs;
+	struct scc2698_block		*block_regs;
+	struct ipoctal_stats		chan_stats[NR_CHANNELS];
+	char				*buffer[NR_CHANNELS];
+	unsigned int			nb_bytes[NR_CHANNELS];
+	unsigned int			count_wr[NR_CHANNELS];
+	struct ipoctal_config		chan_config[NR_CHANNELS];
+	wait_queue_head_t		queue[NR_CHANNELS];
+	unsigned short			error_flag[NR_CHANNELS];
+	spinlock_t			lock[NR_CHANNELS];
+	struct mutex			lock_write[NR_CHANNELS];
+	unsigned int			pointer_read[NR_CHANNELS];
+	unsigned int			pointer_write[NR_CHANNELS];
+	unsigned int			open[NR_CHANNELS];
+	unsigned char			write;
+	struct tty_struct		*tty[NR_CHANNELS];
+	struct ktermios			oldtermios[NR_CHANNELS];
+	struct tty_driver		*tty_drv;
+};
+
+/* Linked list to save the registered devices */
+static LIST_HEAD(ipoctal_list);
+
+inline void ipoctal_write_io_reg(struct ipoctal *ipoctal, unsigned char *dest, unsigned char value)
+{
+	unsigned long offset = 0;
+
+	offset = ((void *) dest) - ipoctal->dev->io_space.address;
+	ipoctal->dev->ops->write8(ipoctal->dev, IPACK_IO_SPACE, offset, value);
+}
+
+inline void ipoctal_write_cr_cmd(struct ipoctal *ipoctal, unsigned char *dest, unsigned char value)
+{
+	ipoctal_write_io_reg(ipoctal, dest, value);
+	udelay(DELAY_MICROSECONDS);
+}
+
+inline unsigned char ipoctal_read_io_reg(struct ipoctal *ipoctal, unsigned char *src)
+{
+	unsigned long offset = 0;
+	unsigned char value = 0xFF;
+
+	offset = ((void *) src) - ipoctal->dev->io_space.address;
+	ipoctal->dev->ops->read8(ipoctal->dev, IPACK_IO_SPACE, offset, &value);
+	return value;
+}
+
+struct ipoctal *ipoctal_find_board(struct tty_struct *tty)
+{
+	struct ipoctal *p;
+	struct list_head *element, *next;
+
+	list_for_each_safe(element, next, &ipoctal_list) {
+		p = list_entry(element, struct ipoctal, list);
+		if (tty->driver->major == p->tty_drv->major)
+			return p;
+	}
+
+	return NULL;
+}
+
+int ipoctal_open(struct tty_struct *tty, struct file *file)
+{
+	int channel = tty->index;
+	int res = 0;
+	struct ipoctal *ipoctal;
+
+	ipoctal = ipoctal_find_board(tty);
+
+	if (ipoctal == NULL) {
+		printk(KERN_ERR PFX "Device not found. Major %d\n", tty->driver->major);
+		return -ENODEV;
+	}
+
+	ipoctal->open[channel]++;
+	if (ipoctal->open[channel] > 1)
+		return -EBUSY;
+
+	/* Save struct tty_struct for later */
+	ipoctal->tty[channel] = tty;
+	memcpy(&ipoctal->oldtermios[channel], tty->termios, sizeof(struct ktermios));
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+			CR_ENABLE_RX);
+
+	/* Save struct ipoctal to facilitate future operations */
+	tty->driver_data = ipoctal;
+	return res;
+}
+
+static void ipoctal_reset_stats(struct ipoctal_stats *stats)
+{
+	stats->tx = 0;
+	stats->rx = 0;
+	stats->rcv_break = 0;
+	stats->framing_err = 0;
+	stats->overrun_err = 0;
+	stats->parity_err = 0;
+}
+
+static void ipoctal_free_channel(struct tty_struct *tty)
+{
+	int channel = tty->index;
+	struct ipoctal *ipoctal = tty->driver_data;
+
+	if (ipoctal == NULL)
+		return;
+
+	ipoctal_reset_stats(&ipoctal->chan_stats[channel]);
+	ipoctal->pointer_read[channel] = 0;
+	ipoctal->pointer_write[channel] = 0;
+	ipoctal->nb_bytes[channel] = 0;
+}
+
+void ipoctal_close(struct tty_struct *tty, struct file *filp)
+{
+	int channel = tty->index;
+	struct ipoctal *ipoctal = tty->driver_data;
+
+	ipoctal->open[channel]--;
+
+	if (!ipoctal->open[channel]) {
+		ipoctal_free_channel(tty);
+		ipoctal->tty[channel] = NULL;
+	}
+}
+
+static int ipoctal_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
+{
+	void __user *user_arg = (void __user *)arg;
+	struct ipoctal *ipoctal = tty->driver_data;
+	int channel = tty->index;
+	int res = -ENOIOCTLCMD;
+
+	if (ipoctal == NULL)
+		return -ENODEV;
+
+	switch (cmd) {
+	case TIOCGICOUNT:
+	{
+		struct serial_icounter_struct icount;
+
+		if (channel < 0) {
+			res = channel;
+			goto out_ioctl;
+		}
+
+		/* Give the stats to the user */
+		icount.cts = 0;
+		icount.dsr = 0;
+		icount.rng = 0;
+		icount.dcd = 0;
+		icount.rx = ipoctal->chan_stats[channel].rx;
+		icount.tx = ipoctal->chan_stats[channel].tx;
+		icount.frame = ipoctal->chan_stats[channel].framing_err;
+		icount.parity = ipoctal->chan_stats[channel].parity_err;
+		icount.brk = ipoctal->chan_stats[channel].rcv_break;
+
+		if (copy_to_user(user_arg, &icount, sizeof(icount))) {
+			printk(KERN_ERR PFX "Slot [%d:%d] Channel %c :"
+			       " Error during data copy to user space !\n",
+			       ipoctal->dev->bus_nr,
+			       ipoctal->dev->slot, channel);
+			res = -EFAULT;
+			goto out_ioctl;
+		}
+		break;
+	}
+	default:
+		res = -ENOIOCTLCMD;
+		goto out_ioctl;
+		break;
+	}
+out_ioctl:
+	return res;
+}
+
+static int ipoctal_irq_handler(void *arg)
+{
+	unsigned int channel;
+	unsigned int block;
+	unsigned char isr;
+	unsigned char sr;
+	unsigned char isr_tx_rdy, isr_rx_rdy;
+	unsigned char value;
+	struct ipoctal *ipoctal = (struct ipoctal *) arg;
+
+	/* Check all channels */
+	for (channel = 0; channel < NR_CHANNELS; channel++) {
+
+		/* If there is no client, skip the check */
+		if (ipoctal->open[channel] == 0)
+			continue;
+
+		/*
+		 * The HW is organized in pair of channels.
+		 * See which register we need to read from
+		 */
+		block = channel / 2;
+		isr = ipoctal_read_io_reg(ipoctal, &ipoctal->block_regs[block].u.r.isr);
+		sr = ipoctal_read_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.r.sr);
+
+		if ((channel % 2) == 1) {
+			isr_tx_rdy = isr & ISR_TxRDY_B;
+			isr_rx_rdy = isr & ISR_RxRDY_FFULL_B;
+		} else {
+			isr_tx_rdy = isr & ISR_TxRDY_A;
+			isr_rx_rdy = isr & ISR_RxRDY_FFULL_A;
+		}
+
+		/* In case of RS-485, change from TX to RX when finishing TX. Half-duplex. */
+		if ((ipoctal->board_id == IP_OCTAL_485_ID) &&
+				(sr & SR_TX_EMPTY) && (ipoctal->nb_bytes[channel] == 0)) {
+			ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr, CR_DISABLE_TX);
+			ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr, CR_CMD_NEGATE_RTSN);
+			ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr, CR_ENABLE_RX);
+			ipoctal->write = 1;
+			wake_up_interruptible(&ipoctal->queue[channel]);
+		}
+
+		/* RX data */
+		if (isr_rx_rdy && (sr & SR_RX_READY)) {
+			value = ipoctal_read_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.r.rhr);
+			tty_insert_flip_char(ipoctal->tty[channel], value, TTY_NORMAL);
+			tty_flip_buffer_push(ipoctal->tty[channel]);
+		}
+
+		/* TX of each character */
+		if (isr_tx_rdy && (sr & SR_TX_READY)) {
+			unsigned int *pointer_write = &ipoctal->pointer_write[channel];
+
+			if (ipoctal->nb_bytes[channel] <= 0) {
+				ipoctal->nb_bytes[channel] = 0;
+				continue;
+			}
+			spin_lock(&ipoctal->lock[channel]);
+			value = ipoctal->buffer[channel][*pointer_write];
+			ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.thr, value);
+			ipoctal->chan_stats[channel].tx++;
+			ipoctal->count_wr[channel]++;
+			(*pointer_write)++;
+			*pointer_write = *pointer_write % MAX_CHAR;
+			ipoctal->nb_bytes[channel]--;
+			spin_unlock(&ipoctal->lock[channel]);
+
+			if ((ipoctal->nb_bytes[channel] == 0) &&
+					(waitqueue_active(&ipoctal->queue[channel]))) {
+
+				if (ipoctal->board_id != IP_OCTAL_485_ID) {
+					ipoctal->write = 1;
+					wake_up_interruptible(&ipoctal->queue[channel]);
+				}
+			}
+		}
+
+		/* Error: count statistics */
+		if (sr & SR_ERROR) {
+			ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+					CR_CMD_RESET_ERR_STATUS);
+			if (sr & SR_OVERRUN_ERROR) {
+				ipoctal->error_flag[channel] |= UART_OVERRUN;
+				ipoctal->chan_stats[channel].overrun_err++;
+			}
+			if (sr & SR_PARITY_ERROR) {
+				ipoctal->error_flag[channel] |= UART_PARITY;
+				ipoctal->chan_stats[channel].parity_err++;
+			}
+			if (sr & SR_FRAMING_ERROR) {
+				ipoctal->error_flag[channel] |= UART_FRAMING;
+				ipoctal->chan_stats[channel].framing_err++;
+			}
+			if (sr & SR_RECEIVED_BREAK) {
+				ipoctal->error_flag[channel] |= UART_BREAK;
+				ipoctal->chan_stats[channel].rcv_break++;
+			}
+			if (waitqueue_active(&ipoctal->queue[channel]))
+				wake_up_interruptible(&ipoctal->queue[channel]);
+		}
+		udelay(DELAY_MICROSECONDS);
+	}
+	return IRQ_HANDLED;
+}
+
+static int ipoctal_check_model(struct ipack_device *dev, unsigned char *id)
+{
+	unsigned char manufacturerID;
+	unsigned char board_id;
+
+	dev->ops->read8(dev, IPACK_ID_SPACE, IPACK_IDPROM_OFFSET_MANUFACTURER_ID, &manufacturerID);
+	if (manufacturerID != IP_OCTAL_MANUFACTURER_ID)
+		return -ENODEV;
+
+	dev->ops->read8(dev, IPACK_ID_SPACE, IPACK_IDPROM_OFFSET_MODEL, (unsigned char *)&board_id);
+
+	switch (board_id) {
+	case IP_OCTAL_232_ID:
+	case IP_OCTAL_422_ID:
+	case IP_OCTAL_485_ID:
+		*id = board_id;
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+
+static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr, unsigned int slot, unsigned int vector, char *carrier)
+{
+	int res = 0;
+	int i;
+	struct tty_driver *tty;
+	char name[20] = "";
+	unsigned char board_id;
+
+	res = ipoctal->dev->ops->map_space(ipoctal->dev, 0, IPACK_ID_SPACE);
+	if (res) {
+		printk(KERN_ERR PFX "Unable to map slot [%d:%d] ID space!\n", bus_nr, slot);
+		goto out_unregister_slot;
+	}
+
+	res = ipoctal_check_model(ipoctal->dev, &board_id);
+	if (res) {
+		ipoctal->dev->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
+		goto out_unregister_slot;
+	}
+	ipoctal->board_id = board_id;
+
+	res = ipoctal->dev->ops->map_space(ipoctal->dev, 0, IPACK_IO_SPACE);
+	if (res) {
+		printk(KERN_ERR PFX "Unable to map slot [%d:%d] IO space!\n", bus_nr, slot);
+		ipoctal->dev->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
+		goto out_unregister_slot;
+	}
+
+	res = ipoctal->dev->ops->map_space(ipoctal->dev, 0x8000, IPACK_MEM_SPACE);
+	if (res) {
+		printk(KERN_ERR PFX "Unable to map slot [%d:%d] MEM space!\n", bus_nr, slot);
+		ipoctal->dev->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
+		ipoctal->dev->ops->unmap_space(ipoctal->dev, IPACK_IO_SPACE);
+		goto out_unregister_slot;
+	}
+
+	for (i = 0; i < NR_CHANNELS; i++) {
+		ipoctal_reset_stats(&ipoctal->chan_stats[i]);
+		ipoctal->buffer[i] = kzalloc(MAX_CHAR*sizeof(unsigned char), GFP_KERNEL);
+		ipoctal->nb_bytes[i] = 0;
+		init_waitqueue_head(&ipoctal->queue[i]);
+		ipoctal->error_flag[i] = UART_NOERROR;
+	}
+
+	/* Save the virtual address to access the registers easily */
+	ipoctal->chan_regs = (struct scc2698_channel *) ipoctal->dev->io_space.address;
+	ipoctal->block_regs = (struct scc2698_block *) ipoctal->dev->io_space.address;
+
+	/* Disable RX and TX before touching anything */
+	for (i = 0; i < NR_CHANNELS ; i++) {
+		ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[i].u.w.cr,
+				CR_DISABLE_RX | CR_DISABLE_TX);
+	}
+
+	for (i = 0; i < IP_OCTAL_NB_BLOCKS; i++) {
+		ipoctal_write_io_reg(ipoctal, &ipoctal->block_regs[i].u.w.acr, ACR_BRG_SET2);
+		ipoctal_write_io_reg(
+				ipoctal,
+				&ipoctal->block_regs[i].u.w.opcr,
+				OPCR_MPP_OUTPUT | OPCR_MPOa_RTSN | OPCR_MPOb_RTSN);
+		ipoctal_write_io_reg(
+				ipoctal,
+				&ipoctal->block_regs[i].u.w.imr,
+				IMR_TxRDY_A | IMR_RxRDY_FFULL_A | IMR_DELTA_BREAK_A |
+				IMR_TxRDY_B | IMR_RxRDY_FFULL_B | IMR_DELTA_BREAK_B);
+	}
+
+	/*
+	 * IP-OCTAL has different addresses to copy its IRQ vector.
+	 * Depending of the carrier these addresses are accesible or not.
+	 * More info in the datasheet.
+	 */
+	ipoctal->dev->ops->request_irq(ipoctal->dev, vector, ipoctal_irq_handler, ipoctal);
+	if (strcmp(carrier, "TVME200") == 0)
+		ipoctal->dev->ops->write8(ipoctal->dev, IPACK_ID_SPACE, IP_OCTAL_ID_SPACE_VECTOR, vector);
+	else
+		ipoctal->dev->ops->write8(ipoctal->dev, IPACK_ID_SPACE, 0, vector);
+
+	/* Register the TTY device */
+
+	/* Each IP-OCTAL channel is a TTY port */
+	tty = alloc_tty_driver(NR_CHANNELS);
+
+	if (!tty)
+		return -ENOMEM;
+
+	/* Fill struct tty_driver with ipoctal data */
+	tty->owner = THIS_MODULE;
+	tty->driver_name = "ipoctal";
+	sprintf(name, "ipoctal.%d.%d.", bus_nr, slot);
+	tty->name = name;
+	tty->major = 0;
+
+	tty->minor_start = 0;
+	tty->type = TTY_DRIVER_TYPE_SERIAL;
+	tty->subtype = SERIAL_TYPE_NORMAL;
+	tty->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	tty->init_termios = tty_std_termios;
+	tty->init_termios.c_cflag = B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	tty->init_termios.c_ispeed = 9600;
+	tty->init_termios.c_ospeed = 9600;
+
+	tty_set_operations(tty, &ipoctal_fops);
+	res = tty_register_driver(tty);
+	if (res) {
+		printk(KERN_ERR PFX "Can't register tty driver.\n");
+		put_tty_driver(tty);
+		goto out_unregister_slot_unmap;
+	}
+
+	/* Save struct tty_driver for use it when uninstalling the device */
+	ipoctal->tty_drv = tty;
+
+	for (i = 0; i < NR_CHANNELS; i++) {
+		tty_register_device(tty, i, NULL);
+		ipoctal->tty[i] = NULL;
+		spin_lock_init(&ipoctal->lock[i]);
+		mutex_init(&ipoctal->lock_write[i]);
+		ipoctal->pointer_read[i] = 0;
+		ipoctal->pointer_write[i] = 0;
+		ipoctal->nb_bytes[i] = 0;
+		/* Enable again the RX. TX will be enabled when there is something to send */
+		ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[i].u.w.cr,
+				CR_ENABLE_RX);
+	}
+
+	return 0;
+
+out_unregister_slot_unmap:
+	ipoctal->dev->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
+	ipoctal->dev->ops->unmap_space(ipoctal->dev, IPACK_IO_SPACE);
+	ipoctal->dev->ops->unmap_space(ipoctal->dev, IPACK_MEM_SPACE);
+
+out_unregister_slot:
+	return res;
+}
+
+static inline int ipoctal_copy_write_buffer(struct ipoctal *ipoctal, unsigned int channel, const unsigned char *buf, int count)
+{
+	unsigned long flags;
+	int i;
+	unsigned int *pointer_read = &ipoctal->pointer_read[channel];
+
+	/* Copy the bytes from the user buffer to the internal one */
+	for (i = 0; i < count; i++) {
+		if (i <= (MAX_CHAR - ipoctal->nb_bytes[channel])) {
+			spin_lock_irqsave(&ipoctal->lock[channel], flags);
+			ipoctal->buffer[channel][*pointer_read] = buf[i];
+			*pointer_read = (*pointer_read + 1) % MAX_CHAR;
+			ipoctal->nb_bytes[channel]++;
+			spin_unlock_irqrestore(&ipoctal->lock[channel], flags);
+		} else {
+			break;
+		}
+	}
+	return i;
+}
+
+static int ipoctal_write(struct ipoctal *ipoctal, unsigned int channel, const unsigned char *buf, int count)
+{
+	ipoctal->nb_bytes[channel] = 0;
+	ipoctal->count_wr[channel] = 0;
+
+	ipoctal_copy_write_buffer(ipoctal, channel, buf, count);
+
+	ipoctal->error_flag[channel] = UART_NOERROR;
+
+	/* As the IP-OCTAL 485 only supports half duplex, do it manually */
+	if (ipoctal->board_id == IP_OCTAL_485_ID) {
+		ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr, CR_DISABLE_RX);
+		ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+				CR_CMD_ASSERT_RTSN);
+	}
+
+	/*
+	 * Send a packet and then disable TX to avoid failure after several send
+	 * operations
+	 */
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr, CR_ENABLE_TX);
+	wait_event_interruptible(ipoctal->queue[channel], ipoctal->write);
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr, CR_DISABLE_TX);
+
+	ipoctal->write = 0;
+	return ipoctal->count_wr[channel];
+}
+
+static int ipoctal_write_tty(struct tty_struct *tty, const unsigned char *buf, int count)
+{
+	unsigned int channel = tty->index;
+	struct ipoctal *ipoctal = tty->driver_data;
+	int ret = 0;
+
+	if (mutex_lock_interruptible(&ipoctal->lock_write[channel]))
+		return -ERESTARTSYS;
+
+	ret = ipoctal_write(ipoctal, channel, buf, count);
+	mutex_unlock(&ipoctal->lock_write[channel]);
+	return ret;
+}
+
+int ipoctal_write_room(struct tty_struct *tty)
+{
+	int channel = tty->index;
+	struct ipoctal *ipoctal = tty->driver_data;
+
+	return MAX_CHAR - ipoctal->nb_bytes[channel];
+}
+
+int ipoctal_chars_in_buffer(struct tty_struct *tty)
+{
+	int channel = tty->index;
+	struct ipoctal *ipoctal = tty->driver_data;
+
+	return ipoctal->nb_bytes[channel];
+}
+
+void ipoctal_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
+{
+	unsigned int cflag;
+	unsigned char mr1 = 0;
+	unsigned char mr2 = 0;
+	unsigned char csr = 0;
+	unsigned int channel = tty->index;
+	struct ipoctal *ipoctal = tty->driver_data;
+
+	cflag = tty->termios->c_cflag;
+
+	if (old_termios) {
+		if ((cflag == old_termios->c_cflag) &&
+				(RELEVANT_IFLAG(tty->termios->c_iflag) ==
+				 RELEVANT_IFLAG(old_termios->c_iflag)))
+			return;
+	}
+
+	/* Disable and reset everything before change the setup */
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+			CR_DISABLE_RX | CR_DISABLE_TX);
+	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+			CR_CMD_RESET_RX);
+	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+			CR_CMD_RESET_TX);
+	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+			CR_CMD_RESET_ERR_STATUS);
+	ipoctal_write_cr_cmd(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+			CR_CMD_RESET_MR);
+
+	/* Set Bits per chars */
+	switch (cflag & CSIZE) {
+	case CS6:
+		mr1 |= MR1_CHRL_6_BITS;
+		break;
+	case CS7:
+		mr1 |= MR1_CHRL_7_BITS;
+		break;
+	case CS8:
+	default:
+		mr1 |= MR1_CHRL_8_BITS;
+		break;
+	}
+
+	/* Set Parity */
+	if (cflag & PARENB)
+		if (cflag & PARODD)
+			mr1 |= MR1_PARITY_ON | MR1_PARITY_ODD;
+		else
+			mr1 |= MR1_PARITY_ON | MR1_PARITY_EVEN;
+	else
+		mr1 |= MR1_PARITY_OFF;
+
+	/* Set stop bits */
+	if (cflag & CSTOPB)
+		mr2 |= MR2_STOP_BITS_LENGTH_2;
+	else
+		mr2 |= MR2_STOP_BITS_LENGTH_1;
+
+	/* Set the flow control */
+	switch (ipoctal->board_id) {
+	case IP_OCTAL_232_ID:
+		if (cflag & CRTSCTS) {
+			mr1 |= MR1_RxRTS_CONTROL_ON;
+			mr2 |= MR2_TxRTS_CONTROL_OFF | MR2_CTS_ENABLE_TX_ON;
+			ipoctal->chan_config[channel].flow_control = 1;
+		} else {
+			mr1 |= MR1_RxRTS_CONTROL_OFF;
+			mr2 |= MR2_TxRTS_CONTROL_OFF | MR2_CTS_ENABLE_TX_OFF;
+			ipoctal->chan_config[channel].flow_control = 0;
+		}
+		break;
+	case IP_OCTAL_422_ID:
+		mr1 |= MR1_RxRTS_CONTROL_OFF;
+		mr2 |= MR2_TxRTS_CONTROL_OFF | MR2_CTS_ENABLE_TX_OFF;
+		ipoctal->chan_config[channel].flow_control = 0;
+		break;
+	case IP_OCTAL_485_ID:
+		mr1 |= MR1_RxRTS_CONTROL_OFF;
+		mr2 |= MR2_TxRTS_CONTROL_ON | MR2_CTS_ENABLE_TX_OFF;
+		ipoctal->chan_config[channel].flow_control = 0;
+		break;
+	default:
+		return;
+		break;
+	}
+
+	/* Set baud rate */
+	switch (tty_get_baud_rate(tty)) {
+	case 75:
+		csr |= TX_CLK_75 | RX_CLK_75;
+		break;
+	case 110:
+		csr |= TX_CLK_110 | RX_CLK_110;
+		break;
+	case 150:
+		csr |= TX_CLK_150 | RX_CLK_150;
+		break;
+	case 300:
+		csr |= TX_CLK_300 | RX_CLK_300;
+		break;
+	case 600:
+		csr |= TX_CLK_600 | RX_CLK_600;
+		break;
+	case 1200:
+		csr |= TX_CLK_1200 | RX_CLK_1200;
+		break;
+	case 1800:
+		csr |= TX_CLK_1800 | RX_CLK_1800;
+		break;
+	case 2000:
+		csr |= TX_CLK_2000 | RX_CLK_2000;
+		break;
+	case 2400:
+		csr |= TX_CLK_2400 | RX_CLK_2400;
+		break;
+	case 4800:
+		csr |= TX_CLK_4800  | RX_CLK_4800;
+		break;
+	case 9600:
+		csr |= TX_CLK_9600  | RX_CLK_9600;
+		break;
+	case 19200:
+		csr |= TX_CLK_19200 | RX_CLK_19200;
+		break;
+	case 38400:
+		csr |= TX_CLK_38400 | RX_CLK_38400;
+		break;
+	default:
+		printk(KERN_INFO PFX
+		       "Slot [%d:%d] Channel %d : illegal baud rate value: %d\n",
+		       ipoctal->dev->bus_nr,
+		       ipoctal->dev->slot,
+		       channel,
+		       tty_get_baud_rate(tty));
+		return;
+	}
+
+	mr1 |= MR1_ERROR_CHAR;
+	mr1 |= MR1_RxINT_RxRDY;
+
+	/* Write the control registers */
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.mr, mr1);
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.mr, mr2);
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.csr, csr);
+
+	/* save the setup in the structure */
+	ipoctal->chan_config[channel].baud = tty_get_baud_rate(tty);
+	ipoctal->chan_config[channel].bits_per_char = cflag & CSIZE;
+	ipoctal->chan_config[channel].parity = cflag & PARENB;
+	ipoctal->chan_config[channel].stop_bits = cflag & CSTOPB;
+
+	/* Enable again the RX */
+	ipoctal_write_io_reg(ipoctal, &ipoctal->chan_regs[channel].u.w.cr,
+			CR_ENABLE_RX);
+}
+
+const struct tty_operations ipoctal_fops = {
+	.ioctl =		ipoctal_ioctl,
+	.open =			ipoctal_open,
+	.close =		ipoctal_close,
+	.write =		ipoctal_write_tty,
+	.set_termios =		ipoctal_set_termios,
+	.write_room =		ipoctal_write_room,
+	.chars_in_buffer =	ipoctal_chars_in_buffer,
+};
+
+int ipoctal_match(struct ipack_device *dev)
+{
+	int res;
+	unsigned char board_id;
+
+	res = dev->ops->map_space(dev, 0, IPACK_ID_SPACE);
+	if (res)
+		goto out_match;
+
+	res = ipoctal_check_model(dev, &board_id);
+	dev->ops->unmap_space(dev, IPACK_ID_SPACE);
+
+out_match:
+	return res;
+}
+
+int ipoctal_probe(struct ipack_device *dev)
+{
+	int res = 0;
+	struct ipoctal *ipoctal;
+
+	ipoctal = kzalloc(sizeof(struct ipoctal), GFP_KERNEL);
+	if (ipoctal == NULL)
+		return -ENOMEM;
+
+	ipoctal->dev = dev;
+	res = ipoctal_inst_slot(ipoctal,
+			dev->bus_nr,
+			dev->slot,
+			dev->irq,
+			dev->bus_name);
+	if (res)
+		goto out_uninst;
+
+	list_add_tail(&ipoctal->list, &ipoctal_list);
+	return res;
+
+out_uninst:
+	kfree(ipoctal);
+	return res;
+}
+
+static void __ipoctal_remove(struct ipoctal *ipoctal)
+{
+	int j;
+
+	for (j = 0; j < NR_CHANNELS; j++)
+		tty_unregister_device(ipoctal->tty_drv, j);
+
+	tty_unregister_driver(ipoctal->tty_drv);
+	put_tty_driver(ipoctal->tty_drv);
+
+	/* Tell the carrier board to free all the resources for this device */
+	ipoctal->dev->ops->remove_device(ipoctal->dev);
+
+	list_del(&ipoctal->list);
+	kfree(ipoctal);
+}
+
+void ipoctal_remove(struct ipack_device *device)
+{
+	struct ipoctal *ipoctal;
+	struct list_head *element, *next;
+
+	list_for_each_safe(element, next, &ipoctal_list) {
+		ipoctal = list_entry(element, struct ipoctal, list);
+		if (ipoctal->dev == device)
+			__ipoctal_remove(ipoctal);
+	}
+}
+
+struct ipack_driver_ops ipoctal_drv_ops = {
+	.match = ipoctal_match,
+	.probe = ipoctal_probe,
+	.remove = ipoctal_remove,
+};
+
+static int __init ipoctal_init(void)
+{
+	driver.ops = &ipoctal_drv_ops;
+	driver.driver.name = MODULE_NAME;
+	ipack_driver_register(&driver);
+	return 0;
+}
+
+static void __exit ipoctal_exit(void)
+{
+	struct ipoctal *p;
+	struct list_head *element, *next;
+
+	list_for_each_safe(element, next, &ipoctal_list) {
+		p = list_entry(element, struct ipoctal, list);
+		__ipoctal_remove(p);
+	}
+	ipack_driver_unregister(&driver);
+}
+
+MODULE_DESCRIPTION("IP-Octal 232, 422 and 485 device driver");
+MODULE_LICENSE("GPL");
+
+module_init(ipoctal_init);
+module_exit(ipoctal_exit);
diff --git a/drivers/staging/ipack/devices/ipoctal.h b/drivers/staging/ipack/devices/ipoctal.h
new file mode 100644
index 0000000..7c5d211
--- /dev/null
+++ b/drivers/staging/ipack/devices/ipoctal.h
@@ -0,0 +1,81 @@
+/**
+ * ipoctal.h
+ *
+ * driver for the IPOCTAL boards
+ * Copyright (c) 2009 Nicolas Serafini, EIC2 SA
+ * Copyright (c) 2010,2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
+ * Copyright (c) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#ifndef _IPOCTAL_H
+#define _IPOCTAL_H_
+
+#define NR_CHANNELS		8
+#define IPOCTAL_MAX_BOARDS	16
+#define MAX_DEVICES		(NR_CHANNELS * IPOCTAL_MAX_BOARDS)
+#define RELEVANT_IFLAG(iflag) ((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
+
+/**
+ * enum uart_parity_e - UART supported parity.
+ */
+enum uart_parity_e {
+	UART_NONE  = 0,
+	UART_ODD   = 1,
+	UART_EVEN  = 2,
+};
+
+/**
+ * enum uart_error - UART error type
+ *
+ */
+enum uart_error	{
+	UART_NOERROR = 0,      /* No error during transmission */
+	UART_TIMEOUT = 1 << 0, /* Timeout error */
+	UART_OVERRUN = 1 << 1, /* Overrun error */
+	UART_PARITY  = 1 << 2, /* Parity error */
+	UART_FRAMING = 1 << 3, /* Framing error */
+	UART_BREAK   = 1 << 4, /* Received break */
+};
+
+/**
+ * struct ipoctal_config - Serial configuration
+ *
+ * @baud: Baud rate
+ * @stop_bits: Stop bits (1 or 2)
+ * @bits_per_char: data size in bits
+ * @parity
+ * @flow_control: Flow control management (RTS/CTS) (0 disabled, 1 enabled)
+ */
+struct ipoctal_config {
+	unsigned int baud;
+	unsigned int stop_bits;
+	unsigned int bits_per_char;
+	unsigned short parity;
+	unsigned int flow_control;
+};
+
+/**
+ * struct ipoctal_stats -- Stats since last reset
+ *
+ * @tx: Number of transmitted bytes
+ * @rx: Number of received bytes
+ * @overrun: Number of overrun errors
+ * @parity_err: Number of parity errors
+ * @framing_err: Number of framing errors
+ * @rcv_break: Number of break received
+ */
+struct ipoctal_stats {
+	unsigned long tx;
+	unsigned long rx;
+	unsigned long overrun_err;
+	unsigned long parity_err;
+	unsigned long framing_err;
+	unsigned long rcv_break;
+};
+
+#endif /* _IPOCTAL_H_ */
diff --git a/drivers/staging/ipack/devices/scc2698.h b/drivers/staging/ipack/devices/scc2698.h
new file mode 100644
index 0000000..bf654f4
--- /dev/null
+++ b/drivers/staging/ipack/devices/scc2698.h
@@ -0,0 +1,229 @@
+/*
+ * scc2698.h
+ *
+ * driver for the IPOCTAL boards
+ * Copyright (c) 2009 Nicolas Serafini, EIC2 SA
+ * Copyright (c) 2010,2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
+ * Copyright (c) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#ifndef SCC2698_H_
+#define SCC2698_H_
+
+/*
+ * struct scc2698_channel - Channel access to scc2698 IO
+ *
+ * dn value are only spacer.
+ *
+ */
+struct scc2698_channel {
+	union {
+		struct {
+			unsigned char d0, mr;  /* Mode register 1/2*/
+			unsigned char d1, sr;  /* Status register */
+			unsigned char d2, r1;  /* reserved */
+			unsigned char d3, rhr; /* Receive holding register (R) */
+			unsigned char junk[8]; /* other crap for block control */
+		} r; /* Read access */
+		struct {
+			unsigned char d0, mr;  /* Mode register 1/2 */
+			unsigned char d1, csr; /* Clock select register */
+			unsigned char d2, cr;  /* Command register */
+			unsigned char d3, thr; /* Transmit holding register */
+			unsigned char junk[8]; /* other crap for block control */
+		} w; /* Write access */
+	} u;
+};
+
+/*
+ * struct scc2698_block - Block access to scc2698 IO
+ *
+ * The scc2698 contain 4 block.
+ * Each block containt two channel a and b.
+ * dn value are only spacer.
+ *
+ */
+struct scc2698_block {
+	union {
+		struct {
+			unsigned char d0, mra;  /* Mode register 1/2 (a) */
+			unsigned char d1, sra;  /* Status register (a) */
+			unsigned char d2, r1;   /* reserved */
+			unsigned char d3, rhra; /* Receive holding register (a) */
+			unsigned char d4, ipcr; /* Input port change register of block */
+			unsigned char d5, isr;  /* Interrupt status register of block */
+			unsigned char d6, ctur; /* Counter timer upper register of block */
+			unsigned char d7, ctlr; /* Counter timer lower register of block */
+			unsigned char d8, mrb;  /* Mode register 1/2 (b) */
+			unsigned char d9, srb;  /* Status register (b) */
+			unsigned char da, r2;   /* reserved */
+			unsigned char db, rhrb; /* Receive holding register (b) */
+			unsigned char dc, r3;   /* reserved */
+			unsigned char dd, ip;   /* Input port register of block */
+			unsigned char de, ctg;  /* Start counter timer of block */
+			unsigned char df, cts;  /* Stop counter timer of block */
+		} r; /* Read access */
+		struct {
+			unsigned char d0, mra;  /* Mode register 1/2 (a) */
+			unsigned char d1, csra; /* Clock select register (a) */
+			unsigned char d2, cra;  /* Command register (a) */
+			unsigned char d3, thra; /* Transmit holding register (a) */
+			unsigned char d4, acr;  /* Auxiliary control register of block */
+			unsigned char d5, imr;  /* Interrupt mask register of block  */
+			unsigned char d6, ctu;  /* Counter timer upper register of block */
+			unsigned char d7, ctl;  /* Counter timer lower register of block */
+			unsigned char d8, mrb;  /* Mode register 1/2 (b) */
+			unsigned char d9, csrb; /* Clock select register (a) */
+			unsigned char da, crb;  /* Command register (b) */
+			unsigned char db, thrb; /* Transmit holding register (b) */
+			unsigned char dc, r1;   /* reserved */
+			unsigned char dd, opcr; /* Output port configuration register of block */
+			unsigned char de, r2;   /* reserved */
+			unsigned char df, r3;   /* reserved */
+		} w; /* Write access */
+	} u;
+} ;
+
+#define MR1_CHRL_5_BITS             (0x0 << 0x0)
+#define MR1_CHRL_6_BITS             (0x1 << 0x0)
+#define MR1_CHRL_7_BITS             (0x2 << 0x0)
+#define MR1_CHRL_8_BITS             (0x3 << 0x0)
+#define MR1_PARITY_EVEN             (0x1 << 0x2)
+#define MR1_PARITY_ODD              (0x0 << 0x2)
+#define MR1_PARITY_ON               (0x0 << 0x3)
+#define MR1_PARITY_FORCE            (0x1 << 0x3)
+#define MR1_PARITY_OFF              (0x2 << 0x3)
+#define MR1_PARITY_SPECIAL          (0x3 << 0x3)
+#define MR1_ERROR_CHAR              (0x0 << 0x5)
+#define MR1_ERROR_BLOCK             (0x1 << 0x5)
+#define MR1_RxINT_RxRDY             (0x0 << 0x6)
+#define MR1_RxINT_FFULL             (0x1 << 0x6)
+#define MR1_RxRTS_CONTROL_ON        (0x1 << 0x7)
+#define MR1_RxRTS_CONTROL_OFF       (0x0 << 0x7)
+
+#define MR2_STOP_BITS_LENGTH_1      (0x7 << 0x0)
+#define MR2_STOP_BITS_LENGTH_2      (0xF << 0x0)
+#define MR2_CTS_ENABLE_TX_ON        (0x1 << 0x4)
+#define MR2_CTS_ENABLE_TX_OFF       (0x0 << 0x4)
+#define MR2_TxRTS_CONTROL_ON        (0x1 << 0x5)
+#define MR2_TxRTS_CONTROL_OFF       (0x0 << 0x5)
+#define MR2_CH_MODE_NORMAL          (0x0 << 0x6)
+#define MR2_CH_MODE_ECHO            (0x1 << 0x6)
+#define MR2_CH_MODE_LOCAL           (0x2 << 0x6)
+#define MR2_CH_MODE_REMOTE          (0x3 << 0x6)
+
+#define CR_ENABLE_RX                (0x1 << 0x0)
+#define CR_DISABLE_RX               (0x1 << 0x1)
+#define CR_ENABLE_TX                (0x1 << 0x2)
+#define CR_DISABLE_TX               (0x1 << 0x3)
+#define CR_CMD_RESET_MR             (0x1 << 0x4)
+#define CR_CMD_RESET_RX             (0x2 << 0x4)
+#define CR_CMD_RESET_TX             (0x3 << 0x4)
+#define CR_CMD_RESET_ERR_STATUS     (0x4 << 0x4)
+#define CR_CMD_RESET_BREAK_CHANGE   (0x5 << 0x4)
+#define CR_CMD_START_BREAK          (0x6 << 0x4)
+#define CR_CMD_STOP_BREAK           (0x7 << 0x4)
+#define CR_CMD_ASSERT_RTSN          (0x8 << 0x4)
+#define CR_CMD_NEGATE_RTSN          (0x9 << 0x4)
+#define CR_CMD_SET_TIMEOUT_MODE     (0xA << 0x4)
+#define CR_CMD_DISABLE_TIMEOUT_MODE (0xC << 0x4)
+
+#define SR_RX_READY                 (0x1 << 0x0)
+#define SR_FIFO_FULL                (0x1 << 0x1)
+#define SR_TX_READY                 (0x1 << 0x2)
+#define SR_TX_EMPTY                 (0x1 << 0x3)
+#define SR_OVERRUN_ERROR            (0x1 << 0x4)
+#define SR_PARITY_ERROR             (0x1 << 0x5)
+#define SR_FRAMING_ERROR            (0x1 << 0x6)
+#define SR_RECEIVED_BREAK           (0x1 << 0x7)
+
+#define SR_ERROR                    (0xF0)
+
+#define ACR_DELTA_IP0_IRQ_EN        (0x1 << 0x0)
+#define ACR_DELTA_IP1_IRQ_EN        (0x1 << 0x1)
+#define ACR_DELTA_IP2_IRQ_EN        (0x1 << 0x2)
+#define ACR_DELTA_IP3_IRQ_EN        (0x1 << 0x3)
+#define ACR_CT_Mask                 (0x7 << 0x4)
+#define ACR_CExt                    (0x0 << 0x4)
+#define ACR_CTxCA                   (0x1 << 0x4)
+#define ACR_CTxCB                   (0x2 << 0x4)
+#define ACR_CClk16                  (0x3 << 0x4)
+#define ACR_TExt                    (0x4 << 0x4)
+#define ACR_TExt16                  (0x5 << 0x4)
+#define ACR_TClk                    (0x6 << 0x4)
+#define ACR_TClk16                  (0x7 << 0x4)
+#define ACR_BRG_SET1                (0x0 << 0x7)
+#define ACR_BRG_SET2                (0x1 << 0x7)
+
+#define TX_CLK_75                   (0x0 << 0x0)
+#define TX_CLK_110                  (0x1 << 0x0)
+#define TX_CLK_38400                (0x2 << 0x0)
+#define TX_CLK_150                  (0x3 << 0x0)
+#define TX_CLK_300                  (0x4 << 0x0)
+#define TX_CLK_600                  (0x5 << 0x0)
+#define TX_CLK_1200                 (0x6 << 0x0)
+#define TX_CLK_2000                 (0x7 << 0x0)
+#define TX_CLK_2400                 (0x8 << 0x0)
+#define TX_CLK_4800                 (0x9 << 0x0)
+#define TX_CLK_1800                 (0xA << 0x0)
+#define TX_CLK_9600                 (0xB << 0x0)
+#define TX_CLK_19200                (0xC << 0x0)
+#define RX_CLK_75                   (0x0 << 0x4)
+#define RX_CLK_110                  (0x1 << 0x4)
+#define RX_CLK_38400                (0x2 << 0x4)
+#define RX_CLK_150                  (0x3 << 0x4)
+#define RX_CLK_300                  (0x4 << 0x4)
+#define RX_CLK_600                  (0x5 << 0x4)
+#define RX_CLK_1200                 (0x6 << 0x4)
+#define RX_CLK_2000                 (0x7 << 0x4)
+#define RX_CLK_2400                 (0x8 << 0x4)
+#define RX_CLK_4800                 (0x9 << 0x4)
+#define RX_CLK_1800                 (0xA << 0x4)
+#define RX_CLK_9600                 (0xB << 0x4)
+#define RX_CLK_19200                (0xC << 0x4)
+
+#define OPCR_MPOa_RTSN              (0x0 << 0x0)
+#define OPCR_MPOa_C_TO              (0x1 << 0x0)
+#define OPCR_MPOa_TxC1X             (0x2 << 0x0)
+#define OPCR_MPOa_TxC16X            (0x3 << 0x0)
+#define OPCR_MPOa_RxC1X             (0x4 << 0x0)
+#define OPCR_MPOa_RxC16X            (0x5 << 0x0)
+#define OPCR_MPOa_TxRDY             (0x6 << 0x0)
+#define OPCR_MPOa_RxRDY_FF          (0x7 << 0x0)
+
+#define OPCR_MPOb_RTSN              (0x0 << 0x4)
+#define OPCR_MPOb_C_TO              (0x1 << 0x4)
+#define OPCR_MPOb_TxC1X             (0x2 << 0x4)
+#define OPCR_MPOb_TxC16X            (0x3 << 0x4)
+#define OPCR_MPOb_RxC1X             (0x4 << 0x4)
+#define OPCR_MPOb_RxC16X            (0x5 << 0x4)
+#define OPCR_MPOb_TxRDY             (0x6 << 0x4)
+#define OPCR_MPOb_RxRDY_FF          (0x7 << 0x4)
+
+#define OPCR_MPP_INPUT              (0x0 << 0x7)
+#define OPCR_MPP_OUTPUT             (0x1 << 0x7)
+
+#define IMR_TxRDY_A                 (0x1 << 0x0)
+#define IMR_RxRDY_FFULL_A           (0x1 << 0x1)
+#define IMR_DELTA_BREAK_A           (0x1 << 0x2)
+#define IMR_COUNTER_READY           (0x1 << 0x3)
+#define IMR_TxRDY_B                 (0x1 << 0x4)
+#define IMR_RxRDY_FFULL_B           (0x1 << 0x5)
+#define IMR_DELTA_BREAK_B           (0x1 << 0x6)
+#define IMR_INPUT_PORT_CHANGE       (0x1 << 0x7)
+
+#define ISR_TxRDY_A                 (0x1 << 0x0)
+#define ISR_RxRDY_FFULL_A           (0x1 << 0x1)
+#define ISR_DELTA_BREAK_A           (0x1 << 0x2)
+#define ISR_COUNTER_READY           (0x1 << 0x3)
+#define ISR_TxRDY_B                 (0x1 << 0x4)
+#define ISR_RxRDY_FFULL_B           (0x1 << 0x5)
+#define ISR_DELTA_BREAK_B           (0x1 << 0x6)
+#define ISR_INPUT_PORT_CHANGE       (0x1 << 0x7)
+
+#endif /* SCC2698_H_ */
-- 
1.7.10

