Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1BBJyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 04:54:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32934 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab1BBJyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 04:54:52 -0500
Date: Wed, 2 Feb 2011 10:54:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20110202095445.GA4761@liondog.tnic>
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
 <20110131070241.GA22071@liondog.tnic>
 <4D46FC9F.6090309@goop.org>
 <20110131234131.GA16095@liondog.tnic>
 <4D475099.1080004@goop.org>
 <20110201110026.GA4739@liondog.tnic>
 <4D489348.90701@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D489348.90701@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I'm reading your answers but I keep getting the impression that this
discussion is not moving anywhere. You keep finding reasons why it can't
be done and trying to persuade me that your way is the only way. Why is
that?

And I'm telling you microcode_xen has nothing to do among
vendor-specific code. Since when is xen a hw vendor and deserves special
attention? And don't tell me because people use it. It is absolutely
inacceptable to add a bunch of code to arch/x86 just because you're
telling me it can't be done differently, not intermixed with hw vendor
code and just because a hypervisor vendor needs it. Does that mean that
if every other virtualization booth wants to add their special code to
arch/x86, we just go and slap it in without questioning its design?

I don't think so.

On Tue, Feb 01, 2011 at 03:12:08PM -0800, Jeremy Fitzhardinge wrote:
> On 02/01/2011 03:00 AM, Borislav Petkov wrote:
> > I am thinking something in the sense of the above. For example, in the
> > AMD case you take
> >
> > static struct microcode_ops microcode_amd_ops = {
> > 	.request_microcode_user           = request_microcode_user,
> > 	.request_microcode_fw             = request_microcode_fw,
> > 	.collect_cpu_info                 = collect_cpu_info_amd,
> > 	.apply_microcode                  = apply_microcode_amd,
> > 	.microcode_fini_cpu               = microcode_fini_cpu_amd,
> > };
> >
> > and reuse the ->request_microcode_fw, ->collect_cpu_info and
> > ->microcode_fini_cpu on dom0 as if you're running on baremetal. Up
> > to the point where you need to apply the microcode. Then, you use
> > your supplied ->apply_microcode hypercall wrapper to call into the
> > hypervisor.
> 
> collect_cpu_info can't work, because the domain doesn't have access to
> all the host's physical CPUs.

Why would you need that? You can safely assume that the ucode patch
level on all cores across the system are identical - I've yet to see a
machine running with different patch levels for the same reason that
mixed silicon systems is a large pain in the ass and you're better off
buying yourself a completely new system.

> However, even aside from that, it means exporting a pile of internal
> details from microcode_amd and reusing them within microcode_xen.  And
> it requires that it be done again for each vendor.

Why can't you load the appropriate, unmodified microcode_<vendor> module
in dom0 and let it call the hypercall?

> But all that's really needed is a dead simple "request" that loads the
> entire file (with a vendor-specific name) and shoves it into Xen.  
> There's no need for any vendor-specific code beyond the filename.

But that adds this funny chunk

-       if (c->x86_vendor == X86_VENDOR_INTEL)
+       if (xen_pv_domain())
+               microcode_ops = init_xen_microcode();
+       else if (c->x86_vendor == X86_VENDOR_INTEL)
                microcode_ops = init_intel_microcode();
        else if (c->x86_vendor == X86_VENDOR_AMD)
                microcode_ops = init_amd_microcode();

which can clearly be avoided. Now imagine the if-else thing contained a
dozen or more virt solutions in there, bloat! Now imagine this not only
in the microcode driver but in a bunch of other places across arch/x86.

> >> But all this is flawed because the microcode_intel/amd.c drivers assume
> >> they can see all the CPUs present in the system, and load suitable
> >> microcode for each specific one.  But a kernel in a Xen domain only has
> >> virtual CPUs - not physical ones - and has no idea how to get
> >> appropriate microcode data for all the physical CPUs in the system.
> > Well, let me quote you:
> >
> > On Fri, Jan 28, 2011 at 04:26:52PM -0800, Jeremy Fitzhardinge wrote:
> >> Xen update mechanism is uniform independent of the CPU type, but the
> >> driver must know where to find the data file, which depends on the CPU
> >> type. And since the update hypercall updates all CPUs, we only need to
> >> execute it once on any CPU - but for simplicity it just runs it only
> >> on (V)CPU 0.
> > so you only do it once and exit early in the rest of the cases. I
> > wouldn't worry about performance since ucode is applied only once upon
> > boot.
> 
> Its not a performance question.  The Intel and AMD microcode drivers
> parse the full blob loaded from userspace, and just extract the chunk
> needed for each CPU.  It does this for each separate CPU, so in
> principle you could have a mixture of models within one machine or
> something (the driver certainly assumes that could happen; perhaps it
> could on a larger multinode machine).
>
> The point is that if it does this on (what the domain sees as ) "cpu 0",
> then it may throw away microcode chunks needed for other CPUs.  That's
> why we need to hand Xen the entire microcode file, and let the
> hypervisor do the work of splitting it up and installing it on the CPUs.

see comment about mixed silicon above.

> > This is exactly what I'm talking about - why copy all that
> > checking/filtering code from baremetal to Xen instead of simply reusing
> > it? Especially if you'd need to update the copy from time to time when
> > baremetal changes.
> 
> The code in the kernel is in the wrong place.  It has to be done in
> Xen.  When Xen is present, the code in the kernel is redundant, not the
> other way around.

Ok, this says it all. Let's remove the arch code and replace it with
xen-friendly version - we won't need the baremetal one anyway. Jeez!

> >> CPU vendors test Xen, and Intel is particularly interested in getting
> >> this microcode driver upstream.  The amount of duplicated code is
> >> trivial, and the basic structure of the microcode updates doesn't seem
> >> set to change.
> > Uuh, I wouldn't bet on that though :).
> 
> Shrug.  AFAICT the mechanism hasn't changed since it was first
> introduced.  If there's a change, then both Linux and Xen will have to
> change, and most likely the same CPU vendor engineer will provide a
> patch for both.  Xen has a good record for tracking new CPU features.

I don't think that the same CPU vendor engineer will do that, believe me!

> >> Since Xen has to have all sorts of other CPU-specific code which at
> >> least somewhat overlaps with what's in the kernel a bit more doesn't
> >> matter.
> > Well, I'll let x86 people decide on that but last time I checked they
> > opposed "if (xen)" sprinkling all over the place.
> 
> Eh?  I'm talking about code within Xen; it doesn't involve any if (xen)s
> within the kernel.

Ok, I'm getting tired of this. I'll gladly read all your answers if you
have constructive suggestions and better proposals - if the only thing
you have to come back are reasons why xen's is the only way to do it,
then don't even bother to answer - at least I won't. If x86 people want
to take your code, they'll do it since it is their call anyway.

Thanks.

-- 
Regards/Gruss,
    Boris.
