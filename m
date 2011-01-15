Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab1AOOKz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 09:10:55 -0500
Received: from 51.197.216.81.static.s-h.siw.siwnet.net ([81.216.197.51]:54761
	"EHLO sloth.weinigel.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750795Ab1AOOKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 09:10:53 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Jan 2011 09:10:53 EST
Message-ID: <4D31A8F1.4080301@weinigel.se>
Date: Sat, 15 Jan 2011 15:02:25 +0100
From: Christer Weinigel <christer@weinigel.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk> <4D2D184A.8020405@codeaurora.org> <20110112090301.GS11039@n2100.arm.linux.org.uk>
In-Reply-To: <20110112090301.GS11039@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 10:03 AM, Russell King - ARM Linux wrote:

> That never has been, and that is called for the _system_ going into
> suspend.  That's not what I'm talking about.  I'm talking about drivers
> doing their own power management in response to (a) their knowledge of
> how the device behaves and (b) in response to the user state they know.
>
> In the case of a UART, that means enabling the clock when the user opens
> the device and turning it off when the user closes the device - and in
> the case of the UART being used as the system console, enabled when
> printk calls it, disabled when finished outputting the message.

 >

> The latter is a case where you're called in atomic context.


This feels a bit like perfect being the enemy of good.

On platforms that need to sleep to enable the UART clock, configuring 
the UART as the kernel console should be equivalent to userspace opening 
the UART device, i.e. enable the clock.  At least to me that feels like 
an acceptable tradeoff, and if I wanted to save the last bit of power 
I'll have to refrain from using UART as the kernel console.

If both printk to the console and disabling the clock is really really 
neccesary, add a clk_enable_busywait, but that will be a bit of a hack.


> Another case - a storage device.  While you may receive open/close calls,
> these are meaningless for power management - you'll receive an open call
> when you mount a filesystem, and a close call when you finally unmount it.
> That doesn't mean it's going to be used.  Your request handler will
> generally run in an atomic context, so in order to do dynamic power
> saving you need to be able to enable/disable clocks in that context.



> A touchscreen controller which you communicate with over a dedicated bus.
> The touchscreen controller doesn't require the host to be constantly
> clocked - it only needs to be clocked when communicating with the
> touchscreen.  The touchscreen controller raises an interrupt for service.
> You'd want to enable the clock in the interrupt handler to communicate
> with the device and turn it off afterwards.


Both of these feel like they should use a call such as clk_get_atomic 
and be able to handle EWOULDBLOCK/EAGAIN (or whatever error code is used 
to indicate that it would have to sleep) and delegate to a worker thread 
to enable the clock.  To catch uses of plain clk_enable from atomic 
contects, add a WARN_ON/BUG_ON(in_atomic()).  It won't catch everything, 
but would help a bit at least.

Someone suggested splitting clk_enable into a part that can sleep and a 
part that can't, would that be workable?  I.e. extend clk_get so that it 
knows what requirements the driver has on the clock.  So a driver that does:

     clk_get(dev, "my_clk", CLK_CANSLEEP);

must then either use clk_enable from contexts which can sleep or use 
clk_enable_atomic and be able to handle EWOULDBLOCK.

A driver which can't handle EWOULDBLOCK would do:

     clk_get(dev, "my_clk", CLK_ATOMIC)

informing the clock subsystem that clk_enable_atomic must always 
succeed.  If the clock source driver can't do that it has to enable the 
clock at clk_get time instead of at clk_enable time.  If a clock 
requires a potentially slow PLL setup which needs to sleep but can gate 
the clock atomically, do the PLL setup from clk_get and the gating from 
clk_enable.  This means that a clock might be on when it strictly isn't 
necessary, but at least it will be correct and assuming that Peter Mundt 
is correct in saying that the sleeping clock case is a corner case this 
will usually not be a problem.

For the corner cases where someone ports a driver that uses CLK_ATOMIC 
to a system with sleeping clocks and wants the last bit of power saving, 
the burden is on that someone to add EWOULDBLOCK support to the driver.

Regarding the other functions in the clock API, generic code in 
clk_disable_atomic could check if it is a sleeping clock and based on 
that call clk_disable directly or delegate the call to a worker thread. 
  All other functions should be able to sleep, with the possible 
exception of clk_get_rate which could be useful so that a driver can 
check if the clock is running at the correct rate from atomic context 
and delegate to a worker thread to change the clock rate if it is not.

To avoid unnecessary code churn it might be better to say that plain 
clk_enable is the atomic variant and if it is a sleeping clock it will 
be enbled at the time plain clk_get is called.  People who want to use 
sleeping clocks can then modify a driver at a time to use 
clk_get_cansleep and clk_enable_cansleep.  But I must say that the name 
clk_enable_atomic feels a lot cleaner.

   /Christer
