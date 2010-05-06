Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab0EFK7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 06:59:41 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:50230 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab0EFK7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 06:59:39 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 May 2010 06:59:39 EDT
Subject: Re: [Nios2-dev] [PATCH 1/2] serial: Add driver for the Altera JTAG
 UART
From: Ian Abbott <abbotti@mev.co.uk>
To: "nios2-dev@sopc.et.ntust.edu.tw" <nios2-dev@sopc.et.ntust.edu.tw>
CC: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <e83e74abd82079284d5c8f62b78f2417ebc9ee27.1273048151.git.tklauser@distanz.ch>
References: <cover.1273048151.git.tklauser@distanz.ch>
	 <e83e74abd82079284d5c8f62b78f2417ebc9ee27.1273048151.git.tklauser@distanz.ch>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 6 May 2010 11:59:31 +0100
Message-ID: <1273143571.3477.29.camel@gentoo-ija64.mev.local>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 09:35 +0100, Tobias Klauser wrote:
> Add an UART driver for the JTAG UART component available as a SOPC
> (System on Programmable Chip) component for Altera FPGAs.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
[...]
> +#if defined(CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS)
> +static void altera_jtaguart_console_putc(struct console *co, const char c)
> +{
> +       struct uart_port *port = &(altera_jtaguart_ports + co->index)->port;
> +       unsigned long status;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&port->lock, flags);
> +       while (((status = readl(port->membase + ALTERA_JTAGUART_CONTROL_REG)) &
> +               ALTERA_JTAGUART_CONTROL_WSPACE_MSK) == 0) {
> +               if ((status & ALTERA_JTAGUART_CONTROL_AC_MSK) == 0) {
> +                       spin_unlock_irqrestore(&port->lock, flags);
> +                       return; /* no connection activity */
> +               }
> +               spin_unlock_irqrestore(&port->lock, flags);
> +               cpu_relax();
> +               spin_lock_irqsave(&port->lock, flags);
> +       }
> +       writel(c, port->membase + ALTERA_JTAGUART_DATA_REG);
> +       spin_unlock_irqrestore(&port->lock, flags);
> +}
> +#else
> +static void altera_jtaguart_console_putc(struct console *co, const char c)
> +{
> +       struct uart_port *port = &(altera_jtaguart_ports + co->index)->port;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&port->lock, flags);
> +       while ((readl(port->membase + ALTERA_JTAGUART_CONTROL_REG) &
> +               ALTERA_JTAGUART_CONTROL_WSPACE_MSK) == 0) {
> +               spin_unlock_irqrestore(&port->lock, flags);
> +               cpu_relax();
> +               spin_lock_irqsave(&port->lock, flags);
> +       }
> +       writel(c, port->membase + ALTERA_JTAGUART_DATA_REG);
> +       spin_unlock_irqrestore(&port->lock, flags);
> +}
> +#endif

I was originally responsible for adding the spin locks to these console
putc functions, but I'm not sure what the policy is regarding that, as
the 8250 driver doesn't use them for console output for example.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

