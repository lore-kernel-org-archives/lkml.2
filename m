Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2LCLCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:02:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47608 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab2LCLCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:02:13 -0500
Message-ID: <50BC8685.20105@ti.com>
Date: Mon, 3 Dec 2012 12:01:25 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Tony Lindgren <tony@atomide.com>, <grant.likely@secretlab.ca>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Enrico Butera <ebutera@gmail.com>,
        Matthias Brugger <matthias.bgg@googlemail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ARM/dts: omap3: Add generic DT support for IGEP
 devices
References: <1354270137-31538-1-git-send-email-javier.martinez@collabora.co.uk> <1354270137-31538-2-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1354270137-31538-2-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 11:08 AM, Javier Martinez Canillas wrote:
> Add a generic .dtsi device tree source file for the
> common characteristics across IGEP Technology devices.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Acked-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  arch/arm/boot/dts/omap3-igep.dtsi |   93 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 93 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/omap3-igep.dtsi
> 
> diff --git a/arch/arm/boot/dts/omap3-igep.dtsi b/arch/arm/boot/dts/omap3-igep.dtsi
> new file mode 100644
> index 0000000..a093bff
> --- /dev/null
> +++ b/arch/arm/boot/dts/omap3-igep.dtsi
> @@ -0,0 +1,93 @@
> +/*
> + * Device Tree Source for IGEP Technology devices
> + *
> + * Copyright (C) 2012 Javier Martinez Canillas <javier@collabora.co.uk>
> + * Copyright (C) 2012 Enric Balletbo i Serra <eballetbo@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +/dts-v1/;
> +
> +/include/ "omap3.dtsi"
> +
> +/ {
> +	memory {
> +		device_type = "memory";
> +		reg = <0x80000000 0x20000000>; /* 512 MB */
> +	};
> +
> +	sound {
> +		compatible = "ti,omap-twl4030";
> +		ti,model = "igep2";
> +		ti,mcbsp = <&mcbsp2>;
> +		ti,codec = <&twl_audio>;
> +	};
> +};
> +
> +&omap3_pmx_core {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <
> +		  &mcbsp2_pins
> +	>;

Tony made a comment to avoid associating these data inside the pmx_core
and instead do that in the dedicated device part.

> +
> +	uart3_pins: pinmux_uart3_pins {
> +		pinctrl-single,pins = <
> +			0x16e 0x100	/* uart3_rx.uart3_rx INPUT | MODE0 */
> +			0x170 0		/* uart3_tx.uart3_tx OUTPUT | MODE0 */
> +		>;
> +	};
> +
> +	mcbsp2_pins: pinmux_mcbsp2_pins {
> +		pinctrl-single,pins = <
> +			0x1a2 0x0104	/* mcspi1_cs2.gpio_176 INPUT | MODE4 */
> +		>;
> +	};

BTW, in this case, the UART3 does not seems to have any connection with
the pins settings. Sine your don't have it in the pmx_core you should
have it in side the UART3 node.

&uart3 {
	pinctrl-names = "default";
	pinctrl-0 = <&uart3_pins>;
};

The rational is that, the mux will be done only if the driver is probed
and not unconditionally during pmx_core probe like it will be the case
otherwise.

Regards,
Benoit


> +};
> +
> +&i2c1 {
> +	clock-frequency = <2600000>;
> +
> +	twl: twl@48 {
> +		reg = <0x48>;
> +		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
> +		interrupt-parent = <&intc>;
> +
> +		vsim: regulator@10 {
> +			compatible = "ti,twl4030-vsim";
> +			regulator-min-microvolt = <1800000>;
> +			regulator-max-microvolt = <3000000>;
> +		};
> +
> +		twl_audio: audio {
> +			compatible = "ti,twl4030-audio";
> +			codec {
> +			      };
> +		};
> +	};
> +};
> +
> +/include/ "twl4030.dtsi"
> +
> +&i2c2 {
> +	clock-frequency = <400000>;
> +};
> +
> +&mmc1 {
> +	vmmc-supply = <&vmmc1>;
> +	vmmc_aux-supply = <&vsim>;
> +	bus-width = <8>;
> +};
> +
> +&mmc2 {
> +	status = "disabled";
> +};
> +
> +&mmc3 {
> +	status = "disabled";
> +};
> +
> +&twl_gpio {
> +	ti,use-leds;
> +};
> 

