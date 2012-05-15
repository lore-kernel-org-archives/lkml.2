Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966715Ab2EOUJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:09:04 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14670 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966025Ab2EOUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:09:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6712"; a="191231278"
Message-ID: <4FB2B7DC.4070706@codeaurora.org>
Date: Tue, 15 May 2012 13:09:00 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>, Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] clk: Fix race conditions between clk_set_parent() and
 clk_enable()
References: <1336798797-8724-1-git-send-email-skannan@codeaurora.org> <20120515194245.GO30400@pengutronix.de> <4FB2B3AA.3010903@codeaurora.org> <20120515200040.GP30400@pengutronix.de>
In-Reply-To: <20120515200040.GP30400@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 01:00 PM, Sascha Hauer wrote:
> On Tue, May 15, 2012 at 12:51:06PM -0700, Saravana Kannan wrote:
>>>>   	ret = clk->ops->set_parent(clk->hw, i);
>>>
>>> You call ->set_parent while holding a spinlock. This won't work with i2c
>>> clocks.
>>
>> I did account for that. I explained it in the commit text. Please
>> let me know if any part of that is not clear or is not correct.
>>
>
> I missed this part in the commit log. I have no idea whether we can live
> with this limitation though.
>
> Sascha
>

It's not really an artificial limitation of the patch. This has to be 
enforced if the clock is to be managed correctly while allowing 
.set_parent to NOT be atomic.

There is no way to guarantee that the enable/disable is properly 
propagated to the parent clock if we can't guarantee mutual exclusion 
between changing parents and calling enable/disable.

Since we can't do mutual exclusion be using spinlock (since .set_parent 
is NOT atomic for these clocks), then only other way of ensuring mutual 
exclusion is to force an unprepare and then mutually exclude a prepare 
while changing the parent. This by association (can't enable unprepared 
clock) mutually excludes the changing of parent and calling enable/disable.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
