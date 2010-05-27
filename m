Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab0E0OMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:12:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55362 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab0E0OMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:12:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Date: Thu, 27 May 2010 16:11:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005271041.30519.arnd@arndb.de> <4BFE73DF.5090107@tilera.com>
In-Reply-To: <4BFE73DF.5090107@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005271611.47963.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX197LcCKC/bjuqG4wfkOpRQpdELiz690qBjeZ0t
 Lo5nn/giDS7xcnkLX3MiRphGYeVH2dOeLdLgSluk3pY1RrIiPQ
 Fbai5pguk5xyuPR7osOdQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Chris Metcalf wrote:
> On 5/27/2010 4:41 AM, Arnd Bergmann wrote:
> > Are you able to build 32 bit kernels for TILE-Gx as well? It's
> > probably something you never really want to do for performance
> > reasons, but I guess you could use that to verify that the
> > ABI is really compatible.
> >   
> 
> No, we haven't tried to do this.  I suppose it would be possible to port
> the TILE-Gx kernel to use -m32 mode and HIGHMEM, but I think it would
> just uglify the code.  :-)

Probably right, yes.

> >> The notion of using a file descriptor as the "rights" object is pretty
> >> central, so I think a character device will work out well.
> >>     
> > ok, I see. Now you could easily do this with system calls as well:
> > Instead of the initial ioctl that associates the file descriptor
> > with a rectangle, you can have a syscall that creates a rectangle
> > and a file descriptor (using anon_inode_getfd) associated with it,
> > and returns the fd to user space. This is similar to what we
> > do for other system call interfaces that operate on their own fds.
> >   
> 
> Yes, good point.  I'll be holding back this code from the initial patch,
> so I can think about it some more.  I'm still predisposed to avoid
> adding system calls in general, though.

Well, adding chardevs just for the sake of doing ioctl in place of
a syscall is no better than adding the real syscall for something that
should be one.
It has all the disadvantages of new syscalls but does it in a sneaky way.

> >> I'll try to remove them and see if anything falls over.  We don't have
> >> any memory-mapped addresses in the 32-bit architecture, though that
> >> changes with the 64-bit architecture, which introduces IO mappings.  For
> >> PCI we actually have to do a hypervisor transaction for reads or writes.
> >>     
> > Ok, then I assume that PIO would also be a hypervisor call, right?
> > If you don't have MMIO on 32 bit, you might want to not define either
> > PIO (inb, ...) no MMIO (readb, ...) calls there and disable
> > CONFIG_HAVE_MMIO in Kconfig.
> >   
> 
> We don't define CONFIG_HAVE_MMIO, but drivers certainly seem to use
> ioread/iowrite methods as well as inb/outb without guarding them with
> any particular tests, so we have to provide definitions of some kind for
> all of them.  I'll confer with our PCI developer to see if we can clean
> up the set of definitions in io.h.

As Geert mentioned, I meant CONFIG_HAS_IOMEM. If that is disabled,
no code should ever call any of these functions.

> >> Hmm, I didn't know about that.  Any information would be appreciated.  I
> >> guess you could synthesize something that looked like a signal purely in
> >> user-space?  But how would debuggers trap it?  I'm not sure how it would
> >> work without a system call.
> >>     
> > I think the C99 standard allows you to not implement SIGFPE at all but
> > instead rely on applications doing fetestexcept() etc.
> >   
> 
> We use this not for the floating-point operations, but for integer
> divide-by-zero.  In principle we could use it for floating-point too,
> but we currently don't, since generally folks don't expect it there.

Ah, I see. That probably makes a lot of sense to present as a signal
the way you do.

> >> Except they're also used by the 32-bit platform where there is no compat
> >> mode (the compat code DOES use them too, it's true).
> >>     
> > I see. AFAICT, all other architectures don't need the wrapper in
> > the 32 bit native case because they define the syscall calling
> > conventions in libc such that they match what the kernel
> > expects for a 64 bit argument (typically split in two subsequent
> > argument slots). Would that work for you as well?
> >   
> 
> Yes, we could override this in libc.  My assumption was that it was
> cleaner to do it in the kernel, since we support uclibc and glibc, and
> doing it in the kernel meant only doing it in one place.

That's not the way I meant. There are two options how (any) libc can
implement this:
1. the calling conventions for user function calls and for kernel
   function calls are the same, so you don't need to do anything here.
2. the calling conventions are different, so you already need a wrapper
   in user space for 64 bit arguments to split them up and you could
   to that in exactly the way that the kernel expects to be called.

> >> I'll think about it.  These are both basically disassembly-related, so
> >> maybe an arch/tile/disasm directory with the tile_desc stuff and the
> >> backtracer?  I'm not sure it's really worth moving out of
> >> arch/tile/kernel though.
> >>     
> > Ok. If you leave them in the directory, just split them out into a separate
> > patch on your next submission then.
> >   
> 
> Does this imply separate git commits to our repository, if we want to do
> things the Right Way?  I always tend to try to commit things in such a
> way that everything is always buildable between each commit, and I can't
> easily pull out the disassembly-related files from the kernel.  On the
> other hand I can easily split up a single bit GIT commit-patch into
> multiple emails, but then of course it wouldn't apply easily to a "git
> am".  Guidance??  :-)

You're right that any commit should result in something that's buildable.
In this case I think you can make an exception because before the first
patch, nothing builds in arch/tile, so you extend that phase to two
or three patches before you get to the first one that's actually
compilable.

	Arnd
