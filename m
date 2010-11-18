Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898Ab0KRQ4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:56:55 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:55189
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755015Ab0KRQ4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:56:54 -0500
X-SpamScore: -7
X-BigFish: VS-7(zz1432N98dNa615mzz1202hzz8275bhz2dh2a8h637h668h67dh685h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
Message-ID: <4CE55ACB.80207@freescale.com>
Date: Thu, 18 Nov 2010 10:56:43 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <20101117215147.GA26792@suse.de> <4CE452CD.3050001@freescale.com> <20101117221903.GA4066@suse.de> <4CE45A4E.70308@freescale.com> <20101118022434.GA9833@suse.de> <4CE546C5.8060401@freescale.com> <20101118153912.GA1443@suse.de> <4CE54E40.9040503@freescale.com> <20101118163321.GA2723@suse.de> <4CE5562B.8080604@freescale.com> <20101118165136.GA3103@suse.de>
In-Reply-To: <20101118165136.GA3103@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 16:57:46.0159 (UTC) FILETIME=[B94C23F0:01CB8741]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Why?  Again, it doesn't matter, and no other tty driver does it.
> 
> Actually you do have control over it, if you really want it, but again,
> don't do that :)

Because the only way to know which byte channel tty you want is via the byte
channel handle.

Think of the situation where you have two serial ports on the back of your
computer.  One of them is /dev/ttyS0, and the other is /dev/ttyS1.  But which
one is which?  The only way to find out is try one and see if it works.

Now that might be acceptable for serial ports that are fixed physically.  But
byte channels handles are completely arbitrary and easily change with even the
slightest re-configuration of the partitions under the hypervisor.  I need to
have some way to tell userspace that /dev/ttybc0 is byte channel handle 73.

> Sorry, I can't do code review, or accept code that is not allowed to be
> sent to the public, as, surprise, I'm public :)

Well, ok.  I didn't want to spam the mailing list with something that only you
asked for, but here it is:

/* ePAPR hypervisor byte channel device driver
 *
 * Copyright 2009-2010 Freescale Semiconductor, Inc.
 *
 * Author: Timur Tabi <timur@freescale.com>
 *
 * This file is licensed under the terms of the GNU General Public License
 * version 2.  This program is licensed "as is" without any warranty of any
 * kind, whether express or implied.
 *
 * This driver support four distinct interfaces, all of which are related to
 * ePAPR hypervisor byte channels.
 *
 * 1) An early-console (udbg) driver.  This provides early console output
 * through a byte channel.  The byte channel handle must be specified in a
 * Kconfig option.
 *
 * 2) A normal console driver.  Output is sent to the byte channel designated
 * for stdout in the device tree.
 *
 * 3) A tty driver.
 *
 * 4) A byte channel character driver.  This driver creates a /dev/bcXX
 * character device for each byte channel.  The "XX" is the byte channel
 * handle.
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/err.h>
#include <linux/interrupt.h>
#include <linux/fs.h>
#include <linux/poll.h>
#include <asm/epapr_hcalls.h>
#include <linux/of.h>
#include <linux/cdev.h>
#include <linux/console.h>
#include <linux/tty.h>
#include <linux/tty_flip.h>
#include <asm/udbg.h>

/* Byte channel handle for stdout (and stdin), taken from device tree */
static unsigned int stdout_bc;

/* Virtual IRQ for the byte channel handle for stdin, taken from device tree */
static unsigned int stdout_irq;

/**************************** SUPPORT FUNCTIONS ****************************/

/*
 * return TRUE if we're running under FSL hypervisor
 *
 * This function checks to see if we're running under the Freescale
 * hypervisor, and returns zero if we're not, or non-zero if we are.
 *
 * First, it checks if MSR[GS]==1, which means we're running under some
 * hypervisor.  Then it checks if there is a hypervisor node in the device
 * tree.  Currently, that means there needs to be a node in the root called
 * "hypervisor" and which has a property named "fsl,hv-version".
 */
static int has_fsl_hypervisor(void)
{
	struct device_node *node;
	int ret;

	if (!(mfmsr() & MSR_GS))
		return 0;

	node = of_find_node_by_path("/hypervisor");
	if (!node)
		return 0;

	ret = of_find_property(node, "fsl,hv-version", NULL) != NULL;

	of_node_put(node);

	return ret;
}

/*
 * find the byte channel handle to use for the console
 *
 * The byte channel to be used for the console is specified via a "stdout"
 * property in the /chosen node.
 *
 * For compatible with legacy device trees, we also look for a "stdout" alias.
 */
static void find_console_handle(void)
{
	struct device_node *np;
	const char *sprop = NULL;
	const uint32_t *iprop;

	np = of_find_node_by_path("/chosen");
	if (np)
		sprop = of_get_property(np, "stdout", NULL);

	if (!np || !sprop) {
		of_node_put(np);
		np = of_find_node_by_name(NULL, "aliases");
		if (np)
			sprop = of_get_property(np, "stdout", NULL);
	}

	of_node_put(np);
	if (!sprop)
		return;

	/* We don't care what the aliased node is actually called.  We only
	 * care if it's compatible with "epapr,hv-byte-channel", because that
	 * indicates that it's a byte channel node.
	 */
	np = of_find_node_by_path(sprop);
	if (!np) {
		pr_warning("ehv-bc: stdout node '%s' does not exist\n", sprop);
		return;
	}

	/* Is it a byte channel? */
	if (!of_device_is_compatible(np, "epapr,hv-byte-channel"))
		goto exit;

	stdout_irq = irq_of_parse_and_map(np, 0);
	if (stdout_irq == NO_IRQ) {
		pr_err("ehv-bc: no 'interrupts' property in %s node\n", sprop);
		goto exit;
	}

	iprop = of_get_property(np, "reg", NULL);
	if (!iprop) {
		pr_err("ehv-bc: no 'reg' property in %s node\n", np->name);
		goto exit;
	}
	stdout_bc = be32_to_cpu(*iprop);

exit:
	of_node_put(np);
}

/*************************** EARLY CONSOLE DRIVER ***************************/

#ifdef CONFIG_PPC_EARLY_DEBUG_EHV_BC

/*
 * send a byte to a byte channel, wait if necessary
 *
 * This function sends a byte to a byte channel, and it waits and
 * retries if the byte channel is full.  It returns if the character
 * has been sent, or if some error has occurred.
 *
 */
static void byte_channel_spin_send(const char data)
{
	int ret, count;

	do {
		count = 1;
		ret = ev_byte_channel_send(CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE,
					   &count, &data);
	} while (ret == EV_EAGAIN);
}

/*
 * The udbg subsystem calls this function to display a single character.
 * We convert CR to a CR/LF.
 */
static void ehv_bc_udbg_putc(char c)
{
	byte_channel_spin_send(c);
	if (c == '\n')
		byte_channel_spin_send('\r');
}

/*
 * early console initialization
 *
 * PowerPC kernels support an early printk console, also known as udbg.
 * This function must be called via the ppc_md.init_early function pointer.
 * At this point, the device tree has been unflattened, so we can obtain the
 * byte channel handle for stdout.
 *
 * We only support displaying of characters (putc).  We do not support
 * keyboard input.
 */
void __init udbg_init_ehv_bc(void)
{
	unsigned int rx_count, tx_count;
	unsigned int ret;

	/* Check if we're running as a guest of a hypervisor */
	if (!(mfmsr() & MSR_GS))
		return;

	/* Verify the byte channel handle */
	ret = ev_byte_channel_poll(CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE,
				   &rx_count, &tx_count);
	if (ret)
		return;

	udbg_putc = ehv_bc_udbg_putc;
	register_early_udbg_console();

	udbg_printf("ehv-bc: early console using byte channel handle %u\n",
		    CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE);
}

#endif

/****************************** CONSOLE DRIVER ******************************/

static struct tty_driver *ehv_bc_driver;

/*
 * Byte channel console sending worker function.
 *
 * For consoles, if the output buffer is full, we should just spin until it
 * clears.
 */
static int ehv_bc_console_byte_channel_send(unsigned int handle, const char *s,
			     unsigned int count)
{
	unsigned int len;
	int ret = 0;

	while (count) {
		len = min_t(unsigned int, count, 16);
		do {
			ret = ev_byte_channel_send(handle, &len, s);
		} while (ret == EV_EAGAIN);
		count -= len;
		s += len;
	}

	return ret;
}

static void ehv_bc_console_write(struct console *co, const char *s,
				 unsigned int count)
{
	unsigned int handle = (unsigned int)co->data;

	while (count) {
		unsigned int len;
		const char *p;
		int ret;

		/* No more than 16 characters can be sent at a time */
		len = min_t(unsigned int, count, 16);

		/* If there's a \n, we need to inject a \r */
		p = strnchr(s, len, '\n');
		if (p)
			len = p - s + 1;

		ret = ehv_bc_console_byte_channel_send(handle, s, len);

		/* Now send a \r if the last character was a \n */
		if (!ret && p)
			ret = ehv_bc_console_byte_channel_send(handle, "\r", 1);

		if (ret)
			/* Any non-zero return code here indicates failure */
			return;

		s += len;
		count -= len;
	}
}

static struct tty_driver *ehv_bc_console_device(struct console *c, int *index)
{
	*index = c->index;

	return ehv_bc_driver;
}

static int ehv_bc_tty_write(struct tty_struct *tty, const unsigned char *s,
				int count)
{
	int ret;

	ret = ehv_bc_console_byte_channel_send(stdout_bc, s, count);
	if (ret < 0)
		return ret;

	return count;
}

static struct console ehv_bc_console = {
	.name		= "ttyEHV",
	.write		= ehv_bc_console_write,
	.device		= ehv_bc_console_device,
	.flags		= CON_PRINTBUFFER | CON_ENABLED,
};

/*
 * Console initialization
 *
 * This is the first function that is called after the device tree is
 * available, so here is where we determine the byte channel handle and IRQ for
 * stdout/stdin, even though that information is used by the tty and character
 * drivers.
 */
static int __init ehv_bc_console_init(void)
{
	find_console_handle();
	if (!stdout_bc) {
		/* stdout is not a byte channel */
		pr_debug("ehv-bc: stdout is not a byte channel\n");
		return -ENODEV;
	}

#ifdef CONFIG_PPC_EARLY_DEBUG_EHV_BC
	/* Print a friendly warning if the user chose the wrong */
	if (stdout_bc != CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE)
		pr_warning("ehv-bc: udbg handle %u is not the stdout handle\n",
			   CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE);
#endif

	ehv_bc_console.data = (void *)stdout_bc;

	add_preferred_console(ehv_bc_console.name, 0, NULL);
	register_console(&ehv_bc_console);

	pr_info("ehv-bc: registered console driver for byte channel %u\n",
		stdout_bc);

	return 0;
}
console_initcall(ehv_bc_console_init);

/******************************** TTY DRIVER ********************************/

/* The tty port object for the console.  There doesn't appear to be a way for
 * ehv_bc_init() to create a port object and pass it to ehv_bc_tty_open(), so
 * we have to make this a global variable.
 */
static struct tty_port ttyport;

/*
 * byte channel receive interupt handler
 *
 * This ISR is called whenever data is available on a byte channel.
 */
static irqreturn_t ehv_bc_tty_rx_isr(int irq, void *data)
{
	struct tty_struct *tty = tty_port_tty_get(data);
	unsigned int rx_count, tx_count;
	unsigned int count, len;
	u8 buffer[16];
	int ret;

	/* Find out how much data is available to be read, and then ask the
	 * TTY layer if it can handle that much.  We want to ensure that every
	 * byte we read from the byte channel will be accepted by the TTY layer.
	 */
	ev_byte_channel_poll(stdout_bc, &rx_count, &tx_count);
	count = tty_buffer_request_room(tty, rx_count);

	/* 'count' is the maximum amount of data the TTY layer can accept at
	 * this time.  However, during testing, I was never able to get 'count'
	 * to be less than 'rx_count'
	 */

	while (count) {
		len = min_t(unsigned int, count, sizeof(buffer));

		ev_byte_channel_receive(stdout_bc, &len, buffer);

		/* 'len' is now the amount of data that's been received. 'len'
		   can't be zero, and most likely it's equal to one. */

		ret = tty_insert_flip_string(tty, buffer, len);

		/* 'ret' is the number of bytes that the TTY layer accepted.
		 * If it's not equal to 'len', then it means the buffer is
		 * full, which should never happen.  If it does, we can exit
		 * gracefully, but we'll have to drop the remaining 'len - ret'
		 * characters we read from the byte channel.
		 */
		if (ret != len)
			break;

		count -= len;
	}

	tty_flip_buffer_push(tty);

	return IRQ_HANDLED;
}

static int ehv_bc_tty_open(struct tty_struct *ttys, struct file *filp)
{
	return tty_port_open(&ttyport, ttys, filp);
}

static void ehv_bc_tty_close(struct tty_struct *ttys, struct file *filp)
{
	tty_port_close(&ttyport, ttys, filp);
}

/*
 * ehv_bc_tty_write_room - return the amount of space in the output buffer
 *
 * This is actually a contract between the driver and the tty layer outlining
 * how much write room the driver can guarantee will be sent OR BUFFERED.  This
 * driver MUST honor the return value.
 */
static int ehv_bc_tty_write_room(struct tty_struct *ttys)
{
	unsigned int rx_count, tx_count;
	unsigned int ret;

	/* Returns the amount of free space in the TX buffer */
	ret = ev_byte_channel_poll(stdout_bc, &rx_count, &tx_count);
	if (ret)
		/* Failure can occur only if stdout_bc is wrong*/
		return -EINVAL;

	return tx_count;
}

/*
 * TTY driver operations
 *
 * If we could ask the hypervisor how much data is still in the TX buffer, then
 * we could implement the .wait_until_sent and .chars_in_buffer functions.
 */
static const struct tty_operations ehv_bc_ops = {
	.open            = ehv_bc_tty_open,
	.close           = ehv_bc_tty_close,
	.write           = ehv_bc_tty_write,
	.write_room      = ehv_bc_tty_write_room,
};

/*
 * initialize the TTY port
 *
 * This function will only be called once, no matter how many times
 * ehv_bc_tty_open() is called.  That's why we register the ISR here.
 */
static int ehv_bc_tty_port_activate(struct tty_port *port,
				    struct tty_struct *ttys)
{
	int ret;

	ret = request_irq(stdout_irq, ehv_bc_tty_rx_isr, 0, "ehv-bc", port);
	if (ret < 0)
		pr_err("ehv-bc: could not request rx irq %u (ret=%i)\n",
		      stdout_irq, ret);

	return ret;
}

static void ehv_bc_tty_port_shutdown(struct tty_port *port)
{
	free_irq(stdout_irq, port);
}

static const struct tty_port_operations ehv_bc_tty_port_ops = {
	.activate = ehv_bc_tty_port_activate,
	.shutdown = ehv_bc_tty_port_shutdown,
};

static int __init ehv_bc_tty_init(unsigned int count)
{
	int ret;

	ehv_bc_driver = alloc_tty_driver(1);
	if (!ehv_bc_driver)
		return -ENOMEM;

	ehv_bc_driver->owner        = THIS_MODULE;
	ehv_bc_driver->driver_name  = "ehv-bc";
	ehv_bc_driver->name         = "ttyEHV";
	ehv_bc_driver->num          = count;
	ehv_bc_driver->type         = TTY_DRIVER_TYPE_CONSOLE;
	ehv_bc_driver->subtype      = SYSTEM_TYPE_CONSOLE;
	ehv_bc_driver->init_termios = tty_std_termios;
	ehv_bc_driver->flags        = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;

	tty_set_operations(ehv_bc_driver, &ehv_bc_ops);

	ret = tty_register_driver(ehv_bc_driver);
	if (ret) {
		pr_err("ehv-bc: could not register tty driver (ret=%i)\n", ret);
		goto error;
	}

	tty_port_init(&ttyport);
	ttyport.ops = &ehv_bc_tty_port_ops;

	pr_info("ehv-bc: registered tty driver for byte channel %u\n",
		stdout_bc);

	return 0;

error:
	put_tty_driver(ehv_bc_driver);
	return ret;
}

static void __exit ehv_bc_tty_exit(void)
{
	tty_unregister_driver(ehv_bc_driver);
	put_tty_driver(ehv_bc_driver);
}

/*********************** BYTE CHANNEL CHARACTER DRIVER ***********************/

/* Per-byte channel private data */
struct ehv_bc_data {
	struct device *dev;
	struct device *tty_dev;
	dev_t dev_id;
	uint32_t handle;
	unsigned int rx_irq;
	unsigned int tx_irq;
	wait_queue_head_t rx_wait;
	wait_queue_head_t tx_wait;
	int rx_ready;
	int tx_ready;
};

/**
 * ehv_bc_rx_isr - byte channel receive interupt handler
 *
 * This ISR is called whenever data is available on a byte channel.
 */
static irqreturn_t ehv_bc_rx_isr(int irq, void *data)
{
	struct ehv_bc_data *bc = data;

	bc->rx_ready = 1;
	wake_up_interruptible(&bc->rx_wait);

	return IRQ_HANDLED;
}

/**
 * ehv_bc_tx_isr - byte channel transmit interupt handler
 *
 * This ISR is called whenever space is available on a byte channel.
 */
static irqreturn_t ehv_bc_tx_isr(int irq, void *data)
{
	struct ehv_bc_data *bc = data;

	bc->tx_ready = 1;
	wake_up_interruptible(&bc->tx_wait);

	return IRQ_HANDLED;
}

/**
 * ehv_bc_poll - query the byte channel to see if data is available
 *
 * Returns a bitmask indicating whether a read will block
 */
static unsigned int ehv_bc_poll(struct file *filp, struct poll_table_struct *p)
{
	struct ehv_bc_data *bc = filp->private_data;
	unsigned int rx_count, tx_count;
	unsigned int mask = 0;
	int ret;

	ret = ev_byte_channel_poll(bc->handle, &rx_count, &tx_count);
	if (ret)
		return POLLERR;

	poll_wait(filp, &bc->rx_wait, p);
	poll_wait(filp, &bc->tx_wait, p);

	if (rx_count)
		mask |= POLLIN | POLLRDNORM;
	if (tx_count)
		mask |= POLLOUT | POLLWRNORM;

	return mask;
}

/**
 * ehv_bc_read - read from a byte channel into the user's buffer
 *
 * Returns the total number of bytes read, or error
 */
static ssize_t ehv_bc_read(struct file *filp, char __user *buf, size_t len,
			   loff_t *off)
{
	struct ehv_bc_data *bc = filp->private_data;
	unsigned int count;
	unsigned int total = 0;
	char buffer[16];
	int ret;

	/* Make sure we stop when the user buffer is full. */
	while (len) {
		/* Don't ask for more than we can receive */
		count = min(len, sizeof(buffer));

		/* Reset the RX status here so that we don't need a spinlock
		 * around the hyerpcall.  It won't matter if the ISR is called
		 * before the receive() returns, because 'count' will be
		 * non-zero, so we won't test rx_ready.
		 */
		bc->rx_ready = 0;

		/* Non-blocking */
		ret = ev_byte_channel_receive(bc->handle, &count, buffer);
		if (ret)
			return -EIO;

		/* If the byte channel is empty, then either we're done or we
		 * need to block.
		 */
		if (!count) {
			if (total)
				/* We did read some chars, so we're done. */
				return total;

			/* If the application specified O_NONBLOCK, then we
			 * return the appropriate error code.
			 */
			if (filp->f_flags & O_NONBLOCK)
				return -EAGAIN;

			/* Wait until some data is available */
			if (wait_event_interruptible(bc->rx_wait, bc->rx_ready))
				return -ERESTARTSYS;

			/* Data is available, so loop around and read it */
			continue;
		}

		copy_to_user(buf, buffer, count);

		buf += count;
		len -= count;
		total += count;
	}

	return total;
}

/**
 * ehv_bc_write - write to a byte channel from the user's buffer
 *
 * Returns the total number of bytes written, or error
 */
static ssize_t ehv_bc_write(struct file *filp, const char __user *buf,
			    size_t len, loff_t *off)
{
	struct ehv_bc_data *bc = filp->private_data;
	unsigned int count;
	unsigned int total = 0;
	char buffer[16];
	int ret;

	while (len) {
		count = min(len, sizeof(buffer));
		copy_from_user(buffer, buf, count);

		bc->tx_ready = 0;

		ret = ev_byte_channel_send(bc->handle, &count, buffer);
		if (ret) {
			if (total)
				/* We did write some chars, so we're done. */
				return total;

			/* If the application specified O_NONBLOCK, then we
			 * return the appropriate error code.
			 */
			if (filp->f_flags & O_NONBLOCK)
				return -EAGAIN;

			/* Wait until some data is available */
			if (wait_event_interruptible(bc->tx_wait, bc->tx_ready))
				return -ERESTARTSYS;

			continue;
		}

		buf += count;
		len -= count;
		total += count;
	}

	return total;
}

/* Array of byte channel objects */
static struct ehv_bc_data *bcs;

/* Number of elements in bcs[] */
static unsigned int count;

/**
 * ehv_bc_open - open the driver
 */
static int ehv_bc_open(struct inode *inode, struct file *filp)
{
	unsigned int minor = iminor(inode);
	struct ehv_bc_data *bc = &bcs[minor];

	filp->private_data = bc;

	return 0;
}

static const struct file_operations ehv_bc_fops = {
	.owner = THIS_MODULE,
	.open = ehv_bc_open,
	.poll = ehv_bc_poll,
	.read = ehv_bc_read,
	.write = ehv_bc_write,
};

static struct class *ehv_bc_class;
static dev_t dev_id;
static struct cdev cdev;

/**
 * ehv_bc_init - ePAPR hypervisor byte channel driver initialization
 *
 * This function is called when this module is loaded.
 */
static int __init ehv_bc_init(void)
{
	struct device_node *np;
	const uint32_t *reg;
	struct ehv_bc_data *bc;
	unsigned int i;
	int ret;

	pr_info("ePAPR hypervisor byte channel driver\n");

	if (!has_fsl_hypervisor()) {
		pr_info("ehv-bc: no hypervisor found\n");
		return -ENODEV;
	}

	/* Count the number of byte channels */
	for_each_compatible_node(np, NULL, "epapr,hv-byte-channel") {
		reg = of_get_property(np, "reg", NULL);
		if (reg && (be32_to_cpu(*reg) != stdout_bc))
			count++;
	}

	/* If stdout is directed to a byte channel, then initialize the tty */
	if (stdout_bc) {
		ret = ehv_bc_tty_init(count + 1);
		if (ret)
			return ret;
	}

	if (!count) {
		if (stdout_bc)
			return 0;

		pr_info("ehv-bc: no byte channels\n");
		return -ENODEV;
	}

	bcs = kzalloc(count * sizeof(struct ehv_bc_data), GFP_KERNEL);
	if (!bcs)
		return -ENOMEM;

	ret = alloc_chrdev_region(&dev_id, 0, count, "ehv-bc");
	if (ret < 0) {
		pr_err("ehv-bc: could not register character device "
		       " (ret=%i)\n", ret);
		goto error_nomem;
	}

	/* Create our class in sysfs */
	ehv_bc_class = class_create(THIS_MODULE, "ehv-bc");

	i = 0;
	for_each_compatible_node(np, NULL, "epapr,hv-byte-channel") {
		reg = of_get_property(np, "reg", NULL);
		if (!reg) {
			pr_err("ehv-bc: no 'reg' property in %s node\n",
				np->name);
			continue;
		}
		if (be32_to_cpu(*reg) == stdout_bc)
			/* Skip the stdout byte channel */
			continue;

		bc = &bcs[i];

		init_waitqueue_head(&bc->rx_wait);
		init_waitqueue_head(&bc->tx_wait);
		bc->handle = be32_to_cpu(*reg);

		bc->rx_irq = irq_of_parse_and_map(np, 0);
		if (bc->rx_irq == NO_IRQ) {
			pr_err("ehv-bc: no 'interrupts' property in %s node\n",
				np->name);
			continue;
		}
		ret = request_irq(bc->rx_irq, ehv_bc_rx_isr, 0, np->name, bc);
		if (ret < 0) {
			pr_err("ehv-bc: could not request rx irq %u\n",
			       bc->rx_irq);
			continue;
		}

		bc->tx_irq = irq_of_parse_and_map(np, 1);
		if (bc->tx_irq == NO_IRQ) {
			pr_err("ehv-bc: no 'interrupts' property in %s node\n",
				np->name);
			continue;
		}
		ret = request_irq(bc->tx_irq, ehv_bc_tx_isr, 0, np->name, bc);
		if (ret < 0) {
			pr_err("ehv-bc: could not request tx irq %u\n",
			       bc->tx_irq);
			continue;
		}

		/* Create the 'dev' entry in sysfs */
		bc->dev_id = MKDEV(MAJOR(dev_id), MINOR(dev_id) + i);
		bc->dev = device_create(ehv_bc_class, NULL, bc->dev_id, bc,
					"bc%u", bc->handle);
		if (IS_ERR(bc->dev)) {
			pr_err("ehv-bc: could not register byte channel %u\n",
				bc->handle);
			continue;
		}
		bc->tty_dev = tty_register_device(ehv_bc_driver, i, bc->dev);
		printk(KERN_INFO "%s:%u tty_dev=%p\n", __func__, __LINE__, bc->tty_dev);

		pr_info("ehv-bc: registered byte channel %u\n", bc->handle);

		i++;
	}

	cdev_init(&cdev, &ehv_bc_fops);
	cdev.owner = THIS_MODULE;

	ret = cdev_add(&cdev, dev_id, count);
	if (ret < 0) {
		pr_err("ehv-bc: could not add cdev\n");
		goto error;
	}

	return 0;

error:
	for (i = 0; i < count; i++) {
		device_destroy(ehv_bc_class, bcs[i].dev_id);
		free_irq(bcs[i].rx_irq, &bcs[i]);
		free_irq(bcs[i].tx_irq, &bcs[i]);
	}

	unregister_chrdev_region(dev_id, count);

error_nomem:
	kfree(bcs);

	return ret;
}


/**
 * ehv_bc_exit - ePAPR hypervisor byte channel driver termination
 *
 * This function is called when this driver is unloaded.
 */
static void __exit ehv_bc_exit(void)
{
	unsigned int i;

	cdev_del(&cdev);

	for (i = 0; i < count; i++) {
		device_destroy(ehv_bc_class, bcs[i].dev_id);
		free_irq(bcs[i].rx_irq, &bcs[i]);
		free_irq(bcs[i].tx_irq, &bcs[i]);
	}

	unregister_chrdev_region(dev_id, count);

	kfree(bcs);

	ehv_bc_tty_exit();
}

module_init(ehv_bc_init);
module_exit(ehv_bc_exit);

MODULE_AUTHOR("Timur Tabi <timur@freescale.com>");
MODULE_DESCRIPTION("ePAPR hypervisor byte channel driver");
MODULE_LICENSE("GPL");

-- 
Timur Tabi
Linux kernel developer at Freescale

