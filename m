Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab0EXVbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 17:31:04 -0400
Received: from king.tilera.com ([72.1.168.226]:47865 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab0EXVbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 17:31:00 -0400
Message-ID: <4BFAF012.4060300@tilera.com>
Date: Mon, 24 May 2010 17:30:58 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <20100524202204.GA9917@merkur.ravnborg.org>
In-Reply-To: <20100524202204.GA9917@merkur.ravnborg.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2010 21:30:59.0726 (UTC) FILETIME=[671872E0:01CAFB88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/2010 4:22 PM, Sam Ravnborg wrote:
> Kernle code looked good from a quick browsing.
>   

Glad to hear it, and thanks for taking the time to look it over.

> Please explain the need for all the different directories within include/
> {arch, hv, netio}
>   

Those three directories are shared with other components of our system. 
The "arch" headers are "core architecture" headers which can be used in
any build environment (Linux, hypervisor, user-code, booter, other
"supervisors" like VxWorks, etc.); they are partly small inline hacks to
use the hardware more easily, and partly just lists of name-to-number
mappings for special registers, etc.  The "hv" headers are imported from
the hypervisor code; these headers are "owned" by our hypervisor, and
the ones shipped with Linux are the ones that have to do with how to run
a supervisor under our hypervisor.  The "netio" headers are another type
of hypervisor header that have to do with interacting with the network
I/O silicon on the chip (the 10 Gbe and 10/100/100 Mb Ethernet).

> There is also several TILE specific options missing the TILE_ prefix.
> Like:
> config XGBE_MAIN
> 	tristate "Tilera GBE/XGBE character device support"
>
> Drop this:
> config XGBE_MAIN
> 	tristate "Tilera GBE/XGBE character device support"
>
> It is better to test for the gcc version and disable the option
> only in the cases where it is known to fail.
>   

Is the "Drop this" comment a cut and paste bug?  I'm guessing you were
referring to CONFIG_WERROR, which enables -Werror support.  The problem
is that whether or not you can use -Werror really depends on not just
the kernel version and the gcc version, but very likely also what
drivers you have enabled.  We always use it internally.  I could also
just pull this out completely (and just force it into "make" externally
within our external build process), or move it to a "generic" configure
option.  In any case we can't just automate it, unfortunately.

> Do not mess with CC like this:
> CC = $(CROSS_COMPILE)gcc
>
> I guess you had to do this to support:
> LIBGCC_PATH     := `$(CC) -print-libgcc-file-name`
>
> If you follow other archs you could do like this:
> LIBGCC_PATH     := `$(CC) -print-libgcc-file-name`
>   

I'm guessing you meant like what h8300 does, "$(shell
$(CROSS-COMPILE)$(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)".  That
seems reasonable.

> arch/tile/kernel/Makefile
> I has expected that compiling vmlinux.lds required knowledge on $(BITS)
> like this:
> CPPFLAGS_vmlinux.lds := -m$(BITS)
>   

Our 32-bit chips only do 32-bit.  In the 64-bit mode we always build the
kernel implicitly -m64, which is the compiler default.

> arch/tile/kernel/vmlinux.lds.S
> A lot of effort has been put into unifying the different
> variants of vmlinux.lds.
> Please see the skeleton outlined in include/asm-generic/vmlinux.lds.h
>   

Yes, I've tried to track this somewhat over kernel releases, but I'll go
back and re-examine it with fresh eyes.

> You include hvglue.ld.
> We use *.lds for linker script file - please rename.
> The file looks generated?? How and when?
>   

It's sort of a semi-generated file.  We have a test in our regressions
that just tests that this file matches the API for our hypervisor, which
is just calls to physical address =32KB plus 64 bytes per syscall
number.  These defined addresses are then used for calls to e.g.
hv_flush_asid() or whatever.  The hypervisor API changes occasionally,
at which point we update this file.  You don't see it used in
vmlinux.lds since it's just used as plain C calls through the arch/tile/
code.

> arch/tile/initramfs:
> Does not look like it belongs in the kernel?
>   

Fair enough.  We ship it with the kernel to make it easy for our users
to bootstrap up into a plausible initramfs filesystem, but it's strictly
speaking not part of the kernel, so I'll remove it.

> arch/tile/include/asm/spinlock.h
> Please make this a one-liner when you uses the asm-generic version only.
> Same goes for byteorder (which includes linux/byteorder/little_endian.h)
>   

I'm not sure what you mean when you say to use the asm-generic version
of spinlock.h, since it's not SMP-ready.  Also, I don't see an
asm-generic/byteorder.h, so I'm puzzled there too.

> In your mail you did not say anything about the checkpatch status.
> It is better that you make your code reasonable checkpatch clean _before_
> merging. Then you will not be hit by a lot of janitorial patches doing so.
>   

I ran checkpatch over everything I submitted.  There are many
complaints, to be sure, but I did a first pass cleaning up everything
that was plausible, so for example all the style issues were fixed, but
things like some uses of volatile, some uses of init_MUTEX, etc., were
not modified.  However, I think it's in decent shape from a checkpatch
point of view.

> Likewise please state sparse status. We do not expect it to be sparse clean.
> But getting rid of the obvious issues is good too.
>   

I have not run sparse over it.  I will do so.

Thanks for your review!  Getting this much feedback from LKML is great
-- I really appreciate it.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


