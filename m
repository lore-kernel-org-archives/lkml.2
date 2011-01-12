Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab1ALJD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 04:03:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52716 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab1ALJDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 04:03:51 -0500
Date: Wed, 12 Jan 2011 09:03:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Message-ID: <20110112090301.GS11039@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk> <4D2D184A.8020405@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2D184A.8020405@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 06:56:10PM -0800, Saravana Kannan wrote:
> On 01/11/2011 01:16 AM, Russell King - ARM Linux wrote:
>> On Tue, Jan 11, 2011 at 10:16:42AM +0800, Jeremy Kerr wrote:
>>> At present, we can satisfy these with:
>>>
>>> * clk_enable: may sleep
>>
>> I object to this as one of the purposes behind the clk API is to allow
>> power savings to be made, and unless we can perform clk enable/disable
>> from atomic contexts, the best you can do is enable the clock when the
>> device is probed and disable it when it's released.
>
> Since dev_pm_ops.suspend is not atomic anymore (am I wrong?), what is  

That never has been, and that is called for the _system_ going into
suspend.  That's not what I'm talking about.  I'm talking about drivers
doing their own power management in response to (a) their knowledge of
how the device behaves and (b) in response to the user state they know.

In the case of a UART, that means enabling the clock when the user opens
the device and turning it off when the user closes the device - and in
the case of the UART being used as the system console, enabled when
printk calls it, disabled when finished outputting the message.

The latter is a case where you're called in atomic context.

Another case - a storage device.  While you may receive open/close calls,
these are meaningless for power management - you'll receive an open call
when you mount a filesystem, and a close call when you finally unmount it.
That doesn't mean it's going to be used.  Your request handler will
generally run in an atomic context, so in order to do dynamic power
saving you need to be able to enable/disable clocks in that context.

A touchscreen controller which you communicate with over a dedicated bus.
The touchscreen controller doesn't require the host to be constantly
clocked - it only needs to be clocked when communicating with the
touchscreen.  The touchscreen controller raises an interrupt for service.
You'd want to enable the clock in the interrupt handler to communicate
with the device and turn it off afterwards.

Shall I continue?
