Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2KIVIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:08:37 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53156 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2KIVIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:08:35 -0500
MIME-Version: 1.0
In-Reply-To: <20121109022624.GI23553@truffula.fritz.box>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <20121109022624.GI23553@truffula.fritz.box>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 21:08:14 +0000
X-Google-Sender-Auth: 5t8y5eMIfX78SzPKmUbXmKei6e0
Message-ID: <CACxGe6v7q2=Dxn6BE_V-w9CEKxAsZ6zQd5Uqm4TeYGYCCu76cg@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 2:26 AM, David Gibson
<david@gibson.dropbear.id.au> wrote:
>> Summary points:
>> - Create an FDT overlay data format and usage model
>>   - SHALL reliable resolve or validate of phandles between base and
>>     overlay trees
>
> So, I'm not at all clear on what this proposed phandle validation
> would involve.  I'm also not convinced it's as necessary as you
> think, more on that below.

Simply this: I'm taking this example from the omap3-beagle-xm.dts. It
has the following stanza which is currently rolled into the resulting
.dtb when compiled.

&i2c1 {
        clock-frequency = <2600000>;

        twl: twl@48 {
                reg = <0x48>;
                interrupts = <7>; /* SYS_NIRQ cascaded to intc */
                interrupt-parent = <&intc>;

                vsim: regulator-vsim {
                        compatible = "ti,twl4030-vsim";
                        regulator-min-microvolt = <1800000>;
                        regulator-max-microvolt = <3000000>;
                };

                twl_audio: audio {
                        compatible = "ti,twl4030-audio";
                        codec {
                        };
                };
        };
};

However, if it were compiled into a separate dtb overlay it might look
like this:

/ {
    .readonly;
    ocp {
        .readonly;
        interrupt-controller@48200000 {
            phandle = <0x1234>; /* EXPECTED PHANDLE */
            .readonly;
        };
        i2c@48070000 {
            .must-exist;
            clock-frequency = <2600000>;

            twl@48 {
                reg = <0x48>;
                interrupts = <7>;
                interrupt-parent = <0x1234>;   /* RESOLVED PHANDLE */

                vsim: regulator-vsim {
                        compatible = "ti,twl4030-vsim";
                        regulator-min-microvolt = <1800000>;
                        regulator-max-microvolt = <3000000>;
                };

                twl_audio: audio {
                        compatible = "ti,twl4030-audio";
                        codec {
                        };
                };
            };
        };
    };
};

Notice I've included the intc node and it's phandle. By phandle
validation I merely mean that when applying an overly the firmware or
kernel must verify that the phandles in the overlay match the phandle
in the base tree. If they don't match, then refuse to apply the
overhead. This approach avoids the need to find and fixup phandles in
the overlay. And if the phandle is generated from a hash of the
full_name, then the resulting phandle will only change if the node
moves.

Similarly, at application time it should be verified that the nodes
with a .readonly or .must-exist property could be verified to actually
exist before attempting to apply the overlay. I used two different
properties with the idea that only certain nodes would need to be
modified... exactly what the policies should be is yet to be
determined.

g.
