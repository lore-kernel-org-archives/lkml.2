Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab2JKO6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:58:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47211 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab2JKO6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:58:43 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-keystone@list.ti.com - Linux developers for Keystone family of
	devices (May contain non-TIers)" <linux-keystone@list.ti.com>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "Chemparathy, Cyril" <cyril@ti.com>
Subject: RE: [PATCH v2 09/13] ARM: davinci - update the dm644x soc code to
 use common clk drivers
Thread-Topic: [PATCH v2 09/13] ARM: davinci - update the dm644x soc code to
 use common clk drivers
Thread-Index: AQHNp6t77vVliQFxq0CE7FMivrMa2Je0KyOg
Date: Thu, 11 Oct 2012 14:58:26 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041FDB5B@DFLE12.ent.ti.com>
References: <1348683037-9705-1-git-send-email-m-karicheri2@ti.com>
 <1348683037-9705-10-git-send-email-m-karicheri2@ti.com>
 <5076BAA2.6010404@ti.com>
In-Reply-To: <5076BAA2.6010404@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9BEwoQU011473

>> -----Original Message-----
>> From: Nori, Sekhar
>> Sent: Thursday, October 11, 2012 8:25 AM
>> To: Karicheri, Muralidharan
>> Cc: mturquette@linaro.org; arnd@arndb.de; akpm@linux-foundation.org;
>> shawn.guo@linaro.org; rob.herring@calxeda.com; linus.walleij@linaro.org;
>> viresh.linux@gmail.com; linux-kernel@vger.kernel.org; Hilman, Kevin;
>> linux@arm.linux.org.uk; davinci-linux-open-source@linux.davincidsp.com; linux-arm-
>> kernel@lists.infradead.org; linux-keystone@list.ti.com - Linux developers for Keystone
>> family of devices (May contain non-TIers); linux-c6x-dev@linux-c6x.org; Chemparathy,
>> Cyril
>> Subject: Re: [PATCH v2 09/13] ARM: davinci - update the dm644x soc code to use
>> common clk drivers
>> 
>> Murali,
>> 
>> On 9/26/2012 11:40 PM, Murali Karicheri wrote:
>> > The clock tree for dm644x is defined using the new structure davinci_clk.
>> > The SoC specific code re-uses clk-fixed-rate, clk-divider and clk-mux
>> > drivers in addition to the davinci specific clk drivers,
>> > clk-davinci-pll and clk-davinci-psc. Macros are defined to define the
>> > various clocks in the SoC.
>> >
>> > Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> 
>> You have chosen to keep all clock related data in platform files while using the common
>> clock framework to provide just the infrastructure. If you look at how mxs and spear
>> have been migrated, they have migrated the soc specific clock data to drivers/clk as well.
>> See "drivers/clk/spear/spear3xx_clock.c" or "drivers/clk/mxs/clk-imx23.c 

I have to disagree on this one. I had investigated these code already and came up with a way that we can re-use code across all of the davinci platforms as well as other architectures that re-uses the clk hardware IPs. spear3xx_clock.c has initialization code for each of the platforms and so is the case with imx23.c. By using platform_data approach, we are able to define clks for each of the SoC and then use davinci_common_clk_init() to do initialize the clk drivers based on platform data. Later once we migrate to device tree, davinci_common_clk_init() will go way and also the clk structures defined in the SoC file. I have prototyped this on one of the device that I am working on. davinci_common_clk_init() will be replaced with a of_davinci_clk_init() that will use device tree to get all of the platform data for the clk providers and do the initialization based on that. See highbank_clocks_init() in clk-highbank.c. I have used this model for device
tree based clk initialization.

So it make sense to keep the design the way it is. Otherwise we will end up writing dm644x_clk_init(), dm355_clk_init(), etc for each of the platforms and these code will get thrown away once we migrate to
device tree. 

>>". I feel the
>> latter way is better and I also think it will simplify some of the look-up infrastructure you
>> had to build. This will also help some real code reduction from arch/arm/mach-davinci/.
>>

The look-up infrastructure is pretty much re-use of the existing code base in SoC specific file. About code reduction, I can't say I agree, as we need to add platform_specific clock initialization code if we follow spear3xx_clock.c model and end up probably adding more code. SoC specific file (for example dm644x.c) has only data structures and all of SoC will re-use davinci_common_clk_init() to do the initialization. So I am not sure how you conclude we will have code reduction?

- Murali

>> Thanks,
>> Sekhar
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
