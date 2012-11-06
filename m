Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2KFKaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:30:11 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:34855 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755Ab2KFKaH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:30:07 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
Date: Tue, 6 Nov 2012 11:30:00 +0100
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
Message-Id: <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Nov 5, 2012, at 9:40 PM, Grant Likely wrote:

> Hey folks,
> 
> As promised, here is my early draft to try and capture what device
> tree overlays need to do and how to get there. Comments and
> suggestions greatly appreciated.
> 
> Device Tree Overlay Feature
> 
> Purpose
> =======
> Sometimes it is not convenient to describe an entire system with a
> single FDT. For example, processor modules that are plugged into one or
> more modules (a la the BeagleBone), or systems with an FPGA peripheral
> that is programmed after the system is booted.
> 
> For these cases it is proposed to implement an overlay feature for the
> so that the initial device tree data can be modified by userspace at
> runtime by loading additional overlay FDTs that amend the original data.
> 
> User Stories
> ============
> Note - These are potential use cases, but just because it is listed here
> doesn't mean it is important. I just want to thoroughly think through the
> implications before making design decisions.
> 
> 
> Jane is building custom BeagleBone expansion boards called 'capes'. She
> can boot the system with a stock BeagleBoard device tree, but additional
> data is needed before a cape can be used. She could replace the FDT file
> used by U-Boot with one that contains the extra data, but she uses the
> same Linux system image regardless of the cape, and it is inconvenient
> to have to select a different device tree at boot time depending on the
> cape.
> 
> Jane solves this problem by storing an FDT overlay for each cape in the
> root filesystem. When the kernel detects that a cape is installed it
> reads the cape's eeprom to identify it and uses request_firmware() to
> obtain the appropriate overlay. Userspace passes the overlay to the
> kernel in the normal way. If the cape doesn't have an eeprom, then the
> kernel will still use firmware_request(), but userspace needs to already
> know which cape is installed.

Jane is a really productive hardware engineer - she manages to fix a
number of problems with her cape design by spinning different revisions
of the cape. Using the flexibility that the DT provides, documents and
defines the hardware changes of the cape revisions in the FDT overlay.
The loader matches the revision of the cape with the proper FDT overlay
so that the drivers are relieved of having to do revision management.

> 
> 
> Nigel is building a real-time video processing system around a MIPS SoC
> and a Virtex FPGA. Video data is streamed through the FPGA for post
> processing operations like motion tracking or compression. The FPGA is
> configured via the SPI bus, and is also connected to GPIO lines and the
> memory mapped peripheral bus. Nigel has designed several FPGA
> configurations for different video processing tasks. The user will
> choose which configuration to load which can even be reprogrammed at
> runtime to switch tasks.
> 
> Each FPGA has a different interface to the processor, so the kernel
> needs additional data before it can use each device. Nigel is passing
> that data to the kernel using an FDT overlay. When Linux loads a new
> FPGA configuration, it uses request_firmare() to obtain the overlay for
> that FPGA. When the FPGA gets reprogrammed, the kernel throws away the
> previous overlay data and uses request_firmware() to get the overlay for
> the new design.
> 
> 
> Mandy has a Raspberry Pi which she has wired by hand up to sensors and
> motor controllers in her prototype autonomous robot project. She is doing
> self-hosted driver development on the Raspberry Pi itself. However, she
> needs a method to tell the kernel about the attached devices.
> 
> By installing dtc on the Pi, Mandy compiles the overlay for her
> prototype hardware. However, she doesn't have a copy of the Pi's
> original FDT source, so instead she uses the dtc 'fs' input format to
> compile the overlay file against the live DT data in /proc.
> 
> 

Jane (the cape designer) can use this too. Developing the cape, she really
appreciates that she doesn't have to reboot every time she makes a change
in the cape hardware. By removing the FDT overlay, compiling with the dtc
on the board, and re-inserting the overlay, she can be more productive by
waiting less.

Johnny, Jane's little son, doesn't know anything about device trees, linux
kernel trees, or hard-core s/w engineering. He is a bright kid, and due to
the board having a node.js based educational electronic design kit, he
can use the web-based simplified development environment, that allows
him graphically to connect the parts in his kit. He can save the design
and the IDE creates on the fly the DT overlay for later use. 

> Amit is writing kernel drivers for Jane's BeagleBone capes, but he
> finds loading new DT files into the root filesystem inconvenient.
> Instead, he includes the FDT overlay file in the initramfs that is built
> and linked in at kernel compile time so that the kernel can find and
> load overlays automatically.
> 
> 
> Joanne has purchased one of Jane's capes and packaged it into a rugged
> case for data logging. As far as Joanne is concerned, the BeagleBone and
> cape together are a single unit and she'd prefer a single monolithic FDT
> instead of using an FDT overlay.
> Option A: Using dtc, she uses the BeagleBone and cape .dts source files
>          to generate a single .dtb for the entire system which is
>          loaded by U-Boot. -or-

