Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1AORHm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 12:07:42 -0500
Received: from 51.197.216.81.static.s-h.siw.siwnet.net ([81.216.197.51]:41735
	"EHLO sloth.weinigel.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752671Ab1AORHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 12:07:40 -0500
Message-ID: <4D31D45A.8080509@weinigel.se>
Date: Sat, 15 Jan 2011 18:07:38 +0100
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
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk> <4D2D184A.8020405@codeaurora.org> <20110112090301.GS11039@n2100.arm.linux.org.uk> <4D31A8F1.4080301@weinigel.se> <20110115145358.GC15996@n2100.arm.linux.org.uk>
In-Reply-To: <20110115145358.GC15996@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2011 03:53 PM, Russell King - ARM Linux wrote:
> On Sat, Jan 15, 2011 at 03:02:25PM +0100, Christer Weinigel wrote:
>> On platforms that need to sleep to enable the UART clock, configuring
>> the UART as the kernel console should be equivalent to userspace opening
>> the UART device, i.e. enable the clock.  At least to me that feels like
>> an acceptable tradeoff, and if I wanted to save the last bit of power
>> I'll have to refrain from using UART as the kernel console.
>
> Well, we're not discussing a _new_ API here - we're discussing an API
> with existing users which works completely fine on the devices its
> used, with differing expectations between implementations.

Yes, so to fulfil the requirement that printk needs to call clk_enable 
from atomic contexts, document that clk_enable can not sleep.  Or add 
the clk_enable_atomic call and modify printk to use it.

>> Both of these feel like they should use a call such as clk_get_atomic
>> and be able to handle EWOULDBLOCK/EAGAIN (or whatever error code is used
>> to indicate that it would have to sleep) and delegate to a worker thread
>> to enable the clock.  To catch uses of plain clk_enable from atomic
>> contects, add a WARN_ON/BUG_ON(in_atomic()).  It won't catch everything,
>> but would help a bit at least.
>
> We've never allowed clk_get() to be called in interruptible context,
> so that's not the issue.  The issue is purely about clk_enable() and
> clk_disable() and whether they should be able to be called in atomic
> context or not.

My bad, it should have said "clk_enable_atomic".

> There's been a lot of talk on this issue for ages with no real progress
> that I'm just going to repeat: let's unify those implementations which
> use a spinlock for their clks into one consolidated solution, and
> a separate consolidated solution for those which use a mutex.
>
> This will at least allow us to have _some_ consolidation of the existing
> implementations - and it doesn't add anything to the problem at hand.
> It might actually help identify what can be done at code level to resolve
> this issue.

Won't that cause a lot of code duplication?  If it's possible to have 
one sane implementation, why not go for it at once?

   /Christer
