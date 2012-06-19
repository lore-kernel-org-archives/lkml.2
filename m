Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2FSRg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 13:36:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:30616 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab2FSRgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 13:36:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="155566072"
Message-ID: <4FE0B853.5060203@linux.intel.com>
Date: Tue, 19 Jun 2012 10:35:15 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: [RFC PATCH] pch_uart: Add eg20t_port lock field, avoid recursive
 spinlocks
References: <8854635ac5471f8671b93c65e3663eb1cb204c9d.1338454156.git.dvhart@linux.intel.com> <CANKRQnhZErpvcsRW3ukNzY0_zv4x=5OzQ-sr+aeuxL63=tQ=4A@mail.gmail.com> <4FC90BAD.3080606@linux.intel.com> <4FCE8307.3050901@linux.intel.com> <CANKRQnj5mxHLprMt4VMMa7sCwLZb=PAktnVVD1MZVkkUG4eLoA@mail.gmail.com> <4FDFA09A.4030405@linux.intel.com> <20120619101447.74cbd9a1@pyramind.ukuu.org.uk>
In-Reply-To: <20120619101447.74cbd9a1@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/19/2012 02:14 AM, Alan Cox wrote:
> On Mon, 18 Jun 2012 14:41:46 -0700
> Darren Hart <dvhart@linux.intel.com> wrote:
> 
>>
>>
>> On 06/05/2012 04:48 PM, Tomoya MORINAGA wrote:
>>> On Wed, Jun 6, 2012 at 7:07 AM, Darren Hart <dvhart@linux.intel.com> wrote:
>>>> Are there still concerns about the additional lock? I'll resend V2
>>>> tomorrow with the single whitespace fix if I don't hear anything back today.
>>>
>>> I understand your saying. Looks good.
>>> However, I am not expert of linux-uart core system.
>>> So, I'd like UART maintainer to give us your opinion.
>>
>> Greg, Alan,
>>
>> any concerns with the locking approach I've adopted in the patch?
> 
> Only the one I noted in my reply the first time around

Hi Alan,

I've hunted, but I can't seem to find this reply. :-/

> which is that you
> can't permit tty->low_latency=1 unless your tty receive path is not an
> IRQ path. From a locking point of view the change makes sense anyway.

I ran into this on the PREEMPT_RT kernel which always uses
tty->low_latency and converts the interrupt handler into a thread.

There is a follow-on patch for RT only to address a sleeping while
atomic bug in pch_console_write(), but I felt _this_ locking structure
change was appropriate for mainline.

> 
> Going back over it your console locking also needs care - an oops or
> printk within the areas the private lock covers will hang the box. That
> should also probably be a trylock style lock as with the other lock on
> that path

I presume you are referring to pch_console_write()?

> static void
> pch_console_write(struct console *co, const char *s, unsigned int count)
> {
> 	struct eg20t_port *priv;
> 	unsigned long flags;
> 	u8 ier;
> 	int locked = 1;
> 
> 	priv = pch_uart_ports[co->index];
> 
> 	touch_nmi_watchdog();
> 
> 	local_irq_save(flags);
> 	spin_lock(&priv->lock);
> 	if (priv->port.sysrq) {
> 		/* serial8250_handle_port() already took the lock */
> 		locked = 0;
> 	} else if (oops_in_progress) {
> 		locked = spin_trylock(&priv->port.lock);
> 	} else
> 		spin_lock(&priv->port.lock);


I see, the oops_in_progress test right? My thinking was that the
oops_in_progress was only relevant to the port.lock as that could be
taken outside of the pch_uart driver, while the priv.lock is only used
within the driver. But, as the oops uses the pch_console_write itself, I
can see the recursive spinlock failure case there.

As for the printk, it seems the 8250 driver would also suffer from that
in the serial8250_console_write function on the port.lock, and it does
not make any allowances for printk.

I would like to hold the priv.lock for a smaller window, but ordering
requires that I take it prior to the port.lock.

So I can test for oops_in_progress on the priv->lock too, but that won't
address the printk issue. Is the oops the bigger concern?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


