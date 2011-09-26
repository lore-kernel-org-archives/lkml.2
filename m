Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab1IZWBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:01:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38367 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1IZWBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:01:06 -0400
Message-ID: <4E80F613.8050603@ti.com>
Date: Tue, 27 Sep 2011 00:00:51 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        "parthab@india.ti.com" <parthab@india.ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hilman, Kevin" <khilman@ti.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
Subject: Re: [PATCH 1/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1109221213500.10719@utopia.booyaka.com> <4E7B8C68.7020407@ti.com> <alpine.DEB.2.00.1109221524560.10719@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1109221524560.10719@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 9/23/2011 1:31 AM, Paul Walmsley wrote:
> Hi
>
> On Thu, 22 Sep 2011, Cousson, Benoit wrote:
>
>> ADDR_TYPE_RT is mainly use for sysconfig access inside hwmod core today, so
>> why should we use it in this case?
>
> Just for consistency, since the flag isn't defined to be
> SYSCONFIG-specific.
>
> That way, if there's another need -- other than SYSCONFIG access -- to
> identify the chunk of address space that's used for register access, we
> won't have to dig through and possibly repatch the hwmod data, just
> because some people didn't want to follow the rule.
>
> If the flag was simply defined to be SYSCONFIG-specific, then you're
> right, it wouldn't be needed.
>
>> To be honest, I've been confused with that flag for some time :-)
>>   * ADDR_TYPE_RT: Address space contains module register target data.
>> Maybe that's my English, but what does "register target data" mean exactly?
>
> The name comes from the L3 section of the 34xx TRM - see for example
> section 9.1.1 "Terminology" of the rev ZR TRM.  The L3 has several address
> space sections, and whoever wrote that text -- Sonics? -- called the one
> with the L3's own internal registers the "register target."  And I was
> looking for a name that I did not have to make up, so I personally
> wouldn't have to defend the name ;-)

OK, so the registers target is not even the IP itself but the 4k memory 
space before every L3/L4 IPs?

>> What was the intent? Providing a way to identify some register vs memory
>> space?
>
> As you suggest, the original impetus for the flag was to identify which
> chunk of address space needs to be mapped by the hwmod code for SYSCONFIG
> accesses to work.  On current OMAPs, this seems to be the same thing as
> identifying the IP block's primary register area for every module with
> SYS* and REVISION registers.  And I probably thought at the time that
> specifying the IP block's main register mapping seemed more useful and
> generally applicable than designating where the SYSCONFIG register was.
> Hence the current definition.

I think we are lucky that the sysconfig is always in the first memory 
region in the case of multiple address spaces like for the usb_host. 
This is clearly something we will have to enforce in the future, 
especially in the strongly order DT world :-)

>> Regarding main_clk, I do not think that some internal IPs like ohci/ehci
>> should have a main_clk, since this is not visible at that level.
>
> Do you not agree that every IP block that contains sequential logic on
> current and foreseeable future SoCs must have some clock signal to drive
> that logic?

Yes I do. My point was that some time we cannot necessarily identify 
this clock or this clock is not relevant due to the container around it.

> The idea of the main_clk was not intended to be PRCM or OCP or even
> OMAP-specific.  It's just intended to represent a clock that is used to
> drive the register logic inside the IP block.  Therefore it must be
> enabled before any register access may occur.  Even if clock gating is
> handled by some higher-level interface (e.g., at the IP block level), the
> main_clk has a rate, so it also implies an upper limit on how quickly
> register operations can occur.  I suppose that all of the IP block's
> clocks could be "optional clocks," but we know that every IP block with
> registers requires at least one clock to work, and that should be the
> main_clk.

OK, I'm too PRCM centric... A clock that is not clearly represented by 
the PRCM should not necessarily exist in the current hwmod 
representation for my PRCM centric point of view :-). And in this case, 
enabling the clock might not be enough since this is the modulemode that 
does matter in OMAP4. That's why I'd rather not put any clock instead of 
a clock that will anyway not be enough to do anything useful due to the 
dependency with the container.

Exposing too many fake nodes might lead to false interpretation and some 
increase of the apparent complexity wrt the real HW capacity.

Bottom-line, I'm not opposed to add such information, but I'd rather 
populate the real HW information available and not extrapolate too much 
if this does not bring some real advantage.

Regards,
Benoit


