Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab2JAQMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:12:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45169 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2JAQMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:12:37 -0400
Message-ID: <5069C0EF.1050204@numascale-asia.com>
Date: Tue, 02 Oct 2012 00:12:31 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH] Prevent AMD MCE oops on multi-server system
References: <1349073725-14093-1-git-send-email-daniel@numascale-asia.com> <20121001100650.GB4795@aftab.osrc.amd.com>
In-Reply-To: <20121001100650.GB4795@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2012 18:06, Borislav Petkov wrote:
> On Mon, Oct 01, 2012 at 02:42:05PM +0800, Daniel J Blueman wrote:
>> When booting on a federated multi-server system, the processor Northbridge
>> lookup returns NULL; add guards to prevent this causing an oops.
> Interesting.
>
> What does lspci say on those systems?
>
> Thanks.
As NumaConnect remote-server I/O is in a pre-release stage, we only 
expose I/O on the first (root) server, so the lspci on eg my three 
server, single-socket C32 development system is uninteresting [1].

We map MMCONFIG addresses in the global address map to the respective 
server, which is how we access the processor Northbridges in the 
bootloader before Linux loads, so they are accessible and get enumerated 
when we enable remote I/O with the ACPI SSDT we generate, however since 
the AMD APIC IDs (hence NB IDs) are only 8-bit, the present 
amd_get_nb_id will produce duplicate NB IDs at best (but in this case, 
as we disable I/O routing, there is no structure); later, we may propose 
to using eg bits 23:8 for the server ID. That's another discussion though.

The minimal patch at least corrects the oops regression which didn't 
happen in earlier kernels.

Thanks!
   Daniel

--- [1]

root@oct1:~# lspci
00:00.0 Host bridge: ATI Technologies Inc RD890 Northbridge only dual 
slot (2x16) PCI-e GFX Hydra part (rev 02)
00:00.2 Generic system peripheral [0806]: ATI Technologies Inc Device 5a23
00:02.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI 
express gpp port B)
00:04.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI 
express gpp port D)
00:05.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI 
express gpp port E)
00:06.0 PCI bridge: ATI Technologies Inc RD890 PCI to PCI bridge (PCI 
express gpp port F)
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA 
Controller [AHCI mode]
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller
00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller
00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3d)
00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 
Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
Link Control
00:19.0 Host bridge: Device 1b47:0601 (rev 02)
00:19.1 Host bridge: Device 1b47:0602 (rev 02)
01:00.0 VGA compatible controller: ATI Technologies Inc Device 68ba
01:00.1 Audio device: ATI Technologies Inc Juniper HDMI Audio [Radeon HD 
5700 Series]
02:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host 
Controller (rev 03)
03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network 
Connection
04:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network 
Connection
05:06.0 VGA compatible controller: ASPEED Technology, Inc. ASPEED 
Graphics Family (rev 10)

-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia

