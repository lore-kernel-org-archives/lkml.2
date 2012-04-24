Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2DXIKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:10:18 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:55940 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755823Ab2DXIKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:10:15 -0400
Message-ID: <4F965FC4.7010502@stericsson.com>
Date: Tue, 24 Apr 2012 10:09:40 +0200
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
References: <1335173873-24301-1-git-send-email-ulf.hansson@stericsson.com> <20120423101804.GA8318@opensource.wolfsonmicro.com> <4F953455.3080002@stericsson.com> <20120423110522.GB8318@opensource.wolfsonmicro.com> <4F95495D.4050508@stericsson.com> <20120423122555.GM8318@opensource.wolfsonmicro.com> <4F954ED6.2040201@stericsson.com> <20120423180140.GR8318@opensource.wolfsonmicro.com>
In-Reply-To: <20120423180140.GR8318@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 08:01 PM, Mark Brown wrote:
> On Mon, Apr 23, 2012 at 02:45:10PM +0200, Ulf Hansson wrote:
>
>> A typical mmc host driver is when finished it's probe routine,
>> trigger of a so called mmc_rescan work which is taking care of
>> detecting and initializing the eMMC card. It is a quite complicated
>> procedure which preferably not to be handled from the host driver's
>> probe function.
>
>> If the platform already have booted from the eMMC card, the card is
>> already powered an initialized from a bootloader. Cutting the power
>> without first notifying the card by sending commands to it, must be
>> prevented and also violates the eMMC specification. In the end, it
>> will mean that the detect and initialization procedure fails.
>
> Can the driver use is_enabled() in the probe routine to check the
> current status during probe and hand off appropriately?  The issue here
> seems like it's the fact that the driver isn't managing to bootstrapping
> of its state well.

Well, it is not as simple as that. An mmc host driver is just a driver 
for handling a certain mmc IP. Uper layers handles the (e)MMC/SD/SDIO 
protocol including controlling power the card. Moreover the complicated 
detect procedure is handled in a work.

In principle what you are proposing will mean that each mmc host driver 
will have to "flush" the rescan work from probe. This will have horrid 
impact on boot time since rescan can take several hundred of 
milliseconds for each eMMC/SD/SDIO card. Is is far better to handle the 
rescan in parallel works.

I really think it would be much beneficial to be able to tell the late 
init call (regulator_init_completet) to back off from disabling this 
regulator. If not using boot_on, we can invent another regulator 
constraint for this. What do you think of this?

>
> Worst case seems to be that the card will be briefly powered during boot
> then turned off again after enumeration which doesn't seem like the end
> of the world to me.

It is really crucial that the regulator is not switched off in an 
uncontrolled manner. It will mean viloating eMMC spec and in many cases 
the hw is not able to reset the eMMC and thus the detect procedure will 
fail. Likely the eMMC holds root file system then the platform wont boot...

Kind regards
Ulf Hansson
