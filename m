Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673Ab2FAShf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:37:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:61689 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932756Ab2FAShd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:37:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="173767908"
Message-ID: <4FC90BAD.3080606@linux.intel.com>
Date: Fri, 01 Jun 2012 11:36:29 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: [RFC PATCH] pch_uart: Add eg20t_port lock field, avoid recursive
 spinlocks
References: <8854635ac5471f8671b93c65e3663eb1cb204c9d.1338454156.git.dvhart@linux.intel.com> <CANKRQnhZErpvcsRW3ukNzY0_zv4x=5OzQ-sr+aeuxL63=tQ=4A@mail.gmail.com>
In-Reply-To: <CANKRQnhZErpvcsRW3ukNzY0_zv4x=5OzQ-sr+aeuxL63=tQ=4A@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/01/2012 01:30 AM, Tomoya MORINAGA wrote:
> On Thu, May 31, 2012 at 5:54 PM, Darren Hart <dvhart@linux.intel.com> wrote:
>> @@ -1376,7 +1379,8 @@ static void pch_uart_set_termios(struct uart_port *port,
>>
>>        baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
>>
>> -       spin_lock_irqsave(&port->lock, flags);
>> +       spin_lock_irqsave(&priv->lock, flags);
>> +       spin_lock(&port->lock);
>>
>>        uart_update_timeout(port, termios->c_cflag, baud);
>>        rtn = pch_uart_hal_set_line(priv, baud, parity, bits, stb);
>> @@ -1389,7 +1393,8 @@ static void pch_uart_set_termios(struct uart_port *port,
>>                tty_termios_encode_baud_rate(termios, baud, baud);
>>
>>  out:
>> -       spin_unlock_irqrestore(&port->lock, flags);
>> +       spin_unlock(&port->lock);
>> +       spin_unlock_irqrestore(&priv->lock, flags);
>>  }
> 
> Are both port->lock and priv->lock really necessary ?

The priv lock protects the pch_uart_hal* calls and the io access.

The port lock protects the uart_update_timeout call. I'm assuming the
8250.c driver is correct in holding the port lock before making this
call and making other modifcations to the port struct.

So yes, I believe both are required. The port->lock was used as the lock
to protect the private data in the interrupt handler,
pch_uart_interrupt. If we could avoid holding that lock across the
entire function, limiting it to just around the pch_uart_hal calls
(perhaps by adding it to the hal calls and adding lockless __pch_uart*
calls) we could avoid the recursive lock that occurs with handle_rx. I
still think a priv-lock is a good idea though, even if just to clarify
what is being protected.

Thoughts?

> 
> 
>> @@ -1572,7 +1578,9 @@ pch_console_write(struct console *co, const char *s, unsigned int count)
>>
>>        if (locked)
>>                spin_unlock(&priv->port.lock);
>> +       spin_unlock(&priv->lock);
>>        local_irq_restore(flags);
>> +
>>  }
> 
> Looks spare blank line.

Thanks, will fix for V2 after this discussion wraps up.

> 
> thanks.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
