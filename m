Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2KZQmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:42:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38967 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2KZQmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:42:11 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: How about a gpio_get(device *, char *) function?
To: Linus Walleij <linus.walleij@linaro.org>,
        Alex Courbot <acourbot@nvidia.com>
Cc: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CACRpkda9c18E3Msx0dpr8APjSfx5iz4XcS=V1wQaH81ejz7GJQ@mail.gmail.com>
References: <38620644.IyR5R8rjKP@percival> <CACRpkdZc3cEGfSKW-b=G31yuw_E-GOXid3jkxZ0tuKYGYRE5Nw@mail.gmail.com> <7471321.6NJDeDGfYW@percival> <CACRpkda9c18E3Msx0dpr8APjSfx5iz4XcS=V1wQaH81ejz7GJQ@mail.gmail.com>
Date: Mon, 26 Nov 2012 11:25:13 +0000
Message-Id: <20121126112513.AE83B3E0A51@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012 13:09:20 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Nov 5, 2012 at 8:31 AM, Alex Courbot <acourbot@nvidia.com> wrote:
> 
> > Interesting. I see you already gave the whole thing a thought. What I don't
> > understand however is what is so wrong with the current GPIO numberspace that
> > you want to replace it? Whether we use simple integers or blind pointers, the
> > adressable space will basically remain the same. GPIO numbers can actually be
> > considered as handles, and actually I would not mind typedef'ing "int" to a
> > GPIO handle type in order to add more opacity to the framework.
> 
> So the basic problem is scalability and multiplatform support.
> 
> Currently we have a global "roof" on GPIO numbers, ARCH_NR_GPIOS,
> which is helpfully set to 256 in include/asm-generic/gpio.h.
> 
> In the embedded case "ARCH" is a particular board for a particular
> SoC so this number is actually roof:ed for some arbitrary combination
> of SoC + electronics, at compile time, for that very machine.
> 
> So what happens when we try to achieve multiplatform support in the
> ARM tree (same for others, I expect ACPI etc to run into the same
> problem) is that this has to be set to some arbitrarily high value so
> that all GPIOs will fit, and they are not sparse, so if you're just using
> GPIOs 0 .. 15 and 199935..200000 you will need to reserve
> 200000 * sizeof(int) bytes.
> 
> So to avoid this, arch maintainers try with different clever
> macros to pack the GPIO number assignments per board
> downward to begin at 0 and keep the array at minimum size,
> and do not dynamically grab GPIO numbers as they like.
> 
> Contrast this to IRQs which are in the CONFIG_SPARSE_IRQ
> case stored in a radix tree and IRQs can be sparse like this
> without wasting much memory. So IRQdomains can for example
> just grab a number of free IRQ descriptors and the actual
> numbers returned do not matter.
> 
> Using static number assignments also has the side effect
> that developers will just int mygpio = 42; directly in the code
> to cut corners and invites such laziness instead of allocating
> and propagating resources. With abstract handles this does
> not happen.
> 
> So moving forward we need a dynamic, radix tree of sparse GPIOs,
> and we need to follow the design pattern of IRQ descriptors to
> keep the kernel consistent, for example pinctrl does this with
> pins - these are sparse and dynamically allocated. They do not
> have integer numbers other than locally for a particular pin
> controller.
> 
> > Also the current DT bindings will likely continue to require the legacy API
> > anyway, so I am not sure we can make it go away.

It's not. Nothing in the binding is dictating using the current kernel
API. All that stuff can be refactored without changing the binding.

> We can make any DT business go away as long as all DTS
> files are maintained in the kernel and especially if their
> structure is not future-proof. The "DT contract" to make
> bindings stable and everlasting is being broken every day
> as things are right now.

Don't go down that path. Firmware bindings are hard and plenty of people
have experienced the pain of bindings breaking, but *planning* to break
bindings makes it orders of magnitude worse. At least try to preserve
compatibility.

> Not that I know the DT stuff by
> heart, but if the way we're doing GPIO in DT is requiring the
> OS to use a certain type of static array implementation it must
> be wrong since DT is supposed to be OS-neutral.

g.