Unlikely. 
> Option B: Joanne uses a tool to merge the BeagleBone and cape .dtb files
>          (instead of .dts files), -or-
Possible but low probability.

> Option C: U-Boot loads both the base and overlay FDT files, merges them,
>          and passes the resolved tree to the kernel.
> 

Could be made to work. Only really required if Joanne wants the 
cape interface to work for u-boot too. For example if the cape has some
kind of network interface that u-boot will use to boot from.

> ....
> 
> Summary points:
> - Create an FDT overlay data format and usage model
>  - SHALL reliable resolve or validate of phandles between base and
>    overlay trees
>  - SHOULD reliably handle changes between different underlying overlays
>    (ie. what happens to existing .dtb overly files if the structure of
>    the dtb it is layered over changes. If not possible, then SHALL
>    detect when the base tree doesn't match and refuse to apply the
>    overlay.
> - dts syntax needs to be extended for overlay .dtb files
> - DTC tool needs to be modified to support overlay .dtb generation
> - Overlays SHOULD be able to be applied either by firmware or the kernel
> - libfdt SHALL be extended to parse and apply overlays

- ftdump should be fixed and work for the overlay syntax too.

> - Linux SHALL be extended to parse and apply overlays from userspace
> - Linux SHALL be extended to notify drivers of changes to device tree
> - Linux MAY use request_firmware() to load overlays via sysfs
>  - (mechanism for triggering overlay load TBD)
> - Linux MAY support removal of overlays (harder, but some use-cases want
>  this)
> - Linux MAY be extended to remove devices associated with removed overlays
> 
> Technical details to resolve:
> - How does an overlay get attached to the correct base tree nodes?
> - How are phandles fixed up and/or verified?
> - What is the model for overlays?
>  - Can an overlay modify existing properties?
>  - Can an overlay add new properties to existing nodes?
>  - Can an overlay delete existing nodes/properties?
> - Does FDT need a schema? - Schema should be tightly associated with binding
>  documentation. Verifying schema at runtime should be simple. Runtime
>  checking is harder, but could be used as part of phandle fixup.
> - Similarly, does FDT need data typing? Other than reading the binding
>  there is no mechanism to determine if a single cell is a phandle, an
>  integer (possibly enum), a flags field, or part of a string.
>  - Data typing would require additional per-property data; probably by
>    adding companion properties containing the data typing.  ie. an
>    optional '.reg,format' property could contain the format of the
>    'reg' property.  (The naming scheme for the new property can be
>    debated, it just needs to be something that won't conflict with
>    regular names).
>  - Data type data could be used as part of phandle fixups.
> - How do bus drivers get notified when FDT data changes?
>  - node addition/removal
>  - property changes on existing nodes
>  - A notifier chain may work here, or maybe a generic "firmware data
>    changed" device driver callback. I could see this being generically
>    useful for other driver data like ACPI
> 

This is much grander in vision that I had in mind :)

It can handle our use cases, but I'm worried if we're bitting more
that what we can chew. Perhaps a staged approach? I.e. target the
low hanging fruit first, get it work, and then work on the hardest
parts?

> Project plan
> ============
> 
> 1) Create syntax for overlays
> -----------------------------
> DTC already uses an overlay model internally which is often used in
> conjunction with .dtsi files. It should be a natural extension to
> generate FDT overlay files from the existing syntax (maybe minor
> modifications)
> 
> Doing this will require a method to differentiate between overlay and
> include directives.  Maybe they aren't really different at all and it
> will depend on dtc options to determine whether or not to produce an
> overlay. Suggestions are welcome here.
> 
> 2) Create a data format for overlays
> ------------------------------------
> The overlay data format could be a direct extension from the existing
> dtb data format. One option is to construct the overlay tree by creating
> empty nodes for each node that it either adds children to or references
> the phandle of in the base tree. Empty nodes could even be tagged as a
> prereq by adding a '.readonly' property to those nodes. When an overlay
> parser encounters those nodes, it would know that it needs to already
> exist in the tree.
> 
> There is a problem though with phandles. If the phandle values in the
> base tree don't match the ones in the overlay, then the overlay won't be
> able to correctly reference base nodes. At a minimum, the parser must
> verify that the phandles match before applying the overlay. Ideally,
> phandles in the overlay should be fixed up at application time, but this
> isn't easy. It would probably require first adding property data type
> information to the device tree.
> 
> It may be sufficient to solve it by making the phandle values less
> volatile. Right now dtc generates phandles linearly. Generated phandles
> could be overridden with explicit phandle properties, but it isn't a
> fantastic solution. Perhaps generating the phandle from a hash of the
> node name would be sufficient.
> 

