Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2KNDmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 22:42:21 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43786 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab2KNDmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 22:42:19 -0500
Message-ID: <50A3130F.7010001@gmail.com>
Date: Wed, 14 Nov 2012 14:42:07 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Constantine Shulyupin <const@MakeLinux.com>
CC: linux-kernel@vger.kernel.org, celinux-dev@lists.celinuxforum.org,
        gregkh@linuxfoundation.org, Tim Bird <tim.bird@am.sony.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Selim TEMUR <selimtemur@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] LDT - Linux Driver Template
References: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
In-Reply-To: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/12 05:46, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> LDT is useful for Linux driver development beginners,
> hackers and as starting point for a new drivers.
> The driver uses following Linux facilities: module, platform driver,
> file operations (read/write, mmap, ioctl, blocking and nonblocking mode, polling),
> kfifo, completion, interrupt, tasklet, work, kthread, timer, simple misc device,
> multiple char devices, Device Model, configfs, UART 0x3f8,
> HW loopback, SW loopback, ftracer.
> 
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>

In general, since this is intended to be example code for beginner
developers, the code should have more comments explaining what each part
does. It should also try as hard as possible to conform to kernel coding
standards. I would suggest running it through checkpatch and sparse,
since those tools are often recommended to (new) kernel developers.

Some more comments below.

~Ryan

