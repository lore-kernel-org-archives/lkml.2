Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2BLMI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 07:08:56 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:54764 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2BLMId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 07:08:33 -0500
Date: Sun, 12 Feb 2012 13:08:27 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tony.luck@intel.com
Subject: Re: [PATCH v3 00/31] Hardware Events Report Mecanism (HERM)
Message-ID: <20120212120827.GA32467@aftab>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
 <20120210132633.GA16783@aftab>
 <4F35484E.7030807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F35484E.7030807@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 02:39:42PM -0200, Mauro Carvalho Chehab wrote:
> IMO, we should provide a Kconfig to allow disabling the legacy sysfs, but
> keep it enabled by default. With time, we may remove it together with
> the backport code.

Yeah, why you want to remove them at all, actually? There wasn't any reason
specified.

[..]

> >> kworker/u:5-198 [006] 1341.771535: mc_error_mce: mce#0: Corrected
> >> error memory read error on label "CPU_SrcID#0_Channel#3_DIMM#0 "
> >> (channel 0 slot 0 page 0x3a2db9 offset 0x7ac grain 32 syndrome
> >> 0x0 CPU: 0, MCGc/s: 1000c14/0, MC5: 8c00004000010090, ADDR/MISC:
> >> 00000003a2db97ac/00000020404c4c86, RIP: 00:<0000000000000000>, TSC: 0,
> >> PROCESSOR: 0:206d6, TIME: 1328829250, SOCKET: 0, APIC: 0 1 error(s):
> >> Unknown: Err=0001:0090 socket=0 channel=2/mask=4 rank=1)
> > 
> > This is too much, you probably only want to say:
> > 
> > 	Corrected DRAM read error on DIMM "CPU..."
> > 
> > The channel, slot, page etc should be only Kconfigurable for people who
> > really need it.
> 
> Not sure if it is a good idea to remove those info via Kconfig, as this
> would mean that the userspace parsers will need to be prepared to work
> with both ways. It is probably better/easier to pass everything to
> userspace, and add a filter there.

As I said countless times already, the normal case is not interested
in so much information - they want to know only which DIMM caused the
error. Unless someone has compelling reasons to keep that info, I don't
want to burden the reporting path with unnecessary info.

> >>      kworker/u:5-198 [006] 1341.792536: mc_error_mce: mce#0: Corrected
> >> error Can't discover the memory rank for ch addr 0x60f2a6d76 on
> >> label "any memory" ( page 0x0 offset 0x0 grain 32 syndrome 0x0
> >> CPU: 0, MCGc/s: 1000c14/0, MC5: 8c00004000010090, ADDR/MISC:
> >> 0000000c1e54dab6/00000020404c4c86, RIP: 00:<0000000000000000>, TSC: 0,
> >> PROCESSOR: 0:206d6, TIME: 1328829250, SOCKET: 0, APIC: 0 )
> > 
> > I guess we can report EDAC failures to map the DIMM properly like this.
> 
> Hmm... Yes, that may work, but changing all the drivers to provide the
> information on that way is not simple.
> 
> There are two different situations here:
> 
> 1) the driver knows that it was not able to detect the memory rank.
>    all it needs to do is to fill the message like above. No issue at all.
> 
> 2) the driver thinks that the information were decoded, but there's
>    a bug there. This is what the "out-of-range" error message tracks.

That's not hard to fix at the driver level - see my other mail about the single
trace_hw_error thing.

> Changing all drivers to provide a message like above for (2) requires
> lots of changes and tests, on each driver, and will provide a very
> little benefit:  if such error ever happens, the EDAC driver needs a 
> fix, and the parsed information is not reliable (the mce one can still
> be used). In such case, a bug against the driver should be filled.
> 
> There's no way for doing properly at core level, as the way to decode
> such out-of-range bugs is memory-architecture dependent. So, something
> like:
> 	"Can't discover the memory rank for ch addr 0x60f2a6d76"
> 
> Doesn't make much sense for FB-DIMM memory driver.

This is exactly why the drivers themselves should create the error
message and stick it into the trace_* call.

[snip more]

I don't see a problem with the driver creating a proper/fitting error
message string and sticking it into the trace_* call.

