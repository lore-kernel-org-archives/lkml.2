Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0HSVcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:32:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53696 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0HSVcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <4C6D73FA.1060809@codeaurora.org>
References: <1282158943-11902-1-git-send-email-ppannuto@codeaurora.org>
 <1282158943-11902-4-git-send-email-ppannuto@codeaurora.org>
 <AANLkTim2u7F47J5rn_SHZHWCV27Nk-j6bKoJx92dK9jH@mail.gmail.com> <4C6D73FA.1060809@codeaurora.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 19 Aug 2010 15:31:40 -0600
X-Google-Sender-Auth: d2DwtzksOgnCd_z69wPnUZE1TcQ
Message-ID: <AANLkTikFZaDj+etALT0nv9fM5XkH8aA6B=98DJ0k7uDm@mail.gmail.com>
Subject: Re: [PATCH 3/4] msm-bus: Define the msm-bus skeleton
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Bean <gbean@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>, gregkh@suse.de,
        magnus.damm@gmail.com, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 12:12 PM, Patrick Pannuto
<ppannuto@codeaurora.org> wrote:
>>> QUICK COMMENT
>>>
>>> It is worth noting that this patch is a fairly minimal implementation,
>>> that is, it does not yet have any functionality that makes it differ
>>> from the platform bus - it just shows how it would be done.
>>
>> Okay, so that's the core point.  without the differentiated behaviour,
>> you can do exactly the same thing, with the same topology, without the
>> new bus types.
>>
>> So, the question remains, what is the new functionality that needs to
>> be supported that platform_bus_type doesn't implement?  That is the
>> example that I'm really keen to see!  :-)
>>
>> Cheers,
>> g.
>>
>
> Ahhh... I was afraid you'd say that.

:-)  Hi Patrick.

>>> +static struct platform_device msm_apps_bus = {
>>> +       .name                   = "root-fabric-apps",
>>> +       .id                     = -1,
>>> +};
>>> +
>>> +static struct platform_device msm_system_bus = {
>>> +       .name                   = "root-fabric-system",
>>> +       .id                     = -1,
>>> +};
>>> +
>>> +static struct platform_device msm_mmss_bus = {
>>> +       .name                   = "fabric-mmss",
>>> +       .id                     = -1,
>>> +};
>>> +
>>> +int msm_device_register(struct platform_device *pdev)
>>> +{
>>> +       pdev->dev.bus = &msm_bus_type;
>>> +       /* XXX: Use platform_data to assign pdev->dev.parent */
>>> +
>>> +       device_initialize(&pdev->dev);
>>> +       return __platform_device_add(pdev);
>>> +}
>>> +
>
> With the understanding that I do not own the code that would be actually
> doing this, hopefully some pseduo-code can help?
>
> int msm_device_register(struct platform_device *pdev)
> {
>        pdev->dev.bus = &msm_bus_type;
>
>        if (!strncmp(pdev->name, "root", strlen("root"))) {
>                /* We are a root fabric (physical bus), no parent */
>                pdev->dev.parent = NULL;

Parent is null by default.

>        }
>        else {
>                struct msm_dev_info* info = pdev->dev.platform_data;
>                switch(info->magic) {
>                case APPS_MAGIC:
>                        pdev->dev.parent = &msm_apps_bus;
>                        break;
>                case SYSTEM_MAGIC:
>                        pdev->dev.parent = &msm_system_bus;
>                        break;
>                case MMSS_MAGIC:
>                        pdev->dev.parent = &msm_mmss_bus;
>                        break;
>                }
>        }
>
>        device_initailize(&pdev->dev);
>        return __platform_device_add(pdev);
> }

Yikes, don't do this.  The parent bus information can be statically
assigned to the devices definitions themselves (see example at end of
email).  Doing it in code is opaque and too complex.

> int msm_bus_probe(struct device* dev)
> {
>        int error;
>        struct msm_dev_info* info = dev->platform_data;
>        struct sibling_device* sib;
>
>        list_for_each_entry(sib, &info->sib_list, list) {
>                error = build_path(dev, sib->dev, sib->requirements);
>                if (error)
>                        return error;
>        }
>
>        if (dev->driver->probe)
>                error = dev->driver->probe(dev);
>
>        return error;
> }
>
> What you see here is handling the fact that "fabrics" are actually separate
> buses, so we must be intelligent in adding devices so they attach to the
> right parent.  When probing devices, they may have other devices they need
> to talk to, which may be on a different fabric (physical bus), so we need
> to prove that we can build a path from the first device to its sibling,
> meeting all of the requirements (clock speed, bandwidth, etc) along all
> the physical buses along the way.

