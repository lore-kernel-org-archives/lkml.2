Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab2DYRTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:19:13 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51458 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab2DYRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:19:11 -0400
Date: Wed, 25 Apr 2012 19:19:04 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC PATCH v13 6/7] edac.h: Prepare to handle with generic
 layers
Message-ID: <20120425171904.GM18882@aftab.osrc.amd.com>
References: <20120423174955.GH6147@aftab.osrc.amd.com>
 <4F959FDE.2070304@redhat.com>
 <20120424104059.GA11559@aftab.osrc.amd.com>
 <4F9692AD.8090000@redhat.com>
 <20120424125538.GC11559@aftab.osrc.amd.com>
 <4F96A696.40308@redhat.com>
 <20120424133242.GI11559@aftab.osrc.amd.com>
 <4F96B783.6060101@redhat.com>
 <20120424162743.GU11559@aftab.osrc.amd.com>
 <4F96E1EB.1030407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F96E1EB.1030407@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 02:24:59PM -0300, Mauro Carvalho Chehab wrote:
> Yes, but this seems to be hidden on some lower level layer on their
> hardware. The rank information is only an information inside their
> per-DIMM registers.

Yep, it looks like it.

[..]

> [52803.640136] EDAC DEBUG: get_dimm_config: mc#1: Node ID: 1, source ID: 1
> [52803.640141] EDAC DEBUG: get_dimm_config: Memory mirror is disabled
> [52803.640154] EDAC DEBUG: get_dimm_config: Lockstep is disabled
> [52803.640156] EDAC DEBUG: get_dimm_config: address map is on open page mode
> [52803.640157] EDAC DEBUG: get_dimm_config: Memory is unregistered
> [52803.640159] EDAC DEBUG: get_dimm_config: Channel #0  MTR0 = 500c
> [52803.640162] EDAC DEBUG: get_dimm_config: mc#1: channel 0, dimm 0, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
> [52803.640165] EDAC DEBUG: get_dimm_config: Channel #0  MTR1 = 500c
> [52803.640168] EDAC DEBUG: get_dimm_config: mc#1: channel 0, dimm 1, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
> [52803.640171] EDAC DEBUG: get_dimm_config: Channel #0  MTR2 = 0
> [52803.640174] EDAC DEBUG: get_dimm_config: Channel #1  MTR0 = 500c
> [52803.640176] EDAC DEBUG: get_dimm_config: mc#1: channel 1, dimm 0, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
> [52803.640180] EDAC DEBUG: get_dimm_config: Channel #1  MTR1 = 500c
> [52803.640182] EDAC DEBUG: get_dimm_config: mc#1: channel 1, dimm 1, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
> [52803.640185] EDAC DEBUG: get_dimm_config: Channel #1  MTR2 = 0
> [52803.640188] EDAC DEBUG: get_dimm_config: Channel #2  MTR0 = 500c
> [52803.640190] EDAC DEBUG: get_dimm_config: mc#1: channel 2, dimm 0, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
> [52803.640193] EDAC DEBUG: get_dimm_config: Channel #2  MTR1 = 500c
> [52803.640195] EDAC DEBUG: get_dimm_config: mc#1: channel 2, dimm 1, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
> [52803.640199] EDAC DEBUG: get_dimm_config: Channel #2  MTR2 = 0
> [52803.640201] EDAC DEBUG: get_dimm_config: Channel #3  MTR0 = 500c
> [52803.640203] EDAC DEBUG: get_dimm_config: mc#1: channel 3, dimm 0, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400
> [52803.640218] EDAC DEBUG: get_dimm_config: Channel #3  MTR1 = 500c
> [52803.640220] EDAC DEBUG: get_dimm_config: mc#1: channel 3, dimm 1, 4096 Mb (1048576 pages) bank: 8, rank: 2, row: 0x8000, col: 0x400

Ok, this looks like output from those MC_DOD_CH{0,1,2}_{0,1,2}
registers. And those are per-channel, actually, with a NUMRANK field
which tells you how many ranks the DIMM on this channel has.

(Btw, I'm looking at the corei7 datasheet, doc# 320835-003, couldn't
find those MC_DOD*s in the xeon datasheets).

