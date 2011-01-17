Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1AQPSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 10:18:04 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37977 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1AQPSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 10:18:00 -0500
Message-ID: <4D345DA3.8020105@monstr.eu>
Date: Mon, 17 Jan 2011 16:17:55 +0100
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

Last week I have also implemented simple ioctl function for uartlite - 
just printk to see what happen. Look at the second log below.



If there is defined uartlite ioctl function (but always returns 
-ENOIOCTLCMD)

Sending select for 192.168.0.100...
Lease of 192.168.0.100 obtaulite_ioctl 5401 bf9b1ed8
n_tty_ioctl
ined, lease time 7200
adding dns 172.16.0.5
adding dns 172.16.10.1
Stuart_open(0) called
arting portmap:

Welcome to
  ulite_ioctl 5401 bf9f8a8c
n_tty_ioctl
ulite_ioctl 5402 bf9f8a70
n_tty_ioctl
_____       _   uart_close(0) called, port->count 2
************ 210 362
         _      _
| ___ \     | |         | |    (_)
| |_/ / ___ | |_   __ _ | |     _  _ __   _   _ __  __
|  __/ / _ \| __| / _` || |    | || '_ \ | | | |\ \/ /
| |   |  __/| |_ | (_| || |____| || | | || |_| | >  <
\_|    \___| \__| \__,_|\_____/|_||_| |_| \__,_|/_/\_\

on Xilinx-SP605-LTP-full-WB-pc-msr-next-22-watch-wt-mdm

************
uart_open(0) called
ulite_ioctl 5401 bff76a18
n_tty_ioctl
ulite_ioctl 540b 2
n_tty_ioctl
n_tty_ioctl_helper TCFLSH
tty_perform_flush TCIOFLUSH
tty_perform_flush TCOFLUSH
tty_driver_flush_buffer
uart_flush_buffer(0) called
ulite_ioctl 5402 bff769a4
n_tty_ioctl
ulite_ioctl 540b 0
n_tty_ioctl
n_tty_ioctl_helper TCFLSH
tty_perform_flush TCIFLUSH
ulite_ioctl 5401 bff76558
n_tty_ioctl

Xilinx-SP605-LTP-full-WB-pc-msr-next-22-watch-wt-mdm login:


If uarlite ioctl is defined: (cases: TCFLSH, TCGETS, TCSETS) - return 0;
It is interested but maybe implement that function could be enough. What 
do you think?

Thanks,
Michal


NET: Registered protocol family 17
uart_open(0) called
ulite_startup ------------------------
Freeing unused kernel memory: 11218k freed
ulite_ioctl 5600 bf9d1bc8
n_tty_ioctl
ulite_ioctl TCGETS bf9d1b1c
ulite_ioctl TCSETS bf9d1b00
ulite_ioctl TCGETS bf9d1a8c
ulite_ioctl TCSETS bf9d1a70
ulite_ioctl TCGETS bff204d0
Mounting proc:
Mounting var:
Populatinulite_ioctl TCGETS bfd8b4c0
g /var:
Runningulite_ioctl TCGETS bf87e4c0
  local start scripts.
Mounting sysfs:
mdev: initialising /dev
ulite_ioctl TCGETS bf8164c0
Mounting /etc/config:
Populating /etc/culite_ioctl TCGETS bf95a4c0
onfig:
flatfsd:ulite_ioctl TCGETS bf9744c0
  Created 8 configulite_ioctl TCGETS bf9434c0
uration files (168 bytes)
Mounting devpts:
Setting hostname:
Bringing up network interfaces:
net eth0: Promiscuous mode disabled.
udhcpc (v1.14.3) started
Sending discover...
Sending select for 192.168.0.100...
Lease of 192.168.0.100 obtaulite_ioctl TCGETS bfa3bed8
ined, lease time 7200
adding dns 172.16.0.5
adding uart_open(0) called
ulite_ioctl TCGETS bf9d1a8c
ulite_ioctl TCSETS bf9d1a70
uart_close(0) called, port->count 2
************ 1dd 362

Starting portmap:

Welcome to
  _____       _           _      _
| ___ \     | |         | |    (_)
| |_/ / ___ | |_   __ _ | |     _  _ __   _   _ __  __
|  __/ / _ \| __| / _` || |    | || '_ \ | | | |\ \/ /
| |   |  __/| |_ | (_| || |____| || | | || |_| | >  <
\_|    \___| \__| \__,_|\_____/|_||_| |_| \__,_|/_/\_\

on Xilinx-SP605-LTP-full-WB-pc-msr-next-22-watch-wt-mdm

************
uart_open(0) called
ulite_ioctl TCGETS bfd98a18
ulite_ioctl TCFLSH 2
ulite_ioctl TCSETS bfd989a4
ulite_ioctl TCFLSH 0
ulite_ioctl TCGETS bfd98558

Xilinx-SP605-LTP-full-WB-pc-msr-next-22-watch-wt-mdm login:


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
