Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1AUCGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 21:06:18 -0500
Received: from smtp-out.google.com ([74.125.121.67]:24363 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1AUCGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 21:06:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r7RGWiJl94M/LQIjqfVqNyN/asFcfVAAZ5iCEGL402Ev7oa0pjQiy1DRFYM8ONcSEl
         3xVx923jNnRPass1n2ug==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101201623480.8580@xanadu.home>
References: <201101111016.42819.jeremy.kerr@canonical.com>
	<20110111031552.GJ3760@linux-sh.org>
	<4D3862DB.5000708@fluff.org>
	<20110120185617.GI6335@n2100.arm.linux.org.uk>
	<alpine.LFD.2.00.1101201623480.8580@xanadu.home>
Date: Thu, 20 Jan 2011 18:06:12 -0800
Message-ID: <AANLkTimwBruVgGQWs5NQG7U3PcF6RQHZ6Pd1hjxyGpcA@mail.gmail.com>
Subject: Re: Locking in the clk API
From: Dima Zavin <dmitriyz@google.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>, Paul Mundt <lethal@linux-sh.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        "Uwe Kleine-K??nig" <u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a better one.

Many devices use serial display panels sitting on either MDDI or MIPI
links. The interface clocks need to be on, but they stay in low-power
mode while the display is on. The display controller however does not
need to be on since the serial panels typically have a local
framebuffer that does the idle panel refresh on it's own. When a new
frame comes in to be displayed, you need to clock on the display
controller, DMA the data to the panel, and when it's done turn the
controller off. The clk_enable may or may not happen at irq context,
depending on whether or not you are starting the DMA from a
vsync/tear-effect irq or simply from the screen_update() function. The
clk_disable will most certainly happen from the DMA_DONE irq.

--Dima

On Thu, Jan 20, 2011 at 1:30 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Thu, 20 Jan 2011, Russell King - ARM Linux wrote:
>
>> On Thu, Jan 20, 2011 at 04:29:15PM +0000, Ben Dooks wrote:
>> > I really don't like the fact that people are doing these things in
>> > atomic contexts, and I think we should apply some pressure to move
>> > the atomic caller cases to use systems where they can sleep such as
>> > using threaded-irq handlers (they work very nicely)
>>
>> How do you ensure that printk is always called from a non-atomic
>> context?
>
> Is this a good example?  I don't think that power sensitive systems such
> as a cellphone should keep printk() enabled in the final product.  The
> output from printk() over a serial port is a debugging convenience, and
> trying to aggressively turn on/off the serial clock around each call to
> printk() is a bit silly.  Better simply turn the serial clock on
> whenever its console facility is opened, and turn it off when the
> console is closed, which should be good enough in that context.
>
>
> Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
