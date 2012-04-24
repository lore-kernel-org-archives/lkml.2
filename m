Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab2DXRZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:25:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab2DXRZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:25:14 -0400
Message-ID: <4F96E1EB.1030407@redhat.com>
Date: Tue, 24 Apr 2012 14:24:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic layers
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com> <1334607133-30039-7-git-send-email-mchehab@redhat.com> <20120423174955.GH6147@aftab.osrc.amd.com> <4F959FDE.2070304@redhat.com> <20120424104059.GA11559@aftab.osrc.amd.com> <4F9692AD.8090000@redhat.com> <20120424125538.GC11559@aftab.osrc.amd.com> <4F96A696.40308@redhat.com> <20120424133242.GI11559@aftab.osrc.amd.com> <4F96B783.6060101@redhat.com> <20120424162743.GU11559@aftab.osrc.amd.com>
In-Reply-To: <20120424162743.GU11559@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-04-2012 13:27, Borislav Petkov escreveu:
> On Tue, Apr 24, 2012 at 11:24:03AM -0300, Mauro Carvalho Chehab wrote:
>> Yes (well, except that Nehalem has also a concept of "virtual channel", so
>> calling it "virtual" can mislead into a different view).
> 
> No, it cannot. It is a very simple question: Am I looking at virtual
> slots/channels or not, when I'm looking at edac-ctl output?

It is showing physical slots/channels at edac-ctl output.

> [..]
> 
>>> I hope you can understand my confusion now:
>>>
>>> On the one hand, there are the physical slots where the DIMMs are
>>> sticked into.
>>>
>>> OTOH, there are the slots==ranks which the memory controllers use to
>>> talk to the DIMMs.
>>
>> This only applies to amd64 and other csrows-based memory controllers.
>>
>> A memory controller like the one at Nehalem abstracts csrows (I suspect
>> that they have internally something functionally similar to a FB-DIMM
>> AMB internally). They do memory interleaving between the memory channels
>> in order to produce a cachesize bigger than 64 bits, but they don't
> 
> You mean cacheline here.

Yes. Sorry for the typo.

>> actually care about how many ranks are there on each DIMM.
> 
> This cannot be right - you need the chip select to talk to a rank.
> This is basic DDR functionality.

Yes, but this seems to be hidden on some lower level layer on their hardware.
The rank information is only an information inside their per-DIMM registers.

> I can imagine that they're doing some tricks like channel/chip
> select/memory controller interleaving.

They can do all several different types of interleaving, using from 1
(no interleaving) to 4 channels. The interleave is done by address range,
not by csrow.

This is a dump of what sb_edac reads from Sandy Bridge EP registers:

