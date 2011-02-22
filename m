Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1BVKq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:46:59 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:57217 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab1BVKq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:46:58 -0500
X-Auth-Info: j1aBlrnnSYXO85LeNla0Tv2gkcdaE430dz9+pfFLav4=
Message-ID: <4D639493.1060601@grandegger.com>
Date: Tue, 22 Feb 2011 11:48:51 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 01/13] mfd: pruss mfd driver.
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>	<1297435892-28278-2-git-send-email-subhasish@mistralsolutions.com>	<20110221163027.GF10686@sortiz-mobl>	<37B3755C4AE64BAA805DFBAEBDC3D9E4@subhasishg> <20110222103127.GC30279@sortiz-mobl>
In-Reply-To: <20110222103127.GC30279@sortiz-mobl>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 11:31 AM, Samuel Ortiz wrote:
> Hi Subhasish,
> 
> On Tue, Feb 22, 2011 at 11:13:38AM +0530, Subhasish Ghosh wrote:
>> Thank you for your comments.
> No problem.
> 
>>>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>>>> index fd01836..6c437df 100644
>>>> --- a/drivers/mfd/Kconfig
>>>> +++ b/drivers/mfd/Kconfig
>>>> @@ -81,6 +81,16 @@ config MFD_DM355EVM_MSP
>>>>   boards.  MSP430 firmware manages resets and power sequencing,
>>>>   inputs from buttons and the IR remote, LEDs, an RTC, and more.
>>>>
>>>> +config MFD_DA8XX_PRUSS
>>>> + tristate "Texas Instruments DA8XX PRUSS support"
>>>> + depends on ARCH_DAVINCI && ARCH_DAVINCI_DA850
>>> Why are we depending on those ?
>>
>> SG -- The PRUSS core in only available within DA850 and DA830,
>>            DA830 support is not yet implemented.
> Sure, but if there are no actual code dependencies, I'd like to get rid of
> those depends.
> 
>>>> +u32 pruss_disable(struct device *dev, u8 pruss_num)
>>>> +{
>>>> + struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
>>>> + da8xx_prusscore_regs h_pruss;
>>>> + u32 temp_reg;
>>>> +
>>>> + if (pruss_num == DA8XX_PRUCORE_0) {
>>>> + /* Disable PRU0  */
>>>> + h_pruss = (da8xx_prusscore_regs)
>>>> + ((u32) pruss->ioaddr + 0x7000);
>>> So it seems you're doing this in several places, and I have a few
>>> comments:
>>>
>>> - You don't need the da8xx_prusscore_regs at all.
>>> - Define the register map through a set of #define in your header file.
>>> - Use a static routine that takes the core number and returns the
>>> register map
>>> offset.
>>>
>>> Then routines like this one will look a lot more readable.
>>
>> SG -- There are a huge number of PRUSS registers. A lot of them are
>> reserved and are expected to change as development on the
>>            controller is still ongoing. 
> First of all, from what I read in your patch you're only using the CONTROL
> offset.
> 
>> If we use #defines to plot
>> all the registers, then first, there are too many array type
>> registers which will need to be duplicated.
> What I'm expecting is a small set of defines for the register offsets. You
> have 13 fields in your da8xx_prusscore_regs, you only need to define 13
> register offsets.
> 
> So, if you have a:
> 
> static u32 reg_offset(struct device *dev, u8 pru_num)
> {
> 	struct da8xx_pruss *pru = dev_get_drvdata(dev->parent);
> 
> 	switch (pru_num) {
> 	case DA8XX_PRUCORE_0:
> 		return (u32) pru->ioaddr + 0x7000;
> 	case DA8XX_PRUCORE_1:
> 		return (u32) pru->ioaddr + 0x7800;
> 	default:
> 		return 0;
> }
> 
> 
> then routines like pruss_enable (which should return an int, btw) would look
> like:
> 
> int pruss_enable(struct device *dev, u8 pruss_num)
> {
> 	u32 offset = reg_offset(dev, pruss_num);
> 
> 	if (offset == 0)
> 		return -EINVAL;
> 
> 	__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
> 			offset + PRU_CORE_CONTROL);
> 
> 	return 0;
> }

All registers are memory mapped and could nicely be described by
structures (and sub-structures). Therefore we asked to considerer
structs, at least for the Pruss SocketCAN drivers. That would result in
much much clearer and better readable code. The code above would shrink to:

	__raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
		     &prucore[pruss_num].control);

And proper type checking would be ensured as well.

Wolfgang.



