Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab2CMRX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:23:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38066 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab2CMRXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:23:55 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
To: Dong Aisheng <b29396@freescale.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: s.hauer@pengutronix.de, shawn.guo@freescale.com, kernel@pengutronix.de,
        rob.herring@calxeda.com, cjb@laptop.org, rdunlap@xenotime.net,
        vinod.koul@linux.intel.com
In-Reply-To: <1331628428-24017-2-git-send-email-b29396@freescale.com>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com> <1331628428-24017-2-git-send-email-b29396@freescale.com>
Date: Tue, 13 Mar 2012 11:23:51 -0600
Message-Id: <20120313172351.97C5E3E053B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 16:47:04 +0800, Dong Aisheng <b29396@freescale.com> wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> This patch includes basic dt support which can boot via nfs rootfs.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
>  Documentation/devicetree/bindings/arm/fsl.txt |    4 +
>  arch/arm/boot/dts/imx28-evk.dts               |   31 +++++++++
>  arch/arm/boot/dts/imx28.dtsi                  |   88 +++++++++++++++++++++++++
>  arch/arm/mach-mxs/Kconfig                     |    9 +++
>  arch/arm/mach-mxs/Makefile                    |    1 +
>  arch/arm/mach-mxs/imx28-dt.c                  |   67 +++++++++++++++++++
>  6 files changed, 200 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/fsl.txt b/Documentation/devicetree/bindings/arm/fsl.txt
> index 54bddda..9f21faf 100644
> --- a/Documentation/devicetree/bindings/arm/fsl.txt
> +++ b/Documentation/devicetree/bindings/arm/fsl.txt
> @@ -1,6 +1,10 @@
>  Freescale i.MX Platforms Device Tree Bindings
>  -----------------------------------------------
>  
> +i.MX28 Evaluation Kit
> +Required root node properties:
> +    - compatible = "fsl,imx28-evk", "fsl,imx28";
> +
>  i.MX51 Babbage Board
>  Required root node properties:
>      - compatible = "fsl,imx51-babbage", "fsl,imx51";
> diff --git a/arch/arm/boot/dts/imx28-evk.dts b/arch/arm/boot/dts/imx28-evk.dts
> new file mode 100644
> index 0000000..9758dc4
> --- /dev/null
> +++ b/arch/arm/boot/dts/imx28-evk.dts
> @@ -0,0 +1,31 @@
> +/*
> + * Copyright 2012 Freescale Semiconductor, Inc.
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
> +/include/ "imx28.dtsi"
> +
> +/ {
> +	model = "Freescale i.MX28 Evaluation Kit";
> +	compatible = "fsl,imx28-evk", "fsl,imx28";
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x40000000 0x08000000>;
> +	};
> +
> +	ahb@80080000 {
> +		fec@800f0000 {
> +			phy-mode = "rmii";
> +			local-mac-address = [00 04 9F 01 7D 5B];

Generally a bad idea to put a specific mac address into the device tree.
Better to fill it with zeros.  Otherwise all the dev boards will end up using
the same value.

> +			status = "okay";
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
> new file mode 100644
> index 0000000..acf0dab
> --- /dev/null
> +++ b/arch/arm/boot/dts/imx28.dtsi
> @@ -0,0 +1,88 @@
> +/*
> + * Copyright 2012 Freescale Semiconductor, Inc.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	interrupt-parent = <&icoll>;
> +
> +	aliases {
> +		serial0 = &uart1;
> +	};
> +
> +	cpus {
> +		cpu@0 {
> +			compatible = "arm,arm926ejs";
> +		};
> +	};
> +
> +	apb@80000000 {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		reg = <0x80000000 0x80000>;
> +		ranges;
> +
> +		apbh@80000000 {
> +			compatible = "simple-bus";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			reg = <0x80000000 0x3c900>;
> +			ranges;
> +
> +			icoll: interrupt-controller@80000000 {
> +				compatible = "fsl,imx28-icoll";
> +				interrupt-controller;
> +				#interrupt-cells = <1>;
> +				reg = <0x80000000 0x2000>;
> +			};
> +		};
> +
> +		apbx@80040000 {
> +			compatible = "simple-bus";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			reg = <0x80040000 0x40000>;
> +			ranges;
> +
> +			uart1: uart@80074000 {
> +				compatible = "arm,pl011", "arm,primecell";
> +				reg = <0x80074000 0x2000>;
> +				interrupts = <47>;
> +			};
> +		};

What is the purpose of the apbh and apbx busses?  Will more device nodes
get added to them later, or does each only contain a single device?

g.