I doubt the hash method will work reliably. We only have 32 bits to work with,
nothing like the SHA hashes of git.

> Example: an overlay source file might look something like this:
> 
> /include/ "base-file.dts"  /* 'include' may not be the best syntax here */
> &i2c0 {		/* i2c0 resolved by label */
> 	touchpad@10 {
> 		compatible = "acme,touchpad";
> 		reg = <0x10>;
> 		interrupt-parent = <&intc>;
> 		interrupts = <100>;
> 	};
> };
> 
> And the generated overlay dtb may look like this:
> 
> / {
> 	.readonly;
> 	interrupt-controller@0x10005000 {
> 		.readonly;
> 		phandle = <0x1234>;
> 	};
> 	peripheral-bus {
> 		.readonly;
> 		i2c@20001000 {
> 			touchpad@10 {
> 				compatible = "acme,touchpad";
> 				reg = <0x10>;
> 				interrupt-parent = <0x1234>;
> 				interrupts = <100>;
> 			};
> 		};
> 	};
> };
> 
> Which is obviously missing a bunch of information for the rest of the
> system, but contains enough data to ensure that the path to the touchpad
> node is valid and that the phandle has not changed.
> 
> This handles many of the use cases, but it assumes that an overlay is
> board specific. If it ever is required to support multiple base boards
> with a single overlay file then there is a problem. The .dtb overlays
> generated in this manor cannot handle different phandles or nodes that
> are in a different place. On the other hand, the overlay source files
> should have no problem being compiled for multiple targets.

It will work for our case. The board-file dependency problem is not a big
concern right now.

> 
> 3) Modify DTC and libfdt to process overlays
> --------------------------------------------
> Direct follow on from above. This will require DTC to be modified to
> generate the overlay output format and new test cases to verify it
> works.
> 
> In the process libfdt will get modified to add overlay support which
> will immediately be available to U-Boot and other bootloaders.
> 
> 4) Teach Linux to request FDT overlays
> --------------------------------------
> Add request_firmware() hook for adding overlays. If the platform
> supports detecting the attached expansion board, then this may
> manipulate the filename for a specific file.
> 
> The kernel will graft the overlay into the existing live tree
> 

5) Have a method to attach FDT overlay to a kernel module.

For some drivers it might be better if the kernel module and the 
DT overlay is packaged in the same file. You be in a part of
the module binary as a special section that request_firmware can
pick up automatically. 

> Workitems:
> Document device tree node lifecycle
> Add tests to enforce device tree node lifecycle
> Add interface to firmware_request() an FDT overlay
> Add support to merge overlay FDT nodes into base tree
> Add support to track FDT changes per-overlay
> Add runtime fixups of overlay phandles
> - Without this overlay phandles must exactly match the base tree
> Add support to remove an overlay (question: is this important?)
> 

For hot-plugging, you need it. Whether kernel code can deal with
large parts of the DT going away... How about we use the dead
properties method and move/tag the removed modes as such, and not
really remove them.

> 5) Teach Linux driver model to respond to device tree changes
> -------------------------------------------------------------
> There are several parts to this. The most obvious are adding hooks for
> platform_device, i2c_device and spi_device creation. In all three cases,
> the users should already be providing enough information to support
> dynamic addition (and possibly removal) of dt nodes.
> of_platform_populate() is called for platform devices,
> of_register_spi_devices() for spi and of_i2c_register_devices(). Right
> now all three functions register all the child devices and then
> immediately return. However, if they could set up a notifier for node
> addition, then it would be easy to trigger additional device creation
> when new nodes are added.
> 
> Other busses would be similar, but i2c, spi and platform are the most
> common use cases currently.
> 
> Workitems:
> Modify of_platform_populate() to get new node notifications
> Modify of_register_spi_devices to get new node notifications
> Modify of_register_i2c_devices to get new node notifications
> 

w1 is the same. Possibly more.

Another can of worms is the pinctrl nodes. 

> 6) Other work
> -------------
> The device node user space interface could use some work. Here are some
> random work items that are peripherally related to the overlay feature.
> 
> Other Workitems:
> Define FDT schema syntax
> Add FDT schema support to FDT (basically lint-style testing)
> Investigate runtime schema validation
> Make device_nodes first-class kobjects and remove the procfs interface
> - it can be emulated with a symlink
> Add symlinks from devices to devicetree nodes in sysfs

That's going to take a while :)

Regards

-- Pantelis

