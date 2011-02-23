Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab1BWULw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:11:52 -0500
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.182]:28933
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932557Ab1BWULt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:11:49 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Feb 2011 15:11:49 EST
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh2a8h637h668h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
Message-ID: <4D656679.90907@freescale.com>
Date: Wed, 23 Feb 2011 13:56:41 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101213 Fedora/2.0.11-1.fc13 SeaMonkey/2.0.11
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: How important is it that tty_write_room doesn't lie?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

As you may remember, I have a combination console/tty driver that talks to a
serial-like FIFO provided by our hypervisor.  Both tty_operations.write() and
console.write() talk to the same FIFO for character output.

I've implemented a tty_operations.write_room() function that queries the
hypervisor for amount of free space in the FIFO.  I've noticed a subtle bug in
this function, and I was hoping for some advice on how to fix it.

I believe I might have a problem when the following events happen in this order:

1) The TTY layer calls write_room() to determine the amount of free space in the
FIFO.

2) The *console* layer calls console.write() to write some data (e.g. the kernel
interrupted the TTY layer and executed a printk)

3) Control returns to the TTY layer, which calls tty_operations.write(),
assuming that the number returned by the previous call to write_room() is still
correct.

Because of the interjected console write, the FIFO no longer has a much room as
write_room() said it does.  When the TTY layer calls tty_operations.write(), my
driver returns a number smaller than the size of the buffer passed to (i.e. not
all characters were written).  The TTY layer, not expecting this, loses data.

Is my assessment of the situation correct?  If so, is there any way around this
problem that doesn't require implementing *two* software FIFOs in the driver:
one for the console interface, and one for the TTY interface?  If every driver
needs a FIFO like this, wouldn't it be simpler for the TTY and console layers to
provide their own FIFOs?  I feel like I'm missing something obvious.

-- 
Timur Tabi
Linux kernel developer at Freescale

