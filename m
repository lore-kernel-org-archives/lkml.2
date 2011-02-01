Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1BAAP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:15:27 -0500
Received: from claw.goop.org ([74.207.240.146]:58076 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab1BAAPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:15:23 -0500
Message-ID: <4D475099.1080004@goop.org>
Date: Mon, 31 Jan 2011 16:15:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com> <20110130113356.GA27967@liondog.tnic> <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic> <4D46FC9F.6090309@goop.org> <20110131234131.GA16095@liondog.tnic>
In-Reply-To: <20110131234131.GA16095@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 03:41 PM, Borislav Petkov wrote:
> On Mon, Jan 31, 2011 at 10:17:03AM -0800, Jeremy Fitzhardinge wrote:
>> On 01/30/2011 11:02 PM, Borislav Petkov wrote:
>>>> Well, I was trying to avoid putting Xen-specific code into the existing
>>>> Intel/AMD loaders.  That doesn't seem any cleaner.
>>>>
>>>> I could export "my firmware pathname" functions from them and have the
>>>> Xen driver call those, rather than duplicating the pathname construction
>>>> code.  Would that help address your concerns?
>>> Well, I was thinking even more radically than that. How about
>>>
>>> 1. microcode_xen.c figures out which struct microcode_ops to use based
>>> on the hw vendor;
>>>
>>> 2. overwrites the ->apply_microcode ptr with the hypercall wrapper
>>>
>>> 3. dom0 uses it to load the firmware image and do all checks to it
>> That could be made to work, but I don't really see it as being an
>> improvement.
> WTF? How is
>
> * almost no code duplication
> * not adding Xen-specific checks to generic arch code
> * relying on already tested codepaths
>
> not an improvement?

My understanding of what you're proposing is:

   1. the normal CPU-specific microcode driver starts up
   2. an if (xen) test overrides the apply_microcode to call a
      Xen-specific function
   3. the driver requests the firmware, loads and verifies it as normal
   4. the microcode is applied via the Xen apply_microcode function

With (2) needing a Xen-specific change to both the Intel and AMD drivers.

If not, what are you proposing in detail?

Are you instead thinking:

    * Xen-specific microcode driver starts up
    * It calls either the intel or amd request_microcode_fw as needed
    * apply the the loaded data via hypercall

?

But all this is flawed because the microcode_intel/amd.c drivers assume
they can see all the CPUs present in the system, and load suitable
microcode for each specific one.  But a kernel in a Xen domain only has
virtual CPUs - not physical ones - and has no idea how to get
appropriate microcode data for all the physical CPUs in the system.

>>> 4. eventually, the hypervisor gets to apply the _verified_ microcode
>>> image (no more checks needed) using the vendor-specific application
>>> method.
>>>
>>> This way there's almost no code duplication, you'll be reusing the
>>> vendor-supplied code in baremetal which gets tested and updated
>>> everytime it needs to and will save you a bunch of work everytime
>>> there's change to it needed to replicate it into the hypervisor.
>> In general Xen tries to avoid trusting its domains.  Admittedly, dom0 is
>> special in that it is already somewhat trusted, but even dom0 is
>> constrained by Xen.  For microcode, Xen just depends on it to provide a
>> best-possible microcode file, then Xen+the CPU do the work of fully
>> validating it and installing it.
> Well, the CPU doesn't trust the microcode provided by the software
> either. And why should it?

Right.  There's nothing really for the driver to do (kernel or Xen). 
The Intel driver does a bunch of checksum checking, which is presumably
useful for detecting a corrupted firmware update early, and splits out
the chunks specific to the current cpus.  The AMD driver does no
checking per-se, but also looks for processor-specific microcode update
chunks.

In the Xen case, since a domain is not necessarily seeing all the
details of the underlying physical cpus, it makes most sense for
usermode to just pass in the whole microcode file and let Xen do all the
checking/filtering based on complete knowledge of the system.

> All I'm saying is, you should try as best as possible to avoid code
> duplication and the need for replicating functionality to Xen, thus
> doubling - even multiplying - the effort for coding/testing baremetal
> and then Xen. Microcode is a perfect example since the vendors do all
> their testing/verification on baremetal anyway and the rest should
> benefit from that work.

CPU vendors test Xen, and Intel is particularly interested in getting
this microcode driver upstream.  The amount of duplicated code is
trivial, and the basic structure of the microcode updates doesn't seem
set to change.  Since Xen has to have all sorts of other CPU-specific
code which at least somewhat overlaps with what's in the kernel a bit
more doesn't matter.

(It's interesting that nobody seems to have been interested enough in
Via to have ever implemented a microcode driver for it - perhaps they
only ever do it from BIOS.)

    J
