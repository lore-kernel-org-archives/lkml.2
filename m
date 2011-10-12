Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1JLPTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:19:46 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54710 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab1JLPTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:19:44 -0400
Date: Wed, 12 Oct 2011 11:19:37 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: monstr@monstr.eu, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: Using serial driver 16550A in poll mode without interrupt
 connected
Message-ID: <20111012151937.GL11548@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, monstr@monstr.eu,
	linux-serial@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Peter Korsgaard <jacmet@sunsite.dk>
References: <4E95902B.7080204@monstr.eu>
 <20111012145153.5490b592@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012145153.5490b592@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 02:51:53PM +0100, Alan Cox wrote:
> > Driver is probed with no IRQ (NO_IRQ = -1 on Microblaze)
> > 83e00000.serial: ttyS0 at MMIO 0x83e01003 (irq = -1) is a 16550A
> 
> Zero means no IRQ. NO_IRQ is a legacy internal thing for the old IDE code
> so not something other code should be using. Setting the IRQ to -1 is
> bogus and will confuse the rest of the kernel.
> 
> > Is it possible to use serial driver without IRQ - or blocking IRQ, etc.?
> 
> Within limits - it kills your power management and data rates because of
> the continual polling.

It was something that I implemented years ago primarily for crappy
hardware that didn't get interrupts right.  It's not something which
where I would advise anyone to intentionally design hardware to use.

If you have really deep FIFO's (i.e., a kilobyte or more), and you're
primarily interested in throughput, not latency, and/or you are trying
to support tens or hundreds of serial ports for some kind of modem
pool, there is a place for a polled implementation.  See the Comtrol
Rockport for an example of hardware and with a linux driver that will
handle this.  It's basically a "NAPI for serial ports" sort of
approach to minimize the overhead of potentially hundreds of thousands
of interrupts per second if you are driving large numbers of ports
(and at that point, power management is the least of your concerns
:-).  But you need special hardware to do this, not a random 16550A
with a pathetically small 16 byte FIFO.

						- Ted
