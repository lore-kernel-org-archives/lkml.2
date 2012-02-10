Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab2BJQj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:39:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab2BJQj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:39:56 -0500
Message-ID: <4F35484E.7030807@redhat.com>
Date: Fri, 10 Feb 2012 14:39:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tony.luck@intel.com
Subject: Re: [PATCH v3 00/31] Hardware Events Report Mecanism (HERM)
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com> <20120210132633.GA16783@aftab>
In-Reply-To: <20120210132633.GA16783@aftab>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 10-02-2012 11:26, Borislav Petkov escreveu:
> On Thu, Feb 09, 2012 at 10:00:59PM -0200, Mauro Carvalho Chehab wrote:
>> The old sysfs nodes are still supported. Latter patches will allow
>> disabling the old sysfs nodes.
> 
> I wouldn't remove those easily since they're documented as an EDAC
> interface in <Documentation/edac.txt> and, as such, are probably used by
> people.

Yes, deprecating it will take some kernel releases. The main client for it
is the edac-utils, but sysadmins may have their own scripts.

IMO, we should provide a Kconfig to allow disabling the legacy sysfs, but
keep it enabled by default. With time, we may remove it together with
the backport code.

> 
>> All errors currently generate the printk events, as before, but they'll
>> also generate perf events like:
> 
> This format needs a bit more massaging:
> 
>>
>>             bash-1680 [001] 152.349448: mc_error: [Hardware Error]:
>> mce#0: Uncorrected error FAKE ERROR on label "mc#0channel#2slot#2 "
>> (channel 2 slot 2 page 0x0 offset 0x0 grain 0 for EDAC testing only)
> 
> I don't see why the process and PID are relevant to the error reported
> so it should probably go. I dunno whether this can easily be done with
> the current ftrace code...

Yes, those data is not relevant. I dunno how this is implemented there.
Maybe someone more experienced with trace internal implementation 
could help us on this matter.

> 
>> kworker/u:5-198 [006] 1341.771535: mc_error_mce: mce#0: Corrected
>> error memory read error on label "CPU_SrcID#0_Channel#3_DIMM#0 "
>> (channel 0 slot 0 page 0x3a2db9 offset 0x7ac grain 32 syndrome
>> 0x0 CPU: 0, MCGc/s: 1000c14/0, MC5: 8c00004000010090, ADDR/MISC:
>> 00000003a2db97ac/00000020404c4c86, RIP: 00:<0000000000000000>, TSC: 0,
>> PROCESSOR: 0:206d6, TIME: 1328829250, SOCKET: 0, APIC: 0 1 error(s):
>> Unknown: Err=0001:0090 socket=0 channel=2/mask=4 rank=1)
> 
> This is too much, you probably only want to say:
> 
> 	Corrected DRAM read error on DIMM "CPU..."
> 
> The channel, slot, page etc should be only Kconfigurable for people who
> really need it.

Not sure if it is a good idea to remove those info via Kconfig, as this
would mean that the userspace parsers will need to be prepared to work
with both ways. It is probably better/easier to pass everything to
userspace, and add a filter there.

>>      kworker/u:5-198 [006] 1341.792536: mc_error_mce: mce#0: Corrected
>> error Can't discover the memory rank for ch addr 0x60f2a6d76 on
>> label "any memory" ( page 0x0 offset 0x0 grain 32 syndrome 0x0
>> CPU: 0, MCGc/s: 1000c14/0, MC5: 8c00004000010090, ADDR/MISC:
>> 0000000c1e54dab6/00000020404c4c86, RIP: 00:<0000000000000000>, TSC: 0,
>> PROCESSOR: 0:206d6, TIME: 1328829250, SOCKET: 0, APIC: 0 )
> 
> I guess we can report EDAC failures to map the DIMM properly like this.

Hmm... Yes, that may work, but changing all the drivers to provide the
information on that way is not simple.

There are two different situations here:

1) the driver knows that it was not able to detect the memory rank.
   all it needs to do is to fill the message like above. No issue at all.

2) the driver thinks that the information were decoded, but there's
   a bug there. This is what the "out-of-range" error message tracks.

Changing all drivers to provide a message like above for (2) requires
lots of changes and tests, on each driver, and will provide a very
little benefit:  if such error ever happens, the EDAC driver needs a 
fix, and the parsed information is not reliable (the mce one can still
be used). In such case, a bug against the driver should be filled.

There's no way for doing properly at core level, as the way to decode
such out-of-range bugs is memory-architecture dependent. So, something
like:
	"Can't discover the memory rank for ch addr 0x60f2a6d76"

