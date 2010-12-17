Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0LQXJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:09:37 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:38256 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab0LQXJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:09:35 -0500
Date: Sat, 18 Dec 2010 00:09:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Michael Lawnick <ml.lawnick@gmx.de>
Cc: Ben Dooks <ben-i2c@fluff.org>, Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthias Zacharias <Matthias.Zacharias@bmk-solutions.de>
Subject: Re: [RFC] i2c-algo-bit: Disable interrupts while SCL is high
Message-ID: <20101218000924.546ad703@endymion.delvare>
In-Reply-To: <4D0B5312.5080107@gmx.de>
References: <20101216150638.7d3850b5@endymion.delvare>
	<20101216160046.GE20097@trinity.fluff.org>
	<20101216175337.2b1ae6ee@endymion.delvare>
	<4D0B5312.5080107@gmx.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Fri, 17 Dec 2010 13:09:54 +0100, Michael Lawnick wrote:
> Jean Delvare said the following:
> > Hi Ben,
> > 
> > On Thu, 16 Dec 2010 16:00:46 +0000, Ben Dooks wrote:
> >> On Thu, Dec 16, 2010 at 03:06:38PM +0100, Jean Delvare wrote:
> >> > Add a spinlock to every user of i2c-algo-bit, which is taken before
> >> > raising SCL and released after lowering SCL. We don't really need
> >> > the exclusion functionality, but we have to disable local interrupts.
> >> > This is needed to comply with SMBus requirements that SCL shouldn't
> >> > be high for longer than 50 us.
> >> > 
> >> > SMBus slaves can consider SCL being high for 50 us as a timeout
> >> > condition. This has been observed to happen reproducibly with the
> >> > Melexis MLX90614.
> >> > 
> >> > The drawback of this approach is that spin_lock_irqsave() and
> >> > spin_unlock_irqrestore() will be called once for each bit going on the
> >> > I2C bus in either direction. This can mean up to 100 kHz for standard
> >> > I2C and SMBus and up to 250 kHz for fast I2C. The good thing is that
> >> > this limits the latency to reasonable values (2us at 250 kHz, 5 us at
> >> > 100 kHz and 50 us at 10 kHz).
> >> 
> >> Hmm, this is going to be a drain on interrupt latency... disabling
> >> interrupts in a system for that long could cause other things to
> >> jitter.
> > 
> > So you consider that even disabling interrupts for 5 us is too long? Or
> > are you only worried by the 50 us case?
> 
> Sorry to disturb, but
> <MANTRA>
> 	Disabling interrupts may be done only for a few instructions.</MANTRA>
> 
> Even 1 us is an eternity on modern systems.

Don't be sorry, this is exactly the kind of input I was asking for. I'm
a little surprised, I thought disabling interrupts for a couple
microseconds was happening all the time, but I'll trust your
experience. Given your point and Ben's, it seems clear that my patch is
not acceptable as is, and at the very least I should make the spinlock
usage optional.

High-resolution timers may be an option too, but I guess it will
require a rewrite of the driver, and also I don't think HR timers are
available everywhere, so we will have to keep the old code in place for
compatibility.

Matthias, can you please tell us whether your system supports
high-resolution timers? I need to know if that would be a viable
solution for you.

-- 
Jean Delvare
