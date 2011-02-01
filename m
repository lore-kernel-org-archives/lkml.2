Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1BALAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 06:00:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58943 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab1BALAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 06:00:33 -0500
Date: Tue, 1 Feb 2011 12:00:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20110201110026.GA4739@liondog.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D475099.1080004@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 04:15:21PM -0800, Jeremy Fitzhardinge wrote:
> My understanding of what you're proposing is:
> 
>    1. the normal CPU-specific microcode driver starts up
>    2. an if (xen) test overrides the apply_microcode to call a
>       Xen-specific function
>    3. the driver requests the firmware, loads and verifies it as normal
>    4. the microcode is applied via the Xen apply_microcode function
> 
> With (2) needing a Xen-specific change to both the Intel and AMD drivers.
> 
> If not, what are you proposing in detail?
> 
> Are you instead thinking:
> 
>     * Xen-specific microcode driver starts up
>     * It calls either the intel or amd request_microcode_fw as needed
>     * apply the the loaded data via hypercall
> 
> ?

I am thinking something in the sense of the above. For example, in the
AMD case you take

static struct microcode_ops microcode_amd_ops = {
	.request_microcode_user           = request_microcode_user,
	.request_microcode_fw             = request_microcode_fw,
	.collect_cpu_info                 = collect_cpu_info_amd,
	.apply_microcode                  = apply_microcode_amd,
	.microcode_fini_cpu               = microcode_fini_cpu_amd,
};

and reuse the ->request_microcode_fw, ->collect_cpu_info and
->microcode_fini_cpu on dom0 as if you're running on baremetal. Up
to the point where you need to apply the microcode. Then, you use
your supplied ->apply_microcode hypercall wrapper to call into the
hypervisor.

> But all this is flawed because the microcode_intel/amd.c drivers assume
> they can see all the CPUs present in the system, and load suitable
> microcode for each specific one.  But a kernel in a Xen domain only has
> virtual CPUs - not physical ones - and has no idea how to get
> appropriate microcode data for all the physical CPUs in the system.

Well, let me quote you:

On Fri, Jan 28, 2011 at 04:26:52PM -0800, Jeremy Fitzhardinge wrote:
> Xen update mechanism is uniform independent of the CPU type, but the
> driver must know where to find the data file, which depends on the CPU
> type. And since the update hypercall updates all CPUs, we only need to
> execute it once on any CPU - but for simplicity it just runs it only
> on (V)CPU 0.

so you only do it once and exit early in the rest of the cases. I
wouldn't worry about performance since ucode is applied only once upon
boot.

[..]

> Right.  There's nothing really for the driver to do (kernel or Xen). 
> The Intel driver does a bunch of checksum checking, which is presumably
> useful for detecting a corrupted firmware update early, and splits out
> the chunks specific to the current cpus.  The AMD driver does no
> checking per-se, but also looks for processor-specific microcode update
> chunks.
> 
> In the Xen case, since a domain is not necessarily seeing all the
> details of the underlying physical cpus, it makes most sense for
> usermode to just pass in the whole microcode file and let Xen do all the
> checking/filtering based on complete knowledge of the system.

This is exactly what I'm talking about - why copy all that
checking/filtering code from baremetal to Xen instead of simply reusing
it? Especially if you'd need to update the copy from time to time when
baremetal changes.

> > All I'm saying is, you should try as best as possible to avoid code
> > duplication and the need for replicating functionality to Xen, thus
> > doubling - even multiplying - the effort for coding/testing baremetal
> > and then Xen. Microcode is a perfect example since the vendors do all
> > their testing/verification on baremetal anyway and the rest should
> > benefit from that work.
> 
> CPU vendors test Xen, and Intel is particularly interested in getting
> this microcode driver upstream.  The amount of duplicated code is
> trivial, and the basic structure of the microcode updates doesn't seem
> set to change.

Uuh, I wouldn't bet on that though :).

> Since Xen has to have all sorts of other CPU-specific code which at
> least somewhat overlaps with what's in the kernel a bit more doesn't
> matter.

Well, I'll let x86 people decide on that but last time I checked they
opposed "if (xen)" sprinkling all over the place.

Btw, hpa has a point, if you can load microcode using multiboot, all
that discussion will become moot since you'll be better at loading
microcode even than baremetal. We need a similar mechanism in x86 too
since the current one loads the microcode definitely too late.

The optimal case for baremetal would be to load it as early as possible
on each CPU's bootstrapping path and if you can do that in the
hypervisor, before even dom0 starts, you're very much fine.

> (It's interesting that nobody seems to have been interested enough in
> Via to have ever implemented a microcode driver for it - perhaps they
> only ever do it from BIOS.)

Yeah, that's one possibility. I bet they'll do it though, when BIOS
cannot be updated/is out of life on some of their platforms and they
want to get a ucode patch applied.

-- 
Regards/Gruss,
    Boris.
