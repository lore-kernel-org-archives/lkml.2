Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2EEPSX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:18:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44111 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab2EEPSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:18:22 -0400
Message-ID: <4FA544B1.3070705@gmail.com>
Date: Sat, 05 May 2012 23:18:09 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Francois Rigaut <frigaut@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org,
        Nico Schottelius <nico-linux-20120419@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
References: <20120419163800.GB13977@schottelius.org> <CAMVeQ8r_3vuAxzbLyKoecOHOOGijUDkLfw+MK7o-WoWbuOGSrg@mail.gmail.com> <20120502163629.GE928@schottelius.org> <20120502202509.GA26798@kroah.com> <20120503065003.GB13386@schottelius.org> <CAMVeQ8qYu4bShd_+pwRv8bShhusJMDa-jjoqu7EujS4jt7RSNA@mail.gmail.com> <20120503153547.GD20334@kroah.com> <CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com> <20120503233858.GA13453@kroah.com> <4FA358ED.1080705@gmail.com> <20120504184851.GB11223@kroah.com> <CAE9FiQWuePNRWV=ncJkF57aQZ0ZT91xxZ0sZMexq8HgN9NcAfA@mail.gmail.com> <CAE9FiQWcyRfLKB+YivOfa-GydbhoaMx06n6a4VMDWoTOMkj7ig@mail.gmail.com> <4FA4AA3E.1070903@gmail.com>
In-Reply-To: <4FA4AA3E.1070903@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Francois,
	It seems that the PCI topology related to the Thunderbird is:
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port (rev 09)
	03:00.0 PCI bridge: Intel Corporation Device 151a (rev 01)
	04:00.0 PCI bridge: Intel Corporation Device 151a (rev 01)
	04:03.0 PCI bridge: Intel Corporation Device 151a (rev 01)
	04:04.0 PCI bridge: Intel Corporation Device 151a (rev 01)
		37:00.0 PCI bridge: Intel Corporation Device 1513
		38:00.0 PCI bridge: Intel Corporation Device 1513
			39:00.0 PCI bridge: Pericom Semiconductor Device 400c (rev 02)
			3a:03.0 PCI bridge: Pericom Semiconductor Device 400c (rev 02)
				3b:00.0 USB controller: Pericom Semiconductor Device 400e (rev 01)
				3b:00.1 USB controller: Pericom Semiconductor Device 400e (rev 01)
				3b:00.2 USB controller: Pericom Semiconductor Device 400f (rev 01)
		38:01.0 PCI bridge: Intel Corporation Device 1513
			3c:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM57761 Gigabit Ethernet PCIe (rev 10)
		38:02.0 PCI bridge: Intel Corporation Device 1513
			3d:00.0 FireWire (IEEE 1394): nee Agere Systems nee Lucent Microelectronics FW643 PCI Express 1394b Controller (PHY/Link) (rev 08)
		38:03.0 PCI bridge: Intel Corporation Device 1513
		38:04.0 PCI bridge: Intel Corporation Device 1513
		38:05.0 PCI bridge: Intel Corporation Device 1513

It's really a complex topology. The longest path has root port + 3 PCIe switches + endpoint.
The device with id "Intel Corporation Device 151a", "Intel Corporation Device 1513" and
"Pericom Semiconductor Device 400c" should be 3 PCIe switches. I guess the thunderbird
cable is used to connect 04:04.0 to the second PCIe switch with device ID "Intel Corporation
Device 1513". 

According to the acpidump sent out by you, I guess the relationship among PCIe and ACPI is as below:
        Device (PCI0)	// PCIe host bridge
        {
            Name (_HID, EisaId ("PNP0A08"))
            Device (P0P2)	//00:01.0
            {
                Name (_ADR, 0x00010000)
                Device (UPSB)	//03:00.0
                {
                    Name (_ADR, 0x00)
                    Device (DSB2)	//04:04.0
                    {
                        Name (_ADR, 0x00040000)
                        Method (_RMV, 0, NotSerialized)
                        {
                            Return (OSDW ()) // OSDW-> OS is Darwin
                        }
                        Device (UPS2)	//37:00.0
                        {
                            Name (_ADR, 0x00)
			}
		    }
		}
	    }
	}

But _RMV method only returns 1 on iOS or Max OS X. That means ACPI based hotplug is disabled
on Linux for your system. And as Yinghai has pointed out, all the PCIe downstream ports on 
the system don't support PCIe hotplug. So need BIOS or hardware changes to support Thunderbolt
cable hotplug on your system.

