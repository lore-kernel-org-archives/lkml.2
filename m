Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2KFTe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:34:59 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:43378 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546Ab2KFTe5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:34:57 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com>
Date: Tue, 6 Nov 2012 20:34:30 +0100
Cc: Rob Herring <robherring2@gmail.com>, Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A5170602-2AE7-4EC4-BE0F-0DF015A287D7@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com> <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Nov 6, 2012, at 12:14 PM, Grant Likely wrote:

> On Tue, Nov 6, 2012 at 10:30 AM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
>> Hi Grant,
>> 
>> On Nov 5, 2012, at 9:40 PM, Grant Likely wrote:
>> 
>>> Hey folks,
>>> 
>>> As promised, here is my early draft to try and capture what device
>>> tree overlays need to do and how to get there. Comments and
>>> suggestions greatly appreciated.
>>> 
>>> Device Tree Overlay Feature
>>> 
>>> Purpose
>>> =======
>>> Sometimes it is not convenient to describe an entire system with a
>>> single FDT. For example, processor modules that are plugged into one or
>>> more modules (a la the BeagleBone), or systems with an FPGA peripheral
>>> that is programmed after the system is booted.
>>> 
>>> For these cases it is proposed to implement an overlay feature for the
>>> so that the initial device tree data can be modified by userspace at
>>> runtime by loading additional overlay FDTs that amend the original data.
>>> 
>>> User Stories
>>> ============
>>> Note - These are potential use cases, but just because it is listed here
>>> doesn't mean it is important. I just want to thoroughly think through the
>>> implications before making design decisions.
>>> 
>>> 
>>> Jane is building custom BeagleBone expansion boards called 'capes'. She
>>> can boot the system with a stock BeagleBoard device tree, but additional
>>> data is needed before a cape can be used. She could replace the FDT file
>>> used by U-Boot with one that contains the extra data, but she uses the
>>> same Linux system image regardless of the cape, and it is inconvenient
>>> to have to select a different device tree at boot time depending on the
>>> cape.
>>> 
>>> Jane solves this problem by storing an FDT overlay for each cape in the
>>> root filesystem. When the kernel detects that a cape is installed it
>>> reads the cape's eeprom to identify it and uses request_firmware() to
>>> obtain the appropriate overlay. Userspace passes the overlay to the
>>> kernel in the normal way. If the cape doesn't have an eeprom, then the
>>> kernel will still use firmware_request(), but userspace needs to already
>>> know which cape is installed.
>> 
>> Jane is a really productive hardware engineer - she manages to fix a
>> number of problems with her cape design by spinning different revisions
>> of the cape. Using the flexibility that the DT provides, documents and
>> defines the hardware changes of the cape revisions in the FDT overlay.
>> The loader matches the revision of the cape with the proper FDT overlay
>> so that the drivers are relieved of having to do revision management.
> 
> Okay
> 
>>> By installing dtc on the Pi, Mandy compiles the overlay for her
>>> prototype hardware. However, she doesn't have a copy of the Pi's
>>> original FDT source, so instead she uses the dtc 'fs' input format to
>>> compile the overlay file against the live DT data in /proc.
>> 
>> Jane (the cape designer) can use this too. Developing the cape, she really
>> appreciates that she doesn't have to reboot every time she makes a change
>> in the cape hardware. By removing the FDT overlay, compiling with the dtc
>> on the board, and re-inserting the overlay, she can be more productive by
>> waiting less.
> 
> Yes, but I'll leave this paragraph out of the spec. It isn't
> significantly different from what is already there.
> 

No problem.

>> Johnny, Jane's little son, doesn't know anything about device trees, linux
>> kernel trees, or hard-core s/w engineering. He is a bright kid, and due to
>> the board having a node.js based educational electronic design kit, he
>> can use the web-based simplified development environment, that allows
>> him graphically to connect the parts in his kit. He can save the design
>> and the IDE creates on the fly the DT overlay for later use.
> 
> Yes.
> 
>>> Joanne has purchased one of Jane's capes and packaged it into a rugged
>>> case for data logging. As far as Joanne is concerned, the BeagleBone and
>>> cape together are a single unit and she'd prefer a single monolithic FDT
>>> instead of using an FDT overlay.
>>> Option A: Using dtc, she uses the BeagleBone and cape .dts source files
>>>         to generate a single .dtb for the entire system which is
>>>         loaded by U-Boot. -or-
>> Unlikely.
>>> Option B: Joanne uses a tool to merge the BeagleBone and cape .dtb files
>>>         (instead of .dts files), -or-
>> Possible but low probability.
>>> Option C: U-Boot loads both the base and overlay FDT files, merges them,
>>>         and passes the resolved tree to the kernel.
>> Could be made to work. Only really required if Joanne wants the
>> cape interface to work for u-boot too. For example if the cape has some
>> kind of network interface that u-boot will use to boot from.
> 
> Unlikely for your focus perhaps, but I'm trying to capture all the
> relevant permutations, and I can guarantee that some people really
> will want this. If not on the bone, then on some other platform.
> 

No problem there. Certainly they are valid scenarios.

