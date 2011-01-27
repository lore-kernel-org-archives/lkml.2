Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1A0EeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 23:34:22 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23058 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1A0EeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 23:34:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71926930"
Message-ID: <4D40F5CC.6080809@codeaurora.org>
Date: Wed, 26 Jan 2011 20:34:20 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Colin Cross <ccross@google.com>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-sh <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Richard Zhao <linuxzsc@gmail.com>
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com>	<20110111091607.GI12552@n2100.arm.linux.org.uk>	<201101111744.59712.jeremy.kerr@canonical.com>	<20110111103929.GN24920@pengutronix.de>	<AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com>	<4D386ABF.9060908@fluff.org>	<20110120190822.GK6335@n2100.arm.linux.org.uk>	<4D3932B4.8010904@codeaurora.org> <20110121094042.GD13235@n2100.arm.linux.org.uk>
In-Reply-To: <20110121094042.GD13235@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2011 01:40 AM, Russell King - ARM Linux wrote:
> On Thu, Jan 20, 2011 at 11:16:04PM -0800, Saravana Kannan wrote:
>> This suggestion looked promising till I realized that clk_set_rate()
>> will still be atomic. clk_set_rate() will need to enable/disable the
>> PLLs depending on which PLLs the rates are derived from. So, the locking
>> in clk_prepare/unprepare() still has to be atomic since the "slow stuff"
>> is shared with clk_set_rate().
>
> Who calls clk_set_rate() from an atomic context?  Do we know whether
> anyone does?

As promised I looked into this in the upstream kernel and with the 
internal teams.

In the upstream (torvalds/master) kernel, I found at least one example 
of calling clk_set_rate() from atomic context (spinlock in this case):
cpm_uart/cpm_uart_core.c

I'm not too familiar with serial/tty, does anyone know if the 
.set_termios needs to be atmoic? If not, we could just change 
cpm_uart/cpm_uart_core.c to use mutex instead of spinlock.

In our internal tree (which we upstream), we have UART HS driver that 
needs to do the same stuff as cpm_uart_core.c. The problem is 
essentially the UART baud rate range being too high to be controllable 
by just the dividers in the UART core. So, the clock rate has to be 
changed in the .set_termios function.

Another concern (not present in MSM) for upstream kernel is that some 
arch/mach might use the clock driver to control the CPU frequency and 
might want to drop it to a low freq in the final stages of an idle 
suspend. In that case, the call would be from atomic context. Similar 
issue during normal suspend.

Except UART, looks like internal teams don't care much for atomic 
clk_set_rate(). So, if .set_termios can use mutex, MSM is good to go for 
prepare/unprepare.

Russell,

If UART does not need clk_set_rate() to be atomic, would you be 
comfortable marking clk_set_rate() as sleepable in the clk.h comments?

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