On 05/05/2012 12:19 PM, Francois Rigaut wrote:
> 
> On 05/05/12 05:38, Yinghai Lu wrote:
>> On Fri, May 4, 2012 at 12:37 PM, Yinghai Lu<yinghai@kernel.org>  wrote:
>>> On Fri, May 4, 2012 at 11:48 AM, Greg KH<gregkh@linuxfoundation.org>  wrote:
>>>> Ok, it looks like these are the devices that we are missing while
>>>> "hotplugging":
>>>> 37:00.0 PCI bridge: Intel Corporation Device 1513
>>>> 38:00.0 PCI bridge: Intel Corporation Device 1513
>>>> 38:01.0 PCI bridge: Intel Corporation Device 1513
>>>> 38:02.0 PCI bridge: Intel Corporation Device 1513
>>>> 38:03.0 PCI bridge: Intel Corporation Device 1513
>>>> 38:04.0 PCI bridge: Intel Corporation Device 1513
>>>> 38:05.0 PCI bridge: Intel Corporation Device 1513
>>>> 39:00.0 PCI bridge: Pericom Semiconductor Device 400c (rev 02)
>>>> 3a:03.0 PCI bridge: Pericom Semiconductor Device 400c (rev 02)
>>>> 3b:00.0 USB controller: Pericom Semiconductor Device 400e (rev 01)
>>>> 3b:00.1 USB controller: Pericom Semiconductor Device 400e (rev 01)
>>>> 3b:00.2 USB controller: Pericom Semiconductor Device 400f (rev 01)
>>>> 3c:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM57761 Gigabit Ethernet PCIe (rev 10)
>>>> 3d:00.0 FireWire (IEEE 1394): nee Agere Systems nee Lucent
>>>> Microelectronics FW643 PCI Express 1394b Controller (PHY/Link) (rev 08)
>>>>
>>>> Which is good, I was worried that there was a video controller out there
>>>> on the end of the thunderbolt link.
>>>>
>>>> So, the problem really is two here:
>>>>   - your video card doesn't detect the new display
>>>>   - your pci devices do not show up
>>>>
>>>> The first one probably needs to be reported to the Intel video driver
>>>> people, they can help you out the best.
> no it's definitely not the first one. As you saw, there'sa whole bunch of other devices (3 USB, firewire, network) that do not show up either.
> 
> The new info from Yinghai (thanks Yinghai) explains why hotpluging with pciehp did not work/detect the PCIE hotplug and did not result in *any* kernel messages.
> 
> So the whole thing I guess boils down to making acpiphp work. And why it outputs the "no such device" error message and does not load:
> 
> I tried with debug=1 and got a bit more info in the log files:
> 
> [root@poliahu frigaut]# lsmod | grep -e acpi -e pci
> acpi_cpufreq            5941  0
> mperf                   1275  1 acpi_cpufreq
> processor              26144  1 acpi_cpufreq
> [root@poliahu frigaut]# modprobe acpiphp debug=1
> ERROR: could not insert 'acpiphp': No such device
> 
> at this point this message showed up in everything.log:
> May  5 14:09:55 localhost kernel: [28329.700022] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> May  5 14:09:55 localhost kernel: [28329.702041] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> May  5 14:09:55 localhost kernel: [28329.702484] acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:04:00.0
> May  5 14:09:55 localhost kernel: [28329.702715] acpiphp_glue: Bus 0000:05 has 0 slots
> May  5 14:09:55 localhost kernel: [28329.702720] acpiphp_glue: Total 0 slots
> 
> then:
> [root@poliahu frigaut]# lsmod | grep -e acpi -e pci
> pci_hotplug            25324  0
> acpi_cpufreq            5941  0
> mperf                   1275  1 acpi_cpufreq
> processor              26144  1 acpi_cpufreq
> [root@poliahu frigaut]#
> 
> shows that acpiphp was indeed not loaded (I assume the error occurs after it has written out the above messages in the log file), but pci_hotplug was as a dep of acpiphp I assume (thus, correct behavior).
> 
> So we're back to the issue of the acpiphp load error.
> 
> Greg, I see you're one of the authors of acpiphp:
> #define DRIVER_VERSION    "0.5"
> #define DRIVER_AUTHOR    "Greg Kroah-Hartman <gregkh@us.ibm.com>, Takayoshi Kochi <t-kochi@bq.jp.nec.com>, Matthew Wilcox <willy@hp.com>"
> #define DRIVER_DESC    "ACPI Hot Plug PCI Controller Driver"
> 
> but that might have been a while back?
> 
> Cheers, and thanks,
> Francois
> 
> 
> 
>>>>
>>>> The second one means that something is up with the pci hotplug
>>>> controller.  I've cced the linux-pci list, the people there should be
>>>> able to help out better than I, as I no longer have any PCI hotplug
>>>> hardware to work with anymore.
>>>>
>>> those devices are under 04:04.0, but that does not have slot cap
>>> enabled by BIOS. So pciehp is going to to help.
>> should be: pciehp is not going to help.
>>
>> so acpiphp are involved?
>>
>> Yinghai
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

