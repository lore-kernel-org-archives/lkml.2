Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2DXMny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:43:54 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:49525 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753799Ab2DXMnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:43:53 -0400
Message-ID: <4F969FE8.7040500@stericsson.com>
Date: Tue, 24 Apr 2012 14:43:20 +0200
From: Ulf Hansson <ulf.hansson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] regulator: core: Keep boot_on regulators powered during
 init
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com> <20120423101804.GA8318@opensource.wolfsonmicro.com> <4F953455.3080002@stericsson.com> <20120423110522.GB8318@opensource.wolfsonmicro.com> <4F95495D.4050508@stericsson.com> <20120423122555.GM8318@opensource.wolfsonmicro.com> <4F954ED6.2040201@stericsson.com> <20120423180140.GR8318@opensource.wolfsonmicro.com> <4F965FC4.7010502@stericsson.com> <20120424105603.GA12063@opensource.wolfsonmicro.com>
In-Reply-To: <20120424105603.GA12063@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 12:56 PM, Mark Brown wrote:
> On Tue, Apr 24, 2012 at 10:09:40AM +0200, Ulf Hansson wrote:
>> On 04/23/2012 08:01 PM, Mark Brown wrote:
>
>>> Can the driver use is_enabled() in the probe routine to check the
>>> current status during probe and hand off appropriately?  The issue here
>>> seems like it's the fact that the driver isn't managing to bootstrapping
>>> of its state well.
>
>> Well, it is not as simple as that. An mmc host driver is just a
>> driver for handling a certain mmc IP. Uper layers handles the
>> (e)MMC/SD/SDIO protocol including controlling power the card.
>> Moreover the complicated detect procedure is handled in a work.
>
>> In principle what you are proposing will mean that each mmc host
>> driver will have to "flush" the rescan work from probe. This will
>> have horrid impact on boot time since rescan can take several
>> hundred of milliseconds for each eMMC/SD/SDIO card. Is is far better
>> to handle the rescan in parallel works.
>
> No, that's not what I'm suggesting - all I'm suggesting is that the
> driver uses is_enabled() in probe() to check if the regulator is on, if
> it is then it grabs a reference to it.  Then, when it's figured out
> what's going on, it can drop the reference again if it's not needed.

The problem is how it should "figure out what is going on", all that 
stuff is handled from the protocol layer.

So if grabbing a reference, there is no good point in the code were I 
can drop it. Moreover _every_ host driver needs to handle this. It will 
likely become a "hack" is my first impression.

>> I really think it would be much beneficial to be able to tell the
>> late init call (regulator_init_completet) to back off from disabling
>> this regulator. If not using boot_on, we can invent another
>> regulator constraint for this. What do you think of this?
>
> This just seems awfully fragile and very much dependant on things like
> having the driver actually enabled to clean up later.

Setting this constraint is not done be "default", it could be clearly be 
stated that the consumer must handle the enable/disable, otherwise the 
regulator will be left in the state it was when the kernel booted.

>
>>> Worst case seems to be that the card will be briefly powered during boot
>>> then turned off again after enumeration which doesn't seem like the end
>>> of the world to me.
>
>> It is really crucial that the regulator is not switched off in an
>> uncontrolled manner. It will mean viloating eMMC spec and in many
>> cases the hw is not able to reset the eMMC and thus the detect
>> procedure will fail. Likely the eMMC holds root file system then the
>> platform wont boot...
>
> Right, but I'm talking about uncontrolled enables not disables - worst
> case is you'll have to do an ordered shutdown you wouldn't otherwise
> have to do but that doesn't seem like the end of the world.


Kind regards
Ulf Hansson
