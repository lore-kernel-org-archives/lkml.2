Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175Ab0GVJ46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 05:56:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37591 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab0GVJ4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 05:56:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 22 Jul 2010 11:56:38 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [review patch 1/2] firewire: new driver: nosy - IEEE 1394 traffic
 sniffer
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net,
        Kristian Hoegsberg <krh@bitplanet.net>
In-Reply-To: <tkrat.72756f504d6c0055@s5r6.in-berlin.de>
Message-ID: <tkrat.ddc816ab75cce8ac@s5r6.in-berlin.de>
References: <tkrat.72756f504d6c0055@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the traffic sniffer driver for Texas Instruments PCILynx/
PCILynx2 based cards.  The use cases for nosy are analysis of
nonstandard protocols and as an aid in development of drivers,
applications, or firmwares.

This comparably small kernel driver sets up packet reception DMA in the
special snoop mode of the PCILynx chip.  Userspace can pick up the
snooped FireWire traffic via a misc char device file "/dev/nosy".  The
file supports poll(), read(), and four ioctl()s; see nosy-user.h.

The ioctls use type code '&' which is currently unallocated according to
Documentation/ioctl/ioctl-number.txt.  Is this OK or should it be moved
to a different type code?

A side note regarding maintainability:  The PCILynx chip is well
documented in Texas Instruments' literature SCPA020A and SLLA023.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/Kconfig     |   23 ++
 drivers/firewire/Makefile    |    1 +
 drivers/firewire/nosy-user.h |   25 ++
 drivers/firewire/nosy.c      |  720 ++++++++++++++++++++++++++++++++++++++++++
 drivers/firewire/nosy.h      |  237 ++++++++++++++
 5 files changed, 1006 insertions(+), 0 deletions(-)
 create mode 100644 drivers/firewire/nosy-user.h
 create mode 100644 drivers/firewire/nosy.c
 create mode 100644 drivers/firewire/nosy.h

diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index a9371b3..c4edc34 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -66,4 +66,27 @@ config FIREWIRE_NET
 
 source "drivers/ieee1394/Kconfig"
 
+config FIREWIRE_NOSY
+	tristate "Nosy - a FireWire traffic sniffer for PCILynx cards"
+	depends on PCI
+	help
+	  Nosy is an IEEE 1394 packet sniffer that is used for protocol
+	  analysis and in development of IEEE 1394 drivers, applications,
+	  or firmwares.
+
+	  This driver lets you use a Texas Instruments PCILynx 1394 to PCI
+	  link layer controller TSB12LV21/A/B as a low-budget bus analyzer.
+	  PCILynx is a nowadays very rare IEEE 1394 controller which is
+	  not OHCI 1394 compliant.
+
+	  The following cards are known to be based on PCILynx or PCILynx-2:
+	  IOI IOI-1394TT (PCI card), Unibrain Fireboard 400 PCI Lynx-2
+	  (PCI card), Newer Technology FireWire 2 Go (CardBus card),
+	  Apple Power Mac G3 blue & white (onboard controller).
+
+	  To compile this driver as a module, say M here:  The module will be
+	  called nosy.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/drivers/firewire/Makefile b/drivers/firewire/Makefile
index a8f9bb6..3c6a7fb 100644
--- a/drivers/firewire/Makefile
+++ b/drivers/firewire/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_FIREWIRE)      += firewire-core.o
 obj-$(CONFIG_FIREWIRE_OHCI) += firewire-ohci.o
 obj-$(CONFIG_FIREWIRE_SBP2) += firewire-sbp2.o
 obj-$(CONFIG_FIREWIRE_NET)  += firewire-net.o
