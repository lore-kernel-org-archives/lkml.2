Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab2HHPPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:15:34 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:47145
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758663Ab2HHPPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:15:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzz8275bh8275dhz2dh87h2a8h668h839h944hd25he96hf0ah107ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 8 Aug 2012 23:15:58 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Matt Sealey <matt@genesi-usa.com>
CC: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] efikamx: reintroduce Genesi Efika MX Smarttop via device
 tree
Message-ID: <20120808151555.GE14718@S2101-09.ap.freescale.net>
References: <1344375978-29981-1-git-send-email-matt@genesi-usa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1344375978-29981-1-git-send-email-matt@genesi-usa.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 04:46:18PM -0500, Matt Sealey wrote:
> This device tree only supports the final retail board ("TO3").
> 
> It is currently feature equivalent to the MX51 Babbage device tree. The
> following features have been tested and work as well as can be expected:
> 
> * Serial port
> * SD card support
> * I2C bus
> * SGTL5000 audio support via the internal speaker
> * SDMA support (via audio)
> * SPI bus
> * NOR flash (at 25MHz bus speed)
> * MC13892 PMIC Regulator and Realtime clock functions
> 
> Since the board requires some extra work on the PMIC to power off, the system
> will instead just halt, however reboot works. Other missing features are due
> to a lack of drivers or device tree bindings currently.
> 
> Signed-off-by: Matt Sealey <matt@genesi-usa.com>
> Signed-off-by: Steev Klimaszewski <steev@genesi-usa.com>
> ---
>  arch/arm/boot/dts/imx51-efikamx.dts |  247 +++++++++++++++++++++++++++++++++++
>  arch/arm/mach-imx/Makefile.boot     |    2 +-
>  2 files changed, 248 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/imx51-efikamx.dts
> 
> diff --git a/arch/arm/boot/dts/imx51-efikamx.dts b/arch/arm/boot/dts/imx51-efikamx.dts
> new file mode 100644
> index 0000000..dd14f77
> --- /dev/null
> +++ b/arch/arm/boot/dts/imx51-efikamx.dts
> @@ -0,0 +1,247 @@
> +/*
> + * Copyright 2011 Freescale Semiconductor, Inc.
> + * Copyright 2011 Linaro Ltd.
> + * Copyright 2012 Genesi USA, Inc.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +/dts-v1/;
> +/include/ "imx51.dtsi"
> +
> +/ {
> +	model = "Genesi Efika MX (Smarttop)";
> +	compatible = "genesi,imx51-efikamx", "fsl,imx51";
> +
> +	memory {
> +		reg = <0x90000000 0x20000000>;
> +	};
> +
> +	soc {
> +		aips@70000000 {
> +			spba@70000000 {
> +				esdhc@70004000 {

The pinctrl_provide_dummies() in imx51_dt_init() is something to be
removed.  Then any driver calling pinctrl API will require pinctrl
set up for the device here.  So please have the pinctrl setup for
those devices. 

> +					cd-gpios = <&gpio1 0 0>;
> +					wp-gpios = <&gpio1 1 0>;
> +					status = "okay";
> +				};
> +
> +				ssi2: ssi@70014000 {
> +				    fsl,mode = "i2s-slave";
> +				    status = "okay";
> +				};
> +
> +				ecspi@70010000 {
> +					fsl,spi-num-chipselects = <2>;
> +					cs-gpios = <&gpio4 24 0>, <&gpio4 25 0>;
> +					status = "okay";
> +
> +					pmic: mc13892@0 {
> +						#address-cells = <1>;
> +						#size-cells = <0>;
> +						compatible = "fsl,mc13892";
> +						spi-max-frequency = <6000000>;
> +						reg = <0>;
> +						interrupt-parent = <&gpio1>;
> +						interrupts = <6 0x4>;
> +						fsl,mc13xxx-uses-rtc;
> +
> +						regulators {
> +							sw1_reg: sw1 {
> +								regulator-min-microvolt = <600000>;
> +								regulator-max-microvolt = <1375000>;
> +								regulator-boot-on;
> +								regulator-always-on;
> +							};
> +
> +							sw2_reg: sw2 {
> +								regulator-min-microvolt = <900000>;
> +								regulator-max-microvolt = <1850000>;
> +								regulator-boot-on;
> +								regulator-always-on;
> +							};
> +
> +							sw3_reg: sw3 {
> +								regulator-min-microvolt = <1100000>;
> +								regulator-max-microvolt = <1850000>;
> +								regulator-boot-on;
> +								regulator-always-on;
> +							};
> +
> +							sw4_reg: sw4 {
> +								regulator-min-microvolt = <1100000>;
> +								regulator-max-microvolt = <1850000>;
> +								regulator-boot-on;
> +								regulator-always-on;
> +							};
> +
> +							vpll_reg: vpll {
> +								regulator-min-microvolt = <1050000>;
> +								regulator-max-microvolt = <1800000>;
> +								regulator-boot-on;
> +								regulator-always-on;
> +							};
> +
> +							vdig_reg: vdig {
> +								regulator-min-microvolt = <1650000>;
> +								regulator-max-microvolt = <1650000>;
> +								regulator-boot-on;
> +							};
> +
> +							vsd_reg: vsd {
> +								regulator-min-microvolt = <3150000>;
> +								regulator-max-microvolt = <3150000>;
> +							};
> +
> +							vusb2_reg: vusb2 {
> +								regulator-min-microvolt = <2400000>;
> +								regulator-max-microvolt = <2775000>;
> +								regulator-boot-on;
> +								regulator-always-on;
> +							};
> +
> +							vvideo_reg: vvideo {
> +								regulator-min-microvolt = <2775000>;
> +								regulator-max-microvolt = <2775000>;
> +								regulator-boot-on;
> +							};
> +
> +							vaudio_reg: vaudio {
> +								regulator-min-microvolt = <2300000>;
> +								regulator-max-microvolt = <3000000>;
> +							};
> +
> +							vcam_reg: vcam {
> +								regulator-min-microvolt = <2500000>;
> +								regulator-max-microvolt = <3000000>;
> +							};
> +
> +							vgen1_reg: vgen1 {
> +								regulator-min-microvolt = <1200000>;
> +								regulator-max-microvolt = <3150000>;
> +							};
> +
> +							vgen2_reg: vgen2 {
> +								regulator-min-microvolt = <3150000>;
> +								regulator-max-microvolt = <3150000>;
> +								regulator-always-on;
> +							};
> +
> +							vgen3_reg: vgen3 {
> +								regulator-min-microvolt = <1800000>;
> +								regulator-max-microvolt = <2900000>;
> +								regulator-always-on;
> +							};
> +						};
> +					};
> +
> +					flash: sst25vf032b@1 {
> +						#address-cells = <1>;
> +						#size-cells = <1>;
> +						compatible = "sst,sst25vf032b";
> +						spi-max-frequency = <25000000>;
> +						reg = <1>;
> +
> +						partition@0 {
> +							label = "firmware";
> +							reg = <0x0 0x200000>;
> +						};
> +
> +						partition@200000 {
> +							label = "user";
> +							reg = <0x200000 0x200000>;
> +						};
> +					};
> +				};
> +			};
> +
> +			wdog@73f98000 {
> +				status = "okay";
> +			};

Remove it.  I have queued a patch to enable wdog in <soc>.dtsi
by default.

> +
> +			iomuxc@73fa8000 {
> +				compatible = "fsl,imx51-iomuxc";
> +				reg = <0x73fa8000 0x4000>;
> +			};
> +
> +			uart1: serial@73fbc000 {
> +				fsl,uart-has-rtscts;
> +				status = "okay";
> +			};
> +
> +		};
> +
> +		aips@80000000 {
> +			sdma@83fb0000 {
> +				fsl,sdma-ram-script-name = "imx/sdma/sdma-imx51.bin";
> +			};

Remove it.  I have seen a patch to move this name into <soc>.dtsi
as default.

> +
> +			i2c@83fc4000 {
> +				status = "okay";
> +
> +				codec: sgtl5000@0a {
> +					compatible = "fsl,sgtl5000";
> +					reg = <0x0a>;
> +					clock-frequency = <12288000>;
> +					VDDA-supply = <&vdig_reg>;
> +					VDDIO-supply = <&vvideo_reg>;
> +				};
> +			};
> +
> +			audmux@83fd0000 {
> +				status = "okay";
> +			};
> +		};
> +	};
> +
> +	gpio-keys {
> +		compatible = "gpio-keys";
> +
> +		power {
> +			label = "Power Button";
> +			gpios = <&gpio2 31 0>;
> +			linux,code = <116>; /* KEY_POWER */
> +			gpio-key,wakeup;
> +		};
> +	};
> +
> +	gpio-leds {
> +		compatible = "gpio-leds";
> +
> +		red {
> +			label = "red";
> +			gpios = <&gpio3 13>;
> +			linux,default-trigger = "ide-disk";
> +		};
> +
> +		green {
> +			label = "green";
> +			gpios = <&gpio3 14>;
> +			linux,default-trigger = "default-on";
> +		};
> +
> +		blue {
> +			label = "blue";
> +			gpios = <&gpio3 15>;
> +			linux,default-trigger = "mmc0";
> +		};
> +	};
> +
> +	sound {
> +		compatible = "fsl,imx-audio-sgtl5000";
> +		model = "efikamx-sgtl5000";
> +		ssi-controller = <&ssi2>;
> +		audio-routing =
> +			"MIC_IN", "Mic Jack",
> +			"Mic Jack", "Mic Bias",
> +			"Ext Spk", "LINE_OUT";
> +		audio-codec = <&codec>;
> +		mux-int-port = <2>;
> +		mux-ext-port = <3>;
> +	};
> +};
> diff --git a/arch/arm/mach-imx/Makefile.boot b/arch/arm/mach-imx/Makefile.boot
> index 05541cf..3ed7c9d 100644
> --- a/arch/arm/mach-imx/Makefile.boot
> +++ b/arch/arm/mach-imx/Makefile.boot
> @@ -38,7 +38,7 @@ zreladdr-$(CONFIG_SOC_IMX6Q)	+= 0x10008000
>  params_phys-$(CONFIG_SOC_IMX6Q)	:= 0x10000100
>  initrd_phys-$(CONFIG_SOC_IMX6Q)	:= 0x10800000
>  
> -dtb-$(CONFIG_MACH_IMX51_DT) += imx51-babbage.dtb
> +dtb-$(CONFIG_MACH_IMX51_DT) += imx51-babbage.dtb imx51-efikamx.dtb

Please have the new entry on the new line like dtb-$(CONFIG_SOC_IMX6Q).
Yes, we will change dtb-$(CONFIG_MACH_IMX53_DT).

>  dtb-$(CONFIG_MACH_IMX53_DT) += imx53-ard.dtb imx53-evk.dtb \
>  			       imx53-qsb.dtb imx53-smd.dtb
>  dtb-$(CONFIG_SOC_IMX6Q)	+= imx6q-arm2.dtb \
> -- 
> 1.7.9.5
> 

-- 
Regards,
Shawn

