Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1AaHCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 02:02:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42254 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1AaHCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:02:46 -0500
Date: Mon, 31 Jan 2011 08:02:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20110131070241.GA22071@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	the arch/x86 maintainers <x86@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Xen Devel <Xen-devel@lists.xensource.com>,
	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com>
 <20110130113356.GA27967@liondog.tnic>
 <4D461FB9.5050807@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D461FB9.5050807@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 30, 2011 at 06:34:33PM -0800, Jeremy Fitzhardinge wrote:
> > - ucode should be loaded as early as possible and the perfect place
> > for that should be the hypervisor and not the dom0 kernel. But I'm not
> > that familiar with xen design and I guess it would be pretty hard to
> > do. (Btw, x86 bare metal could also try to improve the situation there
> > but that's also hard due to the design of the firmware loader (needs
> > userspace)).
> 
> Yes, its the same issue with Xen or without.  The Xen hypervisor has no
> devices, storage or anything else with which it can get microcode data. 
> It depends on the dom0 kernel getting it from somewhere and supplying it
> to the hypervisor.  In practice this is no different from relying on
> usermode to get the firmware update.
> 
> In general firmware updates are not critical and not required very
> early, so "as soon as reasonably possible" is OK.

Yep.

I can imagine cases where CPU ucode might need to get applied as early
as possible.

> (If the firmware update is critical, it should be supplied as a BIOS
> update.)

I can also imagine cases where BIOS update is not an option/is not
provided and we'd need the ucode applied by the OS too :). Think BIOS
quirks in the kernel whereas all that can be fixed in the BIOS.

> So I think this is moot with respect to this particular patch.
> 
> > - you're adding a microcode_xen.c as if this is another hw vendor and
> > you're figuring out which is the proper firmware image based on the
> > vendor, then you load it and then do the hypercall. This is duplicating
> > code and inviting future bugs. Everytime the hw vendors decide to change
> > something to their fw loading mechanism, xen needs to be updated. Also,
> > you don't do any sanity checks to the ucode image as the vendor code
> > does which is inacceptable.
> 
> The code within the hypervisor is more or less the same as the kernel's:
> it does all the required vendor-specific checks on the firmware and
> loads it on all the CPUs with the appropriate mechanism.  The hypercall
> ABI is vendor-agnostic, but it assumes that dom0 will supply suitable
> microcode for the current CPU vendor (though if it doesn't, the image
> will presumably be rejected).
> 
> So from that perspective, it is a distinct microcode loading mechanism,
> akin to a vendor-specific one.  The awkward part is getting the filename
> to actually request from usermode, which is Intel/AMD/whatever specific,
> which results in duplicated code to generate that pathname.
> 
> > What it should do instead, is call into the hw vendor-specific ucode
> > loading mechanism and do all the image loading/verification there. The
> > only thing you'd need to supply is a xen-specific ->apply_microcode()
> > doing the hypercall _after_ the ucode image has been verified and is
> > good to go. I'm guessing the XENPF_microcode_update does call into the
> > hypervisor and calls a xen-specific ucode update mechanism based on the
> > vendor instead of using the vendor-supplied code...
> 
> Well, I was trying to avoid putting Xen-specific code into the existing
> Intel/AMD loaders.  That doesn't seem any cleaner.
> 
> I could export "my firmware pathname" functions from them and have the
> Xen driver call those, rather than duplicating the pathname construction
> code.  Would that help address your concerns?

Well, I was thinking even more radically than that. How about

1. microcode_xen.c figures out which struct microcode_ops to use based
on the hw vendor;

2. overwrites the ->apply_microcode ptr with the hypercall wrapper

3. dom0 uses it to load the firmware image and do all checks to it

4. eventually, the hypervisor gets to apply the _verified_ microcode
image (no more checks needed) using the vendor-specific application
method.

This way there's almost no code duplication, you'll be reusing the
vendor-supplied code in baremetal which gets tested and updated
everytime it needs to and will save you a bunch of work everytime
there's change to it needed to replicate it into the hypervisor.

Btw, if the code within the hypervisor is similar to the kernel's, you
could even save the original ->apply_microcode() pointer from step 2 and
call it in the hypervisor when the XENPF_microcode_update hypercall op
gets called. This way you have 0 code duplication.

I think this'll be very cool :).

-- 
Regards/Gruss,
    Boris.
