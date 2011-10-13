Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab1JMMvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 08:51:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51859 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab1JMMvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 08:51:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E96DE8A.6050404@jp.fujitsu.com>
Date: Thu, 13 Oct 2011 21:50:18 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Abdelghani Ouchabane <abdelghani@ezono.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: PCIe can not rescan for new PCIe device ( FPGA board )
References: <4E8EA746.6030103@ezono.com> <CAErSpo6YEp2v9xzVJHsu5WSJDqb+sWZUfS-e7UmGEXENRiWmnQ@mail.gmail.com> <4E8F2758.3040408@ezono.com> <CAErSpo6Lo2bXw=yjscQ6zzRMnpMZ-cUzbBxN3dDS1D3M67sQ8g@mail.gmail.com> <4E939E5D.3010208@jp.fujitsu.com> <4E93FA3D.2030400@ezono.com> <4E953579.6050807@jp.fujitsu.com> <4E95516F.60300@ezono.com>
In-Reply-To: <4E95516F.60300@ezono.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the information. Though I don't have any good news for you,
I think as follows based on the info.

- There are two hot-plug capable PCIe slots on your machine.

- But, it seems you are using fakephp driver, not pciehp (is that
  correct?). The fakephp cannot handle hot-plug event such as presence
  change event on the slot. This is why the bus is not scanned automatically.

- Unfortunately, the bus would not be scanned automatically even if you
  use pciehp. As I told you in the previous email, current pciehp don't
  scan the bus automatically only if the slot is hot-plug surprise
  capable. According to the lspci output, your hotplug controller is not
  hot-plug surprise capable.

- I don't think pciehp solve invalid register read problem. According to
  the lspci output, power controller capability isn't present on your
  hotplug controller. On such environment, pciehp driver does almost the
  same thing as fakephp does (just scan the bus/remove the pci device data
  structure) except hot-plug event handling.

But it's worth whole trying pciehp.
By the way, have you tried acpiphp? It might help you.

Regards,
Kenji Kaneshige


