Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033Ab2FAIaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:30:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59889 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929Ab2FAIaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:30:25 -0400
MIME-Version: 1.0
In-Reply-To: <8854635ac5471f8671b93c65e3663eb1cb204c9d.1338454156.git.dvhart@linux.intel.com>
References: <8854635ac5471f8671b93c65e3663eb1cb204c9d.1338454156.git.dvhart@linux.intel.com>
Date: Fri, 1 Jun 2012 17:30:25 +0900
Message-ID: <CANKRQnhZErpvcsRW3ukNzY0_zv4x=5OzQ-sr+aeuxL63=tQ=4A@mail.gmail.com>
Subject: Re: [RFC PATCH] pch_uart: Add eg20t_port lock field, avoid recursive spinlocks
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 5:54 PM, Darren Hart <dvhart@linux.intel.com> wrote:
> @@ -1376,7 +1379,8 @@ static void pch_uart_set_termios(struct uart_port *port,
>
>        baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
>
> -       spin_lock_irqsave(&port->lock, flags);
> +       spin_lock_irqsave(&priv->lock, flags);
> +       spin_lock(&port->lock);
>
>        uart_update_timeout(port, termios->c_cflag, baud);
>        rtn = pch_uart_hal_set_line(priv, baud, parity, bits, stb);
> @@ -1389,7 +1393,8 @@ static void pch_uart_set_termios(struct uart_port *port,
>                tty_termios_encode_baud_rate(termios, baud, baud);
>
>  out:
> -       spin_unlock_irqrestore(&port->lock, flags);
> +       spin_unlock(&port->lock);
> +       spin_unlock_irqrestore(&priv->lock, flags);
>  }

Are both port->lock and priv->lock really necessary ?


> @@ -1572,7 +1578,9 @@ pch_console_write(struct console *co, const char *s, unsigned int count)
>
>        if (locked)
>                spin_unlock(&priv->port.lock);
> +       spin_unlock(&priv->lock);
>        local_irq_restore(flags);
> +
>  }

Looks spare blank line.

thanks.
-- 
ROHM Co., Ltd.
tomoya