[52803.640136] EDAC DEBUG: get_dimm_config: mc#1: Node ID: 1, source ID: 1
[52803.640141] EDAC DEBUG: get_dimm_config: Memory mirror is disabled
[52803.640154] EDAC DEBUG: get_dimm_config: Lockstep is disabled
[52803.640156] EDAC DEBUG: get_dimm_config: address map is on open page mode
[52803.640157] EDAC DEBUG: get_dimm_config: Memory is unregistered
[52803.640159] EDAC DEBUG: get_dimm_config: Channel #0  MTR0 = 500c
[52803.640162] EDAC DEBUG: get_dimm_config: mc#1: channel 0, dimm 0, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
[52803.640165] EDAC DEBUG: get_dimm_config: Channel #0  MTR1 = 500c
[52803.640168] EDAC DEBUG: get_dimm_config: mc#1: channel 0, dimm 1, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
[52803.640171] EDAC DEBUG: get_dimm_config: Channel #0  MTR2 = 0
[52803.640174] EDAC DEBUG: get_dimm_config: Channel #1  MTR0 = 500c
[52803.640176] EDAC DEBUG: get_dimm_config: mc#1: channel 1, dimm 0, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
[52803.640180] EDAC DEBUG: get_dimm_config: Channel #1  MTR1 = 500c
[52803.640182] EDAC DEBUG: get_dimm_config: mc#1: channel 1, dimm 1, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
[52803.640185] EDAC DEBUG: get_dimm_config: Channel #1  MTR2 = 0
[52803.640188] EDAC DEBUG: get_dimm_config: Channel #2  MTR0 = 500c
[52803.640190] EDAC DEBUG: get_dimm_config: mc#1: channel 2, dimm 0, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
[52803.640193] EDAC DEBUG: get_dimm_config: Channel #2  MTR1 = 500c
[52803.640195] EDAC DEBUG: get_dimm_config: mc#1: channel 2, dimm 1, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
[52803.640199] EDAC DEBUG: get_dimm_config: Channel #2  MTR2 = 0
[52803.640201] EDAC DEBUG: get_dimm_config: Channel #3  MTR0 = 500c
[52803.640203] EDAC DEBUG: get_dimm_config: mc#1: channel 3, dimm 0, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
[52803.640218] EDAC DEBUG: get_dimm_config: Channel #3  MTR1 = 500c
[52803.640220] EDAC DEBUG: get_dimm_config: mc#1: channel 3, dimm 1, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
[52803.640223] EDAC DEBUG: get_dimm_config: Channel #3  MTR2 = 0
[52803.640226] EDAC DEBUG: get_memory_layout: TOLM: 3.136 GB (0x00000000c3ffffff)
[52803.640228] EDAC DEBUG: get_memory_layout: TOHM: 66.624 GB (0x0000001043ffffff)
[52803.640231] EDAC DEBUG: get_memory_layout: SAD#0 DRAM up to 33.792 GB (0x0000000840000000) Interleave: 8:6 reg=0x000083c3
[52803.640234] EDAC DEBUG: get_memory_layout: SAD#0, interleave #0: 0
[52803.640237] EDAC DEBUG: get_memory_layout: SAD#1 DRAM up to 66.560 GB (0x0000001040000000) Interleave: 8:6 reg=0x000103c3
[52803.640239] EDAC DEBUG: get_memory_layout: SAD#1, interleave #0: 1
[52803.640245] EDAC DEBUG: get_memory_layout: TAD#0: up to 66.560 GB (0x0000001040000000), socket interleave 0, memory interleave 3, TGT: 0, 1, 2, 3, reg=0x0040f3e4
[52803.640249] EDAC DEBUG: get_memory_layout: TAD CH#0, offset #0: 33.792 GB (0x0000000840000000), reg=0x00008400
[52803.640252] EDAC DEBUG: get_memory_layout: TAD CH#1, offset #0: 33.792 GB (0x0000000840000000), reg=0x00008400
[52803.640255] EDAC DEBUG: get_memory_layout: TAD CH#2, offset #0: 33.792 GB (0x0000000840000000), reg=0x00008400
[52803.640258] EDAC DEBUG: get_memory_layout: TAD CH#3, offset #0: 33.792 GB (0x0000000840000000), reg=0x00008400
[52803.640261] EDAC DEBUG: get_memory_layout: CH#0 RIR#0, limit: 8.191 GB (0x00000001fff00000), way: 4, reg=0xa000001e
[52803.640264] EDAC DEBUG: get_memory_layout: CH#0 RIR#0 INTL#0, offset 0.000 GB (0x0000000000000000), tgt: 0, reg=0x00000000
[52803.640278] EDAC DEBUG: get_memory_layout: CH#0 RIR#0 INTL#1, offset 0.000 GB (0x0000000000000000), tgt: 4, reg=0x00040000
[52803.640281] EDAC DEBUG: get_memory_layout: CH#0 RIR#0 INTL#2, offset 0.000 GB (0x0000000000000000), tgt: 1, reg=0x00010000
[52803.640283] EDAC DEBUG: get_memory_layout: CH#0 RIR#0 INTL#3, offset 0.000 GB (0x0000000000000000), tgt: 5, reg=0x00050000
[52803.640287] EDAC DEBUG: get_memory_layout: CH#1 RIR#0, limit: 8.191 GB (0x00000001fff00000), way: 4, reg=0xa000001e
[52803.640290] EDAC DEBUG: get_memory_layout: CH#1 RIR#0 INTL#0, offset 0.000 GB (0x0000000000000000), tgt: 0, reg=0x00000000
[52803.640293] EDAC DEBUG: get_memory_layout: CH#1 RIR#0 INTL#1, offset 0.000 GB (0x0000000000000000), tgt: 4, reg=0x00040000
[52803.640296] EDAC DEBUG: get_memory_layout: CH#1 RIR#0 INTL#2, offset 0.000 GB (0x0000000000000000), tgt: 1, reg=0x00010000
[52803.640299] EDAC DEBUG: get_memory_layout: CH#1 RIR#0 INTL#3, offset 0.000 GB (0x0000000000000000), tgt: 5, reg=0x00050000
[52803.640303] EDAC DEBUG: get_memory_layout: CH#2 RIR#0, limit: 8.191 GB (0x00000001fff00000), way: 4, reg=0xa000001e
[52803.640306] EDAC DEBUG: get_memory_layout: CH#2 RIR#0 INTL#0, offset 0.000 GB (0x0000000000000000), tgt: 0, reg=0x00000000
[52803.640309] EDAC DEBUG: get_memory_layout: CH#2 RIR#0 INTL#1, offset 0.000 GB (0x0000000000000000), tgt: 4, reg=0x00040000
[52803.640312] EDAC DEBUG: get_memory_layout: CH#2 RIR#0 INTL#2, offset 0.000 GB (0x0000000000000000), tgt: 1, reg=0x00010000
[52803.640315] EDAC DEBUG: get_memory_layout: CH#2 RIR#0 INTL#3, offset 0.000 GB (0x0000000000000000), tgt: 5, reg=0x00050000
[52803.640319] EDAC DEBUG: get_memory_layout: CH#3 RIR#0, limit: 8.191 GB (0x00000001fff00000), way: 4, reg=0xa000001e
[52803.640322] EDAC DEBUG: get_memory_layout: CH#3 RIR#0 INTL#0, offset 0.000 GB (0x0000000000000000), tgt: 0, reg=0x00000000
[52803.640324] EDAC DEBUG: get_memory_layout: CH#3 RIR#0 INTL#1, offset 0.000 GB (0x0000000000000000), tgt: 4, reg=0x00040000
[52803.640327] EDAC DEBUG: get_memory_layout: CH#3 RIR#0 INTL#2, offset 0.000 GB (0x0000000000000000), tgt: 1, reg=0x00010000
[52803.640330] EDAC DEBUG: get_memory_layout: CH#3 RIR#0 INTL#3, offset 0.000 GB (0x0000000000000000), tgt: 5, reg=0x00050000

