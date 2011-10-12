Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1JLIEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:04:06 -0400
Received: from ezo.ezono.com ([50.22.105.208]:34799 "EHLO ezo.ezono.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab1JLIEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:04:00 -0400
Message-ID: <4E9549E5.4090405@ezono.com>
Date: Wed, 12 Oct 2011 10:03:49 +0200
From: Abdelghani Ouchabane <abdelghani@ezono.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Abdelghani Ouchabane <abdelghani@ezono.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: PCIe can not rescan for new PCIe device ( FPGA board )
References: <4E8EA746.6030103@ezono.com> <CAErSpo6YEp2v9xzVJHsu5WSJDqb+sWZUfS-e7UmGEXENRiWmnQ@mail.gmail.com> <4E8F2758.3040408@ezono.com> <CAErSpo6Lo2bXw=yjscQ6zzRMnpMZ-cUzbBxN3dDS1D3M67sQ8g@mail.gmail.com> <4E93FA07.306@ezono.com> <CAErSpo7c8pgBUxLGC5rKrBbkSsf+MSGhXuEZAyrPkRj8X2YpBA@mail.gmail.com> <4E954251.5020801@ezono.com>
In-Reply-To: <4E954251.5020801@ezono.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ezo.ezono.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ezono.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/11 17:22, Bjorn Helgaas wrote:
> How did you get this read to work?  Is this in a different system?
> Maybe the difference between this working scenario and the broken
> scenario will have a clue.
Hi,

      yes, it was on a different system. I will give you more details:

   Our old systems are based on the Congatec COM Express  conga-B945 ( 
based on the Intel Mobile 945GME chipset ), and we are using a GPO line 
to control the power switch on the FPGA board that is connected using 
PCIe line 0. On the B945 this line is high by default during the boot ( 
The FPGA board gets powered while the system boots "this is the desired 
behaviour" ).

    But now we are working to use the new Congatec COM Express conga-BAF 
( based on the AMD Embedded G-Series Processors ), The GPO line is zero 
by default during the boot. So, after the system boots, we  power the 
FPGA board on, but unfortunately the system can not access the FPGA 
registers.

     We are trying to solve this issue and get the FPGA board works 
without changing the hardware.

> The BIOS left the bridge to bus 02 with all windows disabled, but 
> Linux allocated and enabled the windows as above, and we assigned BARs 
> of device 02:00.0 inside those windows. As far as I can tell, 
> everything leading to the FPGA is set up correctly. Can you try 
> another, known-working (not your FPGA), card in that slot? It still 
> looks to me like a problem with your FPGA. Bjorn 

Yes, I did the following test cases with a standard WiFi card ( Network 
controller: Ralink corp. RT2860 --- Belkin Device 817c --- Kernel 
modules: rt2800pci ):

    A - I booted the system without the express card.

            1 - Introduce the express card after the system has booted up.
            2 - lspci -vt doesn't show the express card, express card 
divers did not loaded (lsmod).
            3 - Rescan the PCIe bus "echo 1 > /sys/bus/pci/rescan"
            4 - The card gets detected (lspci), drivers get loaded 
(lsmod), But ifconfig doesn't show the interface (wlan0).
                 dmesg :
                              [  159.849763] pci 0000:01:00.0: 
[1814:0781] type 0 class 0x000280
                              [  159.849932] pci 0000:01:00.0: reg 10: 
[mem 0x00000000-0x0000ffff]
                              [  159.850220] pci 0000:01:00.0: PME# 
supported from D0 D3hot
                              [  159.850350] pci 0000:01:00.0: PME# disabled
                              [  159.850601] radeon 0000:00:01.0: BAR 6: 
[??? 0x00000000 flags 0x2] has bogus alignment
                              [  159.850787] pci 0000:01:00.0: BAR 0: 
assigned [mem 0x40400000-0x4040ffff]
                              [  159.850941] pci 0000:01:00.0: BAR 0: 
set to [mem 0x40400000-0x4040ffff] (PCI address [0x40400000-0x4040ffff])
                              [  159.879110] cfg80211: Calling CRDA to 
update world regulatory domain
                              [  159.920212] rt2800pci 0000:01:00.0: 
enabling device (0000 -> 0002)
                              [  159.920379] rt2800pci 0000:01:00.0: PCI 
INT A -> GSI 16 (level, low) -> IRQ 16
                              [  159.920551] rt2800pci 0000:01:00.0: 
setting latency timer to 64
                              [  159.930927] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  159.941346] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  159.951737] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  159.962130] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  159.972521] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  159.982907] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  159.993299] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  160.003676] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  160.014056] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  160.024447] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  160.034825] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  160.045230] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  160.055622] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  160.066014] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  160.079940] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  160.093825] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  160.107635] phy0 -> 
