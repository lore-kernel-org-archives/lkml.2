Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953Ab2CENxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:53:42 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34860 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab2CENx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 25/68] TTY: serialP, remove unused material
Date: Mon,  5 Mar 2012 14:52:12 +0100
Message-Id: <1330955575-26641-26-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, remove unused macro and rs_multiport_struct structure. Nobody
uses them at all.

Further, the 2 drivers (they are below) which use the rest of
structures from serialP.h (async_struct and serial_state) do not use
all the members. Remove the members:
* which are unused or
* which are only initialized and never used for something real.

Everybody should avoid the structures with a looong distance.

Finally, remove the ALPHA kludge MCR quirks. They are 1:1 copy from
8250.h. No need to redefine them here.

The 2 promised users of the structures:
arch/ia64/hp/sim/simserial.c
drivers/tty/amiserial.c

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   10 +------
 drivers/tty/amiserial.c      |    6 -----
 include/linux/serialP.h      |   59 ------------------------------------------
 3 files changed, 1 insertion(+), 74 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 164b73d..c8e728bf 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -70,7 +70,7 @@ static char *serial_version = "0.6";
  */
 static struct serial_state rs_table[NR_PORTS]={
   /* UART CLK   PORT IRQ     FLAGS        */
-  { 0, BASE_BAUD, 0x3F8, 0, STD_COM_FLAGS,0,PORT_16550 }  /* ttyS0 */
+  { BASE_BAUD, 0x3F8, 0, STD_COM_FLAGS, PORT_16550 }  /* ttyS0 */
 };
 
 /*
@@ -192,11 +192,6 @@ static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
  * -------------------------------------------------------------------
  */
 
-static void do_softint(struct work_struct *private_)
-{
-	printk(KERN_ERR "simserial: do_softint called\n");
-}
-
 static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct async_struct *info = (struct async_struct *)tty->driver_data;
@@ -639,13 +634,10 @@ static int get_async_struct(int line, struct async_struct **ret_info)
 	}
 	init_waitqueue_head(&info->open_wait);
 	init_waitqueue_head(&info->close_wait);
-	init_waitqueue_head(&info->delta_msr_wait);
-	info->magic = SERIAL_MAGIC;
 	info->port = sstate->port;
 	info->flags = sstate->flags;
 	info->xmit_fifo_size = sstate->xmit_fifo_size;
 	info->line = line;
