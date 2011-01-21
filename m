Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1AUEMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 23:12:48 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22817 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab1AUEMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 23:12:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6232"; a="71114562"
Message-ID: <4D3907BD.4040900@codeaurora.org>
Date: Thu, 20 Jan 2011 20:12:45 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dima Zavin <dmitriyz@google.com>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben-linux@fluff.org>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com>	<20110111031552.GJ3760@linux-sh.org> <4D3862DB.5000708@fluff.org>	<20110120185617.GI6335@n2100.arm.linux.org.uk>	<alpine.LFD.2.00.1101201623480.8580@xanadu.home> <AANLkTimwBruVgGQWs5NQG7U3PcF6RQHZ6Pd1hjxyGpcA@mail.gmail.com>
In-Reply-To: <AANLkTimwBruVgGQWs5NQG7U3PcF6RQHZ6Pd1hjxyGpcA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 06:06 PM, Dima Zavin wrote:
> On Thu, Jan 20, 2011 at 1:30 PM, Nicolas Pitre<nicolas.pitre@linaro.org>  wrote:
>> On Thu, 20 Jan 2011, Russell King - ARM Linux wrote:
>>
>>> On Thu, Jan 20, 2011 at 04:29:15PM +0000, Ben Dooks wrote:
>>>> I really don't like the fact that people are doing these things in
>>>> atomic contexts, and I think we should apply some pressure to move
>>>> the atomic caller cases to use systems where they can sleep such as
>>>> using threaded-irq handlers (they work very nicely)
>>>
>>> How do you ensure that printk is always called from a non-atomic
>>> context?
>>
>> Is this a good example?  I don't think that power sensitive systems such
>> as a cellphone should keep printk() enabled in the final product.  The
>> output from printk() over a serial port is a debugging convenience, and
>> trying to aggressively turn on/off the serial clock around each call to
>> printk() is a bit silly.  Better simply turn the serial clock on
>> whenever its console facility is opened, and turn it off when the
>> console is closed, which should be good enough in that context.

[fixing top post]

 > Here's a better one.
 >
 > Many devices use serial display panels sitting on either MDDI or MIPI
 > links. The interface clocks need to be on, but they stay in low-power
 > mode while the display is on. The display controller however does not
 > need to be on since the serial panels typically have a local
 > framebuffer that does the idle panel refresh on it's own. When a new
 > frame comes in to be displayed, you need to clock on the display
 > controller, DMA the data to the panel, and when it's done turn the
 > controller off. The clk_enable may or may not happen at irq context,
 > depending on whether or not you are starting the DMA from a
 > vsync/tear-effect irq or simply from the screen_update() function. The
 > clk_disable will most certainly happen from the DMA_DONE irq.

Why do we need to turn on the clock in the IRQ? Why not defer it to a 
workqueue (or whatever is the method of the day to defer work from an 
IRQ)? The advantage of doing the clk_enable in the IRQ should be 
negligible compared to the time it takes to do the DMA.

In my opinion, the only major reason for needing atomic clk APIs was due 
to device_ops->suspend being atomic. Since that's not the case anymore, 
I really don't see a justification for atomic clocks. Sure, I might have 
missed some exceptions, but in that case we should make the atomic APIs 
an exception (add clk_enable_atomic) and not the norm.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
