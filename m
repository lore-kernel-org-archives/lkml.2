Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab2BJN0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:26:38 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48675 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab2BJN0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:26:37 -0500
Date: Fri, 10 Feb 2012 14:26:33 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, bp@amd64.org,
        tony.luck@intel.com
Subject: Re: [PATCH v3 00/31] Hardware Events Report Mecanism (HERM)
Message-ID: <20120210132633.GA16783@aftab>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 10:00:59PM -0200, Mauro Carvalho Chehab wrote:
> The old sysfs nodes are still supported. Latter patches will allow
> disabling the old sysfs nodes.

I wouldn't remove those easily since they're documented as an EDAC
interface in <Documentation/edac.txt> and, as such, are probably used by
people.

> All errors currently generate the printk events, as before, but they'll
> also generate perf events like:

This format needs a bit more massaging:

>
>             bash-1680 [001] 152.349448: mc_error: [Hardware Error]:
> mce#0: Uncorrected error FAKE ERROR on label "mc#0channel#2slot#2 "
> (channel 2 slot 2 page 0x0 offset 0x0 grain 0 for EDAC testing only)

I don't see why the process and PID are relevant to the error reported
so it should probably go. I dunno whether this can easily be done with
the current ftrace code...

> kworker/u:5-198 [006] 1341.771535: mc_error_mce: mce#0: Corrected
>error memory read error on label "CPU_SrcID#0_Channel#3_DIMM#0 "
>(channel 0 slot 0 page 0x3a2db9 offset 0x7ac grain 32 syndrome
>0x0 CPU: 0, MCGc/s: 1000c14/0, MC5: 8c00004000010090, ADDR/MISC:
>00000003a2db97ac/00000020404c4c86, RIP: 00:<0000000000000000>, TSC: 0,
>PROCESSOR: 0:206d6, TIME: 1328829250, SOCKET: 0, APIC: 0 1 error(s):
>Unknown: Err=0001:0090 socket=0 channel=2/mask=4 rank=1)

This is too much, you probably only want to say:

	Corrected DRAM read error on DIMM "CPU..."

The channel, slot, page etc should be only Kconfigurable for people who
really need it.

>      kworker/u:5-198 [006] 1341.792536: mc_error_mce: mce#0: Corrected
> error Can't discover the memory rank for ch addr 0x60f2a6d76 on
> label "any memory" ( page 0x0 offset 0x0 grain 32 syndrome 0x0
> CPU: 0, MCGc/s: 1000c14/0, MC5: 8c00004000010090, ADDR/MISC:
> 0000000c1e54dab6/00000020404c4c86, RIP: 00:<0000000000000000>, TSC: 0,
> PROCESSOR: 0:206d6, TIME: 1328829250, SOCKET: 0, APIC: 0 )

I guess we can report EDAC failures to map the DIMM properly like this.

> New sysfs nodes are now provided, to match the real memory architecture.

... and we need those because...?

> For example, on a Sandy Bridge-EP machine, with up to 4 channels, and up
> to 3 DIMMs per channel:
> 
> /sys/devices/system/edac/mc/mc0/
> ├── ce_channel0
> ├── ce_channel0_slot0
> ├── ce_channel0_slot1
> ├── ce_channel0_slot2
> ├── ce_channel1
> ├── ce_channel1_slot0
> ├── ce_channel1_slot1
> ├── ce_channel1_slot2
> ├── ce_channel2
> ├── ce_channel2_slot0
> ├── ce_channel2_slot1
> ├── ce_channel2_slot2
> ├── ce_channel3
> ├── ce_channel3_slot0
> ├── ce_channel3_slot1
> ├── ce_channel3_slot2
> ├── ce_count
> ├── ce_noinfo_count
> ├── dimm0
> │   ├── dimm_dev_type
> │   ├── dimm_edac_mode
> │   ├── dimm_label
> │   ├── dimm_location
> │   ├── dimm_mem_type
> │   └── dimm_size
> ├── dimm1
> │   ├── dimm_dev_type
> │   ├── dimm_edac_mode
> │   ├── dimm_label
> │   ├── dimm_location
> │   ├── dimm_mem_type
> │   └── dimm_size
> ├── fake_inject
> ├── ue_channel0
> ├── ue_channel0_slot0
> ├── ue_channel0_slot1
> ├── ue_channel0_slot2
> ├── ue_channel1
> ├── ue_channel1_slot0
> ├── ue_channel1_slot1
> ├── ue_channel1_slot2
> ├── ue_channel2
> ├── ue_channel2_slot0
> ├── ue_channel2_slot1
> ├── ue_channel2_slot2
> ├── ue_channel3
> ├── ue_channel3_slot0
> ├── ue_channel3_slot1
> ├── ue_channel3_slot2
> ├── ue_count
> └── ue_noinfo_count
> 
> One of the above nodes allow testing the error report mechanism by
> providing a simple driver-independent way to inject errors (fake_inject).
> This node is enabled only when CONFIG_EDAC_DEBUG is enabled, and it
> is limited to test the core EDAC report mechanisms, but it helps to
> test if the tracing events are properly accredited to the right DIMMs.

What happens with the inject_* sysfs nodes which are in EDAC already?

[..]

> The memory error handling function has now the capability of reporting
> more than one dimm, when it is not possible to put the fingers into
> a single place.
> 
> For example:
> 	# echo 1 >/sys/devices/system/edac/mc/mc0/fake_inject  && dmesg |tail -1
> 	[ 2878.130704] EDAC MC0: CE FAKE ERROR on mc#0channel#1slot#0 mc#0channel#1slot#1 mc#0channel#1slot#2  (channel 1 page 0x0 offset 0x0 grain 0 syndrome 0x0 for EDAC testing only)
> 
> All dimm memories present on channel 1 are pointed as one of them were
> responsible for the error.

I don't see how this can be of any help? I like the EDAC failure message
better: if we cannot map it properly for some reason, we tell so the
user instead of generating some misleading data.

> 
> With regards to the output, the errors are now reported on a more 
> user-friendly way, e. g. the EDAC core will output:
> 
> - the timestamp;
> - the memory controller;
> - if the error is corrected, uncorrected or fatal;
> - the error message (driver specific, for example "read error", "scrubbing
>   error", etc)
> - the affected memory labels.

"labels"? See above, if we cannot report it properly, we better say so
instead of misleading with multiple labels.
> 
> Other technical details are provided, inside parenthesis, in order to
> allow hardware manufacturers, OEM, etc to have more details on it, and
> discover what DRAM has problems, if they want/need to.

Exactly, "if they want/need to" sounds like a Kconfig option to me which
can be turned on when needed.
> 
> Ah, now that the memory architecture is properly represented, the DIMM
> labels are automatically filled by the mc_alloc function call, in order
> to properly represent the memory architecture.
> 
> For example, in the case of Sandy Bridge, a memory can be described as:
> 	mc#0channel#1slot#0
> 
> This matches the way the memory is known inside the technical information,
> and, hopefully, at the OEM manuals for the motherboard.

This is not always the case. You need the silkscreen labels from the
board manufacturers as they do not always match with the DIMM topology
from the hw vendor. OEM vendor BIOS should do this with a table of
silkscreen labels or something.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