So, the channels display in edac-ctl are the 3 channels, slot{0,1,2} are the
physical slots on each channel.

Now let's look at your output from earlier:

> $ ./edac-ctl --layout
>        +-----------------------------------+
>        |                mc0                |
>        | channel0  | channel1  | channel2  |
> -------+-----------------------------------+
> slot2: |     0 MB  |     0 MB  |     0 MB  |
> slot1: |  1024 MB  |     0 MB  |     0 MB  |
> slot0: |  1024 MB  |  1024 MB  |  1024 MB  |
> -------+-----------------------------------+
>
> Those are the logs that dump the Memory Controller registers:
>
> [  115.818947] EDAC DEBUG: get_dimm_config: Ch0 phy rd0, wr0 (0x063f4031): 2 ranks, UDIMMs

it says here 2 ranks

> [  115.818950] EDAC DEBUG: get_dimm_config:   dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400
> [  115.818955] EDAC DEBUG: get_dimm_config:   dimm 1 1024 Mb offset: 4, bank: 8, rank: 1, row: 0x4000, col: 0x400
> [  115.818982] EDAC DEBUG: get_dimm_config: Ch1 phy rd1, wr1 (0x063f4031): 2 ranks, UDIMMs

and here 2 too although there's only one single-ranked DIMM here. So
which is it?

> [  115.818985] EDAC DEBUG: get_dimm_config:   dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400
> [  115.819012] EDAC DEBUG: get_dimm_config: Ch2 phy rd3, wr3 (0x063f4031): 2 ranks, UDIMMs
> [  115.819016] EDAC DEBUG: get_dimm_config:   dimm 0 1024 Mb offset: 0, bank: 8, rank: 1, row: 0x4000, col: 0x400

So, I'd say this machine has 4 DIMMs on the node, all 4 of them are
single-ranked and 2 are connected to channel0, the other two channels
have each a single DIMM of a single rank.

Looking further the i7 doc above, there are other registers like
MC_SAG_CH{0,1,2}_{0-7} which look like rank descriptors and there's
even a small pseudo-code thing which can give you the memory address by
"unwinding" the interleaving.

