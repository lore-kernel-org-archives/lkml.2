Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1AaCeh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 21:34:37 -0500
Received: from claw.goop.org ([74.207.240.146]:33685 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab1AaCeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:34:36 -0500
Message-ID: <4D461FB9.5050807@goop.org>
Date: Sun, 30 Jan 2011 18:34:33 -0800
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
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com> <20110130113356.GA27967@liondog.tnic>
In-Reply-To: <20110130113356.GA27967@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2011 03:33 AM, Borislav Petkov wrote:
> On Fri, Jan 28, 2011 at 04:26:52PM -0800, Jeremy Fitzhardinge wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Hi all,
>>
>> I'm proposing this for 2.6.39.
>>
>> This series adds a new "Xen" microcode update type, in addition to
>> Intel and AMD.
>>
>> The Xen hypervisor is responsible for performing the actual microcode
>> update (since only it knows what physical CPUs are in the system and
>> has sufficient privilege to access them), but it requires the dom0
>> kernel to provide the actual microcode update data.
>>
>> Xen update mechanism is uniform independent of the CPU type, but the
>> driver must know where to find the data file, which depends on the CPU
>> type.  And since the update hypercall updates all CPUs, we only need
>> to execute it once on any CPU - but for simplicity it just runs it only
>> on (V)CPU 0.
> I don't like this for several reasons:
>
> - ucode should be loaded as early as possible and the perfect place
> for that should be the hypervisor and not the dom0 kernel. But I'm not
> that familiar with xen design and I guess it would be pretty hard to
> do. (Btw, x86 bare metal could also try to improve the situation there
> but that's also hard due to the design of the firmware loader (needs
> userspace)).

Yes, its the same issue with Xen or without.  The Xen hypervisor has no
devices, storage or anything else with which it can get microcode data. 
It depends on the dom0 kernel getting it from somewhere and supplying it
to the hypervisor.  In practice this is no different from relying on
usermode to get the firmware update.

In general firmware updates are not critical and not required very
early, so "as soon as reasonably possible" is OK.  (If the firmware
update is critical, it should be supplied as a BIOS update.)

So I think this is moot with respect to this particular patch.

> - you're adding a microcode_xen.c as if this is another hw vendor and
> you're figuring out which is the proper firmware image based on the
> vendor, then you load it and then do the hypercall. This is duplicating
> code and inviting future bugs. Everytime the hw vendors decide to change
> something to their fw loading mechanism, xen needs to be updated. Also,
> you don't do any sanity checks to the ucode image as the vendor code
> does which is inacceptable.

The code within the hypervisor is more or less the same as the kernel's:
it does all the required vendor-specific checks on the firmware and
loads it on all the CPUs with the appropriate mechanism.  The hypercall
ABI is vendor-agnostic, but it assumes that dom0 will supply suitable
microcode for the current CPU vendor (though if it doesn't, the image
will presumably be rejected).

So from that perspective, it is a distinct microcode loading mechanism,
akin to a vendor-specific one.  The awkward part is getting the filename
to actually request from usermode, which is Intel/AMD/whatever specific,
which results in duplicated code to generate that pathname.

> What it should do instead, is call into the hw vendor-specific ucode
> loading mechanism and do all the image loading/verification there. The
> only thing you'd need to supply is a xen-specific ->apply_microcode()
> doing the hypercall _after_ the ucode image has been verified and is
> good to go. I'm guessing the XENPF_microcode_update does call into the
> hypervisor and calls a xen-specific ucode update mechanism based on the
> vendor instead of using the vendor-supplied code...

Well, I was trying to avoid putting Xen-specific code into the existing
Intel/AMD loaders.  That doesn't seem any cleaner.

I could export "my firmware pathname" functions from them and have the
Xen driver call those, rather than duplicating the pathname construction
code.  Would that help address your concerns?

    J
