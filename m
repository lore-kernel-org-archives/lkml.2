Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab2E3Ee5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 00:34:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39282 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2E3Eez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 00:34:55 -0400
Date: Wed, 30 May 2012 05:34:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
Message-ID: <20120530043443.GA3200@ZenIV.linux.org.uk>
References: <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
 <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
 <1337112446.20904.50.camel@falcor>
 <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
 <20120516004251.GO22082@ZenIV.linux.org.uk>
 <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
 <20120516021828.GP22082@ZenIV.linux.org.uk>
 <1337807899.15138.31.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337807899.15138.31.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 05:18:19PM -0400, Mimi Zohar wrote:

> > 2) get_unmapped_area() probably ought to grow such a caller and
> > I really suspect that it would've killed quite a few of them.
> 
> ?

This belong at the same level as arch_mmap_check().  We insist on not
having VMAs with address range that has certain properties.  E.g. extends
beyond the maximal user process address (TASK_SIZE, all architectures),
overlaps a range forbidden by MMU (like on sparc boxen) *or* page at
fixed address that must not be unmapped (e.g. page 0 at old arm systems,
with their "IRQ vectors live at fixed small virtual address" lossage).
Or hugepage VMA in range where huge pages are not allowed.  Or page 0
on systems where it's forbidden by security policy.  Same kind of
restriction, as far as the rest of the system is concerned.

The obvious place for enforcing such restrictions is get_unmapped_area().
That's what produces such VMA address ranges and validates ones that
are explicitly given by userland (when called with MAP_FIXED).

> > 3) expand_downwards() seems to be missing the basic sanity checks on the
> > validity of VMA range (arch_mmap_check(), that is).  itanic opencodes
> > the equivalent before calling expand_stack(); arm and mn10300 do not
> > bother, which might or might not be legitimate - depends on whether
> > one can get a fault in the first page *and* reach the check_stack:
> > in e.g. arm __do_page_fault().  Which just might be possible, if attacker
> > maps something just above said first page with MAP_GROWSDOWN and
> > tries to write at very small address - IIRC, the first page on arm
> > contains the stuff that shouldn't be world-writable...  s390 doesn't
> > care and I'm not sure about sparc32/sparc64 - it looks like that shouldn't
> > be possible to hit, but...
> 
> ?

Any place that does this check without the rest of restriction enforcement
is very suspicious.  expand_downwards() is one such place.  I'm not saying
that we need a full-blown get_unmapped_area() in there, but we *do* want
arch_mmap_check().  Itanic does it in caller of expand_stack() (which is
where expand_downwards() come from).  So does arm, now that rmk has fixed
the bug there.  The rest either has arch_mmap_check() returning "no special
restrictions for this architecture" or seems to be guaranteed that if an
area used to satisfy those restrictions then extending its lower end towards
0 can't violate them.  Probably.  Frankly, I would rather just do
arch_mmap_check() in expand_downwards() (and remove it from callers in
arch/{arm,ia64}).  Dumber is better in this case...

Another place is __bprm_mm_init() and there the check doesn't make any sense.

Yet another is install_special_mapping().  And I do not believe that the
check is needed there either.  Address comes either from get_unmapped_area()
(and that's where the checks should be done) or it's cast in stone (e.g.
unicore32 with special vma for its IRQ vectors, fixed at virtual address
0xffff000 and if somebody doesn't like a page being there (r/o, etc.), they
can take that with hardware designers; the damn thing will be there, or the
box won't work).

And the rest of security_file_mmap() callers has the address come through
get_unmapped_area(), AFAICS.  It would bloody better, because otherwise
we are very likely to have a serious hole on a bunch of architectures...