>>> Summary points:
>>> - Create an FDT overlay data format and usage model
>>> - SHALL reliable resolve or validate of phandles between base and
>>>   overlay trees
>>> - SHOULD reliably handle changes between different underlying overlays
>>>   (ie. what happens to existing .dtb overly files if the structure of
>>>   the dtb it is layered over changes. If not possible, then SHALL
>>>   detect when the base tree doesn't match and refuse to apply the
>>>   overlay.
>>> - dts syntax needs to be extended for overlay .dtb files
>>> - DTC tool needs to be modified to support overlay .dtb generation
>>> - Overlays SHOULD be able to be applied either by firmware or the kernel
>>> - libfdt SHALL be extended to parse and apply overlays
>> 
>> - ftdump should be fixed and work for the overlay syntax too.
> 
> Okay
> 
>> This is much grander in vision that I had in mind :)
>> 
>> It can handle our use cases, but I'm worried if we're bitting more
>> that what we can chew. Perhaps a staged approach? I.e. target the
>> low hanging fruit first, get it work, and then work on the hardest
>> parts?
> 
> Actually, I'm not to scared about the work and yes I think that it
> *must* be a staged approach. To start focus on adding overlays without
> phandle resolution (phandles must match) or unloading support.
> Unloading and phandle resolution can be separate follow-on features.
> Unloading and phandle resolution are the hard bits anyway.
> 

Okay.

>>> It may be sufficient to solve it by making the phandle values less
>>> volatile. Right now dtc generates phandles linearly. Generated phandles
>>> could be overridden with explicit phandle properties, but it isn't a
>>> fantastic solution. Perhaps generating the phandle from a hash of the
>>> node name would be sufficient.
>>> 
>> 
>> I doubt the hash method will work reliably. We only have 32 bits to work with,
>> nothing like the SHA hashes of git.
>> 
> 
> I think the biggest trees have on the order of 100 nodes and a 32 bit
> numberspace is 4Gi. Surely collisions can be avoided.  :-)
> 
> It is also possible to explicitly specify the phandle when the hash
> method breaks down, or if the node full path needs to change, but I'd
> like to avoid that approach as much as possible.
> 

Something like 

	foo = <&bar>;


	unresolved-phandle-paths {
		bar = "/soc/bar@deadbeef";

	}
?

It is not very nice looking admittedly.

Could you explain your hashing method a bit? How will you deal with the
possible conflicts?

>> 5) Have a method to attach FDT overlay to a kernel module.
>> 
>> For some drivers it might be better if the kernel module and the
>> DT overlay is packaged in the same file. You be in a part of
>> the module binary as a special section that request_firmware can
>> pick up automatically.
> 
> It used to be that firmware blobs could be linked into the kernel and
> request_firmware() would find them. I'd like to investigate if that is
> still possible.
> 

It should work. Modules should work too.

>>> Add support to remove an overlay (question: is this important?)
>>> 
>> 
>> For hot-plugging, you need it. Whether kernel code can deal with
>> large parts of the DT going away... How about we use the dead
>> properties method and move/tag the removed modes as such, and not
>> really remove them.
> 
> Nodes already use krefs, and I'm thinking about making them kobjects
> so that they appear in sysfs and we'll have some tools to figure out
> when reference counts don't get decremented properly.
> 

>From the little I've looked in the of code, and the drivers, it's going
to be pretty bad. I don't think all users take references properly, and
we have a big global lock for accessing the DT. 

Adding and removing nodes at runtime as part of the normal operation of
the system (and not as something that happens once in a blue moon under
controlled conditions) will uncover lots of bugs.

So let's think about locking too.

>>> Workitems:
>>> Modify of_platform_populate() to get new node notifications
>>> Modify of_register_spi_devices to get new node notifications
>>> Modify of_register_i2c_devices to get new node notifications
>>> 
>> 
>> w1 is the same. Possibly more.
> 
> w1?

One-Wire. Very simple sensor bus using one wire.
> 
>> 
>> Another can of worms is the pinctrl nodes.
> 
> Yes... new pinctrl data would need to trigger adding new data to
> pinctrl. I don't know if the pinctrl api supports that.
> 

I would be happy for now just being able to move the pinctrl definitions
in the DT fragment. I have been told this has been a topic of discussion and
people decided that their place being all together was better.
I'm hoping we can address this.

>> 
>>> 6) Other work
>>> -------------
>>> The device node user space interface could use some work. Here are some
>>> random work items that are peripherally related to the overlay feature.
>>> 
>>> Other Workitems:
>>> Define FDT schema syntax
>>> Add FDT schema support to FDT (basically lint-style testing)
>>> Investigate runtime schema validation
>>> Make device_nodes first-class kobjects and remove the procfs interface
>>> - it can be emulated with a symlink
>>> Add symlinks from devices to devicetree nodes in sysfs
>> 
>> That's going to take a while :)
> 
> :-) But as you've already pointed out this should be taken in a staged
> approach. Simple overlay support is still useful and shouldn't be too
> complex to implement.
> 

Famous last words... :)

> g.

One final thing. Some people have expressed concern that DT processing tends
to take some time; time that badly affects booting speed. Perhaps if large
parts of the DT are disabled, or if the system can operate in some manner
using a lazy parsing method, we could look at that too.

Regards

-- Pantelis


