Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1LLTO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:14:28 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51552 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab1LLTO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:14:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com>
References: <20111210132220.083204833@linutronix.de>
	<alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
	<alpine.LFD.2.02.1112102144370.3020@ionos>
	<alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
	<20111211103047.GA19299@elte.hu>
	<alpine.LFD.2.02.1112111459270.3020@ionos>
	<20111211155347.GA1297@elte.hu>
	<CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com>
	<20111212172059.GC23870@elte.hu>
	<CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com>
Date: Mon, 12 Dec 2011 21:14:25 +0200
X-Google-Sender-Auth: hZGTUN6YiMAPfQVr2xRC-LP_QuE
Message-ID: <CAOJsxLH8ToLUdDhc=ZiYAmJ+Dfc5LPxAenDnM4D_2i-mn4zDzA@mail.gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 7:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>> I'm seeing 1.5 usecs per character for this little benchmark:
>>
>> Interesting - what do you see with the top -b measurement i
>> posted - can you see similar slowdowns?

On Mon, Dec 12, 2011 at 8:40 PM, Pekka Enberg <penberg@kernel.org> wrote:
> ssh-4.2# time top -d 0.01 -n 10 -b
>
> [snip]
>
> real    0m2.935
> user    0m0.006s
> sys     0m0.049s
>
> That's 9.7 usecs per character which is roughly 6x slowdown.
>
> It seems to be related to interrupt handling because if I bump up
> TIMER_INTEVAL_NS to 10 msec:

[snip]

Looking at drivers/tty/serial/8250.c, we have:

static void serial8250_console_putchar(struct uart_port *port, int ch)
{
        struct uart_8250_port *up =
                container_of(port, struct uart_8250_port, port);

        wait_for_xmitr(up, UART_LSR_THRE);
        serial_out(up, UART_TX, ch);
}

in tools/kvm/hw/serial.c::serial8250_out() we do:

        case UART_TX:
                if (!(dev->lcr & UART_LCR_DLAB)) {
                        char *addr = data;

                        if (!(dev->mcr & UART_MCR_LOOP))
                                term_putc(CONSOLE_8250, addr, size, dev->id);
                        /* else FIXME: Inject data into rcv path for LOOP */

                        if (++dev->txcnt == 16)
                                dev->lsr &= ~(UART_LSR_TEMT | UART_LSR_THRE);
                        break;

which clears UART_LSR_THRE after 16 characters. UART_LSR_THRE is only
enabled in serial8250__update_consoles() and serial8250_update_irq()
which are completely bound by TIMER_INTERVAL_NS.

                        Pekka