In this case, all 4 channels are used for interleave:

[52803.640245] EDAC DEBUG: get_memory_layout: TAD#0: up to 66.560 GB (0x0000001040000000), socket interleave 0, memory interleave 3, TGT: 0, 1, 2, 3, reg=0x0040f3e4

It doesn't do DIMM socket interleave (socket interleave 0). It does channel interleave
among channels 0 to 3 (TGT: 0, 1, 2, 3). 

It also does an interleave at the physical memory address on bits 6 to 8:

[52803.640231] EDAC DEBUG: get_memory_layout: SAD#0 DRAM up to 33.792 GB (0x0000000840000000) Interleave: 8:6 reg=0x000083c3

This memory controller have thousands (literally) of different BIOS setups
that change how interleaves can happen on it. The above is the default
setup.

They're based on DIMM socket, MCU channel and physical address ranges.

> In the end of the day, it is smallest row that gives you 64 bits of
> data.

Yes, but the memory controller views memories per DIMM socket, and 

> @Tony: hey Tony, can you point us to an Intel document explaining how
> Sandy Bridge or NH or one of the new ones does the memory addressing wrt
> ranks, channels etc? Thanks.

For Nehalem, see i7core_edac comments that I added at the beginning of the
driver:

 * Based on the following public Intel datasheets:
 * Intel Core i7 Processor Extreme Edition and Intel Core i7 Processor
 * Datasheet, Volume 2:
 *	http://download.intel.com/design/processor/datashts/320835.pdf
 * Intel Xeon Processor 5500 Series Datasheet Volume 2
 *	http://www.intel.com/Assets/PDF/datasheet/321322.pdf
 * also available at:
 * 	http://www.arrownac.com/manufacturers/intel/s/nehalem/5500-datasheet-v2.pdf

