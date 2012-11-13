Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2KMSrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:47:52 -0500
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:37865 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753083Ab2KMSrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:47:49 -0500
From: Constantine Shulyupin <const@MakeLinux.com>
To: linux-kernel@vger.kernel.org, celinux-dev@lists.celinuxforum.org,
        gregkh@linuxfoundation.org
Cc: Constantine Shulyupin <const@MakeLinux.com>
Subject: [PATCH] LDT - Linux Driver Template
Date: Tue, 13 Nov 2012 20:46:37 +0200
Message-Id: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
CC: Tim Bird <tim.bird@am.sony.com>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Selim TEMUR <selimtemur@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 77.126.70.233 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

LDT is useful for Linux driver development beginners,
hackers and as starting point for a new drivers.
The driver uses following Linux facilities: module, platform driver,
file operations (read/write, mmap, ioctl, blocking and nonblocking mode, polling),
kfifo, completion, interrupt, tasklet, work, kthread, timer, simple misc device,
multiple char devices, Device Model, configfs, UART 0x3f8,
HW loopback, SW loopback, ftracer.

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---
 samples/Kconfig             |   14 +
 samples/Makefile            |    5 +-
 samples/ltd/Makefile        |    1 +
 samples/ltd/ldt.c           |  764 +++++++++++++++++++++++++++++++++++++++++++
 samples/ltd/ldt_plat_dev.c  |   68 ++++
 tools/testing/ldt/Makefile  |    6 +
 tools/testing/ldt/ctracer.h |  380 +++++++++++++++++++++
 tools/testing/ldt/dio.c     |  362 ++++++++++++++++++++
 tools/testing/ldt/ldt-test  |  142 ++++++++
 9 files changed, 1740 insertions(+), 2 deletions(-)
 create mode 100644 samples/ltd/Makefile
 create mode 100644 samples/ltd/ldt.c
 create mode 100644 samples/ltd/ldt_plat_dev.c
 create mode 100644 tools/testing/ldt/Makefile
 create mode 100644 tools/testing/ldt/ctracer.h
 create mode 100644 tools/testing/ldt/dio.c
 create mode 100755 tools/testing/ldt/ldt-test

diff --git a/samples/Kconfig b/samples/Kconfig
index 7b6792a..2b93fd0 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -69,4 +69,18 @@ config SAMPLE_RPMSG_CLIENT
 	  to communicate with an AMP-configured remote processor over
 	  the rpmsg bus.
 