Proving a path is a valid concern, but from what I see it should
already be supported with the existing platform_bus_type.

On the probing point, I agree.  There are many cases of device
initialization order dependencies which the kernel does not currently
explicitly enforce.  In a lot of cases it happens to work "just by
luck" (but not entirely luck, because the order things get initialized
in rarely changes).  I've been playing with using bus notifiers to
postpone initialization when a dependant device hasn't yet been
initialized.  But that is a problem regardless of bus type (for
example, I had an Ethernet platform_device that needed to wait for an
mdio_device to show up).

> AND NOW, for a completely different argument:
>
> If nothing else, this would greatly help to clean up the current state of
> /sys on embedded devices. From my understanding, the platform bus is a
> "legacy" bus, where things that have no other home go to roost. Let us
> look at my dev box:

Not entirely true.  That was the case originally, but now it also
means (especially in embedded) simple memory mapped devices that must
be explicitly instantiated because the hardware is not able to probe
for them.

>
>        $ ppannuto@ppannuto-linux:~$ ls /sys/bus
>        acpi  i2c       mmc  pci_express  pnp   sdio   spi
>        hid   mdio_bus  pci  platform     scsi  serio  usb
>
>        ppannuto@ppannuto-linux:~$ ls /sys/bus/platform/devices/
>        Fixed MDIO bus.0  i8042  pcspkr  serial8250
>
> And now my droid:
>
>        $ ls /sys/bus
>        platform omapdss i2c spi usb mmc sdio usb-serial w1 hid
>
>        $ ls /sys/bus/platform/devices
>        power.0 ram_console.0 omap_mdm_ctrl omap2-nand.0 omapdss sfh7743
>        bu52014hfv vib-gpio musb_hdrc ehci-omap.0 ohci.0 sholes_bpwake
>        omap_hdq.0 wl127x-rfkill.0 wl127x-test.0 mmci-omap-hs.0 TIWLAN_SDIO.1
>        omapvout pvrsrvkm omaplfb android_usb usb_mass_storage omap34xxcam
>        omap2_mcspi.1 omap2_mcspi.2  omap2_mcspi.3 omap2_mcspi.4 omap-uart.1
>        omap-uart.2 omap-uart.3 omap-mcbsp.1 omap-mcbsp.2 omap-mcbsp.3 omap-mcbsp.4
>        omap-mcbsp.5 i2c_omap.1 i2c_omap.2 i2c_omap.3 omap_wdt omapfb cpcap-regltr.0
>        cpcap-regltr.17 cpcap-regltr.1 cpcap-regltr.2 cpcap-regltr.3 cpcap-regltr.4
>        cpcap-regltr.5 cpcap-regltr.6 cpcap-regltr.7 cpcap-regltr.8 cpcap-regltr.9
>        cpcap-regltr.10 cpcap-regltr.11 cpcap-regltr.12 cpcap-regltr.13 cpcap-regltr.14
>        cpcap-regltr.15 cpcap-regltr.16 cpcap-regltr.18 cpcap_adc cpcap_key cpcap_battery
>        button-backlight notification-led keyboard-backlight flash-torch cpcap_usb
>        cpcap_usb_det cpcap_audio cpcap_3mm5 cpcap_rtc cpcap_uc C6410 keyreset.0
>        gpio-event.0 device_wifi.1 hp3a omap-previewer omap-resizer.2 alarm
>        cpcap_usb_charger cpcap_usb_connected

