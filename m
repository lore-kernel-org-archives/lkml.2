Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3AGNLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:11:00 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:43384 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3AGNK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:10:58 -0500
Message-ID: <50EAC955.6010109@synopsys.com>
Date: Mon, 7 Jan 2013 18:40:45 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Grant Likely <grant.likely@secretlab.ca>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 25/31] ARC: [plat-arcfpga] Hooking up platform
 to ARC UART
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-26-git-send-email-vgupta@synopsys.com> <201211071416.08012.arnd@arndb.de>
In-Reply-To: <201211071416.08012.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2012 07:46 PM, Arnd Bergmann wrote:
> On Wednesday 07 November 2012, Vineet Gupta wrote:
>> +static struct platform_device arc_uart##n##_dev = {    \
>> +       .name = "arc-uart",                             \
>> +       .id = n,                                        \
>> +       .num_resources = ARRAY_SIZE(arc_uart##n##_res), \
>> +       .resource = arc_uart##n##_res,                  \
>> +       .dev = {                                        \
>> +               .platform_data = &arc_uart_info,        \
>> +       },                                              \
>> +}
>> +
>> +ARC_UART_DEV(0);
>> +#if CONFIG_SERIAL_ARC_NR_PORTS > 1
>> +ARC_UART_DEV(1);
>> +#endif
>> +
>> +static struct platform_device *fpga_early_devs[] __initdata = {
>> +#if defined(CONFIG_SERIAL_ARC_CONSOLE)
>> +       &arc_uart0_dev,
>> +#endif
>> +};
> 
> statically defining platform devices like this is considered very
> bad style, especially since it prevents you from doing proper
> boot-time configuration. Please get the available devices from
> the boot loader. Normally this is done using a flattened device
> tree blob that gets passed, unless you can probe the hardware
> directly.
> 
> 	Arnd
> 

I have a first pass at device tree implementation: extracting plat-clk and
sdram-size as runtime values was relatively easy. However adding arc-uart device
is turning out to be non-trivial and I'm hitting a bunch of blockers which I hope
you and/or Grant will help me with. Please rest assured that I'm only seeking help
after enough grepping and debuggign this for whole day (with -DDEBUG) in much of
device model code.

I used following as refs:
[1] http://www.devicetree.org/Device_Tree_Usage
[2] Documentation/devicetrre/usage_model.txt
[3] metag's implementation which helped to some extent.
[4] drivers/tty/serial/arc_uart.c (merged in 3.8)
[5] lots and lots of grep in arch/*

I have a very minimal device tree file for Angel4 board with just arc-uart device.

---------------------->8--------------------------------
/ {
	compatible = "snps,angel4";
	clock-frequency = <80000000>;	/* 80 MHZ */
	#address-cells = <1>;
	#size-cells = <1>;

	chosen {
		bootargs = "console=ttyARC0,115200n8";
	};

	cpus {
		#address-cells = <1>;
		#size-cells = <0>;

		cpu@0 {
			device_type = "cpu";
			compatible = "snps,arc770d";
			reg = <0>;
		};
	};

	memory {
		device_type = "memory";
		reg = <0x00000000 0x20000000>;	/* 512M */
	};

	fpga {
		compatible = "simple-bus";
		#address-cells = <1>;
		#size-cells = <1>;
		ranges;

		serial@c0fc1000 {
			compatible = "snps,arc-uart";
			reg = <0xc0fc1000 0x100>;
			interrupts = <5>;
			status = "okay";
		};
	};
};
---------------------->8--------------------------------

(1) Although I don't need the container "fpga" I'm forced to - because
of_platform_populate( ) -> of_match_node( ) expects the @match arg to be NOT NULL.
So we pass of_default_bus_match_table and have the compat string "simple-bus" in
the container. Per [1] it seemed it was possible to add the serial device directly
w/o the container.

(2) I need the following OF_DEV_AUXDATA to be able to "name" the device correctly
so that the registered driver [4] can bind with device. How do I match the driver
and devicetree node w/o this glue - it seems compatible="<manuf>,<model>" is not
enough. This also requires the uart base address to be specified (otherwise
of_dev_lookup() fails to identify the auxdata) which IMHO defeats the purpose of
devicetree in first place.

static struct of_dev_auxdata arcuart_auxdata_lookup[] __initdata = {
	OF_DEV_AUXDATA("snps,arc-uart", UART0_BASE, "arc-uart", arc_uart_info),
	{}
};

(3) After above, driver's probe routine is getting called with platform_device->id
= -1 and it seems of_device_add() is doing that purposely. How do I handle that.

(4) Is above standalone "interrupts" string OK, or do I have to explicitly
instantiate the in-core intc as well. Since it is integral part of cpu, I really
don't need any support code to explicitly instantiate it. Also it is not accessed
via mem map - but special ARC instructions in aux address space of cpu.

TIA,
-Vineet