> 
> [..]
> 
>> No. As far as I can tell, they can have 9 quad-ranked DIMMs (the machines
>> I've looked so far are all equipped with single rank memories, so I don't 
>> have a real scenario with 2R or 4R for Nehalem yet).
>>
>> At Sandy Bridge-EP (E. g. Intel E5 CPUs), we have one machine fully equipped
>> with dual rank memories. The number of ranks there is just a DIMM property.
>>
>> # ./edac-ctl --layout
>>        +-----------------------------------------------------------------------------------------------+
>>        |                      mc0                      |                      mc1                      |
>>        | channel0  | channel1  | channel2  | channel3  | channel0  | channel1  | channel2  | channel3  |
>> -------+-----------------------------------------------------------------------------------------------+
>> slot2: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
>> slot1: |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |
>> slot0: |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |
>> -------+-----------------------------------------------------------------------------------------------+
>>
>> (this machine doesn't have physical DIMM sockets for slot#2)
> 
> Ok, I can count 8 2R DIMMs here and each rank or slot in your
> nomenclature is 4G. slot#2 has to be something virtual since each rank
> occupies one slot, i.e. slot0 and slot1 on a channel.

No. This machine has 64 GB of RAM, and it was physically filled with 16 DIMMs, 
each with 4GB. Each of the above represents one DIMM (and not a rank).

Btw, the above logs are for this machine.

# free
             total       used       free     shared    buffers     cached
Mem:      65933268    1166384   64766884          0      60572     363712
-/+ buffers/cache:     742100   65191168
Swap:     68157436      18680   68138756

The DMI decode info also clearly states that:

# dmidecode|grep -e "Memory Device$" -e Size -e "Bank Locat" -e "Serial Number" |grep -v Range
...
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 0 CHANNEL 0 DIMM 0
	Serial Number: 82766209  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 0 CHANNEL 0 DIMM 1
	Serial Number: 827661D3  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 0 CHANNEL 1 DIMM 0
	Serial Number: 82766197  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 0 CHANNEL 1 DIMM 1
	Serial Number: 82766204  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 0 CHANNEL 2 DIMM 0
	Serial Number: 827661D7  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 0 CHANNEL 2 DIMM 1
	Serial Number: 82766200  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 0 CHANNEL 3 DIMM 0
	Serial Number: 827661F9  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 0 CHANNEL 3 DIMM 1
	Serial Number: 827661B3  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 1 CHANNEL 0 DIMM 0
	Serial Number: 47473B79  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 1 CHANNEL 0 DIMM 1
	Serial Number: 440FF77F  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 1 CHANNEL 1 DIMM 0
	Serial Number: 47473B5A  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 1 CHANNEL 1 DIMM 1
	Serial Number: 47473B71  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 1 CHANNEL 2 DIMM 0
	Serial Number: 47473B62  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 1 CHANNEL 2 DIMM 1
	Serial Number: 440FF7FC  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 1 CHANNEL 3 DIMM 0
	Serial Number: 440FF7C1  
Memory Device
	Size: 4096 MB
	Bank Locator: NODE 1 CHANNEL 3 DIMM 1
	Serial Number: 440FF7F4  

As I said, for this memory controller, and for Nehalem, the memories are
mapped per DIMM socket (and not per rank).

Mauro.
