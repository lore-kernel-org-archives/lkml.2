Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1GBCXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 22:23:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37262 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab1GBCXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 22:23:11 -0400
MIME-Version: 1.0
Date: Sat, 2 Jul 2011 03:23:09 +0100
Message-ID: <CAPweEDzf+EoO0Tmg+ZQnNONEo8Z0jDuAOt8vbr19pimmPEc=oQ@mail.gmail.com>
Subject: ARM pain (ref: https://lkml.org/lkml/2011/3/17/492)
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linus, hi,

i've never written directly to you before, mostly to keep out of your way
until something i believed to be important came along, as well as having
thought for some time about a possible solution.  i almost didn't write
at all (various reasons) but after talking the problem over with a trusted
and technically-aware friend, he came up independently with pretty much
exactly the same solution.  so... here we go: preamble over, let's have
some fun...

> Gaah. Guys, this whole ARM thing is a f*cking pain in the ass.

 ha ha :)  took you long enough to wake up to that :)

> You need to stop stepping on each others toes.
> ...
> [more descriptions of insanity snipped]
> ...

> Somebody needs to get a grip in the ARM community.

 ahh, ok.  right.  here's where you're missing some perspective.  i've
 written several times about this, but let me reiterate it here.  ARM
 has over 650 licensed designs, and something like over 120 licensees.
 that's not 650 end-user products *based* on those 650+ CPUs, each of which
 is specially-tailored - that's _really_ 650 *wildly* different CPUs.

 [ok, someone from ARM will correct me: insert appropriate but still
  insanely large numbers well beyond the capability of linux
  kernel source management, such that it doesn't really matter what
  the numbers are]

 let me "spell things out" - you're probably aware of this (but many
 reading this in the future may not be) so please be patient.

 so - by contrast, in e.g. the x86 world, everything is sooo peachy that
 even RDC (http://rdc.com.tw) and XCore86 (CPU behind the norhtec gecko)
 and National Semi (designed the Geode, which AMD bought and then squandered)
 can just do a "drop-in" x86 clone and be done with it.  they can even
 run Windows XP (but they can't get anyone to buy because you can't
 buy Windows XP any more *lol* whoops digression...)

 in the ARM world, there _is_ no BIOS (the CPUs are just too radically
 different), there _is_ no Northbridge, no Southbridge, no "One Motherboard
 To Rule Them All"...

 so all of the nice "Standards" that revolve around x86 systems are
 completely, utterly out the window.  instead, every system that's made
 *has* to have hard-coded into it a complete and total system-level
 understanding of the hardware.

 to give a concrete example: i was one of the four/five or so people
 who was regularly doing reverse-engineering of HTC smartphones, back
 from around 2004 to 2006.  all of them ran WINCE.  they were shit,
 but were considered "great", as there certainly wasn't android around;
 the only linux smartphones at the time were f*****g expensive (having
 to include licenses for e.g. montavista linux, or qtopia, as well as
 having the up-front FCC GSM/3G certification fees of $50k) or they were GPL
 violators.  or, in some cases, they just went completely under
 everybody's radar (e.g. e28).

 anyway: we covered about 10 devices, with varying degrees of success.
 the most successful one was the HTC Universal.  it was basically a
 mini laptop, and it was an absolute corker.

 there are two reasons why i mention these devices.

 1) despite the CPU being the same (PXA273), and despite the devices
 sharing many ICs in common (including with the Compaq iPAQs which were
 also designed by HTC), and DESPITE the code being written by the
 same loosely-knit but close community, we STILL had to add over 150
 platform files to the 2.6.12 kernel tree (approx 15 per device), and
 that was WITH "consolidation" code shared amongst the devices (e.g.
 common gpio functions)

 russell of course completely freaked out, and that was just one small
 free software team, doing only 10 or so devices! :)

 2) the level of complexity behind this "simple" smartphone, was just
 f*****g unbelievable to anyone who is used to x86 hardware.  allow
 me to explain ["relax, linus: it's much worse than you think"].
 the pxa273 has (had) 110 GPIO pins.  with a keyboard matrix taking
 up 8+8 of those, and with each and every peripheral requiring its
 own "power-up" GPIO as well in some cases reset as well (because
 the main power lines simply couldn't cope if everything was turned
 on at once), those 110 GPIO pins simply weren't enough.  so, HTC
 commissioned a custom ASIC (which we named asic3), and it added
 64 more GPIO pins, as well as another UART and a couple of I2C and
 I2S interfaces.

 sadly, with there being SEVEN audio outputs as well as FIVE audio
 inputs (stereo speakers, top earpiece speaker, lid flip-side speaker,
 car speaker, stereo headphones, bluetooth headset - you get the
 message loud and clear), those extra 64 GPIO pins simply... weren't
 enough.

 so, HTC's engineers, being desperate, noticed that the GSM 3G
 chipset, which was on the other side of a /dev/ttyS0, *happened*
 to be also an ARM CPU from Ericsson, and it *happened* to have an
 extra 16 GPIO pins.  so, by communicating over the serial bus, they
 could dedicate those GPIO pins to things like detecting that the
 lid / screen had been flipped over, and also to power up the camera
 light!

 complete fucking madness.  190 GPIO pins, many of which had alternate
 functions, and it's "not enough".  and you're saying, now - some 5 years
 *after* that lot got successfully reverse-engineered - that "it's
 all too complicated"??

 well... duuuhhh! :)

