Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab2ITU0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 16:26:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41981 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2ITU0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 16:26:23 -0400
Message-ID: <505B7BEB.6010105@gmail.com>
Date: Thu, 20 Sep 2012 15:26:19 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, Pawel Moll <pawel.moll@arm.com>,
        konrad.wilk@oracle.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual machines
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 12:44 PM, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: Pawel Moll <pawel.moll@arm.com>
> CC: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/boot/dts/vexpress-xenvm-4.2.dts |  115 ++++++++++++++++++++++++++++++
>  arch/arm/mach-vexpress/Makefile.boot     |    3 +-
>  2 files changed, 117 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/boot/dts/vexpress-xenvm-4.2.dts
> 
> diff --git a/arch/arm/boot/dts/vexpress-xenvm-4.2.dts b/arch/arm/boot/dts/vexpress-xenvm-4.2.dts
> new file mode 100644
> index 0000000..bfb802c
> --- /dev/null
> +++ b/arch/arm/boot/dts/vexpress-xenvm-4.2.dts
> @@ -0,0 +1,115 @@
> +/*
> + * Xen Virtual Machine for unprivileged guests
> + *
> + * Based on ARM Ltd. Versatile Express CoreTile Express (single CPU)
> + * Cortex-A15 MPCore (V2P-CA15)
> + *
> + */
> +
> +/dts-v1/;
> +
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	model = "XENVM-4.2";
> +	compatible = "xen,xenvm-4.2", "arm,vexpress";
> +	interrupt-parent = <&gic>;
> +
> +	chosen {
> +		bootargs = "earlyprintk console=hvc0 root=/dev/xvda init=/sbin/init";
> +	};
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			device_type = "cpu";
> +			compatible = "arm,cortex-a15";
> +			reg = <0>;
> +		};
> +	};
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x80000000 0x08000000>;

How much guest memory can be supported here?

I would expect something like the memory size to be filled in by the
hypervisor. If so, perhaps a note on any fields hypervisor will adjust.

Rob

> +	};
> +
> +	gic: interrupt-controller@2c001000 {
> +		compatible = "arm,cortex-a9-gic";
> +		#interrupt-cells = <3>;
> +		#address-cells = <0>;
> +		interrupt-controller;
> +		reg = <0x2c001000 0x1000>,
> +		      <0x2c002000 0x100>;
> +	};
> +
> +	timer {
> +		compatible = "arm,armv7-timer";
> +		interrupts = <1 13 0xf08>,
> +			     <1 14 0xf08>,
> +			     <1 11 0xf08>,
> +			     <1 10 0xf08>;
> +	};
> +
> +	hypervisor {
> +		compatible = "xen,xen-4.2", "xen,xen";
> +		reg = <0xb0000000 0x20000>;
> +		interrupts = <1 15 0xf08>;
> +	};
> +
> +	motherboard {
> +		arm,v2m-memory-map = "rs1";
> +		ranges = <0 0 0x08000000 0x04000000>,
> +			 <1 0 0x14000000 0x04000000>,
> +			 <2 0 0x18000000 0x04000000>,
> +			 <3 0 0x1c000000 0x04000000>,
> +			 <4 0 0x0c000000 0x04000000>,
> +			 <5 0 0x10000000 0x04000000>;
> +
> +		interrupt-map-mask = <0 0 63>;
> +		interrupt-map = <0 0  0 &gic 0  0 4>,
> +				<0 0  1 &gic 0  1 4>,
> +				<0 0  2 &gic 0  2 4>,
> +				<0 0  3 &gic 0  3 4>,
> +				<0 0  4 &gic 0  4 4>,
> +				<0 0  5 &gic 0  5 4>,
> +				<0 0  6 &gic 0  6 4>,
> +				<0 0  7 &gic 0  7 4>,
> +				<0 0  8 &gic 0  8 4>,
> +				<0 0  9 &gic 0  9 4>,
> +				<0 0 10 &gic 0 10 4>,
> +				<0 0 11 &gic 0 11 4>,
> +				<0 0 12 &gic 0 12 4>,
> +				<0 0 13 &gic 0 13 4>,
> +				<0 0 14 &gic 0 14 4>,
> +				<0 0 15 &gic 0 15 4>,
> +				<0 0 16 &gic 0 16 4>,
> +				<0 0 17 &gic 0 17 4>,
> +				<0 0 18 &gic 0 18 4>,
> +				<0 0 19 &gic 0 19 4>,
> +				<0 0 20 &gic 0 20 4>,
> +				<0 0 21 &gic 0 21 4>,
> +				<0 0 22 &gic 0 22 4>,
> +				<0 0 23 &gic 0 23 4>,
> +				<0 0 24 &gic 0 24 4>,
> +				<0 0 25 &gic 0 25 4>,
> +				<0 0 26 &gic 0 26 4>,
> +				<0 0 27 &gic 0 27 4>,
> +				<0 0 28 &gic 0 28 4>,
> +				<0 0 29 &gic 0 29 4>,
> +				<0 0 30 &gic 0 30 4>,
> +				<0 0 31 &gic 0 31 4>,
> +				<0 0 32 &gic 0 32 4>,
> +				<0 0 33 &gic 0 33 4>,
> +				<0 0 34 &gic 0 34 4>,
> +				<0 0 35 &gic 0 35 4>,
> +				<0 0 36 &gic 0 36 4>,
> +				<0 0 37 &gic 0 37 4>,
> +				<0 0 38 &gic 0 38 4>,
> +				<0 0 39 &gic 0 39 4>,
> +				<0 0 40 &gic 0 40 4>,
> +				<0 0 41 &gic 0 41 4>,
> +				<0 0 42 &gic 0 42 4>;
> +	};
> +};
> diff --git a/arch/arm/mach-vexpress/Makefile.boot b/arch/arm/mach-vexpress/Makefile.boot
> index 318d308..5c633c5 100644
> --- a/arch/arm/mach-vexpress/Makefile.boot
> +++ b/arch/arm/mach-vexpress/Makefile.boot
> @@ -7,4 +7,5 @@ initrd_phys-y	:= 0x60800000
>  dtb-$(CONFIG_ARCH_VEXPRESS_DT)	+= vexpress-v2p-ca5s.dtb \
>  				   vexpress-v2p-ca9.dtb \
>  				   vexpress-v2p-ca15-tc1.dtb \
> -				   vexpress-v2p-ca15_a7.dtb
> +				   vexpress-v2p-ca15_a7.dtb \
> +				   vexpress-xenvm-4.2.dtb
> 

