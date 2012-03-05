Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030Ab2CEN50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:57:26 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34849 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964850Ab2CENx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:27 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 30/68] TTY: simserial, remove support of shared interrupts
Date: Mon,  5 Mar 2012 14:52:17 +0100
Message-Id: <1330955575-26641-31-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It never worked there. The ISR was never written for that kind of
stuff. So remove all that crap with a hash of linked lists and pass
the pointer directly to the ISR.

BTW this answers the question there:
  * I don't know exactly why they don't use the dev_id opaque data
  * pointer instead of this extra lookup table

-> Because they thought they will support more devices bound to a
single interrupt w/o IRQF_SHARED. They would need exactly the hash
there.

What I don't understand is rebinding of the interrupt in the shutdown
path. They perhaps meant to do just synchronize_irq? In any case, this
is all gone and free_irq there properly.

By removing the hash we save some bits (exactly NR_IRQS * 8 bytes of
.bss and over a kilo of .text):
before:
   text    data     bss     dec     hex filename
  19600     320    8227   28147    6df3 ../a/ia64/arch/ia64/hp/sim/simserial.o
after:
   text    data     bss     dec     hex filename
  18568     320      28   18916    49e4 ../a/ia64/arch/ia64/hp/sim/simserial.o

Note that a shared interrupt could not work too. request_irq requires
data parameter to be non-NULL. So the whole IRQ_T exercise was
pointless.

Finally, this helps us remove another two members of async_struct :).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/hp/sim/simserial.c |   64 +++++-------------------------------------
 include/linux/serialP.h      |    2 --
 2 files changed, 7 insertions(+), 59 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index d32b759..c35552d 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -92,8 +92,6 @@ static struct serial_uart_config uart_config[] = {
 
 struct tty_driver *hp_simserial_driver;
 
-static struct async_struct *IRQ_ports[NR_IRQS];
-
 static struct console *console;
 
 static unsigned char *tmp_buf;
@@ -167,14 +165,9 @@ static  void receive_chars(struct tty_struct *tty)
  */
 static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
 {
-	struct async_struct * info;
+	struct async_struct *info = dev_id;
 
-	/*
-	 * I don't know exactly why they don't use the dev_id opaque data
-	 * pointer instead of this extra lookup table
-	 */
-	info = IRQ_ports[irq];
-	if (!info || !info->tty) {
+	if (!info->tty) {
 		printk(KERN_INFO "simrs_interrupt_single: info|tty=0 info=%p problem\n", info);
 		return IRQ_NONE;
 	}
@@ -456,7 +449,6 @@ static void shutdown(struct async_struct * info)
 {
 	unsigned long	flags;
 	struct serial_state *state = info->state;
-	int		retval;
 
 	if (!(state->flags & ASYNC_INITIALIZED))
 		return;
@@ -468,33 +460,8 @@ static void shutdown(struct async_struct * info)
 
 	local_irq_save(flags);
 	{
-		/*
-		 * First unlink the serial port from the IRQ chain...
-		 */
-		if (info->next_port)
-			info->next_port->prev_port = info->prev_port;
-		if (info->prev_port)
-			info->prev_port->next_port = info->next_port;
-		else
-			IRQ_ports[state->irq] = info->next_port;
-
-		/*
-		 * Free the IRQ, if necessary
-		 */
-		if (state->irq && (!IRQ_ports[state->irq] ||
-				   !IRQ_ports[state->irq]->next_port)) {
-			if (IRQ_ports[state->irq]) {
-				free_irq(state->irq, NULL);
-				retval = request_irq(state->irq, rs_interrupt_single,
-						     IRQ_T(state), "serial",
-						     NULL);
-
-				if (retval)
-					printk(KERN_ERR "serial shutdown: request_irq: error %d"
-					       "  Couldn't reacquire IRQ.\n", retval);
-			} else
-				free_irq(state->irq, NULL);
-		}
+		if (state->irq)
+			free_irq(state->irq, info);
 
 		if (info->xmit.buf) {
 			free_page((unsigned long) info->xmit.buf);
@@ -645,7 +612,6 @@ startup(struct async_struct *info)
 {
 	unsigned long flags;
 	int	retval=0;
-	irq_handler_t handler;
 	struct serial_state *state= info->state;
 	unsigned long page;
 
@@ -677,29 +643,13 @@ startup(struct async_struct *info)
 	/*
 	 * Allocate the IRQ if necessary
 	 */
-	if (state->irq && (!IRQ_ports[state->irq] ||
-			  !IRQ_ports[state->irq]->next_port)) {
-		if (IRQ_ports[state->irq]) {
-			retval = -EBUSY;
-			goto errout;
-		} else
-			handler = rs_interrupt_single;
-
-		retval = request_irq(state->irq, handler, IRQ_T(state),
-				"simserial", NULL);
+	if (state->irq) {
+		retval = request_irq(state->irq, rs_interrupt_single,
+				IRQ_T(state), "simserial", info);
 		if (retval)
 			goto errout;
 	}
 
-	/*
-	 * Insert serial port into IRQ chain.
-	 */
-	info->prev_port = NULL;
-	info->next_port = IRQ_ports[state->irq];
-	if (info->next_port)
-		info->next_port->prev_port = info;
-	IRQ_ports[state->irq] = info;
-
 	if (info->tty) clear_bit(TTY_IO_ERROR, &info->tty->flags);
 
 	info->xmit.head = info->xmit.tail = 0;
diff --git a/include/linux/serialP.h b/include/linux/serialP.h
index 6ce488c..b8543f9 100644
--- a/include/linux/serialP.h
+++ b/include/linux/serialP.h
@@ -56,8 +56,6 @@ struct async_struct {
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
 	wait_queue_head_t	delta_msr_wait;
-	struct async_struct	*next_port; /* For the linked list */
-	struct async_struct	*prev_port;
 };
 
 #endif /* _LINUX_SERIAL_H */
-- 
1.7.9.2


