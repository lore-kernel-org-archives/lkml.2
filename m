Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2DBReH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:34:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52630 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2DBReF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:34:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6668"; a="178111092"
Message-ID: <4F79E308.5090208@codeaurora.org>
Date: Mon, 02 Apr 2012 10:34:00 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clkdev: Implement managed clk_get()
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com> <4F787392.5040308@codeaurora.org> <20120401153450.GC8971@opensource.wolfsonmicro.com> <4F79D85F.4020909@codeaurora.org> <20120402165242.GC24211@n2100.arm.linux.org.uk> <4F79DC03.7020503@codeaurora.org> <20120402170858.GG24211@n2100.arm.linux.org.uk> <4F79DED3.4070007@codeaurora.org> <20120402172133.GH24211@n2100.arm.linux.org.uk>
In-Reply-To: <20120402172133.GH24211@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/12 10:21, Russell King - ARM Linux wrote:
> On Mon, Apr 02, 2012 at 10:16:03AM -0700, Stephen Boyd wrote:
>> On 04/02/12 10:08, Russell King - ARM Linux wrote:
>>> Utter crap.  Deleting them makes the non-common clock implementations
>>> unsafe.  If a struct clk is provided by a module (and we do have some
>>> which are) then the module reference count has to be held.  That's
>>> what these hooks do.
>>>
>>> When these platforms get converted over to the common clock, and the
>>> issues surrounding dynamically registered and removed clocks are sane,
>>> these hooks have to be used by the common clock to deal with the
>>> refcounting so that common code knows when the structures can be freed.
>> I'm saying that when every platform is using the common clock code we
>> would only have one __clk_get() implementation and we should be able to
>> delete clkdev.h entirely.
> No you did not, you said quite clearly that clkdev should go away and
> be replaced by something else, because you see clkdev as just another
> "platform specific implementation" (your words).  You were definitely
> not talking about _just_ the backends for clkdev's clk_get().

Sorry. I was speaking about the future when we have one struct clk
definition. I suppose that wasn't clear because I wasn't explicit.

I do think we should improve/replace clkdev by keeping the core parts
(device name and connection name mapping) and internalizing it in the
common clock code. Your comment about a 1:N mapping between clocks and
devices sounds unfortunate.

Ideally we should be generating struct clks at runtime when clk_get() is
called. This way we can tie each caller of clk_get() to a different
instance of a struct clk that eventually all maps back to the same
struct clk_hw in the hardware layer. Right now clkdev is managing the
mapping at too high of a level and denies any such dynamic allocation
scheme.

If we did this it would help us locate bad drivers who all share some
clock in common. Finding which driver is keeping a clock on is annoying
when you have to trace each clk_enable/disable call and see who is
calling it to figure out which driver hasn't released its vote.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

