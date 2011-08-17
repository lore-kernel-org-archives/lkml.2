Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1HQOGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:06:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48927 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab1HQOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:06:00 -0400
MIME-Version: 1.0
Date: Wed, 17 Aug 2011 10:05:59 -0400
Message-ID: <CAOGqxeWf8TFO4SHcwLRod7R0mD9YudZNX0PFybe+aeNzrjOOww@mail.gmail.com>
Subject: [PATCH/resend] 8250: Fix race condition in serial8250_backup_timeout()
From: Alan Cooper <alcooperx@gmail.com>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to fix an issue where output will suddenly become very slow.
The problem occurs on 8250 UARTS with the hardware bug UART_BUG_THRE.

BACKGROUND
For normal UARTs (without UART_BUG_THRE): When the serial core layer
gets new transmit data and the transmitter is idle, it buffers the
data and calls the 8250s' serial8250_start_tx() routine which will
simply enable the TX interrupt in the IER register and return. This
should immediately fire a THRE interrupt and begin transmitting the
data.
For buggy UARTs (with UART_BUG_THRE): merely enabling the TX interrupt
in IER does not necessarily generate a new THRE interrupt.
Therefore, a background timer periodically checks to see if there is
pending data, and starts transmission if that is the case.

The bug happens on SMP systems when the system has nothing to transmit,
the transmit interrupt is disabled and the following sequence occurs:
- CPU0: The background timer routine serial8250_backup_timeout()
 starts and saves the state of the interrupt enable register (IER)
 and then disables all interrupts in IER. NOTE: The transmit interrupt
 (TI) bit is saved as disabled.
- CPU1: The serial core gets data to transmit, grabs the port lock and
 calls serial8250_start_tx() which enables the TI in IER.
- CPU0: serial8250_backup_timeout() waits for the port lock.
- CPU1: finishes (with TI enabled) and releases the port lock.
- CPU0: serial8250_backup_timeout() calls the interrupt routine which
 will transmit the next fifo's worth of data and then restores the
 IER from the previously saved value (TI disabled).
At this point, as long as the serial core has more transmit data
buffered, it will not call serial8250_start_tx() again and the
background timer routine will slowly transmit the data.

The fix is to have serial8250_start_tx() get the port lock before
it saves the IER state and release it after restoring IER. This
also means that we have to call  transmit_chars() instead of
serial8250_handle_port() because serial8250_handle_port also grabs
the lock. This will prevent serial8250_start_tx() from running in parallel.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
---
 drivers/tty/serial/8250.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index b4129f5..8fb7e8f 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -1819,6 +1819,8 @@ static void serial8250_backup_timeout(unsigned long data)
       unsigned int iir, ier = 0, lsr;
       unsigned long flags;

+       spin_lock_irqsave(&up->port.lock, flags);
+
       /*
        * Must disable interrupts or else we risk racing with the interrupt
        * based handler.
@@ -1836,10 +1838,8 @@ static void serial8250_backup_timeout(unsigned long data)
        * the "Diva" UART used on the management processor on many HP
        * ia64 and parisc boxes.
        */
-       spin_lock_irqsave(&up->port.lock, flags);
       lsr = serial_in(up, UART_LSR);
       up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
-       spin_unlock_irqrestore(&up->port.lock, flags);
       if ((iir & UART_IIR_NO_INT) && (up->ier & UART_IER_THRI) &&
           (!uart_circ_empty(&up->port.state->xmit) || up->port.x_char) &&
           (lsr & UART_LSR_THRE)) {
@@ -1848,11 +1848,13 @@ static void serial8250_backup_timeout(unsigned
long data)
       }

       if (!(iir & UART_IIR_NO_INT))
-               serial8250_handle_port(up);
+               transmit_chars(up);

       if (is_real_interrupt(up->port.irq))
               serial_out(up, UART_IER, ier);

+       spin_unlock_irqrestore(&up->port.lock, flags);
+
       /* Standard timer interval plus 0.2s to keep the port running */
       mod_timer(&up->timer,
               jiffies + uart_poll_timeout(&up->port) + HZ / 5);
--
1.7.3.2
