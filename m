Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab0HSSMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 14:12:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12624 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0HSSML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 14:12:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6079"; a="51578009"
Message-ID: <4C6D73FA.1060809@codeaurora.org>
Date: Thu, 19 Aug 2010 11:12:10 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12pre) Gecko/20100809 Shredder/3.0.7pre
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Bean <gbean@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>, gregkh@suse.de,
        magnus.damm@gmail.com, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] msm-bus: Define the msm-bus skeleton
References: <1282158943-11902-1-git-send-email-ppannuto@codeaurora.org>	<1282158943-11902-4-git-send-email-ppannuto@codeaurora.org> <AANLkTim2u7F47J5rn_SHZHWCV27Nk-j6bKoJx92dK9jH@mail.gmail.com>
In-Reply-To: <AANLkTim2u7F47J5rn_SHZHWCV27Nk-j6bKoJx92dK9jH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> QUICK COMMENT
>>
>> It is worth noting that this patch is a fairly minimal implementation,
>> that is, it does not yet have any functionality that makes it differ
>> from the platform bus - it just shows how it would be done.
> 
> Okay, so that's the core point.  without the differentiated behaviour,
> you can do exactly the same thing, with the same topology, without the
> new bus types.
> 
> So, the question remains, what is the new functionality that needs to
> be supported that platform_bus_type doesn't implement?  That is the
> example that I'm really keen to see!  :-)
> 
> Cheers,
> g.
> 

Ahhh... I was afraid you'd say that.


>> +static struct platform_device msm_apps_bus = {
>> +       .name                   = "root-fabric-apps",
>> +       .id                     = -1,
>> +};
>> +
>> +static struct platform_device msm_system_bus = {
>> +       .name                   = "root-fabric-system",
>> +       .id                     = -1,
>> +};
>> +
>> +static struct platform_device msm_mmss_bus = {
>> +       .name                   = "fabric-mmss",
>> +       .id                     = -1,
>> +};
>> +
>> +int msm_device_register(struct platform_device *pdev)
>> +{
>> +       pdev->dev.bus = &msm_bus_type;
>> +       /* XXX: Use platform_data to assign pdev->dev.parent */
>> +
>> +       device_initialize(&pdev->dev);
>> +       return __platform_device_add(pdev);
>> +}
>> +

With the understanding that I do not own the code that would be actually
doing this, hopefully some pseduo-code can help?

int msm_device_register(struct platform_device *pdev)
{
	pdev->dev.bus = &msm_bus_type;

	if (!strncmp(pdev->name, "root", strlen("root"))) {
		/* We are a root fabric (physical bus), no parent */
		pdev->dev.parent = NULL;
	}
	else {
		struct msm_dev_info* info = pdev->dev.platform_data;
		switch(info->magic) {
		case APPS_MAGIC:
			pdev->dev.parent = &msm_apps_bus;
			break;
		case SYSTEM_MAGIC:
			pdev->dev.parent = &msm_system_bus;
			break;
		case MMSS_MAGIC:
			pdev->dev.parent = &msm_mmss_bus;
			break;
		}
	}

	device_initailize(&pdev->dev);
	return __platform_device_add(pdev);
}

int msm_bus_probe(struct device* dev)
{
	int error;
	struct msm_dev_info* info = dev->platform_data;
	struct sibling_device* sib;

	list_for_each_entry(sib, &info->sib_list, list) {
		error = build_path(dev, sib->dev, sib->requirements);
		if (error)
			return error;
	}

	if (dev->driver->probe)
		error = dev->driver->probe(dev);

	return error;
}

What you see here is handling the fact that "fabrics" are actually separate
buses, so we must be intelligent in adding devices so they attach to the
right parent.  When probing devices, they may have other devices they need
to talk to, which may be on a different fabric (physical bus), so we need
to prove that we can build a path from the first device to its sibling,
meeting all of the requirements (clock speed, bandwidth, etc) along all
the physical buses along the way.


AND NOW, for a completely different argument:

If nothing else, this would greatly help to clean up the current state of
/sys on embedded devices. From my understanding, the platform bus is a
"legacy" bus, where things that have no other home go to roost. Let us
look at my dev box:

	$ ppannuto@ppannuto-linux:~$ ls /sys/bus
	acpi  i2c       mmc  pci_express  pnp   sdio   spi
	hid   mdio_bus  pci  platform     scsi  serio  usb

	ppannuto@ppannuto-linux:~$ ls /sys/bus/platform/devices/
	Fixed MDIO bus.0  i8042  pcspkr  serial8250

And now my droid:

	$ ls /sys/bus
	platform omapdss i2c spi usb mmc sdio usb-serial w1 hid

	$ ls /sys/bus/platform/devices
	power.0 ram_console.0 omap_mdm_ctrl omap2-nand.0 omapdss sfh7743
	bu52014hfv vib-gpio musb_hdrc ehci-omap.0 ohci.0 sholes_bpwake
	omap_hdq.0 wl127x-rfkill.0 wl127x-test.0 mmci-omap-hs.0 TIWLAN_SDIO.1
	omapvout pvrsrvkm omaplfb android_usb usb_mass_storage omap34xxcam
	omap2_mcspi.1 omap2_mcspi.2  omap2_mcspi.3 omap2_mcspi.4 omap-uart.1
	omap-uart.2 omap-uart.3 omap-mcbsp.1 omap-mcbsp.2 omap-mcbsp.3 omap-mcbsp.4
	omap-mcbsp.5 i2c_omap.1 i2c_omap.2 i2c_omap.3 omap_wdt omapfb cpcap-regltr.0
	cpcap-regltr.17 cpcap-regltr.1 cpcap-regltr.2 cpcap-regltr.3 cpcap-regltr.4
	cpcap-regltr.5 cpcap-regltr.6 cpcap-regltr.7 cpcap-regltr.8 cpcap-regltr.9
	cpcap-regltr.10 cpcap-regltr.11 cpcap-regltr.12 cpcap-regltr.13 cpcap-regltr.14
	cpcap-regltr.15 cpcap-regltr.16 cpcap-regltr.18 cpcap_adc cpcap_key cpcap_battery
	button-backlight notification-led keyboard-backlight flash-torch cpcap_usb
	cpcap_usb_det cpcap_audio cpcap_3mm5 cpcap_rtc cpcap_uc C6410 keyreset.0
	gpio-event.0 device_wifi.1 hp3a omap-previewer omap-resizer.2 alarm
	cpcap_usb_charger cpcap_usb_connected

	$ ls /sys/bus/omapdss/devices
	display0

	$ ls /sys/bus/w1/devices
	89-000000000000

This is a fairly ugly mess.  IMHO, it would reflect the view of the world much
better if most of that lived under /sys/bus/omap (or something similar); such a
scheme also gives omap (and msm, and others) a home for all of the custom power
code that is sure to go with their SOCs.


-Pat

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