> >> New sysfs nodes are now provided, to match the real memory architecture.
> > 
> > ... and we need those because...?
> 
> Because manufacturers wanting to map their motherboards into EDAC is finding
> a very bad time, as there's no easy way to map what they have with a random
> driver-specific fake csrows/channel information.

Not fake, they're actually chip select rows and channels == DRAM
controllers.

> Anywone wanting to do such
> mapping right now would need to read and understand the edac driver. The
> only driver where such mapping is easy seems to be amd64_edac, as it doesn't
> support FB-DIMMs, nor the memory controller abstracts csrows information or
> provides more than 2 channels.
> 
> For example, on the above driver, there's no "channel-b". The error were
> on branch 1, channel 1 of branch 1 (the third channel of the memory controller). 
> The only way to discover it is after carefully analyzing the driver. So, anyone
> trying to map what the motherboard's label DIMM 1D would quickly discover that
> it means branch 1, channel 1, slot 1, but some drivers would map it as:
> 
> 	csrow 3, channel 1	(branch, channel -> csrow; slot ->channel)
> others as:
> 	csrow 7, channel 0	(branch, channel, slot -> csrow; channel always 0)
> and others as:
> 	csrow 1, channel 3.	(slot -> csrow; branch, channel -> channel)
> 
> (yes, all 3 types of mapping exists at the drivers)

So what are you saying? I don't see how your a little bit changed
mapping helps. As I told you already, motherboard designers don't always
comply with the placing of the DIMM connectors to the hw vendor spec and
place the channel and slots routing in an conveniently increasing order.
Again, you need the silk screen labels the way the BIOS sees them.

[..]

> > What happens with the inject_* sysfs nodes which are in EDAC already?
> 
> Will keep there, as-is. This is just yet-another testing feature, and won't
> interfere or superseed the existing ones.

Then it should be made to use the existing ones or you should have a
compelling reason why you can't reuse the existing ones. If you really
need it, you should stick it in debugfs and behind a debugging Kconfig
option.

> >> The memory error handling function has now the capability of reporting
> >> more than one dimm, when it is not possible to put the fingers into
> >> a single place.
> >>
> >> For example:
> >> 	# echo 1 >/sys/devices/system/edac/mc/mc0/fake_inject  && dmesg |tail -1
> >> 	[ 2878.130704] EDAC MC0: CE FAKE ERROR on mc#0channel#1slot#0 mc#0channel#1slot#1 mc#0channel#1slot#2  (channel 1 page 0x0 offset 0x0 grain 0 syndrome 0x0 for EDAC testing only)
> >>
> >> All dimm memories present on channel 1 are pointed as one of them were
> >> responsible for the error.
> > 
> > I don't see how this can be of any help? I like the EDAC failure message
> > better: if we cannot map it properly for some reason, we tell so the
> > user instead of generating some misleading data.
> 
> This is not a misleading data. Depending on how the ECC code is generated,
> there's no way to point to a single dimm, because two or more memories are
> used to produce the ECC data.
> 
> FB-DIMM memories can be in lockstep mode. If so, UE errors happen on a
> memory pair.
> 
> If the system admin wants to quickly recover the machine, he needs to know
> that replacing the 2 affected memories, the machine will work. He can later
> put the affected memories on a separate hardware, using a single-channel
> mode, in order to discover what's broken, but pointing to the two affected
> memories helps him to recover quickly, while still allowing him to further
> track where the problem is.
> 
> Btw, on Sandy Bridge, a memory can be on both lockstep and mirror mode. So,
> if an UE error occurs, 4 DIMM's maybe affected.

This sounds very strange, a single UE from multiple DIMMs? Reading
through "4.2 Southbound Commands" of the JEDEC FBDIMM spec, on several
occasions it states that only single DIMMs are being addressed (DS[2:0]
field) when sending commands to them southwards.

@Tony: hey Tony, is it true that FBDIMM can actually do DIMM
interleaving when doing DIMM reads/writes and the ECC calculation is
done on words from different DIMMs? The statement that the ECC word
would effectively protect multiple DIMMs and when an error is reported,
it would mean "multiple DIMMs affected" sounds pretty strange for my
taste...

[..]

> > "labels"? See above, if we cannot report it properly, we better say so
> > instead of misleading with multiple labels.
> 
> What the poor user is expected to do on such case, if it is not pointed to
> some memories for him to test? Ok, we can improve the message to make it
> clearer that likely just one of the pointed memories were affected, but 
> letting him with no glue would be a nightmare for the users.