Doesn't make much sense for FB-DIMM memory driver.

On such drivers, identifying the channel and the slot is easy: all it is 
needed is to check what AMB  were selected. However, identifying the
channel addr is not relevant on this case and some drivers aren't even
able to get such info, as the memory controller may be interlacing the
memories between different channels.

Also, an out of range information would mean that the driver maintainer
will need to fix something there. A message like:

	kernel: EDAC MC0: UE - no information available: INTERNAL ERROR 
	kernel: EDAC MC0: INTERNAL ERROR: channel-b out of range (4 >= 4)

(this is a real case example)

Is clearer for a driver maintainer than:

	Can't discover the memory rank for ch addr 0x60f2a6d76

As it points exactly what's wrong at the parser.

(in this specific example, the driver were able to get the proper error,
but the FBDIMM error call it were using required two channels, due to one
of the EDAC internal constraints). As most FB-DIMM drivers weren't able to
attribute an UE error to a single channel, the typical call were to pass
channel, channel + 1. In this specific MC, this is wrong.

>> New sysfs nodes are now provided, to match the real memory architecture.
> 
> ... and we need those because...?

Because manufacturers wanting to map their motherboards into EDAC is finding
a very bad time, as there's no easy way to map what they have with a random
driver-specific fake csrows/channel information. Anywone wanting to do such
mapping right now would need to read and understand the edac driver. The
only driver where such mapping is easy seems to be amd64_edac, as it doesn't
support FB-DIMMs, nor the memory controller abstracts csrows information or
provides more than 2 channels.

For example, on the above driver, there's no "channel-b". The error were
on branch 1, channel 1 of branch 1 (the third channel of the memory controller). 
The only way to discover it is after carefully analyzing the driver. So, anyone
trying to map what the motherboard's label DIMM 1D would quickly discover that
it means branch 1, channel 1, slot 1, but some drivers would map it as:

	csrow 3, channel 1	(branch, channel -> csrow; slot ->channel)
others as:
	csrow 7, channel 0	(branch, channel, slot -> csrow; channel always 0)
and others as:
	csrow 1, channel 3.	(slot -> csrow; branch, channel -> channel)

(yes, all 3 types of mapping exists at the drivers)

> 
>> For example, on a Sandy Bridge-EP machine, with up to 4 channels, and up
>> to 3 DIMMs per channel:
>>
>> /sys/devices/system/edac/mc/mc0/
>> ├── ce_channel0
>> ├── ce_channel0_slot0
>> ├── ce_channel0_slot1
>> ├── ce_channel0_slot2
>> ├── ce_channel1
>> ├── ce_channel1_slot0
>> ├── ce_channel1_slot1
>> ├── ce_channel1_slot2
>> ├── ce_channel2
>> ├── ce_channel2_slot0
>> ├── ce_channel2_slot1
>> ├── ce_channel2_slot2
>> ├── ce_channel3
>> ├── ce_channel3_slot0
>> ├── ce_channel3_slot1
>> ├── ce_channel3_slot2
>> ├── ce_count
>> ├── ce_noinfo_count
>> ├── dimm0
>> │   ├── dimm_dev_type
>> │   ├── dimm_edac_mode
>> │   ├── dimm_label
>> │   ├── dimm_location
>> │   ├── dimm_mem_type
>> │   └── dimm_size
>> ├── dimm1
>> │   ├── dimm_dev_type
>> │   ├── dimm_edac_mode
>> │   ├── dimm_label
>> │   ├── dimm_location
>> │   ├── dimm_mem_type
>> │   └── dimm_size
>> ├── fake_inject
>> ├── ue_channel0
>> ├── ue_channel0_slot0
>> ├── ue_channel0_slot1
>> ├── ue_channel0_slot2
>> ├── ue_channel1
>> ├── ue_channel1_slot0
>> ├── ue_channel1_slot1
>> ├── ue_channel1_slot2
>> ├── ue_channel2
>> ├── ue_channel2_slot0
>> ├── ue_channel2_slot1
>> ├── ue_channel2_slot2
>> ├── ue_channel3
>> ├── ue_channel3_slot0
>> ├── ue_channel3_slot1
>> ├── ue_channel3_slot2
>> ├── ue_count
>> └── ue_noinfo_count
>>
>> One of the above nodes allow testing the error report mechanism by
>> providing a simple driver-independent way to inject errors (fake_inject).
>> This node is enabled only when CONFIG_EDAC_DEBUG is enabled, and it
>> is limited to test the core EDAC report mechanisms, but it helps to
>> test if the tracing events are properly accredited to the right DIMMs.
> 
> What happens with the inject_* sysfs nodes which are in EDAC already?

