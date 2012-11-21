Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2KUEXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 23:23:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7697 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab2KUEXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 23:23:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 20 Nov 2012 20:23:09 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Date: Wed, 21 Nov 2012 13:23:06 +0900
Message-ID: <13540495.epaCf4JVn9@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.3 (Linux/3.6.6-1-ARCH; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121120215429.B621F3E1821@localhost>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <1353149747-31871-2-git-send-email-acourbot@nvidia.com> <20121120215429.B621F3E1821@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Wednesday 21 November 2012 05:54:29 Grant Likely wrote:
> > With the advent of the device tree and of ARM kernels that are not
> > board-tied, we cannot rely on these board-specific hooks anymore but
> 
> This isn't strictly true. It is still perfectly fine to have board
> specific code when necessary. However, there is strong encouragement to
> enable that code in device drivers as much as possible and new board
> files need to have very strong justification.

But doesn't introducing board-specific code into the kernel just defeats the 
purpose of the DT? If we extend this logic, we are heading straight back to 
board-definition files. To a lesser extent than before I agree, but the problem 
is fundamentally the same.

> > need a way to implement these sequences in a portable manner. This patch
> > introduces a simple interpreter that can execute such power sequences
> > encoded either as platform data or within the device tree. It also
> > introduces first support for regulator, GPIO and PWM resources.
> 
> This is where I start getting nervous. Up to now I've strongly resisted
> adding any kind of interpreted code to the device tree. The model is to
> identify hardware, but require the driver to know how to control it. (as
> compared to ACPI which is entirely designed around executable
> bytecode).
> 
> While the power sequences described here certainly cannot be confused
> with a Turing complete bytecode, it is a step in that direction.

Technically speaking power sequences are a step towards an interpreter, but it 
is a very small one and it should not go much further than the current state. 
I understand the concern of having "code" into the DT but I really think it 
should be viewed from a different angle.

Powering sequences are special in that they can be affected by the board design 
or the devices variations. For instance hundreds of different panels with 
backlights are currently compatible with the pwm-backlight driver. The only 
thing that differenciates them is how the backlight is powered on and off. If 
you are to build a kernel that is supposed to support all these panels, you 
would need to embed all the powering sequences in the kernel even though only 
one of them will be used by one specific board. Power sequences in the DT help 
preventing that.

With that stated, it is clear that we should not need to define more than the 
short, simple sequences of actions that cannot be elegantly handled by the 
driver. Anything beyond that should be handled by the driver itself. In 
particular, here are a few things I do *not* want to see included in power 
seqs:

- conditionals/jumps (or it's not a sequence anymore).
- direct access to hardware. Resources must at least be abstracted in some 
way. You shall not e.g. access the address space directly.
- support for non-power related resources - that is out of the special case of 
powering sequences and should be done by the driver

That should keep the "grammar" simple, and the sequences short enough to that 
we can consider then as data belonging to the device, and not as code that is 
interpreted.

> I think this will get very verbose in a hurry. Already this simple
> example is 45 lines long. Using the device tree structure to encode the
> language doesn't look like a very good fit. Not to mention that the
> order of operations is entirely based on the node name. Want to insert
> an operation between step0 and step1? Need to rename step1, step2, and
> step3 to do so.

I don't like that steps numbering thing neither, but it seems to be the best 
way to do it so far.

As for the DT structure not being adapted for this - I would agree if we 
wanted to implement a complete interpreter, but that's precisely not the case. 
More about this later.

> This implementation also isn't very consistent. The gpio is referenced
> with a phandle in step3/step0, but the regulator and pwm are referenced
> by id.

Tomi made the same remark - the reason for using the phandle in GPIO is 
because GPIO framework does not support referencing GPIOs by name yet. I 
wanted to DT bindings to reflect the underlying framework as much as possible 
until we have a function like gpio_get(device, id).

However I agree that this makes things inconsistent at the moment and would 
require a bindings change. And in the case of the DT this is actually easy to 
implement (I did it in some previous versions). I'll make sure to do it.

> As an alternative, what about something like the following?
> 
> 	backlight {
> 		compatible = "pwm-backlight";
> 		...
> 
> 		/* resources used by the power sequences */
> 		pwms = <&pwm 2 5000000>;
> 		pwm-names = "backlight";
> 		regulators = <&backlight_reg>;
> 		gpios = <&gpio 28 0>;
> 
> 		power-on-sequence = "r0e;d10000m;p0e;g0s";
> 		power-off-sequence = "g0c;p0d;d10000m;r0d";
> 	};

Well, *now* it really looks like bytecode. :)

> I'm thinking about the scripts as trivial-to-parse ascii strings that
> have a very simple set of commands. The commands use resources already
> defined in the node. ie. 'g0' refers to the first entry in the gpios
> property. 'r0' for the regulator, 'p0' for the pwms, 'd' means delay. By
> no means take this as the format to use, it is just an example off the
> top of my head, but it is already way easier to work with than putting
> each command into a node.

I'd argue that this opens the door wide open towards having a complete 
interpreter in the device tree. At least DT nodes restrict what we can do 
conveniently.

> The trick is still to define a syntax that doesn't fall apart when it
> needs to be extended. I would also like to get opinions on whether or
> not conditionals or loops should be supported (ie. loop waiting for a
> status to change). If they should then we need to be a lot more careful
> about the design (and due to my aforementioned nervousness, somebody may
> need to get me therapy).

That's IMHO the main argument in favor of using DT nodes here (the syntax 
extension, not your therapy). They can be extended simply by adding properties 
to them, and I was relying on this to make power seqs extensible while keeping 
things consistent (and backward-compatible). For instance, when we want to 
support voltage setting in regulators we can just add a "voltage" property for 
that.

So to sum up the pros of the current node-base representation:
- give a "data like" representation of powering sequences (what they should 
be, actually)
- puts sanity barriers for not turning power seqs into a real code interpreter
- easily extensible

There are probably a few cons, the numbering of steps being one, but at least 
we don't need to design a new DSL and care too much about extensibility which 
is, in the nodes case, built-in and free.

I also like to make it clear that I don't want to see this going out of 
control and that any extension proposal would have to be thoroughly justified 
and reviewed - and better not contradict any of the 3 points listed above.

If that makes you feel better, maybe we can try and fix what is wrong with the 
current bindings instead of introducing a new language that will be, by 
nature, more complex to handle and difficult to extend without breaking things?

Alex.