You're looking in the wrong place.  Look in /sys/devices/platform
instead.  /sys/bus/*/devices shows the bus /type/ attachment, not the
physical bus attachement.

To rehash:

/sys/bus - shows the bus types and the devices registered against them
*as symlinks* to the device's sysfs directory
/sys/devices - shows the actual topology from the Linux point of view.

To illustrate, look at /sys/bus/pci_express/devices on a PC:

$ ls -l /sys/bus/pci_express/devices
0000:00:1c.0:pcie01 ->
../../../devices/pci0000:00/0000:00:1c.0/0000:00:1c.0:pcie01
0000:00:1c.0:pcie04 ->
../../../devices/pci0000:00/0000:00:1c.0/0000:00:1c.0:pcie04
0000:00:1c.0:pcie08 ->
../../../devices/pci0000:00/0000:00:1c.0/0000:00:1c.0:pcie08
0000:00:1c.1:pcie01 ->
../../../devices/pci0000:00/0000:00:1c.1/0000:00:1c.1:pcie01
0000:00:1c.1:pcie04 ->
../../../devices/pci0000:00/0000:00:1c.1/0000:00:1c.1:pcie04
0000:00:1c.1:pcie08 ->
../../../devices/pci0000:00/0000:00:1c.1/0000:00:1c.1:pcie08

See?  The pci_express devices actually live in /sys/devices, and on 2
separate physical busses; 0000:00:1c.0 and 0000:00:1c.1

That being said, /sys/devices/platform on your phone probably looks
identical because everything is registered without setting the parent
pointer.  However, it isn't always that way... (see below).

> This is a fairly ugly mess.  IMHO, it would reflect the view of the world much
> better if most of that lived under /sys/bus/omap (or something similar); such a
> scheme also gives omap (and msm, and others) a home for all of the custom power
> code that is sure to go with their SOCs.

This is the topology argument, which I agree is desirable to represent
accurately for several reasons, but in this case it has nothing to do
with the bus_type.  For example, take a look at my mpc5200 board:

$ ls /sys/bus/platform
f0000000.soc5200	       f0000670.timer		f0002000.serial
f0000200.cdm		       f0000800.rtc		f0003000.ethernet
f0000500.interrupt-controller  f0000900.can		f0003000.mdio
f0000600.timer		       f0000980.can		f0003a00.ata
f0000610.timer		       f0000b00.gpio		f0003d00.i2c
f0000620.timer		       f0000c00.gpio		f0003d40.i2c
f0000630.timer		       f0000f00.spi		f0008000.sram
f0000640.timer		       f0001000.usb		fe000000.flash
f0000650.timer		       f0001200.dma-controller	localbus.0
f0000660.timer		       f0001f00.xlb

$ ls /sys/devices/platform
power  uevent

Lots of platform devices, but none of them live in
/sys/devices/platform.  So, what's going on here?  Well, on powerpc
the platform device topology matches the device initialization data
which already organizes the devices based on the physical bus
attachment.  You can see this by looking where the symlinks in
/sys/bus/platform/devices point to:

$ ls -l /sys/bus/platform/devices
f0000000.soc5200 -> ../../../devices/f0000000.soc5200
f0000200.cdm -> ../../../devices/f0000000.soc5200/f0000200.cdm
[... trimmed for brevity ...]
f0003d40.i2c -> ../../../devices/f0000000.soc5200/f0003d40.i2c
f0008000.sram -> ../../../devices/f0000000.soc5200/f0008000.sram
fe000000.flash -> ../../../devices/localbus.0/fe000000.flash
localbus.0 -> ../../../devices/localbus.0

Most devices are children of the "f0000000.soc5200" physical bus, and
the flash device is a child of the external "localbus.0".  You'll also
notice that both f0000000.soc5200 and localbus.0 are also platform
devices on their own.

So, the topology issue can be solved right now without any regard to
the bus_type.  Also, the converse is true.  New bus_types can be added
to handle different behaviour without changing the existing topology.
Following the topology argument muddies the issue of whether or not
inheriting new bus types from plaform_bus_type is a good idea.

Try this: on one of you msm boards create a new static struct device
or struct platform_device, make sure it gets registered before the
other devices, set the .dev.parent pointer in all the msm_device_uart
platform_devices to point to it.  For example:

struct platform_device msm_bus = {
	.name = "msm_sample_bus",
};

struct platform_device msm_device_uart1 = {
	.name = "msm_serial",
	.id = 1,
	.num_resources = ARRAY_SIZE(resource_uart3),
	.resource = resources_uart3,
	.dev = {
		.parent = &msm_bus.dev,
	},
};

Then look at the effect on the system.  Data like topology can and
should be defined in a static manor; either like the above, or as I
prefer, in a flattened device tree file.

Hmmm, I've written a lot.  I should summarize.  On the topology front,
it is a separate issue, and can be solved right now without a new bus
type.

On the new bus_type front, I'm still not convinced.  However,
supporting PM operations is the most likely line of argument that
would sway me.  I've got to reply to Kevin's email and I'll elaborate
there.  I'm particularly concerned about the concept of sharing device
driver instances between bus_types.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