+config SAMPLE_DRIVER_TEMPLATE
+	tristate "LDT - Linux driver template"
+	help
+	  Template of Linux device driver. Useful for Linux driver
+	  development beginners, hackers and as starting point for a new drivers.
+	  The driver uses following Linux facilities: module, platform driver,
+	  file operations (read/write, mmap, ioctl, blocking and nonblocking mode, polling),
+	  kfifo, completion, interrupt, tasklet, work, kthread, timer, simple misc device,
+	  multiple char devices, Device Model, configfs, UART 0x3f8, HW loopback,
+	  SW loopback, ftracer.
+	  Usermode test script and utility are located in tools/testing/ldt/
+
+	  List of more samples and skeletons can be found at http://elinux.org/Device_drivers
+
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index 5ef08bb..d4b1818 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,4 +1,5 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ tracepoints/ trace_events/ \
-			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/
+obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ tracepoints/ trace_events/
+obj-$(CONFIG_SAMPLES)	+= hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/
+obj-$(CONFIG_SAMPLES)	+= ldt/
diff --git a/samples/ltd/Makefile b/samples/ltd/Makefile
new file mode 100644
index 0000000..efd691f
--- /dev/null
+++ b/samples/ltd/Makefile
@@ -0,0 +1 @@
+obj-$(SAMPLE_DRIVER_TEMPLATE)+= ldt.o ldt_plat_dev.o
diff --git a/samples/ltd/ldt.c b/samples/ltd/ldt.c
new file mode 100644
index 0000000..a4d2b3b
--- /dev/null
+++ b/samples/ltd/ldt.c
@@ -0,0 +1,764 @@
+/*
+ *	LDT - Linux Driver Template
+ *
+ *	Copyright (C) 2012 Constantine Shulyupin http://www.makelinux.net/
+ *
+ *	Dual BSD/GPL License
+ *
+ *
+ *	The driver demonstrates usage of following Linux facilities:
+ *
+ *	Linux kernel module
+ *	file_operations
+ *		read and write (UART)
+ *		blocking read
+ *		polling
+ *		mmap
+ *		ioctl
+ *	kfifo
+ *	completion
+ *	interrupt
+ *	tasklet
+ *	timer
+ *	work
+ *	kthread
+ *	simple single misc device file (miscdevice, misc_register)
+ *	multiple char device files (alloc_chrdev_region)
+ *	debugfs
+ *	platform_driver and platform_device in another module
+ *	simple UART driver on port 0x3f8 with IRQ 4
+ *	Device Model (class, device)
+ *	Power Management (dev_pm_ops)
+ *	Device Tree (of_device_id)
+ *
+ *	TODO:
+ *	linked list
+ *	private instance state struct
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/timer.h>
+#include <linux/kfifo.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/platform_device.h>
+#include <linux/serial_reg.h>
+#include <linux/debugfs.h>
+#include <linux/cdev.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/mod_devicetable.h>
+
+#define ctracer_cut_path(fn) (fn[0] != '/' ? fn : (strrchr(fn, '/') + 1))
+#define __file__	ctracer_cut_path(__FILE__)
+
+/*
+ *	print_context prints execution context:
+ *	hard interrupt, soft interrupt or scheduled task
+ */
+
+#define print_context()	\
+	pr_debug("%s:%d %s %s 0x%x\n", __file__, __LINE__, __func__, \
+			(in_irq() ? "harirq" : current->comm), preempt_count());
+
+#define once(exp) do { \
+	static int _passed; if (!_passed) { exp; }; _passed = 1; } while (0)
+
+#define check(a) \
+	(ret = a, ((ret < 0) ? pr_warning("%s:%i %s FAIL\n\t%i=%s\n", \
+	__file__, __LINE__, __func__, ret, #a) : 0), ret)
+
+#define pr_debug_hex(h)	pr_debug("%s:%d %s %s = 0x%lX\n", \
+	__file__, __LINE__, __func__, #h, (long int)h)
+#define pr_debug_dec(d)	pr_debug("%s:%d %s %s = %ld\n", \
+	__file__, __LINE__, __func__, #d, (long int)d)
+
+#define pr_err_msg(m)	pr_err("%s:%d %s %s\n", __file__, __LINE__, __func__, m)
+
+
+static char ldt_name[] = KBUILD_MODNAME;
+static int bufsize = PFN_ALIGN(16 * 1024);
+static void *in_buf;
+static void *out_buf;
+static int uart_detected;
+void *port_ptr;
+
+static int port;
+module_param(port, int, 0);
+static int port_size;
+module_param(port_size, int, 0);
+
+static int irq;
+module_param(irq, int, 0);
+
+static int loopback;
+module_param(loopback, int, 0);
+
+static int isr_counter;
+static int ldt_work_counter;
+
+#define FIFO_SIZE 128		/* should be power of two */
+static DEFINE_KFIFO(in_fifo, char, FIFO_SIZE);
+static DEFINE_KFIFO(out_fifo, char, FIFO_SIZE);
+
+static DECLARE_WAIT_QUEUE_HEAD(ldt_readable);
+
+static spinlock_t fifo_lock;
+
+
+/*
+ *	ldt_received - called with data received from HW port
+ *	Called from tasklet, which is fired from ISR or timer
+ */
+
+static void ldt_received(void *data, int size)
+{
+	kfifo_in_spinlocked(&in_fifo, data, size, &fifo_lock);
+	wake_up_interruptible(&ldt_readable);
+}
+
+/*
+ *	ldt_send - send data to HW port or emulated SW loopback
+ */
+
+static void ldt_send(void *data, int size)
+{
+	if (uart_detected) {
+		if (ioread8(port_ptr + UART_LSR) & UART_LSR_THRE)
+			iowrite8(*(char *)data, port_ptr + UART_TX);
+		else
+			pr_err_msg("overflow");
+	} else
+		/* emulate loopback  */
+	if (loopback)
+		ldt_received(data, size);
+}
+
+/*
+ *	work
+ */
+
+static void ldt_work_func(struct work_struct *work)
+{
+	once(print_context());
+	ldt_work_counter++;
+}
+
+DECLARE_WORK(ldt_work, ldt_work_func);
+
+/*
+ *	tasklet
+ */
+
+static DECLARE_COMPLETION(ldt_complete);
+
+#define tx_ready()	(ioread8(port_ptr + UART_LSR) & UART_LSR_THRE)
+#define rx_ready()	(ioread8(port_ptr + UART_LSR) & UART_LSR_DR)
+
+static void ldt_tasklet_func(unsigned long d)
+{
+	char data_out, data_in;
+	once(print_context());
+	if (uart_detected) {
+		while (tx_ready() && kfifo_out_spinlocked(&out_fifo, &data_out, sizeof(data_out), &fifo_lock)) {
+			pr_debug_hex(ioread8(port_ptr + UART_LSR));
+			pr_debug_dec(data_out);
+			if (data_out >= 32)
+				pr_debug("data_out = '%c' ", data_out);
+			ldt_send(&data_out, sizeof(data_out));
+		}
+		while (rx_ready()) {
+			pr_debug_hex(ioread8(port_ptr + UART_LSR));
+			data_in = ioread8(port_ptr + UART_RX);
+			pr_debug_dec(data_in);
+			if (data_in >= 32)
+				pr_debug("data_out = '%c' ", data_in);
+			ldt_received(&data_in, sizeof(data_in));
+		}
+	} else {
+		while (kfifo_out_spinlocked(&out_fifo, &data_out, sizeof(data_out), &fifo_lock)) {
+			pr_debug_dec(data_out);
+			ldt_send(&data_out, sizeof(data_out));
+		}
+	}
+	schedule_work(&ldt_work);
+	complete(&ldt_complete);
+}
+
+static DECLARE_TASKLET(ldt_tasklet, ldt_tasklet_func, 0);
+
+/*
+ *	interrupt
+ */
+
+static irqreturn_t ldt_isr(int irq, void *dev_id, struct pt_regs *regs)
+{
+	/*
+	 *      UART interrupt is not fired in loopback mode,
+	 *      therefore fire ldt_tasklet from timer too
+	 */
+	once(print_context());
+	isr_counter++;
+	pr_debug_hex(ioread8(port_ptr + UART_FCR));
+	pr_debug_hex(ioread8(port_ptr + UART_IIR));
+	tasklet_schedule(&ldt_tasklet);
+	return IRQ_HANDLED;	/* our IRQ */
+}
+
+/*
+ *	timer
+ */
+
+static struct timer_list ldt_timer;
+static void ldt_timer_func(unsigned long data)
+{
+	/*
+	 *      this timer is used just to fire ldt_tasklet,
+	 *      when there is no interrupt in loopback mode
+	 */
+	if (loopback)
+		tasklet_schedule(&ldt_tasklet);
+	mod_timer(&ldt_timer, jiffies + HZ / 100);
+}
+
+static DEFINE_TIMER(ldt_timer, ldt_timer_func, 0, 0);
+
+/*
+ *	file_operations
+ */
+
+static int ldt_open(struct inode *inode, struct file *file)
+{
+	print_context();
+	pr_debug_dec(imajor(inode));
+	pr_debug_dec(iminor(inode));
+	pr_debug_hex(file->f_flags & O_NONBLOCK);
+	return 0;
+}
+
+static int ldt_release(struct inode *inode, struct file *file)
+{
+	print_context();
+	pr_debug_dec(imajor(inode));
+	pr_debug_dec(iminor(inode));
+	pr_debug_dec(isr_counter);
+	pr_debug_dec(ldt_work_counter);
+	return 0;
+}
+
+/*
+ *	read
+ */
+
+static DEFINE_MUTEX(read_lock);
+
+static ssize_t ldt_read(struct file *file, char __user * buf, size_t count, loff_t * ppos)
+{
+	int ret;
+	unsigned int copied;
+	if (kfifo_is_empty(&in_fifo)) {
+		if (file->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
+			goto exit;
+		} else {
+			pr_err_msg("waiting");
+			ret = wait_event_interruptible(ldt_readable, !kfifo_is_empty(&in_fifo));
+			if (ret == -ERESTARTSYS) {
+				pr_err_msg("interrupted");
+				ret = -EINTR;
+				goto exit;
+			}
+		}
+	}
+	if (mutex_lock_interruptible(&read_lock)) {
+		pr_err_msg("interrupted");
+		return -EINTR;
+	}
+	ret = kfifo_to_user(&in_fifo, buf, count, &copied);
+	mutex_unlock(&read_lock);
+exit:
+	return ret ? ret : copied;
+}
+
+/*
+ *	write
+ */
+
+static DEFINE_MUTEX(write_lock);
+
+static ssize_t ldt_write(struct file *file, const char __user * buf, size_t count, loff_t * ppos)
+{
+	int ret;
+	unsigned int copied;
+	/* TODO: wait_event_interruptible ... ldt_writeable */
+	if (mutex_lock_interruptible(&write_lock))
+		return -EINTR;
+	ret = kfifo_from_user(&out_fifo, buf, count, &copied);
+	mutex_unlock(&write_lock);
+	tasklet_schedule(&ldt_tasklet);
+	return ret ? ret : copied;
+}
+
+/*
+ *	polling
+ */
+
+static unsigned int ldt_poll(struct file *file, poll_table * pt)
+{
+	unsigned int mask = 0;
+	poll_wait(file, &ldt_readable, pt);
+	/*poll_wait(file, ldt_writeable, pt); TODO */
+
+	if (!kfifo_is_empty(&in_fifo))
+		mask |= POLLIN | POLLRDNORM;
+	mask |= POLLOUT | POLLWRNORM;
+#if 0
+	mask |= POLLHUP;	/* on output eof */
+	mask |= POLLERR;	/* on output error */
+#endif
+	pr_debug_hex(mask);
+	return mask;
+}
+
+/*
+ *	pages_flag - set or clear a flag for sequence of pages
+ *
+ *	more generic solution instead SetPageReserved, ClearPageReserved etc
+ */
+
+void pages_flag(struct page *page, int pages, int mask, int value)
+{
+	for (; pages; pages--, page++)
+		if (value)
+			__set_bit(mask, &page->flags);
+		else
+			__clear_bit(mask, &page->flags);
+}
+
+/*
+ *	mmap
+ */
+static int ldt_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	void *buf = NULL;
+	if (vma->vm_flags & VM_WRITE)
+		buf = in_buf;
+	else if (vma->vm_flags & VM_READ)
+		buf = out_buf;
+	if (!buf)
+		return -EINVAL;
+	if (remap_pfn_range(vma, vma->vm_start, virt_to_phys(buf) >> PAGE_SHIFT,
+			    vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
+		pr_err_msg("remap_pfn_range failed");
+		return -EAGAIN;
+	}
+	return 0;
+}
+
+/*
+ *	ioctl
+ */
+
+#define trace_ioctl(nr) printk("ioctl=(%c%c %c #%i %i)\n", \
+	(_IOC_READ & _IOC_DIR(nr)) ? 'r' : ' ', (_IOC_WRITE & _IOC_DIR(nr)) ? 'w' : ' ', \
+	_IOC_TYPE(nr), _IOC_NR(nr), _IOC_SIZE(nr))
+
+static long ldt_ioctl(struct file *f, unsigned int cmnd, unsigned long arg)
+{
+	void __user *user = (void *)arg;
+	pr_debug_hex(cmnd);
+	pr_debug_hex(arg);
+	trace_ioctl(cmnd);
+	if (_IOC_DIR(cmnd) == _IOC_WRITE) {
+		copy_from_user(in_buf, user, _IOC_SIZE(cmnd));
+		memcpy(out_buf, in_buf, bufsize);
+		memset(in_buf, 0, bufsize);
+	}
+	if (_IOC_DIR(cmnd) == _IOC_READ) {
+		copy_to_user(user, out_buf, _IOC_SIZE(cmnd));
+		memset(out_buf, 0, bufsize);
+	}
+	switch (_IOC_TYPE(cmnd)) {
+	case 'A':
+		switch (_IOC_NR(cmnd)) {
+		case 0:
+			break;
+		}
+		break;
+	}
+	return 0;
+}
+
+static const struct file_operations ldt_fops = {
+	.owner = THIS_MODULE,
+	.open = ldt_open,
+	.release = ldt_release,
+	.read = ldt_read,
+	.write = ldt_write,
+	.poll = ldt_poll,
+	.mmap = ldt_mmap,
+	.unlocked_ioctl = ldt_ioctl,
+};
+
+#ifdef USE_MISCDEV
+/*
+ *	use miscdevice for single instance device
+ */
+static struct miscdevice ldt_miscdev = {
+	MISC_DYNAMIC_MINOR,
+	ldt_name,
+	&ldt_fops,
+};
+#else
+/*
+ *	used cdev and device for multiple instances device
+ */
+
+static int devs = 8;
+module_param(devs, int, 0);
+
+static struct cdev ldt_cdev;
+static struct class *ldt_class;
+static struct device *ldt_dev;
+#if 0
+static char *ldt_devnode(struct device *dev, umode_t * mode)
+{
+	if (mode)
+		*mode = S_IRUGO | S_IWUGO;
+	/* *mode = 0666; */
+	return NULL;
+}
+#endif
+#endif
+
+/*
+ *	kthread
+ */
+
+static int ldt_thread_sub(void *data)
+{
+	int ret = 0;
+	/*
+	   perform here a useful work in task context
+	 */
+	return ret;
+}
+
+static int ldt_thread(void *data)
+{
+	int ret = 0;
+	print_context();
+	allow_signal(SIGINT);
+	while (!kthread_should_stop()) {
+		ret = wait_for_completion_interruptible(&ldt_complete);
+		if (ret == -ERESTARTSYS) {
+			pr_err_msg("interrupted");
+			ret = -EINTR;
+			break;
+		}
+		ret = ldt_thread_sub(data);
+	}
+	return ret;
+}
+
+/*
+ *	UART
+ */
+
+static struct resource *port_r;
+
+static int uart_probe(void)
+{
+	int ret = 0;
+	if (port) {
+		port_ptr = ioport_map(port, port_size);
+		pr_debug_hex(port_ptr);
+		port_r = request_region(port, port_size, ldt_name);
+		pr_debug_hex(port_r);
+		/* ignore error */
+	}
+	if (irq) {
+		ret = check(request_irq(irq, (void *)ldt_isr, IRQF_SHARED, ldt_name, THIS_MODULE));
+		iowrite8(UART_MCR_RTS | UART_MCR_OUT2 | UART_MCR_LOOP, port_ptr + UART_MCR);
+		uart_detected = (ioread8(port_ptr + UART_MSR) & 0xF0) == (UART_MSR_DCD | UART_MSR_CTS);
+		pr_debug_hex(ioread8(port_ptr + UART_MSR));
+
+		if (uart_detected) {
+			/*iowrite8(UART_IER_MSI | UART_IER_THRI |  UART_IER_RDI | UART_IER_RLSI, port_ptr + UART_IER); */
+			iowrite8(UART_IER_RDI | UART_IER_RLSI | UART_IER_THRI, port_ptr + UART_IER);
+			iowrite8(UART_MCR_DTR | UART_MCR_RTS | UART_MCR_OUT2, port_ptr + UART_MCR);
+			iowrite8(UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT, port_ptr + UART_FCR);
+			pr_debug_dec(loopback);
+			if (loopback)
+				iowrite8(ioread8(port_ptr + UART_MCR) | UART_MCR_LOOP, port_ptr + UART_MCR);
+		}
+		if (!uart_detected && loopback) {
+			pr_warn("Emulating loopback in software\n");
+			ret = -ENODEV;
+		}
+	}
+	pr_debug_hex(uart_detected);
+	pr_debug_hex(ioread8(port_ptr + UART_IER));
+	pr_debug_hex(ioread8(port_ptr + UART_IIR));
+	pr_debug_hex(ioread8(port_ptr + UART_FCR));
+	pr_debug_hex(ioread8(port_ptr + UART_LCR));
+	pr_debug_hex(ioread8(port_ptr + UART_MCR));
+	pr_debug_hex(ioread8(port_ptr + UART_LSR));
+	pr_debug_hex(ioread8(port_ptr + UART_MSR));
+	return ret;
+}
+
+static struct task_struct *thread;
+static struct dentry *debugfs;
+static int major;
+
+int chrdev_region_init(char *dev_name)
+{
+	int ret;
+	int d;
+	dev_t devid;
+	devid = MKDEV(major, 0);
+	ret = check(alloc_chrdev_region(&devid, 0, devs, dev_name));
+	major = MAJOR(devid);
+	pr_debug_dec(major);
+	cdev_init(&ldt_cdev, &ldt_fops);
+	check(cdev_add(&ldt_cdev, MKDEV(major, 0), devs));
+	ldt_class = class_create(THIS_MODULE, dev_name);
+	/* ldt_class->devnode = ldt_devnode; */
+	ldt_dev = device_create(ldt_class, NULL, devid, NULL, "%s", dev_name);
+	for (d = 1; d < devs; d++)
+		device_create(ldt_class, NULL, MKDEV(major, d), NULL, "%s%d", dev_name, d);
+	pr_debug_dec(IS_ERR(ldt_dev));
+	pr_debug_hex(ldt_dev);
+	return major;
+}
+
+/*
+ *	ldt_probe - main initialization function
+ */
+
+static __devinit int ldt_probe(struct platform_device *pdev)
+{
+	int ret;
+	char *data = NULL;
+	struct resource *r;
+	print_context();
+	printk(KERN_DEBUG"%s %s %s", ldt_name, __DATE__, __TIME__);
+	printk(KERN_DEBUG"pdev = %p ", pdev);
+	pr_debug_dec(irq);
+	pr_debug_dec(bufsize);
+	in_buf = alloc_pages_exact(bufsize, GFP_KERNEL | __GFP_ZERO);
+	if (!in_buf) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+	pages_flag(virt_to_page(in_buf), PFN_UP(bufsize), PG_reserved, 1);
+	out_buf = alloc_pages_exact(bufsize, GFP_KERNEL | __GFP_ZERO);
+	if (!out_buf) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+	pages_flag(virt_to_page(out_buf), PFN_UP(bufsize), PG_reserved, 1);
+	if (pdev) {
+		dev_dbg(&pdev->dev, "%s:%d %s attaching driver\n", __file__, __LINE__, __func__);
+		pr_debug_hex(pdev->dev.of_node);
+#ifdef CONFIG_OF_DEVICE
+		check(of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev));
+#endif
+		data = pdev->dev.platform_data;
+		printk("%p %s\n", data, data);
+		if (!irq)
+			irq = platform_get_irq(pdev, 0);
+		r = platform_get_resource(pdev, IORESOURCE_IO, 0);
+		if (r && !port)
+			port = r->start;
+
+		if (r && !port_size)
+			port_size = resource_size(r);
+	}
+	isr_counter = 0;
+	uart_probe();
+	/* proc_create(ldt_name, 0, NULL, &ldt_fops); depricated */
+	mod_timer(&ldt_timer, jiffies + HZ / 10);
+	thread = kthread_run(ldt_thread, NULL, "%s", ldt_name);
+	if (IS_ERR(thread)) {
+		ret = PTR_ERR(thread);
+		if (ret)
+			goto exit;
+	}
+	debugfs = debugfs_create_file(ldt_name, S_IRUGO, NULL, NULL, &ldt_fops);
+#ifdef USE_MISCDEV
+	ret = check(misc_register(&ldt_miscdev));
+	if (ret < 0)
+		goto exit;
+	pr_debug_dec(ldt_miscdev.minor);
+#else
+	chrdev_region_init(ldt_name);
+#endif
+exit:
+	pr_debug_dec(ret);
+	return ret;
+}
+
+/*
+ *	ldt_remove - main clean up function
+ */
+
+static int __devexit ldt_remove(struct platform_device *pdev)
+{
+	int d;
+	if (pdev)
+		dev_dbg(&pdev->dev, "%s:%d %s detaching driver\n", __file__, __LINE__, __func__);
+	/* remove_proc_entry(ldt_name, NULL); depricated */
+	if (debugfs)
+		debugfs_remove(debugfs);
+#ifdef USE_MISCDEV
+	misc_deregister(&ldt_miscdev);
+#else
+	for (d = 0; d < devs; d++)
+		device_destroy(ldt_class, MKDEV(major, d));
+	class_destroy(ldt_class);
+	cdev_del(&ldt_cdev);
+	unregister_chrdev_region(MKDEV(major, 0), devs);
+#endif
+	if (!IS_ERR_OR_NULL(thread)) {
+		send_sig(SIGINT, thread, 1);
+		kthread_stop(thread);
+	}
+	del_timer(&ldt_timer);
+	if (port_r)
+		release_region(port, port_size);
+	if (irq) {
+		if (uart_detected) {
+			iowrite8(0, port_ptr + UART_IER);
+			iowrite8(0, port_ptr + UART_FCR);
+			iowrite8(0, port_ptr + UART_MCR);
+			ioread8(port_ptr + UART_RX);
+		}
+		free_irq(irq, THIS_MODULE);
+	}
+	tasklet_kill(&ldt_tasklet);
+	if (in_buf) {
+		pages_flag(virt_to_page(in_buf), PFN_UP(bufsize), PG_reserved, 0);
+		free_pages_exact(in_buf, bufsize);
+	}
+	if (out_buf) {
+		pages_flag(virt_to_page(out_buf), PFN_UP(bufsize), PG_reserved, 0);
+		free_pages_exact(out_buf, bufsize);
+	}
+	pr_debug_dec(isr_counter);
+	pr_debug_dec(ldt_work_counter);
+	if (port_ptr)
+		ioport_unmap(port_ptr);
+	return 0;
+}
+
+#ifdef USE_PLATFORM_DEVICE
+
+/*
+ * Following code requires platform_device (ldt_plat_dev.*) to work
+ */
+
+#ifdef CONFIG_PM
+
+static int ldt_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int ldt_resume(struct device *dev)
+{
+	return 0;
+}
+
+static const struct dev_pm_ops ldt_pm = {
+	.suspend = ldt_suspend,
+	.resume = ldt_resume,
+};
+
+#define ldt_pm_ops (&ldt_pm)
+#else
+#define ldt_pm_ops NULL
+#endif
+
+static const struct of_device_id ldt_of_match[] = {
+	{.compatible = "linux-driver-template",},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, ldt_of_match);
+
+static struct platform_driver ldt_driver = {
+	.driver = {
+		   .name = "ldt_device_name",
+		   .owner = THIS_MODULE,
+		   .pm = ldt_pm_ops,
+		   .of_match_table = of_match_ptr(ldt_of_match),
+		   },
+	.probe = ldt_probe,
+	.remove = __devexit_p(ldt_remove),
+};
+
+#ifdef module_platform_driver
+module_platform_driver(ldt_driver);
+#else
+
+/*
+ *	for Linux kernel releases before v3.1-12
+ *	without macro module_platform_driver
+ */
+
+static int ldt_init(void)
+{
+	int ret = 0;
+	ret = platform_driver_register(&ldt_driver);
+	return ret;
+}
+
+static void ldt_exit(void)
+{
+	platform_driver_unregister(&ldt_driver);
+}
+
+module_init(ldt_init);
+module_exit(ldt_exit);
+#endif /* module_platform_driver */
+
+#else /* !USE_PLATFORM_DEVICE */
+
+/*
+ *	Standalone module initialization to run without platform_device
+ */
+
+static int ldt_init(void)
+{
+	int ret = 0;
+	/*
+	 *      Call probe function directly,
+	 *      bypassing platform_device infrastructure
+	 */
+	ret = ldt_probe(NULL);
+	return ret;
+}
+
+static void ldt_exit(void)
+{
+	int res;
+	res = ldt_remove(NULL);
+}
+
+module_init(ldt_init);
+module_exit(ldt_exit);
+#endif
+
+MODULE_DESCRIPTION("LDT - Linux Driver Template");
+MODULE_AUTHOR("Constantine Shulyupin <const@makelinux.net>");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/samples/ltd/ldt_plat_dev.c b/samples/ltd/ldt_plat_dev.c
new file mode 100644
index 0000000..cd45057
--- /dev/null
+++ b/samples/ltd/ldt_plat_dev.c
@@ -0,0 +1,68 @@
+/*
+ *	LDT - Linux Driver Template
+ *
+ *	Copyright (C) 2012 Constantine Shulyupin  http://www.makelinux.net/
+ *
+ *	Dual BSD/GPL License
+ *
+ *	platform_device template driver
+ *
+ *	uses
+ *
+ *	platform_data
+ *	resources
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include "tracing.h"
+
+static struct resource ldt_resource[] = {
+	{
+	 .flags = IORESOURCE_IO,
+	 .start = 0x3f8,
+	 .end = 0x3ff,
+	 },
+	{
+	 .flags = IORESOURCE_IRQ,
+	 .start = 4,
+	 .end = 4,
+	 },
+	{
+	 .flags = IORESOURCE_MEM,
+	 .start = 0,
+	 .end = 0,
+	 },
+};
+
+void ldt_dev_release(struct device *dev)
+{
+_entry:;
+}
+
+static struct platform_device ldt_platform_device = {
+	.name = "ldt_device_name",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(ldt_resource),
+	.resource = ldt_resource,
+	.dev.platform_data = "test data",
+	.dev.release = ldt_dev_release,
+};
+
+static int ldt_plat_dev_init(void)
+{
+	return platform_device_register(&ldt_platform_device);
+}
+
+static void ldt_plat_dev_exit(void)
+{
+	platform_device_unregister(&ldt_platform_device);
+}
+
+module_init(ldt_plat_dev_init);
+module_exit(ldt_plat_dev_exit);
+
+MODULE_DESCRIPTION("LDT - Linux Driver Template: platform_device");
+MODULE_AUTHOR("Constantine Shulyupin <const@makelinux.net>");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/tools/testing/ldt/Makefile b/tools/testing/ldt/Makefile
new file mode 100644
index 0000000..0bfefd6
--- /dev/null
+++ b/tools/testing/ldt/Makefile
@@ -0,0 +1,6 @@
+all: dio
+
+dio: CPPFLAGS+=-g -D CTRACER_ON
+
+clean:
+	rm -rf dio *.o  dio *.tmp *.log
diff --git a/tools/testing/ldt/ctracer.h b/tools/testing/ldt/ctracer.h
new file mode 100644
index 0000000..45c5d48
--- /dev/null
+++ b/tools/testing/ldt/ctracer.h
@@ -0,0 +1,380 @@
+/*
+	Tracing utility for C
+
+	implemented in single h-file
+
+	Copyright (C) 2012 Constantine Shulyupin  http://www.makelinux.net/
+
+	Dual BSD/GPL License
+*/
+
+#if 0
+/* Optional configuration flags: */
+#define TRACE_TIME
+#define TRACE_MALLOC
+#define TRACE_LINUX_MEMORY_ON
+#endif
+/*
+	VI command to include label _entry to each function start for tracing
+	:%s/) *\n{ *$/)\r{\t_entry:;/
+ */
+
+#ifndef __ASSEMBLY__
+
+#ifndef CTRACER_H_INCLUDED
+#define CTRACER_H_INCLUDED
+extern __thread int ret;
+
+#define multistatement(ms)	ms	/* trick to bypass checkpatch.pl error */
+/*
+#define _entry multistatement(trllog(); goto _entry; _entry)
+*/
+#define _entry multistatement(_trace_enter_exit_(); trln(); goto _entry_second; _entry_second)
+/*
+#define _entry once(trl()); goto _entry; _entry
+#define return trlm("} "); return
+*/
+
+#define do_statement(a)	do { a } while (0)
+
+/*
+	trace variables: integer, hex, string, pointer, float, time value, with and w/o new line
+	macro with '_' doesn't prints new line
+	notation:
+	tr = trace
+	v<letter> = printf Variable in specified format (d, x, f, s, etc)
+*/
+
+#define trla(fmt, args...) tracef("%s:%i %s "fmt, __file__, __LINE__, __func__, ## args)
+#define trv(t, v) tracef(#v" = %"t EOL, v)
+#define trv_(t, v) tracef(#v" = %"t" ", v)
+#define trvd(d) tracef(#d" = %ld"EOL, (long int)d)
+#define trvd_(d) tracef(#d" = %ld ", (long int)d)
+#define trvx_(x) tracef(#x" = 0x%x ", (int)x)
+#define trvx(x) tracef(#x" = 0x%x"EOL, (int)x)
+#define trvlx(x) tracef(#x" = %#llx"EOL, (int)x)
+#define trvX(x) tracef(#x" = %#X"EOL, (int)x)
+#define trvf(f) tracef(#f" = %f"EOL, f)
+#define trvf_(f) tracef(#f" = %f ", f)
+#define trvtv_(tv) tracef(#tv" = %u.%06u ", (unsigned int)tv.tv_sec, (unsigned int)tv.tv_usec)
+#define trvtv(tv) tracef(#tv" = %u.%06u"EOL, (unsigned int)tv.tv_sec, (unsigned int)tv.tv_usec)
+#define trvs(s) tracef(#s" = \"%s\""EOL, s)
+#define trvs_(s) tracef(#s" = \"%s\" ", s)
+#define trvp(p) tracef(#p" = %08x"EOL, (unsigned)p)
+#define trvp_(p) tracef(#p" = %08x ", (unsigned)p)
+#define trvdn(d, n) {int i; tracef("%s", #d"[]="); for (i = 0; i < n; i++) tracef("%d:%d,", i, (*((int *)d+i))); tracef(EOL); }
+#define trvxn(d, n) {int i; tracef("%s", #d"[]="); for (i = 0; i < n; i++) tracef("%04x,", (*((int *)d+i))); tracef(EOL); }
+#define trvdr(record) trvdn(&record, sizeof(record)/sizeof(int));
+#define trvxr(record) trvxn(&record, sizeof(record)/sizeof(int));
+
+/* trvdnz - TRace Digital Variable, if Not Zero */
+#define trvdnz(d) { if (d) tracef(#d" = %d"EOL, (int)d); }
+#define trace_call(a) do { trla("calling %s {\n", #a); a; tracef("} done\n"); } while (0)
+
+/* trlm - TRace Location, with Message */
+#define trlm(m) tracef(SOL"%s:%i %s %s"EOL, __file__, __LINE__, __func__, m)
+#define trlm_(m) tracef(SOL"%s:%i %s %s ", __file__, __LINE__, __func__, m)
+#define trl() do { trace_time(); trlm(""); } while (0)
+#define trl_() tracef(SOL"%s:%i %s ", __file__, __LINE__, __func__)
+#define trln() tracef(EOL)
+
+#define trl_in() do_statement(trace_time(); trlm("{");)
+#define trl_out() do_statement(trace_time(); trlm("}");)
+#define empty_statement() do { } while (0)
+
+#define trace_mem(P, N) \
+	 IFTRACE({ int i = 0; tracef("%s=", #P); for (; i < (int)(N) ; i++) \
+{ if (i && (!(i % 16))) tracef("%i:", i); \
+tracef("%02x ", 0xFF & *((char *)((void *)(P))+i)); \
+if (!((i+1) % 4)) \
+	tracef(" "); \
+if (!((i+1) % 16)) \
+	tracef(EOL); \
+}; tracef(EOL); })
+
+#define trace_mem_int_list(P, N) \
+IFTRACE({ int i = 0; for (; i < (int)(N); i += sizeof(int)) \
+{ tracef("%i, ", *(int *)((void *)(P)+i)); \
+}; })
+
+#define trace_mem_int(P, N) \
+IFTRACE({ int i = 0; for (; i < (int)(N) ; i += sizeof(int)) \
+{ if (i && (!(i % 16))) tracef("%i:", i); \
+tracef("%x ", *(int *)((void *)(P)+i)); \
+if (!((i+1) % 64)) \
+	tracef(EOL); \
+}; tracef(EOL); })
+
+#define trace_ioctl(nr) tracef("ioctl=(%c%c %c #%i %i)\n", \
+	(_IOC_READ & _IOC_DIR(nr)) ? 'r' : ' ', (_IOC_WRITE & _IOC_DIR(nr)) ? 'w' : ' ', \
+	_IOC_TYPE(nr), _IOC_NR(nr), _IOC_SIZE(nr))
+
+#define trace_ioctl_(nr) tracef("ioctl=(%i %i %i %i)", _IOC_DIR(nr), _IOC_TYPE(nr), _IOC_NR(nr), _IOC_SIZE(nr))
+
+#define chkz(a) \
+(p = a,\
+	((!p) ? tracef("%s %i %s FAIL %i = %s\n", __FILE__, __LINE__, __func__, p, #a) : 0),\
+	p)
+
+#define chkn(a) \
+(ret = a,\
+	((ret < 0) ? tracef("%s:%i %s FAIL\n\t%i=%s\n", __FILE__, __LINE__, __func__, ret, #a)\
+	 : 0), ret)
+
+#define chkne(a) \
+(/* tracef("calling  %s\n",#a), */ \
+	ret = a,\
+	((ret < 0) ? tracef("%s:%i %s FAIL errno = %i \"%s\" %i = %s\n", __FILE__, __LINE__, __func__, errno, strerror(errno), ret, #a)\
+	 : 0), ret)
+
+#define chkn2(a) \
+(ret = a,\
+	((ret < 0) ? tracef("%s %i %s FAIL %i = %s\n", __FILE__, __LINE__, __func__, ret, #a)\
+	 : tracef("%s %i %s %i = %s\n", __FILE__, __LINE__, __func__, ret, #a)),\
+	ret)
+
+#define once(exp) do_statement( \
+	static int _passed; if (!_passed) {exp; }; _passed = 1;)
+
+
+#ifdef CTRACER_OFF		/* force no tracing */
+#undef CTRACER_ON
+#endif
+
+#ifdef CTRACER_ON
+#define IFTRACE(x) x
+
+#ifdef __KERNEL__
+#undef TRACE_TIME
+#include <linux/kernel.h>
+#include <linux/printk.h>
+
+#ifdef TRACE_LINUX_MEMORY_ON
+#include <linux/mmzone.h>
+
+extern int free_pages_prev;
+#define trace_linux_mem() do { \
+extern zone_t *zone_table[MAX_NR_ZONES*MAX_NR_NODES]; \
+int mem_change = zone_table[0]->free_pages - free_pages_prev; \
+if (mem_change) { \
+	trl_(); trvi_(mem_change); trvi(zone_table[0]->free_pages); } \
+	free_pages_prev = zone_table[0]->free_pages; \
+} while (0)
+#endif
+
+#define SOL KERN_DEBUG
+#define tracef(fmt, args...) printk(fmt, ##args)
+
+#else /* !__KERNEL__ */
+/* CTRACER_ON and not __KERNEL__ */
+#include <stdio.h>
+
+#define tracef(args...) fprintf(stderr, ##args)
+
+#if 0
+#include <signal.h>
+#define BP {trl(); kill(0, SIGTRAP); }
+#define BP kill(0, SIGTRAP)
+#endif
+
+#ifndef tracef
+#define tracef printf
+#endif
+#endif /* !__KERNEL__ */
+
+#ifndef _hweight32
+static inline unsigned int _hweight32(unsigned int w)
+{	/* from kernel */
+	w -= (w >> 1) & 0x55555555;
+	w = (w & 0x33333333) + ((w >> 2) & 0x33333333);
+	w = (w + (w >> 4)) & 0x0f0f0f0f;
+	return (w * 0x01010101) >> 24;
+}
+
+#define _hweight32 _hweight32
+#endif
+#define trllog(args ...) \
+do {  \
+	static int num;			\
+	if (_hweight32(num) < 2) {		\
+		trla("#%d\n", (int)num);	\
+	}	num++;				\
+} while (0)
+
+#define trlnum(n, args ...) \
+do {  \
+	static int num;			\
+	if (num < n) {		\
+		trl_();				\
+		tracef("#0x%x", (int)num);	\
+		args;				\
+		trln();			\
+	}	num++;				\
+} while (0)
+
+#define trleach(n, args ...) \
+do {  \
+	static int num;			\
+	if (!(num % n)) {	\
+		trl_();				\
+		trvi_(num);		\
+		args;				\
+		trln();			\
+	}	num++;				\
+} while (0)
+
+#else /* !CTRACER_ON */
+#define trllog(args ...)
+
+static inline int empty_function(void)
+{
+	return 0;
+}
+
+#define IFTRACE(x) empty_statement()
+#define trace_linux_mem() empty_statement()
+#define tracef(fmt, args...) empty_function()
+#define stack_trace() empty_statement()
+
+#endif /* _TARCE */
+
+#ifndef SOL
+#define SOL ""
+#endif
+#define EOL "\n" /* for console */
+
+#ifdef MODULE
+/* omit full absolute path for modules */
+extern char *strrchr(const char *s, int c);
+#define ctracer_cut_path(fn) (fn[0] != '/' ? fn : (strrchr(fn, '/') + 1))
+#define __file__	ctracer_cut_path(__FILE__)
+#else
+#define __file__	__FILE__
+#endif
+
+#ifdef TRACE_MALLOC
+static int malloc_count;
+static void *malloc_trace;
+#endif
+#ifdef TRACE_MALLOC
+
+#define malloc(s) \
+	(trla("malloc #%i %p %i\n", ++malloc_count, malloc_trace = malloc(s), s),\
+	malloc_trace)
+
+#define free(p) { free(p); trla("free   #%i %p\n", malloc_count--, (void *)p); }
+
+#define strdup(s) \
+	(trla("strdup #%i %p\n", ++malloc_count, malloc_trace = (void *)strdup(s)),\
+	(char *)malloc_trace)
+
+#endif
+
+#ifdef TRACE_TIME
+
+#include <time.h>
+#include <sys/time.h>
+
+#ifndef trace_time_defined
+#define trace_time_defined
+
+void trace_time();
+/*
+extern double time_prev_f;
+void static inline trace_time()
+{
+	time_t time_cur;
+	double time_cur_f;
+	time(&time_cur);
+	struct timeval tv;
+	struct timezone tz;
+	struct tm* time_tm;
+	gettimeofday(&tv, &tz);
+	time_tm = localtime(&time_cur);
+	time_cur = tv.tv_sec;
+	time_cur_f = 0.000001 * tv.tv_usec + time_cur;
+	double passed = time_cur_f - time_prev_f;
+	if (passed > 0.001)
+	{
+		tracef("time=%04d-%02d-%02d %02d:%02d:%02d %02d +%1.4f s\n",
+				time_tm->tm_year+1900, time_tm->tm_mon+1, time_tm->tm_mday,
+				time_tm->tm_hour, time_tm->tm_min, time_tm->tm_sec, (int)tv.tv_usec,
+				passed);
+		time_prev_f = time_cur_f;
+	}
+}
+*/
+#endif
+
+#else
+#define trace_time() empty_statement()
+#endif
+
+#ifdef __GLIBC__XX
+#include <execinfo.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+#ifdef stack_trace
+#undef stack_trace
+#endif
+#ifndef stack_trace_difined
+#define stack_trace_difined
+/* only once */
+static inline void stack_trace(void)
+{
+	void *array[5];
+	size_t size;
+	char **strings;
+	size_t i;
+	size = backtrace(array, sizeof(array) / sizeof(array[0]));
+	strings = backtrace_symbols(array, size);
+	tracef("Stack:\n");
+
+	for (i = 0; i < size; i++) {
+		if (!array[i])
+			break;
+		tracef("%i %p %s\n", i, array[i], strings[i]);
+	}
+	free(strings);
+}
+#endif
+#endif /* __GLIBC__ */
+
+/* see also nr_free_pages */
+#define freeram() { \
+	static unsigned int last; struct sysinfo i; si_meminfo(&i); trl_(); \
+	int d = last-i.freeram; int used = i.totalram-i.freeram; \
+	trvi_(i.freeram); trvi_(used);  trvi(d); \
+	last = i.freeram; }
+
+extern int sprint_symbol_no_offset(char *buffer, unsigned long address);
+
+static inline void __on_cleanup(char *s[])
+{
+#ifdef __KERNEL__
+	printk(KERN_DEBUG"%s", *s);
+#else
+	fputs(*s, stderr);
+#endif
+}
+
+#if !defined(__KERNEL__) || defined(MODULE)
+static inline int lookup_symbol_name(unsigned long addr, char *symbol)
+{
+	return sprintf(symbol, "%lx", addr);
+}
+#else
+int lookup_symbol_name(unsigned long addr, char *symname);
+#endif
+
+#define _trace_enter_exit_() char _caller[200]; \
+	lookup_symbol_name((unsigned long)__builtin_return_address(0), _caller); \
+	char __attribute__((cleanup(__on_cleanup))) *_s; \
+	char _ret_msg[100]; _s = _ret_msg; \
+	snprintf(_ret_msg, sizeof(_ret_msg), "%s < %s }\n", _caller, __func__); \
+	tracef(SOL"%s > %s { @ %s:%d", _caller, __func__, __file__, __LINE__);
+
+/*__END_DECLS */
+#endif /* CTRACER_H_INCLUDED */
+#endif /* __ASSEMBLY__ */
diff --git a/tools/testing/ldt/dio.c b/tools/testing/ldt/dio.c
new file mode 100644
index 0000000..79f3886
--- /dev/null
+++ b/tools/testing/ldt/dio.c
@@ -0,0 +1,362 @@
+/*
+ *	DIO - Device Input/Output utility for testing device drivers
+ *
+ *	stdin/stdout <--> dio <--> mmap, ioctl, read/write
+ *
+ *	Copyright (C) 2012 Constantine Shulyupin <const@makelinux.net>
+ *	http://www.makelinux.net/
+ *
+ *	Dual BSD/GPL License
+ *
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+#include <getopt.h>
+#include <string.h>
+#include <sys/param.h>
+#include <sys/poll.h>
+#include <sys/wait.h>
+#include <sys/types.h>
+#include <sys/time.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <sys/user.h>
+#include <time.h>
+#include <fcntl.h>
+#include <assert.h>
+#include <linux/ioctl.h>
+#include "ctracer.h"
+
+static enum io_type {
+	file_io,
+	mmap_io,
+	ioctl_io
+} io_type;
+
+static void *inbuf, *outbuf;
+static void *mm;
+static void *mem;
+static int buf_size;
+static int offset;
+static char *dev_name;
+static int ignore_eof;
+static int ioctl_num;
+static int loops;
+static int delay;
+static char ioctl_type = 'A';
+__thread int ret;
+static int ro, wo; /* read only, write only*/
+
+/*
+#define VERBOSE
+*/
+
+int output(int dev, void *buf, int size)
+{
+#ifdef VERBOSE
+_entry:
+	trl_();
+	trvd(size);
+#endif
+	ret = 0;
+	if (dev < 0 || ro)
+		return 0;
+	switch (io_type) {
+	case mmap_io:
+		memcpy(mem, buf, size);
+		ret = size;
+		break;
+	case ioctl_io:
+		ioctl(dev, _IOC(_IOC_WRITE, ioctl_type, ioctl_num, size & _IOC_SIZEMASK), buf);
+		break;
+	case file_io:
+	default:
+		ret = write(dev, buf, size);
+	}
+	return ret;
+}
+
+int input(int dev, void *buf, int size)
+{
+	ret = 0;
+#ifdef VERBOSE
+_entry:
+	trl_();
+	trvd(size);
+#endif
+	if (dev < 0 || wo)
+		return 0;
+	switch (io_type) {
+	case mmap_io:
+		memcpy(buf, mem, size);
+		ret = size;
+		break;
+	case ioctl_io:
+		ioctl(dev, _IOC(_IOC_READ, ioctl_type, ioctl_num, size & _IOC_SIZEMASK), buf);
+		ret = size;
+		break;
+	case file_io:
+	default:
+		ret = read(dev, buf, size);
+	}
+	return ret;
+}
+
+int io_start(int dev)
+{
+	struct pollfd pfd[2];
+	ssize_t data_in_len, data_out_len, len_total = 0;
+	int i = 0;
+
+	/* TODO: wo, ro */
+	pfd[0].fd = fileno(stdin);
+	pfd[0].events = POLLIN;
+	pfd[1].fd = dev;
+	pfd[1].events = POLLIN;
+	while (poll(pfd, sizeof(pfd) / sizeof(pfd[0]), -1) > 0) {
+#ifdef VERBOSE
+		trvd_(i);
+		trvx_(pfd[0].revents);
+		trvx_(pfd[1].revents);
+		trln();
+#endif
+		data_in_len = 0;
+		if (pfd[0].revents & POLLIN) {
+			pfd[0].revents = 0;
+			ret = data_in_len = read(fileno(stdin), inbuf, buf_size);
+			if (data_in_len < 0) {
+				usleep(100000);
+				break;
+			}
+			if (!data_in_len && !ignore_eof) {
+				/* read returns 0 on End Of File */
+				break;
+			}
+#ifdef VERBOSE
+			trvd_(data_in_len);
+			trln();
+#endif
+again:
+			chkne(ret = output(dev, inbuf, data_in_len));
+			if (ret < 0 && errno == EAGAIN) {
+				usleep(100000);
+				goto again;
+			}
+			if (data_in_len > 0)
+				len_total += data_in_len;
+		}
+		data_out_len = 0;
+		if (pfd[1].revents & POLLIN) {
+			pfd[1].revents = 0;
+			chkne(ret = data_out_len = input(dev, outbuf, buf_size));
+			if (data_out_len < 0) {
+				usleep(100000);
+				break;
+			}
+			if (!data_out_len) {
+				/* EOF, don't expect data from the file any more
+				   but wee can continue to write */
+				pfd[1].events = 0;
+			}
+			if (!data_out_len && !ignore_eof) {
+				/* read returns 0 on End Of File */
+				break;
+			}
+			write(fileno(stdout), outbuf, data_out_len);
+			if (data_out_len > 0)
+				len_total += data_out_len;
+		}
+#ifdef VERBOSE
+		trl_();
+		trvd_(i);
+		trvd_(len_total);
+		trvd_(data_in_len);
+		trvd_(data_out_len);
+		trln();
+#endif
+		if ((!ignore_eof && pfd[0].revents & POLLHUP) || pfd[1].revents & POLLHUP)
+			break;
+		i++;
+		if (loops && i >= loops)
+			break;
+		usleep(1000 * delay);
+	}
+#ifdef VERBOSE
+	trl_();
+	trvd_(i);
+	trvd_(len_total);
+	trvd_(data_in_len);
+	trvd_(data_out_len);
+	trln();
+#endif
+	return ret;
+}
+
+#define add_literal_option(o)  do { options[optnum].name = #o; \
+	options[optnum].flag = (void *)&o; options[optnum].has_arg = 1; \
+	options[optnum].val = -1; optnum++; } while (0)
+
+#define add_flag_option(n, p, v) do { options[optnum].name = n; \
+	options[optnum].flag = (void *)p; options[optnum].has_arg = 0; \
+	options[optnum].val = v; optnum++; } while (0)
+
+static struct option options[100];
+int optnum;
+static int verbose;
+
+int options_init()
+{
+	optnum = 0;
+	/* on gcc 64, pointer to variable can be used only on run-time
+	 */
+	memset(options, 0, sizeof(options));
+	add_literal_option(io_type);
+	add_literal_option(buf_size);
+	add_literal_option(ioctl_num);
+	add_literal_option(ioctl_type);
+	add_literal_option(loops);
+	add_literal_option(delay);
+	add_literal_option(offset);
+	add_flag_option("ioctl", &io_type, ioctl_io);
+	add_flag_option("mmap", &io_type, mmap_io);
+	add_flag_option("file", &io_type, file_io);
+	add_flag_option("ignore_eof", &ignore_eof, 1);
+	add_flag_option("verbose", &verbose, 1);
+	add_flag_option("ro", &ro, 1);
+	add_flag_option("wo", &wo, 1);
+	options[optnum].name = strdup("help");
+	options[optnum].has_arg = 0;
+	options[optnum].val = 'h';
+	optnum++;
+	return optnum;
+}
+
+/*
+ * expand_arg, return_if_arg_is_equal - utility functions
+ * to translate command line parameters
+ * from string to numeric values using predefined preprocessor defines
+ */
+
+#define return_if_arg_is_equal(entry) do { if (0 == strcmp(arg, #entry)) return entry; } while (0)
+
+int expand_arg(char *arg)
+{
+	if (!arg)
+		return 0;
+/*
+	return_if_arg_is_equal(SOCK_STREAM);
+*/
+	return strtol(arg, NULL, 0);
+}
+
+char *usage = "dio - Device Input/Output utility\n\
+Usage:\n\
+	dio <options> <device file>\n\
+\n\
+options:\n\
+\n\
+default values are marked with '*'\n\
+\n\
+	-h | --help\n\
+		show this help\n\
+\n\
+	--buf_size <n> \n\
+		I/O buffer size\n\
+\n\
+Samples:\n\
+\n\
+TBD\n\
+\n\
+";
+
+int init(int argc, char *argv[])
+{
+	int opt = 0;
+	int longindex = 0;
+	options_init();
+	opterr = 0;
+	while ((opt = getopt_long(argc, argv, "h", options, &longindex)) != -1) {
+		switch (opt) {
+		case 0:
+			if (options[longindex].val == -1)
+				*options[longindex].flag = expand_arg(optarg);
+			break;
+		case 'h':
+			printf("%s", usage);
+			exit(0);
+			break;
+		default:	/* '?' */
+			printf("Error in arguments\n");
+			trvx(opt);
+			exit(EXIT_FAILURE);
+		}
+	}
+	if (optind < argc)
+		dev_name = argv[optind];
+	if (io_type == ioctl_io && buf_size >= 1 << _IOC_SIZEBITS)
+		fprintf(stderr, "WARNING: size of ioctl data it too big\n");
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int dev;
+
+	buf_size = sysconf(_SC_PAGESIZE);
+	init(argc, argv);
+	verbose && fprintf(stderr, "%s compiled " __DATE__ " " __TIME__ "\n", argv[0]);
+	if (io_type == ioctl_io && buf_size >= 1 << _IOC_SIZEBITS)
+		buf_size = (1 << _IOC_SIZEBITS) - 1;
+	inbuf = malloc(buf_size);
+	outbuf = malloc(buf_size);
+	chkne(dev = open(dev_name, O_CREAT | O_RDWR, 0666));
+	if (io_type == mmap_io) {
+		mm = mmap(NULL, buf_size, PROT_READ | PROT_WRITE, MAP_SHARED, dev, offset & ~(sysconf(_SC_PAGESIZE)-1));
+		if (mm == MAP_FAILED) {
+			warn("mmap() failed");
+			goto exit;
+		}
+		mem = mm + (offset & (sysconf(_SC_PAGESIZE)-1));
+	}
+	if (verbose) {
+		trvs_(dev_name);
+		trvd_(io_type);
+		trvd_(buf_size);
+		trvd_(ignore_eof);
+		trvd_(verbose);
+		trvp_(mm);
+		trvp_(mem);
+		trln();
+	}
+	switch (io_type) {
+	case mmap_io:
+	case ioctl_io:
+		if (!ro) {
+			chkne(ret = read(fileno(stdin), inbuf, buf_size));
+			if (ret < 0)
+				goto exit;
+			chkne(ret = output(dev, inbuf, ret));
+		}
+		if (!wo) {
+			chkne(ret = input(dev, outbuf, buf_size));
+			if (ret < 0)
+				goto exit;
+			write(fileno(stdout), outbuf, ret);
+		}
+		break;
+	case file_io:
+	default:
+		io_start(dev);
+	}
+exit:
+	if (mm && mm != MAP_FAILED)
+		munmap(mm, buf_size);
+	free(outbuf);
+	free(inbuf);
+	close(dev);
+	exit(EXIT_SUCCESS);
+}
diff --git a/tools/testing/ldt/ldt-test b/tools/testing/ldt/ldt-test
new file mode 100755
index 0000000..9e84a6f
--- /dev/null
+++ b/tools/testing/ldt/ldt-test
@@ -0,0 +1,142 @@
+#!/bin/bash
+
+#
+#	LDT - Linux Driver Template
+#
+#	Test script
+#
+#	Copyright (C) 2012 Constantine Shulyupin  http://www.makelinux.net/
+#
+#	Dual BSD/GPL License
+#
+
+RED="\\033[0;31m"
+NOCOLOR="\\033[0;39m"
+GREEN="\\033[0;32m"
+GRAY="\\033[0;37m"
+
+set -o errtrace
+debugfs=`grep debugfs /proc/mounts | awk '{ print $2; }'`
+tracing=$debugfs/tracing
+
+tracing()
+{
+	sudo sh -c "cd $tracing; $1" || true
+}
+
+tracing_start()
+{
+	tracing "echo :mod:ldt > set_ftrace_filter"
+	tracing "echo function > current_tracer" # need for draw_functrace.py
+	#tracing "echo function_graph > current_tracer"
+	tracing "echo 1 > function_profile_enabled"
+	# useful optional command:
+	#tracing "echo XXX > set_ftrace_notrace"
+	#sudo cat $tracing/current_tracer
+	#sudo cat $tracing/set_ftrace_filter
+	#sudo cat $tracing/function_profile_enabled
+	# available_filter_functions
+	# echo $$ > set_ftrace_pid
+}
+
+tracing_stop()
+{
+	( echo Profiling data per CPU
+	tracing "cat trace_stat/function*" )> trace_stat.log && echo trace_stat.log saved
+	tracing "echo 0 > function_profile_enabled"
+	sudo cp $tracing/trace ftrace.log && echo ftrace.log saved
+	sudo dd iflag=nonblock if=$tracing/trace_pipe 2> /dev/null > trace_pipe.log || true && echo trace_pipe.log saved
+	tracing "echo nop > current_tracer"
+	#export PYTHONPATH=/usr/src/linux-headers-$(uname -r)/scripts/tracing/
+	# draw_functrace.py needs function tracer
+	python /usr/src/linux-headers-$(uname -r)/scripts/tracing/draw_functrace.py \
+		< trace_pipe.log > functrace.log && echo functrace.log saved || true
+}
+
+# sudo rmmod parport_pc parport  ppdev lp
+sudo dmesg -n 7
+sudo rmmod ldt ldt_plat_dev 2> /dev/null
+sudo dmesg -c > /dev/null
+stty -F /dev/ttyS0 115200
+make -s
+set -o errexit
+
+#
+# Check for presence looback on /dev/ttyS0.
+# If loopback is not present, switch loopback on in the driver
+#
+
+data='loopback?'
+received=`echo $data | ./dio  --ignore_eof --loops 2 --delay 10 /dev/ttyS0 2> /dev/null`
+if [ "$data" == "$received" ]; then
+echo -e "Loopback on /dev/ttyS0 detected"
+loopback=0
+else
+echo -e "No loopback behind /dev/ttyS0 detected, running ldt driver with UART in loopback mode"
+loopback=1
+fi
+
+# clean data
+echo | ./dio  --ignore_eof --loops 10 --delay 10 /dev/ttyS0 2> /dev/null > /dev/null
+
+sudo modprobe ldt loopback=$loopback
+sudo modprobe ldt_plat_dev
+
+tracing_start || true
+sudo sh -c "chmod go+rw /dev/ldt*"
+data=123rw
+echo $data > /dev/ldt
+sleep 0.5
+received=`dd iflag=nonblock if=/dev/ldt 2> /dev/null || true`
+if [ "$data" == "$received" ]; then
+echo -e "${GREEN}LDT nonblocking read/write test passed$NOCOLOR"
+else
+echo -e "${RED}LDT nonblock read/write test failed$NOCOLOR"
+echo expected $data
+echo received $received
+fi
+
+data=123bl
+cat /dev/ldt > R.tmp &
+sleep 0.5; echo $data > /dev/ldt;
+sleep 0.5
+kill %1; wait %1 2> /dev/null || true
+received=`cat R.tmp`
+rm -f R.tmp
+
+if [ "$data" == "$received" ]; then
+echo -e "${GREEN}LDT blocking read/write test passed$NOCOLOR"
+else
+echo -e "${RED}LDT blocking read/write test failed$NOCOLOR"
+echo expected $data
+echo received $received
+fi
+
+data=123mmap
+received=`sudo echo $data | ./dio --mmap /dev/ldt`
+if [ "$data" == "$received" ]; then
+echo -e "${GREEN}LDT mmap test passed$NOCOLOR"
+else
+echo -e "${RED}LDT mmap test failed$NOCOLOR"
+echo expected $data
+echo received $received
+fi
+
+data=123ioctl
+received=`sudo echo $data | ./dio --ioctl /dev/ldt`
+if [ "$data" == "$received" ]; then
+echo -e "${GREEN}LDT ioctl test passed$NOCOLOR"
+else
+echo -e "${RED}LDT ioctl test failed$NOCOLOR"
+echo expected $data
+echo received $received
+fi
+
+sudo ls -l /sys/kernel/debug/ldt
+#grep ldt /proc/interrupts || true
+
+#sudo rmmod ldt ldt_plat_dev 2> /dev/null
+
+tracing_stop || true
+sudo dmesg --notime --show-delta --read-clear 2>/dev/null > kernel.log || \
+sudo dmesg -c > kernel.log && echo kernel.log saved
-- 
1.7.9.5

