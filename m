Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab0KCANT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 20:13:19 -0400
Received: from mxout3.netvision.net.il ([194.90.6.2]:41293 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0KCANQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 20:13:16 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <4CD0A988.4070204@billauer.co.il>
Date: Wed, 03 Nov 2010 02:15:04 +0200
From: Eli Billauer <eli@billauer.co.il>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: open() on /dev/tty takes 30 seconds on 2.6.36
References: <4CCBCD8E.1020601@billauer.co.il>
 <201010310436.18613.arnd@arndb.de> <4CCE140C.8050909@billauer.co.il>
 <201011012039.16312.arnd@arndb.de>
In-reply-to: <201011012039.16312.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

> Ok, that's certainly modem-manager in the tty_release function, calling
> uart_close, which has this code:
>
>         if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE) {
>                 /*
>                  * hack: open-coded tty_wait_until_sent to avoid
>                  * recursive tty_lock
>                  */
>                 long timeout = msecs_to_jiffies(port->closing_wait);
>                 if (wait_event_interruptible_timeout(tty->write_wait,
>                                 !tty_chars_in_buffer(tty), timeout) >= 0)
>                         __uart_wait_until_sent(uport, timeout);
>         }
>
> port->closing_wait gets initialized to 30 seconds, which fits your
> symptom.
>   
I lost you here. Maybe my version is outdated? The most similar thing I 
have is this in tty_port.c, in tty_port_close_start():

    if (test_bit(ASYNCB_INITIALIZED, &port->flags) &&
            port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
        tty_wait_until_sent(tty, port->closing_wait);

I put a printk on invocations of tty_wait_until_sent(), which was called 
like crazy during bootup on behalf of tty1, and then never again after 
boot was completed. I should point out, that during this session, all I 
did was to wait a few minutes and then reboot the computer from the GUI 
login console. So I never logged in. Anyhow, the ttySx ports were opened 
and closed, the same 30 seconds delays, but no call to 
tty_wait_until_sent() until kernel logging was stopped.

> What does "lspci -vvx" show about the
> port? 
It turns out, that the device, to which ttyS1-ttyS3 are attached is a 
soft modem, which doesn't even have drivers for a 64 bits system. There 
is no /dev/ttyS4, which is consistent with the "Couldn't register serial 
port 0000:05:04.0: -28" message. Anyhow, I can't say I understand why 
any serial port was allocated to this modem. But it's not like I 
understand how it should work.

05:04.0 Modem: ALi Corporation SmartLink SmartPCI563 56K Modem (prog-if 
00 [Generic])
    Subsystem: Device 2020:545a
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at fbbff000 (32-bit, non-prefetchable) [size=4K]
    Region 1: I/O ports at be00 [size=256]
    Capabilities: [40] Power Management version 2
        Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: serial
00: b9 10 5a 54 07 00 90 02 00 00 03 07 00 20 00 00
10: 00 f0 bf fb 01 be 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 20 20 5a 54
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00

   Eli

-- 
Web: http://www.billauer.co.il

