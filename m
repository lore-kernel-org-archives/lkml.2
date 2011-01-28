Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1A1D11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 22:27:27 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17489 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1A1D10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 22:27:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6239"; a="72069527"
Message-ID: <4D42379D.5030503@codeaurora.org>
Date: Thu, 27 Jan 2011 19:27:25 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-sh <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>, Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Richard Zhao <linuxzsc@gmail.com>
Subject: Re: Locking in the clk API
References: <201101111744.59712.jeremy.kerr@canonical.com>	<20110111103929.GN24920@pengutronix.de>	<AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com>	<4D386ABF.9060908@fluff.org>	<20110120190822.GK6335@n2100.arm.linux.org.uk>	<4D3932B4.8010904@codeaurora.org>	<20110121094042.GD13235@n2100.arm.linux.org.uk>	<4D40F5CC.6080809@codeaurora.org>	<20110127085438.GA25239@n2100.arm.linux.org.uk>	<4D41D5EC.6030405@codeaurora.org> <20110127204354.GB1597@n2100.arm.linux.org.uk>
In-Reply-To: <20110127204354.GB1597@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2011 12:43 PM, Russell King - ARM Linux wrote:
> On Thu, Jan 27, 2011 at 12:30:36PM -0800, Saravana Kannan wrote:
>> On 01/27/2011 12:54 AM, Russell King - ARM Linux wrote:
>>> On Wed, Jan 26, 2011 at 08:34:20PM -0800, Saravana Kannan wrote:
>>>> I'm not too familiar with serial/tty, does anyone know if the
>>>> .set_termios needs to be atmoic? If not, we could just change
>>>> cpm_uart/cpm_uart_core.c to use mutex instead of spinlock.
>>>
>>> The locking is there to protect against the interrupt handler accessing
>>> the port->* stuff (which seems to have been forgotten by the cpm driver).
>>>
>>> I don't see any reason why clk_set_rate() needs to be under the spinlock
>>> there - we need the reprogramming of the baud rate within the spinlock
>>> on 8250 because of DLAB bit hiding the data registers.  It's also a good
>>> idea that it _is_ within the spinlock along with uart_update_timeout()
>>> to ensure timeouts and the baud rate are updated together.
>>
>> For internal tree purposes, does .set_termios need to be atomic? Can it
>> grab mutexes instead of spinlock?
>
> I think I already answered that question above where I said "protect
> against the interrupt handler accessing the port->* stuff".
>
>> Going back to the topic, how about CPU freq drivers possibly using
>> clk_set_rate() to change freq? Do you think that's not the case or a
>> concern?
>
> CPUfreq drivers probably should busy-wait until the CPU PLL has locked
> if the CPU is allowed to continue running while the PLL relocks.  Some
> implementations will halt the CPU while the PLL is transitioning and
> that's really not unreasonable to do.
>
> I think some even require the code to be running out of SRAM and SDRAM
> remain untouched while the PLL is transitioning (omap maybe?)

Looks like you are confident to consider clk_set_rate() as sleepable. 
Can we add a comment to clk.h that says so?

Otherwise, there is no point in the suggesting the 
clk_prepare/unprepare() APIs.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