Will keep there, as-is. This is just yet-another testing feature, and won't
interfere or superseed the existing ones.

> [..]
> 
>> The memory error handling function has now the capability of reporting
>> more than one dimm, when it is not possible to put the fingers into
>> a single place.
>>
>> For example:
>> 	# echo 1 >/sys/devices/system/edac/mc/mc0/fake_inject  && dmesg |tail -1
>> 	[ 2878.130704] EDAC MC0: CE FAKE ERROR on mc#0channel#1slot#0 mc#0channel#1slot#1 mc#0channel#1slot#2  (channel 1 page 0x0 offset 0x0 grain 0 syndrome 0x0 for EDAC testing only)
>>
>> All dimm memories present on channel 1 are pointed as one of them were
>> responsible for the error.
> 
> I don't see how this can be of any help? I like the EDAC failure message
> better: if we cannot map it properly for some reason, we tell so the
> user instead of generating some misleading data.

This is not a misleading data. Depending on how the ECC code is generated,
there's no way to point to a single dimm, because two or more memories are
used to produce the ECC data.

FB-DIMM memories can be in lockstep mode. If so, UE errors happen on a
memory pair.

If the system admin wants to quickly recover the machine, he needs to know
that replacing the 2 affected memories, the machine will work. He can later
put the affected memories on a separate hardware, using a single-channel
mode, in order to discover what's broken, but pointing to the two affected
memories helps him to recover quickly, while still allowing him to further
track where the problem is.

Btw, on Sandy Bridge, a memory can be on both lockstep and mirror mode. So,
if an UE error occurs, 4 DIMM's maybe affected.

> 
>>
>> With regards to the output, the errors are now reported on a more 
>> user-friendly way, e. g. the EDAC core will output:
>>
>> - the timestamp;
>> - the memory controller;
>> - if the error is corrected, uncorrected or fatal;
>> - the error message (driver specific, for example "read error", "scrubbing
>>   error", etc)
>> - the affected memory labels.
> 
> "labels"? See above, if we cannot report it properly, we better say so
> instead of misleading with multiple labels.

What the poor user is expected to do on such case, if it is not pointed to
some memories for him to test? Ok, we can improve the message to make it
clearer that likely just one of the pointed memories were affected, but 
letting him with no glue would be a nightmare for the users.

>> Other technical details are provided, inside parenthesis, in order to
>> allow hardware manufacturers, OEM, etc to have more details on it, and
>> discover what DRAM has problems, if they want/need to.
> 
> Exactly, "if they want/need to" sounds like a Kconfig option to me which
> can be turned on when needed.

I'm yet to know a real usecase where the user doesn't want that. He may not be
the final consumer of such data, but what we've seen, in practice, is that,
when people need to replace bad memory sticks, they go after the machine vendors,
asking for warranty replacement. The vendors usually request a more detailed 
info than just "dimm xxx is broken". The rest of the log helps them to show
what actually happened with the memories, and the vendor to verify that the
complain is pertinent.

Anyway, as I said before, the better would be that the userspace tool that
retrieves such data to have an option to show the details or not.

>> Ah, now that the memory architecture is properly represented, the DIMM
>> labels are automatically filled by the mc_alloc function call, in order
>> to properly represent the memory architecture.
>>
>> For example, in the case of Sandy Bridge, a memory can be described as:
>> 	mc#0channel#1slot#0
>>
>> This matches the way the memory is known inside the technical information,
>> and, hopefully, at the OEM manuals for the motherboard.
> 
> This is not always the case. You need the silkscreen labels from the
> board manufacturers as they do not always match with the DIMM topology
> from the hw vendor. OEM vendor BIOS should do this with a table of
> silkscreen labels or something.

Yes. However, as I've already explained, OEM vendors don't know what
"csrow 3, channel 2" means, as there are several different ways of mapping
channel#, slot# into csrow/channel, and there are at least 4 or 5 different
mapping logic inside the drivers.

If you take a look at the existing drivers that don't use csrow/channel,
as a general rule, each driver will to its own proprietary fake mapping,
with causes lots of problem for OEM's, as they need a hardware engineer
(and/or the hardware diagram) to get the real data, and a software engineer
to analyze the driver and map it into the EDAC's internal fake representation.

Regards,
Mauro.

