Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1HYJgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:36:41 -0400
Received: from smtp151.iad.emailsrvr.com ([207.97.245.151]:57468 "EHLO
	smtp151.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1HYJgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:36:39 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Aug 2011 05:36:39 EDT
X-SMTPDoctor-Processed: csmtpprox 2.7.4
MIME-Version: 1.0
Date: Thu, 25 Aug 2011 11:29:21 +0200
Message-ID: <CAHzZGEz3EYuQQA0BK0Z9L14BXzuYRV4WVHS+6=L9rBwx+_G_8A@mail.gmail.com>
Subject: Problem with writing virtual serial device driver.
From: =?UTF-8?B?RGF3aWQgQ2nEmcW8YXJraWV3aWN6?= <dawidc@b-labs.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working on virtual serial driver for paravirtualized Linux instance.

I'm using documentation available on the web and doing mostly fine,
but hit some weird issue.

The problem is: my driver successfully registers serial device, the
appropriate devices get created under /dev, but no matter what I do
with them, I never see any single "struct uart_ops" function getting
called.


I paste the full code below. I would greatly appreciate any advise and help.

-- BEGIN --
/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */
#include <linux/module.h>
#include <linux/tty.h>
#include <linux/ioport.h>
#include <linux/io.h>
#include <linux/slab.h>
#include <linux/init.h>
#include <linux/serial.h>
#include <linux/console.h>
#include <linux/sysrq.h>
#include <linux/uaccess.h>

#include <l4lib/lib/cap.h>
#include <l4/api/irq.h>

#if defined(CONFIG_SERIAL_C0SERIAL_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
#define SUPPORT_SYSRQ
#endif

#include <linux/serial_core.h>

#define MY_NAME "c0serial"
#define dbg(fmt, arg...)						\
	do {								\
		if (debug)						\
			printk (KERN_DEBUG "%s: %s: " fmt "\n",		\
				MY_NAME , __FUNCTION__ , ## arg);	\
	} while (0)
#define err(format, arg...) printk(KERN_ERR "%s: " format "\n" ,
MY_NAME , ## arg)
#define info(format, arg...) printk(KERN_INFO "%s: " format "\n" ,
MY_NAME , ## arg)
#define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n" ,
MY_NAME , ## arg)

static int debug = 1;
module_param(debug, int, 1)
MODULE_PARM_DESC(debug, "Debugging mode enabled or not");

#define C0SERIAL_BUFFER_PHSMEM CONFIG_PARAVIRT_SERIALDEV_BUF_START
#define C0SERIAL_BUFFER_SIZE 128

#define C0SERIAL_ALL_BUFFERS_SIZE (sizeof(struct c0serial_buffer) *
CONFIG_CONTAINERS * 2)


struct c0serial_buffer
{
	atomic_t count;            /* 0 - free, -1 - busy writing, >0 - data
available */
	atomic_t opened;           /* is the buffer opened on the receiver side? */
	char ch;
};


struct c0serial_buffer* c0serial_buffers;
#define C0SERIAL_BUF_TO_CONT0 0
#define C0SERIAL_BUF_FROM_CONT0 1

#define get_buffer(cont, to_or_from) \
	(&c0serial_buffers[(cont * CONFIG_CONTAINERS * 2 + to_or_from)])

#define C0SERIAL_IRQ_ACK_TX CONFIG_PARAVIRT_SERIALDEV_TXIRQ
#define C0SERIAL_IRQ_ACK_RX CONFIG_PARAVIRT_SERIALDEV_RXIRQ

static int containers = -1; /* number of loaded containers */
static int cur_cont = -1;

#define SERIAL_C0SERIAL_MAJOR	204
#define MINOR_START		154
#define C0SERIAL_DEVICENAME	"ttyVIRT"
#define MASTER_CONTAINER 0

#define SERIAL_C0SERIAL_MASTER_MAJOR	205
#define C0SERIAL_MASTER_DEVICENAME	"ttyCONT"
/*
 * We wrap our port structure around the generic uart_port.
 */
struct c0serial_uart_port {
	struct uart_port	uart;		/* uart */

	struct c0serial_buffer	*rx_buf;
	struct c0serial_buffer	*tx_buf;

	unsigned int tx_cont;

};

static struct c0serial_uart_port c0serial_port;
static struct c0serial_uart_port c0serial_master_port[CONFIG_CONTAINERS];

#ifdef SUPPORT_SYSRQ
static struct console c0serial_console;
#endif

static void c0serial_stop_tx(struct uart_port *port)
{
	dbg();
}
static void c0serial_stop_rx(struct uart_port *port)
{
	dbg();
}
static void c0serial_set_mctrl(struct uart_port *port, unsigned int mctrl)
{
	dbg();
}
static unsigned int c0serial_get_mctrl(struct uart_port *port)
{
	dbg();
	return 0;
}
static void c0serial_break_ctl(struct uart_port *port, int break_state)
{
	dbg();
}
static void c0serial_enable_ms(struct uart_port *port)
{
	dbg();
}
static void c0serial_release_port(struct uart_port *port)
{
	dbg();
}
static int c0serial_request_port(struct uart_port *port)
{
	dbg();
	return 0;
}
static void c0serial_config_port(struct uart_port *port, int flags)
{
	dbg();
}
static int c0serial_verify_port(struct uart_port *port, struct
serial_struct *ser)
{
	dbg();
	return 0;
}
static void c0serial_set_termios(struct uart_port *port, struct ktermios *new,
		struct ktermios *old)
{
	dbg();
}

static void c0serial_notify(int cont_id, int irq)
{
	int ret;

	dbg();
	/* commit pending changes */
	wmb();

	if ((ret = l4_irq_control(IRQ_CONTROL_RAISE,
				IRQ_GUEST_MASK(cont_id), irq
					) < 0)) {
		printk(KERN_ERR "Couldn't raise inter-container IRQ%d, "
				"ret: %d\n",
				irq, ret);
		BUG(); /* TODO: oops would be better? will this be oops? */
	}
}

static void c0serial_notify_tx(int cont_id)
{
	c0serial_notify(cont_id, C0SERIAL_IRQ_ACK_TX);
}

static void c0serial_notify_rx(int cont_id)
{
	c0serial_notify(cont_id, C0SERIAL_IRQ_ACK_RX);
}

void UART_PUT_CHAR(struct c0serial_uart_port* port, char ch)
{
	dbg();

	if (atomic_read(&port->tx_buf->opened) == 0)
		return;

	port->tx_buf->ch = ch;
	atomic_set(&port->tx_buf->count, 1);

	c0serial_notify_tx(port->tx_cont);
}

int UART_GET_CHAR(struct c0serial_uart_port* port, char* ch)
{
	dbg();

	if (atomic_read(&port->rx_buf->count) <= 0) {
		return 0;
	}

	*ch = port->rx_buf->ch;


	atomic_set(&port->rx_buf->count, 0);

	c0serial_notify_rx(port->tx_cont);

	return 1;
}

static inline struct c0serial_uart_port *
to_c0serial_uart_port(struct uart_port *uart)
{
	return container_of(uart, struct c0serial_uart_port, uart);
}


/*
 * Return TIOCSER_TEMT when transmitter FIFO and Shift register is empty.
 */
static u_int c0serial_tx_empty(struct uart_port *port)
{
	struct c0serial_uart_port *c0serial_port = to_c0serial_uart_port(port);

	dbg();
	if (atomic_read(&c0serial_port->tx_buf->count) == 0) {
		return TIOCSER_TEMT;
	}

	return 0;
}


/*
 * Characters received (called from interrupt handler)
 */
static void c0serial_rx_chars(struct uart_port *port)
{
	struct c0serial_uart_port *c0serial_port = to_c0serial_uart_port(port);
	struct tty_struct *tty = port->state->port.tty;
	char ch;

	dbg();

	if (UART_GET_CHAR(c0serial_port, &ch)) {
		tty_insert_flip_char(tty, ch, 0);
	}

}

/*
 * Transmit characters (called from tasklet with TXRDY interrupt
 * disabled)
 */
static void c0serial_tx_chars(struct uart_port *port)
{
	struct circ_buf *xmit = &port->state->xmit;
	struct c0serial_uart_port *c0serial_port = to_c0serial_uart_port(port);

	dbg();

	if (port->x_char && atomic_read(&c0serial_port->tx_buf->count) == 0) {
		UART_PUT_CHAR(c0serial_port, port->x_char);
		port->icount.tx++;
		port->x_char = 0;
	}
	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
		return;

	while (atomic_read(&c0serial_port->tx_buf->count) == 0) {
		UART_PUT_CHAR(c0serial_port, xmit->buf[xmit->tail]);
		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
		port->icount.tx++;
		if (uart_circ_empty(xmit))
			break;
	}

	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
		uart_write_wakeup(port);
}

/*
 * receive interrupt handler.
 */
static irqreturn_t c0serial_irq_ack_tx(int irq, void *dev_id)
{
	dbg();

	/* Interrupt receive */
	if (atomic_read(&c0serial_port.rx_buf->count) > 0) {
		c0serial_rx_chars(&c0serial_port.uart);
	}
	return IRQ_HANDLED;
}

/*
 * transmit interrupt handler.
 */
static irqreturn_t c0serial_irq_ack_rx(int irq, void *dev_id)
{
	dbg();
	if (atomic_read(&c0serial_port.tx_buf->count) == 0) {
		c0serial_tx_chars(&c0serial_port.uart);
	}
	return IRQ_HANDLED;
}


/*
 * Perform initialization and enable port for reception
 */
static int c0serial_startup(struct uart_port *port)
{
	struct c0serial_uart_port *c0serial_port = to_c0serial_uart_port(port);

	dbg();
	atomic_set(&c0serial_port->rx_buf->opened, 1);

	c0serial_notify_rx(c0serial_port->tx_cont);

	return 0;
}

/*
 * Disable the port
 */
static void c0serial_start_tx(struct uart_port *port)
{
	dbg();
	c0serial_tx_chars(port);
}


/*
 * Disable the port
 */
static void c0serial_shutdown(struct uart_port *port)
{
	struct c0serial_uart_port *c0serial_port = to_c0serial_uart_port(port);

	dbg();

	atomic_set(&c0serial_port->rx_buf->opened, 0);
}

/*
 * Return string describing the specified port
 */
static const char *c0serial_type(struct uart_port *port)
{
	dbg();
	return  NULL;
}

#ifdef CONFIG_CONSOLE_POLL
static int c0serial_poll_get_char(struct uart_port *port)
{
	char ch;

	dbg();

	while (!c0serial_port->rx_buf.count != 0)
		cpu_relax();

	UART_GET_CHAR(port, &ch);

	return ch;
}

static void c0serial_poll_put_char(struct uart_port *port, unsigned char ch)
{
	dbg();

	while (!c0serial_port->tx_buf.count != 0)
		cpu_relax();

	UART_PUT_CHAR(port, ch);
}
#endif


static struct uart_ops c0serial_pops = {
	.tx_empty	= c0serial_tx_empty,
	.start_tx	= c0serial_start_tx,

	.startup	= c0serial_startup,
	.shutdown	= c0serial_shutdown,
	.type		= c0serial_type,

#ifdef CONFIG_CONSOLE_POLL
	.poll_get_char	= c0serial_poll_get_char,
	.poll_put_char	= c0serial_poll_put_char,
#endif
	.set_mctrl    = c0serial_set_mctrl,
	.get_mctrl    = c0serial_get_mctrl,
	.stop_tx      = c0serial_stop_tx,
	.stop_rx      = c0serial_stop_rx,
	.enable_ms    = c0serial_enable_ms,
	.break_ctl    = c0serial_break_ctl,
	.release_port = c0serial_release_port,
	.request_port = c0serial_request_port,
	.config_port  = c0serial_config_port,
	.verify_port  = c0serial_verify_port,
	.set_termios  = c0serial_set_termios,
};

/*
 * Configure the port from the platform device resource info.
 */
static void __devinit c0serial_init_port(
		struct c0serial_uart_port *c0serial_port, unsigned int cont_idx
		)
{
	struct uart_port *port = &c0serial_port->uart;

	dbg();

	port->iotype		= UPIO_MEM;
	port->flags		= UPF_BOOT_AUTOCONF;
	port->ops		= &c0serial_pops;
	port->fifosize		= 1;
	port->line		= 0;
#if 0
	port->dev		= ;
	port->mapbase	= pdev->resource[0].start;
	port->irq	= pdev->resource[1].start;
#endif

	c0serial_port->rx_buf = get_buffer(cont_idx, C0SERIAL_BUF_FROM_CONT0);
	c0serial_port->tx_buf = get_buffer(cont_idx, C0SERIAL_BUF_TO_CONT0);
	c0serial_port->tx_cont = MASTER_CONTAINER;
	c0serial_notify_rx(MASTER_CONTAINER);

}
static void __devinit c0serial_master_init_port(
		struct c0serial_uart_port *c0serial_port, unsigned int cont_idx
		)
{
	struct uart_port *port = &c0serial_port->uart;

	dbg();

	port->iotype		= UPIO_MEM;
	port->flags		= UPF_BOOT_AUTOCONF;
	port->ops		= &c0serial_pops;
	port->fifosize		= 1;
	port->line		= cont_idx;
#if 0
	port->dev		= ;
	port->mapbase	= pdev->resource[0].start;
	port->irq	= pdev->resource[1].start;
#endif

	c0serial_port->rx_buf = get_buffer(cont_idx, C0SERIAL_BUF_TO_CONT0);
	c0serial_port->tx_buf = get_buffer(cont_idx, C0SERIAL_BUF_FROM_CONT0);
	c0serial_port->tx_cont = cont_idx;
	c0serial_notify_rx(cont_idx);

}
#ifdef CONFIG_SERIAL_C0SERIAL_CONSOLE
static void c0serial_console_putchar(struct uart_port *port, int ch)
{
	dbg();

	while (c0serial_port->to_buf.count != 0) {
		cpu_relax();
	}
	UART_PUT_CHAR(port, ch);
}

/*
 * Interrupts are disabled on entering
 */
static void c0serial_console_write(struct console *co, const char *s,
u_int count)
{
	struct uart_port *port = &c0serial_ports[co->index].uart;
	struct c0serial_uart_port *c0serial_port = to_c0serial_uart_port(port);

	dbg();

	uart_console_write(port, s, count, c0serial_console_putchar);

	/*
	 * wait for transmitter to become empty
	 */
	while (c0serial_port->to_buf.count != 0) {};
}


/*
 * If the port was already initialised (eg, by a boot loader),
 * try to determine the current setup.
 */
static void __init c0serial_console_get_options(struct uart_port
*port, int *baud,
					     int *parity, int *bits)
{
	dbg();
}

static int __init c0serial_console_setup(struct console *co, char *options)
{
	dbg();
	return 0;
}

static struct uart_driver c0serial_uart;

static struct console c0serial_console = {
	.name		= C0SERIAL_DEVICENAME,
	.write		= c0serial_console_write,
	.device		= uart_console_device,
	.setup		= c0serial_console_setup,
	.flags		= CON_PRINTBUFFER,
	.index		= -1,
	.data		= &c0serial_uart,
};

#define C0SERIAL_CONSOLE_DEVICE	(&c0serial_console)

/*
 * Early console initialization (before VM subsystem initialized).
 */
static int __init c0serial_console_init(void)
{
	dbg();

	if (c0serial_default_console_device) {
		add_preferred_console(C0SERIAL_DEVICENAME,
				      c0serial_default_console_device->id, NULL);
		c0serial_init_port(&c0serial_ports[c0serial_default_console_device->id],
				c0serial_default_console_device);
		register_console(&c0serial_console);
	}

	return 0;
}

console_initcall(c0serial_console_init);

/*
 * Late console initialization.
 */
static int __init c0serial_late_console_init(void)
{
	dbg();

	if (c0serial_default_console_device
	    && !(c0serial_console.flags & CON_ENABLED))
		register_console(&c0serial_console);

	return 0;
}

core_initcall(c0serial_late_console_init);

static inline bool c0serial_is_console_port(struct uart_port *port)
{
	dbg();
	return port->cons && port->cons->index == port->line;
}

#else
#define C0SERIAL_CONSOLE_DEVICE	NULL

static inline bool c0serial_is_console_port(struct uart_port *port)
{
	dbg();
	return false;
}
#endif

static
int c0serial_register_irqs(void)
{
	int ret;
	if ((ret = request_irq(C0SERIAL_IRQ_ACK_TX, c0serial_irq_ack_tx,
				0, "c0serial", NULL)) != 0) {
		printk(KERN_ERR "c0serial: can not register IRQ%d, ret=%d\n",
				C0SERIAL_IRQ_ACK_TX, ret);
		return -EIO;
	}
	if ((ret = request_irq(C0SERIAL_IRQ_ACK_RX, c0serial_irq_ack_rx,
				0, "c0serial", NULL)) != 0) {
		printk(KERN_ERR "c0serial: can not register IRQ%d, ret=%d\n",
				C0SERIAL_IRQ_ACK_RX, ret);
		free_irq(C0SERIAL_IRQ_ACK_TX, NULL);
		return -EIO;
	}
	return 0;
}

void c0serial_unregister_irqs(void)
{
	free_irq(C0SERIAL_IRQ_ACK_RX, NULL);
	free_irq(C0SERIAL_IRQ_ACK_TX, NULL);
}


static struct uart_driver c0serial_master_uart_driver = {
	.owner		= THIS_MODULE,
	.driver_name	= "c0serial_master_serial",
	.dev_name	= C0SERIAL_MASTER_DEVICENAME,
	.major		= SERIAL_C0SERIAL_MASTER_MAJOR,
	.minor		= MINOR_START,
	.nr		= CONFIG_CONTAINERS,
	.cons		= NULL,
};


static struct uart_driver c0serial_uart_driver = {
	.owner		= THIS_MODULE,
	.driver_name	= "c0serial_serial",
	.dev_name	= C0SERIAL_DEVICENAME,
	.major		= SERIAL_C0SERIAL_MAJOR,
	.minor		= MINOR_START,
	.nr		= 1,
	.cons		= C0SERIAL_CONSOLE_DEVICE,
};

static int __init c0serial_serial_init(void)
{
	int ret;
	int driver_registered = 0;
	int driver_master_registered = 0;
	int i;

	printk ("c0serial serial driver\n");
	dbg();

	cur_cont = cap_read_domain();
	c0serial_buffers = ioremap(C0SERIAL_BUFFER_PHSMEM,
			           CONFIG_CONTAINERS * 2 * sizeof(struct c0serial_buffer));

	if (!c0serial_buffers) {
		printk(KERN_ERR "c0serial: Couldn't map memory\n");
		return -ENODEV;
	}

	/* TODO: read from hypervisor */
	containers = CONFIG_CONTAINERS;
	if (containers > CONFIG_CONTAINERS) {
		printk(KERN_ERR "c0serial: Error - %d containers not supported\n",
			       containers);
		return -ENODEV;
	}

	ret = uart_register_driver(&c0serial_uart_driver);
	if (ret) {
		return ret;
	}
	driver_registered = 1;

	if (cur_cont == MASTER_CONTAINER) {
		ret = uart_register_driver(&c0serial_master_uart_driver);
		if (ret) {
			return ret;
		}
	}
	driver_master_registered = 1;

	c0serial_init_port(&c0serial_port, cur_cont);

	ret = uart_add_one_port(&c0serial_uart_driver, &c0serial_port.uart);
	if (ret) {
		goto err_out;
	}

	if (cur_cont == MASTER_CONTAINER) {
		for (i = 0; i < CONFIG_CONTAINERS; ++i) {
			c0serial_master_init_port(&c0serial_master_port[i], i);
			if ((ret = uart_add_one_port(&c0serial_master_uart_driver,
					&c0serial_master_port[i].uart))) {
				goto err_out;
			}
		}
	}

	if ((ret = c0serial_register_irqs()) < 0) {
		goto err_out;

	}

	return 0;

err_out:
	if (driver_registered) {
		uart_unregister_driver(&c0serial_uart_driver);
		driver_registered = 0;
	}

	if (driver_master_registered) {
		uart_unregister_driver(&c0serial_master_uart_driver);
		driver_master_registered = 0;
	}

	if (c0serial_buffers) {
		iounmap(c0serial_buffers);
		c0serial_buffers = NULL;
	}

	printk ("c0serial serial driver: init failed\n");
	return ret;
}

static void __exit c0serial_serial_exit(void)
{
	c0serial_unregister_irqs();
	uart_unregister_driver(&c0serial_uart_driver);

	dbg();

	if (cur_cont == MASTER_CONTAINER) {
		uart_unregister_driver(&c0serial_master_uart_driver);
	}

	if (c0serial_buffers) {
		iounmap(c0serial_buffers);
		c0serial_buffers = NULL;
	}
}

module_init(c0serial_serial_init);
module_exit(c0serial_serial_exit);

MODULE_AUTHOR("Dawid Ciężarkiewicz");
MODULE_DESCRIPTION("Codezero serial port driver");
MODULE_LICENSE("GPL");
MODULE_ALIAS("c0serial");
--- END ---

Regards,

-- 
Dawid Ciężarkiewicz
B-Labs. http://b-labs.com/
