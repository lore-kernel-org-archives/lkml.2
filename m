Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab1IUEub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 00:50:31 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:53127 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab1IUEu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 00:50:29 -0400
Date: Wed, 21 Sep 2011 14:50:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jamie Iles <jamie@jamieiles.com>,
        Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the tty tree with the powerpc tree
Message-Id: <20110921145023.e38d553e218c8b5a2e71e9d8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/8250.c between commit 7df5659eefad ("serial/8250: Move
UPIO_TSI to powerpc") from the powerpc tree and commit 4834d0289785
("tty: serial8250: remove UPIO_DWAPB{,32}") from the tty tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/8250.c
index 610b8e6,435ce14..0000000
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@@ -443,42 -443,24 +443,6 @@@ static void au_serial_out(struct uart_p
  	__raw_writel(value, p->membase + offset);
  }
  
- /* Save the LCR value so it can be re-written when a Busy Detect IRQ occurs. */
- static inline void dwapb_save_out_value(struct uart_port *p, int offset,
- 					int value)
- {
- 	struct uart_8250_port *up =
- 		container_of(p, struct uart_8250_port, port);
- 
- 	if (offset == UART_LCR)
- 		up->lcr = value;
- }
- 
- /* Read the IER to ensure any interrupt is cleared before returning from ISR. */
- static inline void dwapb_check_clear_ier(struct uart_port *p, int offset)
- {
- 	if (offset == UART_TX || offset == UART_IER)
- 		p->serial_in(p, UART_IER);
- }
- 
- static void dwapb_serial_out(struct uart_port *p, int offset, int value)
- {
- 	int save_offset = offset;
- 	offset = map_8250_out_reg(p, offset) << p->regshift;
- 	dwapb_save_out_value(p, save_offset, value);
- 	writeb(value, p->membase + offset);
- 	dwapb_check_clear_ier(p, save_offset);
- }
- 
- static void dwapb32_serial_out(struct uart_port *p, int offset, int value)
- {
- 	int save_offset = offset;
- 	offset = map_8250_out_reg(p, offset) << p->regshift;
- 	dwapb_save_out_value(p, save_offset, value);
- 	writel(value, p->membase + offset);
- 	dwapb_check_clear_ier(p, save_offset);
- }
- 
 -static unsigned int tsi_serial_in(struct uart_port *p, int offset)
 -{
 -	unsigned int tmp;
 -	offset = map_8250_in_reg(p, offset) << p->regshift;
 -	if (offset == UART_IIR) {
 -		tmp = readl(p->membase + (UART_IIR & ~3));
 -		return (tmp >> 16) & 0xff; /* UART_IIR % 4 == 2 */
 -	} else
 -		return readb(p->membase + offset);
 -}
 -
 -static void tsi_serial_out(struct uart_port *p, int offset, int value)
 -{
 -	offset = map_8250_out_reg(p, offset) << p->regshift;
 -	if (!((offset == UART_IER) && (value & UART_IER_UUE)))
 -		writeb(value, p->membase + offset);
 -}
 -
  static unsigned int io_serial_in(struct uart_port *p, int offset)
  {
  	offset = map_8250_in_reg(p, offset) << p->regshift;
@@@ -517,16 -501,11 +483,6 @@@ static void set_io_from_upio(struct uar
  		p->serial_out = au_serial_out;
  		break;
  
- 	case UPIO_DWAPB:
- 		p->serial_in = mem_serial_in;
- 		p->serial_out = dwapb_serial_out;
- 		break;
- 
- 	case UPIO_DWAPB32:
- 		p->serial_in = mem32_serial_in;
- 		p->serial_out = dwapb32_serial_out;
- 		break;
- 
 -	case UPIO_TSI:
 -		p->serial_in = tsi_serial_in;
 -		p->serial_out = tsi_serial_out;
 -		break;
 -
  	default:
  		p->serial_in = io_serial_in;
  		p->serial_out = io_serial_out;
