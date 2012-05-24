Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637Ab2EXVJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:09:23 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51007 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab2EXVJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:09:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAJJYPdmmaDuW-yhLQbGj9ihfiJOp5K_C_Vn6dCTzmr0A_gaKjg@mail.gmail.com>
References: <20110216161728.GA8431@darkside.kls.lan>
	<20110310014952.38b7a6ef@redhat.com>
	<CAJJYPdmmaDuW-yhLQbGj9ihfiJOp5K_C_Vn6dCTzmr0A_gaKjg@mail.gmail.com>
Date: Thu, 24 May 2012 23:09:21 +0200
Message-ID: <CAJJYPdnTMZiTi6OT2cqk_h_e8+m8iGZqVK_zazLM39eFWLf5xw@mail.gmail.com>
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

2011/9/2 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2011/3/10 Chuck Ebbert <cebbert@redhat.com>:
>> On Wed, 16 Feb 2011 17:17:28 +0100
>> "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE> wrote:
>>
>>> reading /proc/tty/driver/serial leads to a NULL pointer dereference
>>> BUG and freeze on a serial-console enabled 2.6.35.{4,10,11} and
>>> 2.6.37. 2.6.32.28 does fine without BUG and freeze.
>>>
>>> Fresh boot 2.6.35.11 into emergency...
>>> # cat /proc/tty/driver/serial
>>> [   73.199568] BUG: unable to handle kernel NULL pointer dereference
>>> at 00000099 [   73.227373] IP: [<c11a8969>] tty_ldisc_try+0x10/0x35
>>
>> The oops is here, in uart_handle_dcd_change() in serial_core.h:
>>
>>        struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
>>
>> (port->tty is NULL)
>>
>> Called from check_modem_status() in 8250.c:
>>
>>                if (status & UART_MSR_DDCD)
>>                        uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
>>
>> So apparently the port has no tty, until you run "setserial -g", or else
>> that somehow makes the DCD status appear unchanged later when reading
>> /proc/tty/driver/serial.
>
>
> Just noticed the same freeze of my box with 3.1.0-rc4 - thought with
> just a little bit different stack trace
> (as I've taken only camera snap - here is just list of function) -
> happened right after resume.
>
> tty_ldisc_try   NULL pointer dereference
>
> tty_ldisc_ref
> check_modem_status
> serial8250_get_mctrl
> uart_proc_show
> ? seq_read
> ? kmem_cache_alloc_trace
> ? seq_read
> seq_read
> ? sub_preempt_count
> ? seq_lseek
> proc_reg_read
> vfs_read
> sys_read
> system_call_fastpath


Anything new about this issue ?

Seems I'm getting recently several of those reports with 3.4 kernel:


tty_ldisc_ref
uart_handle_dcd_change

Even something simple like this:

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 9c4c05b..32c68c0 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2453,7 +2453,7 @@ void uart_handle_dcd_change(struct uart_port
*uport, unsigned int status)
 {
        struct uart_state *state = uport->state;
        struct tty_port *port = &state->port;
-       struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
+       struct tty_ldisc *ld = port ? tty_ldisc_ref(port->tty) : NULL;
        struct pps_event_time ts;

        if (ld && ld->ops->dcd_change)
@@ -2465,7 +2465,7 @@ void uart_handle_dcd_change(struct uart_port
*uport, unsigned int status)
                hardpps();
 #endif

-       if (port->flags & ASYNC_CHECK_CD) {
+       if (port && port->flags & ASYNC_CHECK_CD) {
                if (status)
                        wake_up_interruptible(&port->open_wait);
                else if (port->tty)


Zdenek
