Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab0GNPg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:36:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:37974 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab0GNPgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:36:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,202,1278313200"; 
   d="scan'208";a="818070113"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Ben Greear <greearb@candelatech.com>,
        Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Date: Wed, 14 Jul 2010 08:36:22 -0700
Subject: RE: Regression: 2.6.34 boot fails on E5405 system, bisected:
 	de08e2c26
Thread-Topic: Regression: 2.6.34 boot fails on E5405 system, bisected:
 	de08e2c26
Thread-Index: AcsjXuy0X0KsBtYzQMyEnj9PfZFdSwACuJow
Message-ID: <43F901BD926A4E43B106BF17856F0755EA8EE7E2@orsmsx508.amr.corp.intel.com>
References: <4C3D067C.10507@candelatech.com>
	<4C3D101E.5010605@candelatech.com>	<4C3D1942.1090207@gmail.com>
	<4C3D1F82.1040907@candelatech.com>
 <AANLkTinDv7I4v51j-Lev9Ry_3DyVVv58lAyCQXZV1CwB@mail.gmail.com>
 <4C3DC64F.5040505@candelatech.com>
In-Reply-To: <4C3DC64F.5040505@candelatech.com>
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

what is the config size of 10.1?
ls -l /sys/bus/pci/devices/0000:00:10.1/config

if that is 256, it might be related to this patch.

>From e9b1d5d0ff4d3ae86050dc4c91b3147361c7af9e Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@linux.intel.com>
Date: Fri, 14 May 2010 13:55:57 -0700
Subject: [PATCH] x86, mrst: Don't blindly access extended config space

Do not blindly access extended configuration space unless we actively
know we're on a Moorestown platform.  The fixed-size BAR capability
lives in the extended configuration space, and thus is not applicable
if the configuration space isn't appropriately sized.

This fixes booting certain VMware configurations with CONFIG_MRST=y.

Moorestown will add a fake PCI-X 266 capability to advertise the
presence of extended configuration space.

Reported-and-tested-by: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Jacob Pan <jacob.jun.pan@intel.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <AANLkTiltKUa3TrKR1M51eGw8FLNoQJSLT0k0_K5X3-OJ@mail.gmail.com>
---
 arch/x86/pci/mrst.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 8bf2fcb..1cdc02c 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -247,6 +247,10 @@ static void __devinit pci_fixed_bar_fixup(struct pci_dev *dev)
 	u32 size;
 	int i;
 
+	/* Must have extended configuration space */
+	if (dev->cfg_size < PCIE_CAP_OFFSET + 4)
+		return;
+
 	/* Fixup the BAR sizes for fixed BAR devices and make them unmoveable */
 	offset = fixed_bar_cap(dev->bus, dev->devfn);
 	if (!offset || PCI_DEVFN(2, 0) == dev->devfn ||
-- 
1.6.3.3


>-----Original Message-----
>From: Ben Greear [mailto:greearb@candelatech.com]
>Sent: Wednesday, July 14, 2010 7:15 AM
>To: Robert Hancock
>Cc: linux-kernel; jbarnes@virtuousgeek.org; Pan, Jacob jun
>Subject: Re: Regression: 2.6.34 boot fails on E5405 system, bisected:
>de08e2c26
>
>On 07/13/2010 08:29 PM, Robert Hancock wrote:
>> On Tue, Jul 13, 2010 at 8:22 PM, Ben Greear<greearb@candelatech.com>
>wrote:
>>>> Can you print out bus->number and devfn and look that up in lspci to
>>>> find out which device it's hitting? It looks like there's a device
>with
>>>> a PCI Express extended capability header that has a extended
>capability
>>>> ID of 0000h and a next capability offset of 100h, which points to
>>>> itself, causing the infinite loop. I'm guessing that if pcie_cap>>
>20
>>>> <= pos then it should give up and break out of the loop, since it
>means
>>>> that the next capability pointer is invalidly pointing to the same
>or a
>>>> previous entry..
>>>
>>> Bailing out like that does let it boot.
>>>
>>> As for the bus and devfn:  bus: 0   devfn: 129 (decimal)
>>>
>>> I'm not sure what to look for in lspci, but here is the output with -
>n:
>>
>> That will be device 0x10 function 1, this one:
>>
>> 00:10.1 0600: 8086:25f0 (rev b1)
>>
>> Intel 5000 Series Chipset FSB Registers, apparently.. What does lspci
>> -vv show for that device?
>
>00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers
>(rev b1)
>	Subsystem: Super Micro Computer Inc Unknown device 9780
>	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
>ParErr- Stepping- SERR- FastB2B- DisINTx-
>	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
><TAbort- <MAbort- >SERR- <PERR- INTx-
>	Kernel modules: i5000_edac, i5k_amb
>
>Thanks,
>Ben
>
>
>--
>Ben Greear <greearb@candelatech.com>
>Candela Technologies Inc  http://www.candelatech.com
