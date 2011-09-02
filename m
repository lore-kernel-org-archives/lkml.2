Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1IBSXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:23:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49807 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab1IBSXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <20110310014952.38b7a6ef@redhat.com>
References: <20110216161728.GA8431@darkside.kls.lan>
	<20110310014952.38b7a6ef@redhat.com>
Date: Fri, 2 Sep 2011 20:23:00 +0200
Message-ID: <CAJJYPdmmaDuW-yhLQbGj9ihfiJOp5K_C_Vn6dCTzmr0A_gaKjg@mail.gmail.com>
Subject: Re: kernel BUG and freeze on cat /proc/tty/driver/serial
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: "Mario 'BitKoenig' Holbe" <Mario.Holbe@tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/10 Chuck Ebbert <cebbert@redhat.com>:
> On Wed, 16 Feb 2011 17:17:28 +0100
> "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE> wrote:
>
>> reading /proc/tty/driver/serial leads to a NULL pointer dereference
>> BUG and freeze on a serial-console enabled 2.6.35.{4,10,11} and
>> 2.6.37. 2.6.32.28 does fine without BUG and freeze.
>>
>> Fresh boot 2.6.35.11 into emergency...
>> # cat /proc/tty/driver/serial
>> [   73.199568] BUG: unable to handle kernel NULL pointer dereference
>> at 00000099 [   73.227373] IP: [<c11a8969>] tty_ldisc_try+0x10/0x35
>
> The oops is here, in uart_handle_dcd_change() in serial_core.h:
>
>        struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
>
> (port->tty is NULL)
>
> Called from check_modem_status() in 8250.c:
>
>                if (status & UART_MSR_DDCD)
>                        uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
>
> So apparently the port has no tty, until you run "setserial -g", or else
> that somehow makes the DCD status appear unchanged later when reading
> /proc/tty/driver/serial.


Just noticed the same freeze of my box with 3.1.0-rc4 - thought with
just a little bit different stack trace
(as I've taken only camera snap - here is just list of function) -
happened right after resume.

tty_ldisc_try   NULL pointer dereference

tty_ldisc_ref
check_modem_status
serial8250_get_mctrl
uart_proc_show
? seq_read
? kmem_cache_alloc_trace
? seq_read
seq_read
? sub_preempt_count
? seq_lseek
proc_reg_read
vfs_read
sys_read
system_call_fastpath


Zdenek