> [52803.640223] EDAC DEBUG: get_dimm_config: Channel #3  MTR2 = 0
> [52803.640226] EDAC DEBUG: get_memory_layout: TOLM: 3.136 GB (0x00000000c3ffffff)
> [52803.640228] EDAC DEBUG: get_memory_layout: TOHM: 66.624 GB (0x0000001043ffffff)
> [52803.640231] EDAC DEBUG: get_memory_layout: SAD#0 DRAM up to 33.792 GB (0x0000000840000000) Interleave: 8:6 reg=0x000083c3
> [52803.640234] EDAC DEBUG: get_memory_layout: SAD#0, interleave #0: 0
> [52803.640237] EDAC DEBUG: get_memory_layout: SAD#1 DRAM up to 66.560 GB (0x0000001040000000) Interleave: 8:6 reg=0x000103c3
> [52803.640239] EDAC DEBUG: get_memory_layout: SAD#1, interleave #0: 1
> [52803.640245] EDAC DEBUG: get_memory_layout: TAD#0: up to 66.560 GB (0x0000001040000000), socket interleave 0, memory interleave 3, TGT: 0, 1, 2, 3, reg=0x0040f3e4
> [52803.640249] EDAC DEBUG: get_memory_layout: TAD CH#0, offset #0: 33.792 GB (0x0000000840000000), reg=0x00008400
> [52803.640252] EDAC DEBUG: get_memory_layout: TAD CH#1, offset #0: 33.792 GB (0x0000000840000000), reg=0x00008400
> [52803.640255] EDAC DEBUG: get_memory_layout: TAD CH#2, offset #0: 33.792 GB (0x0000000840000000), reg=0x00008400
> [52803.640258] EDAC DEBUG: get_memory_layout: TAD CH#3, offset #0: 33.792 GB (0x0000000840000000), reg=0x00008400
> [52803.640261] EDAC DEBUG: get_memory_layout: CH#0 RIR#0, limit: 8.191 GB (0x00000001fff00000), way: 4, reg=0xa000001e
> [52803.640264] EDAC DEBUG: get_memory_layout: CH#0 RIR#0 INTL#0, offset 0.000 GB (0x0000000000000000), tgt: 0, reg=0x00000000
> [52803.640278] EDAC DEBUG: get_memory_layout: CH#0 RIR#0 INTL#1, offset 0.000 GB (0x0000000000000000), tgt: 4, reg=0x00040000
> [52803.640281] EDAC DEBUG: get_memory_layout: CH#0 RIR#0 INTL#2, offset 0.000 GB (0x0000000000000000), tgt: 1, reg=0x00010000
> [52803.640283] EDAC DEBUG: get_memory_layout: CH#0 RIR#0 INTL#3, offset 0.000 GB (0x0000000000000000), tgt: 5, reg=0x00050000
> [52803.640287] EDAC DEBUG: get_memory_layout: CH#1 RIR#0, limit: 8.191 GB (0x00000001fff00000), way: 4, reg=0xa000001e
> [52803.640290] EDAC DEBUG: get_memory_layout: CH#1 RIR#0 INTL#0, offset 0.000 GB (0x0000000000000000), tgt: 0, reg=0x00000000
> [52803.640293] EDAC DEBUG: get_memory_layout: CH#1 RIR#0 INTL#1, offset 0.000 GB (0x0000000000000000), tgt: 4, reg=0x00040000
> [52803.640296] EDAC DEBUG: get_memory_layout: CH#1 RIR#0 INTL#2, offset 0.000 GB (0x0000000000000000), tgt: 1, reg=0x00010000
> [52803.640299] EDAC DEBUG: get_memory_layout: CH#1 RIR#0 INTL#3, offset 0.000 GB (0x0000000000000000), tgt: 5, reg=0x00050000
> [52803.640303] EDAC DEBUG: get_memory_layout: CH#2 RIR#0, limit: 8.191 GB (0x00000001fff00000), way: 4, reg=0xa000001e
> [52803.640306] EDAC DEBUG: get_memory_layout: CH#2 RIR#0 INTL#0, offset 0.000 GB (0x0000000000000000), tgt: 0, reg=0x00000000
> [52803.640309] EDAC DEBUG: get_memory_layout: CH#2 RIR#0 INTL#1, offset 0.000 GB (0x0000000000000000), tgt: 4, reg=0x00040000
> [52803.640312] EDAC DEBUG: get_memory_layout: CH#2 RIR#0 INTL#2, offset 0.000 GB (0x0000000000000000), tgt: 1, reg=0x00010000
> [52803.640315] EDAC DEBUG: get_memory_layout: CH#2 RIR#0 INTL#3, offset 0.000 GB (0x0000000000000000), tgt: 5, reg=0x00050000
> [52803.640319] EDAC DEBUG: get_memory_layout: CH#3 RIR#0, limit: 8.191 GB (0x00000001fff00000), way: 4, reg=0xa000001e
> [52803.640322] EDAC DEBUG: get_memory_layout: CH#3 RIR#0 INTL#0, offset 0.000 GB (0x0000000000000000), tgt: 0, reg=0x00000000
> [52803.640324] EDAC DEBUG: get_memory_layout: CH#3 RIR#0 INTL#1, offset 0.000 GB (0x0000000000000000), tgt: 4, reg=0x00040000
> [52803.640327] EDAC DEBUG: get_memory_layout: CH#3 RIR#0 INTL#2, offset 0.000 GB (0x0000000000000000), tgt: 1, reg=0x00010000
> [52803.640330] EDAC DEBUG: get_memory_layout: CH#3 RIR#0 INTL#3, offset 0.000 GB (0x0000000000000000), tgt: 5, reg=0x00050000
> 
> In this case, all 4 channels are used for interleave:

Ok, this has 4 channels.

> [52803.640245] EDAC DEBUG: get_memory_layout: TAD#0: up to 66.560 GB (0x0000001040000000), socket interleave 0, memory interleave 3, TGT: 0, 1, 2, 3, reg=0x0040f3e4
> 
> It doesn't do DIMM socket interleave (socket interleave 0). It does channel interleave
> among channels 0 to 3 (TGT: 0, 1, 2, 3). 
> 
> It also does an interleave at the physical memory address on bits 6 to 8:

Ok.

[..]

