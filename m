Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1APVCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:02:16 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42868 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1APVCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:02:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=DIwzNYC9gO/IXomVW6mgswEiy2BxZgMQomVaa4bqVo+8yXpOhTO3exDo3rIOj1PWQV
         CYkA8xrl5Sy++Ny9vR4O7IaGmyE3/omb1UBqUGYeJXr0CQXNxJTZZIhJoG9sIOY/PF58
         yw12F71mm71eVPgvUm8hnKiLDCYQ9lWbY8KSY=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: monstr@monstr.eu
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Uartlite - ulite_transmit
References: <4D2465E0.2000707@monstr.eu> <4D246672.3070002@monstr.eu>
	<87vd22h3dq.fsf@macbook.be.48ers.dk> <4D257D61.2060400@monstr.eu>
	<87r5cqh0bn.fsf@macbook.be.48ers.dk> <4D25871D.2000408@monstr.eu>
	<87mxnegy4u.fsf@macbook.be.48ers.dk> <4D26C538.3010101@monstr.eu>
	<4D26D79C.8060304@monstr.eu> <4D2D78F3.2040903@monstr.eu>
	<87aaj6zays.fsf@macbook.be.48ers.dk> <4D2D8113.1020504@monstr.eu>
	<8739oyza2n.fsf@macbook.be.48ers.dk> <4D32B5A2.1070508@monstr.eu>
Date: Sun, 16 Jan 2011 22:02:06 +0100
In-Reply-To: <4D32B5A2.1070508@monstr.eu> (Michal Simek's message of "Sun, 16
	Jan 2011 10:08:50 +0100")
Message-ID: <87r5cc5zqp.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Michal" == Michal Simek <monstr@monstr.eu> writes:

Hi,

 Michal> Hi Peter,
 Michal> sorry for delay. I had to look at another issue.

No problem.

 Michal> Below is full log:
 Michal> 1. I setup baudrate to 50. (It could be possible to set it up to 0 too)
 Michal> That's why I think that doesn't matter what baudrate is setup.

 Michal> 2. You see where ulite_startup is called. It is called only once.

Ok, good.

 Michal> 3. You see that there is no call __uart_wait_until_sent(). It could be
 Michal> called for ASYNC mode. The second thing is __uart_wait_until_sent
 Michal> function is checking if tx fifo is empty not circ buffer is empty.

Yes, that's afaik what that function should do.

 Michal> 4. Next thing is that in uart_close. port->count is 2 which means that
 Michal> the executing path is
 Michal> 	if (port->count) {
 Michal> 		spin_unlock_irqrestore(&port->lock, flags);
 Michal> 		goto done;
 Michal> 	}
 Michal> which means that there is no chance to call __uart_wait_until_sent
 Michal> function anyway.

And no buffer flushing, so that's fine.

 Michal> 5. I did one modification to add simple while loop till circ buffer is
 Michal> empty to the same location to see what happen (timouts are bogus
 Michal> values).

 Michal> if (port->count) {
 Michal> 	spin_unlock_irqrestore(&port->lock, flags);
 Michal> 	printk("************ %x %x\n", (&uport->state->xmit)->tail,
 Michal> (&uport->state->xmit)->head);
 Michal> 	while (!uart_circ_empty(&uport->state->xmit)) {
 Michal> 		msleep_interruptible(jiffies_to_msecs((uport->timeout - HZ/50)));
 Michal> 		if (signal_pending(current))
 Michal> 			break;
 Michal> 		if (time_after(jiffies, jiffies + uport->timeout))
 Michal> 			break;
 Michal> 	}
 Michal> 	printk("************\n");
 Michal> 	goto done;
 Michal> }

Ok, so this shows that there's still data in the circular buffer when
uart is closed, like expected.

For me, it all looks normal:

1. serial port gets opened, uart_open -> uart_startup -> ulite_startup
   gets called, ASYNC_INITIALIZED gets set, circular buffer and hardware
   TX fifo cleared.

2. Some time later serial port gets opened again, and uart_startup is a
   NOP because ASYNC_INITIALIZED is set. No circular buffer / hw fifo
   clear.

3. serial port gets closed, uart_close is a NOP because port->count > 0

4. serial port gets opened again, NOP like in 2.

The problem is the uart_flush_buffer() call we see after uart_open() in
4. If doesn't seem to come from serial_core (only called from uart_close
/ uart_hangup), so presumably it comes from the TTY core or
userspace. Could you add a bit more debug to figure out where exactly it
comes from?

 Michal> ************
 Michal> uart_open(0) called
 Michal> uart_flush_buffer(0) called

-- 
Bye, Peter Korsgaard
