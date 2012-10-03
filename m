Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2JCGyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:54:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56748 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2JCGyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:54:06 -0400
Message-ID: <506BE109.6040200@numascale-asia.com>
Date: Wed, 03 Oct 2012 14:54:01 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH] Prevent AMD MCE oops on multi-server system
References: <1349073725-14093-1-git-send-email-daniel@numascale-asia.com> <20121001100650.GB4795@aftab.osrc.amd.com> <5069C0EF.1050204@numascale-asia.com> <20121001180131.GU5410@aftab.osrc.amd.com>
In-Reply-To: <20121001180131.GU5410@aftab.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 02:01, Borislav Petkov wrote:
> On Tue, Oct 02, 2012 at 12:12:31AM +0800, Daniel J Blueman wrote:
>> On 01/10/2012 18:06, Borislav Petkov wrote:
>>> On Mon, Oct 01, 2012 at 02:42:05PM +0800, Daniel J Blueman wrote:
>>>> When booting on a federated multi-server system, the processor Northbridge
>>>> lookup returns NULL; add guards to prevent this causing an oops.
>>> Interesting.
>>>
>>> What does lspci say on those systems?
>>>
>>> Thanks.
>> As NumaConnect remote-server I/O is in a pre-release stage, we only
>> expose I/O on the first (root) server, so the lspci on eg my three
>> server, single-socket C32 development system is uninteresting [1].
>
> Yeah, I was looking for the NB devices:
>
>> 00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
>> 00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Address Map
>> 00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
>> 00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
>> 00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Link Control
>
> [ … ]
>
>> We map MMCONFIG addresses in the global address map to the
>> respective server, which is how we access the processor Northbridges
>> in the bootloader before Linux loads, so they are accessible and get
>> enumerated when we enable remote I/O with the ACPI SSDT we generate,
>> however since the AMD APIC IDs (hence NB IDs) are only 8-bit, the
>> present amd_get_nb_id will produce duplicate NB IDs at best (but in
>> this case, as we disable I/O routing, there is no structure); later,
>> we may propose to using eg bits 23:8 for the server ID. That's
>> another discussion though.
>
> Ah yes, I remember now. We had this discussion already, AFAIR. So if you
> say you disable I/O routing, what actually doesn't work out as expected
> is the NB enumeration in amd_nb.c where pci_get_device simply fails?
>
> Because if you had duplicate APIC IDs, you'd atleast get some NB
> descriptor, even if not the correct one?

With remote-I/O disabled, since only the first PCI domain has been 
enumerated, the array of Northbridge IDs has structures only for the 
root (first) server's northbridges, thus the lookup returns NULL for 
later ones.

Yes, we see the duplicates with remote I/O enabled [1, 2], stemming from 
amd64_edac.h:

static inline u8 get_node_id(struct pci_dev *pdev)
{
	return PCI_SLOT(pdev->devfn) - 0x18;
}

How about a patch that would add the PCI domain eg in bits 8 and up?

>> The minimal patch at least corrects the oops regression which didn't
>> happen in earlier kernels.
>
> Right, I beefed it up a bit and added a stable tag, pls take a look and
> let me know if it is ok. I'll run it on a couple of machines but I don't
> expect any issues so I'll send it upstream soon.

Looks good!

Thanks Boris,
    Daniel

--- [1]

EDAC MC: Ver: 3.0.0
AMD64 EDAC driver v3.4.0
EDAC amd64: DRAM ECC enabled.
EDAC amd64: F10h detected (node 0).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2:   0MB 3:   0MB
EDAC amd64: MC: 4: 2048MB 5: 2048MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2:   0MB 3:   0MB
EDAC amd64: MC: 4: 2048MB 5: 2048MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC amd64: using x4 syndromes.
EDAC amd64: MCT channel count: 2
EDAC amd64: CS4: Unbuffered DDR3 RAM
EDAC amd64: CS5: Unbuffered DDR3 RAM
EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
EDAC amd64: DRAM ECC enabled.
EDAC amd64: F10h detected (node 0).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2:   0MB 3:   0MB
EDAC amd64: MC: 4: 2048MB 5: 2048MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2:   0MB 3:   0MB
EDAC amd64: MC: 4: 2048MB 5: 2048MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC amd64: using x4 syndromes.
EDAC amd64: MCT channel count: 2
EDAC amd64: CS4: Unbuffered DDR3 RAM
EDAC amd64: CS5: Unbuffered DDR3 RAM
EDAC MC: bug in low-level driver: attempt to assign
   duplicate mc_idx 0 in add_mc_to_global_list()