-	INIT_WORK(&info->work, do_softint);
 	info->state = sstate;
 	if (sstate->info) {
 		kfree(info);
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 7532862..c6d8913 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -473,7 +473,6 @@ static irqreturn_t ser_rx_int(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	receive_chars(info);
-	info->last_active = jiffies;
 #ifdef SERIAL_DEBUG_INTR
 	printk("end.\n");
 #endif
@@ -494,7 +493,6 @@ static irqreturn_t ser_tx_int(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	  transmit_chars(info);
-	  info->last_active = jiffies;
 #ifdef SERIAL_DEBUG_INTR
 	  printk("end.\n");
 #endif
@@ -828,7 +826,6 @@ static void change_speed(struct async_struct *info,
 	mb();
 	}
 
-	info->LCR = cval;				/* Save LCR */
 	local_irq_restore(flags);
 }
 
@@ -1743,7 +1740,6 @@ static int get_async_struct(int line, struct async_struct **ret_info)
 	init_waitqueue_head(&info->close_wait);
 	init_waitqueue_head(&info->delta_msr_wait);
 #endif
-	info->magic = SERIAL_MAGIC;
 	info->port = sstate->port;
 	info->flags = sstate->flags;
 	info->xmit_fifo_size = sstate->xmit_fifo_size;
@@ -1840,7 +1836,6 @@ static inline void line_info(struct seq_file *m, struct serial_state *state)
 	if (!info) {
 		info = &scr_info;	/* This is just for serial_{in,out} */
 
-		info->magic = SERIAL_MAGIC;
 		info->flags = state->flags;
 		info->quot = 0;
 		info->tty = NULL;
@@ -1987,7 +1982,6 @@ static int __init amiga_serial_probe(struct platform_device *pdev)
 		goto fail_put_tty_driver;
 
 	state = rs_table;
-	state->magic = SSTATE_MAGIC;
 	state->port = (int)&custom.serdatr; /* Just to give it a value */
 	state->line = 0;
 	state->custom_divisor = 0;
diff --git a/include/linux/serialP.h b/include/linux/serialP.h
index ec27b34..c1acdb2 100644
--- a/include/linux/serialP.h
+++ b/include/linux/serialP.h
@@ -26,32 +26,23 @@
 #include <linux/wait.h>
 
 struct serial_state {
-	int	magic;
 	int	baud_base;
 	unsigned long	port;
 	int	irq;
 	int	flags;
-	int	hub6;
 	int	type;
 	int	line;
-	int	revision;	/* Chip revision (950) */
 	int	xmit_fifo_size;
 	int	custom_divisor;
 	int	count;
-	u8	*iomem_base;
-	u16	iomem_reg_shift;
 	unsigned short	close_delay;
 	unsigned short	closing_wait; /* time to wait before closing */
 	struct async_icount	icount;	
-	int	io_type;
 	struct async_struct *info;
-	struct pci_dev	*dev;
 };
 
 struct async_struct {
-	int			magic;
 	unsigned long		port;
-	int			hub6;
 	int			flags;
 	int			xmit_fifo_size;
 	struct serial_state	*state;
@@ -63,21 +54,12 @@ struct async_struct {
 	int			x_char;	/* xon/xoff character */
 	int			close_delay;
 	unsigned short		closing_wait;
-	unsigned short		closing_wait2; /* obsolete */
 	int			IER; 	/* Interrupt Enable Register */
 	int			MCR; 	/* Modem control register */
-	int			LCR; 	/* Line control register */
-	int			ACR;	 /* 16950 Additional Control Reg. */
 	unsigned long		event;
-	unsigned long		last_active;
 	int			line;
 	int			blocked_open; /* # of blocked opens */
  	struct circ_buf		xmit;
- 	spinlock_t		xmit_lock;
-	u8			*iomem_base;
-	u16			iomem_reg_shift;
-	int			io_type;
-	struct work_struct			work;
 	struct tasklet_struct	tlet;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
@@ -86,51 +68,10 @@ struct async_struct {
 	struct async_struct	*prev_port;
 };
 
-#define CONFIGURED_SERIAL_PORT(info) ((info)->port || ((info)->iomem_base))
-
-#define SERIAL_MAGIC 0x5301
-#define SSTATE_MAGIC 0x5302
-
 /*
  * Events are used to schedule things to happen at timer-interrupt
  * time, instead of at rs interrupt time.
  */
 #define RS_EVENT_WRITE_WAKEUP	0
 
-/*
- * Multiport serial configuration structure --- internal structure
- */
-struct rs_multiport_struct {
-	int		port1;
-	unsigned char	mask1, match1;
-	int		port2;
-	unsigned char	mask2, match2;
-	int		port3;
-	unsigned char	mask3, match3;
-	int		port4;
-	unsigned char	mask4, match4;
-	int		port_monitor;
-};
-
-#if defined(__alpha__) && !defined(CONFIG_PCI)
-/*
- * Digital did something really horribly wrong with the OUT1 and OUT2
- * lines on at least some ALPHA's.  The failure mode is that if either
- * is cleared, the machine locks up with endless interrupts.
- *
- * This is still used by arch/mips/au1000/common/serial.c for some weird
- * reason (mips != alpha!)
- */
-#define ALPHA_KLUDGE_MCR  (UART_MCR_OUT2 | UART_MCR_OUT1)
-#elif defined(CONFIG_SBC8560)
-/*
- * WindRiver did something similarly broken on their SBC8560 board. The
- * UART tristates its IRQ output while OUT2 is clear, but they pulled
- * the interrupt line _up_ instead of down, so if we register the IRQ
- * while the UART is in that state, we die in an IRQ storm. */
-#define ALPHA_KLUDGE_MCR (UART_MCR_OUT2)
-#else
-#define ALPHA_KLUDGE_MCR 0
-#endif
-
 #endif /* _LINUX_SERIAL_H */
-- 
1.7.9.2


