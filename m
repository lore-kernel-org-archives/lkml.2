Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab2HHNng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:43:36 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:56127 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932440Ab2HHNnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:43:35 -0400
Message-ID: <50226CF4.1010202@ti.com>
Date: Wed, 08 Aug 2012 16:43:16 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120723 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>, Dmitry Torokhov <dtor@mail.ru>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH 04/11] MFD: twl4030-audio: Add DT support
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com> <1344418887-5262-5-git-send-email-peter.ujfalusi@ti.com> <20120808131356.GS16861@opensource.wolfsonmicro.com>
In-Reply-To: <20120808131356.GS16861@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 04:13 PM, Mark Brown wrote:
> On Wed, Aug 08, 2012 at 12:41:20PM +0300, Peter Ujfalusi wrote:
> 
>> +Required properties:
>> +- compatible : must be "ti,twl4030-audio"
> 
> So, as I mentioned before I find this sort of direct mapping of the
> Linux device representation into the device tree really troubling.
> I'm just way too aware of the fact that even the Linux split of these
> things can change over time and often represents internal Linux
> considerations.

Yes, I remember. This is however a bit different case compared to the twl6040.
The twl4030 series of PMIC includes the following parts:
twl4030, twl5030, twl5031, tps65950, tps65930 - contains audio block
tps65920, tps65921 - does not contain audio block

So the audio block within these PMICs are really a block, it is present on
some PMIC and it is missing on other's.

This is what we discussed regarding to twl6040. I only expose the audio block
and not the Linux implementation (that we have separate driver for vibra and
codec sub functionality).

>> +-ti,hs_extmute: Use external mute for HS pop reduction
>> +-ti,hs_extmute_gpio: Use external GPIO to control the external mute
>> +-ti,hs_extmute_disable_level: The desired level of the GPIO line when the
>> +			      external mute is disabled. valuse: 0 or 1
> 
> This doesn't seem like something that should be in the CODEC driver
> really, there's a general need for something which can unmute controls
> at the end of the power up sequence and mute before power down.  Also,
> if this is going to be part of the binding shouldn't we just omit the
> first property and simply check for the presence of the property which
> specifies the GPIO?

The hs_extmute is used for reducing pop noise on the headset. The sequence is
described in the TRM and it need to be done within the codec driver since it
is within the sequence.
Now there's two ways for boards to implement it:
using the dedicated pin from twl4030 PMIC (MUTE/GPIO6) - if only
"ti,hs_extmute" present we use this mode.
Some boards are using the GPIO6 from twl4030 for other purposes, in this case
an external GPIO is used for the same purpose - thus we have
ti,hs_extmute_gpio and ti,hs_extmute_disable_level to tell the driver this.
As for the ti,hs_extmute_disable_level: some boards chosen that the mute is
disabled when the signal is high on the GPIO (don't ask me why). This property
tells this.

All of this has to be in the driver due to the sequencing requirements.

> 
>> +#ifdef CONFIG_OF
>> +	if (of_find_node_by_name(node, "codec"))
>> +		return true;
>> +#endif
> 
> This really seems like we should be stubbing out of_find_node_by_name()
> to return false in non-OF cases.

Yes, most likely the of_find_node_by_name() deserves the same treatment as
some selected of_* function in case CONFIG_OF is not selected.
But at the moment this is not the case, we need to protect with ifdef since we
might break other randconfigs where CONFIG_OF is not set.

>> +#ifdef CONFIG_OF
>> +	if (!of_property_read_u32(node, "ti,enable-vibra", &vibra) && vibra)
>> +		return true;
>> +#endif
> 
> Similarly here.

Here the ifdef is no needed. of_property_read_u32() return -ENOSYS in case
CONFIG_OF is not selected.

-- 
Péter