(2011/10/12 17:35), Abdelghani Ouchabane wrote:
> On 12/10/11 08:36, Kenji Kaneshige wrote:
>> Hello,
>>
>> According to your dmesg output, pciehp driver doesn't detect any PCIe
>> hotplug slot. Can you send the following information?
>>
>>   - ls -lR /sys/bus/pci/slots
>>   - lspci -vvvv (as root user)
> 
> Hallo,
> 
> - I tested my system with:
> * A standard WiFi card (Network controller: Ralink corp. RT2860 ---
> Belkin Device 817c --- Kernel modules: rt2800pci).
> * My FPGA board.
> 
> - I did the following:
> 
> * I booted the system without the express card&  without my FPGA board.
> 1 - Introduce the express card&  my FPGA board after the system has
> booted up.
> 2 - lspci -vt doesn't show the express card&  FPGA board, express card
> divers did not loaded (lsmod).
> 3 - lspci -vt doesn't show my FPGA board.
> 4 - Rescan the PCIe bus "echo 1>  /sys/bus/pci/rescan"
> 5 - The express card gets detected (lspci), drivers get loaded (lsmod),
> But ifconfig doesn't show the interface (wlan0).
> 6 - My FPGA board gets detected (lspci), but I could not access its
> registers 0xffffffff.
> dmesg :
> [ 152.045433] pci 0000:01:00.0: [1814:0781] type 0 class 0x000280
> [ 152.045602] pci 0000:01:00.0: reg 10: [mem 0x00000000-0x0000ffff]
> [ 152.045854] pci 0000:01:00.0: PME# supported from D0 D3hot
> [ 152.045980] pci 0000:01:00.0: PME# disabled
> [ 152.046263] radeon 0000:00:01.0: BAR 6: [??? 0x00000000 flags 0x2] has
> bogus alignment
> [ 152.046452] pci 0000:01:00.0: BAR 0: assigned [mem 0x40400000-0x4040ffff]
> [ 152.046606] pci 0000:01:00.0: BAR 0: set to [mem
> 0x40400000-0x4040ffff] (PCI address [0x40400000-0x4040ffff])
> [ 152.075665] cfg80211: Calling CRDA to update world regulatory domain
> [ 152.116429] rt2800pci 0000:01:00.0: enabling device (0000 ->  0002)
> [ 152.116598] rt2800pci 0000:01:00.0: PCI INT A ->  GSI 16 (level, low)
> ->  IRQ 16
> [ 152.116770] rt2800pci 0000:01:00.0: setting latency timer to 64
> [ 152.127146] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.137537] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.147926] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.158332] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.168723] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.179115] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.189489] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.199864] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.210256] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.220634] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.231088] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.241463] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.251865] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.262270] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.276185] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.290055] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.303865] phy0 ->  rt2x00pci_regbusy_read: Error - Indirect register
> access failed: offset=0x00000580, value=0xffffffff
> [ 152.307477] phy0 ->  rt2800_init_eeprom: Error - Invalid RT chipset
> detected.
> [ 152.311073] phy0 ->  rt2x00lib_probe_dev: Error - Failed to allocate
> device.
> [ 152.314700] rt2800pci 0000:01:00.0: PCI INT A disabled
> [ 172.830318] pci 0000:02:00.0: [1234:0002] type 0 class 0x001180
> [ 172.833754] pci 0000:02:00.0: reg 10: [mem 0x00000000-0x00000fff 64bit
> pref]
> [ 172.837127] pci 0000:02:00.0: reg 18: [mem 0x00000000-0x0003ffff 64bit
> pref]
> [ 172.840456] pci 0000:02:00.0: reg 20: [mem 0x00000000-0x00000fff 64bit
> pref]
> [ 172.843964] radeon 0000:00:01.0: BAR 6: [??? 0x00000000 flags 0x2] has
> bogus alignment
> [ 172.847331] pci 0000:02:00.0: BAR 2: assigned [mem
> 0x40200000-0x4023ffff 64bit pref]
> [ 172.850728] pci 0000:02:00.0: BAR 2: set to [mem 0x40200000-0x4023ffff
> 64bit pref] (PCI address [0x40200000-0x4023ffff])
> [ 172.854231] pci 0000:02:00.0: BAR 0: assigned [mem
> 0x40240000-0x40240fff 64bit pref]
> [ 172.857771] pci 0000:02:00.0: BAR 0: set to [mem 0x40240000-0x40240fff
> 64bit pref] (PCI address [0x40240000-0x40240fff])
> [ 172.861339] pci 0000:02:00.0: BAR 4: assigned [mem
> 0x40241000-0x40241fff 64bit pref]
> [ 172.864997] pci 0000:02:00.0: BAR 4: set to [mem 0x40241000-0x40241fff
> 64bit pref] (PCI address [0x40241000-0x40241fff])
> 
> 
> 7 - Reset the express card "echo 1>
> /sys/bus/pci/devices/0000\:01\:00.0/reset". But ifconfig still doesn't
> show the interface (wlan0)
> dmesg :
> [ 731.717117] pci 0000:01:00.0: restoring config space at offset 0x1
> (was 0x100400, writing 0x100002)
> 
> 8 - Reset my FPGA board "echo 1>
> /sys/bus/pci/devices/0000\:02\:00.0/reset". Still I could not access
> into my FPGA registers.
> logs :
> [root@localhost ~]# echo 1>  /sys/bus/pci/devices/0000\:02\:00.0/reset
> -bash: echo: write error: Invalid argument
> dmesg :
> [ 910.928564] pci 0000:02:00.0: restoring config space at offset 0x1
> (was 0x100400, writing 0x100000)
> 
> 
> * I have attached to you the requested information.
> 
> Many thanks,
> Ghani
> 
> 