+obj-$(CONFIG_FIREWIRE_NOSY) += nosy.o
diff --git a/drivers/firewire/nosy-user.h b/drivers/firewire/nosy-user.h
new file mode 100644
index 0000000..e48aa62
--- /dev/null
+++ b/drivers/firewire/nosy-user.h
@@ -0,0 +1,25 @@
+#ifndef __nosy_user_h
+#define __nosy_user_h
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+#define NOSY_IOC_GET_STATS _IOR('&', 0, struct nosy_stats)
+#define NOSY_IOC_START     _IO('&', 1)
+#define NOSY_IOC_STOP      _IO('&', 2)
+#define NOSY_IOC_FILTER    _IOW('&', 2, __u32)
+
+struct nosy_stats {
+	__u32 total_packet_count;
+	__u32 lost_packet_count;
+};
+
+/*
+ * Format of packets returned from the kernel driver:
+ *
+ *	quadlet with timestamp		(microseconds, CPU endian)
+ *	quadlet-padded packet data...	(little endian)
+ *	quadlet with ack		(little endian)
+ */
+
+#endif /* __nosy_user_h */
diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
new file mode 100644
index 0000000..a8f528c
--- /dev/null
+++ b/drivers/firewire/nosy.c
@@ -0,0 +1,720 @@
+/*
+ * nosy - Snoop mode driver for TI PCILynx 1394 controllers
+ * Copyright (C) 2002-2007 Kristian Høgsberg
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/kref.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/timex.h>
+#include <linux/uaccess.h>
+#include <linux/wait.h>
+
+#include <asm/atomic.h>
+#include <asm/byteorder.h>
+
+#include "nosy.h"
+#include "nosy-user.h"
+
+#define TCODE_PHY_PACKET		0x10
+#define PCI_DEVICE_ID_TI_PCILYNX	0x8000
+
+static char driver_name[] = KBUILD_MODNAME;
+
+/* this is the physical layout of a PCL, its size is 128 bytes */
+struct pcl {
+	__le32 next;
+	__le32 async_error_next;
+	u32 user_data;
+	__le32 pcl_status;
+	__le32 remaining_transfer_count;
+	__le32 next_data_buffer;
+	struct {
+		__le32 control;
+		__le32 pointer;
+	} buffer[13];
+};
+
+struct packet {
+	unsigned int length;
+	char data[0];
+};
+
+struct packet_buffer {
+	char *data;
+	size_t capacity;
+	long total_packet_count, lost_packet_count;
+	atomic_t size;
+	struct packet *head, *tail;
+	wait_queue_head_t wait;
+};
+
+struct pcilynx {
+	struct pci_dev *pci_device;
+	__iomem char *registers;
+
+	struct pcl *rcv_start_pcl, *rcv_pcl;
+	__le32 *rcv_buffer;
+
+	dma_addr_t rcv_start_pcl_bus, rcv_pcl_bus, rcv_buffer_bus;
+
+	spinlock_t client_list_lock;
+	struct list_head client_list;
+
+	struct miscdevice misc;
+	struct list_head link;
+	struct kref kref;
+};
+
+static inline struct pcilynx *
+lynx_get(struct pcilynx *lynx)
+{
+	kref_get(&lynx->kref);
+
+	return lynx;
+}
+
+static void
+lynx_release(struct kref *kref)
+{
+	kfree(container_of(kref, struct pcilynx, kref));
+}
+
+static inline void
+lynx_put(struct pcilynx *lynx)
+{
+	kref_put(&lynx->kref, lynx_release);
+}
+
+struct client {
+	struct pcilynx *lynx;
+	u32 tcode_mask;
+	struct packet_buffer buffer;
+	struct list_head link;
+};
+
+static DEFINE_MUTEX(card_mutex);
+static LIST_HEAD(card_list);
+
+static int
+packet_buffer_init(struct packet_buffer *buffer, size_t capacity)
+{
+	buffer->data = kmalloc(capacity, GFP_KERNEL);
+	if (buffer->data == NULL)
+		return -ENOMEM;
+	buffer->head = (struct packet *) buffer->data;
+	buffer->tail = (struct packet *) buffer->data;
+	buffer->capacity = capacity;
+	buffer->lost_packet_count = 0;
+	atomic_set(&buffer->size, 0);
+	init_waitqueue_head(&buffer->wait);
+
+	return 0;
+}
+
+static void
+packet_buffer_destroy(struct packet_buffer *buffer)
+{
+	kfree(buffer->data);
+}
+
+static int
+packet_buffer_get(struct client *client, char __user *data, size_t user_length)
+{
+	struct packet_buffer *buffer = &client->buffer;
+	size_t length;
+	char *end;
+
+	if (wait_event_interruptible(buffer->wait,
+				     atomic_read(&buffer->size) > 0) ||
+				     list_empty(&client->lynx->link))
+		return -ERESTARTSYS;
+
+	if (atomic_read(&buffer->size) == 0)
+		return -ENODEV;
+
+	/* FIXME: Check length <= user_length. */
+
+	end = buffer->data + buffer->capacity;
+	length = buffer->head->length;
+
+	if (&buffer->head->data[length] < end) {
+		if (copy_to_user(data, buffer->head->data, length))
+			return -EFAULT;
+		buffer->head = (struct packet *) &buffer->head->data[length];
+	} else {
+		size_t split = end - buffer->head->data;
+
+		if (copy_to_user(data, buffer->head->data, split))
+			return -EFAULT;
+		if (copy_to_user(data + split, buffer->data, length - split))
+			return -EFAULT;
+		buffer->head = (struct packet *) &buffer->data[length - split];
+	}
+
+	/*
+	 * Decrease buffer->size as the last thing, since this is what
+	 * keeps the interrupt from overwriting the packet we are
+	 * retrieving from the buffer.
+	 */
+	atomic_sub(sizeof(struct packet) + length, &buffer->size);
+
+	return length;
+}
+
+static void
+packet_buffer_put(struct packet_buffer *buffer, void *data, size_t length)
+{
+	char *end;
+
+	buffer->total_packet_count++;
+
+	if (buffer->capacity <
+	    atomic_read(&buffer->size) + sizeof(struct packet) + length) {
+		buffer->lost_packet_count++;
+		return;
+	}
+
+	end = buffer->data + buffer->capacity;
+	buffer->tail->length = length;
+
+	if (&buffer->tail->data[length] < end) {
+		memcpy(buffer->tail->data, data, length);
+		buffer->tail = (struct packet *) &buffer->tail->data[length];
+	} else {
+		size_t split = end - buffer->tail->data;
+
+		memcpy(buffer->tail->data, data, split);
+		memcpy(buffer->data, data + split, length - split);
+		buffer->tail = (struct packet *) &buffer->data[length - split];
+	}
+
+	/* Finally, adjust buffer size and wake up userspace reader. */
+
+	atomic_add(sizeof(struct packet) + length, &buffer->size);
+	wake_up_interruptible(&buffer->wait);
+}
+
+static inline void
+reg_write(struct pcilynx *lynx, int offset, u32 data)
+{
+	writel(data, lynx->registers + offset);
+}
+
+static inline u32
+reg_read(struct pcilynx *lynx, int offset)
+{
+	return readl(lynx->registers + offset);
+}
+
+static inline void
+reg_set_bits(struct pcilynx *lynx, int offset, u32 mask)
+{
+	reg_write(lynx, offset, (reg_read(lynx, offset) | mask));
+}
+
+/*
+ * Maybe the pcl programs could be set up to just append data instead
+ * of using a whole packet.
+ */
+static inline void
+run_pcl(struct pcilynx *lynx, dma_addr_t pcl_bus,
+			   int dmachan)
+{
+	reg_write(lynx, DMA0_CURRENT_PCL + dmachan * 0x20, pcl_bus);
+	reg_write(lynx, DMA0_CHAN_CTRL + dmachan * 0x20,
+		  DMA_CHAN_CTRL_ENABLE | DMA_CHAN_CTRL_LINK);
+}
+
+static int
+set_phy_reg(struct pcilynx *lynx, int addr, int val)
+{
+	if (addr > 15) {
+		dev_err(&lynx->pci_device->dev,
+			"PHY register address %d out of range\n", addr);
+		return -1;
+	}
+	if (val > 0xff) {
+		dev_err(&lynx->pci_device->dev,
+			"PHY register value %d out of range\n", val);
+		return -1;
+	}
+	reg_write(lynx, LINK_PHY, LINK_PHY_WRITE |
+		  LINK_PHY_ADDR(addr) | LINK_PHY_WDATA(val));
+
+	return 0;
+}
+
+static int
+nosy_open(struct inode *inode, struct file *file)
+{
+	int minor = iminor(inode);
+	struct client *client;
+	struct pcilynx *tmp, *lynx = NULL;
+
+	mutex_lock(&card_mutex);
+	list_for_each_entry(tmp, &card_list, link)
+		if (tmp->misc.minor == minor) {
+			lynx = lynx_get(tmp);
+			break;
+		}
+	mutex_unlock(&card_mutex);
+	if (lynx == NULL)
+		return -ENODEV;
+
+	client = kmalloc(sizeof *client, GFP_KERNEL);
+	if (client == NULL)
+		goto fail;
+
+	client->tcode_mask = ~0;
+	client->lynx = lynx;
+	INIT_LIST_HEAD(&client->link);
+
+	if (packet_buffer_init(&client->buffer, 128 * 1024) < 0)
+		goto fail;
+
+	file->private_data = client;
+
+	return 0;
+fail:
+	kfree(client);
+	lynx_put(lynx);
+
+	return -ENOMEM;
+}
+
+static int
+nosy_release(struct inode *inode, struct file *file)
+{
+	struct client *client = file->private_data;
+	struct pcilynx *lynx = client->lynx;
+
+	spin_lock_irq(&lynx->client_list_lock);
+	list_del_init(&client->link);
+	spin_unlock_irq(&lynx->client_list_lock);
+
+	packet_buffer_destroy(&client->buffer);
+	kfree(client);
+	lynx_put(lynx);
+
+	return 0;
+}
+
+static unsigned int
+nosy_poll(struct file *file, poll_table *pt)
+{
+	struct client *client = file->private_data;
+	unsigned int ret = 0;
+
+	poll_wait(file, &client->buffer.wait, pt);
+
+	if (atomic_read(&client->buffer.size) > 0)
+		ret = POLLIN | POLLRDNORM;
+
+	if (list_empty(&client->lynx->link))
+		ret |= POLLHUP;
+
+	return ret;
+}
+
+static ssize_t
+nosy_read(struct file *file, char __user *buffer, size_t count, loff_t *offset)
+{
+	struct client *client = file->private_data;
+
+	return packet_buffer_get(client, buffer, count);
+}
+
+static long
+nosy_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct client *client = file->private_data;
+	spinlock_t *client_list_lock = &client->lynx->client_list_lock;
+	struct nosy_stats stats;
+
+	switch (cmd) {
+	case NOSY_IOC_GET_STATS:
+		spin_lock_irq(client_list_lock);
+		stats.total_packet_count = client->buffer.total_packet_count;
+		stats.lost_packet_count  = client->buffer.lost_packet_count;
+		spin_unlock_irq(client_list_lock);
+
+		if (copy_to_user((void __user *) arg, &stats, sizeof stats))
+			return -EFAULT;
+		else
+			return 0;
+
+	case NOSY_IOC_START:
+		spin_lock_irq(client_list_lock);
+		list_add_tail(&client->link, &client->lynx->client_list);
+		spin_unlock_irq(client_list_lock);
+
+		return 0;
+
+	case NOSY_IOC_STOP:
+		spin_lock_irq(client_list_lock);
+		list_del_init(&client->link);
+		spin_unlock_irq(client_list_lock);
+
+		return 0;
+
+	case NOSY_IOC_FILTER:
+		spin_lock_irq(client_list_lock);
+		client->tcode_mask = arg;
+		spin_unlock_irq(client_list_lock);
+
+		return 0;
+
+	default:
+		return -EINVAL;
+		/* Flush buffer, configure filter. */
+	}
+}
+
+static const struct file_operations nosy_ops = {
+	.owner =		THIS_MODULE,
+	.read =			nosy_read,
+	.unlocked_ioctl =	nosy_ioctl,
+	.poll =			nosy_poll,
+	.open =			nosy_open,
+	.release =		nosy_release,
+};
+
+#define PHY_PACKET_SIZE 12 /* 1 payload, 1 inverse, 1 ack = 3 quadlets */
+
+static void
+packet_irq_handler(struct pcilynx *lynx)
+{
+	struct client *client;
+	u32 tcode_mask, tcode;
+	size_t length;
+	struct timeval tv;
+
+	/* FIXME: Also report rcv_speed. */
+
+	length = __le32_to_cpu(lynx->rcv_pcl->pcl_status) & 0x00001fff;
+	tcode  = __le32_to_cpu(lynx->rcv_buffer[1]) >> 4 & 0xf;
+
+	do_gettimeofday(&tv);
+	lynx->rcv_buffer[0] = (__force __le32)tv.tv_usec;
+
+	if (length == PHY_PACKET_SIZE)
+		tcode_mask = 1 << TCODE_PHY_PACKET;
+	else
+		tcode_mask = 1 << tcode;
+
+	spin_lock(&lynx->client_list_lock);
+
+	list_for_each_entry(client, &lynx->client_list, link)
+		if (client->tcode_mask & tcode_mask)
+			packet_buffer_put(&client->buffer,
+					  lynx->rcv_buffer, length + 4);
+
+	spin_unlock(&lynx->client_list_lock);
+}
+
+static void
+bus_reset_irq_handler(struct pcilynx *lynx)
+{
+	struct client *client;
+	struct timeval tv;
+
+	do_gettimeofday(&tv);
+
+	spin_lock(&lynx->client_list_lock);
+
+	list_for_each_entry(client, &lynx->client_list, link)
+		packet_buffer_put(&client->buffer, &tv.tv_usec, 4);
+
+	spin_unlock(&lynx->client_list_lock);
+}
+
+static irqreturn_t
+irq_handler(int irq, void *device)
+{
+	struct pcilynx *lynx = device;
+	u32 pci_int_status;
+
+	pci_int_status = reg_read(lynx, PCI_INT_STATUS);
+
+	if (pci_int_status == ~0)
+		/* Card was ejected. */
+		return IRQ_NONE;
+
+	if ((pci_int_status & PCI_INT_INT_PEND) == 0)
+		/* Not our interrupt, bail out quickly. */
+		return IRQ_NONE;
+
+	if ((pci_int_status & PCI_INT_P1394_INT) != 0) {
+		u32 link_int_status;
+
+		link_int_status = reg_read(lynx, LINK_INT_STATUS);
+		reg_write(lynx, LINK_INT_STATUS, link_int_status);
+
+		if ((link_int_status & LINK_INT_PHY_BUSRESET) > 0)
+			bus_reset_irq_handler(lynx);
+	}
+
+	/* Clear the PCI_INT_STATUS register only after clearing the
+	 * LINK_INT_STATUS register; otherwise the PCI_INT_P1394 will
+	 * be set again immediately. */
+
+	reg_write(lynx, PCI_INT_STATUS, pci_int_status);
+
+	if ((pci_int_status & PCI_INT_DMA0_HLT) > 0) {
+		packet_irq_handler(lynx);
+		run_pcl(lynx, lynx->rcv_start_pcl_bus, 0);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void
+remove_card(struct pci_dev *dev)
+{
+	struct pcilynx *lynx = pci_get_drvdata(dev);
+	struct client *client;
+
+	mutex_lock(&card_mutex);
+	list_del_init(&lynx->link);
+	misc_deregister(&lynx->misc);
+	mutex_unlock(&card_mutex);
+
+	reg_write(lynx, PCI_INT_ENABLE, 0);
+	free_irq(lynx->pci_device->irq, lynx);
+
+	spin_lock_irq(&lynx->client_list_lock);
+	list_for_each_entry(client, &lynx->client_list, link)
+		wake_up_interruptible(&client->buffer.wait);
+	spin_unlock_irq(&lynx->client_list_lock);
+
+	pci_free_consistent(lynx->pci_device, sizeof(struct pcl),
+			    lynx->rcv_start_pcl, lynx->rcv_start_pcl_bus);
+	pci_free_consistent(lynx->pci_device, sizeof(struct pcl),
+			    lynx->rcv_pcl, lynx->rcv_pcl_bus);
+	pci_free_consistent(lynx->pci_device, PAGE_SIZE,
+			    lynx->rcv_buffer, lynx->rcv_buffer_bus);
+
+	iounmap(lynx->registers);
+	pci_disable_device(dev);
+	lynx_put(lynx);
+}
+
+#define RCV_BUFFER_SIZE (16 * 1024)
+
+static int __devinit
+add_card(struct pci_dev *dev, const struct pci_device_id *unused)
+{
+	struct pcilynx *lynx;
+	u32 p, end;
+	int ret, i;
+
+	if (pci_set_dma_mask(dev, 0xffffffff)) {
+		dev_err(&dev->dev,
+		    "DMA address limits not supported for PCILynx hardware\n");
+		return -ENXIO;
+	}
+	if (pci_enable_device(dev)) {
+		dev_err(&dev->dev, "Failed to enable PCILynx hardware\n");
+		return -ENXIO;
+	}
+	pci_set_master(dev);
+
+	lynx = kzalloc(sizeof *lynx, GFP_KERNEL);
+	if (lynx == NULL) {
+		dev_err(&dev->dev, "Failed to allocate control structure\n");
+		ret = -ENOMEM;
+		goto fail_disable;
+	}
+	lynx->pci_device = dev;
+	pci_set_drvdata(dev, lynx);
+
+	spin_lock_init(&lynx->client_list_lock);
+	INIT_LIST_HEAD(&lynx->client_list);
+	kref_init(&lynx->kref);
+
+	lynx->registers = ioremap_nocache(pci_resource_start(dev, 0),
+					  PCILYNX_MAX_REGISTER);
+
+	lynx->rcv_start_pcl = pci_alloc_consistent(lynx->pci_device,
+				sizeof(struct pcl), &lynx->rcv_start_pcl_bus);
+	lynx->rcv_pcl = pci_alloc_consistent(lynx->pci_device,
+				sizeof(struct pcl), &lynx->rcv_pcl_bus);
+	lynx->rcv_buffer = pci_alloc_consistent(lynx->pci_device,
+				RCV_BUFFER_SIZE, &lynx->rcv_buffer_bus);
+	if (lynx->rcv_start_pcl == NULL ||
+	    lynx->rcv_pcl == NULL ||
+	    lynx->rcv_buffer == NULL) {
+		dev_err(&dev->dev, "Failed to allocate receive buffer\n");
+		ret = -ENOMEM;
+		goto fail_deallocate;
+	}
+	lynx->rcv_start_pcl->next	= cpu_to_le32(lynx->rcv_pcl_bus);
+	lynx->rcv_pcl->next		= cpu_to_le32(PCL_NEXT_INVALID);
+	lynx->rcv_pcl->async_error_next	= cpu_to_le32(PCL_NEXT_INVALID);
+
+	lynx->rcv_pcl->buffer[0].control =
+			cpu_to_le32(PCL_CMD_RCV | PCL_BIGENDIAN | 2044);
+	lynx->rcv_pcl->buffer[0].pointer =
+			cpu_to_le32(lynx->rcv_buffer_bus + 4);
+	p = lynx->rcv_buffer_bus + 2048;
+	end = lynx->rcv_buffer_bus + RCV_BUFFER_SIZE;
+	for (i = 1; p < end; i++, p += 2048) {
+		lynx->rcv_pcl->buffer[i].control =
+			cpu_to_le32(PCL_CMD_RCV | PCL_BIGENDIAN | 2048);
+		lynx->rcv_pcl->buffer[i].pointer = cpu_to_le32(p);
+	}
+	lynx->rcv_pcl->buffer[i - 1].control |= cpu_to_le32(PCL_LAST_BUFF);
+
+	reg_set_bits(lynx, MISC_CONTROL, MISC_CONTROL_SWRESET);
+	/* Fix buggy cards with autoboot pin not tied low: */
+	reg_write(lynx, DMA0_CHAN_CTRL, 0);
+	reg_write(lynx, DMA_GLOBAL_REGISTER, 0x00 << 24);
+
+#if 0
+	/* now, looking for PHY register set */
+	if ((get_phy_reg(lynx, 2) & 0xe0) == 0xe0) {
+		lynx->phyic.reg_1394a = 1;
+		PRINT(KERN_INFO, lynx->id,
+		      "found 1394a conform PHY (using extended register set)");
+		lynx->phyic.vendor = get_phy_vendorid(lynx);
+		lynx->phyic.product = get_phy_productid(lynx);
+	} else {
+		lynx->phyic.reg_1394a = 0;
+		PRINT(KERN_INFO, lynx->id, "found old 1394 PHY");
+	}
+#endif
+
+	/* Setup the general receive FIFO max size. */
+	reg_write(lynx, FIFO_SIZES, 255);
+
+	reg_set_bits(lynx, PCI_INT_ENABLE, PCI_INT_DMA_ALL);
+
+	reg_write(lynx, LINK_INT_ENABLE,
+		  LINK_INT_PHY_TIME_OUT | LINK_INT_PHY_REG_RCVD |
+		  LINK_INT_PHY_BUSRESET | LINK_INT_IT_STUCK |
+		  LINK_INT_AT_STUCK | LINK_INT_SNTRJ |
+		  LINK_INT_TC_ERR | LINK_INT_GRF_OVER_FLOW |
+		  LINK_INT_ITF_UNDER_FLOW | LINK_INT_ATF_UNDER_FLOW);
+
+	/* Disable the L flag in self ID packets. */
+	set_phy_reg(lynx, 4, 0);
+
+	/* Put this baby into snoop mode */
+	reg_set_bits(lynx, LINK_CONTROL, LINK_CONTROL_SNOOP_ENABLE);
+
+	run_pcl(lynx, lynx->rcv_start_pcl_bus, 0);
+
+	if (request_irq(dev->irq, irq_handler, IRQF_SHARED,
+			driver_name, lynx)) {
+		dev_err(&dev->dev,
+			"Failed to allocate shared interrupt %d\n", dev->irq);
+		ret = -EIO;
+		goto fail_deallocate;
+	}
+
+	lynx->misc.parent = &dev->dev;
+	lynx->misc.minor = MISC_DYNAMIC_MINOR;
+	lynx->misc.name = "nosy";
+	lynx->misc.fops = &nosy_ops;
+
+	mutex_lock(&card_mutex);
+	ret = misc_register(&lynx->misc);
+	if (ret) {
+		dev_err(&dev->dev, "Failed to register misc char device\n");
+		mutex_unlock(&card_mutex);
+		goto fail_free_irq;
+	}
+	list_add_tail(&lynx->link, &card_list);
+	mutex_unlock(&card_mutex);
+
+	dev_info(&dev->dev,
+		 "Initialized PCILynx IEEE1394 card, irq=%d\n", dev->irq);
+
+	return 0;
+
+fail_free_irq:
+	reg_write(lynx, PCI_INT_ENABLE, 0);
+	free_irq(lynx->pci_device->irq, lynx);
+
+fail_deallocate:
+	if (lynx->rcv_start_pcl)
+		pci_free_consistent(lynx->pci_device, sizeof(struct pcl),
+				lynx->rcv_start_pcl, lynx->rcv_start_pcl_bus);
+	if (lynx->rcv_pcl)
+		pci_free_consistent(lynx->pci_device, sizeof(struct pcl),
+				lynx->rcv_pcl, lynx->rcv_pcl_bus);
+	if (lynx->rcv_buffer)
+		pci_free_consistent(lynx->pci_device, PAGE_SIZE,
+				lynx->rcv_buffer, lynx->rcv_buffer_bus);
+	iounmap(lynx->registers);
+	kfree(lynx);
+
+fail_disable:
+	pci_disable_device(dev);
+
+	return ret;
+}
+
+static struct pci_device_id pci_table[] __devinitdata = {
+	{
+		.vendor =    PCI_VENDOR_ID_TI,
+		.device =    PCI_DEVICE_ID_TI_PCILYNX,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+	},
+	{ }	/* Terminating entry */
+};
+
+static struct pci_driver lynx_pci_driver = {
+	.name =		driver_name,
+	.id_table =	pci_table,
+	.probe =	add_card,
+	.remove =	remove_card,
+};
+
+MODULE_AUTHOR("Kristian Hoegsberg");
+MODULE_DESCRIPTION("Snoop mode driver for TI pcilynx 1394 controllers");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, pci_table);
+
+static int __init nosy_init(void)
+{
+	return pci_register_driver(&lynx_pci_driver);
+}
+
+static void __exit nosy_cleanup(void)
+{
+	pci_unregister_driver(&lynx_pci_driver);
+
+	pr_info("Unloaded %s\n", driver_name);
+}
+
+module_init(nosy_init);
+module_exit(nosy_cleanup);
diff --git a/drivers/firewire/nosy.h b/drivers/firewire/nosy.h
new file mode 100644
index 0000000..078ff27
--- /dev/null
+++ b/drivers/firewire/nosy.h
@@ -0,0 +1,237 @@
+/*
+ * Chip register definitions for PCILynx chipset.  Based on pcilynx.h
+ * from the Linux 1394 drivers, but modified a bit so the names here
+ * match the specification exactly (even though they have weird names,
+ * like xxx_OVER_FLOW, or arbitrary abbreviations like SNTRJ for "sent
+ * reject" etc.)
+ */
+
+#define PCILYNX_MAX_REGISTER     0xfff
+#define PCILYNX_MAX_MEMORY       0xffff
+
+#define PCI_LATENCY_CACHELINE             0x0c
+
+#define MISC_CONTROL                      0x40
+#define MISC_CONTROL_SWRESET              (1<<0)
+
+#define SERIAL_EEPROM_CONTROL             0x44
+
+#define PCI_INT_STATUS                    0x48
+#define PCI_INT_ENABLE                    0x4c
+/* status and enable have identical bit numbers */
+#define PCI_INT_INT_PEND                  (1<<31)
+#define PCI_INT_FRC_INT                   (1<<30)
+#define PCI_INT_SLV_ADR_PERR              (1<<28)
+#define PCI_INT_SLV_DAT_PERR              (1<<27)
+#define PCI_INT_MST_DAT_PERR              (1<<26)
+#define PCI_INT_MST_DEV_TO                (1<<25)
+#define PCI_INT_INT_SLV_TO                (1<<23)
+#define PCI_INT_AUX_TO                    (1<<18)
+#define PCI_INT_AUX_INT                   (1<<17)
+#define PCI_INT_P1394_INT                 (1<<16)
+#define PCI_INT_DMA4_PCL                  (1<<9)
+#define PCI_INT_DMA4_HLT                  (1<<8)
+#define PCI_INT_DMA3_PCL                  (1<<7)
+#define PCI_INT_DMA3_HLT                  (1<<6)
+#define PCI_INT_DMA2_PCL                  (1<<5)
+#define PCI_INT_DMA2_HLT                  (1<<4)
+#define PCI_INT_DMA1_PCL                  (1<<3)
+#define PCI_INT_DMA1_HLT                  (1<<2)
+#define PCI_INT_DMA0_PCL                  (1<<1)
+#define PCI_INT_DMA0_HLT                  (1<<0)
+/* all DMA interrupts combined: */
+#define PCI_INT_DMA_ALL                   0x3ff
+
+#define PCI_INT_DMA_HLT(chan)             (1 << (chan * 2))
+#define PCI_INT_DMA_PCL(chan)             (1 << (chan * 2 + 1))
+
+#define LBUS_ADDR                         0xb4
+#define LBUS_ADDR_SEL_RAM                 (0x0<<16)
+#define LBUS_ADDR_SEL_ROM                 (0x1<<16)
+#define LBUS_ADDR_SEL_AUX                 (0x2<<16)
+#define LBUS_ADDR_SEL_ZV                  (0x3<<16)
+
+#define GPIO_CTRL_A                       0xb8
+#define GPIO_CTRL_B                       0xbc
+#define GPIO_DATA_BASE                    0xc0
+
+#define DMA_BREG(base, chan)              (base + chan * 0x20)
+#define DMA_SREG(base, chan)              (base + chan * 0x10)
+
+#define PCL_NEXT_INVALID (1<<0)
+
+/* transfer commands */
+#define PCL_CMD_RCV            (0x1<<24)
+#define PCL_CMD_RCV_AND_UPDATE (0xa<<24)
+#define PCL_CMD_XMT            (0x2<<24)
+#define PCL_CMD_UNFXMT         (0xc<<24)
+#define PCL_CMD_PCI_TO_LBUS    (0x8<<24)
+#define PCL_CMD_LBUS_TO_PCI    (0x9<<24)
+
+/* aux commands */
+#define PCL_CMD_NOP            (0x0<<24)
+#define PCL_CMD_LOAD           (0x3<<24)
+#define PCL_CMD_STOREQ         (0x4<<24)
+#define PCL_CMD_STORED         (0xb<<24)
+#define PCL_CMD_STORE0         (0x5<<24)
+#define PCL_CMD_STORE1         (0x6<<24)
+#define PCL_CMD_COMPARE        (0xe<<24)
+#define PCL_CMD_SWAP_COMPARE   (0xf<<24)
+#define PCL_CMD_ADD            (0xd<<24)
+#define PCL_CMD_BRANCH         (0x7<<24)
+
+/* BRANCH condition codes */
+#define PCL_COND_DMARDY_SET    (0x1<<20)
+#define PCL_COND_DMARDY_CLEAR  (0x2<<20)
+
+#define PCL_GEN_INTR           (1<<19)
+#define PCL_LAST_BUFF          (1<<18)
+#define PCL_LAST_CMD           (PCL_LAST_BUFF)
+#define PCL_WAITSTAT           (1<<17)
+#define PCL_BIGENDIAN          (1<<16)
+#define PCL_ISOMODE            (1<<12)
+
+#define DMA0_PREV_PCL                     0x100
+#define DMA1_PREV_PCL                     0x120
+#define DMA2_PREV_PCL                     0x140
+#define DMA3_PREV_PCL                     0x160
+#define DMA4_PREV_PCL                     0x180
+#define DMA_PREV_PCL(chan)                (DMA_BREG(DMA0_PREV_PCL, chan))
+
+#define DMA0_CURRENT_PCL                  0x104
+#define DMA1_CURRENT_PCL                  0x124
+#define DMA2_CURRENT_PCL                  0x144
+#define DMA3_CURRENT_PCL                  0x164
+#define DMA4_CURRENT_PCL                  0x184
+#define DMA_CURRENT_PCL(chan)             (DMA_BREG(DMA0_CURRENT_PCL, chan))
+
+#define DMA0_CHAN_STAT                    0x10c
+#define DMA1_CHAN_STAT                    0x12c
+#define DMA2_CHAN_STAT                    0x14c
+#define DMA3_CHAN_STAT                    0x16c
+#define DMA4_CHAN_STAT                    0x18c
+#define DMA_CHAN_STAT(chan)               (DMA_BREG(DMA0_CHAN_STAT, chan))
+/* CHAN_STATUS registers share bits */
+#define DMA_CHAN_STAT_SELFID              (1<<31)
+#define DMA_CHAN_STAT_ISOPKT              (1<<30)
+#define DMA_CHAN_STAT_PCIERR              (1<<29)
+#define DMA_CHAN_STAT_PKTERR              (1<<28)
+#define DMA_CHAN_STAT_PKTCMPL             (1<<27)
+#define DMA_CHAN_STAT_SPECIALACK          (1<<14)
+
+#define DMA0_CHAN_CTRL                    0x110
+#define DMA1_CHAN_CTRL                    0x130
+#define DMA2_CHAN_CTRL                    0x150
+#define DMA3_CHAN_CTRL                    0x170
+#define DMA4_CHAN_CTRL                    0x190
+#define DMA_CHAN_CTRL(chan)               (DMA_BREG(DMA0_CHAN_CTRL, chan))
+/* CHAN_CTRL registers share bits */
+#define DMA_CHAN_CTRL_ENABLE              (1<<31)
+#define DMA_CHAN_CTRL_BUSY                (1<<30)
+#define DMA_CHAN_CTRL_LINK                (1<<29)
+
+#define DMA0_READY                        0x114
+#define DMA1_READY                        0x134
+#define DMA2_READY                        0x154
+#define DMA3_READY                        0x174
+#define DMA4_READY                        0x194
+#define DMA_READY(chan)                   (DMA_BREG(DMA0_READY, chan))
+
+#define DMA_GLOBAL_REGISTER               0x908
+
+#define FIFO_SIZES                        0xa00
+
+#define FIFO_CONTROL                      0xa10
+#define FIFO_CONTROL_GRF_FLUSH            (1<<4)
+#define FIFO_CONTROL_ITF_FLUSH            (1<<3)
+#define FIFO_CONTROL_ATF_FLUSH            (1<<2)
+
+#define FIFO_XMIT_THRESHOLD               0xa14
+
+#define DMA0_WORD0_CMP_VALUE              0xb00
+#define DMA1_WORD0_CMP_VALUE              0xb10
+#define DMA2_WORD0_CMP_VALUE              0xb20
+#define DMA3_WORD0_CMP_VALUE              0xb30
+#define DMA4_WORD0_CMP_VALUE              0xb40
+#define DMA_WORD0_CMP_VALUE(chan)	(DMA_SREG(DMA0_WORD0_CMP_VALUE, chan))
+
+#define DMA0_WORD0_CMP_ENABLE             0xb04
+#define DMA1_WORD0_CMP_ENABLE             0xb14
+#define DMA2_WORD0_CMP_ENABLE             0xb24
+#define DMA3_WORD0_CMP_ENABLE             0xb34
+#define DMA4_WORD0_CMP_ENABLE             0xb44
+#define DMA_WORD0_CMP_ENABLE(chan)	(DMA_SREG(DMA0_WORD0_CMP_ENABLE, chan))
+
+#define DMA0_WORD1_CMP_VALUE              0xb08
+#define DMA1_WORD1_CMP_VALUE              0xb18
+#define DMA2_WORD1_CMP_VALUE              0xb28
+#define DMA3_WORD1_CMP_VALUE              0xb38
+#define DMA4_WORD1_CMP_VALUE              0xb48
+#define DMA_WORD1_CMP_VALUE(chan)	(DMA_SREG(DMA0_WORD1_CMP_VALUE, chan))
+
+#define DMA0_WORD1_CMP_ENABLE             0xb0c
+#define DMA1_WORD1_CMP_ENABLE             0xb1c
+#define DMA2_WORD1_CMP_ENABLE             0xb2c
+#define DMA3_WORD1_CMP_ENABLE             0xb3c
+#define DMA4_WORD1_CMP_ENABLE             0xb4c
+#define DMA_WORD1_CMP_ENABLE(chan)	(DMA_SREG(DMA0_WORD1_CMP_ENABLE, chan))
+/* word 1 compare enable flags */
+#define DMA_WORD1_CMP_MATCH_OTHERBUS      (1<<15)
+#define DMA_WORD1_CMP_MATCH_BROADCAST     (1<<14)
+#define DMA_WORD1_CMP_MATCH_BUS_BCAST     (1<<13)
+#define DMA_WORD1_CMP_MATCH_LOCAL_NODE    (1<<12)
+#define DMA_WORD1_CMP_MATCH_EXACT         (1<<11)
+#define DMA_WORD1_CMP_ENABLE_SELF_ID      (1<<10)
+#define DMA_WORD1_CMP_ENABLE_MASTER       (1<<8)
+
+#define LINK_ID                           0xf00
+#define LINK_ID_BUS(id)                   (id<<22)
+#define LINK_ID_NODE(id)                  (id<<16)
+
+#define LINK_CONTROL                      0xf04
+#define LINK_CONTROL_BUSY                 (1<<29)
+#define LINK_CONTROL_TX_ISO_EN            (1<<26)
+#define LINK_CONTROL_RX_ISO_EN            (1<<25)
+#define LINK_CONTROL_TX_ASYNC_EN          (1<<24)
+#define LINK_CONTROL_RX_ASYNC_EN          (1<<23)
+#define LINK_CONTROL_RESET_TX             (1<<21)
+#define LINK_CONTROL_RESET_RX             (1<<20)
+#define LINK_CONTROL_CYCMASTER            (1<<11)
+#define LINK_CONTROL_CYCSOURCE            (1<<10)
+#define LINK_CONTROL_CYCTIMEREN           (1<<9)
+#define LINK_CONTROL_RCV_CMP_VALID        (1<<7)
+#define LINK_CONTROL_SNOOP_ENABLE         (1<<6)
+
+#define CYCLE_TIMER                       0xf08
+
+#define LINK_PHY                          0xf0c
+#define LINK_PHY_READ                     (1<<31)
+#define LINK_PHY_WRITE                    (1<<30)
+#define LINK_PHY_ADDR(addr)               (addr<<24)
+#define LINK_PHY_WDATA(data)              (data<<16)
+#define LINK_PHY_RADDR(addr)              (addr<<8)
+
+#define LINK_INT_STATUS                   0xf14
+#define LINK_INT_ENABLE                   0xf18
+/* status and enable have identical bit numbers */
+#define LINK_INT_LINK_INT                 (1<<31)
+#define LINK_INT_PHY_TIME_OUT             (1<<30)
+#define LINK_INT_PHY_REG_RCVD             (1<<29)
+#define LINK_INT_PHY_BUSRESET             (1<<28)
+#define LINK_INT_TX_RDY                   (1<<26)
+#define LINK_INT_RX_DATA_RDY              (1<<25)
+#define LINK_INT_IT_STUCK                 (1<<20)
+#define LINK_INT_AT_STUCK                 (1<<19)
+#define LINK_INT_SNTRJ                    (1<<17)
+#define LINK_INT_HDR_ERR                  (1<<16)
+#define LINK_INT_TC_ERR                   (1<<15)
+#define LINK_INT_CYC_SEC                  (1<<11)
+#define LINK_INT_CYC_STRT                 (1<<10)
+#define LINK_INT_CYC_DONE                 (1<<9)
+#define LINK_INT_CYC_PEND                 (1<<8)
+#define LINK_INT_CYC_LOST                 (1<<7)
+#define LINK_INT_CYC_ARB_FAILED           (1<<6)
+#define LINK_INT_GRF_OVER_FLOW            (1<<5)
+#define LINK_INT_ITF_UNDER_FLOW           (1<<4)
+#define LINK_INT_ATF_UNDER_FLOW           (1<<3)
+#define LINK_INT_IARB_FAILED              (1<<0)

-- 
Stefan Richter
-=====-==-=- -=== =-==-
http://arcgraph.de/sr/

