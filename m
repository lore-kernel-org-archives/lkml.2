Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2JaWAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:00:53 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:35049 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864Ab2JaWAv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:00:51 -0400
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20121031214310.GA15766@atomide.com>
Date: Thu, 1 Nov 2012 00:00:45 +0200
Cc: Benoit Cousson <b-cousson@ti.com>, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E08E316D-E7C5-4AFC-8C82-6423E5128FAA@antoniou-consulting.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com> <20121031175219.GH12739@atomide.com> <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com> <20121031180935.GL12739@atomide.com> <50918223.6080003@ti.com> <8AD2F7AF-8315-442B-A394-1A38DAB29F52@antoniou-consulting.com> <20121031212639.GQ12739@atomide.com> <8B058B00-6C21-4410-A24B-75651D49F6EC@antoniou-consulting.com> <20121031214310.GA15766@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Oct 31, 2012, at 11:43 PM, Tony Lindgren wrote:

> * Pantelis Antoniou <panto@antoniou-consulting.com> [121031 14:38]:
>> 
>> There a a whole bunch of conflicting capes. There's no
>> way to instantiate them together. They must be instantiated
>> only after their EEPROMs are read and they are matched
>> to their corresponding cape drivers.
> 
> You don't need to instantiate the capes during __init,
> you need to just instantiate the omap internal devices
> which are always there in the hardware. These internal
> devices just need to be set to state = "disabled" until
> they are used.
> 

If you set the device's node state to disable the device
doesn't get registered; i.e. the device's probe method will not be
called.

The devices are instantiated by the call to 

	of_platform_populate(NULL, omap_dt_match_table, NULL, NULL);

in omap_generic_init() (arch/arm/mach-omap2/board-generic.c)

Which for each child of the root node will call of_platform_bus_create
which in turn will call of_platform_device_create_pdata.

First check in there is

       if (!of_device_is_available(np))
                return NULL;
 
of_device_is_available() will return 0 in any case status is neither
"okay" or "ok".

So when device's node is 'disabled' of_platform_device_create_pdata()
will not create the device.

Now, of course it is possible to re-trigger the platform's probe method
to be called, and in fact I do so in the capebus patches.

Since the bus drives of things like i2c & spi must be disabled if not
used by any cape, they are "disabled" by default, and are activated when
referenced by a cape.

In the file drivers/capebus/capebus-driver.c, there are two functions.

The first, capebus_of_platform_device_enable() will check if the referenced
device node is disabled, and after enabling it (with capebus_of_device_node_enable())
will call of_platform_device_create(), but now this time the instantiation
will be successful.

The problem is that now, we're way past the point in the boot sequence
that omap_build_device has been freed; calling the probe method will now lead
to a crash.

> The capes themselves should not have anything to do
> with omap_hwmod or omap_device, they just contain
> external connectors, regulators, LCD panels etc.
> 
> To your capebus the omap internal devices should look
> like just regular struct device entries.
> 
> Regards,
> 
> Tony

Regards

-- Pantelis