EDAC amd64: Error probing instance: 0
EDAC amd64: DRAM ECC enabled.
EDAC amd64: F10h detected (node 0).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2:   0MB 3:   0MB
EDAC amd64: MC: 4: 2048MB 5: 2048MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:   0MB 1:   0MB
EDAC amd64: MC: 2:   0MB 3:   0MB
EDAC amd64: MC: 4: 2048MB 5: 2048MB
EDAC amd64: MC: 6:   0MB 7:   0MB
EDAC amd64: using x4 syndromes.
EDAC amd64: MCT channel count: 2
EDAC amd64: CS4: Unbuffered DDR3 RAM
EDAC amd64: CS5: Unbuffered DDR3 RAM
EDAC MC: bug in low-level driver: attempt to assign
   duplicate mc_idx 0 in add_mc_to_global_list()
EDAC amd64: Error probing instance: 0
EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI 
controller': DEV '0000:00:18.2' (POLLED)

--- [2]

0000:00:00.0 Host bridge: ATI Technologies Inc RD890 Northbridge only 
dual slot (2x16) PCI-e GFX Hydra part (rev 02)
0000:00:00.2 Generic system peripheral [0806]: ATI Technologies Inc 
Device 5a23
0000:00:02.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge 
(PCI express gpp port B)
0000:00:04.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge 
(PCI express gpp port D)
0000:00:05.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge 
(PCI express gpp port E)
0000:00:06.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge 
(PCI express gpp port F)
0000:00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA 
Controller [AHCI mode]
0000:00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller
0000:00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
0000:00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI 
Controller
0000:00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller
0000:00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
0000:00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI 
Controller
0000:00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3d)
0000:00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
0000:00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
0000:00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host 
controller
0000:00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
0000:00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 
Controller
0000:00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor HyperTransport Configuration
0000:00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor Address Map
0000:00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor DRAM Controller
0000:00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor Miscellaneous Control
0000:00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor Link Control
0000:00:19.0 Host bridge: Device 1b47:0601 (rev 02)
0000:00:19.1 Host bridge: Device 1b47:0602 (rev 02)
0000:01:00.0 VGA compatible controller: ATI Technologies Inc Device 68ba
0000:01:00.1 Audio device: ATI Technologies Inc Juniper HDMI Audio 
[Radeon HD 5700 Series]
0000:02:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host 
Controller (rev 03)
0000:03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit 
Network Connection
0000:04:00.0 Ethernet controller: Intel Corporation 82574L Gigabit 
Network Connection
0000:05:06.0 VGA compatible controller: ASPEED Technology, Inc. ASPEED 
Graphics Family (rev 10)
0001:00:00.0 Host bridge: ATI Technologies Inc RD890 Northbridge only 
dual slot (2x16) PCI-e GFX Hydra part (rev 02)
0001:00:04.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge 
(PCI express gpp port D)
0001:00:05.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge 
(PCI express gpp port E)
0001:00:06.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge 
(PCI express gpp port F)
0001:00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA 
Controller [AHCI mode]
0001:00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller
0001:00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
0001:00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI 
Controller
0001:00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller
0001:00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
0001:00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI 
Controller
0001:00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3d)
0001:00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
0001:00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
0001:00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host 
controller
0001:00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
0001:00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 
Controller
0001:00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor HyperTransport Configuration
0001:00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor Address Map
0001:00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor DRAM Controller
0001:00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor Miscellaneous Control
0001:00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor Link Control
0001:00:19.0 Host bridge: Device 1b47:0601 (rev 02)
0001:00:19.1 Host bridge: Device 1b47:0602 (rev 02)
0001:01:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host 
Controller (rev 03)
0001:02:00.0 Ethernet controller: Intel Corporation 82574L Gigabit 
Network Connection
0001:03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit 
Network Connection
0001:04:06.0 VGA compatible controller: ASPEED Technology, Inc. ASPEED 
Graphics Family (rev 10)
0002:00:00.0 Host bridge: ATI Technologies Inc RD890 Northbridge only 
dual slot (2x16) PCI-e GFX Hydra part (rev 02)
0002:00:04.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge 
(PCI express gpp port D)
0002:00:05.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge 
(PCI express gpp port E)
0002:00:06.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge 
(PCI express gpp port F)
0002:00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA 
Controller [AHCI mode]
0002:00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller
0002:00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
0002:00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI 
Controller
0002:00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller
0002:00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
0002:00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI 
Controller
0002:00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3d)
0002:00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
0002:00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
0002:00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host 
controller
0002:00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
0002:00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 
Controller
0002:00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor HyperTransport Configuration
0002:00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor Address Map
0002:00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor DRAM Controller
0002:00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor Miscellaneous Control
0002:00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h 
Processor Link Control
0002:00:19.0 Host bridge: Device 1b47:0601 (rev 02)
0002:00:19.1 Host bridge: Device 1b47:0602 (rev 02)
0002:01:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host 
Controller (rev 03)
0002:02:00.0 Ethernet controller: Intel Corporation 82574L Gigabit 
Network Connection
0002:03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit 
Network Connection
0002:04:06.0 VGA compatible controller: ASPEED Technology, Inc. ASPEED 
Graphics Family (rev 10)
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
