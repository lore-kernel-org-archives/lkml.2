Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2KFTlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:41:11 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:58207 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432Ab2KFTlH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:41:07 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=iso-8859-1
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CA+Bv8XZOt7h3dtDsk1SaR71J3tYFOTsPJSjZLSP3RVuLdYdFDg@mail.gmail.com>
Date: Tue, 6 Nov 2012 20:41:00 +0100
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <56051C08-3ECF-4C0A-9B88-64B4C1DDDF45@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com> <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com> <20121106183531.GH6801@atomide.com> <CA+Bv8XZOt7h3dtDsk1SaR71J3tYFOTsPJSjZLSP3RVuLdYdFDg@mail.gmail.com>
To: Russ Dill <Russ.Dill@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russ,

On Nov 6, 2012, at 8:29 PM, Russ Dill wrote:

> On Tue, Nov 6, 2012 at 10:35 AM, Tony Lindgren <tony@atomide.com> wrote:
>> * Grant Likely <grant.likely@secretlab.ca> [121106 03:16]:
>>> On Tue, Nov 6, 2012 at 10:30 AM, Pantelis Antoniou
>>> <panto@antoniou-consulting.com> wrote:
>>>> 
>>>> Another can of worms is the pinctrl nodes.
>>> 
>>> Yes... new pinctrl data would need to trigger adding new data to
>>> pinctrl. I don't know if the pinctrl api supports that.
>> 
>> The actual pins stay the same, just their configuration
>> changes. AFAIK all that is already supported using the
>> pinctrl framework.
>> 
>> For example, considering hotplugging capes on the beaglebone:
>> 
>> 1. You need to map all the sensible modes for the pins exposed
>>   to the capes in the board specific .dts file. This will
>>   add roughly 4 x nr_capbus_pins named modes in the .dts file
>>   so not too bad.
>> 
>> 2. Claim all the capebus pins during the capbus driver probe
>>   and set them to some safe mode.
>> 
>> 3. Try to detect the connected cape(s) over i2c.
>> 
>> 4. Use pinctr_select_state to set the desired modes for
>>   the pins used by the cape(s).
>> 
>> 5. Enable capebus regulators and clocks etc.
>> 
>> 6. Load the driver modules for whatever omap internal
>>   devices the cape supports.
>> 
>> You could also claim the pin for the omap internal
>> devices instead of claiming them in the capebus, but then
>> things can get messy with binding and unbinding the
>> drivers. So just claiming all the pins in the capebus
>> probably keeps things simpler.
> 
> That assumes that for a particular external bus, certain pins aren't
> already shared with functions already on the board, for instance if an
> I²C bus brought out to the external bus already has a chip connected
> to it.

This is our case on the bone. We don't enable the peripheral until
a cape that references it is enabled.

I don't think that very big changes are going to be needed TBH.

So now we use:

        am3358_pinmux: pinmux@44e10800 {
		....
                bone_dvi_cape_led_pins: pinmux_bone_dvi_cape_led_pins {
                        pinctrl-single,pins = <
                                0x48 0x07       /* gpmc_a2.gpio1_18, OUTPUT | MODE7 */
                                0x4c 0x07       /* gpmc_a3.gpio1_19, OUTPUT | MODE7 */
                        >;
                };
		....
	};

And in the cape definition:

        pinctrl-0 = <&bone_geiger_cape_pins>;

Ideally if we could do this in the cape definition:

	cape_pinmux {
		parent = <&am3358_pinmux>;

                bone_dvi_cape_led_pins: pinmux_bone_dvi_cape_led_pins {
                        pinctrl-single,pins = <
                                0x48 0x07       /* gpmc_a2.gpio1_18, OUTPUT | MODE7 */
                                0x4c 0x07       /* gpmc_a3.gpio1_19, OUTPUT | MODE7 */
                        >;
	};

        pinctrl-0 = <&bone_geiger_cape_pins>;
	
It would be just fine.

Regards

-- Pantelis

