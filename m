Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2K1RYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:24:44 -0500
Received: from leviathan.tchmachines.com ([208.76.85.180]:49133 "EHLO
	leviathan.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2K1RYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:24:42 -0500
X-Greylist: delayed 2632 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2012 12:24:41 EST
From: Eli Billauer <eli.billauer@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 2/2] New driver: Xillybus generic interface for FPGA (programmable logic)
Date: Wed, 28 Nov 2012 17:41:33 +0200
Message-Id: <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - leviathan.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - billauer.co.il
X-Get-Message-Sender-Via: leviathan.tchmachines.com: authenticated_id: billaue/sender_address_domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xillybus is a general-purpose framework for communication between programmable
logic (FPGA) and a host. It provides a simple connection between hardware FIFOs
in the FPGA and their respective device files on the host. The user space
programming model is like piping data from or to the FPGA.

The underlying transport between the host and FPGA is either PCIe or AXI
(AMBA bus by ARM).

The Xillybus logic (IP core) is configurable in the number of pipes it presents
and their nature. The driver autodetects these pipes, making it essentially
forward-compatible to future configurations. The benefit of having this driver
enabled in the kernel is that hardware vendors may release a new card, knowing
that it will work out of the box on any future Linux machine, with the specific
configuration defined for the FPGA part.

This driver has been available for download for over a year, and has been
actively used on a wide variety of kernels versions and configurations.

Website: http://xillybus.com

Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 drivers/misc/Kconfig    |   32 +
 drivers/misc/Makefile   |    1 +
 drivers/misc/xillybus.c | 2845 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 2878 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/xillybus.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b151b7c..87f5dd7 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -499,6 +499,38 @@ config USB_SWITCH_FSA9480
 	  stereo and mono audio, video, microphone and UART data to use
 	  a common connector port.
 
+config XILLYBUS
+	tristate "Xillybus Support"
+	depends on PCI || (OF_ADDRESS && OF_DEVICE && OF_IRQ)
+	default m
+	help
+	  Xillybus is a generic interface for peripherals designed on
+	  programmable logic (FPGA). The driver probes the hardware for
+	  its capabilities, and creates device files accordingly.
+
+	  If unsure, say M.
+
+config XILLYBUS_PCIE
+	bool "Xillybus over PCIe"
+	depends on XILLYBUS && PCI
+	default y
+	help
+	  Set to Y if you want Xillybus to use PCI Express for communicating
+	  with the FPGA. This option is harmless, but it requires PCI
+	  support on the kernel. Say Y if the target processor supports
+	  PCI and/or PCIe.
+
+config XILLYBUS_OF
+	bool "Xillybus over Device Tree"
+	depends on XILLYBUS && OF_ADDRESS && OF_DEVICE && OF_IRQ
+	default y
+	help
+	  Set to Y if you want Xillybus to find its resources from the
+	  Open Firmware Flattened Device Tree. If the target is an embedded
+	  system, say Y.  This option is harmless, but it requires Device
+	  Tree support on the kernel, which is usually not the case for
+	  kernels for fullblown computers.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 2129377..fcac6cb 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -49,3 +49,4 @@ obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
 obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
 obj-$(CONFIG_INTEL_MEI)		+= mei/
