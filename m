Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab1AaSRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:17:09 -0500
Received: from claw.goop.org ([74.207.240.146]:40521 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab1AaSRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:17:08 -0500
Message-ID: <4D46FC9F.6090309@goop.org>
Date: Mon, 31 Jan 2011 10:17:03 -0800
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
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com> <20110130113356.GA27967@liondog.tnic> <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic>
In-Reply-To: <20110131070241.GA22071@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2011 11:02 PM, Borislav Petkov wrote:
>> Well, I was trying to avoid putting Xen-specific code into the existing
>> Intel/AMD loaders.  That doesn't seem any cleaner.
>>
>> I could export "my firmware pathname" functions from them and have the
>> Xen driver call those, rather than duplicating the pathname construction
>> code.  Would that help address your concerns?
> Well, I was thinking even more radically than that. How about
>
> 1. microcode_xen.c figures out which struct microcode_ops to use based
> on the hw vendor;
>
> 2. overwrites the ->apply_microcode ptr with the hypercall wrapper
>
> 3. dom0 uses it to load the firmware image and do all checks to it

That could be made to work, but I don't really see it as being an
improvement.  The whole "overwriting bits of other people's ops
structures" thing seems like a pretty bad idea for long term
maintainability.

> 4. eventually, the hypervisor gets to apply the _verified_ microcode
> image (no more checks needed) using the vendor-specific application
> method.
>
> This way there's almost no code duplication, you'll be reusing the
> vendor-supplied code in baremetal which gets tested and updated
> everytime it needs to and will save you a bunch of work everytime
> there's change to it needed to replicate it into the hypervisor.

In general Xen tries to avoid trusting its domains.  Admittedly, dom0 is
special in that it is already somewhat trusted, but even dom0 is
constrained by Xen.  For microcode, Xen just depends on it to provide a
best-possible microcode file, then Xen+the CPU do the work of fully
validating it and installing it.

> Btw, if the code within the hypervisor is similar to the kernel's, you
> could even save the original ->apply_microcode() pointer from step 2 and
> call it in the hypervisor when the XENPF_microcode_update hypercall op
> gets called. This way you have 0 code duplication.

The hypervisor and its domains are completely separate pieces of code. 
This is akin to suggesting the kernel directly jump through a pointer
and to run some usermode code.

    J
