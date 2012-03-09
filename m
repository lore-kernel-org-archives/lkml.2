Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2CIOic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:38:32 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:41215 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2CIOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:38:31 -0500
Date: Fri, 9 Mar 2012 15:38:06 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120309143806.GA11962@aftab>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120308215716.GA5925@aftab>
 <4F59DC38.5080104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F59DC38.5080104@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 07:32:24AM -0300, Mauro Carvalho Chehab wrote:

[..]

> > Also, what does the nomenclature
> > 
> > [   12.196138] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: dimm0 (0:0:0): row 0, chan 0
> > [   12.204636] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: dimm1 (0:1:0): row 0, chan 1
> > [   12.213127] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: dimm2 (1:0:0): row 1, chan 0
> > [   12.221613] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: dimm3 (1:1:0): row 1, chan 1
> > [   12.230103] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: dimm4 (2:0:0): row 2, chan 0
> > [   12.238590] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: dimm5 (2:1:0): row 2, chan 1
> > [   12.247078] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: dimm6 (3:0:0): row 3, chan 0
> > [   12.255560] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: dimm7 (3:1:0): row 3, chan 1
> > [   12.264058] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 8: dimm8 (4:0:0): row 4, chan 0
> > [   12.272552] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 9: dimm9 (4:1:0): row 4, chan 1
> > [   12.281041] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 10: dimm10 (5:0:0): row 5, chan 0
> > [   12.289699] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 11: dimm11 (5:1:0): row 5, chan 1
> > [   12.298362] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 12: dimm12 (6:0:0): row 6, chan 0
> > [   12.307018] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 13: dimm13 (6:1:0): row 6, chan 1
> > [   12.315684] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 14: dimm14 (7:0:0): row 7, chan 0
> > [   12.324352] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 15: dimm15 (7:1:0): row 7, chan 1
> > 
> > mean? 16 DIMMs? No way.
> 
> The debug message needs to be fixed. The above message shows how many ranks were
> allocated, and not DIMMs. That means that patch 5/6 of the last series is incomplete,
> as it doesn't touch on the debug messages.
> 
> This debug info has the purpose of showing how the dimm or rank real location
> is mapped into the virtual csrow/channel notation.
> 
> From your logs, the machine you're testing has 16 ranks, so, except for the
> debug log fix, it is properly detecting everything.

No, it has 8 ranks (4 dual-ranked DIMMs on MCT 0 and the same on the
3 other MCTs). So rank0-7 is correct, actually, sorry. The dimm0-15
labeling above is rather wrong though and needs fixing.

> The rank location (the number in parenthesis) is being mapped to the right
> row/channel. On this MC, the location has just 2 addresses, so, the above
> message is showing "0" for the third location, as expected on this debug msg.
> 
> On a machine where the csrow/channel is virtualized, the above map would be 
> different. For example, on a machine with the i5000 Memory Controller, the
> memory is organized as:
> 
>        +-----------------------------------------------+
>        |                      mc0                      |
>        |        branch0        |        branch1        |
>        | channel0  | channel1  | channel0  | channel1  |
> -------+-----------------------------------------------+
> slot3: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
> slot2: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
> -------+-----------------------------------------------+
> slot1: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
> slot0: |   512 MB  |   512 MB  |   512 MB  |   512 MB  |
> -------+-----------------------------------------------+
> 
> This is the map for it (in this case, the debug is correct, as the memory is organized
> per dimm):
> 
> [   16.946841] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: dimm0 (0:0:0): row 0, chan 0
> [   16.946845] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: dimm1 (0:0:1): row 0, chan 1
> [   16.946848] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: dimm2 (0:0:2): row 0, chan 2
> [   16.946852] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: dimm3 (0:0:3): row 0, chan 3
> [   16.946855] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: dimm4 (0:1:0): row 1, chan 0
> [   16.946859] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: dimm5 (0:1:1): row 1, chan 1
> [   16.946862] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: dimm6 (0:1:2): row 1, chan 2
> [   16.946866] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: dimm7 (0:1:3): row 1, chan 3
> [   16.946869] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 8: dimm8 (1:0:0): row 2, chan 0
> [   16.946873] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 9: dimm9 (1:0:1): row 2, chan 1
> [   16.946876] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 10: dimm10 (1:0:2): row 2, chan 2
> [   16.946880] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 11: dimm11 (1:0:3): row 2, chan 3
> [   16.946883] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 12: dimm12 (1:1:0): row 3, chan 0
> [   16.946887] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 13: dimm13 (1:1:1): row 3, chan 1
> [   16.946890] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 14: dimm14 (1:1:2): row 3, chan 2
> [   16.946894] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 15: dimm15 (1:1:3): row 3, chan 3
> 
> It means that, on this driver, the dimm that it is at branch 1, channel 0
> slot 0 is mapped, according with this debug message:
> 	[   16.946869] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 8: dimm8 (1:0:0): row 2, chan 0
> as row 2, channel 0, on the per-csrow node:
> 
> /sys/devices/system/edac/mc/mc0/csrow2/ch0_dimm_label:mc#0branch#1channel#0slot#0
> 
> > Basically, the problem with the DIMM nomenclature is that you cannot
> > know from the hardware how many chip selects, aka ranks, comprise
> > one DIMM. IOW, you cannot know whether your DIMMs are single-ranked,
> > dual-ranked or quad-ranked and thus you cannot combine the csrows into
> > DIMM structs.
> 
> This may not be possible on amd64 hardware, but there are other memory
> controllers that allow it. On several ones, the registers are per DIMM,
> and there are fields there that counts the number of ranks per dimm.

Right, so all I'm saying is that on the drivers which have ranks but
cannot tell you to which DIMMs they belong, we shouldn't have the word
"DIMM" anywhere in sysfs or printk output because it is misleading
anyway. On those other drivers which explicitly support DIMMs, you can
do the per-DIMM splitting in /sysfs or whatever.

Also, now we have:

csrow0
|-- ce_count
|-- ch0_ce_count
|-- ch0_dimm_label
|-- ch1_ce_count
|-- ch1_dimm_label
|-- dev_type
|-- edac_mode
|-- mem_type
|-- size_mb
`-- ue_count
csrow1
|-- ce_count
|-- ch0_ce_count
|-- ch0_dimm_label
|-- ch1_ce_count
|-- ch1_dimm_label
|-- dev_type
|-- edac_mode
|-- mem_type
|-- size_mb
`-- ue_count
csrow2
...



with your patches we get:

rank0/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
`-- dimm_size
rank1/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
`-- dimm_size
rank2/
|-- dimm_dev_type
|-- dimm_edac_mode
|-- dimm_label
|-- dimm_location
|-- dimm_mem_type
`-- dimm_size
...


which splits the ch0 and ch1 of the csrow? dir above into ranks. All
fine and dandy but that doesn't change the whole situation - we simply
talk about ranks and not chip select rows anymore. Oh well...

Also, the following hierarchy looks ugly:

 ce_csrow0
 ce_csrow0_channel0
 ce_csrow0_channel1
 ce_csrow1
 ce_csrow1_channel0
 ce_csrow1_channel1
 ce_csrow2
 ce_csrow2_channel0
 ce_csrow2_channel1
 ce_csrow3
 ce_csrow3_channel0
 ce_csrow3_channel1

Much better would it be if you put the ch0 and ch1 CE error count into
the csrow?/ directory, i.e. something like:

csrow?/ce/ch{0,1}
csrow?/ue/ch{0,1}

so that all is clear just from looking at the directory structure. Or
put it into the rank?/ hierarchy and have all per-rank info in one
concentrated, self-describing location.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
