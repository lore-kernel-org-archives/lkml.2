Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1BXMjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:39:08 -0500
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:60486 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671Ab1BXMjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:39:05 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Feb 2011 07:39:05 EST
X-AuditID: 1209190d-b7cacae000000a14-9f-4d66503c8f2f
Subject: Re: How important is it that tty_write_room doesn't lie?
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20110223225728.GR2924@thunk.org>
Date: Thu, 24 Feb 2011 07:34:00 -0500
Cc: Timur Tabi <timur@freescale.com>, Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <83266FC1-CB6F-4FC6-AAD3-05EC006B553E@mit.edu>
References: <4D656679.90907@freescale.com> <20110223202915.GB9081@suse.de> <4D657292.6000106@freescale.com> <20110223225728.GR2924@thunk.org>
To: "Ted Ts'o" <tytso@MIT.EDU>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 23, 2011, at 5:57 PM, Ted Ts'o wrote:

>> The FIFO can vary, but it's probably at least 2KB it size.  At
>> least, we hope to able to set it to that size in the field.
>> Currently, we set it to 4KB.
> 
> Wow, the FIFO has gotten a lot larger than I ever remember them
> getting even when people were doing 460kbps.  I'm guessing this is
> because you're trying to defer interrupts for power saving reasons,
> yes?  I was used to seeing FIFO sizes more in the 32-128 bytes, tops.  :-)

One more thought: If your FIFO is that large, you might want to consider
simply having the interrupt driver wake up a kernel thread, say when it
half full (to give the scheduler time to wake up and let the kernel thread
run), and dequeue the FIFO in a process context.

Or as an intermediate step, do the FIFO dequeue in a bottom-half
handler, where you'll at least be able to do memory allocations.

Don't assume that you have to empty the entire FIFO into a circular
buffer in an interrupt handler, just because that's what the 8250/16550
driver does.  It was designed that way because it had very small FIFO's,
but there are other ways that serial drivers can work.

One device driver I worked on, for the Comtrol Rocketport, was designed
for a very large number of ports (32-128 serial ports) and it had a single 
huge buffer shared between all of the ports, and once an interrupt
kicked things off, it was more efficient to simply be constantly pulling
things out of the buffer and dispatching it to the various tty ports,
and in practice it was faster and more efficient never to pull
the characters out in interrupt context, but instead use a polling
type system instead.

Think of it as a very early form of NAPI interrupt mitigation, but for
serial ports instead of high speed ethernet.  :-)

-- Ted

