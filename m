Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab1A3LeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 06:34:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53300 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab1A3LeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 06:34:05 -0500
Date: Sun, 30 Jan 2011 12:33:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20110130113356.GA27967@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	the arch/x86 maintainers <x86@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Xen Devel <Xen-devel@lists.xensource.com>,
	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 04:26:52PM -0800, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Hi all,
> 
> I'm proposing this for 2.6.39.
> 
> This series adds a new "Xen" microcode update type, in addition to
> Intel and AMD.
> 
> The Xen hypervisor is responsible for performing the actual microcode
> update (since only it knows what physical CPUs are in the system and
> has sufficient privilege to access them), but it requires the dom0
> kernel to provide the actual microcode update data.
> 
> Xen update mechanism is uniform independent of the CPU type, but the
> driver must know where to find the data file, which depends on the CPU
> type.  And since the update hypercall updates all CPUs, we only need
> to execute it once on any CPU - but for simplicity it just runs it only
> on (V)CPU 0.

I don't like this for several reasons:

- ucode should be loaded as early as possible and the perfect place
for that should be the hypervisor and not the dom0 kernel. But I'm not
that familiar with xen design and I guess it would be pretty hard to
do. (Btw, x86 bare metal could also try to improve the situation there
but that's also hard due to the design of the firmware loader (needs
userspace)).

- you're adding a microcode_xen.c as if this is another hw vendor and
you're figuring out which is the proper firmware image based on the
vendor, then you load it and then do the hypercall. This is duplicating
code and inviting future bugs. Everytime the hw vendors decide to change
something to their fw loading mechanism, xen needs to be updated. Also,
you don't do any sanity checks to the ucode image as the vendor code
does which is inacceptable.

What it should do instead, is call into the hw vendor-specific ucode
loading mechanism and do all the image loading/verification there. The
only thing you'd need to supply is a xen-specific ->apply_microcode()
doing the hypercall _after_ the ucode image has been verified and is
good to go. I'm guessing the XENPF_microcode_update does call into the
hypervisor and calls a xen-specific ucode update mechanism based on the
vendor instead of using the vendor-supplied code...

Thanks.

-- 
Regards/Gruss,
    Boris.
