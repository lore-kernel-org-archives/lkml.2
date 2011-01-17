Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1AQGfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 01:35:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46516 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1AQGfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 01:35:40 -0500
Message-ID: <4D33E336.1060804@monstr.eu>
Date: Mon, 17 Jan 2011 07:35:34 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Uartlite - ulite_transmit
References: <4D2465E0.2000707@monstr.eu> <4D246672.3070002@monstr.eu>	<87vd22h3dq.fsf@macbook.be.48ers.dk> <4D257D61.2060400@monstr.eu>	<87r5cqh0bn.fsf@macbook.be.48ers.dk> <4D25871D.2000408@monstr.eu>	<87mxnegy4u.fsf@macbook.be.48ers.dk> <4D26C538.3010101@monstr.eu>	<4D26D79C.8060304@monstr.eu> <4D2D78F3.2040903@monstr.eu>	<87aaj6zays.fsf@macbook.be.48ers.dk> <4D2D8113.1020504@monstr.eu>	<8739oyza2n.fsf@macbook.be.48ers.dk> <4D32B5A2.1070508@monstr.eu> <87r5cc5zqp.fsf@macbook.be.48ers.dk>
In-Reply-To: <87r5cc5zqp.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Korsgaard wrote:
>>>>>> "Michal" == Michal Simek <monstr@monstr.eu> writes:
> 
> Hi,
> 
>  Michal> Hi Peter,
>  Michal> sorry for delay. I had to look at another issue.
> 
> No problem.
> 
>  Michal> Below is full log:
>  Michal> 1. I setup baudrate to 50. (It could be possible to set it up to 0 too)
>  Michal> That's why I think that doesn't matter what baudrate is setup.
> 
>  Michal> 2. You see where ulite_startup is called. It is called only once.
> 
> Ok, good.
> 
>  Michal> 3. You see that there is no call __uart_wait_until_sent(). It could be
>  Michal> called for ASYNC mode. The second thing is __uart_wait_until_sent
>  Michal> function is checking if tx fifo is empty not circ buffer is empty.
> 
> Yes, that's afaik what that function should do.
> 
>  Michal> 4. Next thing is that in uart_close. port->count is 2 which means that
>  Michal> the executing path is
>  Michal> 	if (port->count) {
>  Michal> 		spin_unlock_irqrestore(&port->lock, flags);
>  Michal> 		goto done;
>  Michal> 	}
>  Michal> which means that there is no chance to call __uart_wait_until_sent
>  Michal> function anyway.
> 
> And no buffer flushing, so that's fine.
> 
>  Michal> 5. I did one modification to add simple while loop till circ buffer is
>  Michal> empty to the same location to see what happen (timouts are bogus
>  Michal> values).
> 
>  Michal> if (port->count) {
>  Michal> 	spin_unlock_irqrestore(&port->lock, flags);
>  Michal> 	printk("************ %x %x\n", (&uport->state->xmit)->tail,
>  Michal> (&uport->state->xmit)->head);
>  Michal> 	while (!uart_circ_empty(&uport->state->xmit)) {
>  Michal> 		msleep_interruptible(jiffies_to_msecs((uport->timeout - HZ/50)));
>  Michal> 		if (signal_pending(current))
>  Michal> 			break;
>  Michal> 		if (time_after(jiffies, jiffies + uport->timeout))
>  Michal> 			break;
>  Michal> 	}
>  Michal> 	printk("************\n");
>  Michal> 	goto done;
>  Michal> }
> 
> Ok, so this shows that there's still data in the circular buffer when
> uart is closed, like expected.
> 
> For me, it all looks normal:
> 
> 1. serial port gets opened, uart_open -> uart_startup -> ulite_startup
>    gets called, ASYNC_INITIALIZED gets set, circular buffer and hardware
>    TX fifo cleared.

But ASYNC_INITIALIZED is not set.

> 
> 2. Some time later serial port gets opened again, and uart_startup is a
>    NOP because ASYNC_INITIALIZED is set. No circular buffer / hw fifo
>    clear.
> 
> 3. serial port gets closed, uart_close is a NOP because port->count > 0
> 
> 4. serial port gets opened again, NOP like in 2.
> 
> The problem is the uart_flush_buffer() call we see after uart_open() in
> 4. If doesn't seem to come from serial_core (only called from uart_close
> / uart_hangup), so presumably it comes from the TTY core or
> userspace. Could you add a bit more debug to figure out where exactly it
> comes from?

ok. will do.

Thanks,
Michal

> 
>  Michal> ************
>  Michal> uart_open(0) called
>  Michal> uart_flush_buffer(0) called
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