> ---
>  samples/Kconfig             |   14 +
>  samples/Makefile            |    5 +-
>  samples/ltd/Makefile        |    1 +
>  samples/ltd/ldt.c           |  764 +++++++++++++++++++++++++++++++++++++++++++
>  samples/ltd/ldt_plat_dev.c  |   68 ++++
>  tools/testing/ldt/Makefile  |    6 +
>  tools/testing/ldt/ctracer.h |  380 +++++++++++++++++++++
>  tools/testing/ldt/dio.c     |  362 ++++++++++++++++++++
>  tools/testing/ldt/ldt-test  |  142 ++++++++
>  9 files changed, 1740 insertions(+), 2 deletions(-)
>  create mode 100644 samples/ltd/Makefile
>  create mode 100644 samples/ltd/ldt.c
>  create mode 100644 samples/ltd/ldt_plat_dev.c
>  create mode 100644 tools/testing/ldt/Makefile
>  create mode 100644 tools/testing/ldt/ctracer.h
>  create mode 100644 tools/testing/ldt/dio.c
>  create mode 100755 tools/testing/ldt/ldt-test
> 
> diff --git a/samples/Kconfig b/samples/Kconfig
> index 7b6792a..2b93fd0 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -69,4 +69,18 @@ config SAMPLE_RPMSG_CLIENT
>  	  to communicate with an AMP-configured remote processor over
>  	  the rpmsg bus.
>  
> +config SAMPLE_DRIVER_TEMPLATE
> +	tristate "LDT - Linux driver template"
> +	help
> +	  Template of Linux device driver. Useful for Linux driver
> +	  development beginners, hackers and as starting point for a new drivers.
> +	  The driver uses following Linux facilities: module, platform driver,
> +	  file operations (read/write, mmap, ioctl, blocking and nonblocking mode, polling),
> +	  kfifo, completion, interrupt, tasklet, work, kthread, timer, simple misc device,
> +	  multiple char devices, Device Model, configfs, UART 0x3f8, HW loopback,
> +	  SW loopback, ftracer.
> +	  Usermode test script and utility are located in tools/testing/ldt/
> +
> +	  List of more samples and skeletons can be found at http://elinux.org/Device_drivers
> +
>  endif # SAMPLES
> diff --git a/samples/Makefile b/samples/Makefile
> index 5ef08bb..d4b1818 100644
> --- a/samples/Makefile
> +++ b/samples/Makefile
> @@ -1,4 +1,5 @@
>  # Makefile for Linux samples code
>  
> -obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ tracepoints/ trace_events/ \
> -			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/
> +obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ tracepoints/ trace_events/
> +obj-$(CONFIG_SAMPLES)	+= hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/
> +obj-$(CONFIG_SAMPLES)	+= ldt/
> diff --git a/samples/ltd/Makefile b/samples/ltd/Makefile
> new file mode 100644
> index 0000000..efd691f
> --- /dev/null
> +++ b/samples/ltd/Makefile
> @@ -0,0 +1 @@
> +obj-$(SAMPLE_DRIVER_TEMPLATE)+= ldt.o ldt_plat_dev.o
> diff --git a/samples/ltd/ldt.c b/samples/ltd/ldt.c
> new file mode 100644
> index 0000000..a4d2b3b
> --- /dev/null
> +++ b/samples/ltd/ldt.c
> @@ -0,0 +1,764 @@
> +/*
> + *	LDT - Linux Driver Template
> + *
> + *	Copyright (C) 2012 Constantine Shulyupin http://www.makelinux.net/
> + *
> + *	Dual BSD/GPL License
> + *
> + *
> + *	The driver demonstrates usage of following Linux facilities:
> + *
> + *	Linux kernel module
> + *	file_operations
> + *		read and write (UART)
> + *		blocking read
> + *		polling
> + *		mmap
> + *		ioctl
> + *	kfifo
> + *	completion
> + *	interrupt
> + *	tasklet
> + *	timer
> + *	work
> + *	kthread
> + *	simple single misc device file (miscdevice, misc_register)
> + *	multiple char device files (alloc_chrdev_region)
> + *	debugfs
> + *	platform_driver and platform_device in another module
> + *	simple UART driver on port 0x3f8 with IRQ 4
> + *	Device Model (class, device)
> + *	Power Management (dev_pm_ops)
> + *	Device Tree (of_device_id)
> + *
> + *	TODO:
> + *	linked list
> + *	private instance state struct
> + *
> + */
> +
> +#include <linux/io.h>
> +#include <linux/mm.h>
> +#include <linux/interrupt.h>
> +#include <linux/sched.h>
> +#include <linux/delay.h>
> +#include <linux/kthread.h>
> +#include <linux/timer.h>
> +#include <linux/kfifo.h>
> +#include <linux/fs.h>
> +#include <linux/poll.h>
> +#include <linux/module.h>
> +#include <linux/miscdevice.h>
> +#include <linux/platform_device.h>
> +#include <linux/serial_reg.h>
> +#include <linux/debugfs.h>
> +#include <linux/cdev.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/mod_devicetable.h>
> +
> +#define ctracer_cut_path(fn) (fn[0] != '/' ? fn : (strrchr(fn, '/') + 1))
> +#define __file__	ctracer_cut_path(__FILE__)
> +
> +/*
> + *	print_context prints execution context:
> + *	hard interrupt, soft interrupt or scheduled task
> + */
> +
> +#define print_context()	\
> +	pr_debug("%s:%d %s %s 0x%x\n", __file__, __LINE__, __func__, \
> +			(in_irq() ? "harirq" : current->comm), preempt_count());
> +
> +#define once(exp) do { \
> +	static int _passed; if (!_passed) { exp; }; _passed = 1; } while (0)
> +
> +#define check(a) \
> +	(ret = a, ((ret < 0) ? pr_warning("%s:%i %s FAIL\n\t%i=%s\n", \
> +	__file__, __LINE__, __func__, ret, #a) : 0), ret)
> +
> +#define pr_debug_hex(h)	pr_debug("%s:%d %s %s = 0x%lX\n", \
> +	__file__, __LINE__, __func__, #h, (long int)h)
> +#define pr_debug_dec(d)	pr_debug("%s:%d %s %s = %ld\n", \
> +	__file__, __LINE__, __func__, #d, (long int)d)
> +
> +#define pr_err_msg(m)	pr_err("%s:%d %s %s\n", __file__, __LINE__, __func__, m)

This is all extensively ugly.

> +
> +static char ldt_name[] = KBUILD_MODNAME;
> +static int bufsize = PFN_ALIGN(16 * 1024);
> +static void *in_buf;
> +static void *out_buf;
> +static int uart_detected;
> +void *port_ptr;

Having globals like this means that only one instance of the device can
be present, which is not true for many devices, and sets a bad example
for copy-pasters, which this is aimed at. The typical way to do this is
to have a struct:

	struct ldt_info {
		void *in_buf;
		void *out_buf;
		...
	};

And then allocate it in probe, and use dev_set_drvdata or similar to
associate it with the device.

> +
> +static int port;
> +module_param(port, int, 0);
> +static int port_size;
> +module_param(port_size, int, 0);
> +
> +static int irq;
> +module_param(irq, int, 0);
> +
> +static int loopback;
> +module_param(loopback, int, 0);
> +
> +static int isr_counter;
> +static int ldt_work_counter;
> +
> +#define FIFO_SIZE 128		/* should be power of two */
> +static DEFINE_KFIFO(in_fifo, char, FIFO_SIZE);
> +static DEFINE_KFIFO(out_fifo, char, FIFO_SIZE);
> +
> +static DECLARE_WAIT_QUEUE_HEAD(ldt_readable);
> +
> +static spinlock_t fifo_lock;
> +
> +
> +/*
> + *	ldt_received - called with data received from HW port
> + *	Called from tasklet, which is fired from ISR or timer
> + */
> +
> +static void ldt_received(void *data, int size)

Why the indents on the comments? Also, remove the blank lines between
the comments and the first line of the function.

Since this is example code, it should probably use proper kerneldoc
formatted comments.

> +{
> +	kfifo_in_spinlocked(&in_fifo, data, size, &fifo_lock);
> +	wake_up_interruptible(&ldt_readable);
> +}
> +
> +/*
> + *	ldt_send - send data to HW port or emulated SW loopback
> + */
> +
> +static void ldt_send(void *data, int size)
> +{
> +	if (uart_detected) {
> +		if (ioread8(port_ptr + UART_LSR) & UART_LSR_THRE)
> +			iowrite8(*(char *)data, port_ptr + UART_TX);
> +		else
> +			pr_err_msg("overflow");
> +	} else
> +		/* emulate loopback  */

Braces should be used for single lines on the 'else' if the 'if' part
also need braces. Note that comments are not statements, so the
indentation here is misleading, it is actually interpreted as:

	if (uart_detected) {
		...
	} else if (loopback) {
		...
	}

Which may not be what you want (and certainly isn't what the code layout
suggests).

> +	if (loopback)
> +		ldt_received(data, size);
> +}
> +
> +/*
> + *	work
> + */

Useless comment.

> +
> +static void ldt_work_func(struct work_struct *work)
> +{
> +	once(print_context());
> +	ldt_work_counter++;
> +}
> +
> +DECLARE_WORK(ldt_work, ldt_work_func);

This should have static to stop it polluting the global namespace. Even
better, it should be moved into a priv struct. Also, all global data
should really be declared at the top of the file, unless there is a good
reason not to do so.

> +
> +/*
> + *	tasklet
> + */
> +

More useless comments.

> +static DECLARE_COMPLETION(ldt_complete);
> +
> +#define tx_ready()	(ioread8(port_ptr + UART_LSR) & UART_LSR_THRE)
> +#define rx_ready()	(ioread8(port_ptr + UART_LSR) & UART_LSR_DR)

Stuff like this should be functions, not macros.

> +
> +static void ldt_tasklet_func(unsigned long d)
> +{
> +	char data_out, data_in;

Blank line between variable declarations and code.

> +	once(print_context());
> +	if (uart_detected) {
> +		while (tx_ready() && kfifo_out_spinlocked(&out_fifo, &data_out, sizeof(data_out), &fifo_lock)) {

Lines should be split to fit inside 80 columns.

> +			pr_debug_hex(ioread8(port_ptr + UART_LSR));
> +			pr_debug_dec(data_out);
> +			if (data_out >= 32)
> +				pr_debug("data_out = '%c' ", data_out);
> +			ldt_send(&data_out, sizeof(data_out));
> +		}
> +		while (rx_ready()) {
> +			pr_debug_hex(ioread8(port_ptr + UART_LSR));
> +			data_in = ioread8(port_ptr + UART_RX);
> +			pr_debug_dec(data_in);
> +			if (data_in >= 32)
> +				pr_debug("data_out = '%c' ", data_in);
> +			ldt_received(&data_in, sizeof(data_in));
> +		}
> +	} else {
> +		while (kfifo_out_spinlocked(&out_fifo, &data_out, sizeof(data_out), &fifo_lock)) {
> +			pr_debug_dec(data_out);
> +			ldt_send(&data_out, sizeof(data_out));
> +		}
> +	}
> +	schedule_work(&ldt_work);
> +	complete(&ldt_complete);
> +}
> +
> +static DECLARE_TASKLET(ldt_tasklet, ldt_tasklet_func, 0);
> +
> +/*
> + *	interrupt
> + */
> +
> +static irqreturn_t ldt_isr(int irq, void *dev_id, struct pt_regs *regs)
> +{
> +	/*
> +	 *      UART interrupt is not fired in loopback mode,
> +	 *      therefore fire ldt_tasklet from timer too
> +	 */
> +	once(print_context());
> +	isr_counter++;
> +	pr_debug_hex(ioread8(port_ptr + UART_FCR));
> +	pr_debug_hex(ioread8(port_ptr + UART_IIR));
> +	tasklet_schedule(&ldt_tasklet);
> +	return IRQ_HANDLED;	/* our IRQ */
> +}
> +
> +/*
> + *	timer
> + */
> +
> +static struct timer_list ldt_timer;
> +static void ldt_timer_func(unsigned long data)
> +{
> +	/*
> +	 *      this timer is used just to fire ldt_tasklet,
> +	 *      when there is no interrupt in loopback mode
> +	 */
> +	if (loopback)
> +		tasklet_schedule(&ldt_tasklet);
> +	mod_timer(&ldt_timer, jiffies + HZ / 100);
> +}
> +
> +static DEFINE_TIMER(ldt_timer, ldt_timer_func, 0, 0);
> +
> +/*
> + *	file_operations
> + */
> +
> +static int ldt_open(struct inode *inode, struct file *file)
> +{
> +	print_context();
> +	pr_debug_dec(imajor(inode));
> +	pr_debug_dec(iminor(inode));
> +	pr_debug_hex(file->f_flags & O_NONBLOCK);
> +	return 0;
> +}
> +
> +static int ldt_release(struct inode *inode, struct file *file)
> +{
> +	print_context();
> +	pr_debug_dec(imajor(inode));
> +	pr_debug_dec(iminor(inode));
> +	pr_debug_dec(isr_counter);
> +	pr_debug_dec(ldt_work_counter);
> +	return 0;
> +}
> +
> +/*
> + *	read
> + */
> +
> +static DEFINE_MUTEX(read_lock);
> +
> +static ssize_t ldt_read(struct file *file, char __user * buf, size_t count, loff_t * ppos)
> +{
> +	int ret;
> +	unsigned int copied;
> +	if (kfifo_is_empty(&in_fifo)) {

Doesn't this require locking against whatever is filling the fifo?

> +		if (file->f_flags & O_NONBLOCK) {
> +			ret = -EAGAIN;
> +			goto exit;

	return -EAGAIN;

> +		} else {
> +			pr_err_msg("waiting");
> +			ret = wait_event_interruptible(ldt_readable, !kfifo_is_empty(&in_fifo));
> +			if (ret == -ERESTARTSYS) {
> +				pr_err_msg("interrupted");
> +				ret = -EINTR;
> +				goto exit;

	return -EINTR;

> +			}
> +		}
> +	}
> +	if (mutex_lock_interruptible(&read_lock)) {
> +		pr_err_msg("interrupted");
> +		return -EINTR;
> +	}
> +	ret = kfifo_to_user(&in_fifo, buf, count, &copied);
> +	mutex_unlock(&read_lock);

The read_lock is only used here, so would only protect against
concurrent reads. Isn't the read for a device function already
synchronised against itself by the caller?

> +exit:
> +	return ret ? ret : copied;
> +}
> +
> +/*
> + *	write
> + */
> +
> +static DEFINE_MUTEX(write_lock);
> +
> +static ssize_t ldt_write(struct file *file, const char __user * buf, size_t count, loff_t * ppos)
> +{
> +	int ret;
> +	unsigned int copied;
> +	/* TODO: wait_event_interruptible ... ldt_writeable */
> +	if (mutex_lock_interruptible(&write_lock))
> +		return -EINTR;
> +	ret = kfifo_from_user(&out_fifo, buf, count, &copied);
> +	mutex_unlock(&write_lock);
> +	tasklet_schedule(&ldt_tasklet);
> +	return ret ? ret : copied;

Shouldn't this function be grabbing fifo_lock to prevent concurrent
access to the fifo by the tasklet function? write_lock has the same
issues described for read_lock above.

> +}
> +
> +/*
> + *	polling
> + */
> +
> +static unsigned int ldt_poll(struct file *file, poll_table * pt)
> +{
> +	unsigned int mask = 0;
> +	poll_wait(file, &ldt_readable, pt);
> +	/*poll_wait(file, ldt_writeable, pt); TODO */
> +
> +	if (!kfifo_is_empty(&in_fifo))

Locking?

> +		mask |= POLLIN | POLLRDNORM;
> +	mask |= POLLOUT | POLLWRNORM;
> +#if 0
> +	mask |= POLLHUP;	/* on output eof */
> +	mask |= POLLERR;	/* on output error */
> +#endif

TODO comments, and #if 0 blocks are extremly confusing in example code,
especially when they lack any real explanation.

> +	pr_debug_hex(mask);
> +	return mask;
> +}
> +
> +/*
> + *	pages_flag - set or clear a flag for sequence of pages
> + *
> + *	more generic solution instead SetPageReserved, ClearPageReserved etc
> + */
> +
> +void pages_flag(struct page *page, int pages, int mask, int value)

Should be static. I don't think this function should exists, especially
not as example code.

> +{
> +	for (; pages; pages--, page++)

page and pages is really confusing. Maybe page and num_pages would be
better?

> +		if (value)
> +			__set_bit(mask, &page->flags);
> +		else
> +			__clear_bit(mask, &page->flags);
> +}
> +
> +/*
> + *	mmap
> + */
> +static int ldt_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +	void *buf = NULL;
> +	if (vma->vm_flags & VM_WRITE)
> +		buf = in_buf;
> +	else if (vma->vm_flags & VM_READ)
> +		buf = out_buf;
> +	if (!buf)
> +		return -EINVAL;
> +	if (remap_pfn_range(vma, vma->vm_start, virt_to_phys(buf) >> PAGE_SHIFT,
> +			    vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
> +		pr_err_msg("remap_pfn_range failed");
> +		return -EAGAIN;
> +	}
> +	return 0;
> +}
> +
> +/*
> + *	ioctl
> + */
> +
> +#define trace_ioctl(nr) printk("ioctl=(%c%c %c #%i %i)\n", \
> +	(_IOC_READ & _IOC_DIR(nr)) ? 'r' : ' ', (_IOC_WRITE & _IOC_DIR(nr)) ? 'w' : ' ', \
> +	_IOC_TYPE(nr), _IOC_NR(nr), _IOC_SIZE(nr))
> +
> +static long ldt_ioctl(struct file *f, unsigned int cmnd, unsigned long arg)
> +{
> +	void __user *user = (void *)arg;
> +	pr_debug_hex(cmnd);
> +	pr_debug_hex(arg);
> +	trace_ioctl(cmnd);
> +	if (_IOC_DIR(cmnd) == _IOC_WRITE) {
> +		copy_from_user(in_buf, user, _IOC_SIZE(cmnd));
> +		memcpy(out_buf, in_buf, bufsize);
> +		memset(in_buf, 0, bufsize);
> +	}
> +	if (_IOC_DIR(cmnd) == _IOC_READ) {
> +		copy_to_user(user, out_buf, _IOC_SIZE(cmnd));
> +		memset(out_buf, 0, bufsize);
> +	}

Locking for the kfifo accesses?

> +	switch (_IOC_TYPE(cmnd)) {
> +	case 'A':
> +		switch (_IOC_NR(cmnd)) {
> +		case 0:
> +			break;
> +		}
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static const struct file_operations ldt_fops = {
> +	.owner = THIS_MODULE,
> +	.open = ldt_open,
> +	.release = ldt_release,
> +	.read = ldt_read,
> +	.write = ldt_write,
> +	.poll = ldt_poll,
> +	.mmap = ldt_mmap,
> +	.unlocked_ioctl = ldt_ioctl,

Tabify would be nice:

	.owner		= THIS_MODULE,
	.open		= ldt_open,
	.release	= ldt_release,
	...

> +};
> +
> +#ifdef USE_MISCDEV

Should be a Kconfig option?

> +/*
> + *	use miscdevice for single instance device
> + */
> +static struct miscdevice ldt_miscdev = {
> +	MISC_DYNAMIC_MINOR,
> +	ldt_name,
> +	&ldt_fops,
> +};

Use a C99 initialiser.

> +#else
> +/*
> + *	used cdev and device for multiple instances device
> + */
> +
> +static int devs = 8;
> +module_param(devs, int, 0);

MODULE_PARM_DESC?

> +
> +static struct cdev ldt_cdev;
> +static struct class *ldt_class;
> +static struct device *ldt_dev;
> +#if 0
> +static char *ldt_devnode(struct device *dev, umode_t * mode)
> +{
> +	if (mode)
> +		*mode = S_IRUGO | S_IWUGO;
> +	/* *mode = 0666; */
> +	return NULL;
> +}
> +#endif

Why is this commented out?

> +#endif
> +
> +/*
> + *	kthread
> + */
> +
> +static int ldt_thread_sub(void *data)
> +{
> +	int ret = 0;
> +	/*
> +	   perform here a useful work in task context
> +	 */
> +	return ret;
> +}

This seems fairly pointless. The ldt_thread function is the important
bit. A simple thread might do all of its processing there. This implies
that a sub-function is always required.

> +
> +static int ldt_thread(void *data)
> +{
> +	int ret = 0;
> +	print_context();
> +	allow_signal(SIGINT);
> +	while (!kthread_should_stop()) {
> +		ret = wait_for_completion_interruptible(&ldt_complete);
> +		if (ret == -ERESTARTSYS) {
> +			pr_err_msg("interrupted");
> +			ret = -EINTR;
> +			break;
> +		}
> +		ret = ldt_thread_sub(data);
> +	}
> +	return ret;
> +}
> +
> +/*
> + *	UART
> + */
> +
> +static struct resource *port_r;
> +
> +static int uart_probe(void)
> +{
> +	int ret = 0;
> +	if (port) {
> +		port_ptr = ioport_map(port, port_size);

Error checking?

> +		pr_debug_hex(port_ptr);
> +		port_r = request_region(port, port_size, ldt_name);
> +		pr_debug_hex(port_r);
> +		/* ignore error */

Why ignore errors? This just encourages driver developers using this
example to do the same.

> +	}
> +	if (irq) {
> +		ret = check(request_irq(irq, (void *)ldt_isr, IRQF_SHARED, ldt_name, THIS_MODULE));

Get rid of the check macro and do some proper error checking. Why is the
second argument being cast as void *?

> +		iowrite8(UART_MCR_RTS | UART_MCR_OUT2 | UART_MCR_LOOP, port_ptr + UART_MCR);
> +		uart_detected = (ioread8(port_ptr + UART_MSR) & 0xF0) == (UART_MSR_DCD | UART_MSR_CTS);
> +		pr_debug_hex(ioread8(port_ptr + UART_MSR));
> +
> +		if (uart_detected) {
> +			/*iowrite8(UART_IER_MSI | UART_IER_THRI |  UART_IER_RDI | UART_IER_RLSI, port_ptr + UART_IER); */
> +			iowrite8(UART_IER_RDI | UART_IER_RLSI | UART_IER_THRI, port_ptr + UART_IER);
> +			iowrite8(UART_MCR_DTR | UART_MCR_RTS | UART_MCR_OUT2, port_ptr + UART_MCR);
> +			iowrite8(UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT, port_ptr + UART_FCR);
> +			pr_debug_dec(loopback);
> +			if (loopback)
> +				iowrite8(ioread8(port_ptr + UART_MCR) | UART_MCR_LOOP, port_ptr + UART_MCR);

Break these lines up to get them under 80 columns.

> +		}
> +		if (!uart_detected && loopback) {
> +			pr_warn("Emulating loopback in software\n");
> +			ret = -ENODEV;
> +		}
> +	}
> +	pr_debug_hex(uart_detected);
> +	pr_debug_hex(ioread8(port_ptr + UART_IER));
> +	pr_debug_hex(ioread8(port_ptr + UART_IIR));
> +	pr_debug_hex(ioread8(port_ptr + UART_FCR));
> +	pr_debug_hex(ioread8(port_ptr + UART_LCR));
> +	pr_debug_hex(ioread8(port_ptr + UART_MCR));
> +	pr_debug_hex(ioread8(port_ptr + UART_LSR));
> +	pr_debug_hex(ioread8(port_ptr + UART_MSR));
> +	return ret;
> +}
> +
> +static struct task_struct *thread;
> +static struct dentry *debugfs;
> +static int major;
> +
> +int chrdev_region_init(char *dev_name)
> +{
> +	int ret;
> +	int d;

Same type variables can go on one line.

> +	dev_t devid;
> +	devid = MKDEV(major, 0);
> +	ret = check(alloc_chrdev_region(&devid, 0, devs, dev_name));
> +	major = MAJOR(devid);
> +	pr_debug_dec(major);
> +	cdev_init(&ldt_cdev, &ldt_fops);
> +	check(cdev_add(&ldt_cdev, MKDEV(major, 0), devs));
> +	ldt_class = class_create(THIS_MODULE, dev_name);
> +	/* ldt_class->devnode = ldt_devnode; */
> +	ldt_dev = device_create(ldt_class, NULL, devid, NULL, "%s", dev_name);
> +	for (d = 1; d < devs; d++)
> +		device_create(ldt_class, NULL, MKDEV(major, d), NULL, "%s%d", dev_name, d);
> +	pr_debug_dec(IS_ERR(ldt_dev));
> +	pr_debug_hex(ldt_dev);
> +	return major;
> +}
> +
> +/*
> + *	ldt_probe - main initialization function
> + */
> +
> +static __devinit int ldt_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	char *data = NULL;
> +	struct resource *r;
> +	print_context();
> +	printk(KERN_DEBUG"%s %s %s", ldt_name, __DATE__, __TIME__);
> +	printk(KERN_DEBUG"pdev = %p ", pdev);

Use pr_debug. Don't use __DATE__ and __TIME__, the person should know
when they build their code.

> +	pr_debug_dec(irq);
> +	pr_debug_dec(bufsize);
> +	in_buf = alloc_pages_exact(bufsize, GFP_KERNEL | __GFP_ZERO);
> +	if (!in_buf) {
> +		ret = -ENOMEM;
> +		goto exit;
> +	}
> +	pages_flag(virt_to_page(in_buf), PFN_UP(bufsize), PG_reserved, 1);
> +	out_buf = alloc_pages_exact(bufsize, GFP_KERNEL | __GFP_ZERO);

alloc_pages_exact is not used by very many drivers, and none of the uses
appear to be for kfifos. This sets a potentially bad example for driver
writers. Any reason this can't be kzalloc?

> +	if (!out_buf) {
> +		ret = -ENOMEM;
> +		goto exit;
> +	}
> +	pages_flag(virt_to_page(out_buf), PFN_UP(bufsize), PG_reserved, 1);
> +	if (pdev) {
> +		dev_dbg(&pdev->dev, "%s:%d %s attaching driver\n", __file__, __LINE__, __func__);
> +		pr_debug_hex(pdev->dev.of_node);
> +#ifdef CONFIG_OF_DEVICE
> +		check(of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev));
> +#endif
> +		data = pdev->dev.platform_data;

Use dev_get_platdata(&pdev->dev);

> +		printk("%p %s\n", data, data);
> +		if (!irq)
> +			irq = platform_get_irq(pdev, 0);
> +		r = platform_get_resource(pdev, IORESOURCE_IO, 0);

If this fails, shouldn't the probe fail?

> +		if (r && !port)
> +			port = r->start;
> +
> +		if (r && !port_size)
> +			port_size = resource_size(r);
> +	}
> +	isr_counter = 0;
> +	uart_probe();

uart_probe returns a value, which is not checked here?

> +	/* proc_create(ldt_name, 0, NULL, &ldt_fops); depricated */
> +	mod_timer(&ldt_timer, jiffies + HZ / 10);
> +	thread = kthread_run(ldt_thread, NULL, "%s", ldt_name);
> +	if (IS_ERR(thread)) {
> +		ret = PTR_ERR(thread);
> +		if (ret)

This if test will always be true.

> +			goto exit;
> +	}
> +	debugfs = debugfs_create_file(ldt_name, S_IRUGO, NULL, NULL, &ldt_fops);

Error checking.

> +#ifdef USE_MISCDEV
> +	ret = check(misc_register(&ldt_miscdev));
> +	if (ret < 0)
> +		goto exit;
> +	pr_debug_dec(ldt_miscdev.minor);
> +#else
> +	chrdev_region_init(ldt_name);
> +#endif
> +exit:

This does no cleanup if the probe partially succeeded.

> +	pr_debug_dec(ret);
> +	return ret;
> +}
> +
> +/*
> + *	ldt_remove - main clean up function
> + */
> +
> +static int __devexit ldt_remove(struct platform_device *pdev)
> +{
> +	int d;
> +	if (pdev)

pdev should always be valid.

> +		dev_dbg(&pdev->dev, "%s:%d %s detaching driver\n", __file__, __LINE__, __func__);
> +	/* remove_proc_entry(ldt_name, NULL); depricated */
> +	if (debugfs)
> +		debugfs_remove(debugfs);
> +#ifdef USE_MISCDEV
> +	misc_deregister(&ldt_miscdev);
> +#else
> +	for (d = 0; d < devs; d++)
> +		device_destroy(ldt_class, MKDEV(major, d));
> +	class_destroy(ldt_class);
> +	cdev_del(&ldt_cdev);
> +	unregister_chrdev_region(MKDEV(major, 0), devs);
> +#endif
> +	if (!IS_ERR_OR_NULL(thread)) {
> +		send_sig(SIGINT, thread, 1);
> +		kthread_stop(thread);
> +	}
> +	del_timer(&ldt_timer);
> +	if (port_r)
> +		release_region(port, port_size);
> +	if (irq) {
> +		if (uart_detected) {
> +			iowrite8(0, port_ptr + UART_IER);
> +			iowrite8(0, port_ptr + UART_FCR);
> +			iowrite8(0, port_ptr + UART_MCR);
> +			ioread8(port_ptr + UART_RX);
> +		}
> +		free_irq(irq, THIS_MODULE);
> +	}
> +	tasklet_kill(&ldt_tasklet);
> +	if (in_buf) {
> +		pages_flag(virt_to_page(in_buf), PFN_UP(bufsize), PG_reserved, 0);
> +		free_pages_exact(in_buf, bufsize);
> +	}
> +	if (out_buf) {
> +		pages_flag(virt_to_page(out_buf), PFN_UP(bufsize), PG_reserved, 0);
> +		free_pages_exact(out_buf, bufsize);
> +	}
> +	pr_debug_dec(isr_counter);
> +	pr_debug_dec(ldt_work_counter);
> +	if (port_ptr)
> +		ioport_unmap(port_ptr);
> +	return 0;
> +}
> +
> +#ifdef USE_PLATFORM_DEVICE
> +
> +/*
> + * Following code requires platform_device (ldt_plat_dev.*) to work
> + */
> +
> +#ifdef CONFIG_PM
> +
> +static int ldt_suspend(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static int ldt_resume(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops ldt_pm = {
> +	.suspend = ldt_suspend,
> +	.resume = ldt_resume,
> +};
> +
> +#define ldt_pm_ops (&ldt_pm)
> +#else
> +#define ldt_pm_ops NULL
> +#endif
> +
> +static const struct of_device_id ldt_of_match[] = {
> +	{.compatible = "linux-driver-template",},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, ldt_of_match);
> +
> +static struct platform_driver ldt_driver = {
> +	.driver = {
> +		   .name = "ldt_device_name",
> +		   .owner = THIS_MODULE,
> +		   .pm = ldt_pm_ops,
> +		   .of_match_table = of_match_ptr(ldt_of_match),
> +		   },
> +	.probe = ldt_probe,
> +	.remove = __devexit_p(ldt_remove),

Tabify.

> +};
> +
> +#ifdef module_platform_driver
> +module_platform_driver(ldt_driver);
> +#else

Why would this not be defined?

> +
> +/*
> + *	for Linux kernel releases before v3.1-12
> + *	without macro module_platform_driver
> + */

If you are aiming for merging to mainline the kernel version stuff
becomes irrelevant.

> +
> +static int ldt_init(void)
> +{
> +	int ret = 0;
> +	ret = platform_driver_register(&ldt_driver);
> +	return ret;

	return platform_driver_register(&ldt_driver);

> +}
> +
> +static void ldt_exit(void)
> +{
> +	platform_driver_unregister(&ldt_driver);
> +}
> +
> +module_init(ldt_init);
> +module_exit(ldt_exit);
> +#endif /* module_platform_driver */
> +
> +#else /* !USE_PLATFORM_DEVICE */
> +
> +/*
> + *	Standalone module initialization to run without platform_device
> + */
> +
> +static int ldt_init(void)
> +{
> +	int ret = 0;
> +	/*
> +	 *      Call probe function directly,
> +	 *      bypassing platform_device infrastructure
> +	 */
> +	ret = ldt_probe(NULL);
> +	return ret;

	return ldt_probe(NULL);

> +}
> +
> +static void ldt_exit(void)
> +{
> +	int res;
> +	res = ldt_remove(NULL);

What is the point of the res variable?

> +}
> +
> +module_init(ldt_init);
> +module_exit(ldt_exit);
> +#endif
> +
> +MODULE_DESCRIPTION("LDT - Linux Driver Template");
> +MODULE_AUTHOR("Constantine Shulyupin <const@makelinux.net>");
> +MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/samples/ltd/ldt_plat_dev.c b/samples/ltd/ldt_plat_dev.c
> new file mode 100644
> index 0000000..cd45057
> --- /dev/null
> +++ b/samples/ltd/ldt_plat_dev.c
> @@ -0,0 +1,68 @@
> +/*
> + *	LDT - Linux Driver Template
> + *
> + *	Copyright (C) 2012 Constantine Shulyupin  http://www.makelinux.net/
> + *
> + *	Dual BSD/GPL License
> + *
> + *	platform_device template driver
> + *
> + *	uses
> + *
> + *	platform_data
> + *	resources
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include "tracing.h"
> +
> +static struct resource ldt_resource[] = {
> +	{
> +	 .flags = IORESOURCE_IO,
> +	 .start = 0x3f8,
> +	 .end = 0x3ff,
> +	 },
> +	{
> +	 .flags = IORESOURCE_IRQ,
> +	 .start = 4,
> +	 .end = 4,
> +	 },
> +	{
> +	 .flags = IORESOURCE_MEM,
> +	 .start = 0,
> +	 .end = 0,
> +	 },

Identation is all messed here.

> +};
> +
> +void ldt_dev_release(struct device *dev)
> +{
> +_entry:;
> +}

Just remove the body.

> +static struct platform_device ldt_platform_device = {
> +	.name = "ldt_device_name",
> +	.id = 0,
> +	.num_resources = ARRAY_SIZE(ldt_resource),
> +	.resource = ldt_resource,

Typically put resource first, then num_resources.

> +	.dev.platform_data = "test data",
> +	.dev.release = ldt_dev_release,
> +};
> +
> +static int ldt_plat_dev_init(void)
> +{
> +	return platform_device_register(&ldt_platform_device);
> +}
> +
> +static void ldt_plat_dev_exit(void)
> +{
> +	platform_device_unregister(&ldt_platform_device);
> +}
> +
> +module_init(ldt_plat_dev_init);
> +module_exit(ldt_plat_dev_exit);
> +
> +MODULE_DESCRIPTION("LDT - Linux Driver Template: platform_device");
> +MODULE_AUTHOR("Constantine Shulyupin <const@makelinux.net>");
> +MODULE_LICENSE("Dual BSD/GPL");

~Ryan


