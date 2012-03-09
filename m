Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab2CIKcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 05:32:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab2CIKca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 05:32:30 -0500
Message-ID: <4F59DC38.5080104@redhat.com>
Date: Fri, 09 Mar 2012 07:32:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com> <20120308215716.GA5925@aftab>
In-Reply-To: <20120308215716.GA5925@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 08-03-2012 18:57, Borislav Petkov escreveu:
> On Wed, Mar 07, 2012 at 08:40:32AM -0300, Mauro Carvalho Chehab wrote:
>> Prepare the internal structures to represent the memory properties per dimm, 
>> instead of per csrow. 
>>
>> This is needed for modern controllers with more than 2 channels, as the memories 
>> at the same slot number but on different channels (or channel pairs) may be 
>> different.
> 
> Ok, so I this thing looks pretty fishy to me. I've booted it on a box which has
> the following config on the first memory controller:
> 
> [   12.058897] EDAC MC: DCT0 chip selects:
> [   12.063091] EDAC amd64: MC: 0:  2048MB 1:  2048MB
> [   12.068155] EDAC amd64: MC: 2:  2048MB 3:  2048MB
> [   12.073219] EDAC amd64: MC: 4:     0MB 5:     0MB
> [   12.078281] EDAC amd64: MC: 6:     0MB 7:     0MB
> [   12.093305] EDAC MC: DCT1 chip selects:
> [   12.097499] EDAC amd64: MC: 0:  2048MB 1:  2048MB
> [   12.102562] EDAC amd64: MC: 2:  2048MB 3:  2048MB
> [   12.107623] EDAC amd64: MC: 4:     0MB 5:     0MB
> [   12.112690] EDAC amd64: MC: 6:     0MB 7:     0MB
> 
> Yes, 2 dual-ranked DIMMs per MCT, i.e. 4 DIMMs in the DIMM slots on the
> node (+ 4 more for the other MCT because it is a dual-node CPU). With
> your patchset I got 8 ranks, 1024MB each, not good.

Hmm... it seems it is dividing the memory size by the number of hanks.

I think that the error is on this patch:
	[PATCH 1/2] edac: Fix core support for MC's that see DIMMS instead of ranks

This hunk seems wrong:

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 377eed8..ea7eb9a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2187,7 +2227,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 		for (j = 0; j < pvt->channel_count; j++) {
 			csrow->channels[j].dimm->mtype = mtype;
 			csrow->channels[j].dimm->edac_mode = edac_mode;
-			csrow->channels[j].dimm->nr_pages = nr_pages;
+			csrow->channels[j].dimm->nr_pages = nr_pages / pvt->channel_count;
 
 		}

> 
> $ tree /sys/devices/system/edac/mc/mc0/rank?/
> /sys/devices/system/edac/mc/mc0/rank0/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> `-- dimm_size
> /sys/devices/system/edac/mc/mc0/rank1/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> `-- dimm_size
> /sys/devices/system/edac/mc/mc0/rank2/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> `-- dimm_size
> /sys/devices/system/edac/mc/mc0/rank3/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> `-- dimm_size
> /sys/devices/system/edac/mc/mc0/rank4/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> `-- dimm_size
> /sys/devices/system/edac/mc/mc0/rank5/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> `-- dimm_size
> /sys/devices/system/edac/mc/mc0/rank6/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> `-- dimm_size
> /sys/devices/system/edac/mc/mc0/rank7/
> |-- dimm_dev_type
> |-- dimm_edac_mode
> |-- dimm_label
> |-- dimm_location
> |-- dimm_mem_type
> `-- dimm_size

Ok, 8 ranks were filled.

> Also, what does the nomenclature
> 
> [   12.196138] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: dimm0 (0:0:0): row 0, chan 0
> [   12.204636] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: dimm1 (0:1:0): row 0, chan 1
> [   12.213127] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: dimm2 (1:0:0): row 1, chan 0
> [   12.221613] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: dimm3 (1:1:0): row 1, chan 1
> [   12.230103] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: dimm4 (2:0:0): row 2, chan 0
> [   12.238590] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: dimm5 (2:1:0): row 2, chan 1
> [   12.247078] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: dimm6 (3:0:0): row 3, chan 0
> [   12.255560] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: dimm7 (3:1:0): row 3, chan 1
> [   12.264058] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 8: dimm8 (4:0:0): row 4, chan 0
> [   12.272552] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 9: dimm9 (4:1:0): row 4, chan 1
> [   12.281041] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 10: dimm10 (5:0:0): row 5, chan 0
> [   12.289699] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 11: dimm11 (5:1:0): row 5, chan 1
> [   12.298362] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 12: dimm12 (6:0:0): row 6, chan 0
> [   12.307018] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 13: dimm13 (6:1:0): row 6, chan 1
> [   12.315684] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 14: dimm14 (7:0:0): row 7, chan 0
> [   12.324352] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 15: dimm15 (7:1:0): row 7, chan 1
> 
> mean? 16 DIMMs? No way.

