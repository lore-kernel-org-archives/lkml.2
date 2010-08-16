Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0HPCAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 22:00:16 -0400
Received: from blv-smtpout-01.boeing.com ([130.76.32.69]:43259 "EHLO
	blv-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab0HPCAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 22:00:14 -0400
X-Greylist: delayed 1254 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Aug 2010 22:00:12 EDT
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: Patrick Pannuto <ppannuto@codeaurora.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "gregkh@suse.de" <gregkh@suse.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Miao <eric.y.miao@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kyle D Moffett <kyle@moffetthome.net>
Date: Sun, 15 Aug 2010 20:38:10 -0500
Subject: Re: [PATCH 2/2] platform: Facilitate the creation of
 pseudo-platform buses
Thread-Topic: [PATCH 2/2] platform: Facilitate the creation of
 pseudo-platform buses
Thread-Index: Acs847ZNDcrwxKLyQDW5aAzTzqP2iA==
Message-ID: <3F978429-F916-42E5-8B36-6AC02DAC8CA2@boeing.com>
References: <1281484174-32174-1-git-send-email-ppannuto@codeaurora.org>
 <1281484174-32174-3-git-send-email-ppannuto@codeaurora.org>
In-Reply-To: <1281484174-32174-3-git-send-email-ppannuto@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 10, 2010, at 19:49, Patrick Pannuto wrote:
> As SOCs become more popular, the desire to quickly define a simple,
> but functional, bus type with only a few unique properties becomes
> desirable. As they become more complicated, the ability to nest these
> simple busses and otherwise orchestrate them to match the actual
> topology also becomes desirable.
> 
> EXAMPLE USAGE
> 
> /arch/ARCH/MY_ARCH/my_bus.c:
> 
> 	#include <linux/device.h>
> 	#include <linux/platform_device.h>
> 
> 	struct bus_type SOC_bus_type = {
> 		.name = "SOC-bus-type",
> 	};
> 	EXPORT_SYMBOL_GPL(SOC_bus_type);
> 
> 	struct platform_device SOC_bus1 = {
> 		.name	 = "SOC-bus1",
> 		.id		= -1,
> 		.dev.bus = &SOC_bus_type;
> 	};
> 	EXPORT_SYMBOL_GPL(SOC_bus1);
> 
> 	struct platform_device SOC_bus2 = {
> 		.name	 = "SOC-bus2",
> 		.id		= -2,
> 		.dev.bus = &SOC_bus_type;
> 	};
> 	EXPORT_SYMBOL_GPL(SOC_bus2);
> 
> 	static int __init SOC_bus_init(void)
> 	{
> 		int error;
> 
> 		error = pseudo_platform_bus_register(&SOC_bus_type);
> 		if (error)
> 			return error;
> 
> 		error = platform_device_register(&SOC_bus1);
> 		if (error)
> 			goto fail_bus1;
> 
> 		error = platform_device_register(&SOC_bus2);
> 		if (error)
> 			goto fail_bus2;
> 
> 		return error;
> 
> 		/* platform_device_unregister(&SOC_bus2); */
> fail_bus2:
> 		platform_device_unregister(&SOC_bus1);
> fail_bus1:
> 		pseudo_platform_bus_unregister(&SOC_bus_type);
> 
> 		return error;
> 	}
> 
> /drivers/my_driver.c:
> 	static struct platform_driver my_driver = {
> 		.driver = {
> 			.name	= "my-driver",
> 			.owner	= THIS_MODULE,
> 			.bus	= &SOC_bus_type,
> 		},
> 	};
> 
> /somewhere/my_device.c:
> 	static struct platform_device my_device = {
> 		.name		= "my-device",
> 		.id		= -1,
> 		.dev.bus	= &my_bus_type,
> 		.dev.parent	= &SOC_bus1.dev,
> 	};
> 
> This will build a device tree that mirrors the actual system:
> 
> /sys/bus
> |-- SOC-bus-type
> |   |-- devices
> |   |   |-- SOC_bus1 -> ../../../devices/SOC_bus1
> |   |   |-- SOC_bus2 -> ../../../devices/SOC_bus2
> |   |   |-- my-device -> ../../../devices/SOC_bus1/my-device
> |   |-- drivers
> |   |   |-- my-driver
> 
> /sys/devices
> |-- SOC_bus1
> |   |-- my-device
> |-- SOC_bus2
> 
> Driver can drive any device on the SOC, which is logical, without
> actually being registered on multiple /bus_types/, even though the
> devices may be on different /physical buses/ (which are actually
> just devices).

Hmm...

To me this seems like a really painful implementation of what the OpenFirmware-esque "Flattened Device Tree" does on many embedded systems.

For example, to build an equivalent device tree using an OpenFirmware FDT file, I'd just use this:

/dts-v1/;
/ {
	#address-cells = <1>;
	#size-cells = <1>;
	[...snip...]

	soc-bus-1@fc000000 {
		/* of_platform driver matches against this: */
		compatible = "my-company-name,soc-bus-type";

		/* Define base address and size of the bus */
		reg = <0xfc000000 0x01000000>;
		#address-cells = <1>;
		#size-cells = <1>;

		/* 
		 * Define logical memory mapping relative to the bus addr:
		 * First field is the relative base address for children,
		 * second field is the address in the parent's memory map,
		 * third field is the size of the range.
		 */
		ranges = <0x0 0xfc000000 0x01000000>;

		/* Now for sub-devices */
		my-device@0x10000 {
			compatible = "my-company-name,my-driver";
			reg = <0x10000 0x100>; /* Address and size */
		};
	};

	soc-bus-2@fd000000 {
		/* of_platform driver matches against this: */
		compatible = "my-company-name,soc-bus-type";

		/* Define base address and size of the bus */
		reg = <0xfd000000 0x01000000>;
		#address-cells = <1>;
		#size-cells = <1>;

		/* 
		 * Define logical memory mapping relative to the bus addr:
		 * First field is the relative base address for children,
		 * second field is the address in the parent's memory map,
		 * third field is the size of the range.
		 */
		ranges = <0x0 0xfd000000 0x01000000>;
	};
};

If you don't need to actually do anything special at the bus level, you can just:
	static struct of_device_id soc_bus_ids[] = {
		{ .compatible = "soc-bus-type", },
		{},
	};
	of_platform_bus_probe(NULL, &soc_bus_ids, NULL);

Any of_platform driver that matches something on one of those busses is automatically probed.  Alternatively, if you need special bus behavior:
	static struct of_device_id soc_bus_ids[] = {
		{ .compatible = "soc-bus-type", },
		{},
	};
	static struct of_platform_driver soc_bus_type = {
		.name = "soc-bus-type",
		.match_table = &soc_bus_ids,
		.owner = THIS_MODULE,
		.probe = mybus_probe,
		.remove = mybus_remove,
		.suspend = mybus_suspend,
		.resume = mybus_resume,
		.shutdown = mybus_shutdown,
	};

Then your .probe function actually registers a new OF bus.

The best part is... all devices registered as "of_platform" devices can be used to support many entirely different board models from the exact same kernel.

Fully commented and with actual physical addresses in, my FDT example is comparable to your sample code.  Furthermore, all of the error handling is automatically done, a bunch of device drivers are already ported over, and all the kinks regarding interrupts, etc are already taken care of.  I highly recommend taking a look to see if you can use the very nice existing OF bus code to solve your problem instead of writing yet another half-hard-coded platform bus type.

Cheers,
Kyle Moffett

