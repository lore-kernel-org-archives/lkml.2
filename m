Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1BBS3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:29:18 -0500
Received: from claw.goop.org ([74.207.240.146]:35653 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab1BBS3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:29:16 -0500
Message-ID: <4D49A277.3030404@goop.org>
Date: Wed, 02 Feb 2011 10:29:11 -0800
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
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com> <20110130113356.GA27967@liondog.tnic> <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic> <4D46FC9F.6090309@goop.org> <20110131234131.GA16095@liondog.tnic> <4D475099.1080004@goop.org> <20110201110026.GA4739@liondog.tnic> <4D489348.90701@goop.org> <20110202095445.GA4761@liondog.tnic>
In-Reply-To: <20110202095445.GA4761@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, missed your specific comments below.

On 02/02/2011 01:54 AM, Borislav Petkov wrote:
>> collect_cpu_info can't work, because the domain doesn't have access to
>> all the host's physical CPUs.
> Why would you need that? You can safely assume that the ucode patch
> level on all cores across the system are identical - I've yet to see a
> machine running with different patch levels for the same reason that
> mixed silicon systems is a large pain in the ass and you're better off
> buying yourself a completely new system.

I was thinking specifically about a large multi-chassis system with lots
of nodes.  In that case you could well imagine different nodes/chassis
having variations of CPU steppings.

But even on a single board, I don't know what limitations there are on
mixing steppings between sockets, but I suspect it is possible. 
Obviously I wouldn't expect there to be large variations between CPUs
(different models or features) - that would be a problem.

>> However, even aside from that, it means exporting a pile of internal
>> details from microcode_amd and reusing them within microcode_xen.  And
>> it requires that it be done again for each vendor.
> Why can't you load the appropriate, unmodified microcode_<vendor> module
> in dom0 and let it call the hypercall?

Well, if it can call hypercalls, then to some extent it is already
"modified".  Either I change the source to change the wrmsrs into
hypercalls, or overwrite its operations structure to change the
apply_microcode function pointer (which would require - at the very
least - making it non-static) to a hyper-calling function.

Either way it implies that we're delving into the Intel/AMD drivers in
order to implement Xen-specific functionality, which is clearly (to me,
at least) much worse than just making the Xen-specific code completely
self-contained.

>> But all that's really needed is a dead simple "request" that loads the
>> entire file (with a vendor-specific name) and shoves it into Xen.  
>> There's no need for any vendor-specific code beyond the filename.
> But that adds this funny chunk
>
> -       if (c->x86_vendor == X86_VENDOR_INTEL)
> +       if (xen_pv_domain())
> +               microcode_ops = init_xen_microcode();
> +       else if (c->x86_vendor == X86_VENDOR_INTEL)
>                 microcode_ops = init_intel_microcode();
>         else if (c->x86_vendor == X86_VENDOR_AMD)
>                 microcode_ops = init_amd_microcode();
>
> which can clearly be avoided. Now imagine the if-else thing contained a
> dozen or more virt solutions in there, bloat!

This is just the way microcode_core.c is structured.  It doesn't have a
dozen or more virt solutions, but if it did, we could change the way
that microcode loaders are probed for to make it cleaner.  Exactly the
same issue arises if you say "there might be a dozen or more cpu vendors
- bloat!".  True, there might be, and we should fix it in that case.  Or
conversely, there might be a new CPU vendor who decides to implement the
Intel microcode loading interface, in which case the tests on a specific
vendor become wrong.

>  Now imagine this not only
> in the microcode driver but in a bunch of other places across arch/x86.

Why imagine that?  We're not talking about the rest of arch/x86.

>>> This is exactly what I'm talking about - why copy all that
>>> checking/filtering code from baremetal to Xen instead of simply reusing
>>> it? Especially if you'd need to update the copy from time to time when
>>> baremetal changes.
>> The code in the kernel is in the wrong place.  It has to be done in
>> Xen.  When Xen is present, the code in the kernel is redundant, not the
>> other way around.
> Ok, this says it all. Let's remove the arch code and replace it with
> xen-friendly version - we won't need the baremetal one anyway. Jeez!

I didn't say anything about removing the code from Linux.  But the
simple fact is that a kernel running under a hypervisor isn't the
ultimate owner of the machine's hardware - the hypervisor is, and it
controls all access to the hardware.  That's deeply fundamental to the
way any hypervisor works, and Xen is just one example.  And the
consequence of that is that Linux has to use hypervisor facilities to
perform certain operations rather than using its own code.

>> Shrug.  AFAICT the mechanism hasn't changed since it was first
>> introduced.  If there's a change, then both Linux and Xen will have to
>> change, and most likely the same CPU vendor engineer will provide a
>> patch for both.  Xen has a good record for tracking new CPU features.
> I don't think that the same CPU vendor engineer will do that, believe me!

Many individual Intel and AMD engineers contribute code to both Xen and
Linux.  It's not a question of belief.

Thanks,
    J

