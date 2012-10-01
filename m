Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2JASfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:35:55 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:58786 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab2JASfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:35:53 -0400
Date: Mon, 1 Oct 2012 12:35:43 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ARM] Use AT() in the linker script to create correct
 program headers
Message-ID: <20121001183543.GC22342@obsidianresearch.com>
References: <20120930232116.GC30637@obsidianresearch.com>
 <20121001153952.GB2100@linaro.org>
 <20121001160639.GA31620@obsidianresearch.com>
 <20121001175647.GD2100@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001175647.GD2100@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 06:56:47PM +0100, Dave Martin wrote:

> > > If the kernel is intended to be loadable at a physical address which is
> > > not statically known, no ELF loader that does not ignore the ELF
> > > phdr
> > 
> > In this case you can't really use a standard ELF loader to load the
> > kernel so, LOAD_OFFSET = 0 is fine. My case is using an ELF loader,
> > and I have set options for a static physical load address.
> 
> Generally, people should try to be compatible with the single kernel
> image effort unless there's a really compelling reason not to.

Well, all the embedded kernels we use are always custom built and
minimized for the target. So as long as there are options to minimize
the kernel size/increase performance by taking out the relocation
stuff, we are going to use them.

All our boards on PPC and ARM use DT kernels now, and we try to flow
back all the generic stuff as best we can. As someone that makes
custom boards, I really like DT, it makes things much easier :)

> Wouldn't your firmware be incapable of loading a multiplatform kernel?

Well, no, it boots ELFs, so it can boot anything, with any memory
layout. A 2nd stage loader would be required to boot standard kernels,
that loader would be an ELF with 1 section for the 2nd stage, 1
section for the zImage and 1 section for the initrd, with proper load
headers.

Creating such a system is a lot of annoyance, so we never have - it is
*so much* easier to just boot vmlinux ELF directly.

> Well, that was a bit of a pedantic point I admit, but there are
> conflicting definitions of what "virtual address" really means in these
> situations.  The original SYSV ABI spec explicitly specifies that
> e_entry is a virtual address, but is also rather vague about how the
> paddr fields should be interpreted.

Granted the spec is vauge, but convention for loaders seems to be that
it is a physical address these days.

It could be a virtual address, and the loader could translate it by
looking at the phdrs, but I don't see any other arches doing that?

> All that AT(ADDR(blah) - LOAD_OFFSET) stuff is cumbersome, but if it's
> at least consistent with other architectures then it may not such a
> disaster.  It's not universal though: less than 50% of the arches in
> the kernel currently seem to use this.

I agree it is not nice, but I once did try to make PHDRS work as you
described, but was never successful. IIRC there were serious linker
bugs) As you note the AT method is consistent with other arches, and
the generic vmlinux.lds.h

> > Yes, if you use more loader stages then the load headers are ignored.
> > Our boot loaders on our boards boot straight ELF vmlinux.gz so they
> > need correct load headers.
 
> If your image is compressed anyway though, why are you not using zImage?

We store the kernel in a CRAMFS, the loader pulls it out and
decompresses it, processes the ELF sections 'on the fly' and jumps to
it. Using zImage would result in double-decompression, and reallly has
no benefits to us.

Jason
