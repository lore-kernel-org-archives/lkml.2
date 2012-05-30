Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2E3QgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 12:36:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42199 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab2E3QgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 12:36:13 -0400
Date: Wed, 30 May 2012 17:36:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
Message-ID: <20120530163605.GV11775@ZenIV.linux.org.uk>
References: <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
 <1337112446.20904.50.camel@falcor>
 <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
 <20120516004251.GO22082@ZenIV.linux.org.uk>
 <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
 <20120516021828.GP22082@ZenIV.linux.org.uk>
 <1337807899.15138.31.camel@falcor>
 <20120530043443.GA3200@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530043443.GA3200@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 05:34:43AM +0100, Al Viro wrote:
> On Wed, May 23, 2012 at 05:18:19PM -0400, Mimi Zohar wrote:
> 
> > > 2) get_unmapped_area() probably ought to grow such a caller and
> > > I really suspect that it would've killed quite a few of them.
> > 
> > ?
> 
> This belong at the same level as arch_mmap_check().  We insist on not
> having VMAs with address range that has certain properties.  E.g. extends
> beyond the maximal user process address (TASK_SIZE, all architectures),
> overlaps a range forbidden by MMU (like on sparc boxen) *or* page at
> fixed address that must not be unmapped (e.g. page 0 at old arm systems,
> with their "IRQ vectors live at fixed small virtual address" lossage).
> Or hugepage VMA in range where huge pages are not allowed.  Or page 0
> on systems where it's forbidden by security policy.  Same kind of
> restriction, as far as the rest of the system is concerned.
> 
> The obvious place for enforcing such restrictions is get_unmapped_area().
> That's what produces such VMA address ranges and validates ones that
> are explicitly given by userland (when called with MAP_FIXED).

BTW, here's what we have for callers of get_unmapped_area():
[hexagon,mips,powerpc,s390,sh,x86] arch_setup_additional_pages() - passes to
install_special_mapping(), where we'll feed it to that check.
[x86] setup_additional_pages() - ditto.
[uprobes] xol_add_vma() - ditto.
sys_mremap() - we explicitly call security_file_mmap() just downstream from
that call.
mremap_to() - we have called security_file_mmap() a bit earlier; might as
well fold it into get_unmapped_area(); note that we are calling it with
MAP_FIXED here, so get_unmapped_area() can't change the address, just accept
or reject it.
do_brk() - ditto.
do_mmap_pgoff() - we have security_file_mmap() (with non-NULL file, this
time) done shortly after get_unmapped_area()
vma_expandable() - on this codepath we don't do check, since starting
address can't change here.  Might as well have done it, though.
[ia64 perfmon] a pointless wrapper around get_unmapped_area(); incidentally,
it gets calling conventions wrong - get_unmapped_area() return -E... on
failure, not 0.  No check made, and AFAICS it's a bug.  I've fixed the
calling conventions there (see vfs.git#for-next tip).

So we have one caller of get_unmapped_area() that legitimately doesn't have
the return value fed through security_file_mmap().  And that's expanding
mremap() trying to decide if it's allowed to grow an old vma in place.
Not the hottest path in the kernel, that...

As far as I'm concerned, the sane plan here would be
	* split the damn hook into file-related and address-related parts.
	* take the former outside - up from do_mmap_pgoff(), through
do_mmap() into vm_mmap()/do_shmat() and into sys_mmap_pgoff().  Caller of
do_mmap() in fs/aio.c doesn't need that - we have file == NULL there.
That's 5 callers, 3 on MMU side of things and 2 on !MMU.
	* take the latter into get_unmapped_area() (on success exits).
As for the existing callers:
		one in __bprm_mm_init() can go
		what's left of the callers in do_mmap_pgoff() and !MMU
validate_mmap_request() can go (we'd taken all file-related checks upstream
and we'd done get_unmapped_area() already)
		one in expand_downwards() should stay
		ones in mremap_to(), sys_mremap() and do_brk() can go -
get_unmapped_area() nearby takes care of that
		one in install_special_mapping() can go; most of the
callers of that one have address coming out of get_unmapped_area() and
the rest (tile and uml/x86 arch_setup_additional_pages(), uml_setup_stubs(),
unicore32 vectors_user_mapping(), compat && !compat_uses_vdso case in
x86 arch_setup_additional_pages()) are passing a fixed address in there and
any security policy wishing to deny that can just as well refuse to boot -
same effect.  Incidentally, unicore32 probably should do an analog of
commit f9d4861 (ARM: 7294/1: vectors: use gate_vma for vectors user mapping)
and stop playing with install_special_mapping() completely.
	* probably take arch_mmap_check() into expand_downwards(); we don't
want a full-blow get_unmapped_area() there (it's a fairly hot path and most
of get_unmapped_area() would be redundant here, even with MAP_FIXED), but
arch_mmap_check() would probably be more in place here than in the callers
of expand_stack().

The only question is what do we want passed to resulting two hooks.  LSM
folks?