Why are you sticking so much to those error messages?! If your driver
is programmed properly, it should detect the DIMM in error just fine,
without any "out-of-range" issues or multiple labels. The error case
should be very very seldom and in such case, stating that we're in error
is fine!

> >> Other technical details are provided, inside parenthesis, in order to
> >> allow hardware manufacturers, OEM, etc to have more details on it, and
> >> discover what DRAM has problems, if they want/need to.
> > 
> > Exactly, "if they want/need to" sounds like a Kconfig option to me which
> > can be turned on when needed.
> 
> I'm yet to know a real usecase where the user doesn't want that. He may not be
> the final consumer of such data, but what we've seen, in practice, is that,
> when people need to replace bad memory sticks, they go after the machine vendors,
> asking for warranty replacement. The vendors usually request a more detailed 
> info than just "dimm xxx is broken". The rest of the log helps them to show
> what actually happened with the memories, and the vendor to verify that the
> complain is pertinent.
> 
> Anyway, as I said before, the better would be that the userspace tool that
> retrieves such data to have an option to show the details or not.

Right, let's see which of that bulk of additional info the machine
vendor could use:

     kworker/u:5-198   [006]  1341.771535: mc_error_mce: mce#0: Corrected error memory read error on label "CPU_SrcID#0_Channel#3_DIMM#0 " (channel 0
slot 0  page 0x3a2db9 offset 0x7ac grain 32 syndrome 0x0 CPU: 0, MCGc/s: 1000c14/0, MC5: 8c00004000010090, ADDR/MISC:
00000003a2db97ac/00000020404c4c86, RIP: 00:<0000000000000000>, TSC: 0, PROCESSOR: 0:206d6, TIME: 1328829250, SOCKET: 0, APIC: 0 1 error(s): Unknown:
Err=0001:0090 socket=0 channel=2/mask=4 rank=1)

- process name: hmm, no
- pid: nope,
- which logical processor saw the error: hmm, no
- label: oh yeah, this one it wants to know
- memory page: I don't think so
- offset, grain, syndrome: dunno, maybe or maybe not
- MCG, MC5 (it should be 4, btw), ADDR/MISC etc MCE bank MSRs: nah, not really
- TSC... not even worth mentioning

So, it looks to me, this info is only tangentially, if at all, important
to the machine vendor. So, add only the fields which are really
important instead of blindly dumping all we have into the trace and thus
bloating the trace unnecessarily and making it less usable.

> >> Ah, now that the memory architecture is properly represented, the DIMM
> >> labels are automatically filled by the mc_alloc function call, in order
> >> to properly represent the memory architecture.
> >>
> >> For example, in the case of Sandy Bridge, a memory can be described as:
> >> 	mc#0channel#1slot#0
> >>
> >> This matches the way the memory is known inside the technical information,
> >> and, hopefully, at the OEM manuals for the motherboard.
> > 
> > This is not always the case. You need the silkscreen labels from the
> > board manufacturers as they do not always match with the DIMM topology
> > from the hw vendor. OEM vendor BIOS should do this with a table of
> > silkscreen labels or something.
> 
> Yes. However, as I've already explained, OEM vendors don't know what
> "csrow 3, channel 2" means, as there are several different ways of mapping
> channel#, slot# into csrow/channel, and there are at least 4 or 5 different
> mapping logic inside the drivers.
> 
> If you take a look at the existing drivers that don't use csrow/channel,
> as a general rule, each driver will to its own proprietary fake mapping,
> with causes lots of problem for OEM's, as they need a hardware engineer
> (and/or the hardware diagram) to get the real data, and a software engineer
> to analyze the driver and map it into the EDAC's internal fake representation.

Let me put it clearer this time: I hardly doubt that having a bit
different nomenclature than CS and channel, i.e. MC, channel and slot
would help identify the DIMMs since board manufacturers don't always
lay out them as the hw vendors wish for a multitude of reasons. And I'd
guess the SB case is not different. But then again, adding those as a
generated string message which only the relevant drivers issue and it
doesn't affect the rest of the drivers is fine with me.

Not when there are new sysfs nodes which are valid only on those systems
and useless on others.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