> For Nehalem, see i7core_edac comments that I added at the beginning of the
> driver:
> 
>  * Based on the following public Intel datasheets:
>  * Intel Core i7 Processor Extreme Edition and Intel Core i7 Processor
>  * Datasheet, Volume 2:
>  *	http://download.intel.com/design/processor/datashts/320835.pdf
>  * Intel Xeon Processor 5500 Series Datasheet Volume 2
>  *	http://www.intel.com/Assets/PDF/datasheet/321322.pdf

This is 404.

>  * also available at:
>  * 	http://www.arrownac.com/manufacturers/intel/s/nehalem/5500-datasheet-v2.pdf

This one works.

> >> No. As far as I can tell, they can have 9 quad-ranked DIMMs (the machines
> >> I've looked so far are all equipped with single rank memories, so I don't 
> >> have a real scenario with 2R or 4R for Nehalem yet).

Well, the xeon 5500 datasheet, vol2 has a table 3-2 of RDIMM population
configs and according to it, it can do only one 4R DIMM in the farthest
slot, page 127 from here:

http://www.intel.com/content/www/us/en/processors/xeon/xeon-processor-5000-sequence/Xeon5000TechnicalResources.html

?

> >> At Sandy Bridge-EP (E. g. Intel E5 CPUs), we have one machine fully equipped
> >> with dual rank memories. The number of ranks there is just a DIMM property.
> >>
> >> # ./edac-ctl --layout
> >>        +-----------------------------------------------------------------------------------------------+
> >>        |                      mc0                      |                      mc1                      |
> >>        | channel0  | channel1  | channel2  | channel3  | channel0  | channel1  | channel2  | channel3  |
> >> -------+-----------------------------------------------------------------------------------------------+
> >> slot2: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
> >> slot1: |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |
> >> slot0: |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |  4096 MB  |
> >> -------+-----------------------------------------------------------------------------------------------+
> >>
> >> (this machine doesn't have physical DIMM sockets for slot#2)

This looks like a 4-channel memory controller with 3 physical slots per
channel.

> > Ok, I can count 8 2R DIMMs here and each rank or slot in your
> > nomenclature is 4G. slot#2 has to be something virtual since each rank
> > occupies one slot, i.e. slot0 and slot1 on a channel.
> 
> No. This machine has 64 GB of RAM, and it was physically filled with 16 DIMMs, 
> each with 4GB. Each of the above represents one DIMM (and not a rank).

Yep, I see that now.

> 
> Btw, the above logs are for this machine.
> 
> # free
>              total       used       free     shared    buffers     cached
> Mem:      65933268    1166384   64766884          0      60572     363712
> -/+ buffers/cache:     742100   65191168
> Swap:     68157436      18680   68138756
> 
> The DMI decode info also clearly states that:
> 
> # dmidecode|grep -e "Memory Device$" -e Size -e "Bank Locat" -e "Serial Number" |grep -v Range
> ...
> Memory Device
> 	Size: 4096 MB
> 	Bank Locator: NODE 0 CHANNEL 0 DIMM 0
> 	Serial Number: 82766209  
> Memory Device
> 	Size: 4096 MB
> 	Bank Locator: NODE 0 CHANNEL 0 DIMM 1
> 	Serial Number: 827661D3  
> Memory Device
> 	Size: 4096 MB
> 	Bank Locator: NODE 0 CHANNEL 1 DIMM 0
> 	Serial Number: 82766197

[..]

> As I said, for this memory controller, and for Nehalem, the memories are
> mapped per DIMM socket (and not per rank).

Ok, so there are still ranks and this is how the memory controller
addresses them but they can be interleaved (or not) depending on the
configuration. The registers describing the DIMMs are per-DIMM and have
fields like NUMRANK etc which tells you how many ranks a DIMM has, etc.

Then there are the MC_SAG_CH{0,1,2}_{1-7} which describes 8 interleave
ranges and those are actually the chip select rows == ranks.

And now the question is, when you get a DRAM ECC, how does the hardware
point to the DIMM in error, does it give you a (channel, slot) tuple
or a virtual address which you have to un-interleave? From MCA, you're
getting a virtual address in MC4_ADDR so how do you compute this one
back to a DIMM?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