rt2x00pci_regbusy_read: Error - Indirect register access failed: 
offset=0x00000580, value=0xffffffff
                              [  160.111266] phy0 -> rt2800_init_eeprom: 
Error - Invalid RT chipset detected.
                              [  160.114860] phy0 -> 
rt2x00lib_probe_dev: Error - Failed to allocate device.
                              [  160.118496] rt2800pci 0000:01:00.0: PCI 
INT A disabled


    B - I booted the system with express card.

            1  - Insert the express card when the system is off.
            2  - Boot the system.
            3  - The card gets detected (lspci), drivers get loaded 
(lsmod), But ifconfig shows the interface(wlan0).


   C - I booted the system with express card then removed it then 
inserted it.

           1  - Insert the express card when the system is off.
           2  - Boot the system
           3  - The card gets detected (lspci), drivers get loaded 
(lsmod), But ifconfig shows the interface(wlan0).
           4  - Remove from pci bus "echo 1 > 
/sys/bus/pci/devices/0000\:0?\:00.0/remove" - NOTE = ? depends on the slot.
                 dmesg :
                              [   69.510267] rt2800pci 0000:01:00.0: PCI 
INT A disabled
           5  - Remove the card.
           6  - Plug the card back in.
           7  - Rescan the bus "echo 1 > /sys/bus/pci/rescan".
           8 -  The card gets detected (lspci), drivers get loaded 
(lsmod), But ifconfig shows the interface(wlan1).
                 dmesg :
                              [  208.328481] pci 0000:01:00.0: 
[1814:0781] type 0 class 0x000280
                              [  208.328658] pci 0000:01:00.0: reg 10: 
[mem 0x00000000-0x0000ffff]
                              [  208.328910] pci 0000:01:00.0: PME# 
supported from D0 D3hot
                              [  208.329068] pci 0000:01:00.0: PME# disabled
                              [  208.329328] radeon 0000:00:01.0: BAR 6: 
[??? 0x00000000 flags 0x2] has bogus alignment
                              [  208.329516] pci 0000:01:00.0: BAR 0: 
assigned [mem 0xfea00000-0xfea0ffff]
                              [  208.329671] pci 0000:01:00.0: BAR 0: 
set to [mem 0xfea00000-0xfea0ffff] (PCI address [0xfea00000-0xfea0ffff])
                              [  208.330511] rt2800pci 0000:01:00.0: 
enabling device (0000 -> 0002)
                              [  208.330665] rt2800pci 0000:01:00.0: PCI 
INT A -> GSI 16 (level, low) -> IRQ 16
                              [  208.330834] rt2800pci 0000:01:00.0: 
setting latency timer to 64
                              [  208.341348] ieee80211 phy1: Selected 
rate control algorithm 'minstrel_ht'
                              [  208.342396] Registered led device: 
rt2800pci-phy1::radio
                              [  208.342575] Registered led device: 
rt2800pci-phy1::assoc
                              [  208.342752] Registered led device: 
rt2800pci-phy1::quality
                              [  208.428306] udev[1339]: renamed network 
interface wlan0 to wlan1


As you can see that my system doesn't detect the express card in test 
case "A" and the values of registers are 0xffffffff, the same as in my 
FPGA board.

Cheers,
Ghani

