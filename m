Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1CaFG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 01:06:29 -0400
Received: from mail.lang.hm ([64.81.33.126]:53573 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab1CaFG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 01:06:27 -0400
Date: Wed, 30 Mar 2011 22:05:41 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Nicolas Pitre <nico@fluxnic.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <alpine.LFD.2.00.1103302255280.28032@xanadu.home>
Message-ID: <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com> <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
 <alpine.LFD.2.00.1103302255280.28032@xanadu.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Nicolas Pitre wrote:

> On Wed, 30 Mar 2011, david@lang.hm wrote:
>
>> On Wed, 30 Mar 2011, Nicolas Pitre wrote:
>>
>
>> this means that you need to have some group doing the equivalent of assigning
>> device numbers for the different devices (and in this case going just a little
>> further to define what setup parameters will be needed), initially this may be
>> a little rough, but after a very short time I would expect the people doing
>> this work to start recognising that even though vendor A who first proposes
>> this device has some things hard-wired, the definition format should support
>> these things as variables instead of being assumed.
>
> Ideally, yes.  but if every vendor has a different set of peripherals,
> and from one SOC revision to the next from the same vendor you still
> have different hardware knobs, then you still have to add yet more code
> to the kernel.  And that doesn't solve the issue of dynamic clock and
> power management at runtime either for which custom code is still
> required.
>
> As long as SOC vendors keep producing wildly different architectures
> besides the core CPU we'll have this problem.  Denying the reality won't
> make that problem go away either.  And device tree won't stop those
> vendor from still trying to do things differently (better?) because they
> are not constrained by having to ensure this single proprietary software
> stack still boot.

the thing that you are not convincing us of is that all these different 
SoCs are so wildly different architectures.

back in the early days of the PCs, different systems from different 
vendors had different bus types, peripherals at different addresses, etc. 
that didn't make all of those vendors systems different architectures, 
instead those things were varients of the x86 architecture.

with ARM you do have a couple different architectures (arm5 vs arm7 for 
example), but what you are hearing people say is that

arm7+IPblock1+IPblock2
arm7+IPblock1+IPblock3>
arm7+IPblock2+IPblock3>

are not three different architectures, they are one architecture with 
different devices attached.

what's more, you seem to be saying that

arm7+IPblock1

and

arm7+IPblock1

are different architectures if the wiring between the arm core and 
IPblock1 are different (they are different 'boards' or different chip 
models, possibly from different manufacturers)

I see the variations here as a good thing, just like having a huge number 
of pluggable cards in a PC was a good thing (even though it made it hard 
to have an OS that supports every card out there)

in the case of the PC, systems that were too different died off, systems 
that could have their differences abstracted into different 
drivers prospered.

I am _not_ saying that all arm systems need to standardize on one 
interrupt controller, I am saying that the kernel support for ARM needs to 
be able to _easily_ be told that this chip has interrupt chip type 24 
connected this way, and interrupt chip type 87 connected that way, without 
needing to create a new architecture. If the kernel is compiled with the 
appropriate drivers, it should even be able to be done without needing to 
recompile the kernel.

Now I understand that this isn't how things are done today in ARM, but 
that's not how things were done 10 years ago in x86 either. back then you 
had kernels compiled specifically for each system. nowdays that is still 
done where space or performance is critical, but a huge number of systems 
sacrafice a few % of speed, and some storage and ram for the flexibility 
and supportability of using a one-size-fits-many kernel (along with a 
large number of loadable modules)

why can't ARM do this?


look at serial port support on x86.

while serial ports are becoming rare nowdays, the kernel has support for 
_many_ different types of ports, and all of the port types support being 
wired up in different ways (to different addresses and interrupts)

the kernel could have gone the route that ARM did of having a master 
config that listed every system known and where it's serial ports were 
wired, but thanks to the fact that many of these were plug-in options, 
that would have been painful enough that it drove them to do it the right 
way.

take ARM down a similar path, treat the on-chip devices in a similar way 
to off-chip devices.

define the different types of GPIO behavior in arch-level drivers and make 
the chip-level (or board level) definitions say "I have a type 6 GPIO 
device wired this way" instead of including an entire GPIO driver in that 
definition.


what is happening in ARM is being driven by the short-term ease of the 
chip manufacturers, they do things any way they want, and their engineers 
cut-n-paste their way to make things work as a new architecture.

in the long run, making things more flexible and easier for the device 
designers and the people modifying the designs down the road will grow the 
pie by making it much easier for people to drop an ARM onto a new design, 
add a smattering of random (to the chip manufacturer) chips to do various 
things, and get linux running on the result.

get it down to where a new board can be designed by a guy in his garage, 
with a linux ARM distro able to run out of the box on it (with the 
appropriate definitions of how the guy wired it), and the variations will 
proliferate to the point where the current variation in ARM will look 
trivial by comparison, and the result will be even more use (and therefor 
sales) of ARM chips in all sorts of things that nobody can imagine today.




I'm working on projects that are small embedded systems, right now it's a 
big-boy's game. If you want to do a small project you better copy the 
reference board pretty closely or have a lot of kernel hacking ability 
(along with the ability to convince the management types that you can do 
this). In my project I lost the argument and instead of using ARM and 
linux the people funding things opted to go with a propriatary OS from the 
chip vendor instead. this maze is costing users and developers.

Turn things around and make it easier to have more variations and you will 
get more support from all directions.

David Lang