> Somebody in the ARM community really needs to step up and tell people
> to stop dicking around.

 *lol*: i'd love to - but people don't listen to me: they read the words,
 and they hear something else, then go ballistic at what i categorically
 did not say.  or, they assume i must have a massive ego and must need
 "taking down a peg or two".  but that's another story.  on the other hand,
 such people will however listen to you... one might hope :)

 but seriously, can you see now, with the background above, how that's
 just simply... not going to happen?  the entire design ethos from the
 use of embedded processors where there *is* no commonality is the cause
 of the problem, and no amount of telling people to stop dicking around
 is going to end that.

 plus, as you're well aware, the CPU manufacturers (with notable
 exceptions) simply do not care: they want product out the door,
 they do the Reference Design (*without* consulting any of the
 leading linux kernel experts for each specialist ARM CPU family - with
 notable exceptions), then that gets bought by ODMs, who in many cases
 force their OEMs to sign NDAs; neither the ODMs nor the OEMs change
 the machine id; in many cases (and this is *not* a joke), the OEMs
 add extra devices (such as a webcam and a microphone) to the ODM's
 design... and then fucking well ship it with the original binary-only
 Reference Design Kernel!  web tablets turn up advertised as "web ready",
 on alibaba, where the web CAM and the web MIC don't fucking work!

 anyway: irritatingly, although the writing was clearly "on the wall" as
 far back as 2005, it's only really because of the popularity of android,
 as well as the fact that these so-called "embedded" processors are
 reaching into the general-purpose computing space that it's really
 become a mainstream issue.  [i.e. yeah, sure, you can ignore a CPU
 that's 5x to 20x slower than an x86, such as those 90mhz Cirrus
 Logic ARM CPUs, but you can't ignore a Dual-Core Cortex A9 that
 outperforms an x86 Atom which is still on Intel's mass-production list!]

 so what's a solution?  as is often the case, when a problem is clearly
 stated (despite appearances...), the clues are there.

 it's very simple: create standards, and enforce them.

 who does the standard creation?  that's not your job.

 who does the enforcement? you do, linus :)

 to clarify: i advocate that you consider creating a simple rule, which is
 that *any* two or more independent groups/individuals/organisations that
 become collaborators to create hardware-based "Standards", providing
 *at least* two, preferably three or more real-world devices that actually
 conform to those standards, be given top priority in the review / commit
 process for the linux kernel source code that they submit...

 [note for morons who like to misunderstand what i write: i DID NOT SAY
 "i advocate that collaborator-commits get absolute priority and work by them
 will of course be committed by linus WITHOUT proper review, just because
 they're collaborators".  i say this with the greatest of respect for all
 morons out there. hereendeththelesson...]

 and, that any submissions where collaboration is clearly *not* present be
 either automatically rejected or it be simply placed right at the back of the
 queue [i.e. effectively rejected]

 notable exceptions would include things like the beagleboard, the pandaboard,
 the IMX53 "QuickStart" developer kit (pretty much identical to the pandaboard)
 and so on, most notably because they already kinda fit the above proposed
 simple rule anyway: they _are_ a sort-of hardware standard (evidence for
 this being the IGEPv2 and the quickembed DEV8000 which are clones of the
 beagleboard, because Texas Instruments released even the beagleboard hardware
 design files under a Free Software License.  yaay!)

 _maybe_ directinsight.co.uk's SO-DIMM modules would qualify (despite them
 coming from a single ODM) because they have created a "Standard" which covers
 i believe it's now four separate CPUs, all of which can be slotted into
 exactly the same motherboard / chassis.  this is the sort of thing that
 should be encouraged.  [there's another guy in the U.S. who's done a stunning
 job like this... appx 50mm x 70mm CPU "module" cards, all of them
 interoperable, right across a massive range of widely disparate CPUs.
 darn it, can't remember the name of his company right now].

 additional notable exceptions would be x86 systems (and clones) because,
 again, even though Intel and AMD are competitors at each others' throats,
 the PC "BIOS", historical legacy reasons and to a large extent the w32 OS
 *forces* them to be collaborators, and to have Standards (de-facto,
 proprietary and reverse-engineered or otherwise), around which the linux
 kernel source code's "bang-per-buck" coverage ratio, on each commit, is
 effectively multiplied.

 so instead of the present situation being that you are faced with Hell On
 Earth, due to there being 50x to 100x more systems actually out there
 running the linux kernel than you can possibly cope with (all of them
 ARM or MIPS based), where they *might* be the possibility of getting
 the source code into the linux kernel *some* day, CPU designers as well
 as OEMs and ODMs would face a clear-cut situation: cooperate right from
 the hardware level to share resources, standards, ICs and designs, or expect
 to be running "on your own" [maintaining patches indefinitely using *their*
 money rather than spongeing off of limited free software community resources
 and patience]

 given that, e.g., freescale is presently maintaining linux kernel patches in
 excess of 5mb (and escalating) anyway, such a bluntly-stated situation would
 actually make everyone's lives easier: you just *know* that that code [from
 whatever non-collaborative CPU manufacturer or ODM] isn't going to get
 into the mainline kernel tree... ever :)

 so that's the proposal.  summary: situation in linux kernel isn't really
 due to lack of cooperation on the software side "per se", it's down to
 the absolute overwhelming hardware diversity and lack of standardisation,
 right from the CPU and it gets worse from there.  solution is therefore
 to encourage (with teeth) "Hardware Standardisation", such that any code that
 *is* committed has a higher "bang-per-buck" ratio of devices that (and
 ultimately end-users who) benefit from it, as well as a higher bang-per-buck
 ratio in terms of linux kernel developer maintenance metrics.

 long summary.  oh well.  it's a long post.  summary of summary: enforce
 standards, damnit!  there.  three words.  one of them a cuss-word.  yay!

 now, go home, get some sleep / breakfast, ignore everything else i say:
 i can just ramble on, from here [but along the same lines as above]

 disclaimer / disclosure: i've actually been working, for well over a year,
 as part of a small team on advocating to OEMs / ODMs as well as Retailers,
 *exactly* this: Hardware Standardisation :)  if you think it through, the
 benefits of standardisation on hardware designs are massive (there's
 enough precedents, i don't need to enumerate any), but in the ARM and
 MIPS world, nobody's "stepped up" to the "Standardisation" plate.  i cannot
 for the life of me understand why, when the benefits are so bluntly clear.

 take the following scenario: extend the concept that directinsight
 already have done (SO-DIMM form-factor with CPU+RAM on it), that the
 GPL-violating Chitech / Seatron CT-PC89E already has done (35x67mm SO-DIMM
 with CPU+RAM+NAND on it), that Telechips has already done (SO-DIMM with
 CPU+RAM), and extend it to *user-swappable* off-the-shelf CPU "modules",
 complete with appropriate amounts of RAM and an OS on the NAND (or, as is
 the case with the ODroids from hardkernel.com, on the MicroSD card).

 from a user's perspective: they can choose the product according to their
 budget and/or whim - swap out the CPU card or maybe buy a bigger chassis
 later when they can afford it.

 from an OEM's perspective: they are no longer forced to rely on one
 ODM for a Reference Design - they can get the CPU card design from one
 company and the chassis from another.  also, the software (especially
 linux kernel, due to the above-proposed rule, is much more likely to
 be in the mainstream linux kernel tree - a situation which is 98%
 *NOT* the case right now.  GPL violations are a massive endemic problem
 at the moment).

 from a fabless semiconductor CPU designer's perspective: the issue of
 being forced to spoon-feed OEMs with complete Reference Designs (of
 entire Tablet designs, and Laptop designs) is... like... _gone_!  because
 once some organisations somewhere have collaborated together to bring about
 a "Reference Design Chassis", then *any* CPU card designed to interoperate
 with the Standard around that Reference Design Chassis will simply...
 plug straight in.  and, clearly, any source code (kernels, operating systems)
 will require infinitely less work to get going.  benefit: faster time to
 market.

 ... but you know all this already: you only have to look at the process
 in the x86 world to appreciate how much more streamlined the whole
 thing is, and how absolutely everyone, right down to the end-user,
 benefits from the mass-production of modular components based around
 "standards".

 so why the FUCK is this situation not present in the ARM and MIPS
 community??

 sooo, meestur leenoous, your meeeshiun, should you chooose to accseept... :)

 i have a question for you.  are you prepared to act as the passive "bad guy",
 here, or are you willing to stick your neck out and influence things from
 the other side of the "linux kernel commit tree fence"?  translation:
 are you happy with the current situation of having to always say "no" to
 the ARM community, i.e. would you prefer to take a more active "positive"
 role, and be "leading by example" by being involved with or be an advocate
 for a project that actually _created_ a model hardware standard (using
 embedded CPUs) that other OEMs / ODMs / CPU manufacturers could then follow
 and learn from?

 the reason i ask is because i've been speaking to the Free Software
 Foundation, and _in principle_ (i.e. hypothetically, i.e. it hasn't been
 officially announced or decided, and is still in the "yeah that sounds like
 a good idea, what's the details?" stage) the hypothetical possibility of
 building a FSF-sponsored hardware platform that is compliant to the FSF
 "Hardware Endorsement" Criteria is hypothetically in its early hypothetical
 discussion phase.  purely hypothetically, of course.

 i discussed this with the FSF eek, some 4-6 months ago, and even though it
 was _only_ 4-6 months ago, what killed it was the fact that there simply
 weren't any viable cost-effective CPUs that didn't have proprietary
 encumbered fucking shit libraries (e.g. these fucking proprietary 3D
 graphics engines that are seriously, seriously pissing me and a boat-load
 of other free software people off).

 but, _just_ in the past month, a possible high-value, low-cost CPU has
 come out, from Ingenic, called the jz4770.  it's 1ghz, it's 65nm (low-power),
 it has *two* X-Burst Vector Processing Units (one at 1ghz for general
 purpose use e.g. 3D, the other at 500mhz for Video processing), it's MIPS
 compliant... the only thing it's missing when compared to all the other
 modern SoCs is that it doesn't have on-board HDMI (but it has the outputs
 required to create a full HDMI channel, with the right external IC).

 details here: http://en.ingenic.cn/product.aspx?ID=78

 the second most appropriate CPU which conforms to the FSF Hardware Endorsement
 Criteria is from Texas Instruments: the AM3703.  it's virtually a vanilla
 1ghz Cortex A8: it's "good enough".  there's no proprietary 3D graphics.

 between these two CPUs, it's possible to "standardise" on:

 * Ethernet
 * USB-2
 * SATA-II
 * I2C
 * some GPIO pins
 * RGB/TTL 24-pin (LCD driver)

 based around that "grouping", any CPU card or motherboard (on each side
 of the software fence) which conforms to this set of interfaces is
 greatly simplified.  it's no longer N * M (N=CPUs, M=chassis), it's N + M +
 a little bit of common shared code, exactly wot like you arsked for,
 sir :)

 the motherboard therefore converts the RGB/TTL into LVDS (to drive the
 LCD panel) or it converts that to VGA, it has WIFI, Keyboard, USB, and
 connectors - all that jazz.  it's a "standard" - it's a start :)

 what's nice is that this "standard" can also provide a Desktop and/or
 "Plug Computer" chassis which could become the basis of a "Freedom Box"
 (no, confusingly, the "FreedomBox" project is *not* about creating an
  actual "box", it's about creating the software that goes into the
  box.  er.  so... there's no actual box which exists at the envisaged
  target price of $20 to $30, for the FreedomBox.  er... riiiight :)

 also: the jz4770 is two generations along from the CPU that was used in
 the "Ben Nanonote" - a successful hardware project from qi-hardware.com
 that is released entirely under a Free Software License.  and, the AM3703
 is from Texas Instruments, who have a signficant track record in engaging
 with the Free Software Community and respecting the principles of
 cooperation and collaboration, and this really should be recognised and
 encouraged, despite the incomprehensibly high list price mark-ups on
 some of their CPUs, when compared to their competitors :)

 so there is a lot of tie-in and possibilities for a large community
 base, similar to the OpenPandora and the OpenMoko, as well as a clear
 benefit and easing of the situation in the embedded linux kernel
 development process... if only someone who is actually respected _by_
 the free software community would step up and advocate it and get the
 bloody ball rolling.

 so.

 i kept this absolutely quiet, going privately "how bloody ironic that
 the project i've been working on for a year fits in with what linus is
 complaining about :)", because it would appear to be self-serving if i
 were to mention it.  then, as i said, i talked with my friend, and he
 *independently* said "you know what: the solution is to enforce
 hardware standards onto the OEMs", and at that point i realised that
 i had to get over the misgivings and just write.

 sorry it's a bit long - it happens.  a lot.

 l.
