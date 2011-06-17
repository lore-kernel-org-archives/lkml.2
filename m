Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab1FQBPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:15:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:41278 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab1FQBPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:15:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,378,1304319600"; 
   d="scan'208";a="14224728"
Date: Fri, 17 Jun 2011 09:22:20 +0800
From: Feng Tang <feng.tang@intel.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "Du, Alek" <alek.du@intel.com>
Subject: Re: [PATCH 3/5] dw_spi: rework message processing
Message-ID: <20110617092220.41532d97@feng-i7>
In-Reply-To: <4DFA3D30.2070909@gmail.com>
References: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
	<1308158588-17249-4-git-send-email-dirk.brandewie@gmail.com>
	<20110616220003.7ac89d56@feng-i7>
	<4DFA3D30.2070909@gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 01:28:16 +0800
Dirk Brandewie <dirk.brandewie@gmail.com> wrote:

> On 06/16/2011 07:00 AM, Feng Tang wrote:
> > Hi Dirk,
> >
> > IMHO, the patch is too big, it contains too many changes to the
> > original drivers, and we can't see clearly what you've changed to
> > each logical code part or section, If possible, could you separate
> > this patch to several small ones in a logical way.
> >
> > First, I have some questions, what devices have you tested with
> > this patch? high speed, low speed? Do you have any performance data
> > to show the benefit of this change? Current dw_spi driver has been
> > tested with many devices, so to not break them or cause obvious
> > regression, we have to be cautious.
> 
> See Thread with grant for list of environments where it has been
> tested. The boot time of the platforms it is being used on decreased
> 2-5 seconds with no regressions reported.  It has been in use/under
> test for ~3 months in various Meego and Android builds.  It clears
> all the bugs reported against the driver that I am aware of.  If you
> can give me pointers to teams/projects that are using v2.6.37+
> kernels I would be more that happy to provide them with patches for
> their kernel to ensure we get the most comprehensive test possible.

I was not asking about the environments, but the actual devices connect.
to and work with the dw_spi controller, here is a quote from one of
my previous email of devices listing:

----------------------------------------------------------------------------
I don't know all the devices and users, but here is what I know: I've tested
Max3110 spi-uart (in-tree), Option GTM501L high-speed 3G modem (out of tree),
ektf1236 spi touch screen (out of tree). Alek Du (Cced) should have tested
current dw_spi driver with some spi bluetooth device and modem device. Also
the original author fordw_spi_mmio.c Jean-Hugues Deschense should have some
experience too. 
-----------------------------------------------------------------------------
Meego or Android doesn't mean much for a device driver, as all these OSes are
using the same Linux kernel.

Is "2-5 seconds boot time cuts" the only performance data you got? The current
driver has 2 phases, first is the original one from me, the second is the 
optimization by Alek Du which introduce the batch operation for TX/RX FIFO, 
Alek mentioned the boot time cut too, so I guess the boot time gain is tested
against the original driver, not the current mainstream driver, right?

For the kernel version you mentioned, my thought is the kernel version diff
between 2.6.35 and 2.6.37 doesn't mean much to a simple dw_spi device driver's
performance? some users of dw_spi driver are still using 2.6.35 kernel with
all new optimizations back ported, I have no power to force them upgrade the
kernel, but if the dw_spi driver is the same, then the performance data is
mostly trustable.

> 
> >
> > Here are some general comments according to the commit logs:
> > 1. I think the threaded irq handling is a good idea. And let driver
> > chose to use poll or interrupt is good, some other spi controller
> > driver has used that way for a long time
> > 2. Why you remove the cs_change code, in some case, the controller
> > is only be used by one device, we don't need do the config for
> > every single spi_transfer
> 
> There is no guarantee that all the transfers in a given spi_message
> have the same values for  speed_hz, bits_per_word, cs_change and
> delay_usecs atleast nothing I could find put that restriction in
> place. Since we need to deal with possible changes (although
> unlikely) it gets rid some state we need to maintain and makes the
> code path common for all transfers.

right, if you look at the driver, cs_change is only judge condition
for judge, speed_hz, bits_per_word's change are counted in too. Otherwise
the driver should fail years ago.

> 
> > 3. Why do you remove the chip select control code, dw_spi
> > controller hw has some problem in chip select controller by SER,
> > and thus many devices has to use external GPIO has their chip
> > select, this is real world usages!
> 
> Which devices/platforms are you referring to?  I was unable to find
> any platforms or client drivers using this functionality. If they are
> not public please respond internally.  In any case it is mute since I
> already agreed to put is back in in my response to Grant.

Some intel platforms used/are using that, I got requests to help them
on it. Also some community guys are using that (though I don't know the
detail),  as this piece of code is introduced by Shore George once made
some change according to their specific change, see commit 052dc7c4

> 
> > 4. I saw you enable both TX/RX interrupt when doing interrupt
> > transfer, spi devices' TX/RX are born to be simutaneous, when one
> > word is sent over TX line, a RX word will be received from RX line,
> > so both the orignal interrupt transfer handling written by me and
> > the later optimization from Alek Du only enable TX interrupt, which
> > will only generate half of IRQs comparing to enble both TX/RX, this
> > is huge when the data rate is several Mb per second
> 
> I the current driver the txfltr register is set to 0 (FIFO empty) in
> the interrupt transfer case which will drop chip select every FIFO
> length bytes.
> 
> In my transfer setup the RX FIFO interrupt is set to a value lower
> than the TX threshold which will keep both interrupts from firing at
> the same time.
> 
> The TX interrupt will drive the transfer until there are less than
> tx_threshold bytes left to transfer then by the RX interrupt to drive
> the remainder of the transfer without dropping chip select.

What I set is half-empty for TX interrupt, so the FIFO will get filled
long before it's drained. I don't have any HW protocol analyzer or
logical analyzer, so I can't totally guarantee it won't happen

> 
> > 5. Why do you change the logic of filling TX FIFO, the logic comes
> > from use case that the dw_spi driver is dealing with several high
> > speed devices.
> >
> 
> The version of the driver that I started with did not have the
> current fifo handling code.  I finished my changes before they showed
> up in the AC tree or the upstream kernel.  I picked up most to the
> fifo handling logic from the current driver with the exception of the
> rxtx_gap calculation which was not needed with the way I am
> maintaining the state and the addition of a check to avoid the
> register read in tx_max/rx_max if all bytes have been sent/received.
> This avoids some overhead in the interrupt case.

If there is no performance again, I would hold on any change.

> 
> > Thanks,
> > Feng
> >