The debug message needs to be fixed. The above message shows how many ranks were
allocated, and not DIMMs. That means that patch 5/6 of the last series is incomplete,
as it doesn't touch on the debug messages.

This debug info has the purpose of showing how the dimm or rank real location
is mapped into the virtual csrow/channel notation.

>From your logs, the machine you're testing has 16 ranks, so, except for the
debug log fix, it is properly detecting everything.

The rank location (the number in parenthesis) is being mapped to the right
row/channel. On this MC, the location has just 2 addresses, so, the above
message is showing "0" for the third location, as expected on this debug msg.

On a machine where the csrow/channel is virtualized, the above map would be 
different. For example, on a machine with the i5000 Memory Controller, the
memory is organized as:

       +-----------------------------------------------+
       |                      mc0                      |
       |        branch0        |        branch1        |
       | channel0  | channel1  | channel0  | channel1  |
-------+-----------------------------------------------+
slot3: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
slot2: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
-------+-----------------------------------------------+
slot1: |     0 MB  |     0 MB  |     0 MB  |     0 MB  |
slot0: |   512 MB  |   512 MB  |   512 MB  |   512 MB  |
-------+-----------------------------------------------+

This is the map for it (in this case, the debug is correct, as the memory is organized
per dimm):

[   16.946841] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 0: dimm0 (0:0:0): row 0, chan 0
[   16.946845] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 1: dimm1 (0:0:1): row 0, chan 1
[   16.946848] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 2: dimm2 (0:0:2): row 0, chan 2
[   16.946852] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 3: dimm3 (0:0:3): row 0, chan 3
[   16.946855] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 4: dimm4 (0:1:0): row 1, chan 0
[   16.946859] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 5: dimm5 (0:1:1): row 1, chan 1
[   16.946862] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 6: dimm6 (0:1:2): row 1, chan 2
[   16.946866] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 7: dimm7 (0:1:3): row 1, chan 3
[   16.946869] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 8: dimm8 (1:0:0): row 2, chan 0
[   16.946873] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 9: dimm9 (1:0:1): row 2, chan 1
[   16.946876] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 10: dimm10 (1:0:2): row 2, chan 2
[   16.946880] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 11: dimm11 (1:0:3): row 2, chan 3
[   16.946883] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 12: dimm12 (1:1:0): row 3, chan 0
[   16.946887] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 13: dimm13 (1:1:1): row 3, chan 1
[   16.946890] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 14: dimm14 (1:1:2): row 3, chan 2
[   16.946894] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 15: dimm15 (1:1:3): row 3, chan 3

It means that, on this driver, the dimm that it is at branch 1, channel 0
slot 0 is mapped, according with this debug message:
	[   16.946869] EDAC DEBUG: edac_mc_alloc: edac_mc_alloc: 8: dimm8 (1:0:0): row 2, chan 0
as row 2, channel 0, on the per-csrow node:

/sys/devices/system/edac/mc/mc0/csrow2/ch0_dimm_label:mc#0branch#1channel#0slot#0

> Basically, the problem with the DIMM nomenclature is that you cannot
> know from the hardware how many chip selects, aka ranks, comprise
> one DIMM. IOW, you cannot know whether your DIMMs are single-ranked,
> dual-ranked or quad-ranked and thus you cannot combine the csrows into
> DIMM structs.

This may not be possible on amd64 hardware, but there are other memory
controllers that allow it. On several ones, the registers are per DIMM,
and there are fields there that counts the number of ranks per dimm.

There are other memory controllers that use a simpler strategy: they only
support single or dual ranks, and the even ranks are always used for the
second rank on the same DIMM. On them, if you divide csrow by 2, you got
the DIMM.

On this patch series, I didn't add any logic on the existing drivers to
convert the ones that internally represent memories as ranks into DIMMs.

Instead, the internal representation can be either per dimm or per rank.

I was tempted to fix it, as it sucks that the core would allow two 
different ranks from the same dimm to receive different labels (and
I even made some patches internally, fixing it for a few drivers), but
I ended to simplify the approach and add patch 5/6 to address the
duality.

After having this series applied, I'll likely convert a few drivers to
represent memories per DIMM, instead of per rank.

That would mean to convert the csrow location field inside the dimm struct
into an array with 4 elements, in order to support 1, 2 and 4R memories and
properly represent its location, and to add a way for the driver to tell
the EDAC core how ranks are mapped into DIMMs.

Regards,
Mauro
