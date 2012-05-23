Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2EWVT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:19:27 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39301 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab2EWVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:19:23 -0400
Message-ID: <1337807899.15138.31.camel@falcor>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 17:18:19 -0400
In-Reply-To: <20120516021828.GP22082@ZenIV.linux.org.uk>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
	 <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
	 <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
	 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
	 <1337112446.20904.50.camel@falcor>
	 <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
	 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
	 <20120516004251.GO22082@ZenIV.linux.org.uk>
	 <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
	 <20120516021828.GP22082@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052321-2398-0000-0000-000006E3D9E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 03:18 +0100, Al Viro wrote:
> On Tue, May 15, 2012 at 05:45:44PM -0700, Linus Torvalds wrote:
> > On Tue, May 15, 2012 at 5:42 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >

> Frankly, I would split it in two - one introducing security_mmap_addr()
> and converting the callers, and another doing the rest of it.

Ok, I split the patch. Hopefully it is bisect safe. The results of which
are available from
git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity
#next-vfs-changes.  But before posting them, I'd like to understand what
should be done regarding the issues you raised.

> Said that, I'm not sure I like the resulting picture.
> 
> 1) caller in __bprm_mm_init() is simply ridiculous - note that
> arguments are bleeding *constants*, so it might very well have
> been a BUG_ON().  If it fails, you'll have every execve() fail.

ok, checking the addr based on the same constants doesn't make sense.
Replace it with a BUG_ON() as you suggested?

> 2) get_unmapped_area() probably ought to grow such a caller and
> I really suspect that it would've killed quite a few of them.

?

> 3) expand_downwards() seems to be missing the basic sanity checks on the
> validity of VMA range (arch_mmap_check(), that is).  itanic opencodes
> the equivalent before calling expand_stack(); arm and mn10300 do not
> bother, which might or might not be legitimate - depends on whether
> one can get a fault in the first page *and* reach the check_stack:
> in e.g. arm __do_page_fault().  Which just might be possible, if attacker
> maps something just above said first page with MAP_GROWSDOWN and
> tries to write at very small address - IIRC, the first page on arm
> contains the stuff that shouldn't be world-writable...  s390 doesn't
> care and I'm not sure about sparc32/sparc64 - it looks like that shouldn't
> be possible to hit, but...

?

> 4) i810_dma.c ought to be switched to vm_mmap() - as discussed in that
> thread back then, magical mystery wank with ->f_op reassignments does
> not rely on ->mmap_sem for protection and thus can be taken out of
> under ->mmap_sem.

Ok, replacing the do_mmap() with vm_mmap() would be a separate patch,
but it still leaves the existing f_op reassignment with locking issues.

thanks,

Mimi

