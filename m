Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab1BAXMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 18:12:18 -0500
Received: from claw.goop.org ([74.207.240.146]:44807 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab1BAXMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 18:12:17 -0500
Message-ID: <4D489348.90701@goop.org>
Date: Tue, 01 Feb 2011 15:12:08 -0800
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
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com> <20110130113356.GA27967@liondog.tnic> <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic> <4D46FC9F.6090309@goop.org> <20110131234131.GA16095@liondog.tnic> <4D475099.1080004@goop.org> <20110201110026.GA4739@liondog.tnic>
In-Reply-To: <20110201110026.GA4739@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 03:00 AM, Borislav Petkov wrote:
> I am thinking something in the sense of the above. For example, in the
> AMD case you take
>
> static struct microcode_ops microcode_amd_ops = {
> 	.request_microcode_user           = request_microcode_user,
> 	.request_microcode_fw             = request_microcode_fw,
> 	.collect_cpu_info                 = collect_cpu_info_amd,
> 	.apply_microcode                  = apply_microcode_amd,
> 	.microcode_fini_cpu               = microcode_fini_cpu_amd,
> };
>
> and reuse the ->request_microcode_fw, ->collect_cpu_info and
> ->microcode_fini_cpu on dom0 as if you're running on baremetal. Up
> to the point where you need to apply the microcode. Then, you use
> your supplied ->apply_microcode hypercall wrapper to call into the
> hypervisor.

collect_cpu_info can't work, because the domain doesn't have access to
all the host's physical CPUs.

However, even aside from that, it means exporting a pile of internal
details from microcode_amd and reusing them within microcode_xen.  And
it requires that it be done again for each vendor.

But all that's really needed is a dead simple "request" that loads the
entire file (with a vendor-specific name) and shoves it into Xen.  
There's no need for any vendor-specific code beyond the filename.


>> But all this is flawed because the microcode_intel/amd.c drivers assume
>> they can see all the CPUs present in the system, and load suitable
>> microcode for each specific one.  But a kernel in a Xen domain only has
>> virtual CPUs - not physical ones - and has no idea how to get
>> appropriate microcode data for all the physical CPUs in the system.
> Well, let me quote you:
>
> On Fri, Jan 28, 2011 at 04:26:52PM -0800, Jeremy Fitzhardinge wrote:
>> Xen update mechanism is uniform independent of the CPU type, but the
>> driver must know where to find the data file, which depends on the CPU
>> type. And since the update hypercall updates all CPUs, we only need to
>> execute it once on any CPU - but for simplicity it just runs it only
>> on (V)CPU 0.
> so you only do it once and exit early in the rest of the cases. I
> wouldn't worry about performance since ucode is applied only once upon
> boot.

Its not a performance question.  The Intel and AMD microcode drivers
parse the full blob loaded from userspace, and just extract the chunk
needed for each CPU.  It does this for each separate CPU, so in
principle you could have a mixture of models within one machine or
something (the driver certainly assumes that could happen; perhaps it
could on a larger multinode machine).

The point is that if it does this on (what the domain sees as ) "cpu 0",
then it may throw away microcode chunks needed for other CPUs.  That's
why we need to hand Xen the entire microcode file, and let the
hypervisor do the work of splitting it up and installing it on the CPUs.

> This is exactly what I'm talking about - why copy all that
> checking/filtering code from baremetal to Xen instead of simply reusing
> it? Especially if you'd need to update the copy from time to time when
> baremetal changes.

The code in the kernel is in the wrong place.  It has to be done in
Xen.  When Xen is present, the code in the kernel is redundant, not the
other way around.

>> CPU vendors test Xen, and Intel is particularly interested in getting
>> this microcode driver upstream.  The amount of duplicated code is
>> trivial, and the basic structure of the microcode updates doesn't seem
>> set to change.
> Uuh, I wouldn't bet on that though :).

Shrug.  AFAICT the mechanism hasn't changed since it was first
introduced.  If there's a change, then both Linux and Xen will have to
change, and most likely the same CPU vendor engineer will provide a
patch for both.  Xen has a good record for tracking new CPU features.

>> Since Xen has to have all sorts of other CPU-specific code which at
>> least somewhat overlaps with what's in the kernel a bit more doesn't
>> matter.
> Well, I'll let x86 people decide on that but last time I checked they
> opposed "if (xen)" sprinkling all over the place.

Eh?  I'm talking about code within Xen; it doesn't involve any if (xen)s
within the kernel.


> Btw, hpa has a point, if you can load microcode using multiboot, all
> that discussion will become moot since you'll be better at loading
> microcode even than baremetal. We need a similar mechanism in x86 too
> since the current one loads the microcode definitely too late.
>
> The optimal case for baremetal would be to load it as early as possible
> on each CPU's bootstrapping path and if you can do that in the
> hypervisor, before even dom0 starts, you're very much fine.

It is possible, but it requires that vendors install the microcode
updates in /boot and update the grub entries accordingly.  I'd prefer a
solution which works with current distros as-is.

    J