+obj-$(CONFIG_XILLYBUS)		+= xillybus.o
diff --git a/drivers/misc/xillybus.c b/drivers/misc/xillybus.c
new file mode 100644
index 0000000..0b937c2
--- /dev/null
+++ b/drivers/misc/xillybus.c
@@ -0,0 +1,2845 @@
+#include <linux/version.h>
+#include <linux/list.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/crc32.h>
+#include <linux/poll.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#ifdef CONFIG_XILLYBUS_PCIE
+#include <linux/pci.h>
+#include <linux/pci-aspm.h>
+#endif
+
+#ifdef CONFIG_XILLYBUS_OF
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#endif
+
+MODULE_DESCRIPTION("Xillybus driver");
+MODULE_AUTHOR("Eli Billauer, Xillybus Ltd.");
+MODULE_VERSION("1.06");
+MODULE_ALIAS("xillybus");
+MODULE_LICENSE("GPL v2");
+
+/* General timeout is 100 ms, rx timeout is 10 ms */
+#define XILLY_RX_TIMEOUT (10*HZ/1000)
+#define XILLY_TIMEOUT (100*HZ/1000)
+
+#define fpga_msg_ctrl_reg 0x0002
+#define fpga_dma_control_reg 0x0008
+#define fpga_dma_bufno_reg 0x0009
+#define fpga_dma_bufaddr_lowaddr_reg 0x000a
+#define fpga_dma_bufaddr_highaddr_reg 0x000b
+#define fpga_buf_ctrl_reg 0x000c
+#define fpga_buf_offset_reg 0x000d
+#define fpga_endian_reg 0x0010
+
+#define XILLYMSG_OPCODE_RELEASEBUF 1
+#define XILLYMSG_OPCODE_QUIESCEACK 2
+#define XILLYMSG_OPCODE_FIFOEOF 3
+#define XILLYMSG_OPCODE_FATAL_ERROR 4
+#define XILLYMSG_OPCODE_NONEMPTY 5
+
+#if (PAGE_SIZE < 4096)
+#error Your processor architecture has a page size smaller than 4096
+#endif
+
+#ifdef CONFIG_XILLYBUS_OF
+/* Match table for of_platform binding */
+static struct of_device_id xillybus_of_match[] __devinitdata = {
+	{ .compatible = "xlnx,xillybus-1.00.a", },
+	{}
+};
+
+MODULE_DEVICE_TABLE(of, xillybus_of_match);
+#endif
+
+static struct class *xillybus_class;
+
+/*
+ * ep_list_lock is the last lock to be taken; No other lock requests are
+ * allowed while holding it. It merely protects list_of_endpoints, and not
+ * the endpoints listed in it.
+ */
+
+static LIST_HEAD(list_of_endpoints);
+static struct mutex ep_list_lock;
+struct workqueue_struct *xillybus_wq;
+
+#ifdef CONFIG_XILLYBUS_PCIE
+static DEFINE_PCI_DEVICE_TABLE(xillyids) = {
+	{PCI_DEVICE(PCI_VENDOR_ID_XILINX, PCI_DEVICE_ID_XILLYBUS)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ALTERA, PCI_DEVICE_ID_XILLYBUS)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ACTEL, PCI_DEVICE_ID_XILLYBUS)},
+	{PCI_DEVICE(PCI_VENDOR_ID_LATTICE, PCI_DEVICE_ID_XILLYBUS)},
+	{ /* End: all zeroes */ }
+};
+#endif
+
+struct xilly_page {
+	struct list_head node;
+	unsigned long addr;
+	unsigned int order;
+};
+
+struct xilly_dma {
+	struct list_head node;
+	struct pci_dev *pdev;
+	struct device *dev;
+	dma_addr_t dma_addr;
+	size_t size;
+	int direction;
+};
+
+struct xilly_buffer {
+	void *addr;
+	dma_addr_t dma_addr;
+	int end_offset; /* Counting elements, not bytes */
+};
+
+/*
+ * Locking scheme: Mutexes protect invocations of character device methods.
+ * If both locks are taken, wr_mutex is taken first, rd_mutex second.
+ *
+ * wr_spinlock protects wr_*_buf_idx, wr_empty, wr_sleepy, wr_ready and the
+ * buffers' end_offset fields against changes made by IRQ handler (and in
+ * theory, other file request handlers, but the mutex handles that). Nothing
+ * else.
+ * They are held for short direct memory manipulations. Needless to say,
+ * no mutex locking is allowed when a spinlock is held.
+ *
+ * rd_spinlock does the same with rd_*_buf_idx, rd_empty and end_offset.
+ *
+ * register_mutex is endpoint-specific, and is held when non-atomic
+ * register operations are performed. wr_mutex and rd_mutex may be
+ * held when register_mutex is taken, but none of the spinlocks. Note that
+ * register_mutex doesn't protect against sporadic buf_ctrl_reg writes
+ * which are unrelated to buf_offset_reg, since they are harmless.
+ *
+ * Blocking on the wait queues is allowed with mutexes held, but not with
+ * spinlocks.
+ *
+ * Only interruptible blocking is allowed on mutexes and wait queues.
+ *
+ * All in all, the locking order goes (with skips allowed, of course):
+ * wr_mutex -> rd_mutex -> register_mutex -> wr_spinlock -> rd_spinlock
+ */
+
+struct xilly_cleanup {
+	struct list_head to_kfree;
+	struct list_head to_pagefree;
+	struct list_head to_unmap;
+};
+
+struct xilly_idt_handle {
+	unsigned char *chandesc;
+	unsigned char *idt;
+	int entries;
+};
+
+/*
+ * Read-write confusion: wr_* and rd_* notation sticks to FPGA view, so
+ * wr_* buffers are those consumed by read(), since the FPGA writes to them
+ * and vice versa.
+ */
+
+struct xilly_channel {
+	struct xilly_endpoint *endpoint;
+	int chan_num;
+	int log2_element_size;
+	int seekable;
+
+	struct xilly_buffer **wr_buffers; /* FPGA writes, driver reads! */
+	int num_wr_buffers;
+	unsigned int wr_buf_size; /* In bytes */
+	int wr_fpga_buf_idx;
+	int wr_host_buf_idx;
+	int wr_host_buf_pos;
+	int wr_empty;
+	int wr_ready; /* Significant only when wr_empty == 1 */
+	int wr_sleepy;
+	int wr_eof;
+	int wr_hangup;
+	spinlock_t wr_spinlock;
+	struct mutex wr_mutex;
+	wait_queue_head_t wr_wait;
+	wait_queue_head_t wr_ready_wait;
+	int wr_ref_count;
+	int wr_synchronous;
+	int wr_allow_partial;
+	int wr_exclusive_open;
+	int wr_supports_nonempty;
+
+	struct xilly_buffer **rd_buffers; /* FPGA reads, driver writes! */
+	int num_rd_buffers;
+	unsigned int rd_buf_size; /* In bytes */
+	int rd_fpga_buf_idx;
+	int rd_host_buf_pos;
+	int rd_host_buf_idx;
+	int rd_full;
+	spinlock_t rd_spinlock;
+	struct mutex rd_mutex;
+	wait_queue_head_t rd_wait;
+	int rd_ref_count;
+	int rd_allow_partial;
+	int rd_synchronous;
+	int rd_exclusive_open;
+	struct delayed_work rd_workitem;
+	unsigned char rd_leftovers[4];
+};
+
+struct xilly_endpoint {
+	/*
+	 * One of pdev and dev is always NULL, and the other is a valid
+	 * pointer, depending on the type of device
+	 */
+	struct pci_dev *pdev;
+	struct device *dev;
+	struct resource res; /* OF devices only */
+
+	struct list_head ep_list;
+	int dma_using_dac; /* =1 if 64-bit DMA is used, =0 otherwise. */
+	u32 *registers;
+	int fatal_error;
+
+	struct mutex register_mutex;
+	wait_queue_head_t ep_wait;
+
+	/* List of memory allocations, to make release easy */
+	struct xilly_cleanup cleanup;
+
+	/* Channels and message handling */
+	struct cdev cdev;
+
+	int major;
+	int lowest_minor; /* Highest minor = lowest_minor + num_channels - 1 */
+
+	int num_channels; /* EXCLUDING message buffer */
+	struct xilly_channel **channels;
+	int msg_counter;
+	int failed_messages;
+	int idtlen;
+
+	u32 *msgbuf_addr;
+	dma_addr_t msgbuf_dma_addr;
+	unsigned int msg_buf_size;
+};
+
+const char xillyname[] = "xillybus";
+
+static void malformed_message(u32 *buf)
+{
+	int opcode;
+	int msg_channel, msg_bufno, msg_data, msg_dir;
+
+	opcode = (buf[0] >> 24) & 0xff;
+	msg_dir = buf[0] & 1;
+	msg_channel = (buf[0] >> 1) & 0x7ff;
+	msg_bufno = (buf[0] >> 12) & 0x3ff;
+	msg_data = buf[1] & 0xfffffff;
+
+	pr_warn("xillybus: Malformed message (skipping): "
+		"opcode=%d, channel=%03x, dir=%d, bufno=%03x, data=%07x\n",
+		opcode, msg_channel, msg_dir, msg_bufno, msg_data);
+}
+
+#ifdef CONFIG_XILLYBUS_PCIE
+static int xilly_pci_direction(int direction)
+{
+	switch (direction) {
+	case DMA_TO_DEVICE:
+		return PCI_DMA_TODEVICE;
+	case DMA_FROM_DEVICE:
+		return PCI_DMA_FROMDEVICE;
+	default:
+		return PCI_DMA_BIDIRECTIONAL;
+	}
+}
+#endif
+
+static void xilly_dma_sync_single_for_cpu(struct xilly_endpoint *ep,
+					  dma_addr_t dma_handle,
+					  size_t size,
+					  int direction)
+{
+#ifdef CONFIG_XILLYBUS_PCIE
+	if (ep->pdev)
+		pci_dma_sync_single_for_cpu(ep->pdev,
+					    dma_handle,
+					    size,
+					    xilly_pci_direction(direction));
+	else
+#endif
+		dma_sync_single_for_cpu(ep->dev, dma_handle,
+					size, direction);
+}
+
+static void xilly_dma_sync_single_for_device(struct xilly_endpoint *ep,
+					     dma_addr_t dma_handle,
+					     size_t size,
+					     int direction)
+{
+#ifdef CONFIG_XILLYBUS_PCIE
+	if (ep->pdev)
+		pci_dma_sync_single_for_device(ep->pdev,
+					    dma_handle,
+					    size,
+					    xilly_pci_direction(direction));
+	else
+#endif
+	  dma_sync_single_for_device(ep->dev, dma_handle,
+				     size, direction);
+}
+
+
+/*
+ * xillybus_isr assumes the interrupt is allocated exclusively to it,
+ * which is the natural case MSI and several other hardware-oriented
+ * interrupts. Sharing is not allowed.
+ */
+
+static irqreturn_t xillybus_isr(int irq, void *data)
+{
+	struct xilly_endpoint *ep = data;
+	u32 *buf;
+	unsigned int buf_size;
+	int i;
+	int opcode;
+	unsigned int msg_channel, msg_bufno, msg_data, msg_dir;
+	struct xilly_channel *channel;
+
+	/*
+	 * The endpoint structure is altered during periods when it's
+	 * guaranteed no interrupt will occur, but in theory, the cache
+	 * lines may not be updated. So a memory barrier is issued.
+	 */
+
+	smp_rmb();
+
+	buf = ep->msgbuf_addr;
+	buf_size = ep->msg_buf_size/sizeof(u32);
+
+
+	xilly_dma_sync_single_for_cpu(ep,
+				      ep->msgbuf_dma_addr,
+				      ep->msg_buf_size,
+				      DMA_FROM_DEVICE);
+
+	for (i = 0; i < buf_size; i += 2)
+		if (((buf[i+1] >> 28) & 0xf) != ep->msg_counter) {
+			malformed_message(&buf[i]);
+			pr_warn("xillybus: Sending a NACK on "
+				"counter %x (instead of %x) on entry %d\n",
+				((buf[i+1] >> 28) & 0xf),
+				ep->msg_counter,
+				i/2);
+
+			if (++ep->failed_messages > 10)
+				pr_err("xillybus: Lost sync with "
+				       "interrupt messages. Stopping.\n");
+			else {
+				xilly_dma_sync_single_for_device(
+					ep,
+					ep->msgbuf_dma_addr,
+					ep->msg_buf_size,
+					DMA_FROM_DEVICE);
+
+				iowrite32(0x01,  /* Message NACK */
+					  &ep->registers[fpga_msg_ctrl_reg]);
+			}
+			return IRQ_HANDLED;
+		} else if (buf[i] & (1 << 22)) /* Last message */
+			break;
+
+	if (i >= buf_size) {
+		pr_err("xillybus: Bad interrupt message. Stopping.\n");
+		return IRQ_HANDLED;
+	}
+
+	buf_size = i;
+
+	for (i = 0; i <= buf_size; i += 2) { /* Scan through messages */
+		opcode = (buf[i] >> 24) & 0xff;
+
+		msg_dir = buf[i] & 1;
+		msg_channel = (buf[i] >> 1) & 0x7ff;
+		msg_bufno = (buf[i] >> 12) & 0x3ff;
+		msg_data = buf[i+1] & 0xfffffff;
+
+		switch (opcode) {
+		case XILLYMSG_OPCODE_RELEASEBUF:
+
+			if ((msg_channel > ep->num_channels) ||
+			    (msg_channel == 0)) {
+				malformed_message(&buf[i]);
+				break;
+			}
+
+			channel = ep->channels[msg_channel];
+
+			if (msg_dir) { /* Write channel */
+				if (msg_bufno >= channel->num_wr_buffers) {
+					malformed_message(&buf[i]);
+					break;
+				}
+				spin_lock(&channel->wr_spinlock);
+				channel->wr_buffers[msg_bufno]->end_offset =
+					msg_data;
+				channel->wr_fpga_buf_idx = msg_bufno;
+				channel->wr_empty = 0;
+				channel->wr_sleepy = 0;
+				spin_unlock(&channel->wr_spinlock);
+
+				wake_up_interruptible(&channel->wr_wait);
+
+			} else {
+				/* Read channel */
+
+				if (msg_bufno >= channel->num_rd_buffers) {
+					malformed_message(&buf[i]);
+					break;
+				}
+
+				spin_lock(&channel->rd_spinlock);
+				channel->rd_fpga_buf_idx = msg_bufno;
+				channel->rd_full = 0;
+				spin_unlock(&channel->rd_spinlock);
+
+				wake_up_interruptible(&channel->rd_wait);
+				if (!channel->rd_synchronous)
+					queue_delayed_work(
+						xillybus_wq,
+						&channel->rd_workitem,
+						XILLY_RX_TIMEOUT);
+			}
+
+			break;
+		case XILLYMSG_OPCODE_NONEMPTY:
+			if ((msg_channel > ep->num_channels) ||
+			    (msg_channel == 0) || (!msg_dir) ||
+			    !ep->channels[msg_channel]->wr_supports_nonempty) {
+				malformed_message(&buf[i]);
+				break;
+			}
+
+			channel = ep->channels[msg_channel];
+
+			if (msg_bufno >= channel->num_wr_buffers) {
+				malformed_message(&buf[i]);
+				break;
+			}
+			spin_lock(&channel->wr_spinlock);
+			if (msg_bufno == channel->wr_host_buf_idx)
+				channel->wr_ready = 1;
+			spin_unlock(&channel->wr_spinlock);
+
+			wake_up_interruptible(&channel->wr_ready_wait);
+
+			break;
+		case XILLYMSG_OPCODE_QUIESCEACK:
+			ep->idtlen = msg_data;
+			wake_up_interruptible(&ep->ep_wait);
+
+			break;
+		case XILLYMSG_OPCODE_FIFOEOF:
+			channel = ep->channels[msg_channel];
+			spin_lock(&channel->wr_spinlock);
+			channel->wr_eof = msg_bufno;
+			channel->wr_sleepy = 0;
+
+			channel->wr_hangup = channel->wr_empty &&
+				(channel->wr_host_buf_idx == msg_bufno);
+
+			spin_unlock(&channel->wr_spinlock);
+
+			wake_up_interruptible(&channel->wr_wait);
+
+			break;
+		case XILLYMSG_OPCODE_FATAL_ERROR:
+			ep->fatal_error = 1;
+			wake_up_interruptible(&ep->ep_wait); /* For select() */
+			pr_err("xillybus: FPGA reported a fatal "
+			       "error. This means that the low-level "
+			       "communication with the device has failed. "
+			       "This hardware problem is most likely "
+			       "unrelated to xillybus (neither kernel "
+			       "module nor FPGA core), but reports are "
+			       "still welcome. All I/O is aborted.\n");
+			break;
+		default:
+			malformed_message(&buf[i]);
+			break;
+		}
+	}
+
+	xilly_dma_sync_single_for_device(ep,
+					 ep->msgbuf_dma_addr,
+					 ep->msg_buf_size,
+					 DMA_FROM_DEVICE);
+
+	ep->msg_counter = (ep->msg_counter + 1) & 0xf;
+	ep->failed_messages = 0;
+	iowrite32(0x03, &ep->registers[fpga_msg_ctrl_reg]); /* Message ACK */
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * A few trivial memory management functions.
+ * NOTE: These functions are used only on probe and remove, and therefore
+ * no locks are applied!
+ */
+
+static void xilly_do_cleanup(struct xilly_cleanup *mem)
+{
+	struct list_head *this, *next;
+
+	list_for_each_safe(this, next, &mem->to_unmap) {
+		struct xilly_dma *entry =
+			list_entry(this, struct xilly_dma, node);
+
+		if (entry->pdev)
+#ifdef CONFIG_XILLYBUS_PCIE
+			pci_unmap_single(entry->pdev,
+					 entry->dma_addr,
+					 entry->size,
+					 entry->direction);
+		else
+#endif
+			dma_unmap_single(entry->dev,
+					 entry->dma_addr,
+					 entry->size,
+					 entry->direction);
+
+		kfree(entry);
+	}
+
+	INIT_LIST_HEAD(&mem->to_unmap);
+
+	list_for_each_safe(this, next, &mem->to_kfree)
+		kfree(this);
+
+	INIT_LIST_HEAD(&mem->to_kfree);
+
+	list_for_each_safe(this, next, &mem->to_pagefree) {
+		struct xilly_page *entry =
+			list_entry(this, struct xilly_page, node);
+
+		free_pages(entry->addr, entry->order);
+		kfree(entry);
+	}
+	INIT_LIST_HEAD(&mem->to_pagefree);
+}
+
+static void *xilly_malloc(struct xilly_cleanup *mem, size_t size)
+{
+	void *ptr;
+
+	ptr = kzalloc(sizeof(struct list_head) + size, GFP_KERNEL);
+
+	if (!ptr)
+		return ptr;
+
+	list_add_tail((struct list_head *) ptr, &mem->to_kfree);
+
+	return ptr + sizeof(struct list_head);
+}
+
+static unsigned long xilly_pagealloc(struct xilly_cleanup *mem,
+				     unsigned long order)
+{
+	unsigned long addr;
+	struct xilly_page *this;
+
+	this = kmalloc(sizeof(struct xilly_page), GFP_KERNEL);
+	if (!this)
+		return 0;
+
+	addr =  __get_free_pages(GFP_KERNEL | __GFP_DMA | __GFP_ZERO, order);
+
+	if (!addr) {
+		kfree(this);
+		return 0;
+	}
+
+	this->addr = addr;
+	this->order = order;
+
+	list_add_tail(&this->node, &mem->to_pagefree);
+
+	return addr;
+}
+
+/*
+ * Map either through the PCI DMA mapper or the non_PCI one. Behind the
+ * scenes exactly the same functions are called with the same parameters,
+ * but that can change.
+ */
+
+static dma_addr_t xilly_map_single(struct xilly_cleanup *mem,
+				   struct xilly_endpoint *ep,
+				   void *ptr,
+				   size_t size,
+				   int direction
+	)
+{
+
+	dma_addr_t addr = 0;
+	struct xilly_dma *this;
+
+	this = kmalloc(sizeof(struct xilly_dma), GFP_KERNEL);
+	if (!this)
+		return 0;
+
+	if (ep->pdev) {
+#ifdef CONFIG_XILLYBUS_PCIE
+		int pci_direction = xilly_pci_direction(direction);
+		addr = pci_map_single(ep->pdev, ptr, size, pci_direction);
+		this->direction = pci_direction;
+
+		if (pci_dma_mapping_error(ep->pdev, addr))
+			return 0;
+#else
+		BUG();
+#endif
+	} else {
+		addr = dma_map_single(ep->dev, ptr, size, direction);
+		this->direction = direction;
+
+		if (dma_mapping_error(ep->dev, addr))
+			return 0;
+	}
+
+	this->dma_addr = addr;
+	this->dev = ep->dev;
+	this->pdev = ep->pdev;
+	this->size = size;
+
+	list_add_tail(&this->node, &mem->to_unmap);
+
+	return addr;
+}
+
+static void xillybus_autoflush(struct work_struct *work);
+
+static int xilly_setupchannels(struct xilly_endpoint *ep,
+			       struct xilly_cleanup *mem,
+			       unsigned char *chandesc,
+			       int entries
+	)
+{
+	int i, entry, wr_nbuffer, rd_nbuffer;
+	struct xilly_channel *channel;
+	int channelnum, bufnum, bufsize, format, is_writebuf;
+	int bytebufsize;
+	int synchronous, allowpartial, exclusive_open, seekable;
+	int supports_nonempty;
+	void *wr_salami = NULL;
+	void *rd_salami = NULL;
+	int left_of_wr_salami = 0;
+	int left_of_rd_salami = 0;
+	dma_addr_t dma_addr;
+	int msg_buf_done = 0;
+
+	struct xilly_buffer *this_buffer = NULL; /* Init to silence warning */
+
+	channel = xilly_malloc(mem, ep->num_channels *
+			       sizeof(struct xilly_channel));
+
+	if (!channel)
+		goto memfail;
+
+	ep->channels = xilly_malloc(mem, (ep->num_channels + 1) *
+				    sizeof(struct xilly_channel *));
+
+	if (!ep->channels)
+		goto memfail;
+
+	ep->channels[0] = NULL; /* Channel 0 is message buf. */
+
+	/* Initialize all channels with defaults */
+
+	for (i = 1; i <= ep->num_channels; i++) {
+		channel->wr_buffers = NULL;
+		channel->rd_buffers = NULL;
+		channel->num_wr_buffers = 0;
+		channel->num_rd_buffers = 0;
+		channel->wr_fpga_buf_idx = -1;
+		channel->wr_host_buf_idx = 0;
+		channel->wr_host_buf_pos = 0;
+		channel->wr_empty = 1;
+		channel->wr_ready = 0;
+		channel->wr_sleepy = 1;
+		channel->rd_fpga_buf_idx = 0;
+		channel->rd_host_buf_idx = 0;
+		channel->rd_host_buf_pos = 0;
+		channel->rd_full = 0;
+		channel->wr_ref_count = 0;
+		channel->rd_ref_count = 0;
+
+		spin_lock_init(&channel->wr_spinlock);
+		spin_lock_init(&channel->rd_spinlock);
+		mutex_init(&channel->wr_mutex);
+		mutex_init(&channel->rd_mutex);
+		init_waitqueue_head(&channel->rd_wait);
+		init_waitqueue_head(&channel->wr_wait);
+		init_waitqueue_head(&channel->wr_ready_wait);
+
+		INIT_DELAYED_WORK(&channel->rd_workitem, xillybus_autoflush);
+
+		channel->endpoint = ep;
+		channel->chan_num = i;
+
+		channel->log2_element_size = 0;
+
+		ep->channels[i] = channel++;
+	}
+
+	/*
+	 * The DMA buffer address update is atomic on the FPGA, so even if
+	 * it was in the middle of sending messages to some buffer, changing
+	 * the address is safe, since the data will go to either of the
+	 * buffers. Not that this situation should occur at all anyhow.
+	 */
+
+	wr_nbuffer = 1;
+	rd_nbuffer = 1; /* Buffer zero isn't used at all */
+
+	for (entry = 0; entry < entries; entry++, chandesc += 4) {
+		is_writebuf = chandesc[0] & 0x01;
+		channelnum = (chandesc[0] >> 1) | ((chandesc[1] & 0x0f) << 7);
+		format = (chandesc[1] >> 4) & 0x03;
+		allowpartial = (chandesc[1] >> 6) & 0x01;
+		synchronous = (chandesc[1] >> 7) & 0x01;
+		bufsize = 1 << (chandesc[2] & 0x1f);
+		bufnum = 1 << (chandesc[3] & 0x0f);
+		exclusive_open = (chandesc[2] >> 7) & 0x01;
+		seekable = (chandesc[2] >> 6) & 0x01;
+		supports_nonempty = (chandesc[2] >> 5) & 0x01;
+
+		if ((channelnum > ep->num_channels) ||
+		    ((channelnum == 0) && !is_writebuf)) {
+			pr_err("xillybus: IDT requests channel out "
+			       "of range. Aborting.\n");
+			return -ENODEV;
+		}
+
+		channel = ep->channels[channelnum]; /* NULL for msg channel */
+
+		bytebufsize = bufsize << 2; /* Overwritten just below */
+
+		if (!is_writebuf) {
+			channel->num_rd_buffers = bufnum;
+			channel->log2_element_size = ((format > 2) ?
+						      2 : format);
+			bytebufsize = channel->rd_buf_size = bufsize *
+				(1 << channel->log2_element_size);
+			channel->rd_allow_partial = allowpartial;
+			channel->rd_synchronous = synchronous;
+			channel->rd_exclusive_open = exclusive_open;
+			channel->seekable = seekable;
+
+			channel->rd_buffers = xilly_malloc(
+				mem,
+				bufnum * sizeof(struct xilly_buffer *));
+
+			if (!channel->rd_buffers)
+				goto memfail;
+
+			this_buffer = xilly_malloc(
+				mem,
+				bufnum * sizeof(struct xilly_buffer));
+
+			if (!this_buffer)
+				goto memfail;
+		}
+
+		else if (channelnum > 0) {
+			channel->num_wr_buffers = bufnum;
+			channel->log2_element_size = ((format > 2) ?
+						      2 : format);
+			bytebufsize = channel->wr_buf_size = bufsize *
+				(1 << channel->log2_element_size);
+
+			channel->seekable = seekable;
+			channel->wr_supports_nonempty = supports_nonempty;
+
+			channel->wr_allow_partial = allowpartial;
+			channel->wr_synchronous = synchronous;
+			channel->wr_exclusive_open = exclusive_open;
+
+			channel->wr_buffers = xilly_malloc(
+				mem,
+				bufnum * sizeof(struct xilly_buffer *));
+
+			if (!channel->wr_buffers)
+				goto memfail;
+
+			this_buffer = xilly_malloc(
+				mem,
+				bufnum * sizeof(struct xilly_buffer));
+
+			if (!this_buffer)
+				goto memfail;
+		}
+
+		/*
+		 * Although daunting, we cut the chunks for read buffers
+		 * from a different salami than the write buffers',
+		 * possibly improving performance.
+		 */
+
+		if (is_writebuf)
+			for (i = 0; i < bufnum; i++) {
+				/*
+				 * Buffers are expected in descending
+				 * byte-size order, so there is either
+				 * enough for this buffer or none at all.
+				 */
+				if ((left_of_wr_salami < bytebufsize) &&
+				    (left_of_wr_salami > 0)) {
+					pr_err("xillybus: "
+					       "Corrupt buffer allocation "
+					       "in IDT. Aborting.\n");
+					return -ENODEV;
+				}
+
+				if (left_of_wr_salami == 0) {
+					int allocorder, allocsize;
+
+					allocsize = PAGE_SIZE;
+					allocorder = 0;
+					while (bytebufsize > allocsize) {
+						allocsize *= 2;
+						allocorder++;
+					}
+
+					wr_salami = (void *)
+						xilly_pagealloc(mem,
+								allocorder);
+					if (!wr_salami)
+						goto memfail;
+					left_of_wr_salami = allocsize;
+				}
+
+				dma_addr = xilly_map_single(
+					mem,
+					ep,
+					wr_salami,
+					bytebufsize,
+					DMA_FROM_DEVICE);
+
+				if (!dma_addr)
+					goto dmafail;
+
+				iowrite32(
+					(u32) (dma_addr & 0xffffffff),
+					&ep->registers[
+						fpga_dma_bufaddr_lowaddr_reg]
+					);
+				iowrite32(
+					((u32) ((((u64) dma_addr) >> 32)
+						& 0xffffffff)),
+					&ep->registers[
+						fpga_dma_bufaddr_highaddr_reg]
+					);
+				mmiowb();
+
+				if (channelnum > 0) {
+					this_buffer->addr = wr_salami;
+					this_buffer->dma_addr = dma_addr;
+					channel->wr_buffers[i] = this_buffer++;
+
+					iowrite32(
+						0x80000000 | wr_nbuffer++,
+						&ep->registers[
+							fpga_dma_bufno_reg]);
+				} else {
+					ep->msgbuf_addr = wr_salami;
+					ep->msgbuf_dma_addr = dma_addr;
+					ep->msg_buf_size = bytebufsize;
+					msg_buf_done++;
+
+					iowrite32(
+						0x80000000, &ep->registers[
+							fpga_dma_bufno_reg]);
+				}
+
+				left_of_wr_salami -= bytebufsize;
+				wr_salami += bytebufsize;
+			}
+		else /* Read buffers */
+			for (i = 0; i < bufnum; i++) {
+				/*
+				 * Buffers are expected in descending
+				 * byte-size order, so there is either
+				 * enough for this buffer or none at all.
+				 */
+				if ((left_of_rd_salami < bytebufsize) &&
+				    (left_of_rd_salami > 0)) {
+					pr_err("xillybus: "
+					       "Corrupt buffer allocation "
+					       "in IDT. Aborting.\n");
+					return -ENODEV;
+				}
+
+				if (left_of_rd_salami == 0) {
+					int allocorder, allocsize;
+
+					allocsize = PAGE_SIZE;
+					allocorder = 0;
+					while (bytebufsize > allocsize) {
+						allocsize *= 2;
+						allocorder++;
+					}
+
+					rd_salami = (void *)
+						xilly_pagealloc(
+							mem,
+							allocorder);
+
+					if (!rd_salami)
+						goto memfail;
+					left_of_rd_salami = allocsize;
+				}
+
+				dma_addr = xilly_map_single(
+					mem,
+					ep,
+					rd_salami,
+					bytebufsize,
+					DMA_TO_DEVICE);
+
+				if (!dma_addr)
+					goto dmafail;
+
+				iowrite32(
+					(u32) (dma_addr & 0xffffffff),
+					&ep->registers[
+						fpga_dma_bufaddr_lowaddr_reg]
+					);
+				iowrite32(
+					((u32) ((((u64) dma_addr) >> 32)
+						& 0xffffffff)),
+					&ep->registers[
+						fpga_dma_bufaddr_highaddr_reg]
+					);
+				mmiowb();
+
+				this_buffer->addr = rd_salami;
+				this_buffer->dma_addr = dma_addr;
+				channel->rd_buffers[i] = this_buffer++;
+
+				iowrite32(rd_nbuffer++,
+					  &ep->registers[fpga_dma_bufno_reg]);
+
+				left_of_rd_salami -= bytebufsize;
+				rd_salami += bytebufsize;
+			}
+	}
+
+	if (!msg_buf_done) {
+		pr_err("xillybus: Corrupt IDT: No message buffer. "
+		       "Aborting.\n");
+		return -ENODEV;
+	}
+
+	return 0;
+
+memfail:
+	pr_err("xillybus: Failed to allocate write buffer memory. "
+	       "Aborting.\n");
+	return -ENOMEM;
+dmafail:
+	pr_err("xillybus: Failed to map DMA memory!. Aborting.\n");
+	return -ENOMEM;
+}
+
+static void xilly_scan_idt(struct xilly_endpoint *endpoint,
+			   struct xilly_idt_handle *idt_handle)
+{
+	int count = 0;
+	unsigned char *idt = endpoint->channels[1]->wr_buffers[0]->addr;
+	unsigned char *end_of_idt = idt + endpoint->idtlen - 4;
+	unsigned char *scan;
+	int len;
+
+	scan = idt;
+	idt_handle->idt = idt;
+
+	scan++; /* Skip version number */
+
+	while ((scan <= end_of_idt) && *scan) {
+		while ((scan <= end_of_idt) && *scan++)
+			/* Do nothing, just scan thru string */ ;
+		count++;
+	}
+
+	scan++;
+
+	if (scan > end_of_idt) {
+		pr_err("xillybus: IDT device name list overflow. "
+		       "Aborting.\n");
+		idt_handle->chandesc = NULL;
+		return;
+	} else
+		idt_handle->chandesc = scan;
+
+	len = endpoint->idtlen - (3 + ((int) (scan - idt)));
+
+	if (len & 0x03) {
+		idt_handle->chandesc = NULL;
+
+		pr_err("xillybus: Corrupt IDT device name list. "
+		       "Aborting.\n");
+	}
+
+	idt_handle->entries = len >> 2;
+
+	endpoint->num_channels = count;
+}
+
+static int xilly_obtain_idt(struct xilly_endpoint *endpoint)
+{
+	int rc = 0;
+	struct xilly_channel *channel;
+	unsigned char *version;
+
+	channel = endpoint->channels[1]; /* This should be generated ad-hoc */
+
+	channel->wr_sleepy = 1;
+	wmb(); /* Setting wr_sleepy must come before the command */
+
+	iowrite32(1 | /* Write channel 0 = IDT */
+		   (3 << 24), /* Opcode 3 for channel 0 = Send IDT */
+		   &endpoint->registers[fpga_buf_ctrl_reg]);
+	mmiowb(); /* Just to appear safe */
+
+	wait_event_interruptible_timeout(channel->wr_wait,
+					 (!channel->wr_sleepy),
+					 XILLY_TIMEOUT);
+
+	if (channel->wr_sleepy) {
+		pr_err("xillybus: Failed to obtain IDT. Aborting.\n");
+
+		if (endpoint->fatal_error)
+			return -EIO;
+
+		rc = -ENODEV;
+		return rc;
+	}
+
+	xilly_dma_sync_single_for_cpu(channel->endpoint,
+				      channel->wr_buffers[0]->dma_addr,
+				      channel->wr_buf_size,
+				      DMA_FROM_DEVICE);
+
+	if (channel->wr_buffers[0]->end_offset != endpoint->idtlen) {
+		pr_err("xillybus: IDT length mismatch (%d != %d). "
+		       "Aborting.\n",
+		       channel->wr_buffers[0]->end_offset, endpoint->idtlen);
+		rc = -ENODEV;
+		return rc;
+	}
+
+	if (crc32_le(~0, channel->wr_buffers[0]->addr,
+		     endpoint->idtlen+1) != 0) {
+		pr_err("xillybus: IDT failed CRC check. Aborting.\n");
+		rc = -ENODEV;
+		return rc;
+	}
+
+	version = channel->wr_buffers[0]->addr;
+
+	/* Check version number. Accept anything below 0x82 for now. */
+	if (*version > 0x82) {
+		pr_err("xillybus: No support for IDT version 0x%02x. "
+		       "Maybe the xillybus driver needs an upgarde. "
+		       "Aborting.\n",
+		       (int) *version);
+		rc = -ENODEV;
+		return rc;
+	}
+
+	return 0; /* Success */
+}
+
+static ssize_t xillybus_read(struct file *filp, char *userbuf, size_t count,
+			     loff_t *f_pos)
+{
+	ssize_t rc;
+	unsigned long flags;
+	int bytes_done = 0;
+	int no_time_left = 0;
+	long deadline, left_to_sleep;
+	struct xilly_channel *channel = filp->private_data;
+
+	int empty, reached_eof, exhausted, ready;
+	/* Initializations are there only to silence warnings */
+
+	int howmany = 0, bufpos = 0, bufidx = 0, bufferdone = 0;
+	int waiting_bufidx;
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	deadline = jiffies + 1 + XILLY_RX_TIMEOUT;
+
+	rc = mutex_lock_interruptible(&channel->wr_mutex);
+
+	if (rc)
+		return rc;
+
+	rc = 0; /* Just to be clear about it. Compiler optimizes this out */
+
+	while (1) { /* Note that we may drop mutex within this loop */
+		int bytes_to_do = count - bytes_done;
+		spin_lock_irqsave(&channel->wr_spinlock, flags);
+
+		empty = channel->wr_empty;
+		ready = !empty || channel->wr_ready;
+
+		if (!empty) {
+			bufidx = channel->wr_host_buf_idx;
+			bufpos = channel->wr_host_buf_pos;
+			howmany = ((channel->wr_buffers[bufidx]->end_offset
+				    + 1) << channel->log2_element_size)
+				- bufpos;
+
+			/* Update wr_host_* to its post-operation state */
+			if (howmany > bytes_to_do) {
+				bufferdone = 0;
+
+				howmany = bytes_to_do;
+				channel->wr_host_buf_pos += howmany;
+			} else {
+				bufferdone = 1;
+
+				channel->wr_host_buf_pos = 0;
+
+				if (bufidx == channel->wr_fpga_buf_idx) {
+					channel->wr_empty = 1;
+					channel->wr_sleepy = 1;
+					channel->wr_ready = 0;
+				}
+
+				if (bufidx >= (channel->num_wr_buffers - 1))
+					channel->wr_host_buf_idx = 0;
+				else
+					channel->wr_host_buf_idx++;
+			}
+		}
+
+		/*
+		 * Marking our situation after the possible changes above,
+		 * for use after releasing the spinlock.
+		 *
+		 * empty = empty before change
+		 * exhasted = empty after possible change
+		 */
+
+		reached_eof = channel->wr_empty &&
+			(channel->wr_host_buf_idx == channel->wr_eof);
+		channel->wr_hangup = reached_eof;
+		exhausted = channel->wr_empty;
+		waiting_bufidx = channel->wr_host_buf_idx;
+
+		spin_unlock_irqrestore(&channel->wr_spinlock, flags);
+
+		if (!empty) { /* Go on, now without the spinlock */
+
+			if (bufpos == 0) /* Position zero means it's virgin */
+				xilly_dma_sync_single_for_cpu(
+					channel->endpoint,
+					channel->wr_buffers[bufidx]->dma_addr,
+					channel->wr_buf_size,
+					DMA_FROM_DEVICE);
+
+			if (copy_to_user(
+				    userbuf,
+				    channel->wr_buffers[bufidx]->addr
+				    + bufpos, howmany))
+				rc = -EFAULT;
+
+			userbuf += howmany;
+			bytes_done += howmany;
+
+			if (bufferdone) {
+				xilly_dma_sync_single_for_device(
+					channel->endpoint,
+					channel->wr_buffers[bufidx]->dma_addr,
+					channel->wr_buf_size,
+					DMA_FROM_DEVICE);
+
+				/*
+				 * Tell FPGA the buffer is done with. It's an
+				 * atomic operation to the FPGA, so what
+				 * happens with other channels doesn't matter,
+				 * and the certain channel is protected with
+				 * the channel-specific mutex.
+				 */
+
+				iowrite32(1 | (channel->chan_num << 1)
+					   | (bufidx << 12),
+					   &channel->endpoint->registers[
+						   fpga_buf_ctrl_reg]);
+				mmiowb(); /* Just to appear safe */
+			}
+
+			if (rc) {
+				mutex_unlock(&channel->wr_mutex);
+				return rc;
+			}
+		}
+
+		/* This includes a zero-count return = EOF */
+		if ((bytes_done >= count) || reached_eof)
+			break;
+
+		if (!exhausted)
+			continue; /* More in RAM buffer(s)? Just go on. */
+
+		if ((bytes_done > 0) &&
+		    (no_time_left ||
+		     (channel->wr_synchronous && channel->wr_allow_partial)))
+			break;
+
+		/*
+		 * Nonblocking read: The "ready" flag tells us that the FPGA
+		 * has data to send. In non-blocking mode, if it isn't on,
+		 * just return. But if there is, we jump directly to the point
+		 * where we ask for the FPGA to send all it has, and wait
+		 * until that data arrives. So in a sense, we *do* block in
+		 * nonblocking mode, but only for a very short time.
+		 */
+
+		if (!no_time_left && (filp->f_flags & O_NONBLOCK)) {
+			if (bytes_done > 0)
+				break;
+
+			if (ready)
+				goto desperate;
+
+			bytes_done = -EAGAIN;
+			break;
+		}
+
+		if (!no_time_left || (bytes_done > 0)) {
+			/*
+			 * Note that in case of an element-misaligned read
+			 * request, offsetlimit will include the last element,
+			 * which will be partially read from.
+			 */
+			int offsetlimit = ((count - bytes_done) - 1) >>
+				channel->log2_element_size;
+			int buf_elements = channel->wr_buf_size >>
+				channel->log2_element_size;
+
+			/*
+			 * In synchronous mode, always send an offset limit.
+			 * Just don't send a value too big.
+			 */
+
+			if (channel->wr_synchronous) {
+				/* Don't request more than one buffer */
+				if (channel->wr_allow_partial &&
+				    (offsetlimit >= buf_elements))
+					offsetlimit = buf_elements - 1;
+
+				/* Don't request more than all buffers */
+				if (!channel->wr_allow_partial &&
+				    (offsetlimit >=
+				     (buf_elements * channel->num_wr_buffers)))
+					offsetlimit = buf_elements *
+						channel->num_wr_buffers - 1;
+			}
+
+			/*
+			 * In asynchronous mode, force early flush of a buffer
+			 * only if that will allow returning a full count. The
+			 * "offsetlimit < ( ... )" rather than "<=" excludes
+			 * requesting a full buffer, which would obviously
+			 * cause a buffer transmission anyhow
+			 */
+
+			if (channel->wr_synchronous ||
+			    (offsetlimit < (buf_elements - 1))) {
+
+				mutex_lock(&channel->endpoint->register_mutex);
+
+				iowrite32(offsetlimit,
+					  &channel->endpoint->registers[
+						  fpga_buf_offset_reg]);
+				mmiowb();
+
+				iowrite32(1 | (channel->chan_num << 1) |
+					   (2 << 24) |  /* 2 = offset limit */
+					   (waiting_bufidx << 12),
+					   &channel->endpoint->registers[
+						   fpga_buf_ctrl_reg]);
+
+				mmiowb(); /* Just to appear safe */
+
+				mutex_unlock(&channel->endpoint->
+					     register_mutex);
+			}
+
+		}
+
+		/*
+		 * If partial completion is disallowed, there is no point in
+		 * timeout sleeping. Neither if no_time_left is set and
+		 * there's no data.
+		 */
+
+		if (!channel->wr_allow_partial ||
+		    (no_time_left && (bytes_done == 0))) {
+
+			/*
+			 * This do-loop will run more than once if another
+			 * thread reasserted wr_sleepy before we got the mutex
+			 * back, so we try again.
+			 */
+
+			do {
+				mutex_unlock(&channel->wr_mutex);
+
+				if (wait_event_interruptible(
+					    channel->wr_wait,
+					    (!channel->wr_sleepy)))
+					goto interrupted;
+
+				if (mutex_lock_interruptible(
+					    &channel->wr_mutex))
+					goto interrupted;
+			} while (channel->wr_sleepy);
+
+			continue;
+
+interrupted: /* Mutex is not held if got here */
+			if (channel->endpoint->fatal_error)
+				return -EIO;
+			if (bytes_done)
+				return bytes_done;
+			if (filp->f_flags & O_NONBLOCK)
+				return -EAGAIN; /* Don't admit snoozing */
+			return -EINTR;
+		}
+
+		left_to_sleep = deadline - ((long) jiffies);
+
+		/*
+		 * If our time is out, skip the waiting. We may miss wr_sleepy
+		 * being deasserted but hey, almost missing the train is like
+		 * missing it.
+		 */
+
+		if (left_to_sleep > 0) {
+			left_to_sleep =
+				wait_event_interruptible_timeout(
+					channel->wr_wait,
+					(!channel->wr_sleepy),
+					left_to_sleep);
+
+			if (!channel->wr_sleepy)
+				continue;
+
+			if (left_to_sleep < 0) { /* Interrupt */
+				mutex_unlock(&channel->wr_mutex);
+				if (channel->endpoint->fatal_error)
+					return -EIO;
+				if (bytes_done)
+					return bytes_done;
+				return -EINTR;
+			}
+		}
+
+desperate:
+		no_time_left = 1; /* We're out of sleeping time. Desperate! */
+
+		if (bytes_done == 0) {
+			/*
+			 * Reaching here means that we allow partial return,
+			 * that we've run out of time, and that we have
+			 * nothing to return.
+			 * So tell the FPGA to send anything it has or gets.
+			 */
+
+			iowrite32(1 | (channel->chan_num << 1) |
+				   (3 << 24) |  /* Opcode 3, flush it all! */
+				   (waiting_bufidx << 12),
+				   &channel->endpoint->registers[
+					   fpga_buf_ctrl_reg]);
+			mmiowb(); /* Just to appear safe */
+		}
+
+		/*
+		 * Formally speaking, we should block for data at this point.
+		 * But to keep the code cleaner, we'll just finish the loop,
+		 * make the unlikely check for data, and then block at the
+		 * usual place.
+		 */
+	}
+
+	mutex_unlock(&channel->wr_mutex);
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	return bytes_done;
+}
+
+
+
+/*
+ * The timeout argument takes values as follows:
+ *  >0 : Flush with timeout
+ * ==0 : Flush, and wait idefinitely for the flush to complete
+ *  <0 : Autoflush: Flush only if there's a single buffer occupied
+ */
+
+static int xillybus_myflush(struct xilly_channel *channel, long timeout)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	int end_offset_plus1;
+	int bufidx, bufidx_minus1;
+	int i;
+	int empty;
+	int new_rd_host_buf_pos;
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+	rc = mutex_lock_interruptible(&channel->rd_mutex);
+
+	if (rc)
+		return rc;
+
+	/*
+	 * Don't flush a closed channel. This can happen when the work queued
+	 * autoflush thread fires off after the file has closed. This is not
+	 * an error, just something to dismiss.
+	 */
+
+	if (!channel->rd_ref_count)
+		goto done;
+
+	bufidx = channel->rd_host_buf_idx;
+
+	bufidx_minus1 = (bufidx == 0) ? channel->num_rd_buffers - 1 : bufidx-1;
+
+	end_offset_plus1 = channel->rd_host_buf_pos >>
+		channel->log2_element_size;
+
+	new_rd_host_buf_pos = channel->rd_host_buf_pos -
+		(end_offset_plus1 << channel->log2_element_size);
+
+	/* Submit the current buffer if it's nonempty */
+	if (end_offset_plus1) {
+		unsigned char *tail = channel->rd_buffers[bufidx]->addr +
+			(end_offset_plus1 << channel->log2_element_size);
+
+		/* Copy  unflushed data, so we can put it in next buffer */
+		for (i = 0; i < new_rd_host_buf_pos; i++)
+			channel->rd_leftovers[i] = *tail++;
+
+		spin_lock_irqsave(&channel->rd_spinlock, flags);
+
+		/* Autoflush only if a single buffer is occupied */
+
+		if ((timeout < 0) &&
+		    (channel->rd_full ||
+		     (bufidx_minus1 != channel->rd_fpga_buf_idx))) {
+			spin_unlock_irqrestore(&channel->rd_spinlock, flags);
+			/*
+			 * A new work item may be queued by the ISR exactly
+			 * now, since the execution of a work item allows the
+			 * queuing of a new one while it's running.
+			 */
+			goto done;
+		}
+
+		/* The 4th element is never needed for data, so it's a flag */
+		channel->rd_leftovers[3] = (new_rd_host_buf_pos != 0);
+
+		/* Set up rd_full to reflect a certain moment's state */
+
+		if (bufidx == channel->rd_fpga_buf_idx)
+			channel->rd_full = 1;
+		spin_unlock_irqrestore(&channel->rd_spinlock, flags);
+
+		if (bufidx >= (channel->num_rd_buffers - 1))
+			channel->rd_host_buf_idx = 0;
+		else
+			channel->rd_host_buf_idx++;
+
+		xilly_dma_sync_single_for_device(
+			channel->endpoint,
+			channel->rd_buffers[bufidx]->dma_addr,
+			channel->rd_buf_size,
+			DMA_TO_DEVICE);
+
+		mutex_lock(&channel->endpoint->register_mutex);
+
+		iowrite32(end_offset_plus1 - 1,
+			  &channel->endpoint->registers[fpga_buf_offset_reg]);
+		mmiowb();
+
+		iowrite32((channel->chan_num << 1) | /* Channel ID */
+			   (2 << 24) |  /* Opcode 2, submit buffer */
+			   (bufidx << 12),
+			   &channel->endpoint->registers[fpga_buf_ctrl_reg]);
+		mmiowb(); /* Just to appear safe */
+
+		mutex_unlock(&channel->endpoint->register_mutex);
+	} else if (bufidx == 0)
+		bufidx = channel->num_rd_buffers - 1;
+	else
+		bufidx--;
+
+	channel->rd_host_buf_pos = new_rd_host_buf_pos;
+
+	if (timeout < 0)
+		goto done; /* Autoflush */
+
+
+	/*
+	 * bufidx is now the last buffer written to (or equal to
+	 * rd_fpga_buf_idx if buffer was never written to), and
+	 * channel->rd_host_buf_idx the one after it.
+	 *
+	 * If bufidx == channel->rd_fpga_buf_idx we're either empty or full.
+	 */
+
+	rc = 0;
+
+	while (1) { /* Loop waiting for draining of buffers */
+		spin_lock_irqsave(&channel->rd_spinlock, flags);
+
+		if (bufidx != channel->rd_fpga_buf_idx)
+			channel->rd_full = 1; /*
+					       * Not really full,
+					       * but needs waiting.
+					       */
+
+		empty = !channel->rd_full;
+
+		spin_unlock_irqrestore(&channel->rd_spinlock, flags);
+
+		if (empty)
+			break;
+
+		/*
+		 * Indefinite sleep with mutex taken. With data waiting for
+		 * flushing user should not be surprised if open() for write
+		 * sleeps.
+		 */
+		if (timeout == 0)
+			wait_event_interruptible(channel->rd_wait,
+						 (!channel->rd_full));
+
+		else if (wait_event_interruptible_timeout(
+				 channel->rd_wait,
+				 (!channel->rd_full),
+				 timeout) == 0) {
+			pr_warn("xillybus: "
+				"Timed out while flushing. "
+				"Output data may be lost.\n");
+
+			rc = -ETIMEDOUT;
+			break;
+		}
+
+		if (channel->rd_full) {
+			rc = -EINTR;
+			break;
+		}
+	}
+
+done:
+	mutex_unlock(&channel->rd_mutex);
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	return rc;
+}
+
+static int xillybus_flush(struct file *filp, fl_owner_t id)
+{
+	if (!(filp->f_mode & FMODE_WRITE))
+		return 0;
+
+	return xillybus_myflush(filp->private_data, HZ); /* 1 second timeout */
+}
+
+static void xillybus_autoflush(struct work_struct *work)
+{
+	struct delayed_work *workitem = container_of(
+		work, struct delayed_work, work);
+	struct xilly_channel *channel = container_of(
+		workitem, struct xilly_channel, rd_workitem);
+	int rc;
+
+	rc = xillybus_myflush(channel, -1);
+
+	if (rc == -EINTR)
+		pr_warn("xillybus: Autoflush failed because "
+			"work queue thread got a signal.\n");
+	else if (rc)
+		pr_err("xillybus: Autoflush failed under "
+		       "weird circumstances.\n");
+
+}
+
+static ssize_t xillybus_write(struct file *filp, const char *userbuf,
+			      size_t count, loff_t *f_pos)
+{
+	ssize_t rc;
+	unsigned long flags;
+	int bytes_done = 0;
+	struct xilly_channel *channel = filp->private_data;
+
+	int full, exhausted;
+	/* Initializations are there only to silence warnings */
+
+	int howmany = 0, bufpos = 0, bufidx = 0, bufferdone = 0;
+	int end_offset_plus1 = 0;
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	rc = mutex_lock_interruptible(&channel->rd_mutex);
+
+	if (rc)
+		return rc;
+
+	rc = 0; /* Just to be clear about it. Compiler optimizes this out */
+
+	while (1) {
+		int bytes_to_do = count - bytes_done;
+
+		spin_lock_irqsave(&channel->rd_spinlock, flags);
+
+		full = channel->rd_full;
+
+		if (!full) {
+			bufidx = channel->rd_host_buf_idx;
+			bufpos = channel->rd_host_buf_pos;
+			howmany = channel->rd_buf_size - bufpos;
+
+			/*
+			 * Update rd_host_* to its state after this operation.
+			 * count=0 means committing the buffer immediately,
+			 * which is like flushing, but not necessarily block.
+			 */
+
+			if ((howmany > bytes_to_do) &&
+			    (count ||
+			     ((bufpos >> channel->log2_element_size) == 0))) {
+				bufferdone = 0;
+
+				howmany = bytes_to_do;
+				channel->rd_host_buf_pos += howmany;
+			} else {
+				bufferdone = 1;
+
+				if (count) {
+					end_offset_plus1 =
+						channel->rd_buf_size >>
+						channel->log2_element_size;
+					channel->rd_host_buf_pos = 0;
+				} else {
+					unsigned char *tail;
+					int i;
+
+					end_offset_plus1 = bufpos >>
+						channel->log2_element_size;
+
+					channel->rd_host_buf_pos -=
+						end_offset_plus1 <<
+						channel->log2_element_size;
+
+					tail = channel->
+						rd_buffers[bufidx]->addr +
+						(end_offset_plus1 <<
+						 channel->log2_element_size);
+
+					for (i = 0;
+					     i < channel->rd_host_buf_pos;
+					     i++)
+						channel->rd_leftovers[i] =
+							*tail++;
+				}
+
+				if (bufidx == channel->rd_fpga_buf_idx)
+					channel->rd_full = 1;
+
+				if (bufidx >= (channel->num_rd_buffers - 1))
+					channel->rd_host_buf_idx = 0;
+				else
+					channel->rd_host_buf_idx++;
+			}
+		}
+
+		/*
+		 * Marking our situation after the possible changes above,
+		 * for use  after releasing the spinlock.
+		 *
+		 * full = full before change
+		 * exhasted = full after possible change
+		 */
+
+		exhausted = channel->rd_full;
+
+		spin_unlock_irqrestore(&channel->rd_spinlock, flags);
+
+		if (!full) { /* Go on, now without the spinlock */
+			unsigned char *head =
+				channel->rd_buffers[bufidx]->addr;
+			int i;
+
+			if ((bufpos == 0) || /* Zero means it's virgin */
+			    (channel->rd_leftovers[3] != 0)) {
+				xilly_dma_sync_single_for_cpu(
+					channel->endpoint,
+					channel->rd_buffers[bufidx]->dma_addr,
+					channel->rd_buf_size,
+					DMA_TO_DEVICE);
+
+				/* Virgin, but leftovers are due */
+				for (i = 0; i < bufpos; i++)
+					*head++ = channel->rd_leftovers[i];
+
+				channel->rd_leftovers[3] = 0; /* Clear flag */
+			}
+
+			if (copy_from_user(
+				    channel->rd_buffers[bufidx]->addr + bufpos,
+				    userbuf, howmany))
+				rc = -EFAULT;
+
+			userbuf += howmany;
+			bytes_done += howmany;
+
+			if (bufferdone) {
+				xilly_dma_sync_single_for_device(
+					channel->endpoint,
+					channel->rd_buffers[bufidx]->dma_addr,
+					channel->rd_buf_size,
+					DMA_TO_DEVICE);
+
+				mutex_lock(&channel->endpoint->register_mutex);
+
+				iowrite32(end_offset_plus1 - 1,
+					  &channel->endpoint->registers[
+						  fpga_buf_offset_reg]);
+				mmiowb();
+				iowrite32((channel->chan_num << 1) |
+					   (2 << 24) |  /* 2 = submit buffer */
+					   (bufidx << 12),
+					   &channel->endpoint->registers[
+						   fpga_buf_ctrl_reg]);
+				mmiowb(); /* Just to appear safe */
+
+				mutex_unlock(&channel->endpoint->
+					     register_mutex);
+
+				channel->rd_leftovers[3] =
+					(channel->rd_host_buf_pos != 0);
+			}
+
+			if (rc) {
+				mutex_unlock(&channel->rd_mutex);
+
+				if (channel->endpoint->fatal_error)
+					return -EIO;
+
+				if (!channel->rd_synchronous)
+					queue_delayed_work(
+						xillybus_wq,
+						&channel->rd_workitem,
+						XILLY_RX_TIMEOUT);
+
+				return rc;
+			}
+		}
+
+		if (bytes_done >= count)
+			break;
+
+		if (!exhausted)
+			continue; /* If there's more space, just go on */
+
+		if ((bytes_done > 0) && channel->rd_allow_partial)
+			break;
+
+		/*
+		 * Indefinite sleep with mutex taken. With data waiting for
+		 * flushing, user should not be surprised if open() for write
+		 * sleeps.
+		 */
+
+		if (filp->f_flags & O_NONBLOCK) {
+			bytes_done = -EAGAIN;
+			break;
+		}
+
+		wait_event_interruptible(channel->rd_wait,
+					 (!channel->rd_full));
+
+		if (channel->rd_full) {
+			mutex_unlock(&channel->rd_mutex);
+
+			if (channel->endpoint->fatal_error)
+				return -EIO;
+
+			if (bytes_done)
+				return bytes_done;
+			return -EINTR;
+		}
+	}
+
+	mutex_unlock(&channel->rd_mutex);
+
+	if (!channel->rd_synchronous)
+		queue_delayed_work(xillybus_wq,
+				   &channel->rd_workitem,
+				   XILLY_RX_TIMEOUT);
+
+	if ((channel->rd_synchronous) && (bytes_done > 0)) {
+		rc = xillybus_myflush(filp->private_data, 0); /* No timeout */
+
+		if (rc && (rc != -EINTR))
+			return rc;
+	}
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	return bytes_done;
+}
+
+static int xillybus_open(struct inode *inode, struct file *filp)
+{
+	int rc = 0;
+	unsigned long flags;
+	int minor = iminor(inode);
+	int major = imajor(inode);
+	struct xilly_endpoint *ep_iter, *endpoint = NULL;
+	struct xilly_channel *channel;
+
+	mutex_lock(&ep_list_lock);
+
+	list_for_each_entry(ep_iter, &list_of_endpoints, ep_list) {
+		if ((ep_iter->major == major) &&
+		    (minor >= ep_iter->lowest_minor) &&
+		    (minor < (ep_iter->lowest_minor +
+			      ep_iter->num_channels))) {
+			endpoint = ep_iter;
+			break;
+		}
+	}
+	mutex_unlock(&ep_list_lock);
+
+	if (!endpoint) {
+		pr_err("xillybus: open() failed to find a device "
+		       "for major=%d and minor=%d\n", major, minor);
+		return -ENODEV;
+	}
+
+	if (endpoint->fatal_error)
+		return -EIO;
+
+	channel = endpoint->channels[1 + minor - endpoint->lowest_minor];
+	filp->private_data = channel;
+
+
+	/*
+	 * It gets complicated because:
+	 * 1. We don't want to take a mutex we don't have to
+	 * 2. We don't want to open one direction if the other will fail.
+	 */
+
+	if ((filp->f_mode & FMODE_READ) && (!channel->num_wr_buffers))
+		return -ENODEV;
+
+	if ((filp->f_mode & FMODE_WRITE) && (!channel->num_rd_buffers))
+		return -ENODEV;
+
+	if ((filp->f_mode & FMODE_READ) && (filp->f_flags & O_NONBLOCK) &&
+	    (channel->wr_synchronous || !channel->wr_allow_partial ||
+	     !channel->wr_supports_nonempty)) {
+		pr_err("xillybus: open() failed: "
+		       "O_NONBLOCK not allowed for read on this device\n");
+		return -ENODEV;
+	}
+
+	if ((filp->f_mode & FMODE_WRITE) && (filp->f_flags & O_NONBLOCK) &&
+	    (channel->rd_synchronous || !channel->rd_allow_partial)) {
+		pr_err("xillybus: open() failed: "
+		       "O_NONBLOCK not allowed for write on this device\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * Note: open() may block on getting mutexes despite O_NONBLOCK.
+	 * This shouldn't occur normally, since multiple open of the same
+	 * file descriptor is alsmost always prohibited anyhow
+	 * (*_exclusive_open is normally set in real-life systems).
+	 */
+
+	if (filp->f_mode & FMODE_READ) {
+		rc = mutex_lock_interruptible(&channel->wr_mutex);
+		if (rc)
+			return rc;
+	}
+
+	if (filp->f_mode & FMODE_WRITE) {
+		rc = mutex_lock_interruptible(&channel->rd_mutex);
+		if (rc)
+			goto unlock_wr;
+	}
+
+	if ((filp->f_mode & FMODE_READ) &&
+	    (channel->wr_ref_count != 0) &&
+	    (channel->wr_exclusive_open)) {
+		rc = -EBUSY;
+		goto unlock;
+	}
+
+	if ((filp->f_mode & FMODE_WRITE) &&
+	    (channel->rd_ref_count != 0) &&
+	    (channel->rd_exclusive_open)) {
+		rc = -EBUSY;
+		goto unlock;
+	}
+
+
+	if (filp->f_mode & FMODE_READ) {
+		if (channel->wr_ref_count == 0) { /* First open of file */
+			/* Move the host to first buffer */
+			spin_lock_irqsave(&channel->wr_spinlock, flags);
+			channel->wr_host_buf_idx = 0;
+			channel->wr_host_buf_pos = 0;
+			channel->wr_fpga_buf_idx = -1;
+			channel->wr_empty = 1;
+			channel->wr_ready = 0;
+			channel->wr_sleepy = 1;
+			channel->wr_eof = -1;
+			channel->wr_hangup = 0;
+
+			spin_unlock_irqrestore(&channel->wr_spinlock, flags);
+
+			iowrite32(1 | (channel->chan_num << 1) |
+				  (4 << 24) |  /* Opcode 4, open channel */
+				  ((channel->wr_synchronous & 1) << 23),
+				  &channel->endpoint->registers[
+					  fpga_buf_ctrl_reg]);
+			mmiowb(); /* Just to appear safe */
+		}
+
+		channel->wr_ref_count++;
+	}
+
+	if (filp->f_mode & FMODE_WRITE) {
+		if (channel->rd_ref_count == 0) { /* First open of file */
+			/* Move the host to first buffer */
+			spin_lock_irqsave(&channel->rd_spinlock, flags);
+			channel->rd_host_buf_idx = 0;
+			channel->rd_host_buf_pos = 0;
+			channel->rd_leftovers[3] = 0; /* No leftovers. */
+			channel->rd_fpga_buf_idx = channel->num_rd_buffers - 1;
+			channel->rd_full = 0;
+
+			spin_unlock_irqrestore(&channel->rd_spinlock, flags);
+
+			iowrite32((channel->chan_num << 1) |
+				  (4 << 24),   /* Opcode 4, open channel */
+				  &channel->endpoint->registers[
+					  fpga_buf_ctrl_reg]);
+			mmiowb(); /* Just to appear safe */
+		}
+
+		channel->rd_ref_count++;
+	}
+
+unlock:
+	if (filp->f_mode & FMODE_WRITE)
+		mutex_unlock(&channel->rd_mutex);
+unlock_wr:
+	if (filp->f_mode & FMODE_READ)
+		mutex_unlock(&channel->wr_mutex);
+
+	if (!rc && (!channel->seekable))
+		return nonseekable_open(inode, filp);
+
+	return rc;
+}
+
+static int xillybus_release(struct inode *inode, struct file *filp)
+{
+	int rc;
+	unsigned long flags;
+	struct xilly_channel *channel = filp->private_data;
+
+	int buf_idx;
+	int eof;
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	if (filp->f_mode & FMODE_WRITE) {
+		rc = mutex_lock_interruptible(&channel->rd_mutex);
+
+		if (rc) {
+			pr_warn("xillybus: Failed to close file. "
+				"Hardware left in messy state.\n");
+			return rc;
+		}
+
+		channel->rd_ref_count--;
+
+		if (channel->rd_ref_count == 0) {
+
+			/*
+			 * We rely on the kernel calling flush()
+			 * before we get here.
+			 */
+
+			iowrite32((channel->chan_num << 1) | /* Channel ID */
+				  (5 << 24),  /* Opcode 5, close channel */
+				  &channel->endpoint->registers[
+					  fpga_buf_ctrl_reg]);
+			mmiowb(); /* Just to appear safe */
+		}
+		mutex_unlock(&channel->rd_mutex);
+	}
+
+	if (filp->f_mode & FMODE_READ) {
+		rc = mutex_lock_interruptible(&channel->wr_mutex);
+		if (rc) {
+			pr_warn("xillybus: Failed to close file. "
+				"Hardware left in messy state.\n");
+			return rc;
+		}
+
+		channel->wr_ref_count--;
+
+		if (channel->wr_ref_count == 0) {
+
+			iowrite32(1 | (channel->chan_num << 1) |
+				   (5 << 24),  /* Opcode 5, close channel */
+				   &channel->endpoint->registers[
+					   fpga_buf_ctrl_reg]);
+			mmiowb(); /* Just to appear safe */
+
+			/*
+			 * This is crazily cautious: We make sure that not
+			 * only that we got an EOF (be it because we closed
+			 * the channel or because of a user's EOF), but verify
+			 * that it's one beyond the last buffer arrived, so
+			 * we have no leftover buffers pending before wrapping
+			 * up (which can only happen in asynchronous channels,
+			 * BTW)
+			 */
+
+			while (1) {
+				spin_lock_irqsave(&channel->wr_spinlock,
+						  flags);
+				buf_idx = channel->wr_fpga_buf_idx;
+				eof = channel->wr_eof;
+				channel->wr_sleepy = 1;
+				spin_unlock_irqrestore(&channel->wr_spinlock,
+						       flags);
+
+				/*
+				 * Check if eof points at the buffer after
+				 * the last one the FPGA submitted. Note that
+				 * no EOF is marked by negative eof.
+				 */
+
+				buf_idx++;
+				if (buf_idx == channel->num_wr_buffers)
+					buf_idx = 0;
+
+				if (buf_idx == eof)
+					break;
+
+				/*
+				 * Steal extra 100 ms if awaken by interrupt.
+				 * This is a simple workaround for an
+				 * interrupt pending when entering, which would
+				 * otherwise result in declaring the hardware
+				 * non-responsive.
+				 */
+
+				if (wait_event_interruptible(
+					    channel->wr_wait,
+					    (!channel->wr_sleepy)))
+					msleep(100);
+
+				if (channel->wr_sleepy) {
+					mutex_unlock(&channel->wr_mutex);
+					pr_warn("xillybus: Hardware failed to "
+						"respond to close command, "
+						"therefore left in "
+						"messy state.\n");
+					return -EINTR;
+				}
+			}
+		}
+
+		mutex_unlock(&channel->wr_mutex);
+	}
+
+	return 0;
+}
+loff_t xillybus_llseek(struct file *filp, loff_t offset, int whence)
+{
+	struct xilly_channel *channel = filp->private_data;
+	loff_t pos = filp->f_pos;
+	int rc = 0;
+
+	/*
+	 * Take both mutexes not allowing interrupts, since it seems like
+	 * common applications don't expect an -EINTR here. Besides, multiple
+	 * access to a single file desriptor on seekable devices is a mess
+	 * anyhow.
+	 */
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	mutex_lock(&channel->wr_mutex);
+	mutex_lock(&channel->rd_mutex);
+
+	switch (whence) {
+	case 0:
+		pos = offset;
+		break;
+	case 1:
+		pos += offset;
+		break;
+	case 2:
+		pos = offset; /* Going to the end => to the beginning */
+		break;
+	default:
+		rc = -EINVAL;
+		goto end;
+	}
+
+	/* In any case, we must finish on an element boundary */
+	if (pos & ((1 << channel->log2_element_size) - 1)) {
+		rc = -EINVAL;
+		goto end;
+	}
+
+	mutex_lock(&channel->endpoint->register_mutex);
+
+	iowrite32(pos >> channel->log2_element_size,
+		  &channel->endpoint->registers[fpga_buf_offset_reg]);
+	mmiowb();
+	iowrite32((channel->chan_num << 1) |
+		  (6 << 24),  /* Opcode 6, set address */
+		  &channel->endpoint->registers[fpga_buf_ctrl_reg]);
+	mmiowb(); /* Just to appear safe */
+
+	mutex_unlock(&channel->endpoint->register_mutex);
+
+end:
+	mutex_unlock(&channel->rd_mutex);
+	mutex_unlock(&channel->wr_mutex);
+
+	if (rc) /* Return error after releasing mutexes */
+		return rc;
+
+	filp->f_pos = pos;
+
+	/*
+	 * Since seekable devices are allowed only when the channel is
+	 * synchronous, we assume that there is no data pending in either
+	 * direction (which holds true as long as no concurrent access on the
+	 * file descriptor takes place).
+	 * The only thing we may need to throw away is leftovers from partial
+	 * write() flush.
+	 */
+
+	channel->rd_leftovers[3] = 0;
+
+	return pos;
+}
+
+static unsigned int xillybus_poll(struct file *filp, poll_table *wait)
+{
+	struct xilly_channel *channel = filp->private_data;
+	unsigned int mask = 0;
+	unsigned long flags;
+
+	poll_wait(filp, &channel->endpoint->ep_wait, wait);
+
+	/*
+	 * poll() won't play ball regarding read() channels which
+	 * aren't asynchronous and support the nonempty message. Allowing
+	 * that will create situations where data has been delivered at
+	 * the FPGA, and users expecting select() to wake up, which it may
+	 * not.
+	 */
+
+	if (!channel->wr_synchronous && channel->wr_supports_nonempty) {
+		poll_wait(filp, &channel->wr_wait, wait);
+		poll_wait(filp, &channel->wr_ready_wait, wait);
+
+		spin_lock_irqsave(&channel->wr_spinlock, flags);
+		if (!channel->wr_empty || channel->wr_ready)
+			mask |= POLLIN | POLLRDNORM;
+
+		if (channel->wr_hangup)
+			/*
+			 * Not POLLHUP, because its behavior is in the
+			 * mist, and POLLIN does what we want: Wake up
+			 * the read file descriptor so it sees EOF.
+			 */
+			mask |=  POLLIN | POLLRDNORM;
+		spin_unlock_irqrestore(&channel->wr_spinlock, flags);
+	}
+
+	/*
+	 * If partial data write is disallowed on a write() channel,
+	 * it's pointless to ever signal OK to write, because is could
+	 * block despite some space being available.
+	 */
+
+	if (channel->rd_allow_partial) {
+		poll_wait(filp, &channel->rd_wait, wait);
+
+		spin_lock_irqsave(&channel->rd_spinlock, flags);
+		if (!channel->rd_full)
+			mask |= POLLOUT | POLLWRNORM;
+		spin_unlock_irqrestore(&channel->rd_spinlock, flags);
+	}
+
+	if (channel->endpoint->fatal_error)
+		mask |= POLLERR;
+
+	return mask;
+}
+
+static const struct file_operations xillybus_fops = {
+	.owner      = THIS_MODULE,
+	.read       = xillybus_read,
+	.write      = xillybus_write,
+	.open       = xillybus_open,
+	.flush      = xillybus_flush,
+	.release    = xillybus_release,
+	.llseek     = xillybus_llseek,
+	.poll       = xillybus_poll,
+};
+
+static int xillybus_init_chrdev(struct xilly_endpoint *endpoint,
+				const unsigned char *idt)
+{
+	int rc;
+	dev_t dev;
+	int devnum, i, minor, major;
+	char devname[48];
+	struct device *device;
+
+	rc = alloc_chrdev_region(&dev, 0, /* minor start */
+				 endpoint->num_channels,
+				 xillyname);
+
+	if (rc) {
+		pr_warn("xillybus: Failed to obtain major/minors");
+		goto error1;
+	}
+
+	endpoint->major = major = MAJOR(dev);
+	endpoint->lowest_minor = minor = MINOR(dev);
+
+	cdev_init(&endpoint->cdev, &xillybus_fops);
+	endpoint->cdev.owner = THIS_MODULE;
+	rc = cdev_add(&endpoint->cdev, MKDEV(major, minor),
+		      endpoint->num_channels);
+	if (rc) {
+		pr_warn("xillybus: Failed to add cdev. Aborting.\n");
+		goto error2;
+	}
+
+	idt++;
+
+	for (i = minor, devnum = 0;
+	     devnum < endpoint->num_channels;
+	     devnum++, i++) {
+		snprintf(devname, sizeof(devname)-1, "xillybus_%s", idt);
+
+		devname[sizeof(devname)-1] = 0; /* Should never matter */
+
+		while (*idt++)
+			/* Skip to next */ ;
+
+		device = device_create(xillybus_class,
+				       NULL,
+				       MKDEV(major, i),
+				       NULL,
+				       devname);
+
+		if (IS_ERR(device)) {
+			pr_warn("xillybus: Failed to create %s "
+				"device. Aborting.\n", devname);
+			goto error3;
+		}
+	}
+
+	pr_info("xillybus: Created %d device files.\n",
+		endpoint->num_channels);
+	return 0; /* succeed */
+
+error3:
+	devnum--; i--;
+	for (; devnum >= 0; devnum--, i--)
+		device_destroy(xillybus_class, MKDEV(major, i));
+
+	cdev_del(&endpoint->cdev);
+error2:
+	unregister_chrdev_region(MKDEV(major, minor), endpoint->num_channels);
+error1:
+
+	return rc;
+}
+
+static void xillybus_cleanup_chrdev(struct xilly_endpoint *endpoint)
+{
+	int minor;
+
+	for (minor = endpoint->lowest_minor;
+	     minor < (endpoint->lowest_minor + endpoint->num_channels);
+	     minor++)
+		device_destroy(xillybus_class, MKDEV(endpoint->major, minor));
+	cdev_del(&endpoint->cdev);
+	unregister_chrdev_region(MKDEV(endpoint->major,
+				       endpoint->lowest_minor),
+				 endpoint->num_channels);
+
+	pr_info("xillybus: Removed %d device files.\n",
+		endpoint->num_channels);
+}
+
+static struct xilly_endpoint *init_endpoint(struct pci_dev *pdev,
+					    struct device *dev)
+{
+	struct xilly_endpoint *endpoint;
+
+	endpoint = kzalloc(sizeof(*endpoint), GFP_KERNEL);
+	if (!endpoint) {
+		pr_err("xillybus: Failed to allocate memory. Aborting.\n");
+		return NULL;
+	}
+
+	endpoint->pdev = pdev;
+	endpoint->dev = dev;
+	INIT_LIST_HEAD(&endpoint->cleanup.to_kfree);
+	INIT_LIST_HEAD(&endpoint->cleanup.to_pagefree);
+	INIT_LIST_HEAD(&endpoint->cleanup.to_unmap);
+	endpoint->msg_counter = 0x0b;
+	endpoint->failed_messages = 0;
+	endpoint->fatal_error = 0;
+
+	init_waitqueue_head(&endpoint->ep_wait);
+	mutex_init(&endpoint->register_mutex);
+
+	return endpoint;
+}
+
+static int endpoint_discovery_or_remove(struct xilly_endpoint *endpoint,
+	int do_remove)
+{
+	int rc = 0;
+
+	struct xilly_cleanup tmpmem;
+	int idtbuffersize = (1 << PAGE_SHIFT);
+
+	/*
+	 * The bogus IDT is used during bootstrap for allocating the initial
+	 * message buffer, and then the message buffer and space for the IDT
+	 * itself. The initial message buffer is of a single page's size, but
+	 * it's soon replaced with a more modest one (and memory is freed).
+	 */
+
+	unsigned char bogus_idt[8] = { 1, 224, (PAGE_SHIFT)-2, 0,
+				       3, 192, PAGE_SHIFT, 0 };
+	struct xilly_idt_handle idt_handle;
+
+	INIT_LIST_HEAD(&tmpmem.to_kfree);
+	INIT_LIST_HEAD(&tmpmem.to_pagefree);
+	INIT_LIST_HEAD(&tmpmem.to_unmap);
+
+	if (do_remove)
+		goto remove;
+
+	/*
+	 * Writing the value 0x00000001 to Endianess register signals which
+	 * endianess this processor is using, so the FPGA can swap words as
+	 * necessary.
+	 */
+
+	iowrite32(1, &endpoint->registers[fpga_endian_reg]);
+	mmiowb(); /* Writes below are affected by the one above. */
+
+	/* Bootstrap phase I: Allocate temporary message buffer */
+
+	endpoint->num_channels = 0;
+
+	rc = xilly_setupchannels(endpoint, &tmpmem, bogus_idt, 1);
+
+	if (rc)
+		goto failed_buffers;
+
+	/* Clear the message subsystem (and counter in particular) */
+	iowrite32(0x04, &endpoint->registers[fpga_msg_ctrl_reg]);
+	mmiowb();
+
+	endpoint->idtlen = -1;
+
+	smp_wmb();
+
+	/*
+	 * Set DMA 32/64 bit mode, quiesce the device (?!) and get IDT
+	 * buffer size.
+	 */
+	iowrite32((u32) (endpoint->dma_using_dac & 0x0001),
+		   &endpoint->registers[fpga_dma_control_reg]);
+	mmiowb();
+
+	wait_event_interruptible_timeout(endpoint->ep_wait,
+					 (endpoint->idtlen >= 0),
+					 XILLY_TIMEOUT);
+
+	if (endpoint->idtlen < 0) {
+		pr_err("xillybus: No response from FPGA. Aborting.\n");
+		rc = -ENODEV;
+		goto failed_quiesce;
+	}
+
+	/* Enable DMA */
+	iowrite32((u32) (0x0002 | (endpoint->dma_using_dac & 0x0001)),
+		   &endpoint->registers[fpga_dma_control_reg]);
+	mmiowb();
+
+	/* Bootstrap phase II: Allocate buffer for IDT and obtain it */
+	while (endpoint->idtlen >= idtbuffersize) {
+		idtbuffersize *= 2;
+		bogus_idt[6]++;
+	}
+
+	endpoint->num_channels = 1;
+
+	rc = xilly_setupchannels(endpoint, &tmpmem, bogus_idt, 2);
+
+	if (rc)
+		goto failed_idt;
+
+	smp_wmb();
+
+	rc = xilly_obtain_idt(endpoint);
+
+	if (rc)
+		goto failed_idt;
+
+	xilly_scan_idt(endpoint, &idt_handle);
+
+	if (!idt_handle.chandesc) {
+		rc = -ENODEV;
+		goto failed_idt;
+	}
+	/* Bootstrap phase III: Allocate buffers according to IDT */
+
+	rc = xilly_setupchannels(endpoint,
+				 &endpoint->cleanup,
+				 idt_handle.chandesc,
+				 idt_handle.entries);
+
+	if (rc)
+		goto failed_idt;
+
+	smp_wmb(); /* mutex_lock below should suffice, but won't hurt.*/
+
+	/*
+	 * endpoint is now completely configured. We put it on the list
+	 * available to open() before registering the char device(s)
+	 */
+
+	mutex_lock(&ep_list_lock);
+	list_add_tail(&endpoint->ep_list, &list_of_endpoints);
+	mutex_unlock(&ep_list_lock);
+
+	rc = xillybus_init_chrdev(endpoint, idt_handle.idt);
+
+	if (rc)
+		goto failed_chrdevs;
+
+	xilly_do_cleanup(&tmpmem);
+
+	return 0;
+
+remove:
+	xillybus_cleanup_chrdev(endpoint);
+
+failed_chrdevs:
+	mutex_lock(&ep_list_lock);
+	list_del(&endpoint->ep_list);
+	mutex_unlock(&ep_list_lock);
+
+failed_idt:
+	/* Quiesce the device. Now it's serious to do it */
+	endpoint->idtlen = -1;
+	wmb(); /* Make sure idtlen is set before sending command */
+	iowrite32((u32) (endpoint->dma_using_dac & 0x0001),
+		   &endpoint->registers[fpga_dma_control_reg]);
+	mmiowb();
+
+	wait_event_interruptible_timeout(endpoint->ep_wait,
+					 (endpoint->idtlen >= 0),
+					 XILLY_TIMEOUT);
+
+	if (endpoint->idtlen < 0) {
+		pr_err("xillybus: Failed to quiesce the device on "
+		       "exit. Quitting while leaving a mess.\n");
+		return -ENODEV; /* FPGA may still DMA, so no release */
+	}
+
+	/*
+	 * Flushing is done upon endpoint release to prevent access to memory
+	 * just about to be released. This makes the quiesce complete.
+	 */
+	flush_workqueue(xillybus_wq);
+failed_quiesce:
+failed_buffers:
+	xilly_do_cleanup(&tmpmem);
+
+	return rc;
+}
+
+#ifdef CONFIG_XILLYBUS_PCIE
+static int xilly_probe_or_remove(struct pci_dev *pdev,
+				 const struct pci_device_id *ent,
+				 const int what_to_do)
+{
+	struct xilly_endpoint *endpoint;
+	int rc = 0;
+
+	if (!what_to_do) {
+		endpoint = pci_get_drvdata(pdev);
+		endpoint_discovery_or_remove(endpoint, 1);
+		goto release;
+	}
+
+	endpoint = init_endpoint(pdev, NULL);
+
+	if (!endpoint)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, endpoint);
+
+	rc = pci_enable_device(pdev);
+
+	/* L0s has caused packet drops. No power saving, thank you. */
+
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
+
+	if (rc) {
+		pr_err("xillybus: pci_enable_device() failed. "
+		       "Aborting.\n");
+		goto no_enable;
+	}
+
+	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
+		pr_err("xillybus: Incorrect BAR configuration. "
+		       "Aborting.\n");
+		rc = -ENODEV;
+		goto bad_bar;
+	}
+
+	rc = pci_request_regions(pdev, xillyname);
+	if (rc) {
+		pr_err("xillybus: pci_request_regions() failed. "
+		       "Aborting.\n");
+		goto failed_request_regions;
+	}
+
+	endpoint->registers = pci_iomap(pdev, 0, 128);
+
+	if (!endpoint->registers) {
+		pr_err("xillybus: Failed to map BAR 0. Aborting.\n");
+		goto failed_iomap0;
+	}
+
+	pci_set_master(pdev);
+
+	/* Set up a single MSI interrupt */
+	if (pci_enable_msi(pdev)) {
+		pr_err("xillybus: Failed to enable MSI interrupts. "
+		       "Aborting.\n");
+		rc = -ENODEV;
+		goto failed_enable_msi;
+	}
+	rc = request_irq(pdev->irq, xillybus_isr, 0, xillyname, endpoint);
+
+	if (rc) {
+		pr_err("xillybus: Failed to register MSI handler. "
+		       "Aborting.\n");
+		rc = -ENODEV;
+		goto failed_register_msi;
+	}
+
+	/*
+	 * In theory, an attempt to set the DMA mask to 64 and dma_using_dac=1
+	 * is the right thing. But some unclever PCIe drivers report it's OK
+	 * when the hardware drops those 64-bit PCIe packets. So trust
+	 * nobody and use 32 bits DMA addressing in any case.
+	 */
+
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
+		endpoint->dma_using_dac = 0;
+	else {
+		pr_err("xillybus: Failed to set DMA mask. "
+		       "Aborting.\n");
+		rc = -ENODEV;
+		goto failed_dmamask;
+	}
+
+	rc = endpoint_discovery_or_remove(endpoint, 0);
+
+	if (!rc)
+		return 0;
+
+release:
+failed_dmamask:
+	free_irq(pdev->irq, endpoint);
+failed_register_msi:
+	pci_disable_msi(pdev);
+failed_enable_msi:
+	/* pci_clear_master(pdev); Nobody else seems to do this */
+	pci_iounmap(pdev, endpoint->registers);
+failed_iomap0:
+	pci_release_regions(pdev);
+failed_request_regions:
+bad_bar:
+	pci_disable_device(pdev);
+no_enable:
+	xilly_do_cleanup(&endpoint->cleanup);
+
+	kfree(endpoint);
+	return rc;
+}
+
+static void xilly_remove(struct pci_dev *pdev)
+{
+	xilly_probe_or_remove(pdev, NULL, 0);
+}
+
+static int __devinit xilly_probe(struct pci_dev *pdev,
+				 const struct pci_device_id *ent)
+{
+	return xilly_probe_or_remove(pdev, ent, 1);
+}
+
+MODULE_DEVICE_TABLE(pci, xillyids);
+
+static struct pci_driver xillybus_driver = {
+	.name = (char *) xillyname,
+	.id_table = xillyids,
+	.probe = xilly_probe,
+	.remove = __devexit_p(xilly_remove),
+};
+
+#endif
+
+
+#ifdef CONFIG_XILLYBUS_OF
+static int xilly_drv_probe_or_remove(struct device *dev,
+				    const int what_to_do)
+{
+	struct xilly_endpoint *endpoint;
+	int rc = 0;
+	int irq;
+
+	if (!what_to_do) {
+		endpoint = dev_get_drvdata(dev);
+		irq = irq_of_parse_and_map(dev->of_node, 0);
+		endpoint_discovery_or_remove(endpoint, 1);
+		goto release;
+	}
+
+	endpoint = init_endpoint(NULL, dev);
+
+	if (!endpoint)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, endpoint);
+
+	/*
+	 * Check if the current architecture implements DMA sync functions.
+	 * It should, but old versions of the Microblaze architecture
+	 * support doesn't.
+	 */
+
+	rc = of_address_to_resource(dev->of_node, 0, &endpoint->res);
+	if (rc) {
+		pr_warn("xillybus: Failed to obtain device tree "
+			"resource\n");
+		goto failed_request_regions;
+	}
+
+	if  (!request_mem_region(endpoint->res.start,
+				 resource_size(&endpoint->res), xillyname)) {
+		pr_err("xillybus: request_mem_region failed. Aborting.\n");
+		rc = -EBUSY;
+		goto failed_request_regions;
+	}
+
+	endpoint->registers = of_iomap(dev->of_node, 0);
+
+	if (!endpoint->registers) {
+		pr_err("xillybus: Failed to map I/O memory. Aborting.\n");
+		goto failed_iomap0;
+	}
+
+	irq = irq_of_parse_and_map(dev->of_node, 0);
+
+	rc = request_irq(irq, xillybus_isr, 0, xillyname, endpoint);
+
+	if (rc) {
+		pr_err("xillybus: Failed to register IRQ handler. "
+		       "Aborting.\n");
+		rc = -ENODEV;
+		goto failed_register_irq;
+	}
+
+	rc = endpoint_discovery_or_remove(endpoint, 0);
+
+	if (!rc)
+		return 0;
+
+release:
+	free_irq(irq, endpoint);
+
+failed_register_irq:
+	iounmap(endpoint->registers);
+failed_iomap0:
+	release_mem_region(endpoint->res.start, 128);
+
+failed_request_regions:
+	xilly_do_cleanup(&endpoint->cleanup);
+
+	kfree(endpoint);
+	return rc;
+}
+
+static int __devexit xilly_drv_remove(struct platform_device *op)
+{
+	xilly_drv_probe_or_remove(&op->dev, 0);
+	return 0;
+}
+
+static int __devinit xilly_drv_probe(struct platform_device *op)
+{
+	const struct of_device_id *match;
+	match = of_match_device(xillybus_of_match, &op->dev);
+
+	if (!match)
+		return -EINVAL;
+
+	return xilly_drv_probe_or_remove(&op->dev, 1);
+}
+
+static struct platform_driver xillybus_platform_driver = {
+	.probe = xilly_drv_probe,
+	.remove = __devexit_p(xilly_drv_remove),
+	.driver = {
+		.name = (char *) xillyname,
+		.owner = THIS_MODULE,
+		.of_match_table = xillybus_of_match,
+	},
+};
+
+#endif
+
+static int __init xillybus_init(void)
+{
+	int rc = 0;
+
+	mutex_init(&ep_list_lock);
+
+	xillybus_class = class_create(THIS_MODULE, xillyname);
+	if (IS_ERR(xillybus_class)) {
+		rc = PTR_ERR(xillybus_class);
+		pr_warn("xillybus: Failed to register class xillybus\n");
+
+		return rc;
+	}
+
+	xillybus_wq = alloc_workqueue(xillyname, 0, 0);
+
+#ifdef CONFIG_XILLYBUS_PCIE
+	rc = pci_register_driver(&xillybus_driver);
+#endif
+	if (rc)
+		goto error1;
+
+#ifdef CONFIG_XILLYBUS_OF
+	rc = platform_driver_register(&xillybus_platform_driver);
+#endif
+	if (rc)
+		goto error2;
+
+	return 0; /* Success */
+
+error2:
+#ifdef CONFIG_XILLYBUS_PCIE
+	pci_unregister_driver(&xillybus_driver);
+#endif
+
+error1:
+	destroy_workqueue(xillybus_wq);
+
+	class_destroy(xillybus_class);
+
+	return rc;
+}
+
+static void __exit xillybus_exit(void)
+{
+#ifdef CONFIG_XILLYBUS_OF
+	platform_driver_unregister(&xillybus_platform_driver);
+#endif
+
+#ifdef CONFIG_XILLYBUS_PCIE
+	pci_unregister_driver(&xillybus_driver);
+#endif
+
+	/* flush_workqueue() was called for each endpoint released */
+	destroy_workqueue(xillybus_wq);
+
+	class_destroy(xillybus_class);
+}
+
+module_init(xillybus_init);
+module_exit(xillybus_exit);
-- 
1.7.2.3

