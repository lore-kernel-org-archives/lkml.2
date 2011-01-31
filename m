Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1AaXli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:41:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40621 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104Ab1AaXlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:41:37 -0500
Date: Tue, 1 Feb 2011 00:41:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20110131234131.GA16095@liondog.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D46FC9F.6090309@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 10:17:03AM -0800, Jeremy Fitzhardinge wrote:
> On 01/30/2011 11:02 PM, Borislav Petkov wrote:
> >> Well, I was trying to avoid putting Xen-specific code into the existing
> >> Intel/AMD loaders.  That doesn't seem any cleaner.
> >>
> >> I could export "my firmware pathname" functions from them and have the
> >> Xen driver call those, rather than duplicating the pathname construction
> >> code.  Would that help address your concerns?
> > Well, I was thinking even more radically than that. How about
> >
> > 1. microcode_xen.c figures out which struct microcode_ops to use based
> > on the hw vendor;
> >
> > 2. overwrites the ->apply_microcode ptr with the hypercall wrapper
> >
> > 3. dom0 uses it to load the firmware image and do all checks to it
> 
> That could be made to work, but I don't really see it as being an
> improvement.

WTF? How is

* almost no code duplication
* not adding Xen-specific checks to generic arch code
* relying on already tested codepaths

not an improvement?

> The whole "overwriting bits of other people's ops structures" thing
> seems like a pretty bad idea for long term maintainability.

I don't think that's an issue: you either load microcode_xen in dom0
(x)or the respective vendor driver on baremetal.

> > 4. eventually, the hypervisor gets to apply the _verified_ microcode
> > image (no more checks needed) using the vendor-specific application
> > method.
> >
> > This way there's almost no code duplication, you'll be reusing the
> > vendor-supplied code in baremetal which gets tested and updated
> > everytime it needs to and will save you a bunch of work everytime
> > there's change to it needed to replicate it into the hypervisor.
> 
> In general Xen tries to avoid trusting its domains.  Admittedly, dom0 is
> special in that it is already somewhat trusted, but even dom0 is
> constrained by Xen.  For microcode, Xen just depends on it to provide a
> best-possible microcode file, then Xen+the CPU do the work of fully
> validating it and installing it.

Well, the CPU doesn't trust the microcode provided by the software
either. And why should it?

All I'm saying is, you should try as best as possible to avoid code
duplication and the need for replicating functionality to Xen, thus
doubling - even multiplying - the effort for coding/testing baremetal
and then Xen. Microcode is a perfect example since the vendors do all
their testing/verification on baremetal anyway and the rest should
benefit from that work.

Thanks.

-- 
Regards/Gruss,
    Boris.
