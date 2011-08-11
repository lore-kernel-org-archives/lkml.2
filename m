Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1HKOFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:05:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51368 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1HKOFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:05:32 -0400
Date: Thu, 11 Aug 2011 15:05:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Arnaud Lacombe <lacombar@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not
 SUBARCH_i386
Message-ID: <20110811140528.GR2203@ZenIV.linux.org.uk>
References: <20110731225801.GD2203@ZenIV.linux.org.uk>
 <1312153988.18010.39.camel@i7.infradead.org>
 <CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
 <20110801043207.GE2203@ZenIV.linux.org.uk>
 <CAFLxGvwxQ2VeqkDpkiVks35DHxZFvAP5nKUtD7i4Z32291otOg@mail.gmail.com>
 <20110809233817.GL2203@ZenIV.linux.org.uk>
 <20110810040445.GM2203@ZenIV.linux.org.uk>
 <20110810174432.GN2203@ZenIV.linux.org.uk>
 <20110811042319.GP2203@ZenIV.linux.org.uk>
 <CAFLxGvwE8FGcRtY6v=6jqatZEUwvbBc0ki43jiTYsUp9e_uiAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvwE8FGcRtY6v=6jqatZEUwvbBc0ki43jiTYsUp9e_uiAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 02:13:22PM +0200, richard -rw- weinberger wrote:

> Sorry for the delay.
> Writing my theses consumes a lot of my time...
> 
> I've already started reviewing and testing your changes.
> Currently they life in my local git repo.
> But a git.kernel.org repo is on the way!
> 
> Later I'll submit all changes to akpm.

OK...  It does end up in linux-next, so...  OTOH, why not send direct pull
requests to Linus?

Speaking of more fun in there:
	* coredumps do not contain fp registers; fixable by switching to
what x86 is doing (CORE_DUMP_USE_REGSET and corresponding bits in uml-x86
ptrace.c - arch/x86/um/ptrace*.c in this tree, arch/um/sys-*/ptrace.c in
mainline)
	* more drivers/{lin,chan*}.c races ;-/  Protecting setup_one_line()
from being done on opened ones is nice, but we are really not safe until
parse_chan_pair() has been finished...  I've partial fixes, but it's not
quite trivial.
	* fixrange_init() assumes that start and end are both multiples of
PMD_SIZE, which is not true, to put it mildly.  Wraparounds are possible
there - e.g. I've seen it called with 0xfffe000/0xffff000 for 32bit UML
running on amd64 host.  Not pretty, since vaddr < end will always remain
true when called that way.  With 3-level pagetables it gets really ugly -
it's nowhere near the end of upper-level table yet, so i < PTRS_PER_PGD
also doesn't stop the sucker.  I think the right solution here is to shift
vaddr down by PMD_SHIFT and do the same to end (taking care of fencepost
errors, of course).
	* no biarch support; that one might be really painful to implement,
but if we want it on something like ppc64 or sparc64 where the userland
is routinely 32bit...  That's going to be really rough on mm-switching
variants, BTW - when kernel address space is 64bit one and userland ones
are 32bit... <shudder>

	Anyway, I'm back to pure VFS work for the next few weeks.  I'll
probably dump fixrange_init() fixes into this tree, but anything beyond
that will have to wait until I dig myself out of atomic_open work and
unionfs/overlayfs/aufs/whatnot mess...
